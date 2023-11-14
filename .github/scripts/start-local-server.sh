#!/bin/bash -e

export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin

dist="keycloak-dist"

if [ "$1" = "extension" ]; then
  echo "Adding default providers when starting Keycloak server";

  if [ "$1" == "extension" ]; then
    args="${*:2}"
    if [ -n "$PRODUCT" ] && [ "$PRODUCT" == "true" ]; then
      args="$args -s $PRODUCT_MVN_SETTINGS  -Dmaven.repo.local=$PRODUCT_MVN_REPO"
    else
      args="$args -s .github/maven-settings.xml"
    fi
    if [ -n "$SKIP_SSL_VALIDATIONS" ] && [ "$SKIP_SSL_VALIDATIONS" == "true" ]; then
      args="$args -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"
    fi
    echo "Maven arguments when building extension quickstarts: $args";

    mvn -Dextension -DskipTests -B -Dnightly $args clean package
    cp extension/user-storage-simple/target/user-storage-properties-example.jar $dist/providers
    cp extension/user-storage-jpa/conf/quarkus.properties $dist/conf
    cp extension/user-storage-jpa/target/user-storage-jpa-example.jar $dist/providers
  fi
fi

eval exec "$dist/bin/kc.sh start-dev --http-port=8180 $SERVER_ARGS" | tee keycloak.log &

wget --retry-connrefused --waitretry=3 --read-timeout=20 --timeout=15 -t 30 http://localhost:8180 --quiet