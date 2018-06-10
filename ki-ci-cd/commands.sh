oc new-project ki-ci-cd

# TODO: global vars
# TODO: resource limits as template params for all templates

# Jenkins
oc new-app jenkins-persistent -p ENABLE_OAUTH=true -p MEMORY_LIMIT=2Gi -p VOLUME_CAPACITY=4Gi

# Gogs
# TODO: sed for XML manipulation

oc new-app -f gogs-persistent-template.yml -p HOSTNAME=gogs-ki-ci-cd.apps.na37.openshift.opentlc.com
# Go to Gogs, create account (gogs_admin:123456) and new org 'MitziCom'
cd /tmp
git clone https://github.com/wkulhanek/ParksMap
cd ParksMap
brew install xmlstarlet
xmlstarlet ed --inplace -u "//settings/mirrors/mirror/url" -v "http://nexus3-ki-ci-cd.apps.na37.openshift.opentlc.com/repository/maven-all-public/" nexus_settings.xml
xmlstarlet ed --inplace -u "//settings/mirrors/mirror/url" -v "http://nexus3.ki-ci-cd.svc.cluster.local/repository/maven-all-public/" nexus_settings_openshift.xml
git remote add private http://gogs_admin:123456@gogs-ki-ci-cd.apps.na37.openshift.opentlc.com/MitziCom/ParksMap.git
git push private master

# Nexus
oc new-app -f nexus-persistent-template.yml -p PROJNAME=ki-ci-cd.apps.na37.openshift.opentlc.com
curl -s https://raw.githubusercontent.com/wkulhanek/ocp_advanced_development_resources/master/nexus/setup_nexus3.sh | bash -s admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}')

# SonarQube
# TODO: combine
oc new-app --template=postgresql-persistent -p POSTGRESQL_USER=sonar -p POSTGRESQL_PASSWORD=sonar -p POSTGRESQL_DATABASE=sonar -p VOLUME_CAPACITY=4Gi --labels=app=sonarqube_db
oc new-app -f sonarqube-persistent-template.yml -p HOSTNAME -p SONARQUBE_JDBC_USERNAME=sonar -p SONARQUBE_JDBC_PASSWORD=sonar -p SONARQUBE_JDBC_DBNAME=sonar
