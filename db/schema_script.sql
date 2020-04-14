--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

-- Started on 2020-04-14 21:35:52

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16394)
-- Name: interrogator; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA interrogator;


--
-- TOC entry 243 (class 1255 OID 16866)
-- Name: addAnswer(bigint, bigint, boolean); Type: PROCEDURE; Schema: interrogator; Owner: -
--

CREATE PROCEDURE interrogator."addAnswer"("unitContentId" bigint, "userId" bigint, "answerIsRight" boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
	"translationLinkId" bigint;
	"userTransLinkRecord" bigint;
BEGIN
	SELECT "TranslationLinkId"
	  INTO "translationLinkId"
	  FROM "UnitContent"  uc
	 WHERE uc."UnitContentId" = "unitContentId";
	 
	INSERT INTO "UserTransLinkHistory" ("TranslationLinkId", "UserId", "Right", "CreateDate")
	VALUES ("translationLinkId", "userId", "answerIsRight", current_date);
	
	IF "answerIsRight" THEN
		UPDATE "UserTransLink"
	   	   SET "RightCount" = "RightCount" + 1
		 WHERE "TranslationLinkId" = "translationLinkId"
		   AND "UserId" = "userId";
	ELSE
		UPDATE "UserTransLink"
	   	   SET "WrongCount" = "WrongCount" + 1
		 WHERE "TranslationLinkId" = "translationLinkId"
		   AND "UserId" = "userId";
	END IF;
	
	GET DIAGNOSTICS "userTransLinkRecord" = ROW_COUNT;
	
	IF "userTransLinkRecord" = 0 THEN
		IF "answerIsRight" THEN
			INSERT INTO UserTransLink("TranslationLinkId", "UserId", "RightCount", "WrongCount")
			VALUES ("translationLinkId", "userId", 1, 0);
		ELSE
			INSERT INTO UserTransLink("TranslationLinkId", "UserId", "RightCount", "WrongCount")
			VALUES ("translationLinkId", "userId", 0, 1);
		END IF;
	END IF;
END
$$;


--
-- TOC entry 244 (class 1255 OID 16873)
-- Name: addRightAnswer(bigint, bigint); Type: PROCEDURE; Schema: interrogator; Owner: -
--

CREATE PROCEDURE interrogator."addRightAnswer"("unitContentId" bigint, "userId" bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	CALL addAnswer("unitContentId", "userId", true);
END
$$;


--
-- TOC entry 245 (class 1255 OID 16874)
-- Name: addWrongAnswer(bigint, bigint); Type: PROCEDURE; Schema: interrogator; Owner: -
--

CREATE PROCEDURE interrogator."addWrongAnswer"("unitContentId" bigint, "userId" bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	CALL addAnswer("unitContentId", "userId", false);
END
$$;


--
-- TOC entry 241 (class 1255 OID 16812)
-- Name: deleteTranslationFrom(bigint); Type: FUNCTION; Schema: interrogator; Owner: -
--

CREATE FUNCTION interrogator."deleteTranslationFrom"("translationFromId" bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	"fromCountForTranslationLink" bigint;
	"deletedRowCount"             bigint;
BEGIN

	SELECT COUNT(1)
	  INTO "deletedRowCount"
	  FROM "TranslationFrom" tf
	 WHERE tf."TranslationFromId" ="translationFromId";
	
	IF "deletedRowCount" = 1 THEN
		SELECT COUNT(1)
		  INTO "fromCountForTranslationLink"
		  FROM "TranslationFrom" tf 
		 WHERE tf."TranslationFromId" = "translationFromId"
		   AND EXISTS (SELECT 1 
					   FROM "TranslationFrom" tf2 
					   WHERE tf2."TranslationFromId" <> tf."TranslationFromId"
						 AND tf2."TranslationLinkId" = tf."TranslationLinkId");

		IF "fromCountForTranslationLink" < 1 THEN
			RAISE 'Last phrase can not be removed. Shall remove the whole translation in this case!';
		END IF;

		DELETE FROM "TranslationFrom" tf
		 WHERE tf."TranslationFromId" ="translationFromId";
		DELETE FROM "Phrase" p 
		 WHERE NOT EXISTS 
				(SELECT 1 FROM "TranslationFrom" tf 
				  WHERE tf."PhraseId" = p."PhraseId")
		   AND NOT EXISTS 
				(SELECT 1 FROM "TranslationTo" tf 
				  WHERE tf."PhraseId" = p."PhraseId");
	END IF;
	
	RETURN "deletedRowCount" > 0;
END;
$$;


--
-- TOC entry 242 (class 1255 OID 16810)
-- Name: deleteUnitContent(bigint); Type: FUNCTION; Schema: interrogator; Owner: -
--

CREATE FUNCTION interrogator."deleteUnitContent"("unitContentId" bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	"deletedRowCount" bigint;
BEGIN
-- it remove all tranlsation link (and its children) if no any connecion from other unit content
-- also for phrases

-- maybe should get the TranslationLink id by the unit content id, if no any connection from unit content
-- and get the phrases by the unit content id, if no any connection from unit content/translation link
-- remove just those record not all for which has not connection
	DELETE FROM "UnitContent" uc 
 	 WHERE uc."UnitContentId" = "unitContentId";
	GET DIAGNOSTICS "deletedRowCount" = ROW_COUNT;
	
	DELETE FROM "TranslationLink" tl
	 WHERE NOT EXISTS 
	 		(SELECT 1 FROM "UnitContent" uc 
			  WHERE uc."TranslationLinkId" = tl."TranslationLinkId");
	DELETE FROM "Phrase" p 
	 WHERE NOT EXISTS 
	 		(SELECT 1 FROM "TranslationFrom" tf 
			  WHERE tf."PhraseId" = p."PhraseId")
	   AND NOT EXISTS 
	 		(SELECT 1 FROM "TranslationTo" tf 
			  WHERE tf."PhraseId" = p."PhraseId");
	
	RETURN "deletedRowCount" > 0;
END
$$;


--
-- TOC entry 246 (class 1255 OID 17038)
-- Name: insertunitcontent(json); Type: FUNCTION; Schema: interrogator; Owner: -
--

CREATE FUNCTION interrogator.insertunitcontent(json_input json) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
	"unitContentId" bigint;
BEGIN

--insert into interrogator."tmp_insertjson"(insertjson)
--select json_input;

with json_data as (
select * from json_populate_record(
	null::"InsertUnitContentTable",
	json_input)
),
languages as (select RootFromLanguageId FromLangId, RootToLanguageId ToLangId from json_data
				join "UnitWithRoot" unit on unit."UnitTreeId" = json_data.id),
tl as (insert into "TranslationLink"("Example", "TranslatedExample")
	   select example, "translatedExample" from json_data
	   RETURNING "TranslationLinkId"),
uc as (insert into "UnitContent"("UnitTreeId", "TranslationLinkId")
	   select json_data.id, "TranslationLinkId" from json_data, tl
	   returning *),
phraseFrom as (insert into "Phrase"("LanguageId", "Text")
			   select l.ToLangId, json_array_elements_text("from"::json) from json_data, languages l
			   returning *),
phraseTo as (insert into "Phrase"("LanguageId", "Text")
		  	 select l.FromLangId, json_array_elements_text("to"::json) from json_data, languages l
		  	 returning *),
tFrom as (insert into "TranslationFrom"("TranslationLinkId", "PhraseId")
	   select tl."TranslationLinkId", phraseFrom."PhraseId" from tl, phraseFrom
	   returning *),
tTo as (insert into "TranslationTo"("TranslationLinkId", "PhraseId")
	    select tl."TranslationLinkId", phraseTo."PhraseId" from tl, phraseTo)
select uc."UnitContentId" into "unitContentId" from uc;

--insert into interrogator."tmp_insertjson"(insertjson) values ("unitContentId");

return "unitContentId";

END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16763)
-- Name: InsertUnitContentTable; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."InsertUnitContentTable" (
    id bigint,
    "from" character(2000),
    "to" character(2000),
    example character(2000),
    "translatedExample" character(2000)
);


--
-- TOC entry 208 (class 1259 OID 16447)
-- Name: Language; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."Language" (
    "LanguageId" bigint NOT NULL,
    "Name" character varying(255) NOT NULL,
    "Code" character varying(3) NOT NULL
);


--
-- TOC entry 209 (class 1259 OID 16485)
-- Name: Language_LanguageId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."Language" ALTER COLUMN "LanguageId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."Language_LanguageId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999999
    CACHE 1
);


--
-- TOC entry 204 (class 1259 OID 16395)
-- Name: Phrase; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."Phrase" (
    "PhraseId" bigint NOT NULL,
    "LanguageId" bigint NOT NULL,
    "Text" character varying(255) NOT NULL,
    "Pronunciation" character varying(255),
    "AudioName" character varying(255)
);


--
-- TOC entry 210 (class 1259 OID 16602)
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."Phrase" ALTER COLUMN "PhraseId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."Phrase_PhraseId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16403)
-- Name: TranslationFrom; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."TranslationFrom" (
    "TranslationFromId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL,
    "PhraseId" bigint NOT NULL,
    "Order" bigint
);


--
-- TOC entry 211 (class 1259 OID 16604)
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."TranslationFrom" ALTER COLUMN "TranslationFromId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."TranslationFrom_TranslationFromId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 207 (class 1259 OID 16419)
-- Name: TranslationLink; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."TranslationLink" (
    "TranslationLinkId" bigint NOT NULL,
    "Example" character varying(255),
    "TranslatedExample" character varying(255),
    "ImageName" character varying(255)
);


--
-- TOC entry 212 (class 1259 OID 16606)
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."TranslationLink" ALTER COLUMN "TranslationLinkId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."TranslationLink_TranslationLinkId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 206 (class 1259 OID 16411)
-- Name: TranslationTo; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."TranslationTo" (
    "TranslationToId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL,
    "PhraseId" bigint NOT NULL,
    "Order" bigint
);


--
-- TOC entry 213 (class 1259 OID 16608)
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."TranslationTo" ALTER COLUMN "TranslationToId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."TranslationTo_TranslationToId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16624)
-- Name: UnitContent; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."UnitContent" (
    "UnitContentId" bigint NOT NULL,
    "UnitTreeId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16612)
-- Name: UnitTree; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."UnitTree" (
    "UnitTreeId" bigint NOT NULL,
    "ParentUnitTreeId" bigint,
    "Name" character varying(255) NOT NULL,
    "FromLanguageId" bigint,
    "ToLanguageId" bigint
);


--
-- TOC entry 218 (class 1259 OID 16714)
-- Name: UnitContentJson; Type: VIEW; Schema: interrogator; Owner: -
--

CREATE VIEW interrogator."UnitContentJson" AS
 SELECT row_to_json(a.*) AS content,
    a.code
   FROM ( SELECT t."Name" AS name,
            t."UnitTreeId" AS code,
            ( SELECT array_to_json(array_agg(b.*)) AS array_to_json
                   FROM ( SELECT c."UnitContentId" AS id,
                            ( SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                                   FROM ( SELECT translationfrom."TranslationFromId" AS "translationId",
    "Phrase"."Text" AS phrase
   FROM (interrogator."TranslationFrom" translationfrom
     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationfrom."PhraseId")))
  WHERE (translationfrom."TranslationLinkId" = l."TranslationLinkId")) phrase) AS "from",
                            ( SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                                   FROM ( SELECT translationto."TranslationToId" AS "translationId",
    "Phrase"."Text" AS phrase
   FROM (interrogator."TranslationTo" translationto
     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationto."PhraseId")))
  WHERE (translationto."TranslationLinkId" = l."TranslationLinkId")) phrase) AS "to",
                            l."Example" AS example,
                            l."TranslatedExample" AS "translatedExample"
                           FROM (interrogator."TranslationLink" l
                             JOIN interrogator."UnitContent" c ON ((c."UnitTreeId" = t."UnitTreeId")))
                          WHERE (l."TranslationLinkId" = c."TranslationLinkId")) b) AS words
           FROM interrogator."UnitTree" t) a;


