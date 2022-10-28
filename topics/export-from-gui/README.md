
# Export MQ config generated from graphical UI
try this: https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.2?topic=guide-extracting-queue-manager-configuration. 

The dmpmqcfg command allows to extract the full configuration from a queue manager including all default and system objects whether they were modified or not. In the container world, the command need to run on the active pod of the queue manager (it can run "remotely", i.e. can gather the configuration from another, connected remote queue manager). The output is a MQSC file that can be used to recreate the same configuration on another queue manager using the runmqsc command.

There is (currently) no way to extract that kind of MQSC file from the MQ Console or the MQ Explorer.