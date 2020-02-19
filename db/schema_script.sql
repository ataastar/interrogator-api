--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

-- Started on 2020-02-19 22:39:44

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
-- TOC entry 240 (class 1255 OID 16827)
-- Name: insertunitcontent(json); Type: FUNCTION; Schema: interrogator; Owner: postgres
--

CREATE FUNCTION interrogator.insertunitcontent(json_input json) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
	"unitContentId" bigint;
BEGIN

insert into interrogator."tmp_insertjson"(insertjson)
select json_input;

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

insert into interrogator."tmp_insertjson"(insertjson) values ("unitContentId");

return "unitContentId";

END;
$$;


ALTER FUNCTION interrogator.insertunitcontent(json_input json) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16763)
-- Name: InsertUnitContentTable; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator."InsertUnitContentTable" (
    id bigint,
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
    "Name" character varying(255) NOT NULL,
    "FromLanguageId" bigint,
    "ToLanguageId" bigint
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
-- TOC entry 222 (class 1259 OID 16821)
-- Name: UnitWithRoot; Type: VIEW; Schema: interrogator; Owner: attila
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


ALTER TABLE interrogator."UnitWithRoot" OWNER TO attila;

--
-- TOC entry 2927 (class 0 OID 0)
-- Dependencies: 222
-- Name: VIEW "UnitWithRoot"; Type: COMMENT; Schema: interrogator; Owner: attila
--

COMMENT ON VIEW interrogator."UnitWithRoot" IS 'Returns the UnitTreeId and its Root UniTreeId and language ids';


--
-- TOC entry 221 (class 1259 OID 16769)
-- Name: tmp_insertjson; Type: TABLE; Schema: interrogator; Owner: attila
--

CREATE TABLE interrogator.tmp_insertjson (
    insertjson character varying(2000)
);


ALTER TABLE interrogator.tmp_insertjson OWNER TO attila;

--
-- TOC entry 2920 (class 0 OID 16763)
-- Dependencies: 220
-- Data for Name: InsertUnitContentTable; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."InsertUnitContentTable" (id, "from", "to", example, "translatedExample") FROM stdin;
\.


--
-- TOC entry 2910 (class 0 OID 16447)
-- Dependencies: 208
-- Data for Name: Language; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."Language" ("LanguageId", "Name", "Code") FROM stdin;
1	English	en
2	Hungarian	hu
\.


--
-- TOC entry 2906 (class 0 OID 16395)
-- Dependencies: 204
-- Data for Name: Phrase; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."Phrase" ("PhraseId", "LanguageId", "Text", "Pronunciation", "AudioName") FROM stdin;
1	2	Lopni	\N	\N
2	1	Steal	\N	\N
3	1	to steal	\N	\N
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
85	2	eat	\N	\N
86	1	eszik	\N	\N
112	2	beautiful	\N	\N
113	1	gyönyörű	\N	\N
114	2	cloudy	\N	\N
115	1	felhős	\N	\N
116	2	bridge	\N	\N
117	1	híd	\N	\N
118	2	canal	\N	\N
119	1	csatorna	\N	\N
120	2	capital	\N	\N
121	1	főváros	\N	\N
122	2	city	\N	\N
123	1	nagyváros	\N	\N
124	1	város	\N	\N
125	2	cliff	\N	\N
126	1	szikla	\N	\N
127	2	coast	\N	\N
128	1	tengerpart	\N	\N
129	2	deep	\N	\N
130	1	mély	\N	\N
131	2	forest	\N	\N
132	1	erdő	\N	\N
133	2	grand	\N	\N
134	1	nemes	\N	\N
135	1	előkelő	\N	\N
136	2	halfway	\N	\N
137	1	félúton	\N	\N
138	2	high	\N	\N
139	1	magas	\N	\N
140	2	hill	\N	\N
141	1	hegy	\N	\N
142	1	domb	\N	\N
143	2	island	\N	\N
144	1	sziget	\N	\N
145	2	Isle of Wight	\N	\N
146	1	Wight-sziget	\N	\N
147	2	kilometre	\N	\N
148	1	kilométer	\N	\N
149	2	lake	\N	\N
150	1	tó	\N	\N
151	2	long	\N	\N
152	1	hosszú	\N	\N
153	2	march	\N	\N
154	1	menetelni	\N	\N
157	2	metre	\N	\N
158	1	méter	\N	\N
161	2	million	\N	\N
162	1	millió	\N	\N
163	2	monster	\N	\N
164	1	szörny	\N	\N
167	2	mountain	\N	\N
168	1	hegy	\N	\N
169	2	neither ... nor	\N	\N
170	1	sem ... sem	\N	\N
171	2	river	\N	\N
172	1	folyó	\N	\N
173	2	sea	\N	\N
174	1	tenger	\N	\N
175	2	the Thames	\N	\N
176	1	Temze	\N	\N
177	2	tunnel	\N	\N
178	1	alagút	\N	\N
179	2	valley	\N	\N
180	1	völgy	\N	\N
181	2	wide	\N	\N
182	1	széles	\N	\N
\.


--
-- TOC entry 2907 (class 0 OID 16403)
-- Dependencies: 205
-- Data for Name: TranslationFrom; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationFrom" ("TranslationFromId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	1	\N
29	28	64	\N
30	28	65	\N
31	29	67	\N
32	32	71	\N
33	33	73	\N
34	34	75	\N
35	34	76	\N
37	47	86	\N
50	60	113	\N
51	61	115	\N
52	64	117	\N
53	65	119	\N
54	66	121	\N
55	67	123	\N
56	67	124	\N
57	68	126	\N
58	69	128	\N
59	70	130	\N
60	71	132	\N
61	72	134	\N
62	72	135	\N
63	73	137	\N
64	74	139	\N
65	75	141	\N
66	75	142	\N
67	76	144	\N
68	77	146	\N
69	78	148	\N
70	79	150	\N
71	80	152	\N
72	81	154	\N
74	83	158	\N
76	85	162	\N
77	86	164	\N
79	88	168	\N
80	89	170	\N
81	90	172	\N
82	91	174	\N
83	92	176	\N
84	93	178	\N
85	94	180	\N
86	95	182	\N
\.


--
-- TOC entry 2909 (class 0 OID 16419)
-- Dependencies: 207
-- Data for Name: TranslationLink; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationLink" ("TranslationLinkId", "Example", "TranslatedExample", "ImageName") FROM stdin;
1	Valaki ellopta a pénztárcámat	Someone stole my wallet	\N
60	\N	\N	\N
61	\N	\N	\N
64	\N	\N	\N
65			\N
66			\N
67			\N
68			\N
69			\N
70			\N
71			\N
72			\N
73			\N
74			\N
75			\N
76			\N
77			\N
78			\N
79			\N
80			\N
81			\N
83	\N	\N	\N
28	Vágja a kenyeret	Cut the bread	\N
29	Dobja a labdát	Throw the ball	\N
85	\N	\N	\N
86			\N
32	Éppen írok	I'm writing now	\N
33			\N
34	Készítem a házimat	I do my homework	\N
88	\N	\N	\N
89			\N
90			\N
91			\N
92			\N
93			\N
94			\N
95			\N
47	\N	\N	\N
\.


--
-- TOC entry 2908 (class 0 OID 16411)
-- Dependencies: 206
-- Data for Name: TranslationTo; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."TranslationTo" ("TranslationToId", "TranslationLinkId", "PhraseId", "Order") FROM stdin;
1	1	2	\N
2	1	3	\N
24	28	62	\N
25	28	63	\N
26	29	66	\N
27	32	70	\N
28	33	72	\N
29	34	74	\N
31	47	85	\N
45	60	112	\N
46	61	114	\N
47	64	116	\N
48	65	118	\N
49	66	120	\N
50	67	122	\N
51	68	125	\N
52	69	127	\N
53	70	129	\N
54	71	131	\N
55	72	133	\N
56	73	136	\N
57	74	138	\N
58	75	140	\N
59	76	143	\N
60	77	145	\N
61	78	147	\N
62	79	149	\N
63	80	151	\N
64	81	153	\N
66	83	157	\N
68	85	161	\N
69	86	163	\N
71	88	167	\N
72	89	169	\N
73	90	171	\N
74	91	173	\N
75	92	175	\N
76	93	177	\N
77	94	179	\N
78	95	181	\N
\.


--
-- TOC entry 2919 (class 0 OID 16624)
-- Dependencies: 217
-- Data for Name: UnitContent; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."UnitContent" ("UnitContentId", "UnitTreeId", "TranslationLinkId") FROM stdin;
1	3	1
25	3	28
26	3	29
27	3	32
28	3	33
29	3	34
36	3	47
49	7	60
50	8	61
53	7	64
54	7	65
55	7	66
56	7	67
57	7	68
58	7	69
59	7	70
60	7	71
61	7	72
62	7	73
63	7	74
64	7	75
65	7	76
66	7	77
67	7	78
68	7	79
69	7	80
70	7	81
72	7	83
74	7	85
75	7	86
77	7	88
78	7	89
79	7	90
80	7	91
81	7	92
82	7	93
83	7	94
84	7	95
\.


--
-- TOC entry 2917 (class 0 OID 16612)
-- Dependencies: 215
-- Data for Name: UnitTree; Type: TABLE DATA; Schema: interrogator; Owner: attila
--

COPY interrogator."UnitTree" ("UnitTreeId", "ParentUnitTreeId", "Name", "FromLanguageId", "ToLanguageId") FROM stdin;
2	1	Unit 3	\N	\N
3	2	A	\N	\N
4	2	B	\N	\N
5	2	C	\N	\N
1	\N	Project 2.	2	1
6	1	Unit 5	\N	\N
7	6	A	\N	\N
8	6	B\n	\N	\N
9	6	C	\N	\N
10	6	D	\N	\N
11	6	Culture	\N	\N
12	6	English across the curriculum	\N	\N
13	6	Revision	\N	\N
14	6	Your project	\N	\N
\.


--
-- TOC entry 2921 (class 0 OID 16769)
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
{"id":"3","from":[{"phrase":"sdkfjkh"}],"to":[{"phrase":"hjhj"}]}
{"id":"3","from":[{"phrase":"jhjh"}],"to":[{"phrase":"jhjh"}]}
{"id":"3","from":[{"phrase":"hjh"}],"to":[{"phrase":"jhjh"}],"example":"","translatedExample":""}
{"id":"3","from":[{"phrase":"jklj"}],"to":[{"phrase":"kjkj"}],"example":"","translatedExample":""}
{"id":"3","from":[{"phrase":"kjkj"}],"to":[{"phrase":"kjkj"}]}
{"from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}
{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}
{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}],"example":"","translatedExample":""}
{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}]}
{"id":"3","from":[{"phrase":"teszt"}],"to":[{"phrase":"test"}],"example":"","translatedExample":""}
{"id":"3","from":[{"phrase":"tezst"}],"to":[{"phrase":"test"}],"example":"teszt","translatedExample":"test"}
{"id":"3","from":[{"phrase":"1"},{"phrase":"2"}],"to":[{"phrase":"10"},{"phrase":"20"},{"phrase":"30"}],"example":"3","translatedExample":"40"}
{"id":"3","from":[null,"0"],"to":[null,"0"],"example":"","translatedExample":""}
{"id":"3","from":["0"],"to":["0"],"example":"","translatedExample":""}
{"id":"3","from":[""],"to":[""],"example":"","translatedExample":""}
{"id":"3","from":[""],"to":[""],"example":"","translatedExample":""}
{"id":"3","from":["teszt"],"to":["test"]}
{"id":"3","from":["teszt"],"to":["test"],"example":"","translatedExample":""}
{"id":"3","from":["eszik"],"to":["eat"]}
{"id":"3","from":["eszik"],"to":["have breakfast","has breakfast"]}
{"id":"3","from":["sf"],"to":["sf"]}
{"id":"3","from":["t"],"to":["t"]}
{"id":"3","from":["f"],"to":["f"]}
{"id":"3","from":["df"],"to":["df"]}
{"id":"3","from":["a"],"to":["a"]}
{"id":"3","from":["b"],"to":["b"]}
{"id":"3","from":["a"],"to":["a"]}
{"id":"3","from":["bb"],"to":["ab"],"example":"","translatedExample":""}
{"id":"3","from":["b"],"to":["b"],"example":"","translatedExample":""}
{"id":"3","from":["s"],"to":["j"]}
{"id":"3","from":["reszt"],"to":["test"]}
{"id":"7","from":["gyönyörű"],"to":["beautiful"]}
{"id":"8","from":["felhős"],"to":["cloudy"]}
{"from":["híd"],"to":["bridge"]}
{"from":["híd"],"to":["bridge"]}
{"id":"7","from":["híd"],"to":["bridge"]}
{"id":"7","from":["csatorna"],"to":["canal"],"example":"","translatedExample":""}
{"id":"7","from":["főváros"],"to":["capital"],"example":"","translatedExample":""}
{"id":"7","from":["nagyváros","város"],"to":["city"],"example":"","translatedExample":""}
{"id":"7","from":["szikla"],"to":["cliff"],"example":"","translatedExample":""}
{"id":"7","from":["tengerpart"],"to":["coast"],"example":"","translatedExample":""}
{"id":"7","from":["mély"],"to":["deep"],"example":"","translatedExample":""}
{"id":"7","from":["erdő"],"to":["forest"],"example":"","translatedExample":""}
{"id":"7","from":["nemes","előkelő"],"to":["grand"],"example":"","translatedExample":""}
{"id":"7","from":["félúton"],"to":["halfway"],"example":"","translatedExample":""}
{"id":"7","from":["magas"],"to":["high"],"example":"","translatedExample":""}
{"id":"7","from":["hegy","domb"],"to":["hill"],"example":"","translatedExample":""}
{"id":"7","from":["sziget"],"to":["island"],"example":"","translatedExample":""}
{"id":"7","from":["Wight-sziget"],"to":["Isle of Wight"],"example":"","translatedExample":""}
{"id":"7","from":["kilométer"],"to":["kilometre"],"example":"","translatedExample":""}
{"id":"7","from":["tó"],"to":["lake"],"example":"","translatedExample":""}
{"id":"7","from":["hosszú"],"to":["long"],"example":"","translatedExample":""}
{"id":"7","from":["menetelni"],"to":["march"],"example":"","translatedExample":""}
{"id":"7","from":["méter"],"to":["merte"],"example":"","translatedExample":""}
{"id":"7","from":["méter"],"to":["metre"]}
{"id":"7","from":["millió"],"to":["millon"],"example":"","translatedExample":""}
{"id":"7","from":["millió"],"to":["million"]}
{"id":"7","from":["szörny"],"to":["monster"],"example":"","translatedExample":""}
{"id":"7","from":["hely"],"to":["mountain"],"example":"","translatedExample":""}
{"id":"7","from":["hegy"],"to":["mountain"]}
{"id":"7","from":["sem ... sem"],"to":["neither ... nor"],"example":"","translatedExample":""}
{"id":"7","from":["folyó"],"to":["river"],"example":"","translatedExample":""}
{"id":"7","from":["tenger"],"to":["sea"],"example":"","translatedExample":""}
{"id":"7","from":["Temze"],"to":["the Thames"],"example":"","translatedExample":""}
{"id":"7","from":["alagút"],"to":["tunnel"],"example":"","translatedExample":""}
{"id":"7","from":["völgy"],"to":["valley"],"example":"","translatedExample":""}
{"id":"7","from":["széles"],"to":["wide"],"example":"","translatedExample":""}
{"id":"4","from":["a"],"to":["a"]}
{"id":"4","from":["a"],"to":["a"]}
{"id":"4","from":["b"],"to":["b"],"example":"","translatedExample":""}
{"id":"4","from":["c"],"to":["c"],"example":"","translatedExample":""}
{"id":"4","from":["d"],"to":["d"],"example":"","translatedExample":""}
4
{"id":"4","from":["e"],"to":["e"],"example":"","translatedExample":""}
90
{"id":"4","from":["f"],"to":["f"],"example":"","translatedExample":""}
91
{"id":"4","from":["g"],"to":["g"],"example":"","translatedExample":""}
92
{"id":"4","from":["h"],"to":["h"]}
93
{"id":"4","from":["a"],"to":["a"]}
94
{"id":"4","from":["a"],"to":["a"]}
95
{"id":"4","from":["a"],"to":["a"]}
96
{"id":"4","from":["b"],"to":["b"]}
97
{"id":"4","from":["c"],"to":["c"]}
98
{"id":"4","from":["a"],"to":["a"],"example":"","translatedExample":""}
99
{"id":"4","from":["a"],"to":["a"]}
100
{"id":"4","from":["a"],"to":["a"]}
102
{"id":"4","from":["a"],"to":["a"],"example":"","translatedExample":""}
103
{"id":"4","from":["c"],"to":["c"],"example":"","translatedExample":""}
104
\.


