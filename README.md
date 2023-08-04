# interrogator-api
interrogator-api for interrogator front end

## Technology

- Node JS
 - Express
- Postgresql (JSON)

## How to run the sample
 - npm install
 - node index.js or run start.bat with the following params
   - database user password
   - host (optionally)
   - web client url (optionally)
   - e.g. enabled from domain: start.bat password interrogator.mooo.com http://interrogator.mooo.com:4200
       - in this case need to add the following line to the hosts file in order to access the app in the local intranet
           - 192.168.0.81 interrogator.mooo.com
   - e.g. enabled from remote:
       - start.bat password 192.168.100.14 http://80.98.178.201:4200
       - start.bat password 192.168.100.15 http://80.98.178.201:4200
   - e.g. enabled just from local:
       - start.bat password 192.168.100.14 // lan
       - start.bat password 192.168.100.15 // wifi
 - Open a browser window and navigate to http:\\\\localhost:3000 to access the app.

## Features
 - retrieves the unit tree
 - retrieves the unit content by unit id
- inserts, update unit content
 - removes unit content (translation) from unit
 - add answer right/false

## In progress

- ...

## TODO tasks
 - check data on insert, in db level
 - improve delete on db level
 - plan user related db and connections
 - plan test results

# Environment variables

- INTERROGATOR_API_PORT: eg. 3000
- INTERROGATOR_API_HOST: eg. localhost
- INTERROGATOR_WEB_URL: the web api url. eg. https://localhost:4200
- INTERROGATOR_DATABASE_URL: the DB url connection. eg: postgres://%user%:%pw%@localhost:5432/interrogator
- INTERROGATOR_DATABASE_CONN_UNSECURE: localhost it is true. no need to set if the connection is secure

# API client generation

In the call_open_api_generator.bat file update the `npmVersion` and run the batch file
