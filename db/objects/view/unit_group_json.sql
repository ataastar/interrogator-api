CREATE OR REPLACE  VIEW unit_group_json(groups) AS
SELECT array_to_json(array_agg(a.*)) AS groups
FROM (SELECT unit_tree.name,
             (SELECT array_to_json(array_agg(unit.*)) AS array_to_json
              FROM (SELECT unit_1.name,
                           unit_1.unit_tree_id AS code
                    FROM unit_tree unit_1
                    WHERE unit_1.parent_unit_tree_id = unit_tree.unit_tree_id) unit) AS "units",
             row_number() OVER ()                                                    AS "order"
      FROM unit_tree
      WHERE unit_tree.parent_unit_tree_id = 19
      ORDER BY unit_tree.name) a;

COMMENT ON VIEW unit_group_json IS 'Returns all unit';
