
# HTTP or MQ protocol?

The main question here is: "Can we use dedicated MQ channels between CP4I and outside using the MQ protocol?"

This is theoretically possible by exposing MQ using the *NodePort* service type (see [Networking in OpenShift](../networking-in-openshift)) but the recommended approach is using the OpenShift routes (see [Interconnection](../interconnection))

>Note: Despite the route uses HTTPS, the MQ protocol can be "hidden" in it.