DROP FUNCTION IF EXISTS add_answer;
CREATE OR REPLACE FUNCTION add_answer(p_unit_content_id BIGINT, p_user_id BIGINT, p_answer_is_right BOOLEAN, p_interrogator_type TEXT) RETURNS BOOLEAN
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO answer(translation_link_id, user_id, from_language_id, right_answer, interrogation_type)
  SELECT translation_link_id,
         p_user_id,
         (SELECT MAX(p.language_id)
          FROM translation_from tf
                 JOIN phrase p ON tf.phrase_id = p.phrase_id
          WHERE uc.translation_link_id = tf.translation_link_id),
         p_answer_is_right,
         p_interrogator_type
  FROM unit_content uc
  WHERE uc.unit_content_id = p_unit_content_id;
  RETURN TRUE;
END
$$;
