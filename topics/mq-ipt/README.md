
# MQ-IPT


IBM MQ Internet Pass-Thru (MQIPT) is an extension to the base IBM MQ product. MQIPT runs as a stand-alone service that can receive and forward IBM MQ message flows, either between two IBM MQ queue managers or between an IBM MQ client and an IBM MQ queue manager. MQIPT enables this connection when the client and server are not on the same physical network.

The following chapter in the documentation describes the IPT configuration:
https://www.ibm.com/docs/en/ibm-mq/9.3?topic=configuring-mq-internet-pass-thru

It is possible to run MQIPT in a container. Please follow the instructions in [IBM MQ Internet Pass-Thru on Docker](https://github.com/ibm-messaging/mq-container/tree/master/incubating/mqipt) to build and run it. 

---

TODO:

The provided instructions describe how to build and run the standalone container with MQIPT. We have to extend this to the possibility of running in OpenShift. This would probably include the ConfigMap with the IPT configuration and solution for building the image and running the container in a pod.
