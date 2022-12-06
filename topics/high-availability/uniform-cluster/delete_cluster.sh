#!/bin/bash

oc delete -f cluster

oc delete pvc data-qm1-ibm-mq-0 -n mq
oc delete pvc data-qm2-ibm-mq-0 -n mq
oc delete pvc data-qm3-ibm-mq-0 -n mq
oc delete pvc data-qm4-ibm-mq-0 -n mq
