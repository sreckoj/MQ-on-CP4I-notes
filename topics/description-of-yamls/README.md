
# Description of the YML files
Storage settings (storage:)

persistedData

Does this affect the configuration of the QMgr only?

enabled: true type: persistent-claim class: <class-name> deleteClaim: true

queueManager, recoveryLogs

Does this affect the QMgr data and logs only?

Why are there separated entries?

classWhat's the meaning of ibm-spectrum-scale-cintx1 / ibm-spectrum-scale-internal?

deleteClaimWhat is deleted and under which circumstances?

ConfigMap

Long lines in the data part are splitted into separate lines, which results to syntax errors.

How can I prevent the insertion of line breaks?

MQ Backup

Is there a backup and recovery procedure for MQ, if yes - please provide link to Information

Defining File System Attributes

In the QMgr YAML it's possible, to define the size in MB or GB. May I define further settings, eg.

- Number of i-nodes

- Size of i-nodes

- Block size

- Journal options

...