--
-- TOC entry 216 (class 1259 OID 16622)
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."UnitContent" ALTER COLUMN "UnitContentId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."UnitContent_UnitContent_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16719)
-- Name: UnitGroupJson; Type: VIEW; Schema: interrogator; Owner: -
--

CREATE VIEW interrogator."UnitGroupJson" AS
 SELECT array_to_json(array_agg(a.*)) AS groups
   FROM ( SELECT "UnitTree"."Name" AS name,
            ( SELECT array_to_json(array_agg(unit.*)) AS array_to_json
                   FROM ( SELECT unit_1."Name" AS name,
                            unit_1."UnitTreeId" AS code
                           FROM interrogator."UnitTree" unit_1
                          WHERE (unit_1."ParentUnitTreeId" = "UnitTree"."UnitTreeId")) unit) AS "group",
            row_number() OVER () AS "order"
           FROM interrogator."UnitTree"
          WHERE ("UnitTree"."ParentUnitTreeId" = 1)) a;


--
-- TOC entry 214 (class 1259 OID 16610)
-- Name: UnitTree_UnitTreeId_seq; Type: SEQUENCE; Schema: interrogator; Owner: -
--

ALTER TABLE interrogator."UnitTree" ALTER COLUMN "UnitTreeId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME interrogator."UnitTree_UnitTreeId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16821)
-- Name: UnitWithRoot; Type: VIEW; Schema: interrogator; Owner: -
--

