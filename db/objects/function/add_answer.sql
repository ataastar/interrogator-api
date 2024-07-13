DROP FUNCTION IF EXISTS add_answer;
CREATE OR REPLACE FUNCTION add_answer(p_unit_content_id BIGINT, p_user_id BIGINT, p_answer_is_right BOOLEAN,
                                      p_interrogator_type TEXT, p_from_language_id BIGINT,
                                      p_answer_time TIMESTAMP without time zone DEFAULT CURRENT_TIMESTAMP) RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_translation_link_id     bigint;
  v_next_interrogation_time TIMESTAMP;
BEGIN
  /*call logging('add_answer: ' || p_unit_content_id || ' ' || p_user_id || ' ' || p_answer_is_right || ' ' ||
               to_char(p_answer_time, 'YYYY.MM.DD H24:MISS.MS'));*/
  --RAISE NOTICE 'p_answer_time: % ', p_answer_time;
  SELECT translation_link_id, utv.from_language_id
  INTO v_translation_link_id
  FROM unit_content uc
         JOIN unit_tree_view utv on uc.unit_tree_id = utv.unit_tree_id
  WHERE uc.unit_content_id = p_unit_content_id;

  --call logging(v_translation_link_id || ' ' || v_from_language_id);

  INSERT INTO answer(translation_link_id, user_id, from_language_id, right_answer, interrogation_type, answer_time)
  VALUES (v_translation_link_id, p_user_id, p_from_language_id, p_answer_is_right, p_interrogator_type, p_answer_time);
  --RAISE NOTICE 'now: %', current_timestamp;
  call calculate_next_interrogation_time(v_translation_link_id, p_user_id, p_answer_is_right, p_interrogator_type,
                                         p_answer_time);

  /*SELECT next_interrogation_time
  INTO v_next_interrogation_time
  FROM user_translation_link
  WHERE translation_link_id = v_translation_link_id
    and user_id = p_user_id;*/

  /*if v_next_interrogation_time is null then
    call logging('v_next_interrogation_time is null');
  else
    call logging('v_next_interrogation_time is not null: ' || v_next_interrogation_time);
  end if;*/

  RETURN NULL; -- extract(epoch from v_next_interrogation_time);
END
$$;

COMMENT ON FUNCTION add_answer IS 'Returns next interrogation time in millis';
