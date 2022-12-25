CREATE OR REPLACE PROCEDURE test_clean_all()
  LANGUAGE plpgsql
AS
$$
BEGIN
  TRUNCATE TABLE interrogation_interval;
END;
$$