CREATE VIEW interrogator."UnitWithRoot" AS
 WITH RECURSIVE unitswithroot AS (
         SELECT ut."UnitTreeId",
            ut."ParentUnitTreeId",
            ut."Name",
            ut."UnitTreeId" AS rootid,
            ut."FromLanguageId" AS rootfromlanguageid,
            ut."ToLanguageId" AS roottolanguageid
           FROM interrogator."UnitTree" ut
          WHERE (ut."ParentUnitTreeId" IS NULL)
        UNION
         SELECT child."UnitTreeId",
            child."ParentUnitTreeId",
            child."Name",
            p.rootid,
            p.rootfromlanguageid,
            p.roottolanguageid
           FROM (interrogator."UnitTree" child
             JOIN unitswithroot p ON ((child."ParentUnitTreeId" = p."UnitTreeId")))
        )
 SELECT unitswithroot."UnitTreeId",
    unitswithroot.rootid,
    unitswithroot.rootfromlanguageid,
    unitswithroot.roottolanguageid
   FROM unitswithroot;


--
-- TOC entry 2955 (class 0 OID 0)
-- Dependencies: 222
-- Name: VIEW "UnitWithRoot"; Type: COMMENT; Schema: interrogator; Owner: -
--

COMMENT ON VIEW interrogator."UnitWithRoot" IS 'Returns the UnitTreeId and its Root UniTreeId and language ids';


