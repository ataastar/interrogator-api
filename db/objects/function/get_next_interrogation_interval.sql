--DROP FUNCTION get_next_interrogation_interval;
CREATE OR REPLACE FUNCTION get_next_interrogation_interval(p_first_right_answer_time TIMESTAMP, p_answer_time TIMESTAMP) RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_elapsed_time                BIGINT;
  v_i1                          BIGINT;
  v_i2                          BIGINT;
  v_m1                          BIGINT;
  v_m2                          BIGINT;
  v_next_interrogation_interval BIGINT;
BEGIN
  --call logging_date(p_first_right_answer_time);
  --call logging_date(p_answer_time);
  --RAISE NOTICE 'p_answer_time: %', p_answer_time;
  --RAISE NOTICE 'p_first_right_answer_time: %', p_first_right_answer_time;
  --call logging('p_first_right_answer_time: ' || p_first_right_answer_time);
  --call logging('p_answer_time: ' || p_answer_time);
  v_elapsed_time = extract(epoch from p_answer_time) - extract(epoch from p_first_right_answer_time);
  --RAISE NOTICE 'v_elapsed_time: %', v_elapsed_time;
  --call logging('v_elapsed_time: ' || v_elapsed_time);
  SELECT elapsed_time, multiplier
  INTO v_i2, v_m2
  FROM interrogation_interval
  WHERE v_elapsed_time < elapsed_time
  ORDER BY elapsed_time
  LIMIT 1;

  IF v_i2 IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT elapsed_time, multiplier
  INTO v_i1, v_m1
  FROM interrogation_interval
  WHERE v_elapsed_time >= elapsed_time
  ORDER BY elapsed_time DESC
  LIMIT 1;

  IF v_i1 IS NULL THEN
    SELECT elapsed_time
    INTO v_elapsed_time
    FROM interrogation_interval
    ORDER BY elapsed_time
    LIMIT 1;
    RETURN v_elapsed_time;
  END IF;

  /*RAISE NOTICE 'v_i1: %', v_i1;
  RAISE NOTICE 'v_m1: %', v_m1;
  RAISE NOTICE 'v_i2: %', v_i2;
  RAISE NOTICE 'v_m2: %', v_m2;*/

 /* RAISE NOTICE 'd: %', cast((v_m1 - v_m2) as decimal) / (v_i1 - v_i2);
  RAISE NOTICE 'v_elapsed_time - v_i1: %', (v_elapsed_time - v_i1);
  RAISE NOTICE '(v_elapsed_time - v_i1) * d: %', ((v_elapsed_time - v_i1) * (cast((v_m1 - v_m2) as decimal) / (v_i1 - v_i2)));
  RAISE NOTICE 'v_next_interrogation_interval/v_elapsed_time: %', ( (v_elapsed_time - v_i1) * (cast((v_m1 - v_m2) as decimal) / (v_i1 - v_i2)) + v_m1);
*/
  v_next_interrogation_interval = LEAST(v_elapsed_time * ( (v_elapsed_time - v_i1) * (cast((v_m1 - v_m2) as decimal) / (v_i1 - v_i2)) + v_m1), v_i2 * v_m2);
  --RAISE NOTICE 'v_next_interrogation_interval: %', v_next_interrogation_interval;
  --RAISE NOTICE 'v_next_interrogation_date: %', (add_time(p_answer_time, v_next_interrogation_interval));

  RETURN v_next_interrogation_interval;

END
$$;
