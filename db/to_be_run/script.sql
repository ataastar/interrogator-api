ALTER TABLE phrase ALTER COLUMN text SET NOT NULL;

call insert_word_type_form(ARRAY['harap'], 2, ARRAY[ROW('bite', 1), ROW('bit', 2), ROW('bitten', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ég', 'éget'], 2, ARRAY[ROW('burn', 1), ROW('burnt', 2), ROW('burnt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ás'], 2, ARRAY[ROW('dig', 1), ROW('dug', 2), ROW('dug', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['növekszik'], 2, ARRAY[ROW('grow', 1), ROW('grew', 2), ROW('grown', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['szagol'], 2, ARRAY[ROW('smell', 1), ROW('smelt', 2), ROW('smelt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['varázsol'], 2, ARRAY[ROW('spell', 1), ROW('spelt', 2), ROW('spelt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['söpör'], 2, ARRAY[ROW('sweep', 1), ROW('swept', 2), ROW('swept', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['könnyezik'], 2, ARRAY[ROW('tear', 1), ROW('tore', 2), ROW('torn', 3)]::word_type_form_phrase_data[]);

CREATE TABLE word_type_unit
(
    word_type_unit_id bigint generated always as identity (maxvalue 9999999)
        constraint word_type_unit_pkey primary key,
    word_type_id bigint not null constraint  fk_wtu_wt_id references word_type,
    name varchar(50) not null
);
CREATE TABLE word_type_unit_link
(
    word_type_link_id bigint not null constraint  fk_wtul_wtl_id references word_type_link,
    word_type_unit_id bigint not null constraint fk_wtul_wtu_id references word_type_unit
);
ALTER TABLE word_type_unit_link
    ADD CONSTRAINT word_type_unit_link_pk
        UNIQUE (word_type_unit_id, word_type_link_id);

INSERT INTO word_type_unit (name, word_type_id) values ('Part 1', 1);
INSERT INTO word_type_unit (name, word_type_id) values ('Part 2', 1);
INSERT INTO word_type_unit (name, word_type_id) values ('Part 3', 1);
INSERT INTO word_type_unit (name, word_type_id) values ('Part 4', 1);
