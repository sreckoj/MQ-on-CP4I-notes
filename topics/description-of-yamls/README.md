
# Description of the YAML files


>The questions from this group include also topics such as:
>- Storage settings, enabling persistence settings, influence on queue manager configuration, storage classes 
>- Queue manager recovery logs
>- ibm-spectrum-scale-cintx1 / ibm-spectrum-scale-internal
>- ConfigMap problems (e.g., long lines split into separate lines, how to prevent insertion of line brakes)
>- MQ backup/restore
>- Defining file system attributes
>
>Those topics will be (are already) covered in separate posts (please see the list on the main page)
>For now we concentrate here on the main YAML structure(s)

---

The creation of the new Queue Manager instance is managed by the MQ Operator. The Queue Manager is defined as a Custom Resource on the OpenShift platform (please click the links to see the details about the Operators and CRDs).
There are several objects created that can be represented using YAML. Most of them, like Pods, Stateful Sets, Services and Routes are managed by the Operator. The YAMLs that are typically prepared/edited by the user are ConfgMaps which are used for the configuration and the YAML of the QueueManager custom resource itself. 

Using the ConfigMaps is described in [QMgr customization](../qmgr-customization) and [Additional configuration](../additional-configuration) posts here in this collection.

The basic YAML structure is automatically generated when we create a new MQ instance in the Platform Navigator or using the OpenShift web console. It looks like this:

```yaml
piVersion: mq.ibm.com/v1beta1
kind: QueueManager
metadata:
  annotations:
    com.ibm.mq/write-defaults-spec: 'false'
  name: quickstart-cp4i
  namespace: cp4i
spec:
  license:
    accept: false
    license: L-RJON-CJR2RX
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
  template:
    pod:
      containers:
        - env:
            - name: MQSNOAUT
              value: 'yes'
          name: qmgr
  version: 9.3.1.0-r2
  web:
    enabled: true
```

Those are, of course not the only parameters that can be defined in the YAML. The following document describes all possible fields: [API reference for QueueManager](https://www.ibm.com/docs/en/ibm-mq/9.3?topic=mqibmcomv1beta1-api-reference-queuemanager)

Please note the way how the fields are described. 
For example the entry *.spec.queueManager* means that under the entry *spec* in the YAML there must be the entry *queueManager* on the next level (shifted right)
```yaml
...
spec
  queueManager
    ...

```

Because the *queueManager* is a complex field, it contains its own subfields, that can be of a simple type, for example, *name*, or another complex type, for example, *availability*
```yaml
...
spec
  queueManager
    name: QM1
    availability:
      type: NativeHA
      updateStrategy: RollingUpdate
      ...

```
etc...






















