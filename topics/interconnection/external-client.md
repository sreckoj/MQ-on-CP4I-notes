
# Accessing from the external client


## Introduction

The OpenShift routes are used for the external access. Pleaese see [Networking in OpenShift](../networking-in-openshift)

The following chapter from the documentation explains details: https://www.ibm.com/docs/en/ibm-mq/9.2?topic=dcqmumo-configuring-route-connect-queue-manager-from-outside-red-hat-openshift-cluster

Please note that the [Server Name Indication](https://www.rfc-editor.org/rfc/rfc3546#page-8) (SNI) header is used to specify the channel. SNI is an extension to the TLS protocol that allows a client to indicate what service it requires. In MQ terminology this equates to a channel. The client is connecting to the queue manager using the main route that was automatically created together with the queue manager, but during the TLS handshake it has to provide the SNI. This is the reason that we have create additional OpenShift Route with the channel SNI address as a route hostname. The following doucment describes how the SNI name is constructed from the channel name: https://www.ibm.com/support/pages/ibm-websphere-mq-how-does-mq-provide-multiple-certificates-certlabl-capability 


## Create certificates

For demo purposes, we will create self-signed certificates.
