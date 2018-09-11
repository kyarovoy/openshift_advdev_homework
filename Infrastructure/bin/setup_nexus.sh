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

oc project $GUID-nexus

oc new-app -f ../templates/nexus.yaml -p PROJNAME=$GUID-nexus.apps.$CLUSTER

while : ; do
	echo "Checking if Nexus is Ready..."
	oc get pod -n ${GUID}-nexus|grep '\-2\-'|grep -v deploy|grep "1/1"
	[[ "$?" == "1" ]] || break
	echo -n "."
	sleep 10
done

curl -s https://raw.githubusercontent.com/wkulhanek/ocp_advanced_development_resources/master/nexus/setup_nexus3.sh | bash -s admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}')

# Code to set up the Nexus. It will need to
# * Create Nexus
# * Set the right options for the Nexus Deployment Config
# * Load Nexus with the right repos
# * Configure Nexus as a docker registry
# Hint: Make sure to wait until Nexus if fully up and running
#       before configuring nexus with repositories.
