SET pw=%1

SET PG_OPTIONS={"search_path":"interrogator"}
SET PORT=3000
SET DATABASE_URL=postgres://mata:%pw%@localhost:5432/postgres
SET DATABASE_CONN_UNSECURE=true
call node index.js