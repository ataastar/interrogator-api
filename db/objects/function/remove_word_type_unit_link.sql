DROP FUNCTION IF EXISTS remove_word_type_unit_link;
CREATE OR REPLACE FUNCTION remove_word_type_unit_link(tl_id BIGINT, wtu_id BIGINT) RETURNS BOOLEAN
  LANGUAGE PLPGSQL
AS
$$
DECLARE
  deleted_row_count bigint;
BEGIN

  DELETE FROM word_type_unit_link wtul WHERE wtul.translation_link_id = tl_id AND wtul.word_type_unit_id = wtu_id;
  GET DIAGNOSTICS deleted_row_count = ROW_COUNT;
  RETURN deleted_row_count > 0;
END;
$$;


