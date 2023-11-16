js-spa: Node.js Single Page Application
===================================================

Level: Beginner  
Technologies: JavaScript, HTML5, Node.js  
Summary: Single Page Application protected using the _Red Hat build of Keycloak_ JavaScript Adapter  
Target Product: Red Hat build of Keycloak

What is it?
-----------

This quickstart demonstrates how to write a Single Page Application(SPA) that authenticates
using _Red Hat build of Keycloak_. Once authenticated the application shows how to invoke a service secured with _Red Hat build of Keycloak_.

The static resources are served by Node.js from the [public](public) directory. The same resources can also be deployed
on the web server of your preference.

System Requirements
-------------------

To compile and run this quickstart you will need:

* Node.js 18.16.0+
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

Alternatively, you can create the realm using the following command (it might require first to run `npm install`):

```shell
npm run create-realm
```

Build and Deploy the Quickstart
-------------------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to run the quickstart:

   ````
   npm install
   npm start
   ````

Access the Quickstart
---------------------

You can access the application with the following URL: <http://localhost:8080>.

Try to authenticate with any of these users:

| Username | Password | Roles              |
|----------|----------|--------------------|
| alice    | alice    | user               |
| admin    | admin    | admin              |

Once authenticated, you are redirected to the application and you can perform the following actions:

* Show the Access Token
* Show the ID Token
* Refresh Token
* Logout

Running tests
--------------------

Make sure _Red Hat build of Keycloak_ is [running](#starting-and-configuring-the-red-hat-build-of-keycloak-server). At the same time, the `npm` should be stopped, so there is nothing listening on http://localhost:8080 .

1. The test assumes that `quickstart` realm does not yet exists. If you already imported it as mentioned in previous steps, it may be needed to remove it first.
It can be done by login in admin console, then going to URL like http://localhost:8180/admin/master/console/#/quickstart/realm-settings and then click `Delete` at the `Action` menu on the left top corner.

Alternatively, it can be done by command:
```shell
npm run delete-realm
```

2. Open a terminal and navigate to the root directory of this quickstart.

3. Run the following command to build and run tests:

   ````
   npm test
   ````
   
#### Test troubleshooting

If there is error message like `Executable doesn't exist at /home/yournick/.cache/ms-playwright/chromium-1060/chrome-linux/chrome`, it may be needed to first install playwright with this command:

```shell
npx playwright install
```


References
--------------------

* [Red Hat build of Keycloak JavaScript Adapter](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/html-single/securing_applications_and_services_guide/index#_javascript_adapter)
* [Red Hat build of Keycloak Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)
