
# Defining file system attributes

The question here was:
>In the QMgr YAML it's possible, to define the size in MB or GB. May I define further settings, eg.
>- Number of i-nodes
>- Size of i-nodes
>- Block size
>- Journal options
>...

This kind of settings is not part of the QueueManager CRD and do not appear in the YAML. But, any setting that can be defined by the MQSC command or that exists in the MQ ini file, can be provided in an OpenShift ConfigMap and applied to the queue manager at the pod startup.
Please see [QMgr customization](../qmgr-customization) and [Additional configuration](../additional-configuration) posts here in this collection.
