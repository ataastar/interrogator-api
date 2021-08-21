CREATE OR REPLACE  VIEW unit_content_json(content, code) AS
SELECT row_to_json(a.*) AS content,
       a.code
FROM (SELECT t.name,
             t.unit_tree_id                                                 AS code,
             (SELECT array_to_json(array_agg(b.*)) AS array_to_json
              FROM (SELECT c.unit_content_id                                                                 AS id,
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationfrom.translation_from_id AS "translationId",
                                         phrase_1.text                       AS phrase
                                  FROM translation_from translationfrom
                                           JOIN phrase phrase_1 ON phrase_1.phrase_id = translationfrom.phrase_id
                                  WHERE translationfrom.translation_link_id = l.translation_link_id) phrase) AS "from",
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationto.translation_to_id AS "translationId",
                                         phrase_1.text                   AS phrase
                                  FROM translation_to translationto
                                           JOIN phrase phrase_1 ON phrase_1.phrase_id = translationto.phrase_id
                                  WHERE translationto.translation_link_id = l.translation_link_id) phrase)   AS "to",
                           l.example,
                           l.translated_example                                                              AS "translatedExample"
                    FROM translation_link l
                             JOIN unit_content c ON c.unit_tree_id = t.unit_tree_id
                    WHERE l.translation_link_id = c.translation_link_id) b) AS words
      FROM unit_tree t) a;

COMMENT ON VIEW unit_content_json IS 'Returns the words/translations for the unit by unit tree id (code)';

