CREATE OR REPLACE FUNCTION create_language(p_name varchar, p_code varchar) RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_language_id BIGINT;
BEGIN
  INSERT INTO language(name, code) VALUES (p_name, p_code) RETURNING language_id INTO v_language_id;
  RETURN v_language_id;
END;
$$
