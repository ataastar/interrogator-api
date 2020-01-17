--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

-- Started on 2020-01-17 22:59:35

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
-- TOC entry 225 (class 1255 OID 16762)
-- Name: insertunitcontent(json); Type: PROCEDURE; Schema: interrogator; Owner: postgres
--

CREATE PROCEDURE interrogator.insertunitcontent(json)
    LANGUAGE plpgsql
    AS $$
BEGIN
/*
with json_data as (
select * from json_populate_record(
	null::interrogator."InsertUnitContentTable",
	'{"code":3,"fromLanguage":"1","toLanguage":"2","from":["Vesz","Venni"],"to":["buy","to buy"],"example":"Valaki","translatedExample":"Someone"}')
),
tl as (insert into interrogator."TranslationLink"("Example", "TranslatedExample")
	select example, "translatedExample" from json_data d
	RETURNING "TranslationLinkId"),
uc as (insert into interrogator."UnitContent"("UnitTreeId", "TranslationLinkId")
	  select code, "TranslationLinkId" from json_data, tl
	  returning *)
select * from uc;


*/
END;
$$;


ALTER PROCEDURE interrogator.insertunitcontent(json) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16763)
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

CREATE VIEW interrogator."UnitContentJson" WITH (security_barrier='false') AS
 SELECT row_to_json(a.*) AS content,
    a.code
   FROM ( SELECT t."Name" AS name,
            t."UnitTreeId" AS code,
            ( SELECT array_to_json(array_agg(b.*)) AS array_to_json
                   FROM ( SELECT ( SELECT array_to_json(array_agg("Phrase"."Text")) AS fromphrase
                                   FROM (interrogator."TranslationFrom" translationfrom
                                     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationfrom."PhraseId")))
                                  WHERE (translationfrom."TranslationLinkId" = l."TranslationLinkId")) AS "from",
                            ( SELECT array_to_json(array_agg("Phrase"."Text")) AS tophrase
                                   FROM (interrogator."TranslationTo" translationto
                                     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationto."PhraseId")))
                                  WHERE (translationto."TranslationLinkId" = l."TranslationLinkId")) AS "to",
                            l."Example" AS example,
                            l."TranslatedExample" AS "translatedExample"
                           FROM (interrogator."TranslationLink" l
                             JOIN interrogator."UnitContent" c ON ((c."UnitTreeId" = t."UnitTreeId")))
                          WHERE (l."TranslationLinkId" = c."TranslationLinkId")) b) AS words
           FROM interrogator."UnitTree" t) a;


ALTER TABLE interrogator."UnitContentJson" OWNER TO attila;

--
-- TOC entry 221 (class 1259 OID 16727)
-- Name: UnitContentJson2; Type: VIEW; Schema: interrogator; Owner: postgres
--

CREATE VIEW interrogator."UnitContentJson2" AS
 SELECT row_to_json(a.*) AS content,
    a.code
   FROM ( SELECT t."Name" AS name,
            t."UnitTreeId" AS code,
            ( SELECT array_to_json(array_agg(b.*)) AS array_to_json
                   FROM ( SELECT ( SELECT array_to_json(array_agg("Phrase"."Text")) AS fromphrase
                                   FROM (interrogator."TranslationFrom" translationfrom
                                     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationfrom."PhraseId")))
                                  WHERE (translationfrom."TranslationLinkId" = l."TranslationLinkId")) AS "from",
                            ( SELECT array_to_json(array_agg("Phrase"."Text")) AS tophrase
                                   FROM (interrogator."TranslationTo" translationto
                                     JOIN interrogator."Phrase" ON (("Phrase"."PhraseId" = translationto."PhraseId")))
                                  WHERE (translationto."TranslationLinkId" = l."TranslationLinkId")) AS "to"
                           FROM (interrogator."TranslationLink" l
                             JOIN interrogator."UnitContent" c ON ((c."UnitTreeId" = t."UnitTreeId")))
                          WHERE (l."TranslationLinkId" = c."TranslationLinkId")) b) AS words
           FROM interrogator."UnitTree" t) a;


