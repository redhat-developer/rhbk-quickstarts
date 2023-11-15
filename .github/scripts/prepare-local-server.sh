#!/bin/bash -e

mkdir keycloak-dist
WGET_ARGS=

if [ -n "$PRODUCT" ] && [ "$PRODUCT" == "true" ] && [ -n "$PRODUCT_BUNDLE_URL" ]; then
  echo "Downloading product bits from $PRODUCT_BUNDLE_URL"
  URL=$PRODUCT_BUNDLE_URL;
  if [ -n "$SKIP_SSL_VALIDATIONS" ] && [ "$SKIP_SSL_VALIDATIONS" == "true" ]; then
    WGET_ARGS="--no-check-certificate";
  fi
elif [[ ( -n "$GITHUB_BASE_REF" &&  "$GITHUB_BASE_REF" == "latest" ) ]] || [[ ( -n "$QUICKSTART_BRANCH" && "$QUICKSTART_BRANCH" != "main" ) ]]; then
  VERSION=$(grep -oPm1 "(?<=<version>)[^<]+" pom.xml)
  echo "Using corresponding Keycloak version: $VERSION"
  URL="https://github.com/keycloak/keycloak/releases/download/${VERSION}/keycloak-${VERSION}.tar.gz"
else
  echo "Downloading nightly Keycloak release"
  URL="https://github.com/keycloak/keycloak/releases/download/nightly/keycloak-999.0.0-SNAPSHOT.tar.gz"
fi

wget -q -O keycloak-dist.tar.gz "$URL" $WGET_ARGS
tar xzf keycloak-dist.tar.gz --strip-components=1 -C keycloak-dist
