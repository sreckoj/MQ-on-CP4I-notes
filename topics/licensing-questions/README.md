
# Licensing questions


The licensing details described here were true at the moment of writing this note. For any recent updates please consult IBM sales and check the official documentation e.g., [IBM Cloud Pak for Integration - Licensing](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing)

When a Pod is specified in any Kubernetes environment (including OpenShift) it is possible to define the resources each container running in this pod needs. The resources that currently can be defined are **CPU** and **memory** (see also: [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)).

There are two parameters that can be defined for each of those resources:
- resource **requests**
- resource **limits**

The resource **request** is a **minimum** amount of CPU and memory that must be available on a node in order for the pod to be scheduled to the node. On the other hand, the resource **limit** is a **maximum** amount that the pod will be permitted to consume. 

If there are a large number of pods on the worker node and there is contention for the resources each pod is guaranteed that will get at least the amount defined with the resource request or it will not run on that node at all. But, if the pod is alone or other pods are not active, it will try to take all available resources on the node unless it is limited by resource limits specification. 

For an illustration let's imagine that we have a worker node with 8 CPU cores and two pods where each of them has *resource requests* set to 2 CPUs. Let's also imagine that the first pod is currently in an idle state and the second is fully active. The idle pod will take a very small amount of CPU and, without the *resource limits* specification, the active pod will take everything else that is available on the node. This is shown in picture *a.)*. But, if we introduce a *resource limit* and set it, for example, to 3 CPUs, the second pod will take only those 3 CPUs despite there being "free" CPUs available on the node (picture *b.)*)

<img width="650" src="images/Snip20221230_31.png">

The [IBM License Service](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=service-license) running as part of the cloud pak sums all **CPU resource limits** of all licensed pods in the cluster. 

All components of the Cloud Pak for Integration have specified default CPU resource requests. Theoretically (for example when using custom images) it could happen that there is a pod without *resource limits* specification. In this case, the whole capacity of the node where such a pod is running is calculated. 


