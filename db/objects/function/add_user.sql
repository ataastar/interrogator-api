DROP FUNCTION add_user;
CREATE OR REPLACE FUNCTION add_user(IN p_email text, IN p_password text)
  RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_id BIGINT;
BEGIN
  INSERT INTO users (email, password)
  VALUES (p_email,
          crypt(p_password, gen_salt('bf')))
  RETURNING user_id INTO v_id;
  RETURN v_id;
END
$$;