--
-- TOC entry 2928 (class 0 OID 0)
-- Dependencies: 209
-- Name: Language_LanguageId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Language_LanguageId_seq"', 2, true);


--
-- TOC entry 2929 (class 0 OID 0)
-- Dependencies: 210
-- Name: Phrase_PhraseId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."Phrase_PhraseId_seq"', 220, true);


--
-- TOC entry 2930 (class 0 OID 0)
-- Dependencies: 211
-- Name: TranslationFrom_TranslationFromId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationFrom_TranslationFromId_seq"', 105, true);


--
-- TOC entry 2931 (class 0 OID 0)
-- Dependencies: 212
-- Name: TranslationLink_TranslationLinkId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationLink_TranslationLinkId_seq"', 121, true);


--
-- TOC entry 2932 (class 0 OID 0)
-- Dependencies: 213
-- Name: TranslationTo_TranslationToId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."TranslationTo_TranslationToId_seq"', 97, true);


--
-- TOC entry 2933 (class 0 OID 0)
-- Dependencies: 216
-- Name: UnitContent_UnitContent_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."UnitContent_UnitContent_seq"', 110, true);


--
-- TOC entry 2934 (class 0 OID 0)
-- Dependencies: 214
-- Name: UnitTree_UnitTreeId_seq; Type: SEQUENCE SET; Schema: interrogator; Owner: attila
--

