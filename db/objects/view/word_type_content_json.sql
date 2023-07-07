DROP VIEW IF EXISTS word_type_content_json;

/*
 {
  "name": "Irregular verbs",
  "forms": ["Infinitive", "Past Tense", "Past Participle"],
  "wordTypeUnits": [{"id":1, "name": "Part 1"},{"id":2, "name":"Part 2"}]
  "rows": [
    {
      "id": "1",
      "wordTypeUnits": [1,2,3,4]
      "fromPhrases": [
        "lenni"
      ],
      "toPhrases": [
        {
          "Infinitive": [
            "be"
          ]
        },
        {
          "Past Tense": [
            "was",
            "were"
          ]
        },
        {
          "Past Participle": [
            "been"
          ]
        }
      ]
    }
  ]
}
 */

CREATE OR REPLACE VIEW word_type_content_json(content, from_language_id, to_language_id, word_type_id) AS

/*SELECT * FROM word_type t
                  JOIN word_type_form f ON t.word_type_id = f.word_type_id
                  JOIN word_type_form_phrase wtfp on f.word_type_form_id = wtfp.word_type_form_id
                  JOIN word_type_link tl on wtfp.word_type_link_id = tl.word_type_link_id
                  JOIN word_type_from wtf ON tl.word_type_link_id = wtf.word_type_link_id
                  JOIN phrase p_from ON wtf.phrase_id = p_from.phrase_id
                  JOIN phrase p_to ON wtfp.phrase_id = p_to.phrase_id;*/

SELECT (SELECT row_to_json(forms.*) AS forms
        FROM (SELECT array_to_json(array_agg(name order by order_number)) AS forms
              FROM word_type_form wtfo
              WHERE wtfo.word_type_id = b_wt.word_type_id) forms)::jsonb ||
       (SELECT row_to_json("wordTypeUnits".*)
        FROM (SELECT array_to_json(array_agg(json_build_object('id', wtu.word_type_unit_id, 'name', wtu.name))) AS "wordTypeUnits"
              FROM word_type_unit wtu) "wordTypeUnits")::jsonb ||
       (SELECT row_to_json(wordtype.*) AS name
        FROM (SELECT name AS name FROM word_type wt WHERE wt.word_type_id = b_wt.word_type_id) wordtype)::JSONB ||
       (SELECT row_to_json(from_phrase.*)
        FROM (SELECT COALESCE(array_to_json(array_agg(phrase.*)), '[]'::JSON) AS "rows"
              FROM (SELECT wtfr.translation_link_id                                    id,
                           array_to_json(array_agg(p.text)) AS                         "fromPhrases",
                           (SELECT array_to_json(array_agg(fp))
                            FROM (SELECT json_build_object(wtf.name, array_to_json(array_agg(p.text)))::JSONB fp
                                  FROM word_type_form_phrase wtfp
                                         JOIN word_type_form wtf ON wtfp.word_type_form_id = wtf.word_type_form_id
                                         JOIN phrase p ON wtfp.phrase_id = p.phrase_id
                                  WHERE wtfp.translation_link_id = wtfr.translation_link_id
                                    AND wtf.word_type_id = b_wt.word_type_id
                                    AND p.language_id = b_wt.language_id
                                  GROUP BY wtf.name) t)                                "toPhrases",
                           (SELECT array_to_json(array_agg(wtu.word_type_unit_id))
                            FROM word_type_unit_link wtul
                                   JOIN word_type_unit wtu ON wtul.word_type_unit_id = wtu.word_type_unit_id
                            WHERE wtfr.translation_link_id = wtul.translation_link_id) "wordTypeUnitIds"
                    FROM word_type_from wtfr
                           JOIN phrase p ON wtfr.phrase_id = p.phrase_id
                           JOIN translation_link tl ON tl.translation_link_id = wtfr.translation_link_id
                    WHERE p.language_id = b_l.language_id
                    GROUP BY wtfr.translation_link_id) phrase
             ) AS from_phrase
       )::JSONB AS content ,
       b_l.language_id from_languge_id,b_wt.language_id to_languge_id,b_wt.word_type_id
FROM word_type b_wt
         CROSS JOIN language b_l;

COMMENT ON VIEW word_type_content_json IS 'Returns the words/translations with word type forms for the specified word type and from-to language id';
