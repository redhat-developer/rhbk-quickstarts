rest-authz-resource-server: Spring Boot REST Service Protected Using Red Hat build of Keycloak Authorization Services
===================================================

Level: Beginner
Technologies: Spring Boot
Summary: Spring Boot REST Service Protected Using _Red Hat build of Keycloak_ Authorization Services
Target Product: Red Hat build of Keycloak

What is it?
-----------

This quickstart demonstrates how to protect a Spring Boot REST service using _Red Hat build of Keycloak_ Authorization Services.

It tries to focus on the authorization features provided by _Red Hat build of Keycloak_ Authorization Services, where resources are
protected by a set of permissions and policies defined in _Red Hat build of Keycloak_ and access to these resources are enforced by a policy enforcer(PEP)
that intercepts every single request sent to the application to check whether or not access should be granted.

System Requirements
-------------------

To compile and run this quickstart you will need:

* JDK 17
* Apache Maven 3.8.6
* Spring Boot 3.0.6
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
For more details, see the _Red Hat build of Keycloak_ documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

Build and Run the Quickstart
-------------------------------

If your server is up and running, perform the following steps to start the application:

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to run the application:

   ````
   mvn spring-boot:run

   ````

Access the Quickstart
---------------------

There are 2 endpoints exposed by the service:

* http://localhost:8080/ - can be invoked by any authenticated user
* http://localhost:8080/protected/premium - can be invoked by users with the `user_premium` role

To invoke the protected endpoints using a bearer token, your client needs to obtain an OAuth2 access token from a _Red Hat build of Keycloak_ server.
In this example, we are going to obtain tokens using the resource owner password grant type so that the client can act on behalf of any user available from
the realm.

You should be able to obtain tokens for any of these users:

| Username | Password | Roles        |
|----------|----------|--------------|
| jdoe     | jdoe     | user_premium |
| alice    | alice    | user         |

To obtain the bearer token, run for instance the following command when on Linux (please make sure to have `curl` and `jq` packages available in your linux distribution):

```shell
export access_token=$(\
curl -X POST http://localhost:8180/realms/quickstart/protocol/openid-connect/token \
-H 'content-type: application/x-www-form-urlencoded' \
-d 'client_id=authz-servlet&client_secret=secret' \
-d 'username=jdoe&password=jdoe&grant_type=password' | jq --raw-output '.access_token' \
)
```

You can use the same command to obtain tokens on behalf of user `alice`, just make sure to change both `username` and `password` request parameters.

After running the command above, you can now access the `http://localhost:8080/protected/premium` endpoint
because the user `jdoe` has the `user_premium` role.

```shell
curl http://localhost:8080/protected/premium \
  -H "Authorization: Bearer "$access_token
```

As a result, you will see the following response from the service:

```
Hello, jdoe!
```

Accessing Protected Resources using Requesting Party Token (RPT)
---------------------

Another approach to access resources protected by a policy enforcer is using a RPT as a bearer token, instead of a regular access token. 
The RPT is an access token with all permissions granted by the server, basically, an access token containing all permissions granted by the server.

To obtain an RPT, you must first exchange an OAuth2 Access Token for a RPT by invoking the token endpoint at the _Red Hat build of Keycloak_ server: 

```bash
export rpt=$(curl -X POST \
 http://localhost:8180/realms/quickstart/protocol/openid-connect/token \
 -H "Authorization: Bearer "$access_token \
 --data "grant_type=urn:ietf:params:oauth:grant-type:uma-ticket" \
 --data "audience=authz-servlet" \
  --data "permission=Premium Resource" | jq --raw-output '.access_token' \
 )
```

The command above is trying to obtain permissions from the server in the format of a RPT. Note that the request is specifying the resource we want
to obtain permissions, in this case, `Premium Resource`.

As an alternative, you can also obtain permissions for any resource protected by your application. For that, execute the command below:

```bash
export rpt=$(curl -X POST \
 http://localhost:8180/realms/quickstart/protocol/openid-connect/token \
 -H "Authorization: Bearer "$access_token \
 --data "grant_type=urn:ietf:params:oauth:grant-type:uma-ticket" \
 --data "audience=authz-servlet" | jq --raw-output '.access_token' \
 )
```

After executing any of the commands above, you should get a response similar to the following:

```bash
{
    "access_token": "${rpt}",
}
``` 

To finally invoke the resource protected by the application, replace the ``${rpt}`` variable below with the value of the ``access_token`` claim from the response above and execute the following command:

```bash
curl http://localhost:8080/protected/premium \
    -H "Authorization: Bearer ${rpt}"
```

Running tests
--------------------

Make sure _Red Hat build of Keycloak_ is [running](#starting-and-configuring-the-red-hat-build-of-keycloak-server).

You don't need spring boot application running because a temporary server is started during test execution.

1. Open a terminal and navigate to the root directory of this quickstart.

2. Run the following command to build and run tests:

   ````
   mvn -Dspring clean verify
   ````

References
--------------------

* [Spring OAuth 2.0 Resource Server JWT](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html)
* [Red Hat build of Keycloak Authorization Services](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/authorization_services_guide/index)
* [Red Hat build of Keycloak Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)