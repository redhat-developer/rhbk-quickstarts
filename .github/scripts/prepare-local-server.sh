#!/bin/bash -e

mkdir keycloak-dist
WGET_ARGS=

if [ -n "$PRODUCT" ] && [ "$PRODUCT" == "true" ] && [ -n "$PRODUCT_BUNDLE_URL" ]; then
  URL=$PRODUCT_BUNDLE_URL;
  if [ -n "$SKIP_SSL_VALIDATIONS" ] && [ "$SKIP_SSL_VALIDATIONS" == "true" ]; then
    WGET_ARGS="--no-check-certificate";
  fi
elif [[ ( -n "$GITHUB_BASE_REF" &&  "$GITHUB_BASE_REF" == "latest" ) ]] || [[ ( -n "$QUICKSTART_BRANCH" && "$QUICKSTART_BRANCH" != "main" ) ]]; then
  KEYCLOAK_SERVER_VERSION=$(grep -oPm1 "(?<=<version>)[^<]+" pom.xml)
fi

if [[ -n "$URL" ]]; then
  echo "Downloading product bits from $URL"
elif [[ -n "$KEYCLOAK_SERVER_VERSION" ]]; then
  echo "Using corresponding Keycloak version: $KEYCLOAK_SERVER_VERSION"
  URL="https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_SERVER_VERSION}/keycloak-${KEYCLOAK_SERVER_VERSION}.tar.gz"
else
  echo "Downloading nightly Keycloak release"
  URL="https://github.com/keycloak/keycloak/releases/download/nightly/keycloak-999.0.0-SNAPSHOT.tar.gz"
fi

wget -q -O keycloak-dist.tar.gz "$URL" $WGET_ARGS
tar xzf keycloak-dist.tar.gz --strip-components=1 -C keycloak-dist
