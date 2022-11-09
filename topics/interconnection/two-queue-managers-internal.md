
# Connectivity between two queue managers <br> on the same OpenShift cluster

>Note: Especially interesting is the requirement that the connection is secured using **mTLS**. We will focus on that.

Assumptions:
  - Queue managers names: **QMA**, **QMB**
  - Both queue managers in the same namespace: **mq**


## Create certificates

For demo purposes, we will create self-signed certificates.

Create a certificate for QMA:
```
openssl req -newkey rsa:2048 -nodes -keyout qma.key -x509 -days 365 -out qma.crt
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

Repeat the same for QMB:
```
openssl req -newkey rsa:2048 -nodes -keyout qmb.key -x509 -days 365 -out qmb.crt
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
qma.crt
qma.key
qmb.crt
qmb.key    
```

## Create secrets

The easiest way is to do this in OpenShift web console. Select **Workloads > Secrets** on the navigation panel and then select the project, in our case it is **mq**. Click on the button **Create** and select **Key/value secret**. 

- Enter the secret name: **qma-tls** <br>
  and add two key/value pairs:
  - Key: **tls.key** <br>
    Value: *drag & drop the file* **qma.key**
  - Key: **tls.crt** <br>
    Value: *drag and drop the file* **qma.crt**


- Create another secret with name name: **qmb-tls** <br>
  and add two key/value pairs:
  - Key: **tls.key** <br>
    Value: *drag & drop the file* **qmb.key**
  - Key: **tls.crt** <br>
    Value: *drag and drop the file* **qmb.crt**

As a result, we have now two secrets: *qma-tls* and *qmb-tls*.
Their YAML representations should look similar to the following. Please note that the key and certificate contents are *base64* encoded. In the following illustration, they are also abbreviated for the sake of readability.

**qma-tls:**
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: qma-tls
  namespace: mq
data:
  tls.crt: >-
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURTRENDQWpBQ0NRQ2pz...
  tls.key: >-
    LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2d0lCQURBTkJna3Fo...
type: Opaque
```

**qmb-tls:**
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: qmb-tls
  namespace: mq
data:
  tls.crt: >-
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURTRENDQWpBQ0NRQ3E5...
  tls.key: >-
    LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2QUlCQURBTkJna3Fo...
type: Opaque

```


## Create queue managers

Use the CP4I Platform Navigator or the OpenShift interfaces to create queue managers with a structure similar to the following examples:

>Note: If you copy/paste the examples, please change *license.accept* to *true* before using 

**QMA:**
```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: qma
  namespace: mq
spec:
  license:
    accept: false
    license: L-RJON-CD3JKX
    use: NonProduction
  queueManager:
    name: QMA
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
          secretName: qma-tls
          items:
            - tls.key
            - tls.crt
    trust:
      - name: qmb
        secret:
          secretName: qmb-tls
          items:
            - tls.crt

```

**QMB:**
```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: qmb
  namespace: mq
spec:
  license:
    accept: false
    license: L-RJON-CD3JKX
    use: NonProduction
  queueManager:
    name: QMB
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
          secretName: qmb-tls
          items:
            - tls.key
            - tls.crt
    trust:
      - name: qma
        secret:
          secretName: qma-tls
          items:
            - tls.crt
```


The most important part of the above structures is the **pki** section. Note that it contains the **keys** entry that refers to the secret with its own private key and certificate, and the **trust** entry that refers only to the certificate of the other queue manager. For example, this is the definition for *QMA*:
```yaml
  pki:
    keys:
      - name: default
        secret:
          secretName: qma-tls
          items:
            - tls.key
            - tls.crt
    trust:
      - name: qmb
        secret:
          secretName: qmb-tls
          items:
            - tls.crt
```
It refers to *tls.key* and *tls.crt* in secret *qma-tls* and only to *tls.crt* in the secret *qmb-tls*:


## Create MQ objects for testing

On **QMA** side create:
- Transmission queue: **QMA.TO.QMB**
- Remote queue definition **TESTQ** with the following properties:
  - Remote queue: **TESTQ**
  - Remote queue manager: **QMB**
  - Transmission queue: **QMA.TO.QMB**
- Sender channel: **QMA.TO.QMB** with the following properties:
  - Connection name: **qmb-ibm-mq.mq.svc.cluster.local(1414)**
  - Transmission queue: **QMA.TO.QMB**

On **QMB** side create:
- Local queue: **TESTQ**
- Receiver channel: **QMA.TO.QMB**

Start the sender channel. Put a message to *TESTQ* on *QMA*. It must appear in the queue *TESTQ* on *QMB* queue manager. 



