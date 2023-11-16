#!/bin/bash -e

export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin

dist="keycloak-dist"

if [ "$1" = "extension" ]; then
  echo "Adding default providers when starting Keycloak server";

  if [ "$1" == "extension" ]; then
    mvn_args="-s .github/maven-settings.xml"
    mvn -Dextension -DskipTests -B -Dnightly $mvn_args clean package
    cp extension/user-storage-simple/target/user-storage-properties-example.jar $dist/providers
    cp extension/user-storage-jpa/conf/quarkus.properties $dist/conf
    cp extension/user-storage-jpa/target/user-storage-jpa-example.jar $dist/providers
  fi
fi

eval exec "$dist/bin/kc.sh start-dev --http-port=8180 $SERVER_ARGS" | tee keycloak.log &

wget --retry-connrefused --waitretry=3 --read-timeout=20 --timeout=15 -t 30 http://localhost:8180 --quiet