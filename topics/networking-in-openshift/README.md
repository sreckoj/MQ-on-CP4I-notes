
# Networking in OpenShift

Networking in OpenShift and generally in Kubernetes is a large and complex topic. There are plenty of books and Internet sources that cover it available. We will explain here some basic concepts that are necessary to start working with CP4I and MQ. 

- The basic unit of execution in Kubernetes is a *pod*. It consists of one or more containers. The containers that belong to the same pod "see" each other as they are on the "localhost".

- There are three three network levels in the Kubernetes cluster -  pod level, services level, and nodes level.

- There is an internal pod network with a specific range of IP addresses ​and each pod has an associated IP address in this network