
# Additional configuration

It is possible to define the MQ script in the OpenShift ConfigMap object and assign this object to the queue manager definition. When an OpenShift pod with a queue manager is created those commands are automatically executed.

The following chapter from the MQ documentation explains this possibility in detail: https://www.ibm.com/docs/en/ibm-mq/9.2?topic=manager-example-supplying-mqsc-ini-files

For example, let's imagine that we want to execute this MQSC code when the queue manager is created:
```sh
DEFINE QL(APPQ) DEFPSIST(YES)
DEFINE CHANNEL(MQEXTERNALCHL) CHLTYPE(SVRCONN) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) SSLCIPH('ANY_TLS12_OR_HIGHER')
SET CHLAUTH(MQEXTERNALCHL) TYPE(BLOCKUSER) USERLIST(NOBODY)
REFRESH SECURITY TYPE(CONNAUTH)
```

Let's also assume that the name of our queue manager will be *QM1* and that it will run in the OpenShift namespace (project) *cp4i*

We can create the following ConfigMap:
```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: demomsc
  namespace: cp4i
data:
  test.mqsc: |-
    DEFINE QL(APPQ) DEFPSIST(YES)
    DEFINE CHANNEL(MQEXTERNALCHL) CHLTYPE(SVRCONN) TRPTYPE(TCP) SSLCAUTH(OPTIONAL) SSLCIPH('ANY_TLS12_OR_HIGHER')
    SET CHLAUTH(MQEXTERNALCHL) TYPE(BLOCKUSER) USERLIST(NOBODY)
    REFRESH SECURITY TYPE(CONNAUTH)
```

And then the queue manager

```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: qm1
  namespace: cp4i
spec:
  license:
    accept: false
    license: L-RJON-CD3JKX
    use: NonProduction
  queueManager:
    name: QUICKSTART
    resources:
      limits:
        cpu: 500m
      requests:
        cpu: 500m
    storage:
      queueManager:
        type: ephemeral
    mqsc:
      - configMap:
          name: demomsc
          items:
            - test.mqsc        
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

```

Note the following snipped in the above example:
```yaml
    mqsc:
      - configMap:
          name: demomsc
          items:
            - test.mqsc        
```

The **name** points to the name of the ConfigMap and **items** point to the MQSC content inside the ConfigMap.
Note also how the MQSC is written in multi lines in the ConfigMap.

To apply the above YAMLs you can put them to the yaml files and run for example:
```
oc apply -f myconfigmap.yaml
```

Or apply them directly in the OpenShift console.