--
-- TOC entry 224 (class 1259 OID 16833)
-- Name: User; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."User" (
    "UserId" bigint NOT NULL,
    "Email" character varying(255) NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16828)
-- Name: UserTransLink; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."UserTransLink" (
    "TranslationLinkId" bigint NOT NULL,
    "UserId" bigint NOT NULL,
    "RightCount" bigint NOT NULL,
    "WrongCount" bigint NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16848)
-- Name: UserTransLinkHistory; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator."UserTransLinkHistory" (
    "TranslationLinkId" bigint NOT NULL,
    "UserId" bigint NOT NULL,
    "Right" boolean NOT NULL,
    "CreateDate" date NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16769)
-- Name: tmp_insertjson; Type: TABLE; Schema: interrogator; Owner: -
--

CREATE TABLE interrogator.tmp_insertjson (
    insertjson character varying(2000)
);


--
-- TOC entry 2945 (class 0 OID 16763)
-- Dependencies: 220
-- Data for Name: InsertUnitContentTable; Type: TABLE DATA; Schema: interrogator; Owner: -
--



--
-- TOC entry 2935 (class 0 OID 16447)
-- Dependencies: 208
-- Data for Name: Language; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."Language" OVERRIDING SYSTEM VALUE VALUES (1, 'English', 'en');
INSERT INTO interrogator."Language" OVERRIDING SYSTEM VALUE VALUES (2, 'Hungarian', 'hu');


