CREATE OR REPLACE PROCEDURE test_create_language()
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_language_id BIGINT;
  v_name VARCHAR;
  v_code VARCHAR;
BEGIN
  v_language_id = create_language('test', 'TT');
  SELECT name, code INTO v_name, v_code FROM language;
  call test_assert_varchar('test', v_name);
  call test_assert_varchar('TT', v_code);
  call test_assert_is_not_null_bigint(v_language_id);
  ROLLBACK;
END;
$$
