CREATE OR REPLACE VIEW unit_tree_view AS
WITH RECURSIVE unit_tree_view AS (
  SELECT unit_tree_id, name, parent_unit_tree_id, 1 AS level, from_language_id, to_language_id
  FROM unit_tree
  WHERE parent_unit_tree_id IS NULL
  UNION ALL
  SELECT child.unit_tree_id,
         child.name,
         child.parent_unit_tree_id,
         parent.level + 1,
         COALESCE(child.from_language_id, parent.from_language_id) AS from_language_id,
         COALESCE(child.to_language_id, parent.to_language_id)     AS to_language_id
  FROM unit_tree_view parent
         JOIN unit_tree child ON child.parent_unit_tree_id = parent.unit_tree_id
)
SELECT *
FROM unit_tree_view
