SET pw=%1


REM public schema is used by default
REM SET PG_OPTIONS={"search_path":"public"}
SET INTERROGATOR_API_HOST=localhost
SET INTERROGATOR_WEB_URL=http://localhost:4200

if [%2]==[] goto skip_host
SET INTERROGATOR_API_HOST=%2
SET INTERROGATOR_WEB_URL=http://%2:4200
:skip_host

if [%3]==[] goto skip_web_host
SET INTERROGATOR_WEB_URL=%3
:skip_web_host

SET INTERROGATOR_API_PORT=3000
SET INTERROGATOR_DATABASE_URL=postgres://mata:%pw%@localhost:5432/interrogator
rem SET INTERROGATOR_API_DB_CONN_UNSECURE=true
call node index.js
