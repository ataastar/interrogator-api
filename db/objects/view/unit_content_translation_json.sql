CREATE OR REPLACE VIEW unit_content_translation_json(unit_content_id, content) AS
select uc.unit_content_id,
       row_to_json(tl.*)::jsonb
         || jsonb_build_object('phrasesByLanguageId',
                               (select jsonb_object_agg(p.language_id, v)
                                from (select g.language_id, jsonb_agg(g.t) v
                                      from (select row_to_json(c.*)::jsonb - 'language_id' t, c.language_id
                                            from (select t.translation_id AS "translationId",
                                                         p.text           AS phrase,
                                                         p.language_id
                                                  from translation t
                                                         join phrase p on t.phrase_id = p.phrase_id
                                                  where t.translation_link_id = tl."translationLinkId") c) g
                                      group by language_id) p))::jsonb
         || jsonb_build_object('unitContentId', uc.unit_content_id) as content
from (select tl.translation_link_id     AS                          "translationLinkId",
             tl.example,
             tl.translated_example      AS                          "translatedExample",
             tl.next_interrogation_date AS                          "nextInterrogationDate",
             (SELECT MAX(answer_time)
              FROM answer a
              WHERE a.translation_link_id = tl.translation_link_id) "lastAnswerTime"
      from translation_link tl) tl
       join unit_content uc on tl."translationLinkId" = uc.translation_link_id;
