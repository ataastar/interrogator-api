CREATE OR REPLACE PROCEDURE calculate_next_interrogation_date(p_translation_link_id bigint, p_user_id bigint,
                                                              p_answer_is_right boolean, p_interrogator_type text)
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_answers     RECORD;
  v_right_count INT = 0;
  v_30_minutes INT = 60 * 30;
  v_now timestamp = now();
  v_30_minutes_after TIMESTAMP = TO_TIMESTAMP( EXTRACT(EPOCH FROM v_now) + v_30_minutes);
BEGIN
  IF NOT p_answer_is_right THEN
    UPDATE translation_link SET next_interrogation_date = v_now WHERE translation_link_id = p_translation_link_id;
    RETURN;
  END IF;

  FOR v_answers IN
    SELECT *
    FROM answer a
    WHERE translation_link_id = p_translation_link_id
      AND answer_time >
          (SELECT answer_time FROM answer w WHERE w.translation_link_id = p_translation_link_id AND NOT w.right_answer)
    ORDER BY answer_time DESC
    LOOP
      v_right_count = v_right_count + 1;
    END LOOP;
  IF v_right_count = 0 THEN
    UPDATE translation_link SET next_interrogation_date = v_30_minutes_after WHERE translation_link_id = p_translation_link_id;
  END IF;
  RAISE NOTICE 'count %', v_right_count;
  RAISE NOTICE 'NOW %', v_now;
  RAISE NOTICE 'v_30_minutes_after %', v_30_minutes_after;

END
$$;

