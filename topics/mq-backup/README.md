
# MQ Backup


Backup and restore procedures for queue manager configuration on OpenShift are described in the following document: https://www.ibm.com/docs/en/ibm-mq/9.3?topic=omumo-backing-up-restoring-queue-manager-configuration-using-red-hat-openshift-cli

The document concentrates on the configuration backup assuming that because of the transient nature of the messages, historical log data is likely to be irrelevant at the time of restore.

At the time of creating MQ instance, it is possible to define (in the Platform Navigator user interface or QueueManager YAML) the type of volume that stores the persistent data. The volume is bound to the */var/mqm* directory inside the MQ container. 

The volume type can be:
- ephemeral
- persistent-claim 

If the *ephemeral* type is selected then the content disappears when the pod is restarted. In the case of using *persistent-claim* the data are stored in the external storage using the underlying OpenShift mechanism.

When the *persistent-claim* type is selected, we must also provide the *storage class* that is used to create *persistent volume claim* in the same OpenShift namespace where the MQ pod is running.

To understand those concepts, please see the following documents:
- [Storage Classes (Kubernetes)](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Volumes (Kubernetes)](https://kubernetes.io/docs/concepts/storage/volumes/)
- [Persisten Volumes (Kubernetes)](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Storage Overview (OpenShift)](https://docs.openshift.com/container-platform/4.10/storage/index.html)
