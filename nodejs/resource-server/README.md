nodejs-resource-server: Node.js Resource Server
===================================================

Level: Beginner  
Technologies: Node.js  
Summary: Node.js Service  
Target Product: <span>RHBK</span>

What is it?
-----------

This quickstart demonstrates how to write a RESTful service with Node.js that is secured with <span>RHBK</span>.

There are 3 endpoints exposed by the service:

* `public` - requires no authentication
* `secured` - can be invoked by users with the `user` role
* `admin` - can be invoked by users with the `admin` role

The endpoints are very simple and will only return a simple message stating what endpoint was invoked.

System Requirements
-------------------

To compile and run this quickstart you will need:

* Node.js 18.16.0+
* RHBK 22+

Starting and Configuring the RHBK Server
-------------------

To start a RHBK Server you can use OpenJDK on Bare Metal, RHBK Operator or any other option described in
[RHBK Getting Started guides]https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/getting_started_guide/index.

For example when using Bare metal, you need to have Java 17 or later available. Then you can unzip RHBK distribution and in the directory `bin` run this command:

```shell
./kc.[sh|bat] start-dev --http-port=8180
```

You should be able to access your RHBK server at http://localhost:8180.

Log in as the admin user to access the RHBK Administration Console. Username should be `admin` and password `admin`.

Import the [realm configuration file](config/realm-import.json) to create a new realm called `quickstart`.
For more details, see the RHBK documentation about how to [create a new realm](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/server_administration_guide/index#proc-creating-a-realm_server_administration_guide).

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

There are 3 endpoints exposed by the service:

* http://localhost:3000/public - requires no authentication
* http://localhost:3000/secured - can be invoked by users with the `user` role
* http://localhost:3000/admin - can be invoked by users with the `admin` role

You can open the public endpoint directly in the browser to test the service. The two other endpoints are protected and require
invoking them with a bearer token.

To invoke the protected endpoints using a bearer token, your client needs to obtain an OAuth2 access token from a RHBK server.
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
curl -X POST http://127.0.0.1:8180/realms/quickstart/protocol/openid-connect/token \
-H 'content-type: application/x-www-form-urlencoded' \
-d 'client_id=test-cli' \
-d 'username=alice&password=alice&grant_type=password' | jq --raw-output '.access_token' \
)
```

You can use the same command to obtain tokens on behalf of user `admin`, just make sure to change both `username` and `password` request parameters.

After running the command above, you can now access the `http://127.0.0.1:3000/secured` endpoint
because the user `alice` has the `user` role.

```shell
curl http://localhost:3000/secured \
  -H "Authorization: Bearer "$access_token
```

As a result, you will see the following response from the service:

```json
{"message":"secured"}
```

Running tests
--------------------

Make sure RHBK is [running](#starting-and-configuring-the-rhbk-server). Also make sure that node server is still listening on http://localhost:3000 .

1. Open a terminal and navigate to the root directory of this quickstart.

2. Run the following command to build and run tests:

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

* [RHBK Node.js Adapter](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/securing_applications_and_services_guide/index#_javascript_adapter)
* [RHBK Documentation](https://access.redhat.com/documentation/en-us/red_hat_build_of_keycloak/22.0/)