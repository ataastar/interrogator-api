DROP VIEW IF EXISTS word_type_unit_content_json;
DROP VIEW IF EXISTS word_type_unit_content;
/*
 {
  "name": "Irregular verbs",
  "forms": ["Infinitive", "Past Tense", "Past Participle"],
  "rows": [
    {
      "id": "1",
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

CREATE OR REPLACE VIEW word_type_unit_content_json(content, word_type_unit_id, from_language_id) AS

/*
SELECT * FROM word_type_unit wtu
    JOIN word_type_unit_link wtul ON wtul.word_type_unit_id = wtu.word_type_unit_id
    JOIN word_type_link tl ON tl.translation_link_id = wtul.translation_link_id
    JOIN word_type_from wtf ON wtf.translation_link_id = tl.translation_link_id
    JOIN phrase p_from ON p_from.phrase_id = wtf.phrase_id
    JOIN word_type_form_phrase wtfp ON wtfp.translation_link_id = tl.translation_link_id
    JOIN word_type_form wtfo ON wtfo.word_type_form_id = wtfp.word_type_form_id
    JOIN phrase p_to ON p_to.phrase_id = wtfp.phrase_id;
*/



SELECT (SELECT row_to_json(forms.*) AS forms FROM (SELECT array_to_json(array_agg(name order by order_number)) AS forms FROM word_type_form wtfo WHERE wtfo.word_type_id = b_wtu.word_type_id) forms)::jsonb ||
       (SELECT row_to_json(wordtype.*) AS forms FROM (SELECT name AS name FROM word_type wt WHERE wt.word_type_id = b_wtu.word_type_id) wordtype)::JSONB ||
       (SELECT row_to_json(from_phrase.*)
        FROM (SELECT COALESCE(array_to_json(array_agg(phrase.*)), '[]'::JSON) as "rows"
              FROM (SELECT wtfr.translation_link_id            id,
                           array_to_json(array_agg(p.text)) AS "fromPhrases",
                           (SELECT array_to_json(array_agg(fp))
                            FROM (SELECT json_build_object(wtf.name, array_to_json(array_agg(p.text)))::JSONB fp
                                  FROM word_type_unit_link wtul
                                         JOIN word_type_form_phrase wtfp
                                              ON wtfp.translation_link_id = wtul.translation_link_id
                                         JOIN word_type_form wtf ON wtfp.word_type_form_id = wtf.word_type_form_id
                                         JOIN phrase p ON wtfp.phrase_id = p.phrase_id
                                  WHERE wtul.word_type_unit_id = b_wtu.word_type_unit_id
                                    AND wtfp.translation_link_id = wtfr.translation_link_id
                                    AND wtf.word_type_id = b_wtu.word_type_id
                                  GROUP BY wtf.name) t)        "toPhrases"
                    FROM word_type_unit_link wtul2
                           JOIN word_type_from wtfr ON wtfr.translation_link_id = wtul2.translation_link_id
                           JOIN phrase p ON wtfr.phrase_id = p.phrase_id
                           JOIN translation_link tl ON tl.translation_link_id = wtfr.translation_link_id
                    WHERE wtul2.word_type_unit_id = b_wtu.word_type_unit_id
                      AND p.language_id = b_l.language_id
                    GROUP BY wtfr.translation_link_id) phrase
             ) AS from_phrase
       )::JSONB AS content ,
       b_wtu.word_type_unit_id, b_l.language_id from_languge_id
FROM word_type_unit b_wtu
         CROSS JOIN language b_l;

COMMENT ON VIEW word_type_unit_content_json IS 'Returns the words/translations with word type forms for the specified word type unit and from language id';

