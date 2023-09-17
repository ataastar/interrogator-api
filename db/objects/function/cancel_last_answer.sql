DROP FUNCTION IF EXISTS cancel_last_answer;
CREATE OR REPLACE FUNCTION cancel_last_answer(p_unit_content_id BIGINT, p_user_id BIGINT,
                                              p_cancelled_answer_right BOOLEAN,
                                              p_interrogator_type TEXT, p_from_language_id BIGINT,
                                              p_answer_time TIMESTAMP without time zone DEFAULT CURRENT_TIMESTAMP) RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_translation_link_id              BIGINT;
  v_last_answer_id                   BIGINT;
  v_last_right_answer                BOOLEAN;
  v_last_interrogation_type          TEXT;
  v_previous_next_interrogation_date TIMESTAMP;
  v_next_interrogation_time TIMESTAMP;
BEGIN
  /*call logging('add_answer: ' || p_unit_content_id || ' ' || p_user_id || ' ' || p_answer_is_right || ' ' ||
               to_char(p_answer_time, 'YYYY.MM.DD H24:MISS.MS'));*/
  --RAISE NOTICE 'p_answer_time: % ', p_answer_time;
  SELECT translation_link_id
  INTO v_translation_link_id
  FROM unit_content uc
         JOIN unit_tree_view utv on uc.unit_tree_id = utv.unit_tree_id
  WHERE uc.unit_content_id = p_unit_content_id;

  --call logging(v_translation_link_id || ' ' || v_from_language_id);
  SELECT interrogation_type, right_answer, answer_id, tl.previous_next_interrogation_date
  INTO v_last_interrogation_type, v_last_right_answer, v_last_answer_id, v_previous_next_interrogation_date
  FROM answer a
         JOIN translation_link tl ON tl.translation_link_id = a.translation_link_id
  WHERE a.translation_link_id = v_translation_link_id
    AND user_id = p_user_id
    AND from_language_id = p_from_language_id
  ORDER BY answer_id DESC
  LIMIT 1;

  -- check that the last answer type and right are the same as the inputs or the previous interrogation is null
  IF v_last_interrogation_type != p_interrogator_type || (v_last_right_answer =
                                                          p_cancelled_answer_right) ||
                                  v_previous_next_interrogation_date IS NULL THEN
    RETURN NULL;
  END IF;

  DELETE FROM answer WHERE answer_id = v_last_answer_id;


  --RAISE NOTICE 'now: %', current_timestamp;
  IF p_cancelled_answer_right THEN
    CALL calculate_next_interrogation_date(v_translation_link_id, p_user_id, NOT p_cancelled_answer_right,
                                           p_interrogator_type, p_answer_time, TRUE);
    SELECT next_interrogation_date
    INTO v_next_interrogation_time
    FROM translation_link
    WHERE translation_link_id = v_translation_link_id;
    RETURN extract(epoch from v_next_interrogation_time);

  ELSE

    UPDATE translation_link
    SET next_interrogation_date          = previous_next_interrogation_date,
        previous_next_interrogation_date = NULL
    WHERE translation_link_id = v_translation_link_id;
    RETURN extract(epoch from v_previous_next_interrogation_date);

  END IF;

END
$$;

COMMENT ON FUNCTION cancel_last_answer IS 'Returns next interrogation time in millis or null if the cancel can not be done. If the answer was false, then the cancel just remove it and restore the previous next interrogation time, so it skip as it was not answered at all. If the answer was right then the cancel change it to false and the next interrogation time will be calculated with it';
