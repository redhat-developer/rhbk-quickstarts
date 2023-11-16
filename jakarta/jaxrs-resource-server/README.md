jakarta-jaxrs-resource-server: JAX-RS Resource Server
===================================================

Level: Beginner
Technologies: Jakarta EE
Summary: A JAX-RS resource server protected with JBoss EAP Elytron OIDC
Target Product: <span>Red Hat build of Keycloak</span>, <span>JBoss EAP</span>

What is it?
-----------

This quickstart demonstrates how to write a RESTful service with Jakarta RESTful Web Service that is secured with _Red Hat build of Keycloak_.

The endpoints are very simple and will only return a simple message stating what endpoint was invoked.

System Requirements
-------------------

To compile and run this quickstart you will need:

* JDK 17
* Apache Maven 3.8.6
* JBoss EAP 8
* Red Hat build of Keycloak 22+

Starting and Configuring the Red Hat build of Keycloak Server
-------------------

To start a _Red Hat build of Keycloak_ Server you can use OpenJDK on Bare Metal, _Red Hat build of Keycloak_ Operator or any other option described in
[Red Hat build of Keycloak Getting Started guides]https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/getting_started_guide/index.

For example when using Bare metal, you need to have Java 17 or later available. Then you can unzip _Red Hat build of Keycloak_ distribution and in the directory `bin` run this command:

```shell
./kc.[sh|bat] start-dev --http-port=8180
```

You should be able to access your _Red Hat build of Keycloak_ server at http://localhost:8180.

Log in as the admin user to access the _Red Hat build of Keycloak_ Administration Console. Username should be `admin` and password `admin`.

Import the [realm configuration file](config/realm-import.json) to create a new realm called `quickstart`.
or more details, see the _Red Hat build of Keycloak_ documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

Starting the JBoss EAP Server
-------------------

In order to deploy the example application, you need a JBoss EAP Server up and running. For more details, see the JBoss EAP documentation about how
to [install the server](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/8-beta/html-single/jboss_eap_installation_methods/index).

Make sure the server is accessible from `localhost` and listening on port `8080`.

Build and Deploy the Quickstart
-------------------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to deploy the quickstart:

   ````
   mvn -Djakarta clean wildfly:deploy
   ````

Access the Quickstart
---------------------

There are 3 endpoints exposed by the service:

* http://localhost:8080/jakarta-jaxrs-resource-server/public - requires no authentication
* http://localhost:8080/jakarta-jaxrs-resource-server/secured - can be invoked by users with the `user` role
* http://localhost:8080/jakarta-jaxrs-resource-server/admin - can be invoked by users with the `admin` role

You can open the public endpoint directly in the browser to test the service. The two other endpoints are protected and require
invoking them with a bearer token.

To invoke the protected endpoints using a bearer token, your client needs to obtain an OAuth2 access token from a _Red Hat build of Keycloak_ server.
In this example, we are going to obtain tokens using the resource owner password grant type so that the client can act on behalf of any user available from
the realm.

You should be able to obtain tokens for any of these users:

| Username | Password | Roles              |
|----------|----------|--------------------|
| alice    | alice    | user               |
| admin    | admin    | admin              |

To obtain the bearer token, run for instance the following command when on Linux (please make sure to have `curl` and `jq` packages available in your linux distribution):

```shell
export access_token=$(\
curl -X POST http://localhost:8180/realms/quickstart/protocol/openid-connect/token \
-H 'content-type: application/x-www-form-urlencoded' \
-d 'client_id=jakarta-jaxrs-resource-server&client_secret=secret' \
-d 'username=alice&password=alice&grant_type=password' | jq --raw-output '.access_token' \
)
```

You can use the same command to obtain tokens on behalf of user `admin`, just make sure to change both `username` and `password` request parameters.

After running the command above, you can now access the `http://localhost:8080/jakarta-jaxrs-resource-server/secured` endpoint
because the user `alice` has the `user` role.

```shell
curl http://localhost:8080/jakarta-jaxrs-resource-server/secured \
  -H "Authorization: Bearer "$access_token
```

As a result, you will see the following response from the service:

```json
{"message":"secured"}
```

You may also want to enable CORS for the service if you want to allow invocations from HTML5 applications deployed to a
different host. To do this edit [oidc.json](src/main/webapp/WEB-INF/oidc.json) file and add:

````
{
   ...
   "enable-cors": true
}
````

Undeploy the Quickstart
--------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to deploy the quickstart:

   ````
   mvn -Djakarta clean wildfly:undeploy
   ````

Running tests
--------------------

Make sure _Red Hat build of Keycloak_ is [running](#starting-and-configuring-the-red-hat-build-of-keycloak-server).

You don't need JBoss EAP running because a temporary server is started during test execution.

1. Open a terminal and navigate to the root directory of this quickstart.

2. Run the following command to build and run tests:

   ````
   mvn -Djakarta clean verify
   ````

References
--------------------

* [SSO With JBoss EAP](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/8-beta/html-single/using_single_sign-on_with_jboss_eap/index#doc-wrapper)
* [Red Hat build of Keycloak Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)