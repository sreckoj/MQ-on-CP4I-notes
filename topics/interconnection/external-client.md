
# Accessing from the external client


## Introduction

The OpenShift routes are used for the external access. Pleaese see [Networking in OpenShift](../networking-in-openshift)

The following chapter from the documentation explains details: https://www.ibm.com/docs/en/ibm-mq/9.2?topic=dcqmumo-configuring-route-connect-queue-manager-from-outside-red-hat-openshift-cluster

Please note that the [Server Name Indication](https://www.rfc-editor.org/rfc/rfc3546#page-8) (SNI) header is used to specify the channel. SNI is an extension to the TLS protocol that allows a client to indicate what service it requires. In MQ terminology this equates to a channel. The client is connecting to the queue manager using the main route that was automatically created together with the queue manager, but during the TLS handshake, it has to provide the SNI. This is the reason that we have to create an additional OpenShift Route with the channel SNI address as a route hostname. The following document describes how the SNI name is constructed from the channel name: https://www.ibm.com/support/pages/ibm-websphere-mq-how-does-mq-provide-multiple-certificates-certlabl-capability 

## Create certificates

For demo purposes, we will create self-signed certificates.

Create a server key (this will be used for the queue manager):
```
openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt
```

When asked, enter the certificate details, for example:
```
Country Name (2 letter code) []:DE
State or Province Name (full name) []:.
Locality Name (eg, city) []:.
Organization Name (eg, company) []:ACME
Organizational Unit Name (eg, section) []:Test
Common Name (eg, fully qualified host name) []:test.acme.com
Email Address []:test.user@acme.com
```

Repeat the same for the client:
```
openssl req -newkey rsa:2048 -nodes -keyout client.key -x509 -days 365 -out client.crt
```

Enter details:
```
Country Name (2 letter code) []:DE
State or Province Name (full name) []:.
Locality Name (eg, city) []:.
Organization Name (eg, company) []:ACME
Organizational Unit Name (eg, section) []:Test
Common Name (eg, fully qualified host name) []:test.acme.com
Email Address []:test.user@acme.com
```

As a result, we have the following files:
```
client.crt
client.key
server.crt
server.key
```

## Create secrets

The easiest way is to do this in OpenShift web console. Select **Workloads > Secrets** on the navigation panel and then select the project, in our case it is **mq**. Click on the button **Create** and select **Key/value secret**. 

- Enter the secret name: **mq-server-tls** <br>
  and add two key/value pairs:
  - Key: **tls.key** <br>
    Value: *drag & drop the file* **server.key**
  - Key: **tls.crt** <br>
    Value: *drag and drop the file* **server.crt**


- Create another secret with name name: **mq-mq-client-tls** <br>
  and add two key/value pairs:
  - Key: **tls.key** <br>
    Value: *drag & drop the file* **client.key**
  - Key: **tls.crt** <br>
    Value: *drag and drop the file* **client.crt**

As a result, we have now two secrets: *mq-server-tls* and *mq-client-tls*.
Their YAML representations should look similar to the following. Please note that the key and certificate contents are *base64* encoded. In the following illustration, they are also abbreviated for the sake of readability.

**mq-server-tls:**
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: mq-server-tls
  namespace: mq
data:
  tls.crt: >-
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURVakNDQWpvQ0N...
  tls.key: >-
    LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2d0lCQURBTkJ...
type: Opaque

```

**mq-client-tls**
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: mq-client-tls
  namespace: mq
data:
  tls.crt: >-
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURVakNDQWpvQ0N...
  tls.key: >-
    LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJ...
type: Opaque

```

## Create MQ instance

Create an instance with the following properties (please change *license.accept* to *true* if you copy/paste this YAML). Please note the **pki** section. We refer to the queue manager's key and the certificate in the keystore and client's certificate in the truststore:
```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: mq1
  namespace: mq
spec:
  license:
    accept: true
    license: L-RJON-CD3JKX
    use: NonProduction
  queueManager:
    name: QM1
    resources:
      limits:
        cpu: 500m
      requests:
        cpu: 500m
    storage:
      queueManager:
        type: ephemeral
  template:
    pod:
      containers:
        - env:
            - name: MQSNOAUT
              value: 'yes'
          name: qmgr
  version: 9.3.0.1-r2
  web:
    enabled: true
  pki:
    keys:
      - name: default
        secret:
          secretName: mq-server-tls
          items:
            - tls.key
            - tls.crt
    trust:
      - name: app
        secret:
          secretName: mq-client-tls
          items:
            - tls.crt
```

## Configure the queue manager

Apply the following properties:
- CHLAUTH records: **disabled**
- Server-connection channel: **DEV.APP.SVRCONN**
  - MCA user: **mqm**
  - SSL cipher: **ANY_TLS12**

Create local queue: **DEV.QUEUE.1**


## Create additional route


By the rules described in this document:
https://www.ibm.com/support/pages/ibm-websphere-mq-how-does-mq-provide-multiple-certificates-certlabl-capability
the SNI name of the channel **DEV.APP.SVRCONN** should be **dev2e-app2e-svrconn.chl.mq.ibm.com**

Use the following YAML to create the route:
```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: mq1-ibm-mq-qm-traffic-dev
  namespace: mq
spec:
  host: dev2e-app2e-svrconn.chl.mq.ibm.com
  to:
    kind: Service
    name: mq1-ibm-mq
  port:
    targetPort: 1414
  tls:
    termination: passthrough
```

Note that it points to the same service as the default route, only the host name represents the channel. 

## Configure client

Here are some examples of the client configuration:

- Client properties:
  ```
  QUEUE_MANAGER=QM1
  CHANNEL=DEV.APP.SVRCONN
  CONN_NAME=mq1-ibm-mq-qm-mq.apps.ocp410.tec.uk.ibm.com(443)
  ```

- In the case of using RFHUTIL for testing:
  ```
  DEV.APP.SVRCONN/TCP/mq1-ibm-mq-qm-mq.apps.ocp410.tec.uk.ibm.com(443)
  ```

- CCDT
  ```json
  {
      "channel":
      [
        {
          "general":
          {
            "description": "MQ Dev Channel"
          },
          "name": "DEV.APP.SVRCONN",
          "clientConnection":
          {
            "connection":
            [
              {
                "host": "/mq1-ibm-mq-qm-mq.apps.ocp410.tec.uk.ibm.com",
                "port": 443
              }
            ],
            "queueManager": "QM1"
          },
          "transmissionSecurity":
          {
            "cipherSpecification": "ANY_TLS12"
          },
          "type": "clientConnection"
        }
      ]
  }
  ```  

>Note: The expression `apps.ocp410.tec.uk.ibm.com` in the above examples is the ingress domain name of the OpenShift cluster used for testing durung the preparation of this document. 
