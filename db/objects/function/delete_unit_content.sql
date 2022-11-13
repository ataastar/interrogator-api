drop function delete_unit_content;
create function delete_unit_content(p_unit_content_id bigint) returns boolean
  language plpgsql
as
$$
DECLARE
  v_translation_link_id bigint;
  v_phrase_from_id bigint;
  v_phrase_to_id bigint;
BEGIN
  -- it removes the translation link (and its children) if no any connection from other unit content
  -- removes phrases (from/to), if no any connection to it

  SELECT uc.translation_link_id INTO v_translation_link_id
  FROM unit_content uc
  WHERE uc.unit_content_id = p_unit_content_id
    AND NOT EXISTS (SELECT 1 FROM unit_content uc2
                    WHERE uc2.translation_link_id = uc.translation_link_id AND uc2.unit_content_id != uc.unit_content_id);

  -- unit content can be deleted now
  DELETE FROM unit_content WHERE unit_content_id = p_unit_content_id;

  -- if link is used in other unit, then no need to delete anything
  IF v_translation_link_id IS NULL THEN
    RETURN FALSE;
  END IF;

  -- select TO part
  SELECT tf.phrase_id INTO v_phrase_from_id
  FROM translation_from tf
  WHERE tf.translation_link_id = v_translation_link_id
    AND NOT EXISTS (SELECT 1 FROM translation_from tf2
                    WHERE tf2.translation_link_id != tf.translation_link_id AND tf2.phrase_id = tf.phrase_id)
    AND NOT EXISTS (SELECT 1 FROM translation_to tf2
      WHERE tf2.phrase_id = tf.phrase_id);

  -- the FROM link can be deleted, because link will be deleted later
  DELETE FROM translation_from WHERE translation_link_id = v_translation_link_id;
  IF v_phrase_from_id IS NOT NULL THEN
    DELETE FROM phrase WHERE phrase_id = v_phrase_from_id;
  END IF;

  -- select TO part
  SELECT tf.phrase_id INTO v_phrase_to_id
  FROM translation_to tf
  WHERE tf.translation_link_id = v_translation_link_id
    AND NOT EXISTS (SELECT 1 FROM translation_to tf2
                    WHERE tf2.translation_link_id != tf.translation_link_id AND tf2.phrase_id = tf.phrase_id)
    AND NOT EXISTS (SELECT 1 FROM translation_from tf2
                    WHERE tf2.phrase_id = tf.phrase_id);

  -- the TO link can be deleted, because link will be deleted later
  DELETE FROM translation_to WHERE translation_link_id = v_translation_link_id;
  IF v_phrase_to_id IS NOT NULL THEN
    DELETE FROM phrase WHERE phrase_id = v_phrase_to_id;
  END IF;

  DELETE FROM translation_link WHERE translation_link_id = v_translation_link_id;

  RETURN TRUE;
END
$$;
