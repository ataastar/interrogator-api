CREATE OR REPLACE PROCEDURE test_assert_is_not_null_bigint(actual bigint)
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF actual IS NULL THEN
    RAISE NOTICE 'Actual  : %', actual;
    RAISE EXCEPTION 'The variable should NOT NULL!';
  END IF;
END;
$$
