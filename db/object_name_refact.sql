alter table "Language" rename to language;
alter table language rename column "LanguageId" to language_id;
alter table language rename column "Name" to name;
alter table language rename column "Code" to code;

alter table "Phrase" rename to phrase;
alter table phrase rename column "PhraseId" to phrase_id;
alter table phrase rename column "LanguageId" to language_id;
alter table phrase rename column "Text" to text;
alter table phrase rename column "Pronunciation" to pronunciation;
alter table phrase rename column "AudioName" to audio_name;

alter table "TranslationFrom" rename to translation_from;
alter table translation_from rename column "TranslationFromId" to translation_from_id;
alter table translation_from rename column "TranslationLinkId" to translation_link_id;
alter table translation_from rename column "PhraseId" to phrase_id;
alter table translation_from rename column "Order" to order_count;

alter table "TranslationTo" rename to translation_to;
alter table translation_to rename column "TranslationToId" to translation_to_id;
alter table translation_to rename column "TranslationLinkId" to translation_link_id;
alter table translation_to rename column "PhraseId" to phrase_id;
alter table translation_to rename column "Order" to order_count;

alter table "TranslationLink" rename to translation_link;
alter table translation_link rename column "TranslationLinkId" to translation_link_id;
alter table translation_link rename column "Example" to example;
alter table translation_link rename column "TranslatedExample" to translated_example;
alter table translation_link rename column "ImageName" to image_name;

alter table "UnitContent" rename to unit_content;
alter table unit_content rename column "UnitContentId" to unit_content_id;
alter table unit_content rename column "UnitTreeId" to unit_tree_id;
alter table unit_content rename column "TranslationLinkId" to translation_link_id;

alter table "UnitTree" rename to unit_tree;
alter table unit_tree rename column "UnitTreeId" to unit_tree_id;
alter table unit_tree rename column "ParentUnitTreeId" to parent_unit_tree_id;
alter table unit_tree rename column "Name" to name;
alter table unit_tree rename column "FromLanguageId" to from_language_id;
alter table unit_tree rename column "ToLanguageId" to to_language_id;

alter table "InsertUnitContentTable" rename to insert_unit_content_table;
alter table insert_unit_content_table rename column "translatedExample" to translated_example;

alter procedure "addAnswer"(bigint, bigint, boolean) rename to add_answer;
alter function "deleteTranslationFrom"(bigint) rename to delete_translation_from;
alter function "deleteUnitContent"(bigint) rename to delete_unit_content;
alter procedure "addRightAnswer"(bigint, bigint) rename to add_right_answer;
alter procedure "addWrongAnswer"(bigint, bigint) rename to add_wrong_answer;

alter table "UnitContentJson" rename to unit_content_json;
alter table "UnitGroupJson" rename to unit_group_json;
alter table "UnitWithRoot" rename to unit_with_root;

drop view unit_with_root;
create view unit_with_root(unit_tree_id, root_id, root_from_language_id, root_to_language_id) as
WITH RECURSIVE unitswithroot AS (
    SELECT ut.unit_tree_id        AS unit_tree_id,
           ut.parent_unit_tree_id AS parent_unit_tree_id,
           ut.name                AS name,
           ut.unit_tree_id        AS rootid,
           ut.from_language_id    AS rootfromlanguageid,
           ut.to_language_id      AS roottolanguageid
    FROM unit_tree ut
    WHERE ut.parent_unit_tree_id IS NULL
    UNION
    SELECT child.unit_tree_id        AS unit_tree_id,
           child.parent_unit_tree_id AS parent_unit_tree_id,
           child.name                AS name,
           p.rootid,
           p.rootfromlanguageid,
           p.roottolanguageid
    FROM unit_tree child
             JOIN unitswithroot p ON child.parent_unit_tree_id = p.unit_tree_id
)
SELECT unitswithroot.unit_tree_id,
       unitswithroot.rootid,
       unitswithroot.rootfromlanguageid,
       unitswithroot.roottolanguageid
FROM unitswithroot;

comment on view unit_with_root is 'Returns the UnitTreeId and its Root UniTreeId and language ids';


drop view unit_group_json;
  create view unit_group_json(groups) as
  SELECT array_to_json(array_agg(a.*)) AS groups
  FROM (SELECT unit_tree.name,
               (SELECT array_to_json(array_agg(unit.*)) AS array_to_json
                FROM (SELECT unit_1.name,
                             unit_1.unit_tree_id AS code
                      FROM unit_tree unit_1
                      WHERE unit_1.parent_unit_tree_id = unit_tree.unit_tree_id) unit) AS "group",
               row_number() OVER ()                                                    AS "order"
        FROM unit_tree
        WHERE unit_tree.parent_unit_tree_id = 1
        ORDER BY unit_tree.name) a;

drop view unit_content_json;
create view unit_content_json(content, code) as
SELECT row_to_json(a.*) AS content,
       a.code