ALTER TABLE interrogator."UnitContentJson2" OWNER TO postgres;

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
-- TOC entry 220 (class 1259 OID 16723)
-- Name: UnitGroupJson2; Type: VIEW; Schema: interrogator; Owner: postgres
--

CREATE VIEW interrogator."UnitGroupJson2" AS
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


ALTER TABLE interrogator."UnitGroupJson2" OWNER TO postgres;

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
-- TOC entry 2917 (class 0 OID 16763)
-- Dependencies: 222
-- Data for Name: InsertUnitContentTable; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."InsertUnitContentTable" (code, "fromLanguage", "toLanguage", "from", "to", example, "translatedExample") FROM stdin;
\.


--
-- TOC entry 2907 (class 0 OID 16447)
-- Dependencies: 208
-- Data for Name: Language; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."Language" ("LanguageId", "Name", "Code") FROM stdin;
1	English	en
2	Hungarian	hu
\.


--
-- TOC entry 2903 (class 0 OID 16395)
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
\.


--
-- TOC entry 2904 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: TranslationFrom; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationFrom" ("TranslationFromId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	1	\N
3	2	4	\N
4	2	5	\N
\.


--
-- TOC entry 2906 (class 0 OID 16419)
-- Dependencies: 207
-- Data for Name: TranslationLink; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationLink" ("TranslationLinkId", "Example", "TranslatedExample", "ImageName") FROM stdin;
1	Valaki ellopta a pénztárcámat	Someone stole my wallet	\N
2	Vesz egy labdát	Buy a ball	\N
\.


--
-- TOC entry 2905 (class 0 OID 16411)
-- Dependencies: 206
-- Data for Name: TranslationTo; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationTo" ("TranslationToId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	2	\N
2	1	3	\N
3	2	6	\N
4	2	7	\N
\.


--
-- TOC entry 2916 (class 0 OID 16624)
-- Dependencies: 217
-- Data for Name: UnitContent; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."UnitContent" ("UnitContentId", "UnitTreeId", "TranslationLinkId") FROM stdin;
1	3	1
3	3	2
\.


--
-- TOC entry 2914 (class 0 OID 16612)
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
-- TOC entry 2923 (class 0 OID 0)
-- Dependencies: 209
-- Name: Language_LanguageId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Language_LanguageId_seq"', 2, true);


--
-- TOC entry 2924 (class 0 OID 0)
-- Dependencies: 210
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Phrase_PhraseId_seq"', 7, true);


--
-- TOC entry 2925 (class 0 OID 0)
-- Dependencies: 211
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationFrom_TranslationFromId_seq"', 4, true);


--
-- TOC entry 2926 (class 0 OID 0)
-- Dependencies: 212
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationLink_TranslationLinkId_seq"', 7, true);


--
-- TOC entry 2927 (class 0 OID 0)
-- Dependencies: 213
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationTo_TranslationToId_seq"', 5, true);


--
-- TOC entry 2928 (class 0 OID 0)
-- Dependencies: 216
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."UnitContent_UnitContent_seq"', 5, true);


--
-- TOC entry 2929 (class 0 OID 0)
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
-- TOC entry 2767 (class 2606 OID 16585)
-- Name: TranslationFrom FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2769 (class 2606 OID 16590)
-- Name: TranslationTo FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2766 (class 2606 OID 16566)
-- Name: TranslationFrom FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") NOT VALID;


--
-- TOC entry 2768 (class 2606 OID 16571)
-- Name: TranslationTo FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") NOT VALID;


--
-- TOC entry 2772 (class 2606 OID 16634)
-- Name: UnitContent FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId");


--
-- TOC entry 2771 (class 2606 OID 16629)
-- Name: UnitContent FK_UnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_UnitTreeId" FOREIGN KEY ("UnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId");


-- Completed on 2020-01-17 22:59:36

--
-- PostgreSQL database dump complete
--

