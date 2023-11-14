servlet-saml-service-provider: Servlet SAML Service Provider
=============================================================

Level: Beginner
Technologies: Jakarta EE
Summary: JSP Profile Application
Target Product: Red Hat build of Keycloak, <span>JBoss EAP</span>

What is it?
-----------

This quickstart demonstrates how to protect a SAML Service Provider that authenticates using _Red Hat build of Keycloak_. 
Once authenticated the application shows the users profile information.

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
[Red Hat build of Keycloak Getting Started guides]https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/getting_started_guide/index.

For example when using Bare metal, you need to have Java 17 or later available. Then you can unzip _Red Hat build of Keycloak_ distribution and in the directory `bin` run this command:

```shell
./kc.[sh|bat] start-dev --http-port=8180
```

You should be able to access your _Red Hat build of Keycloak_ server at http://localhost:8180.

Log in as the admin user to access the _Red Hat build of Keycloak_ Administration Console. Username should be `admin` and password `admin`.

Import the [realm configuration file](config/realm-import.json) to create a new realm called `quickstart`.
For more details, see the _Red Hat build of Keycloak_ documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

Starting the JBoss EAP Server
-------------------

In order to deploy the example application, you need a JBoss EAP Server up and running. For more details, see the JBoss EAP documentation about how
to [install the server](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/8-beta/html-single/jboss_eap_installation_methods/index).

Make sure the server is accessible from `localhost` and listening on port `8080`.

Once you verified that JBoss EAP server works, it is needed to install SAML adapter into it. You can follow the [SAML Adapter documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/securing_applications_and_services_guide/index#_saml_jboss_adapter)
for the details. Make sure to download and install Jakarta version of the adapter (artifact `keycloak-saml-wildfly-adapter-jakarta-dist`).


Build and Deploy the Quickstart
-------------------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to deploy the quickstart:

   ````
   mvn -Djakarta clean wildfly:deploy
   ````

Access the Quickstart
----------------------

You can access the application with the following URL: <http://localhost:8080/servlet-saml-service-provider>

You should be able to authenticate using any of these users:

| Username | Password | Roles              |
|----------|----------|--------------------|
| alice    | alice    | user               |

Undeploy the Quickstart
--------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to undeploy the quickstart:

````
mvn -Djakarta clean wildfly:undeploy
````

Running tests
--------------------

Make sure _Red Hat build of Keycloak_ is [running](#starting-and-configuring-the-red-hat-build-of-keycloak-server). Also make sure that `quickstart` realm is removed as the test will deploy it during it's execution.

You don't need JBoss EAP running because a temporary server is started during test execution.

1. Open a terminal and navigate to the root directory of this quickstart.

2. Run the following command to build and run tests:

   ````
   mvn -Djakarta clean verify
   ````

References
--------------------

* [Red Hat build of Keycloak SAML Adapter](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/securing_applications_and_services_guide/index#_saml_jboss_adapter)
* [Red Hat build of Keycloak Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)
