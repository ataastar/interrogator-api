SET pw=%1

SET PGUSER=mata
SET PGPASSWORD=%pw%
heroku pg:pull DATABASE_URL interrogator3 --app hunenginterrogator