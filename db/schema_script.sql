--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

-- Started on 2020-01-26 16:25:21

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
-- Name: interrogator; Type: SCHEMA; Schema: -; Owner: attila
--

CREATE SCHEMA interrogator;


ALTER SCHEMA interrogator OWNER TO attila;

--
-- TOC entry 238 (class 1255 OID 16812)
-- Name: deleteTranslationFrom(bigint); Type: FUNCTION; Schema: interrogator; Owner: attila
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


ALTER FUNCTION interrogator."deleteTranslationFrom"("translationFromId" bigint) OWNER TO attila;

--
-- TOC entry 239 (class 1255 OID 16810)
-- Name: deleteUnitContent(bigint); Type: FUNCTION; Schema: interrogator; Owner: attila
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


ALTER FUNCTION interrogator."deleteUnitContent"("unitContentId" bigint) OWNER TO attila;

--
-- TOC entry 237 (class 1255 OID 16762)
-- Name: insertunitcontent(json); Type: PROCEDURE; Schema: interrogator; Owner: postgres
--

CREATE PROCEDURE interrogator.insertunitcontent(json_input json)
    LANGUAGE plpgsql
    AS $$
BEGIN

insert into interrogator."tmp_insertjson"(insertjson)
select json_input;

commit;

with json_data as (
select * from json_populate_record(
	null::"InsertUnitContentTable",
	json_input)
),
tl as (insert into "TranslationLink"("Example", "TranslatedExample")
	   select example, "translatedExample" from json_data d
	   RETURNING "TranslationLinkId"),
uc as (insert into "UnitContent"("UnitTreeId", "TranslationLinkId")
	   select code, "TranslationLinkId" from json_data, tl
	   returning *),
phraseFrom as (insert into "Phrase"("LanguageId", "Text")
			   select "toLanguage", json_array_elements_text("from"::json) from json_data
			   returning *),
phraseTo as (insert into "Phrase"("LanguageId", "Text")
		  	 select "fromLanguage", json_array_elements_text("to"::json) from json_data
		  	 returning *),
tFrom as (insert into "TranslationFrom"("TranslationLinkId", "PhraseId")
	   select tl."TranslationLinkId", phraseFrom."PhraseId" from tl, phraseFrom
	   returning *)
insert into "TranslationTo"("TranslationLinkId", "PhraseId")
	   select tl."TranslationLinkId", phraseTo."PhraseId" from tl, phraseTo;
END;
$$;


ALTER PROCEDURE interrogator.insertunitcontent(json_input json) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16763)
-- Name: InsertUnitContentTable; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."InsertUnitContentTable" (
    code bigint,
    "fromLanguage" bigint,
    "toLanguage" bigint,
    "from" character(2000),
    "to" character(2000),
    example character(2000),
    "translatedExample" character(2000)
);


ALTER TABLE interrogator."InsertUnitContentTable" OWNER TO attila;

--
-- TOC entry 208 (class 1259 OID 16447)
-- Name: Language; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."Language" (
    "LanguageId" bigint NOT NULL,
    "Name" character varying(255) NOT NULL,
    "Code" character varying(3) NOT NULL
);


ALTER TABLE interrogator."Language" OWNER TO attila;

--
-- TOC entry 209 (class 1259 OID 16485)
-- Name: Language_LanguageId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: Phrase; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."Phrase" (
    "PhraseId" bigint NOT NULL,
    "LanguageId" bigint NOT NULL,
    "Text" character varying(255) NOT NULL,
    "Pronunciation" character varying(255),
    "AudioName" character varying(255)
);


ALTER TABLE interrogator."Phrase" OWNER TO attila;

--
-- TOC entry 210 (class 1259 OID 16602)
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: TranslationFrom; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."TranslationFrom" (
    "TranslationFromId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL,
    "PhraseId" bigint NOT NULL,
    "Order" bigint
);


ALTER TABLE interrogator."TranslationFrom" OWNER TO attila;

--
-- TOC entry 211 (class 1259 OID 16604)
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: TranslationLink; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."TranslationLink" (
    "TranslationLinkId" bigint NOT NULL,
    "Example" character varying(255),
    "TranslatedExample" character varying(255),
    "ImageName" character varying(255)
);


ALTER TABLE interrogator."TranslationLink" OWNER TO attila;

--
-- TOC entry 212 (class 1259 OID 16606)
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: TranslationTo; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."TranslationTo" (
    "TranslationToId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL,
    "PhraseId" bigint NOT NULL,
    "Order" bigint
);


ALTER TABLE interrogator."TranslationTo" OWNER TO attila;

--
-- TOC entry 213 (class 1259 OID 16608)
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: UnitContent; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."UnitContent" (
    "UnitContentId" bigint NOT NULL,
    "UnitTreeId" bigint NOT NULL,
    "TranslationLinkId" bigint NOT NULL
);


ALTER TABLE interrogator."UnitContent" OWNER TO attila;

