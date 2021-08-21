CREATE OR REPLACE VIEW word_type_unit_json(groups) AS
SELECT array_to_json(array_agg(unit.* order by code)) AS array_to_json
FROM (SELECT unit_1.name,
             unit_1.word_type_unit_id AS code
      FROM word_type_unit unit_1) unit;

COMMENT ON VIEW unit_group_json IS 'Returns all word type unit';
