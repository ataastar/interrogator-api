SELECT row_to_json(a.*) AS content
FROM (SELECT ut.unit_tree_id                           AS code,
             ut.name,
             (select array_to_json(array_agg(row_to_json(tl.*)::jsonb
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
               || jsonb_build_object('unitContentId', uc.unit_content_id)))
              from (select tl.translation_link_id      AS "translationLinkId",
                           tl.example,
                           tl.translated_example       AS "translatedExample",
                           utl.next_interrogation_time AS "nextInterrogationTime",
                           utl.last_answer_time        AS "lastAnswerTime"
                    from translation_link tl
                           left join user_translation_link utl
                                     on tl.translation_link_id = utl.translation_link_id and utl.user_id = $1) tl
                     join unit_content uc on tl."translationLinkId" = uc.translation_link_id
              where uc.unit_tree_id = ut.unit_tree_id) AS translations
      from unit_tree ut
      where ut.unit_tree_id = $2) a
