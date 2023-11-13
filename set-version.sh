#!/bin/bash -e

NEW_VERSION=$1

mvn versions:set -Dversion.keycloak=$NEW_VERSION -DnewVersion=$NEW_VERSION -DgenerateBackupPoms=false -DgroupId=org.keycloak* -DartifactId=*

