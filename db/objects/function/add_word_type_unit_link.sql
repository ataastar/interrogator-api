DROP FUNCTION IF EXISTS add_word_type_unit_link;
CREATE OR REPLACE FUNCTION add_word_type_unit_link(wtl_id BIGINT, wtu_id BIGINT) RETURNS BIGINT
  LANGUAGE PLPGSQL
AS $$
BEGIN

  INSERT INTO word_type_unit_link(word_type_link_id, word_type_unit_id)
  SELECT wtl_id, wtu_id
  WHERE NOT EXISTS (SELECT 1 FROM word_type_unit_link wtul WHERE wtul.word_type_link_id = wtl_id AND wtul.word_type_unit_id = wtu_id);
  RETURN 1;
END;
$$;
