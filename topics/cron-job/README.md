
# Using OpenShift CronJob in combination with MQ

**UNDER CONSTRUCTION**

We will investigate here the possibilities of using OpenShift CronJob to periodically obtain the information related to the QueueManager running in a pod.

As an illustration, we will periodically invoke **dmpmqcfg** command to list the current Queue Manager configuration. 

All objects in this example will be created in a namespace (project) called **mq**. This is just for an illustration - it could be any namespace. In the case of pulling images from the IBM entitled registry, we should not forget to create an entitlement key secret in the selected namespace - see [Applying your entitlement key](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=installing-applying-your-entitlement-key-online-installation) in the Cloud Pak for Integration documentation.

Those are the high-level steps that we are going to implement
---
1. Prepare a ConfigMap with a simple MQ configuration
2. Create an instance of MQ that uses this configuration
3. Manually test *dmpmqcfg* on queue manager running in pod
4. Create a service account and role binding
5. Create a ConfigMap with a job script
6. Create and run an "ordinary" OpenShift Job
7. Prepare a CronJob



