CREATE OR REPLACE PROCEDURE calculate_next_interrogation_date(p_translation_link_id bigint, p_user_id bigint,
                                                              p_answer_is_right boolean, p_interrogator_type text)
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_answers     RECORD;
  v_right_count INT = 0;
  v_10_minutes INT = 60 * 10;
  v_1_hour INT = 60 * 60;
  v_now timestamp = now();
  v_10_minutes_after TIMESTAMP = TO_TIMESTAMP( EXTRACT(EPOCH FROM v_now) + v_10_minutes);
  v_1_hour_after TIMESTAMP = TO_TIMESTAMP( EXTRACT(EPOCH FROM v_now) + v_1_hour);
  v_right_answer_timestamps bigint[];
  v_next_interrogation_date timestamp;
BEGIN
  IF NOT p_answer_is_right THEN
    UPDATE translation_link SET next_interrogation_date = v_now WHERE translation_link_id = p_translation_link_id;
    RETURN;
  END IF;

  FOR v_answers IN
    SELECT *
    FROM answer a
    WHERE translation_link_id = p_translation_link_id
      AND EXISTS
          (SELECT 1 FROM answer w
          WHERE w.translation_link_id = p_translation_link_id AND NOT w.right_answer
                  AND a.answer_time > w.answer_time OR a.answer_time = w.answer_time AND a.answer_id > w.answer_id)
    ORDER BY answer_time DESC -- OR is necessary for the unit test
    LOOP
      v_right_answer_timestamps[v_right_count] = EXTRACT(EPOCH FROM v_answers.answer_time);
      --RAISE NOTICE 'v_right_count %', v_right_count;
      --RAISE NOTICE 'v_right_answer_timestamps %', v_right_answer_timestamps[v_right_count];
      --RAISE NOTICE 'v_right_answer_timestamps %', EXTRACT(EPOCH FROM v_answers.answer_time);
      v_right_count = v_right_count + 1;
    END LOOP;
  /* if the right answer is saved then at least 1 right answer will be found here
  IF v_right_count = 0 THEN
    UPDATE translation_link SET next_interrogation_date = v_now WHERE translation_link_id = p_translation_link_id AND next_interrogation_date > v_now;
  END IF;*/
  IF v_right_count = 1 THEN
    UPDATE translation_link SET next_interrogation_date = v_10_minutes_after WHERE translation_link_id = p_translation_link_id;
    RETURN;
  END IF;
  IF v_right_count = 2 THEN
    v_next_interrogation_date = get_interrogation_date2(v_right_answer_timestamps[0], v_right_answer_timestamps[1]);
  END IF;
  UPDATE translation_link SET next_interrogation_date = v_next_interrogation_date WHERE translation_link_id = p_translation_link_id;
  RAISE NOTICE 'count %', v_right_count;
  RAISE NOTICE 'NOW %', v_now;
  RAISE NOTICE 'v_10_minutes_after %', v_10_minutes_after;

END
$$;
