
# MQ management
How to stop or start a QMgr?

Scale down replicas of deployment to 0 -> oc scale deployment/<deployment name> --replicas 0

https://docs.openshift.com/container-platform/4.11/support/troubleshooting/investigating-pod-issues.html#accessing-running-pods_investigating-pod-issues

Stop QMgr via command line

How to stop or start a Pod?

Pods will restart automatically. Interact with the deployment/deployment config as described above.

If something is stuck, just delete the pod and it will be recreated -> oc delete pod/<pod> -n <namespace>