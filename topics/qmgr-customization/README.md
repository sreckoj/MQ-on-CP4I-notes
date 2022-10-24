
# QMgr customization

This question is similar to the one related to the [additional configuration](../../topics/additional-configuration), but in this case, we supply the content of the INI file in the ConfigMap. See the following example in the documentation: https://www.ibm.com/docs/en/ibm-mq/9.2?topic=manager-example-supplying-mqsc-ini-files

A few additional comments:

- This is applied only when the QM is created or the pod is restarted. Config adjustments after the creation of the QM need to be managed carefully. But this is not principally different from classic MQ.

- Note: It is important to know that any change done in the "classic" way will be lost after the pod restart unless the persistent volume is defined. See the "storage" definition in the YAML example bellow:

- For managing QM configurations dynamically using a Gitops approach, you can build on this tutorial: https://production-gitops.dev/guides/cp4i/mq/qmgr-pipeline/topic5/

- Adjusting the size of log files in qm.ini is not possible as of now - internal request #789 is already open, external RfE : https://integration-development.ideas.ibm.com/ideas/CIP-I-206



The following two YAMLs are based on the example in the documentation article referenced above and illustrate both, MQSC and INI configuration. The only difference from the original example is that we added also the persistent volume (in this case using *rook-ceph*):

ConfigMap:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mqsc-ini-example
data:
  example1.mqsc: |
    DEFINE QLOCAL('DEV.QUEUE.1') REPLACE
    DEFINE QLOCAL('DEV.QUEUE.2') REPLACE
  example2.mqsc: |
    DEFINE QLOCAL('DEV.DEAD.LETTER.QUEUE') REPLACE
  example.ini: |
    Channels:
       MQIBindType=FASTPATH
```

Queue manager:
```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: mqsc-ini-cp4i
spec:
  version: 9.2.5.0-r3
  license:
    accept: false
    license: L-RJON-C7QG3S
    use: NonProduction
  web:
    enabled: true
  queueManager:
    name: "MQSCINI"
    mqsc:
    - configMap:
        name: mqsc-ini-example
        items:
        - example1.mqsc
        - example2.mqsc
    ini:
    - configMap:
        name: mqsc-ini-example
        items:
        - example.ini
    storage:
      queueManager:
        type: persistent-claim
      defaultClass: rook-cephfs        
```