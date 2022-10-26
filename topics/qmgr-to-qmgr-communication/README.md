
# QMGR to QMGR communication

Other than the general networking specifics in OCP, there is no difference in connecting QMs on OCP and classic QMs

The main concern is actually the host name needed to configure the connection. To answer this question it is important to know if both queue managers are running in the same OpenShift cluster or maybe one of them is running outside of the cluster (in another cluster or as s standalone installation).

To understand this we need some basic knowledge about the OpenShift (or general Kubernetes) networking. Please read first the comments under [Networking in OpenShift](../networking-in-openshift)


## When both queue managers run in the same OpenShift cluster

The easiest situation is when both queue managers run in the same cluster. In this case, we can use the internal service DNS name following the syntax that is described in [DNS names](../networking-in-openshift#dns-names) section.

For example, if we have an installation of a queue manager in the namespace (project) **cp4i** and if the name of the MQ instance **qm1** then the service that listens on port 1414 will be created in that namespace. Its name, by convention, will be **qm1-ibm-mq** and the service DNS name will be **qm1-ibm-mq.cp4i.svc.cluster.local** 

You can use this name when creating the channel, for example:
```
CHLTYPE(SDR) TRPTYPE(TCP) CONNAME('qm1-ibm-mq.cp4i.svc.cluster.local(1414)')
...
```

## When external connection is needed


***TODO***
