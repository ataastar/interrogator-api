DROP FUNCTION IF EXISTS add_answer;
CREATE OR REPLACE FUNCTION add_answer(p_unit_content_id BIGINT, p_user_id BIGINT, p_answer_is_right BOOLEAN, p_interrogator_type TEXT) RETURNS BOOLEAN
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_translation_link_id bigint;
  v_from_language_id bigint;
BEGIN
  SELECT translation_link_id, utv.from_language_id INTO v_translation_link_id, v_from_language_id
  FROM unit_content uc
    JOIN unit_tree_view utv on uc.unit_tree_id = utv.unit_tree_id
  WHERE uc.unit_content_id = p_unit_content_id;

  INSERT INTO answer(translation_link_id, user_id, from_language_id, right_answer, interrogation_type)
  VALUES (v_translation_link_id, p_user_id, v_from_language_id, p_answer_is_right, p_interrogator_type);

  call calculate_next_interrogation_date(v_translation_link_id, p_user_id, p_answer_is_right, p_interrogator_type);

  RETURN TRUE;
END
$$;
