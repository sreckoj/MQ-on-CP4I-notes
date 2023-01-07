
# MQ-IPT


IBM MQ Internet Pass-Thru (MQIPT) is an extension to the base IBM MQ product. MQIPT runs as a stand-alone service that can receive and forward IBM MQ message flows, either between two IBM MQ queue managers or between an IBM MQ client and an IBM MQ queue manager. MQIPT enables this connection when the client and server are not on the same physical network.

The following chapter in the documentation describes the IPT configuration:
https://www.ibm.com/docs/en/ibm-mq/9.3?topic=configuring-mq-internet-pass-thru

It is possible to run MQIPT in a container. Please follow the instructions in [IBM MQ Internet Pass-Thru on Docker](https://github.com/ibm-messaging/mq-container/tree/master/incubating/mqipt) to build and run it. 

## Running on OpenShift

The article mentioned above explains how to run the MQIPT in a standalone container. We will try to do the same in OpenShift. 

The command for running the container was the following:
```
docker run -d --volume <path to config>:/var/mqipt -p 1414:1414 mqipt
```

When running on OpenShift (or any other implementation of Kubernetes) we have to replace this command with a Deployment object that defines the image used, the ports, and the volume mounting for the running pod. Before that, we have to push the built container image to some registry available to the pod when it starts the container. Instead of mounting the directory from the local file system the most appropriate way would be to store the IPT configuration file in the ConfigMap object and then mount this object to the directory inside the container.

We will create an image that is slightly different from the one defined in the original Dockerfile. The reason for that is the way how the home directory (*/var/mqipt*) is provided. This directory contains the configuration file (*mqipt.conf*) and at the same time serves as the workspace directory where the logs and error messages are stored. When running an image locally, as described in the referenced article, the directory on the local file system is mounted to the directory inside the container. It can therefore serve both purposes. When running on the OpenShift we want to provide the configuration file as a ConfigMap. But, if we mount the ConfigMap to the directory inside the container we will not be able to create logs and error files on this directory. One of the possible solutions for that is to mount ConfigMap to a temporary directory (*/tmp/mqipt*) and then create a symbolic link in the home directory (*/var/mqipt*) that points to the configuration file (*mqipt.conf*) in this temporary directory. The code that follows is self-explanatory.

We will push the image to the OpenShift internal registry, the alternative is to use any external registry like Artifactory or Quay instead

Let's start:

- Download the MQIPT tar file: <br>
  As per the document https://www.ibm.com/support/pages/ms81-ibm-mq-internet-pass-thru the SupportPac MS81 can be now downloaded from the [FixCentral](https://www.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~WebSphere&product=ibm/WebSphere/WebSphere+MQ&release=9.3.0.0&platform=All&function=fixid&fixids=*IBM-MQIPT*). For this exercise we downloaded the file **9.3.1.0-IBM-MQIPT-LinuxX64.tar.gz** which was the latest version at that moment.

- Create file  **startMQIPT.sh** with the script that serves as a container entry point (same as in the original example):
  ```sh
  #!/bin/bash
  # -*- mode: sh -*-
  # © Copyright IBM Corporation 2018
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  #
  # http://www.apache.org/licenses/LICENSE-2.0
  #
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.
  stop()
  {
      /opt/mqipt/bin/mqiptAdmin -stop
  }

  trap stop SIGTERM SIGINT
  # Run MQIPT and then wait on the process to end.
  /opt/mqipt/bin/mqipt /var/mqipt &
  MQIPTPROCESS=$!

  wait "$MQIPTPROCESS"    
  ```

- Make the script executable
  ```sh
  chmod 755 startMQIPT.sh
  ```  

- Create **Dockerfile** (like explained above, slightly different that the original)
  Note also that the tar file is also different. We use here the newer version downloaded before:
  ```Dockerfile
  FROM ibmcom/ibmjava:jre
  ARG IPTFILE=9.3.1.0-IBM-MQIPT-LinuxX64.tar.gz
  COPY $IPTFILE /opt/
  RUN rm -rf /var/lib/apt/lists/* \
    && cd /opt/ \
    && tar xvf ./$IPTFILE \
    && chmod -R a-w /opt/mqipt \
    && mkdir -p /var/mqipt/logs \
    && mkdir -p /var/mqipt/errors \
    && chmod 777 /var/mqipt \
    && chmod 777 /var/mqipt/logs \
    && chmod 777 /var/mqipt/errors \      
    && mkdir -p /tmp/mqipt \
    && ln -s /tmp/mqipt/mqipt.conf /var/mqipt/mqipt.conf
  ENV MQIPT_PATH=/opt/mqipt
  COPY startMQIPT.sh /usr/local/bin
  ENTRYPOINT ["startMQIPT.sh"]    
  ```

- Create the config file **mqipt.conf** <br> 
  *This is just an example - it does not really do anything useful. Please adapt it to serve your needs. There is also a sample configuration file available in the samples directory in IPT tar.*
  ```
  [global]
  ClientAccess=true
  IdleTimeout=20
  [route]
  ListenerPort=1815
  Destination=qmgr1.example.com
  DestinationPort=1414
  ```  

- Build the image (we are using the *podman* here, but you can equally use the *docker* CLI):
  ```
  podman build -t mqipt .
  ```    

- Test image locally:
  ```
  podman run --rm --volume $(pwd):/tmp/mqipt -p 1414:1414 mqipt
  ```
  Press Ctrl+C to stop the container
  >Note:
  >The above command uses *--rm* which removes container after xist.
  >To run the container in the background (detach mode) use the option *-d*
  >For example, `podman run -d --volume $(pwd):/tmp/mqipt -p 1414:1414 mqipt`
  >To enter "into" the container and check the content run:
  >```
  >podman exec -it <container_name> bash
  >```

- Login to OpenShift and create new project
  ```
  oc new-project mqipt
  ```

- Get the registry URL
  ```
  oc registry info
  ```  
  In our test environment, we got the following:
  ```
  default-route-openshift-image-registry.apps.ocp410.tec.uk.ibm.com
  ```

- Login to the internal registry
  ```
  podman login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp410.tec.uk.ibm.com --tls-verify=false
  ```

- Tag the image
  ```
  podman tag mqipt:latest default-route-openshift-image-registry.apps.ocp410.tec.uk.ibm.com/mqipt/mqipt:1.0
  ```

- Push the image
  ```
  podman push default-route-openshift-image-registry.apps.ocp410.tec.uk.ibm.com/mqipt/mqipt:1.0 --tls-verify=false
  ```

- Verify the image in the internal registry using the OpenShift web console. In the left navigation panel select **Builds > Image Streams**. Select the project: **mqipt**. Click on the image stream **mqipt** and you should find on the page the following internal repository name: 
  ```
  image-registry.openshift-image-registry.svc:5000/mqipt/mqipt
  ```

- Create a config map from the **mqipt.conf** file:
  ```
  oc create configmap --save-config mqipt-conf --from-file=mqipt-conf=./mqipt.conf 
  ```  

- Prepare Deployment object. It uses a previously prepared image and mounts ConfigMap to the container's internal directory. You can store the content in the file and run *oc apply* command or use the *(+)* command from the OpenShift web console toolbar. When Deployment is applied check that the pod has started without errors: 
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: mqipt
    namespace: mqipt
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: mq-ipt
    template:
      metadata:
        labels:
          app: mq-ipt
      spec:
        containers:
        - image: image-registry.openshift-image-registry.svc:5000/mqipt/mqipt:1.0
          imagePullPolicy: Always
          name: mqipt
          ports:
          - containerPort: 1414
            name: ipt-listener
          - containerPort: 8080
            name: http-listener
          volumeMounts:
          - mountPath: "/tmp/mqipt"
            name: mqipt-conf
        volumes:
        - name: mqipt-conf
          configMap:
            name: mqipt-conf
            items:
            - key: mqipt-conf
              path: mqipt.conf
  ```  



















