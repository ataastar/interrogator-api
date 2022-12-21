CREATE OR REPLACE FUNCTION get_interrogation_date2(p_1_answer_time bigint, p_2_answer_time bigint) RETURNS bigint
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_answers     RECORD;
BEGIN
  RAISE NOTICE 'times: % %', p_1_answer_time, p_2_answer_time;
  RETURN 0;
END
$$;
