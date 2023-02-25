DROP FUNCTION IF EXISTS logging_date;
CREATE
  OR REPLACE PROCEDURE logging_date(p_log timestamp without time zone)
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO log(log_timestamp, log)
  VALUES (current_timestamp, to_char(p_log, 'YYYY.MM.DD HH24:MI:SS.MS'));
END
$$;

