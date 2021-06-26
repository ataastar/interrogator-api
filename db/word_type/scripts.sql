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

CREATE OR REPLACE PROCEDURE insert_word_type_form(p_from_phrase varchar[], p_from_language_id bigint, p_word_type_form_phrase word_type_form_phrase_data[], p_word_type_link_id bigint default null)
    LANGUAGE plpgsql
AS $$
DECLARE
    l_word_type_id BIGINT;
    l_to_language_id BIGINT;
    l_word_type_form_phrase RECORD;
    l_phrase_id BIGINT;
BEGIN
    -- insert and get the id if it is null
    IF p_word_type_link_id IS NULL THEN
        WITH inserted AS (
        INSERT INTO word_type_link DEFAULT VALUES RETURNING word_type_link_id
        )
        SELECT word_type_link_id INTO p_word_type_link_id FROM inserted;
    END IF;

    -- gets the word type by the p_word_type_form_phrase first item
    SELECT word_type_id INTO l_word_type_id FROM word_type_form f WHERE f.word_type_form_id = (SELECT p.word_type_form_id FROM UNNEST(p_word_type_form_phrase) p LIMIT 1);

    -- gets the to language id by the p_word_type_form_phrase first item
    SELECT language_id INTO l_to_language_id
        FROM word_type_form wtf
        JOIN word_type wt ON wt.word_type_id = wtf.word_type_id
    WHERE wtf.word_type_form_id = (SELECT p.word_type_form_id FROM UNNEST(p_word_type_form_phrase) p LIMIT 1);

    WITH from_phrase AS (
        INSERT INTO phrase (language_id, text) SELECT p_from_language_id, * FROM UNNEST(p_from_phrase) RETURNING phrase_id
    )
    INSERT INTO word_type_from(word_type_link_id, phrase_id, word_type_id) SELECT p_word_type_link_id, phrase_id, l_word_type_id FROM from_phrase;

    -- insert to phrases and word_type_form_phrases
    FOR l_word_type_form_phrase IN SELECT * FROM UNNEST(p_word_type_form_phrase)
        LOOP
            INSERT INTO phrase(language_id, text) VALUES(l_to_language_id, l_word_type_form_phrase.phrase) RETURNING phrase_id INTO l_phrase_id;
            INSERT INTO word_type_form_phrase(word_type_form_id, word_type_link_id, phrase_id) VALUES(l_word_type_form_phrase.word_type_form_id, p_word_type_link_id, l_phrase_id);
        END LOOP;
END;
$$;

