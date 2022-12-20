CREATE OR REPLACE FUNCTION create_unit_tree(p_parent_id BIGINT, p_name varchar, p_from_language_id BIGINT, p_to_language_id BIGINT)
RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_unit_tree_id BIGINT;
BEGIN
  INSERT INTO unit_tree(parent_unit_tree_id, name, from_language_id, to_language_id)
  VALUES (p_parent_id, p_name, p_from_language_id, p_to_language_id) RETURNING unit_tree_id INTO v_unit_tree_id;
  RETURN v_unit_tree_id;
END;
$$
