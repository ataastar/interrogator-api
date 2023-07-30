DROP VIEW IF EXISTS update_translation;
create or replace function update_translation(json_input json) returns boolean
  language plpgsql
as
$$
DECLARE
  v_input_phrases       json_input_translation_phrase_with_language_id[];
  v_input_phrase        json_input_translation_phrase_with_language_id;
  v_db_phrases          json_input_translation_phrase[];
  v_db_phrase           json_input_translation_phrase;
  v_founded             boolean = false;
  v_translation_link_id bigint;
BEGIN

  SELECT json_input::jsonb ->> 'translationLinkId' INTO v_translation_link_id;

  SELECT array_agg(json_populate_record(null::json_input_translation_phrase_with_language_id, p.a))
  INTO v_input_phrases
  FROM (SELECT json_build_object('languageId', language_id, 'phrase', phrase, 'translationId', "translationId") a
        FROM (SELECT value::jsonb j, key as language_id
              FROM jsonb_each_text((json_input::jsonb ->> 'phrasesByLanguageId')::jsonb)) AS p,
             jsonb_to_recordset(p.j) AS spec(phrase varchar, "translationId" bigint)) p;

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
        WITH insert_result as
               (INSERT INTO phrase (language_id, text)
                 VALUES (v_input_phrase."languageId", v_input_phrase.phrase)
                 RETURNING phrase_id)
        INSERT
        INTO translation (translation_link_id, phrase_id)
        SELECT v_translation_link_id, phrase_id
        FROM insert_result;
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


