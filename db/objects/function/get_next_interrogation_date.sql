CREATE OR REPLACE FUNCTION get_next_interrogation_date(p_first_right_answer_time TIMESTAMP, p_now TIMESTAMP) RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_elapsed_time BIGINT;
  v_i1 BIGINT;
  v_i2 BIGINT;
  v_m1 BIGINT;
  v_m2 BIGINT;

BEGIN
  --v_elapsed_time
  SELECT elapsed_time, multiplier INTO v_i2, v_m2
  FROM interrogation_interval WHERE v_elapsed_time <= elapsed_time ORDER BY elapsed_time LIMIT 1;

  IF v_i2 IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT elapsed_time, multiplier INTO v_i1, v_m1
  FROM interrogation_interval WHERE v_elapsed_time >= elapsed_time ORDER BY elapsed_time DESC LIMIT 1;

  IF v_i1 IS NULL THEN
    -- TODO get min
  END IF;

  --TODO

END
$$;
