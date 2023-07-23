DROP VIEW IF EXISTS update_translation;
create or replace function update_translation(json_input json) returns boolean
  language plpgsql
as
$$
DECLARE
  v_input_phrases       json_input_translation_phrase[];
  v_input_phrase        json_input_translation_phrase;
  v_db_phrases          json_input_translation_phrase[];
  v_db_phrase           json_input_translation_phrase;
  v_founded             boolean = false;
  v_translation_link_id bigint  = false;
BEGIN

  SELECT json_input::jsonb ->> 'translationLinkId' INTO v_translation_link_id;

  select array_agg(spec::json_input_translation_phrase)
  INTO v_input_phrases
  from (select value::jsonb j
        from jsonb_each_text((json_input::jsonb ->> 'phrasesByLanguageId')::jsonb)) as p,
       jsonb_to_recordset(p.j) as spec(phrase varchar, "translationId" bigint);

  select array_agg(l::json_input_translation_phrase)
  INTO v_db_phrases
  from (select p.text as phrase, t.translation_link_id
        from translation t
               join phrase p on t.phrase_id = p.phrase_id
        where t.translation_link_id = v_translation_link_id) l;

  -- delete which are not in the input
  FOREACH v_db_phrase SLICE 0 IN ARRAY v_db_phrases
    LOOP
      FOREACH v_input_phrase SLICE 0 IN ARRAY v_input_phrases
        LOOP
          IF v_db_phrase."translationId" = v_input_phrase."translationId" THEN
            v_founded = TRUE;
          end if;
        END LOOP;
      IF NOT v_founded THEN
        DELETE FROM translation WHERE translation.translation_id = v_db_phrase."translationId";
      end if;
      v_founded = FALSE;
    END LOOP;

  -- insert if new or update
  FOREACH v_input_phrase SLICE 0 IN ARRAY v_input_phrases
    LOOP
      IF v_input_phrase."translationId" IS NULL THEN
        INSERT INTO translation (translation_link_id, phrase_id) VALUES (v_translation_link_id, v_input_phrase.phrase);
      ELSE
        UPDATE phrase p
        SET text = v_input_phrase.phrase
        FROM translation t
        WHERE t.phrase_id = p.phrase_id
          AND t.translation_id = v_input_phrase."translationId";
      end if;

    END LOOP;
  return TRUE;

END;
$$;


