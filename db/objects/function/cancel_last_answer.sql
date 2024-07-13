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
  v_previous_next_interrogation_time TIMESTAMP;
  v_next_interrogation_time TIMESTAMP;
BEGIN
  /*call logging('cancel_last_answer: ' || p_unit_content_id || ' ' || p_user_id || ' ' || p_cancelled_answer_right ||
               ' ' ||
               to_char(p_answer_time, 'YYYY.MM.DD H24:MI:SS.MS'));*/
  --RAISE NOTICE 'p_answer_time: % ', p_answer_time;
  SELECT translation_link_id
  INTO v_translation_link_id
  FROM unit_content uc
         JOIN unit_tree_view utv on uc.unit_tree_id = utv.unit_tree_id
  WHERE uc.unit_content_id = p_unit_content_id;

  --call logging(v_translation_link_id || ' ' || v_from_language_id);
  SELECT interrogation_type, right_answer, answer_id, tl.previous_next_interrogation_time
  INTO v_last_interrogation_type, v_last_right_answer, v_last_answer_id, v_previous_next_interrogation_time
  FROM answer a
         JOIN user_translation_link tl ON tl.translation_link_id = a.translation_link_id and tl.user_id = p_user_id
  WHERE a.translation_link_id = v_translation_link_id
    AND a.user_id = p_user_id
    AND from_language_id = p_from_language_id
  ORDER BY answer_id DESC
  LIMIT 1;

  -- check that the last answer type and right are the same as the inputs or the previous interrogation is null
  IF v_last_interrogation_type != p_interrogator_type || (v_last_right_answer =
                                                          p_cancelled_answer_right) ||
                                  v_previous_next_interrogation_time IS NULL THEN
    RETURN NULL;
  END IF;

  --call logging('cancel_last_answer2: ' || v_translation_link_id);

  --RAISE NOTICE 'now: %', current_timestamp;
  IF p_cancelled_answer_right THEN
    -- if the canceled answer was right then we set to wrong/false and re calculate the next interrogation time
    --call logging('cancel_last_answer: ' || 'update previous answer');
    UPDATE answer SET right_answer = FALSE WHERE answer_id = v_last_answer_id;

    CALL calculate_next_interrogation_time(v_translation_link_id, p_user_id, FALSE,
                                           p_interrogator_type, p_answer_time, TRUE);

    /*SELECT next_interrogation_time
    INTO v_next_interrogation_time
    FROM user_translation_link
    WHERE translation_link_id = v_translation_link_id
      and user_id = p_user_id;*/
    RETURN NULL; -- no need to return currently

  ELSE
    call logging('cancel_last_answer: ' || 'delete previous answer');
    DELETE FROM answer WHERE answer_id = v_last_answer_id;

    UPDATE user_translation_link utl
    SET next_interrogation_time          = previous_next_interrogation_time,
        previous_next_interrogation_time = NULL,
        last_answer_right                = (SELECT a.right_answer
                                            FROM answer a
                                            WHERE a.translation_link_id = utl.translation_link_id
                                            ORDER BY a.answer_time DESC
                                            LIMIT 1)
    WHERE translation_link_id = v_translation_link_id
      and user_id = p_user_id;
    RETURN NULL; -- extract(epoch from current_timestamp);

  END IF;

END
$$;

COMMENT ON FUNCTION cancel_last_answer IS 'Returns next interrogation time in millis or null if the cancel can not be done. If the answer was false, then the cancel just remove it and restore the previous next interrogation time, so it skip as it was not answered at all. If the answer was right then the cancel change it to false and the next interrogation time will be calculated with it';
