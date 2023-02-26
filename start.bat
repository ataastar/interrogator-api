SET pw=%1


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
SET INTERROGATOR_DATABASE_URL=postgres://postgres:%pw%@localhost:5432/interrogator
SET INTERROGATOR_DATABASE_CONN_UNSECURE=true
call node index.js
