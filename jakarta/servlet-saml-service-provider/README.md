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
* Red Hat build of Keycloak 24+
* Docker 20+

Starting and Configuring the Keycloak Server
-------------------

To start a _Red Hat build of Keycloak_ Server you can use OpenJDK on Bare Metal, _Red Hat build of Keycloak_ Operator or any other option described in
[Red Hat build of Keycloak Getting Started guides]https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/24.0/html-single/getting_started_guide/index.

For example when using Bare metal, you need to have Java 17 or later available. Then you can unzip _Red Hat build of Keycloak_ distribution and in the directory `bin` run this command:

```shell
./kc.[sh|bat] start-dev --http-port=8180
```

You should be able to access your _Red Hat build of Keycloak_ server at http://localhost:8180.

Log in as the admin user to access the _Red Hat build of Keycloak_ Administration Console. Username should be `admin` and password `admin`.

Import the [realm configuration file](config/realm-import.json) to create a new realm called `quickstart`.
For more details, see the Keycloak documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/24.0/html-single/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

Starting the JBoss EAP Server
-------------------

In order to deploy the example application, you need a JBoss EAP Server up and running. For more details, see the JBoss EAP documentation about how
to [install the server](https://docs.redhat.com/en/documentation/red_hat_jboss_enterprise_application_platform/8.0/html-single/red_hat_jboss_enterprise_application_platform_installation_methods/index).

Once you have JBoss EAP server downloaded somewhere, it is needed to install SAML adapter into it. It can be installed with the usage of Galleon tools. Please follow these instructions:

1. Download JBoss EAP Installation Manager as described in the [EAP documentation](https://docs.redhat.com/en/documentation/red_hat_jboss_enterprise_application_platform/8.0/html-single/red_hat_jboss_enterprise_application_platform_installation_methods/index#proc_downloading-and-installing-jboss-eap-installation-manager-cli-tool_default).

2. Install Keycloak SAML adapter galleon feature pack into JBoss EAP via JBoss EAP Installation manager. It can be done for instance with the command similar to this from the
directory of JBoss EAP Installation Manager (replace environment variables with the proper directories according to your environment):

```
cd $JBOSS_EAP_INSTALLATION_MANAGER/bin
./jboss-eap-installation-manager.sh feature-pack add \
  --fpl org.keycloak:keycloak-saml-adapter-galleon-pack \
  --layers keycloak-client-saml \
  --dir $JBOSS_EAP_DIR
```

3. Start JBoss EAP server and make sure the server is accessible from `localhost` and listening on port `8080`.

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

References
--------------------

* [Keycloak SAML Adapter](https://www.keycloak.org/docs/latest/securing_apps/#_saml_jboss_adapter)
* [Keycloak Documentation](https://www.keycloak.org/documentation)
* [Wildfly SAML documentation](https://docs.wildfly.org/30/WildFly_Elytron_Security.html#Keycloak_SAML_Integration)
