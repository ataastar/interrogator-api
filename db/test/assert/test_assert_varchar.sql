CREATE OR REPLACE PROCEDURE test_assert_varchar(expected VARCHAR, actual VARCHAR)
  LANGUAGE plpgsql
AS
$$
BEGIN
  IF expected != COALESCE(actual, expected || '1') THEN
    RAISE NOTICE 'Expected: %', expected;
    RAISE NOTICE 'Actual  : %', actual;
    RAISE EXCEPTION 'The varchar variables are not equal!';
  END IF;
END;
$$
