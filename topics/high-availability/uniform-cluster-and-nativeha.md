
# Combining IBM MQ Uniform Cluster with NativeHA 

It is possible to combine the uniform clusters with the NativeHA. You can use the same example described in the [Uniform cluster](uniform-cluster.md) chapter of this collection. The only that you have to do is to add the NativeHA specification at the end of the [queue manager template](uniform-cluster/tmpl-qm.yaml)

For example (see the last two lines):

```yaml
apiVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  name: $INSTANCE_NAME
  namespace: $TARGET_NAMESPACE
spec:
  version: $MQ_VERSION
  license:
    accept: $LICENSE_ACCEPT
    license: $LICENSE
    use: $LICENSE_TYPE
  web:
    enabled: true
  queueManager:
    name: $QUEUE_MANAGER_NAME
    mqsc:
    - configMap:
        name: mq-cluster-conf
        items:
        - common.mqsc
        - $INSTANCE_NAME.mqsc
    ini:
    - configMap:
        name: mq-cluster-conf
        items:
        - qm.ini
    storage:
      queueManager:
        type: persistent-claim
      defaultClass: $STORAGE_CLASS
    availability:
      type: NativeHA
      
```