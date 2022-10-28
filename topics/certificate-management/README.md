
# Certificate management
How to create private/public keys?

Create a Kubernetes secret and store private key in there: https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_inputs.html#source-secrets-ssh-key-authentication 

How to generate TLS certificates?

Create a Kubernetes secret with your TLS-certificate and then mount this in your deployment at the location your application expects the certificates to be:

Secret for TLS certs: https://docs.openshift.com/online/pro/dev_guide/builds/build_inputs.html#source-secrets-trusted-certificate-authorities

Mounting to a pod (same for deployments). Example 2: https://docs.openshift.com/online/pro/dev_guide/secrets.html#secrets-examples 

How to import certificates from external CAs?

IBM cert manager vs Red Hat cert manager?