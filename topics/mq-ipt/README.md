
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

We will create an image that is slightly different from the one defined in the original Dockerfile. The reason for that is the way how the home directory (*/var/mqipt*) is provided. This directory contains the configuration file (*mqipt.conf*) and at the same time serves as the workspace directory where the logs and error messages are stored. When running an image locally, as described in the referenced article, the directory on the local file system is mounted to the directory inside the container. It can therefore serve both purposes. When running on the OpenShift we want to provide the configuration file as a ConfigMap. But, if we mount the ConfigMap to the directory inside the container we will not be able to create logs and error files on this directory. One of the possible solutions for that is to mount ConfigMap to a temporary directory (*/tmp/mqipt*) and then create a symbolic link in the home directory (*/var/mqipt*) that points to the configuration file (*mqipt.conf*) in this temporary directory. The following code examples are self-explanatory.

We will push the image to the OpenShift internal registry, the alternative is to use any external registry like Artifactory or Quay instead

Let's start:

- Download the MQIPT tar file: <br>
  As per the document https://www.ibm.com/support/pages/ms81-ibm-mq-internet-pass-thru the SupportPac MS81 can be now downloaded from the [FixCentral](https://www.ibm.com/support/fixcentral/swg/selectFixes?parent=ibm~WebSphere&product=ibm/WebSphere/WebSphere+MQ&release=9.3.0.0&platform=All&function=fixid&fixids=*IBM-MQIPT*). For this exercise we downloaded the file **9.3.1.0-IBM-MQIPT-LinuxX64.tar.gz** which was the latest version at that moment.


























