CREATE OR REPLACE PROCEDURE calculate_next_interrogation_time(p_translation_link_id bigint, p_user_id bigint,
                                                              p_answer_is_right boolean, p_interrogator_type text,
                                                              p_answer_time TIMESTAMP WITHOUT TIME ZONE,
                                                              p_cancel boolean DEFAULT FALSE)
  LANGUAGE plpgsql
AS
$$
DECLARE

  v_first_right_answer_time     TIMESTAMP;
  v_next_interrogation_interval BIGINT;
BEGIN
  IF NOT p_answer_is_right THEN
    INSERT INTO user_translation_link (user_id, translation_link_id, next_interrogation_time,
                                       previous_next_interrogation_time, last_answer_time, last_answer_right)
    VALUES (p_user_id, p_translation_link_id, p_answer_time, null, p_answer_time, p_answer_is_right)
    ON CONFLICT (user_id, translation_link_id)
      DO UPDATE
      SET previous_next_interrogation_time = CASE
                                               WHEN NOT p_cancel THEN user_translation_link.next_interrogation_time END,
          next_interrogation_time          = p_answer_time,
          last_answer_time                 = CASE
                                               WHEN p_cancel THEN user_translation_link.last_answer_time
                                               ELSE p_answer_time END,
          last_answer_right = CASE
                                WHEN p_cancel THEN NOT p_answer_is_right
                                ELSE p_answer_is_right END;
    RETURN;
  END IF;

  SELECT MIN(a.answer_time)
  INTO v_first_right_answer_time
  FROM answer a
         LEFT JOIN (SELECT w.answer_time, w.answer_id, w.translation_link_id
                    FROM answer w
                    WHERE w.translation_link_id = p_translation_link_id
                      AND NOT w.right_answer
                    ORDER BY w.answer_time DESC, w.answer_id DESC
                    LIMIT 1) w ON w.translation_link_id = p_translation_link_id
  WHERE a.translation_link_id = p_translation_link_id
    AND a.right_answer
    AND (w.answer_id IS NULL OR a.answer_time > w.answer_time OR
         a.answer_time = w.answer_time AND a.answer_id > w.answer_id);
  -- last OR is necessary for the unit tests

  /*call logging('calculate_next_interrogation_time: ' || p_translation_link_id || ' ' || p_user_id || ' ' ||
               p_answer_is_right || ' ' ||
               to_char(p_answer_time, 'YYYY.MM.DD H24:MISS.MS'));*/

  v_next_interrogation_interval = get_next_interrogation_interval(v_first_right_answer_time, p_answer_time);

  /*if (v_next_interrogation_interval is not null) then
    call logging('v_next_interrogation_interval: ' || v_next_interrogation_interval);
  else
    call logging('v_next_interrogation_interval is null');
  end if;*/

  INSERT INTO user_translation_link (user_id, translation_link_id, next_interrogation_time,
                                     previous_next_interrogation_time, last_answer_time, last_answer_right)
  VALUES (p_user_id, p_translation_link_id, add_time(p_answer_time, v_next_interrogation_interval),
          null, p_answer_time, p_answer_is_right)
  ON CONFLICT (user_id, translation_link_id)
    DO UPDATE
    SET previous_next_interrogation_time = user_translation_link.next_interrogation_time,
        next_interrogation_time          =
          CASE
            WHEN user_translation_link.next_interrogation_time > p_answer_time
              THEN add_time(user_translation_link.next_interrogation_time, v_next_interrogation_interval)
            ELSE
              add_time(p_answer_time, v_next_interrogation_interval)
            END,
        last_answer_time                 = CASE
                                             WHEN p_cancel THEN user_translation_link.last_answer_time
                                             ELSE p_answer_time END,
        last_answer_right = CASE
                              WHEN p_cancel THEN NOT p_answer_is_right
                              ELSE p_answer_is_right END;

END
$$;