--
-- TOC entry 2931 (class 0 OID 16395)
-- Dependencies: 204
-- Data for Name: Phrase; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (1, 2, 'Lopni', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (2, 1, 'Steal', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (3, 1, 'to steal', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (62, 1, 'cut', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (63, 1, 'to cut', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (64, 2, 'Vág', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (65, 2, 'Vágni', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (66, 1, 'to throw', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (67, 2, 'dobni', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (70, 2, 'Write', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (71, 1, 'Ír', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (72, 2, 'Sleep', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (73, 1, 'Alszik', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (74, 2, 'Do', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (75, 1, 'Csinál', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (76, 1, 'Készít', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (85, 2, 'eat', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (86, 1, 'eszik', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (229, 2, 'example', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (230, 1, 'példa', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (112, 2, 'beautiful', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (113, 1, 'gyönyörű', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (114, 2, 'cloudy', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (115, 1, 'felhős', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (116, 2, 'bridge', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (117, 1, 'híd', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (118, 2, 'canal', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (119, 1, 'csatorna', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (120, 2, 'capital', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (121, 1, 'főváros', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (122, 2, 'city', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (123, 1, 'nagyváros', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (124, 1, 'város', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (125, 2, 'cliff', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (126, 1, 'szikla', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (127, 2, 'coast', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (128, 1, 'tengerpart', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (129, 2, 'deep', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (130, 1, 'mély', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (131, 2, 'forest', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (132, 1, 'erdő', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (133, 2, 'grand', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (134, 1, 'nemes', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (135, 1, 'előkelő', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (136, 2, 'halfway', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (137, 1, 'félúton', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (138, 2, 'high', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (139, 1, 'magas', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (140, 2, 'hill', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (141, 1, 'hegy', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (142, 1, 'domb', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (143, 2, 'island', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (144, 1, 'sziget', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (145, 2, 'Isle of Wight', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (146, 1, 'Wight-sziget', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (147, 2, 'kilometre', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (148, 1, 'kilométer', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (149, 2, 'lake', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (150, 1, 'tó', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (151, 2, 'long', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (152, 1, 'hosszú', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (153, 2, 'march', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (154, 1, 'menetelni', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (157, 2, 'metre', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (158, 1, 'méter', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (161, 2, 'million', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (162, 1, 'millió', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (163, 2, 'monster', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (164, 1, 'szörny', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (167, 2, 'mountain', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (168, 1, 'hegy', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (169, 2, 'neither ... nor', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (170, 1, 'sem ... sem', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (171, 2, 'river', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (172, 1, 'folyó', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (173, 2, 'sea', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (174, 1, 'tenger', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (175, 2, 'the Thames', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (176, 1, 'Temze', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (177, 2, 'tunnel', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (178, 1, 'alagút', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (179, 2, 'valley', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (180, 1, 'völgy', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (181, 2, 'wide', NULL, NULL);
INSERT INTO interrogator."Phrase" OVERRIDING SYSTEM VALUE VALUES (182, 1, 'széles', NULL, NULL);


--
-- TOC entry 2932 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: TranslationFrom; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (110, 127, 230, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (29, 28, 64, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (30, 28, 65, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (31, 29, 67, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (32, 32, 71, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (33, 33, 73, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (34, 34, 75, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (35, 34, 76, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (37, 47, 86, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (50, 60, 113, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (51, 61, 115, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (52, 64, 117, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (53, 65, 119, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (54, 66, 121, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (55, 67, 123, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (56, 67, 124, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (57, 68, 126, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (58, 69, 128, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (59, 70, 130, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (60, 71, 132, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (61, 72, 134, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (62, 72, 135, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (63, 73, 137, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (64, 74, 139, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (65, 75, 141, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (66, 75, 142, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (67, 76, 144, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (68, 77, 146, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (69, 78, 148, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (70, 79, 150, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (71, 80, 152, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (72, 81, 154, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (74, 83, 158, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (76, 85, 162, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (77, 86, 164, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (79, 88, 168, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (80, 89, 170, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (81, 90, 172, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (82, 91, 174, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (83, 92, 176, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (84, 93, 178, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (85, 94, 180, NULL);
INSERT INTO interrogator."TranslationFrom" OVERRIDING SYSTEM VALUE VALUES (86, 95, 182, NULL);


--
-- TOC entry 2934 (class 0 OID 16419)
-- Dependencies: 207
-- Data for Name: TranslationLink; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (1, 'Valaki ellopta a pénztárcámat', 'Someone stole my wallet', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (60, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (61, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (64, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (65, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (66, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (67, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (68, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (69, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (70, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (71, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (72, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (73, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (74, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (75, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (76, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (77, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (78, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (79, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (80, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (81, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (83, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (28, 'Vágja a kenyeret', 'Cut the bread', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (29, 'Dobja a labdát', 'Throw the ball', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (85, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (86, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (32, 'Éppen írok', 'I''m writing now', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (33, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (34, 'Készítem a házimat', 'I do my homework', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (88, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (89, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (90, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (91, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (92, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (93, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (94, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (95, '', '', NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (47, NULL, NULL, NULL);
INSERT INTO interrogator."TranslationLink" OVERRIDING SYSTEM VALUE VALUES (127, 'mondat', 'sentence', NULL);


--
-- TOC entry 2933 (class 0 OID 16411)
-- Dependencies: 206
-- Data for Name: TranslationTo; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (1, 1, 2, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (2, 1, 3, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (102, 127, 229, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (24, 28, 62, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (25, 28, 63, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (26, 29, 66, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (27, 32, 70, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (28, 33, 72, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (29, 34, 74, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (31, 47, 85, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (45, 60, 112, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (46, 61, 114, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (47, 64, 116, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (48, 65, 118, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (49, 66, 120, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (50, 67, 122, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (51, 68, 125, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (52, 69, 127, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (53, 70, 129, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (54, 71, 131, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (55, 72, 133, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (56, 73, 136, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (57, 74, 138, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (58, 75, 140, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (59, 76, 143, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (60, 77, 145, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (61, 78, 147, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (62, 79, 149, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (63, 80, 151, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (64, 81, 153, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (66, 83, 157, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (68, 85, 161, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (69, 86, 163, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (71, 88, 167, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (72, 89, 169, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (73, 90, 171, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (74, 91, 173, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (75, 92, 175, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (76, 93, 177, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (77, 94, 179, NULL);
INSERT INTO interrogator."TranslationTo" OVERRIDING SYSTEM VALUE VALUES (78, 95, 181, NULL);


--
-- TOC entry 2944 (class 0 OID 16624)
-- Dependencies: 217
-- Data for Name: UnitContent; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (1, 3, 1);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (116, 8, 127);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (25, 3, 28);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (26, 3, 29);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (27, 3, 32);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (28, 3, 33);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (29, 3, 34);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (36, 3, 47);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (49, 7, 60);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (50, 8, 61);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (53, 7, 64);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (54, 7, 65);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (55, 7, 66);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (56, 7, 67);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (57, 7, 68);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (58, 7, 69);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (59, 7, 70);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (60, 7, 71);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (61, 7, 72);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (62, 7, 73);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (63, 7, 74);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (64, 7, 75);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (65, 7, 76);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (66, 7, 77);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (67, 7, 78);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (68, 7, 79);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (69, 7, 80);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (70, 7, 81);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (72, 7, 83);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (74, 7, 85);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (75, 7, 86);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (77, 7, 88);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (78, 7, 89);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (79, 7, 90);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (80, 7, 91);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (81, 7, 92);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (82, 7, 93);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (83, 7, 94);
INSERT INTO interrogator."UnitContent" OVERRIDING SYSTEM VALUE VALUES (84, 7, 95);


--
-- TOC entry 2942 (class 0 OID 16612)
-- Dependencies: 215
-- Data for Name: UnitTree; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (2, 1, 'Unit 3', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (3, 2, 'A', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (4, 2, 'B', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (5, 2, 'C', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (1, NULL, 'Project 2.', 2, 1);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (6, 1, 'Unit 5', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (7, 6, 'A', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (8, 6, 'B
', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (9, 6, 'C', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (10, 6, 'D', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (11, 6, 'Culture', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (12, 6, 'English across the curriculum', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (13, 6, 'Revision', NULL, NULL);
INSERT INTO interrogator."UnitTree" OVERRIDING SYSTEM VALUE VALUES (14, 6, 'Your project', NULL, NULL);


--
-- TOC entry 2948 (class 0 OID 16833)
-- Dependencies: 224
-- Data for Name: User; Type: TABLE DATA; Schema: interrogator; Owner: -
--



--
-- TOC entry 2947 (class 0 OID 16828)
-- Dependencies: 223
-- Data for Name: UserTransLink; Type: TABLE DATA; Schema: interrogator; Owner: -
--



--
-- TOC entry 2949 (class 0 OID 16848)
-- Dependencies: 225
-- Data for Name: UserTransLinkHistory; Type: TABLE DATA; Schema: interrogator; Owner: -
--



--
-- TOC entry 2946 (class 0 OID 16769)
-- Dependencies: 221
-- Data for Name: tmp_insertjson; Type: TABLE DATA; Schema: interrogator; Owner: -
--

INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I''m writing now"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I''m writing now"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"fomLanguage":2,"toLanguage":1,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I''m writing now"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I''m writing now"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Alszik"],"to":["Sleep"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"code":3,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"sdkfjkh"}],"to":[{"phrase":"hjhj"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"jhjh"}],"to":[{"phrase":"jhjh"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"hjh"}],"to":[{"phrase":"jhjh"}],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"jklj"}],"to":[{"phrase":"kjkj"}],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"kjkj"}],"to":[{"phrase":"kjkj"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"tezst"}],"to":[{"phrase":"test"}],"example":"teszt","translatedExample":"test"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[{"phrase":"1"},{"phrase":"2"}],"to":[{"phrase":"10"},{"phrase":"20"},{"phrase":"30"}],"example":"3","translatedExample":"40"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[null,"0"],"to":[null,"0"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["0"],"to":["0"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[""],"to":[""],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":[""],"to":[""],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["teszt"],"to":["test"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["teszt"],"to":["test"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["eszik"],"to":["eat"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["eszik"],"to":["have breakfast","has breakfast"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["sf"],"to":["sf"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["t"],"to":["t"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["f"],"to":["f"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["df"],"to":["df"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["b"],"to":["b"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["bb"],"to":["ab"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["b"],"to":["b"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["s"],"to":["j"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["reszt"],"to":["test"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["gyönyörű"],"to":["beautiful"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"8","from":["felhős"],"to":["cloudy"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"from":["híd"],"to":["bridge"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"from":["híd"],"to":["bridge"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["híd"],"to":["bridge"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["csatorna"],"to":["canal"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["főváros"],"to":["capital"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["nagyváros","város"],"to":["city"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["szikla"],"to":["cliff"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["tengerpart"],"to":["coast"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["mély"],"to":["deep"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["erdő"],"to":["forest"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["nemes","előkelő"],"to":["grand"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["félúton"],"to":["halfway"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["magas"],"to":["high"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["hegy","domb"],"to":["hill"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["sziget"],"to":["island"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["Wight-sziget"],"to":["Isle of Wight"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["kilométer"],"to":["kilometre"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["tó"],"to":["lake"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["hosszú"],"to":["long"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["menetelni"],"to":["march"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["méter"],"to":["merte"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["méter"],"to":["metre"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["millió"],"to":["millon"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["millió"],"to":["million"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["szörny"],"to":["monster"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["hely"],"to":["mountain"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["hegy"],"to":["mountain"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["sem ... sem"],"to":["neither ... nor"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["folyó"],"to":["river"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["tenger"],"to":["sea"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["Temze"],"to":["the Thames"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["alagút"],"to":["tunnel"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["völgy"],"to":["valley"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"7","from":["széles"],"to":["wide"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["b"],"to":["b"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["c"],"to":["c"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["d"],"to":["d"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('4');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["e"],"to":["e"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('90');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["f"],"to":["f"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('91');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["g"],"to":["g"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('92');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["h"],"to":["h"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('93');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('94');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('95');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('96');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["b"],"to":["b"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('97');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["c"],"to":["c"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('98');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('99');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('100');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('102');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('103');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["c"],"to":["c"],"example":"","translatedExample":""}');
INSERT INTO interrogator.tmp_insertjson VALUES ('104');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"3","from":["teszt"],"to":["test"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('112');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('113');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"4","from":["a"],"to":["a"]}');
INSERT INTO interrogator.tmp_insertjson VALUES ('114');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"8","from":["a"],"to":["b"],"example":"példa","translatedExample":"example"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('115');
INSERT INTO interrogator.tmp_insertjson VALUES ('{"id":"8","from":["példa"],"to":["example"],"example":"mondat","translatedExample":"sentence"}');
INSERT INTO interrogator.tmp_insertjson VALUES ('116');


--
-- TOC entry 2956 (class 0 OID 0)
-- Dependencies: 209
-- Name: Language_LanguageId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."Language_LanguageId_seq"', 2, true);


--
-- TOC entry 2957 (class 0 OID 0)
-- Dependencies: 210
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."Phrase_PhraseId_seq"', 230, true);


--
-- TOC entry 2958 (class 0 OID 0)
-- Dependencies: 211
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."TranslationFrom_TranslationFromId_seq"', 110, true);


--
-- TOC entry 2959 (class 0 OID 0)
-- Dependencies: 212
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."TranslationLink_TranslationLinkId_seq"', 127, true);


--
-- TOC entry 2960 (class 0 OID 0)
-- Dependencies: 213
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."TranslationTo_TranslationToId_seq"', 102, true);


--
-- TOC entry 2961 (class 0 OID 0)
-- Dependencies: 216
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."UnitContent_UnitContent_seq"', 116, true);


--
-- TOC entry 2962 (class 0 OID 0)
-- Dependencies: 214
-- Name: UnitTree_UnitTreeId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: -
--

SELECT pg_catalog.setval('interrogator."UnitTree_UnitTreeId_seq"', 14, true);


--
-- TOC entry 2779 (class 2606 OID 16475)
-- Name: Language Language_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."Language"
    ADD CONSTRAINT "Language_pkey" PRIMARY KEY ("LanguageId");


--
-- TOC entry 2771 (class 2606 OID 16584)
-- Name: Phrase Phrase_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "Phrase_pkey" PRIMARY KEY ("PhraseId");


--
-- TOC entry 2773 (class 2606 OID 16488)
-- Name: TranslationFrom TranslationFrom_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "TranslationFrom_pkey" PRIMARY KEY ("TranslationFromId");


--
-- TOC entry 2777 (class 2606 OID 16565)
-- Name: TranslationLink TranslationLink_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationLink"
    ADD CONSTRAINT "TranslationLink_pkey" PRIMARY KEY ("TranslationLinkId");


--
-- TOC entry 2775 (class 2606 OID 16528)
-- Name: TranslationTo TranslationTo_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "TranslationTo_pkey" PRIMARY KEY ("TranslationToId");


--
-- TOC entry 2783 (class 2606 OID 16628)
-- Name: UnitContent UnitContentId_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "UnitContentId_pkey" PRIMARY KEY ("UnitContentId");


--
-- TOC entry 2781 (class 2606 OID 16616)
-- Name: UnitTree UnitTree_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "UnitTree_pkey" PRIMARY KEY ("UnitTreeId");


--
-- TOC entry 2789 (class 2606 OID 16852)
-- Name: UserTransLinkHistory UserTransLinkHistory_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLinkHistory"
    ADD CONSTRAINT "UserTransLinkHistory_pkey" PRIMARY KEY ("TranslationLinkId", "UserId");


--
-- TOC entry 2785 (class 2606 OID 16832)
-- Name: UserTransLink UserTransLink_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLink"
    ADD CONSTRAINT "UserTransLink_pkey" PRIMARY KEY ("TranslationLinkId", "UserId");


--
-- TOC entry 2787 (class 2606 OID 16837)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY ("UserId");


--
-- TOC entry 2790 (class 2606 OID 16476)
-- Name: Phrase FK_LanguageId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "FK_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES interrogator."Language"("LanguageId") NOT VALID;


--
-- TOC entry 2795 (class 2606 OID 16617)
-- Name: UnitTree FK_ParentUnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "FK_ParentUnitTreeId" FOREIGN KEY ("ParentUnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId") NOT VALID;


--
-- TOC entry 2791 (class 2606 OID 16585)
-- Name: TranslationFrom FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2793 (class 2606 OID 16590)
-- Name: TranslationTo FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2797 (class 2606 OID 16634)
-- Name: UnitContent FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId");


--
-- TOC entry 2794 (class 2606 OID 16799)
-- Name: TranslationTo FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2792 (class 2606 OID 16804)
-- Name: TranslationFrom FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2798 (class 2606 OID 16838)
-- Name: UserTransLink FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLink"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") NOT VALID;


--
-- TOC entry 2800 (class 2606 OID 16853)
-- Name: UserTransLinkHistory FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLinkHistory"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId");


--
-- TOC entry 2796 (class 2606 OID 16629)
-- Name: UnitContent FK_UnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_UnitTreeId" FOREIGN KEY ("UnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId");


--
-- TOC entry 2799 (class 2606 OID 16843)
-- Name: UserTransLink FK_UserId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLink"
    ADD CONSTRAINT "FK_UserId" FOREIGN KEY ("UserId") REFERENCES interrogator."User"("UserId") NOT VALID;


--
-- TOC entry 2801 (class 2606 OID 16858)
-- Name: UserTransLinkHistory FK_UserId; Type: FK CONSTRAINT; Schema: interrogator; Owner: -
--

ALTER TABLE ONLY interrogator."UserTransLinkHistory"
    ADD CONSTRAINT "FK_UserId" FOREIGN KEY ("UserId") REFERENCES interrogator."User"("UserId");


-- Completed on 2020-04-14 21:35:52

--
-- PostgreSQL database dump complete
--

