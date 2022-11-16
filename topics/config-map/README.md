
# ConfigMap

The general description of the Kubernetes ConfigMap object can be found in the following document: https://kubernetes.io/docs/concepts/configuration/configmap/

In the IBM MQ context, the ConfigMaps are mostly used for the MQSC scripts that are executed when MQ pods are created and for defining MQ INI files. The idea is to have the configuration defined separately from the pods with the possibility to apply it whenever a new pod is created or the existing one is restarted (deleted and recreated). In that way, we assure that the initial conditions are always assured.

Please see the following notes from this collection:
- [Additional configuration](../additional-configuration)
- [QMgr customization](qmgr-customization)

and the following chapter from the documentation:
- [Supplying MQSC and INI files](https://www.ibm.com/docs/en/ibm-mq/9.2?topic=manager-example-supplying-mqsc-ini-files)