FROM (SELECT t.name,
             t.unit_tree_id                                                 AS code,
             (SELECT array_to_json(array_agg(b.*)) AS array_to_json
              FROM (SELECT c.unit_content_id                                                                 AS id,
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationfrom.translation_from_id AS translation_id,
                                         phrase_1.text                       AS phrase
                                  FROM translation_from translationfrom
                                           JOIN phrase phrase_1
                                                ON phrase_1.phrase_id = translationfrom.phrase_id
                                  WHERE translationfrom.translation_link_id = l.translation_link_id) phrase) AS from,
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationto.translation_to_id AS translation_id,
                                         phrase_1.text                   AS phrase
                                  FROM translation_to translationto
                                           JOIN phrase phrase_1
                                                ON phrase_1.phrase_id = translationto.phrase_id
                                  WHERE translationto.translation_link_id = l.translation_link_id) phrase)   AS to,
                           l.example,
                           l.translated_example                                                              AS translated_example
                    FROM translation_link l
                             JOIN unit_content c ON c.unit_tree_id = t.unit_tree_id
                    WHERE l.translation_link_id = c.translation_link_id) b) AS words
      FROM unit_tree t) a;

drop function delete_unit_content;
create function delete_unit_content(p_unit_content_id bigint) returns boolean
    language plpgsql
as
$$
DECLARE
    deleted_row_count bigint;
BEGIN
    -- it remove all tranlsation link (and its children) if no any connecion from other unit content
-- also for phrases

-- maybe should get the TranslationLink id by the unit content id, if no any connection from unit content
-- and get the phrases by the unit content id, if no any connection from unit content/translation link
-- remove just those record not all for which has not connection
    DELETE FROM unit_content uc
    WHERE uc.unit_content_id = p_unit_content_id;
    GET DIAGNOSTICS deleted_row_count = ROW_COUNT;

    DELETE FROM translation_link tl
    WHERE NOT EXISTS
        (SELECT 1 FROM unit_content uc
         WHERE uc.translation_link_id = tl.translation_link_id);
    DELETE FROM phrase p
    WHERE NOT EXISTS
        (SELECT 1 FROM translation_from tf
         WHERE tf.phrase_id = p.phrase_id)
      AND NOT EXISTS
        (SELECT 1 FROM translation_to tf
         WHERE tf.phrase_id = p.phrase_id);

    RETURN deleted_row_count > 0;
END
$$;

alter function insertunitcontent(json) rename to insert_unit_content;

drop function delete_translation_from(p_translation_from_id bigint);
create function delete_translation_from(p_translation_from_id bigint) returns boolean
    language plpgsql
as
$$
DECLARE
    v_from_count_for_translation_link bigint;
    deleted_row_count             bigint;
BEGIN

    SELECT COUNT(1)
    INTO deleted_row_count
    FROM translation_from tf
    WHERE tf.translation_from_id =p_translation_from_id;

    IF deleted_row_count = 1 THEN
        SELECT COUNT(1)
        INTO v_from_count_for_translation_link
        FROM translation_from tf
        WHERE tf.translation_from_id = p_translation_from_id
          AND EXISTS (SELECT 1
                      FROM translation_from tf2
                      WHERE tf2.translation_from_id <> tf.translation_from_id
                        AND tf2.translation_link_id = tf.translation_link_id);

        IF v_from_count_for_translation_link < 1 THEN
            RAISE 'Last phrase can not be removed. Shall remove the whole translation in this case!';
        END IF;

        DELETE FROM translation_from tf
        WHERE tf.translation_from_id =p_translation_from_id;
        DELETE FROM phrase p
        WHERE NOT EXISTS
            (SELECT 1 FROM translation_from tf
             WHERE tf.phrase_id = p.phrase_id)
          AND NOT EXISTS
            (SELECT 1 FROM translation_to tf
             WHERE tf.phrase_id = p.phrase_id);
    END IF;

    RETURN deleted_row_count > 0;
END;
$$;


drop function insert_unit_content(json_input json);
create function insert_unit_content(json_input json) returns bigint
    language plpgsql
as
$$
DECLARE
    v_unit_content_id bigint;
BEGIN

    --insert into interrogator."tmp_insertjson"(insertjson)
--select json_input;

    with json_data as (
        select * from json_populate_record(
                null::insert_unit_content_table,
                json_input)
    ),
         languages as (select root_from_language_id from_lang_id, root_to_language_id to_lang_id from json_data
                                                                                                join unit_with_root unit on unit.unit_tree_id = json_data.id),
         tl as (insert into translation_link(example, translated_example)
             select example, translated_example from json_data
             RETURNING translation_link_id),
         uc as (insert into unit_content(unit_tree_id, translation_link_id)
             select json_data.id, translation_link_id from json_data, tl
             returning *),
         phraseFrom as (insert into phrase(language_id, text)
             select l.ToLangId, json_array_elements_text("from"::json) from json_data, languages l
             returning *),
         phraseTo as (insert into phrase(language_id, text)
             select l.FromLangId, json_array_elements_text("to"::json) from json_data, languages l
             returning *),
         tFrom as (insert into translation_from(translation_link_id, phrase_id)
             select tl.translation_link_id, phraseFrom.phrase_id from tl, phraseFrom
             returning *),
         tTo as (insert into translation_to(translation_link_id, phrase_id)
             select tl.translation_link_id, phraseTo.phrase_id from tl, phraseTo)
    select uc.unit_content_id into v_unit_content_id from uc;

--insert into interrogator."tmp_insertjson"(insertjson) values (v_unit_content_id);

    return v_unit_content_id;

END;
$$;




