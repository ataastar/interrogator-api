# interrogator-api
interrogator-api for interrogator front end

Technology
 - Node
 - Express
 - Postgresql
 
RUN the sample.
 - npm install
 - set the PG_OPTION in order to the right schema will be the default: SET PG_OPTIONS={"search_path":"interrogator"}
 - node index.js or run start.bat with the following params
   - database user password
   - host (optionally)
   - web client url (optionally)
   - eg enabled from domain: start.bat password interrogator.mooo.com http://interrogator.mooo.com:4200
     - in this case need to add the following line to the hosts file in order to access the app in the local intranet
       - 192.168.0.81 interrogator.mooo.com
   - eg enabled from remote:
     - start.bat password 192.168.0.81 http://80.98.178.201:4200
     - start.bat password 192.168.0.213 http://80.98.178.201:4200
   - eg enabled just from local:
     - start.bat password 192.168.0.213 // lan
     - start.bat password 192.168.0.81 // wifi
 - Open a browser window and navigate to http:\\\\localhost:3000 to access the app.
 
 
FEATURES
 - retrieves the unit tree
 - retrieves the unit content by unit id
 - inserts unit content
 - removes unit content (translation) from unit

IN PROGRESS
 - handle answer for interrogation
 - update phrase, example sentence

TODO tasks
 - use environment variables for port, hostname
 - check data on insert, in db level
 - improve delete on db level
 - plan user related db and connections
 - plan test results
 
# Heroku

- connect to heroku postgres
heroku pg:psql -a hunenginterrogator

- unit tree insert example
insert into unit_tree (parent_unit_tree_id, name, from_language_id, to_language_id) values (19, '1 My life', null, null);
insert into public."UnitTree" ("ParentUnitTreeId", "Name", "FromLanguageId", "ToLanguageId") values (20, 'B  A surprise for Smart Alec!', null, null);

- get postgre connection url
heroku pg:credentials:url DATABASE -a hunenginterrogator

- application name
hunenginterrogator

- get log
heroku logs -a hunenginterrogator -> heroku.log 

# Qovery
- https://console.qovery.com/
- necessary variable:
  - QOVERY_DATABASE_INTERROGATOR_CONNECTION_URI with /interrogator prefix (database)

# Environment variables
- INTERROGATOR_API_PORT: eg. 3000
- INTERROGATOR_WEB: the web api url. eg. https://localhost:4200
- INTERROGATOR_DATABASE_URL: the DB url connection. eg: postgres://%user%:%pw%@localhost:5432/interrogator
