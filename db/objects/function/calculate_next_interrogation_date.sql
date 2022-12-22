CREATE OR REPLACE PROCEDURE calculate_next_interrogation_date(p_translation_link_id bigint, p_user_id bigint,
                                                              p_answer_is_right boolean, p_interrogator_type text)
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_right_count INT = 0;
  v_10_minutes INT = 60 * 10;
  v_1_hour INT = 60 * 60;
  v_now timestamp = now();

  v_10_minutes_after TIMESTAMP = TO_TIMESTAMP( EXTRACT(EPOCH FROM v_now) + v_10_minutes);
  v_1_hour_after TIMESTAMP = TO_TIMESTAMP( EXTRACT(EPOCH FROM v_now) + v_1_hour);
  v_first_right_answer_time TIMESTAMP;
  v_more_right_answer BOOLEAN;
  v_next_interrogation_date timestamp;
BEGIN
  IF NOT p_answer_is_right THEN
    UPDATE translation_link SET next_interrogation_date = v_now WHERE translation_link_id = p_translation_link_id;
    RETURN;
  END IF;

  SELECT MIN(a.answer_time), MIN(a.answer_id) != MAX(a.answer_id) AS more_right_answer INTO v_first_right_answer_time, v_more_right_answer
  FROM answer a
    LEFT JOIN (SELECT w.answer_time, w.answer_id, w.translation_link_id FROM answer w
               WHERE w.translation_link_id = p_translation_link_id AND NOT w.right_answer ORDER BY w.answer_time DESC, w.answer_id DESC LIMIT 1) w ON w.translation_link_id = p_translation_link_id
  WHERE a.translation_link_id = p_translation_link_id AND a.right_answer AND (w.answer_id IS NULL OR a.answer_time > w.answer_time OR a.answer_time = w.answer_time AND a.answer_id > w.answer_id);
  -- last OR is necessary for the unit tests

  /* if the right answer is saved then at least 1 right answer will be found here
  IF v_right_count = 0 THEN
    UPDATE translation_link SET next_interrogation_date = v_now WHERE translation_link_id = p_translation_link_id AND next_interrogation_date > v_now;
  END IF;*/
  IF NOT v_more_right_answer THEN
    RAISE NOTICE 'v_more_right_answer %', v_more_right_answer;
    UPDATE translation_link SET next_interrogation_date = add_time(v_now, an_hour()) WHERE translation_link_id = p_translation_link_id;
    RETURN;
  END IF;
  --IF v_right_count = 2 THEN
    --v_next_interrogation_date = get_interrogation_date2(v_first_right_answer_time, v_right_answer_timestamps[1]);
  --END IF;
  UPDATE translation_link SET next_interrogation_date = v_next_interrogation_date WHERE translation_link_id = p_translation_link_id;
  RAISE NOTICE 'v_more_right_answer %', v_more_right_answer;
  RAISE NOTICE 'NOW %', v_now;
  RAISE NOTICE 'v_10_minutes_after %', v_10_minutes_after;

END
$$;
