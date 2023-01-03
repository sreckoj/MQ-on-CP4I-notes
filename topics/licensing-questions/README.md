
# Licensing questions


The licensing details described here were true at the moment of writing this note. For any recent updates please consult IBM sales and check the official documentation e.g., [IBM Cloud Pak for Integration - Licensing](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing)

>Note: if the information in the CP4I documentation is different than the one in this post here then the information provided by the documentation should be considered true.

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


## The unit of measuring and ratios

The unit of measuring licenses is called VPC. Although the abbreviation stands for "Virtual Processor Core", this is actually not a technical but a sales term. When we buy the Cloud Pak for Integration we actually buy a certain number of VPCs. We can then spend those VPC for any of the capabilities provided by the CP4I.

On the other hand, the amount of CPU defined by *resource limits* or even its actual consumption is expressed in the virtual processor cores that are in this case the technical term. Very often, the same abbreviation - VPC is used also in this situation. To avoid confusion, it is better to use **vCPU** when we talk about CPU consumption as a technical term and **VPC** when we talk about licensing. 

For many of the products that are part of the CP4I, those two amounts are equal. But this is not the case for all of them. IBM defines so-called ratios between *vCPUs* and *VPCs*. Those ratios are given in the table available in the [Licensing](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing) document.  

For example, IBM API Connect that consumes 1 vCPU needs 1 VPC of license entitlement. Another example is IBM App Connect has a ratio of 1:3, which means that for 1 vCPU we need 3 VPCs of license entitlement. But, IBM MQ Advanced has a ratio of 2:1 - using 1 license VPC we can consume 2 vCPUs.   


## Non-production licenses

The same [Licensing](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing) document contains also the table for non-production license ratios. As you will see if you check the document, for non-production usage, you can consume twice as much CPU for the same number of the VPCs.

From the capabilities point of view there is no difference between production and non-production installations of MQ.

## Free components

Some of the components are "for free" - they do not consume license entitlements. Such a component is for example a platform user interface. Please see the table titled "What consumes IBM Cloud Pak for Integration license entitlements according to the ratio?" in already mentioned [Licensing](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing) document. Despite those components do not consume licenses, we still should be careful when planning the installation. They do not need VPCs but they still consume vCPUs and therefore can influence the Red Hat OpenShift licenses needed for the cluster. 

## Red Hat OpenShift licenses

At the moment of writing this note, there was a rule that entitles the customer to be allowed to run 3 OpenShift cores (vCPUs) for each Cloud Pak's VPC. Please see the following document for more details: [Red Hat OpenShift licenses](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.4?topic=planning-licensing#rhos-licenses)

## Capping

If we run two or more instances of the **same** CP4I capability on the same node and if the sum of CPU *resource limits* exceeds the total number of CPUs on that node, the licensing service will take into account the number of node's CPUs instead the sum of the resource limits. For example, let's consider the following situation:
- number of instances: 3
- CPU resource limits per instance: 4
- number of CPUs on node: 8
In this case, the total number of vCPUs used for the license calculation will be 8 and not 12 (to get the number of VPCs we have to apply the ratio for the specific product -  in the case of the MQ Advanced this would be 4 VPCs). 

Again, this is true only for the pods of the same product (for example just MQ) and not for the mixture of the CP4I products (e.g. MQ and Event Streams).

## Enforcing pods to run on a specific node

For licensing and also technical reasons some users want to enforce running pods on a specific node. This is possible using the following steps:
- Label nodes that are going to be used for cp4i with a specific key-value pair, for example:
  ```
  oc label node NODE_NAME nodeuse=cp4i
  ```
- Create an OpenShift project (namespace) and annotate it with the same key-value pair
  ```
  oc annotate namespace PROJECT_NAME openshift.io/node-selector='nodeuse=cp4i’
  ```
  All pods created in the specified project will be scheduled on the labeled node.
- If you want that all other pods are scheduled on other nodes, update the cluster-wide node selector
  ```
  defaultNodeSelector: nodeuse=general
  ``` 
  Please see the OpenShift [documentation](https://docs.openshift.com/container-platform/4.10/nodes/scheduling/nodes-scheduler-node-selectors.html) for details

>Note: If you run the OpenShift on IBM Cloud service (ROKS) then you can not update the cluster-wide node selector. In this case, annotate all other namespaces that you don't want to use the same nodes as cp4i with a 'general' selector:
>```
>oc annotate namespace OTHER_PROJECT openshift.io/node-selector='nodeuse=general’
>```  