--
-- TOC entry 215 (class 1259 OID 16612)
-- Name: UnitTree; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."UnitTree" (
    "UnitTreeId" bigint NOT NULL,
    "ParentUnitTreeId" bigint,
    "Name" character varying(255) NOT NULL
);


ALTER TABLE interrogator."UnitTree" OWNER TO attila;

--
-- TOC entry 218 (class 1259 OID 16714)
-- Name: UnitContentJson; Type: VIEW; Schema: interrogator; Owner: attila
--

CREATE VIEW interrogator."UnitContentJson" AS
 SELECT row_to_json(a.*) AS content,
    a.code
   FROM ( SELECT t."Name" AS name,
            t."UnitTreeId" AS code,
            ( SELECT array_to_json(array_agg(b.*)) AS array_to_json
                   FROM ( SELECT c."UnitContentId" AS id,
                            ( SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                                   FROM ( SELECT translationfrom."TranslationFromId" AS id,
    "Phrase"."Text" AS phrase
   FROM (interrogator."TranslationFrom" translationfrom
     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationfrom."PhraseId")))
  WHERE (translationfrom."TranslationLinkId" = l."TranslationLinkId")) phrase) AS "from",
                            ( SELECT array_to_json(array_agg(row_to_json(phrase.*))) AS array_to_json
                                   FROM ( SELECT translationto."TranslationToId" AS id,
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


ALTER TABLE interrogator."UnitContentJson" OWNER TO attila;

--
-- TOC entry 216 (class 1259 OID 16622)
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- Name: UnitGroupJson; Type: VIEW; Schema: interrogator; Owner: postgres
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


ALTER TABLE interrogator."UnitGroupJson" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16610)
-- Name: UnitTree_UnitTreeId_seq; Type: SEQUENCE; Schema: interrogator; Owner: attila
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
-- TOC entry 221 (class 1259 OID 16769)
-- Name: tmp_insertjson; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator.tmp_insertjson (
    insertjson character varying(2000)
);


ALTER TABLE interrogator.tmp_insertjson OWNER TO attila;

--
-- TOC entry 2915 (class 0 OID 16763)
-- Dependencies: 220
-- Data for Name: InsertUnitContentTable; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."InsertUnitContentTable" (code, "fromLanguage", "toLanguage", "from", "to", example, "translatedExample") FROM stdin;
\.


--
-- TOC entry 2905 (class 0 OID 16447)
-- Dependencies: 208
-- Data for Name: Language; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."Language" ("LanguageId", "Name", "Code") FROM stdin;
1	English	en
2	Hungarian	hu
\.


--
-- TOC entry 2901 (class 0 OID 16395)
-- Dependencies: 204
-- Data for Name: Phrase; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."Phrase" ("PhraseId", "LanguageId", "Text", "Pronunciation", "AudioName") FROM stdin;
1	2	Lopni	\N	\N
2	1	Steal	\N	\N
3	1	to steal	\N	\N
4	2	Vesz	\N	\N
5	2	Venni	\N	\N
6	1	buy	\N	\N
7	1	to buy	\N	\N
62	1	cut	\N	\N
63	1	to cut	\N	\N
64	2	Vág	\N	\N
65	2	Vágni	\N	\N
66	1	to throw	\N	\N
67	2	dobni	\N	\N
70	2	Write	\N	\N
71	1	Ír	\N	\N
72	2	Sleep	\N	\N
73	1	Alszik	\N	\N
74	2	Do	\N	\N
75	1	Csinál	\N	\N
76	1	Készít	\N	\N
\.


--
-- TOC entry 2902 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: TranslationFrom; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationFrom" ("TranslationFromId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	1	\N
3	2	4	\N
4	2	5	\N
29	28	64	\N
30	28	65	\N
31	29	67	\N
32	32	71	\N
33	33	73	\N
34	34	75	\N
35	34	76	\N
\.


--
-- TOC entry 2904 (class 0 OID 16419)
-- Dependencies: 207
-- Data for Name: TranslationLink; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationLink" ("TranslationLinkId", "Example", "TranslatedExample", "ImageName") FROM stdin;
1	Valaki ellopta a pénztárcámat	Someone stole my wallet	\N
2	Vesz egy labdát	Buy a ball	\N
28	Vágja a kenyeret	Cut the bread	\N
29	Dobja a labdát	Throw the ball	\N
32	Éppen írok	I'm writing now	\N
33			\N
34	Készítem a házimat	I do my homework	\N
\.


--
-- TOC entry 2903 (class 0 OID 16411)
-- Dependencies: 206
-- Data for Name: TranslationTo; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationTo" ("TranslationToId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	2	\N
2	1	3	\N
3	2	6	\N
4	2	7	\N
24	28	62	\N
25	28	63	\N
26	29	66	\N
27	32	70	\N
28	33	72	\N
29	34	74	\N
\.


--
-- TOC entry 2914 (class 0 OID 16624)
-- Dependencies: 217
-- Data for Name: UnitContent; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."UnitContent" ("UnitContentId", "UnitTreeId", "TranslationLinkId") FROM stdin;
1	3	1
3	3	2
25	3	28
26	3	29
27	3	32
28	3	33
29	3	34
\.


--
-- TOC entry 2912 (class 0 OID 16612)
-- Dependencies: 215
-- Data for Name: UnitTree; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."UnitTree" ("UnitTreeId", "ParentUnitTreeId", "Name") FROM stdin;
1	\N	Project 2.
2	1	Unit 3
3	2	A
4	2	B
5	2	C
\.


--
-- TOC entry 2916 (class 0 OID 16769)
-- Dependencies: 221
-- Data for Name: tmp_insertjson; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator.tmp_insertjson (insertjson) FROM stdin;
{"code":3,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I'm writing now"}
{"code":3,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I'm writing now"}
{"code":3,"fomLanguage":2,"toLanguage":1,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I'm writing now"}
{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Ír"],"to":["Write"],"example":"Éppen írok","translatedExample":"I'm writing now"}
{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Alszik"],"to":["Sleep"],"example":"","translatedExample":""}
{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}
{"code":3,"fromLanguage":2,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}
{"code":3,"toLanguage":1,"from":["Csinál","Készít"],"to":["Do"],"example":"Készítem a házimat","translatedExample":"I do my homework"}
\.


--
-- TOC entry 2922 (class 0 OID 0)
-- Dependencies: 209
-- Name: Language_LanguageId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Language_LanguageId_seq"', 2, true);


--
-- TOC entry 2923 (class 0 OID 0)
-- Dependencies: 210
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Phrase_PhraseId_seq"', 77, true);


--
-- TOC entry 2924 (class 0 OID 0)
-- Dependencies: 211
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationFrom_TranslationFromId_seq"', 35, true);


--
-- TOC entry 2925 (class 0 OID 0)
-- Dependencies: 212
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationLink_TranslationLinkId_seq"', 35, true);


--
-- TOC entry 2926 (class 0 OID 0)
-- Dependencies: 213
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationTo_TranslationToId_seq"', 29, true);


--
-- TOC entry 2927 (class 0 OID 0)
-- Dependencies: 216
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."UnitContent_UnitContent_seq"', 29, true);


--
-- TOC entry 2928 (class 0 OID 0)
-- Dependencies: 214
-- Name: UnitTree_UnitTreeId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."UnitTree_UnitTreeId_seq"', 5, true);


--
-- TOC entry 2760 (class 2606 OID 16475)
-- Name: Language Language_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Language"
    ADD CONSTRAINT "Language_pkey" PRIMARY KEY ("LanguageId");


--
-- TOC entry 2752 (class 2606 OID 16584)
-- Name: Phrase Phrase_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "Phrase_pkey" PRIMARY KEY ("PhraseId");


--
-- TOC entry 2754 (class 2606 OID 16488)
-- Name: TranslationFrom TranslationFrom_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "TranslationFrom_pkey" PRIMARY KEY ("TranslationFromId");


--
-- TOC entry 2758 (class 2606 OID 16565)
-- Name: TranslationLink TranslationLink_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationLink"
    ADD CONSTRAINT "TranslationLink_pkey" PRIMARY KEY ("TranslationLinkId");


--
-- TOC entry 2756 (class 2606 OID 16528)
-- Name: TranslationTo TranslationTo_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "TranslationTo_pkey" PRIMARY KEY ("TranslationToId");


--
-- TOC entry 2764 (class 2606 OID 16628)
-- Name: UnitContent UnitContentId_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "UnitContentId_pkey" PRIMARY KEY ("UnitContentId");


--
-- TOC entry 2762 (class 2606 OID 16616)
-- Name: UnitTree UnitTree_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "UnitTree_pkey" PRIMARY KEY ("UnitTreeId");


--
-- TOC entry 2765 (class 2606 OID 16476)
-- Name: Phrase FK_LanguageId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "FK_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES interrogator."Language"("LanguageId") NOT VALID;


--
-- TOC entry 2770 (class 2606 OID 16617)
-- Name: UnitTree FK_ParentUnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "FK_ParentUnitTreeId" FOREIGN KEY ("ParentUnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId") NOT VALID;


--
-- TOC entry 2766 (class 2606 OID 16585)
-- Name: TranslationFrom FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2768 (class 2606 OID 16590)
-- Name: TranslationTo FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2772 (class 2606 OID 16634)
-- Name: UnitContent FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId");


--
-- TOC entry 2769 (class 2606 OID 16799)
-- Name: TranslationTo FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2767 (class 2606 OID 16804)
-- Name: TranslationFrom FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2771 (class 2606 OID 16629)
-- Name: UnitContent FK_UnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_UnitTreeId" FOREIGN KEY ("UnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId");


-- Completed on 2020-01-26 16:25:22

--
-- PostgreSQL database dump complete
--

