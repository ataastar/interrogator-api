drop table if exists word_type_form_phrase;
drop table if exists word_type_from;
drop table if exists word_type_link;
drop table if exists word_type_form;
drop table if exists word_type;

create table word_type
(
    word_type_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_pkey primary key,
    language_id bigint not null
        constraint "fk_wt_language"
            references language,
    name varchar(255)
);
COMMENT ON TABLE word_type IS 'Stores a set of words, like irregular verbs';
ALTER TABLE word_type ADD CONSTRAINT wt_language_name UNIQUE (language_id, name);

create table word_type_form
(
    word_type_form_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_form_pkey primary key,
    word_type_id bigint not null
        constraint "fk_wtf_word_type"
            references word_type,
    name varchar(255),
    order_number int
);
COMMENT ON TABLE word_type_form IS 'Stores one piece of set of words, like the irregular verb''s forms: Verb, Past tense, Past participle';
ALTER TABLE word_type_form ADD CONSTRAINT wtf_type_order UNIQUE (word_type_id, order_number);
ALTER TABLE word_type_form ADD CONSTRAINT wtf_type_name UNIQUE (word_type_id, name);

create table word_type_link
(
    word_type_link_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_link_pkey primary key
);
COMMENT ON TABLE word_type_link IS 'Links the word_type_from and the word_type_form_phrase records';

create table word_type_from
(
    word_type_from_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_from_pkey primary key,
    word_type_link_id bigint not null
        constraint "fk_wtfr_word_type_link"
            references word_type_link,
        phrase_id bigint not null
        constraint "fk_wtfr_phrase"
        references phrase,
    word_type_id bigint not null
        constraint "fk_wtfr_word_type"
            references word_type
);
COMMENT ON TABLE word_type_from IS 'Can link more then one from phrases to word type';

create table word_type_form_phrase
(
    word_type_form_phrase_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_form_phrase_pkey primary key,
    word_type_form_id bigint not null
        constraint "fk_wtfp_word_type_form"
            references word_type_form,
    word_type_link_id bigint not null
        constraint "fk_wtfp_word_type_link"
            references word_type_link,
    phrase_id bigint not null
        constraint "fk_wtfp_phrase"
            references phrase
);
COMMENT ON TABLE word_type_form_phrase IS 'Can link the to phrase over the word_type_link';

INSERT INTO word_type(language_id, name)
SELECT language_id, 'Irregular verbs' FROM language WHERE code = 'en';

INSERT INTO word_type_form(word_type_id, name, order_number)
SELECT word_type_id, 'Verb', 1 FROM word_type WHERE name='Irregular verbs';

INSERT INTO word_type_form(word_type_id, name, order_number)
SELECT word_type_id, 'Past Tense', 2 FROM word_type WHERE name='Irregular verbs';

INSERT INTO word_type_form(word_type_id, name, order_number)
SELECT word_type_id, 'Past Participle', 3 FROM word_type WHERE name='Irregular verbs';

CREATE TYPE word_type_form_phrase_data as (phrase varchar, word_type_form_id bigint);


CREATE OR REPLACE PROCEDURE insert_word_type_form(p_from_phrase varchar, p_word_type_form_phrase word_type_form_phrase_data[], p_word_type_link_id bigint default null)
    LANGUAGE plpgsql
AS $$
DECLARE
    l_word_type_id BIGINT;
BEGIN
    -- insert and get the id if it is null
    IF p_word_type_link_id IS NULL THEN
        WITH inserted AS (
        INSERT INTO word_type_link DEFAULT VALUES RETURNING word_type_link_id
        )
        SELECT word_type_link_id INTO p_word_type_link_id FROM inserted;
    END IF;

    -- get the word type from the p_word_type_form_phrase
    SELECT word_type_id INTO l_word_type_id FROM word_type_form f WHERE f.word_type_form_id =  (SELECT word_type_form_id FROM p_word_type_form_phrase LIMIT 1);

    INSERT INTO phrase(language_id, text) VALUES (1, p_from_phrase) -- TODO returning, language

    --
    INSERT INTO word_type_from(word_type_link_id, phrase_id, word_type_id) VALUES (p_word_type_link_id, 0, l_word_type_id); -- TODO
END;
$$;

--alter function insert_unit_content(json) owner to postgres;

