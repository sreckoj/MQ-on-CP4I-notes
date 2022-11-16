
# Certificate management


Please see [Accessing from the external client](../interconnection/external-client.md), available in this collection. It describes the following steps:

- [Create self-signed certificates](../interconnection/external-client.md#create-certificates) (in production they, of course, must be issued by the CA)
- [Create secrets that hold the certificates](../interconnection/external-client.md#create-secrets)
- [Create queue manager with the keystore and truststore definitions that refer to the secrets](../interconnection/external-client.md#create-mq-instance)

Please see also this, similar, example: [Connectivity between two queue managers on the same OpenShift cluster](../interconnection/two-queue-managers-internal.md) 

and the following instructions: [Working with the self-signed certificates](../miscellaneous/self-signed-certs.md)



--- 

**... TO BE CONTINUED ...**

*Additional questions and sources:*


Create a Kubernetes secret and store private key in there: https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_inputs.html#source-secrets-ssh-key-authentication

Create a Kubernetes secret with your TLS-certificate and then mount this in your deployment at the location your application expects the certificates to be:

Secret for TLS certs: https://docs.openshift.com/online/pro/dev_guide/builds/build_inputs.html#source-secrets-trusted-certificate-authorities

Mounting to a pod (same for deployments). Example 2: https://docs.openshift.com/online/pro/dev_guide/secrets.html#secrets-examples

How to import certificates from external CAs?

IBM cert manager vs Red Hat cert manager?

How to secure secrets in OpenShift?
Is it possible to store secrets on an external HSM device?
Are there guidelines how to protect a secret inside an OpenShift cluster?