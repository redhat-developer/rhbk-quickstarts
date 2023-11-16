jakarta-servlet-authz-client: Servlet Application Using Fine-grained Authorization
================================================

Level: Beginner  
Technologies: Jakarta EE
Summary: Servlet application protected with Elytron OIDC and _Red Hat build of Keycloak_ Authorization Services  
Target Product: Red Hat build of Keycloak, <span>JBoss EAP</span>

What is it?
-----------

This quickstart demonstrates how to enable fine-grained authorization to a Jakarta Servlet application in order to protect
specific resources and build a dynamic menu based on the permissions obtained from a _Red Hat build of Keycloak_ Server.

For this application, users can be regular users, premium users or administrators, where:

* Regular users have very limited access.
    * They are allowed to access the main page ([src/main/webapp/index.jsp](src/main/webapp/index.jsp)) and the page that generates a dynamic menu ([src/main/webapp/protected/dynamicMenu.jsp](src/main/webapp/protected/dynamicMenu.jsp))
* Premium users have access to the *premium area*
    * They are allowed to access a specific set of pages for premium users ([src/main/webapp/protected/premium](src/main/webapp/protected/premium)
* Administrators have access to the *administration area*
    * They are allowed to access a specific set of pages for administrators ([src/main/webapp/protected/admin](src/main/webapp/protected/admin))

The dynamic menu is built based on the permissions obtained from the server and using the `AuthorizationContext` object to
determine the resources and scopes the user is allowed to access.

You'll also learn how to use the `AuthorizationContext` object to obtain permissions granted by the server and perform additional checks in the application.

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
For more details, see the _Red Hat build of Keycloak_ documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

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
----------------------

You can access the application with the following URL: <http://localhost:8080/jakarta-servlet-authz-client>.

Try to authenticate with any of these users:

| Username | Password | Roles              |
|----------|----------|--------------------|
| alice    | alice    | user               |
| jdoe     | jdoe     | user, user_premium |
| admin    | admin    | admin              |

If you want to play around, try the following steps:

* Add `user_premium` to `alice` and see if she is now able to access premium resources as well if the dynamic menu changes and display `Do user premium thing`
* Grant to `alice` the necessary permission to access administrative resources.
    * Open the _Red Hat build of Keycloak_ admin console and make sure the `quickstart` realm is selected
    * Click on `Clients` on the left-side menu and select `jakarta-servlet-authz-client` client
    * Click on `Authorization` tab and then click the `Policies` tab
    * On the `Policies` tab, create a new `User-based Policy` by selecting `alice` user. Name this policy as `Only Alice Policy`
    * Click on `Permissions` tab and select `Administrative Resource Permission`
        * Add `Only Alice Policy` policy to the `Apply Policy` field
        * Change `Decision Strategy` from `Unanimous` to `Affirmative`. Click `Save`
    * Logout and log in again as `alice` user and try to access <http://localhost:8080/jakarta-servlet-authz-client/protected/admin/onlyAdmin.jsp>
* Revoke `alice` administrative permissions by changing the `Only Alice Policy` logic
    * Click on `Policies` tab and select `Only Alice Policy`
        * Change `Logic` field from `Positive` to `Negative`. Click `Save`
    * Logout and log in again as `alice` user and try to access <http://localhost:8080/jakarta-servlet-authz-client/protected/admin/onlyAdmin.jsp>

For more information, please consult the Authorization Services documentation.

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
* [Red Hat build of Keycloak Authorization Services](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/authorization_services_guide/index)
* [Red Hat build of Keycloak Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)
