
# Networking in OpenShift

Networking in OpenShift and generally in Kubernetes is a large and complex topic. There are available plenty of books and Internet sources that cover it. We will explain here some basic concepts that are necessary to start working with CP4I and MQ. 

- The basic unit of execution in Kubernetes is a *pod*. It consists of one or more containers. The containers that belong to the same pod "see" each other as they are on the "localhost".

- There are three different internal networks inside the Kubernetes cluster, each with a specific range of IP addresses. Those are the pods' network, services, and cluster nodes network. 

- Each pod has an associated IP address. Pods are able to communicate with each other using their network. But, this is not recommended way of building the solution. At the very basis of the Kubernetes idea is an assumption that a pod is something ephemeral. It can be destroyed and recreated at any moment and it can be moved to another cluster node by the Kubernetes scheduler.

