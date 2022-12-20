CREATE OR REPLACE FUNCTION add_user(IN email text, IN password text)
  RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_id BIGINT;
BEGIN
  INSERT INTO users (email, password)
  VALUES (email,
          crypt(password, gen_salt('bf'))) RETURNING user_id, v_id;
  RETURN v_id;
END
$$;
