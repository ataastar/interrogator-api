SET pw=%1

REM public schema is used by default
REM SET PG_OPTIONS={"search_path":"public"}
SET INTERROGATOR_API_PORT=3000
SET INTERROGATOR_WEB_URL=http://localhost:4200
SET INTERROGATOR_DATABASE_URL=postgres://mata:%pw%@localhost:5432/interrogator
rem SET INTERROGATOR_API_DB_CONN_UNSECURE=true
call node index.js
