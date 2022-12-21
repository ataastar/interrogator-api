CREATE OR REPLACE PROCEDURE test_assert(actual BOOLEAN, message VARCHAR)
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF NOT actual THEN
    RAISE NOTICE 'Assertion failed: %', message;
    RAISE EXCEPTION 'Error: %', message;
  END IF;
END;
$$
