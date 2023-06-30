drop function delete_unit_content;
create function delete_unit_content(p_unit_content_id bigint) returns boolean
  language plpgsql
as
$$
DECLARE
  v_translation_link_id bigint;
  v_phrase_from_id      bigint array;
  v_phrase_to_id        bigint array;
  v_from_language_id    bigint;
  v_to_language_id      bigint;
BEGIN
  -- it removes the translation link (and its children) if no any connection from other unit content
  -- removes phrases (from/to), if no any connection to it

  SELECT uc.translation_link_id, utv.from_language_id, utv.to_language_id
  INTO v_translation_link_id, v_from_language_id, v_to_language_id
  FROM unit_content uc
         JOIN unit_tree_view utv ON uc.unit_tree_id = utv.unit_tree_id
  WHERE uc.unit_content_id = p_unit_content_id
    AND NOT EXISTS (SELECT 1
                    FROM unit_content uc2
                    WHERE uc2.translation_link_id = uc.translation_link_id
                      AND uc2.unit_content_id != uc.unit_content_id);

  -- unit content can be deleted now
  DELETE FROM unit_content WHERE unit_content_id = p_unit_content_id;

  -- if link is used in other unit, then no need to delete anything
  IF v_translation_link_id IS NULL THEN
    RETURN FALSE;
  END IF;

  -- select FROM part
  SELECT array_agg(p.phrase_id)
  INTO v_phrase_from_id
  FROM phrase p
  WHERE p.language_id = v_from_language_id
    AND EXISTS(SELECT 1
               FROM translation tf
               WHERE tf.phrase_id = p.phrase_id
                 AND tf.translation_link_id = v_translation_link_id
                 AND NOT EXISTS(SELECT 1
                                FROM translation tf2
                                WHERE tf2.translation_link_id != tf.translation_link_id
                                  AND tf2.phrase_id = tf.phrase_id));

  -- select TO part
  SELECT array_agg(p.phrase_id)
  INTO v_phrase_to_id
  FROM phrase p
  WHERE p.language_id = v_to_language_id
    AND EXISTS(SELECT 1
               FROM translation tf
               WHERE tf.phrase_id = p.phrase_id
                 AND tf.translation_link_id = v_translation_link_id
                 AND NOT EXISTS(SELECT 1
                                FROM translation tf2
                                WHERE tf2.translation_link_id != tf.translation_link_id
                                  AND tf2.phrase_id = tf.phrase_id));

  DELETE FROM translation WHERE translation_link_id = v_translation_link_id;

  DELETE FROM phrase WHERE phrase_id IN (SELECT unnest(v_phrase_from_id) UNION SELECT unnest(v_phrase_to_id));

  --it is deleted by cascade???
  DELETE FROM translation_link WHERE translation_link_id = v_translation_link_id;

  RETURN TRUE;
END
$$;
