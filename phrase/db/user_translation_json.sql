select row_to_json(tl.*)::jsonb
         || jsonb_build_object('unitContentId', uc.unit_content_id) as content
from (select utl.next_interrogation_time AS "nextInterrogationTime",
             utl.last_answer_time        AS "lastAnswerTime",
             utl.last_answer_right       AS "lastAnswerRight",
             utl.translation_link_id     AS "translationLinkId"
      from user_translation_link utl
      where utl.user_id = $2) tl
       join unit_content uc on tl."translationLinkId" = uc.translation_link_id AND uc.unit_content_id = $1;
