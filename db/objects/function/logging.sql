DROP FUNCTION IF EXISTS logging;
CREATE
  OR REPLACE PROCEDURE logging(p_log TEXT)
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO log(log_timestamp, log)
  VALUES (current_timestamp, p_log);
END
$$;

