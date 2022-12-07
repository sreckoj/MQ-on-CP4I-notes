
# MQ management


## The question of starting/stopping queue manager running in OpenShift/Kubernetes

This question is related to one of the main differences between traditional and containerized environments. Traditional environments typically contain many running applications, processes, services, or whatever we call them. It is therefore logical that we need a way how to start or stop one of those applications. On the other hand, a container contains only one target service and minimal dependencies that are needed by that service. Therefore the question of starting/stopping the application often means starting/stopping the container itself.

In Kubernetes environments, the containers run in [pods](https://kubernetes.io/docs/concepts/workloads/pods/). A pod is a minimal unit of execution. Despite it is possible to manually create and start pods, they are usually controlled by other Kubernetes objects like [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/). Please use the links provided here to read more about those objects.

We cannot stop the pod and leave it in some kind of "stopped" state. Even if we try to kill the pod, it will be automatically restarted. 




>*Questions discussed here:*
>
>How to stop or start a QMgr?
>
>Scale down replicas of deployment to 0 -> oc scale deployment/<deployment name> --replicas 0
>
>https://docs.openshift.com/container-platform/4.11/support/troubleshooting/investigating-pod-issues.html#accessing-running-pods_investigating-pod-issues
>
>Stop QMgr via command line
>
>How to stop or start a Pod?
>
>Pods will restart automatically. Interact with the deployment/deployment config as described above.
>
>If something is stuck, just delete the pod and it will be recreated -> oc delete pod/<pod> -n <namespace>