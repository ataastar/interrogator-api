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
 - inserts unit content
 - removes unit content (translation) from unit

IN PROGRESS
 - update phrase, example sentence

TODO tasks
 - use environment variables for port, hostname
 - check data on insert, in db level
 - improve delete on db level
 - plan user related db and connections
 - plan test results