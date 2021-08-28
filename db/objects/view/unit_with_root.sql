CREATE OR REPLACE  VIEW unit_with_root(unit_tree_id, root_id, root_from_language_id, root_to_language_id) AS
WITH RECURSIVE unitswithroot AS (
    SELECT ut.unit_tree_id,
           ut.parent_unit_tree_id,
           ut.name,
           ut.unit_tree_id     AS rootid,
           ut.from_language_id AS rootfromlanguageid,
           ut.to_language_id   AS roottolanguageid
    FROM unit_tree ut
    WHERE ut.parent_unit_tree_id IS NULL
    UNION
    SELECT child.unit_tree_id,
           child.parent_unit_tree_id,
           child.name,
           p.rootid,
           p.rootfromlanguageid,
           p.roottolanguageid
    FROM unit_tree child
             JOIN unitswithroot p ON child.parent_unit_tree_id = p.unit_tree_id
)
SELECT unitswithroot.unit_tree_id,
       unitswithroot.rootid             AS root_id,
       unitswithroot.rootfromlanguageid AS root_from_language_id,
       unitswithroot.roottolanguageid   AS root_to_language_id
FROM unitswithroot;

COMMENT ON VIEW unit_with_root IS 'Returns the UnitTreeId and its Root UniTreeId and language ids';

