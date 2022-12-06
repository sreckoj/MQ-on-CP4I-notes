#!/bin/bash

export TARGET_NAMESPACE=mq
export CLUSTER_NAME=CLUS1

export MQ_VERSION=9.3.1.0-r1
export LICENSE=L-RJON-CD3JKX
export LICENSE_TYPE=NonProduction
export LICENSE_ACCEPT=true

export STORAGE_CLASS=rook-cephfs

# we will store generated yamls in a subdirectory
mkdir cluster 2> /dev/null

# Prepare cluster config map
( echo "cat <<EOF" ; cat tmpl-cm.yaml ; echo EOF ) | sh > cluster/mq-cluster-conf.yaml

# prepare yamls for queue managers
for qm in qm1 qm2 qm3 qm4
do
    export INSTANCE_NAME=$qm
    export QUEUE_MANAGER_NAME=${qm^^} # uppercased
    ( echo "cat <<EOF" ; cat tmpl-qm.yaml ; echo EOF ) | sh > cluster/${qm}.yaml
done

# apply all yamls
oc apply -f cluster