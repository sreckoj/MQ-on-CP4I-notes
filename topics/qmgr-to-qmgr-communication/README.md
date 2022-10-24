
# QMGR to QMGR communication

Other than the general networking specifics in OCP, there is no difference in connecting QMs on OCP and classic QMs

The main concern is actually the host name needed to configure the connection. To answer this question it is important to know if both queue managers are running in the same OpenShift cluster or maybe one of them is running outside of the cluster (in another cluster or as s standalone installation).

The easiest situation is when both of them run in the same cluster. 

To understand this we need some basic knowledge about the OpenShift (or general Kubernetes) networking. Please read first the comments under [Networking in OpenShift](../networking-in-openshift)

