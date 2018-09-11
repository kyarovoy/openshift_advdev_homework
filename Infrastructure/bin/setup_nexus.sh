#!/bin/bash
# Setup Nexus Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
CLUSTER=$2
echo "Setting up Nexus in project $GUID-nexus"

oc -n $GUID-nexus new-app -f ../templates/nexus.yaml
oc -n $GUID-nexus rollout status dc/nexus3 -w
