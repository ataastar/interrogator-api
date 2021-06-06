SET pw=%1

REM public schema is used by default
REM SET PG_OPTIONS={"search_path":"public"}
SET PORT=3000
SET DATABASE_URL=postgres://mata:%pw%@localhost:5432/interrogator
SET DATABASE_CONN_UNSECURE=true
call node index.js