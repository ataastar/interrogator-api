select row_to_json(tl.*)::jsonb
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
from (select tl.translation_link_id      AS "translationLinkId",
             tl.example,
             tl.translated_example       AS "translatedExample",
             utl.next_interrogation_time AS "nextInterrogationTime",
             utl.last_answer_time  AS "lastAnswerTime",
             utl.last_answer_right AS "lastAnswerRight"
      from translation_link tl
             left join user_translation_link utl
                       on tl.translation_link_id = utl.translation_link_id AND utl.user_id = $2) tl
       join unit_content uc on tl."translationLinkId" = uc.translation_link_id AND uc.unit_content_id = $1;