SELECT pg_catalog.setval('interrogator."UnitTree_UnitTreeId_seq"', 14, true);


--
-- TOC entry 2764 (class 2606 OID 16475)
-- Name: Language Language_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Language"
    ADD CONSTRAINT "Language_pkey" PRIMARY KEY ("LanguageId");


--
-- TOC entry 2756 (class 2606 OID 16584)
-- Name: Phrase Phrase_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "Phrase_pkey" PRIMARY KEY ("PhraseId");


--
-- TOC entry 2758 (class 2606 OID 16488)
-- Name: TranslationFrom TranslationFrom_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "TranslationFrom_pkey" PRIMARY KEY ("TranslationFromId");


--
-- TOC entry 2762 (class 2606 OID 16565)
-- Name: TranslationLink TranslationLink_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationLink"
    ADD CONSTRAINT "TranslationLink_pkey" PRIMARY KEY ("TranslationLinkId");


--
-- TOC entry 2760 (class 2606 OID 16528)
-- Name: TranslationTo TranslationTo_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "TranslationTo_pkey" PRIMARY KEY ("TranslationToId");


--
-- TOC entry 2768 (class 2606 OID 16628)
-- Name: UnitContent UnitContentId_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "UnitContentId_pkey" PRIMARY KEY ("UnitContentId");


