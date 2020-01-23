# interrogator-api
interrogator-api for interrogator front end

Technology
 - Node
 - Express
 - Postgresql
 
RUN the sample.
 -  npm install
 -  set the PG_OPTION in order to the right schema will be the default: SET PG_OPTIONS={"search_path":"interrogator"}
 -  node index.js
 -  Open a browser window and navigate to http:\\\\localhost:3000 to access the app.
 
FEATURES
 - retrieves the unit tree
 - retrieves the unit content by unit id
 - inserts unit content to db
IN PROGRESS
 - remove unit content
TODO tasks
 - check data on insert
 - update phrase
 - remove phase, tranlationLink, unitContent