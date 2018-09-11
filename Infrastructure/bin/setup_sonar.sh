#!/bin/bash
# Setup Sonarqube Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Sonarqube in project $GUID-sonarqube"

oc project $GUID-sonarqube
oc new-app --template=postgresql-persistent -p POSTGRESQL_USER=sonar -p POSTGRESQL_PASSWORD=sonar -p POSTGRESQL_DATABASE=sonar -p VOLUME_CAPACITY=4Gi --labels=app=sonarqube_db
oc new-app -f ../templates/sonarqube.yaml -p HOSTNAME -p SONARQUBE_JDBC_USERNAME=sonar -p SONARQUBE_JDBC_PASSWORD=sonar -p SONARQUBE_JDBC_DBNAME=sonar