--
-- TOC entry 2766 (class 2606 OID 16616)
-- Name: UnitTree UnitTree_pkey; Type: CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "UnitTree_pkey" PRIMARY KEY ("UnitTreeId");


--
-- TOC entry 2769 (class 2606 OID 16476)
-- Name: Phrase FK_LanguageId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."Phrase"
    ADD CONSTRAINT "FK_LanguageId" FOREIGN KEY ("LanguageId") REFERENCES interrogator."Language"("LanguageId") NOT VALID;


--
-- TOC entry 2774 (class 2606 OID 16617)
-- Name: UnitTree FK_ParentUnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitTree"
    ADD CONSTRAINT "FK_ParentUnitTreeId" FOREIGN KEY ("ParentUnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId") NOT VALID;


--
-- TOC entry 2770 (class 2606 OID 16585)
-- Name: TranslationFrom FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2772 (class 2606 OID 16590)
-- Name: TranslationTo FK_PhraseId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_PhraseId" FOREIGN KEY ("PhraseId") REFERENCES interrogator."Phrase"("PhraseId") NOT VALID;


--
-- TOC entry 2776 (class 2606 OID 16634)
-- Name: UnitContent FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId");


--
-- TOC entry 2773 (class 2606 OID 16799)
-- Name: TranslationTo FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationTo"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2771 (class 2606 OID 16804)
-- Name: TranslationFrom FK_TranslationLinkId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."TranslationFrom"
    ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES interrogator."TranslationLink"("TranslationLinkId") ON DELETE CASCADE;


--
-- TOC entry 2775 (class 2606 OID 16629)
-- Name: UnitContent FK_UnitTreeId; Type: FK CONSTRAINT; Schema: interrogator; Owner: attila
--

ALTER TABLE ONLY interrogator."UnitContent"
    ADD CONSTRAINT "FK_UnitTreeId" FOREIGN KEY ("UnitTreeId") REFERENCES interrogator."UnitTree"("UnitTreeId");


-- Completed on 2020-02-19 22:39:45

--
-- PostgreSQL database dump complete
--

