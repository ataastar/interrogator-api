DROP VIEW IF EXISTS insert_unit_content;
create or replace function insert_unit_content(json_input json) returns bigint
	language plpgsql
as $$
DECLARE
    v_unit_content_id bigint;
BEGIN

    --insert into interrogator."tmp_insertjson"(insertjson)
--select json_input;
    --RAISE NOTICE '%', json_input;

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
             select l.to_lang_id, json_array_elements_text("from"::json) from json_data, languages l
             returning *),
         phraseTo as (insert into phrase(language_id, text)
             select l.from_lang_id, json_array_elements_text("to"::json) from json_data, languages l
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