call insert_word_type_form(ARRAY['lenni'], 2, ARRAY[ROW('be', 1), ROW('was', 2), ROW('were',2), ROW('been', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['üt', 'legyőz', 'megver'], 2, ARRAY[ROW('beat', 1), ROW('beat', 2), ROW('beaten', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['válik vmivé'], 2, ARRAY[ROW('become', 1), ROW('became', 2), ROW('become', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elkezd', 'elkezdődik'], 2, ARRAY[ROW('begin', 1), ROW('began', 2), ROW('begun', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['eltör', 'eltörik'], 2, ARRAY[ROW('break', 1), ROW('broke', 2), ROW('broken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['hoz'], 2, ARRAY[ROW('bring', 1), ROW('brought', 2), ROW('brought', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['épít'], 2, ARRAY[ROW('build', 1), ROW('built', 2), ROW('built', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['megvesz'], 2, ARRAY[ROW('buy', 1), ROW('bought', 2), ROW('bought', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elkap', 'elfog'], 2, ARRAY[ROW('catch', 1), ROW('caught', 2), ROW('caught', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['választ', 'kiválaszt'], 2, ARRAY[ROW('choose', 1), ROW('chose', 2), ROW('chosen', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['jön'], 2, ARRAY[ROW('come', 1), ROW('came', 2), ROW('come', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['kerül vmibe'], 2, ARRAY[ROW('cost', 1), ROW('cost', 2), ROW('cost', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['vág'], 2, ARRAY[ROW('cut', 1), ROW('cut', 2), ROW('cut', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['csinál'], 2, ARRAY[ROW('do', 1), ROW('did', 2), ROW('done', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['rajzol', 'húz'], 2, ARRAY[ROW('draw', 1), ROW('drew', 2), ROW('drawn', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['álmodik'], 2, ARRAY[ROW('dream', 1), ROW('dreamt', 2), ROW('dreamed',2), ROW('dreamt', 3), ROW('dreamed',3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['iszik'], 2, ARRAY[ROW('drink', 1), ROW('drank', 2), ROW('drunk', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['vezet'], 2, ARRAY[ROW('drive', 1), ROW('drove', 2), ROW('driven', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['eszik'], 2, ARRAY[ROW('eat', 1), ROW('ate', 2), ROW('eaten', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['esik'], 2, ARRAY[ROW('fall', 1), ROW('fell', 2), ROW('fallen', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['etet'], 2, ARRAY[ROW('feed', 1), ROW('fed', 2), ROW('fed', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['érez'], 2, ARRAY[ROW('feel', 1), ROW('felt', 2), ROW('felt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['harcol'], 2, ARRAY[ROW('fight', 1), ROW('fought', 2), ROW('fought', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['talál'], 2, ARRAY[ROW('find', 1), ROW('found', 2), ROW('found', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['repül'], 2, ARRAY[ROW('fly', 1), ROW('flew', 2), ROW('flown', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elfelejt'], 2, ARRAY[ROW('forget', 1), ROW('forgot', 2), ROW('forgotten', 3), ROW('forgot',3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['kap', 'megeszerez'], 2, ARRAY[ROW('get', 1), ROW('got', 2), ROW('got', 3), ROW('gotten',3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ad'], 2, ARRAY[ROW('give', 1), ROW('gave', 2), ROW('given', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['megy'], 2, ARRAY[ROW('go', 1), ROW('went', 2), ROW('gone', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['akaszt', 'lóg', 'felakaszt'], 2, ARRAY[ROW('hang', 1), ROW('hung', 2), ROW('hung', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['birtokol'], 2, ARRAY[ROW('have', 1), ROW('had', 2), ROW('had', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['hall'], 2, ARRAY[ROW('hear', 1), ROW('heard', 2), ROW('heard', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elrejt', 'elbújik'], 2, ARRAY[ROW('hide', 1), ROW('hid', 2), ROW('hidden', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['üt'], 2, ARRAY[ROW('hit', 1), ROW('hit', 2), ROW('hit', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['tart', 'megfog'], 2, ARRAY[ROW('hold', 1), ROW('held', 2), ROW('held', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['megsért', 'bánt'], 2, ARRAY[ROW('hurt', 1), ROW('hurt', 2), ROW('hurt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['tart'], 2, ARRAY[ROW('keep', 1), ROW('kept', 2), ROW('kept', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['tud', 'ismer'], 2, ARRAY[ROW('know', 1), ROW('knew', 2), ROW('known', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['megtanul', 'megtud'], 2, ARRAY[ROW('learn', 1), ROW('learnt', 2), ROW('learnt', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elmegy', 'elindul', 'otthagy'], 2, ARRAY[ROW('leave', 1), ROW('left', 2), ROW('left', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['kölcsönad'], 2, ARRAY[ROW('lend', 1), ROW('lent', 2), ROW('lent', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['hagy'], 2, ARRAY[ROW('let', 1), ROW('let', 2), ROW('let', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['fekszik'], 2, ARRAY[ROW('lie', 1), ROW('lay', 2), ROW('lain', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elveszít'], 2, ARRAY[ROW('lose', 1), ROW('lost', 2), ROW('lost', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['készít'], 2, ARRAY[ROW('make', 1), ROW('made', 2), ROW('made', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['jelent vmit', 'ért vmit vhogyan', 'szándékozik'], 2, ARRAY[ROW('mean', 1), ROW('meant', 2), ROW('meant', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['találkozik'], 2, ARRAY[ROW('meet', 1), ROW('met', 2), ROW('met', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY[''], 2, ARRAY[ROW('overtake', 1), ROW('overtook', 2), ROW('overtaken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['fizet'], 2, ARRAY[ROW('pay', 1), ROW('paid', 2), ROW('paid', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['tesz', 'rak'], 2, ARRAY[ROW('put', 1), ROW('put', 2), ROW('put', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['olvas'], 2, ARRAY[ROW('read', 1), ROW('read', 2), ROW('read', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['lovagol'], 2, ARRAY[ROW('ride', 1), ROW('rode', 2), ROW('ridden', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['csönget'], 2, ARRAY[ROW('ring', 1), ROW('rang', 2), ROW('rung', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['emelkedik', 'kel'], 2, ARRAY[ROW('rise', 1), ROW('rose', 2), ROW('risen', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['fut'], 2, ARRAY[ROW('run', 1), ROW('ran', 2), ROW('run', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['mond'], 2, ARRAY[ROW('say', 1), ROW('said', 2), ROW('said', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['lát'], 2, ARRAY[ROW('see', 1), ROW('saw', 2), ROW('seen', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elad'], 2, ARRAY[ROW('sell', 1), ROW('sold', 2), ROW('sold', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elküld', 'küld'], 2, ARRAY[ROW('send', 1), ROW('sent', 2), ROW('sent', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['beállít', 'helyet'], 2, ARRAY[ROW('set', 1), ROW('set', 2), ROW('set', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ráz'], 2, ARRAY[ROW('shake', 1), ROW('shook', 2), ROW('shaken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['süt', 'ragyog'], 2, ARRAY[ROW('shine', 1), ROW('shone', 2), ROW('shone', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['mutat', 'prezentál'], 2, ARRAY[ROW('show', 1), ROW('showed', 2), ROW('shown', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['bezár'], 2, ARRAY[ROW('shut', 1), ROW('shut', 2), ROW('shut', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['énekel'], 2, ARRAY[ROW('sing', 1), ROW('sang', 2), ROW('sung', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['elsüllyed'], 2, ARRAY[ROW('sink', 1), ROW('sank', 2), ROW('sunk', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ül', 'leül'], 2, ARRAY[ROW('sit', 1), ROW('sat', 2), ROW('sat', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['alszik'], 2, ARRAY[ROW('sleep', 1), ROW('slept', 2), ROW('slept', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['csúszik', 'megcsúszik'], 2, ARRAY[ROW('slide', 1), ROW('slid', 2), ROW('slid', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['beszél'], 2, ARRAY[ROW('speak', 1), ROW('spoke', 2), ROW('spoken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['költ'], 2, ARRAY[ROW('spend', 1), ROW('spent', 2), ROW('spent', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['áll'], 2, ARRAY[ROW('stand', 1), ROW('stood', 2), ROW('stood', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['lop'], 2, ARRAY[ROW('steal', 1), ROW('stole', 2), ROW('stolen', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ragaszt'], 2, ARRAY[ROW('stick', 1), ROW('stuck', 2), ROW('stuck', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['úszik'], 2, ARRAY[ROW('swim', 1), ROW('swam', 2), ROW('swum', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['visz', 'rak', 'tesz'], 2, ARRAY[ROW('take', 1), ROW('took', 2), ROW('taken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['tanít'], 2, ARRAY[ROW('teach', 1), ROW('taught', 2), ROW('taught', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['mond', 'megmond', 'elmesél'], 2, ARRAY[ROW('tell', 1), ROW('told', 2), ROW('told', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['gondol'], 2, ARRAY[ROW('think', 1), ROW('thought', 2), ROW('thought', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['dob'], 2, ARRAY[ROW('throw', 1), ROW('threw', 2), ROW('thrown', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['megért'], 2, ARRAY[ROW('understand', 1), ROW('understood', 2), ROW('understood', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ébred', 'ébreszt'], 2, ARRAY[ROW('wake', 1), ROW('woke', 2), ROW('woken', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['visel'], 2, ARRAY[ROW('wear', 1), ROW('wore', 2), ROW('worn', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['győz', 'nyer'], 2, ARRAY[ROW('win', 1), ROW('won', 2), ROW('won', 3)]::word_type_form_phrase_data[]);
call insert_word_type_form(ARRAY['ír'], 2, ARRAY[ROW('write', 1), ROW('wrote', 2), ROW('written', 3)]::word_type_form_phrase_data[]);

/*
select * from phrase order by phrase_id desc;
select * from word_type_from;
select * from word_type;
select * from word_type_link;
select * from word_type_form_phrase;*/

DROP VIEW IF EXISTS word_type_content;

CREATE OR REPLACE VIEW word_type_content(content, word_type_id, language_id) AS

/*
 name: 'Irregular verbs', form1Name: 'Infinitive', form2Name:'Past Simple', form3Name:'Past Participle',
 rows: {
 }
 */

SELECT * FROM word_type t
    JOIN word_type_form f ON t.word_type_id = f.word_type_id
    JOIN word_type_form_phrase wtfp on f.word_type_form_id = wtfp.word_type_form_id
    JOIN word_type_link wtl on wtfp.word_type_link_id = wtl.word_type_link_id
    JOIN word_type_from wtf ON wtl.word_type_link_id = wtf.word_type_link_id
    JOIN phrase p_from ON wtf.phrase_id = p_from.phrase_id
    JOIN phrase p_to ON wtfp.phrase_id = p_to.phrase_id;

SELECT *,
    (SELECT * FROM word_type_link wtl WHERE EXISTS (SELECT * FROM word_type_from wtf WHERE wtf.word_type_id = t.word_type_id))
FROM word_type t;

SELECT row_to_json(from_phrase.*)
FROM       (SELECT array_to_json(array_agg(phrase.*))
          FROM (SELECT wtfr.word_type_link_id id,
                       array_to_json(array_agg(p.text)) AS "fromPhrase",
                       (SELECT array_agg(wtf.name) FROM word_type_form wtf) AS forms
                  FROM word_type_from wtfr
                  JOIN phrase p on wtfr.phrase_id = p.phrase_id
                /* WHERE wtf.word_type_link_id = wtl.word_type_link_id*/
              GROUP BY wtfr.word_type_link_id) phrase) AS from_phrase;
--FROM word_type_link wtl;

SELECT array_to_json(array_agg(b.*)) AS array_to_json FROM
(SELECT 1 AS id,
(SELECT array_to_json(array_agg(text)) FROM phrase WHERE phrase_id in (301, 302)) p) b;

SELECT row_to_json(a.*), a.code, 2 AS content
FROM (SELECT t.name,
             t.word_type_id                                                 AS word_type_id,
             (SELECT array_to_json(array_agg(b.*)) AS array_to_json
              FROM (SELECT c.unit_content_id                                                                 AS id,
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationfrom.translation_from_id AS "translationId",
                                         phrase_1.text                       AS phrase
                                  FROM translation_from translationfrom
                                           JOIN phrase phrase_1 ON phrase_1.phrase_id = translationfrom.phrase_id
                                  WHERE translationfrom.translation_link_id = l.translation_link_id) phrase) AS "from",
                           (SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                            FROM (SELECT translationto.translation_to_id AS "translationId",
                                         phrase_1.text                   AS phrase
                                  FROM translation_to translationto
                                           JOIN phrase phrase_1 ON phrase_1.phrase_id = translationto.phrase_id
                                  WHERE translationto.translation_link_id = l.translation_link_id) phrase)   AS "to",
                           l.example,
                           l.translated_example                                                              AS "translatedExample"
                    FROM translation_link l
                             JOIN unit_content c ON c.unit_tree_id = t.unit_tree_id
                    WHERE l.translation_link_id = c.translation_link_id) b) AS words
      FROM word_type t) a;


