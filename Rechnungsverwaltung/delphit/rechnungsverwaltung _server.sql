--
-- PostgreSQL database cluster dump
--

-- Started on 2011-09-13 09:56:16

\connect postgres

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET escape_string_warning = off;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION PASSWORD 'md5f6cf36325b9d5405d5a59607bafcdb12';






--
-- Database creation
--

CREATE DATABASE rechnungsverwaltung WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.1rc1
-- Started on 2011-09-13 09:56:16

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 440 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

--
-- TOC entry 1778 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-09-13 09:56:16

--
-- PostgreSQL database dump complete
--

\connect rechnungsverwaltung

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.1rc1
-- Started on 2011-09-13 09:56:16

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 466 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 146 (class 1259 OID 17039)
-- Dependencies: 5
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    street character varying(255),
    plz character varying(255),
    city character varying(255),
    customer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 145 (class 1259 OID 17037)
-- Dependencies: 5 146
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO postgres;

--
-- TOC entry 1823 (class 0 OID 0)
-- Dependencies: 145
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- TOC entry 1824 (class 0 OID 0)
-- Dependencies: 145
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('addresses_id_seq', 12, true);


--
-- TOC entry 144 (class 1259 OID 17028)
-- Dependencies: 5
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    addresses_id integer,
    invoices_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    companyname character varying(255),
    email character varying(255)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 143 (class 1259 OID 17026)
-- Dependencies: 144 5
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- TOC entry 1825 (class 0 OID 0)
-- Dependencies: 143
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- TOC entry 1826 (class 0 OID 0)
-- Dependencies: 143
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_id_seq', 12, true);


--
-- TOC entry 150 (class 1259 OID 17058)
-- Dependencies: 5
-- Name: invoice_posses; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE invoice_posses (
    id integer NOT NULL,
    invoiceposnr character varying(255),
    description text,
    qty integer,
    unitprice numeric,
    total numeric,
    invoice_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.invoice_posses OWNER TO postgres;

--
-- TOC entry 149 (class 1259 OID 17056)
-- Dependencies: 150 5
-- Name: invoice_posses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE invoice_posses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_posses_id_seq OWNER TO postgres;

--
-- TOC entry 1827 (class 0 OID 0)
-- Dependencies: 149
-- Name: invoice_posses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE invoice_posses_id_seq OWNED BY invoice_posses.id;


--
-- TOC entry 1828 (class 0 OID 0)
-- Dependencies: 149
-- Name: invoice_posses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('invoice_posses_id_seq', 43, true);


--
-- TOC entry 148 (class 1259 OID 17050)
-- Dependencies: 5
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE invoices (
    id integer NOT NULL,
    invoicenr character varying(255),
    customer_id integer,
    invoice_posses_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- TOC entry 147 (class 1259 OID 17048)
-- Dependencies: 5 148
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoices_id_seq OWNER TO postgres;

--
-- TOC entry 1829 (class 0 OID 0)
-- Dependencies: 147
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- TOC entry 1830 (class 0 OID 0)
-- Dependencies: 147
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('invoices_id_seq', 63, true);


--
-- TOC entry 142 (class 1259 OID 17022)
-- Dependencies: 5
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- TOC entry 1801 (class 2604 OID 17042)
-- Dependencies: 146 145 146
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- TOC entry 1800 (class 2604 OID 17031)
-- Dependencies: 144 143 144
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- TOC entry 1803 (class 2604 OID 17061)
-- Dependencies: 150 149 150
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE invoice_posses ALTER COLUMN id SET DEFAULT nextval('invoice_posses_id_seq'::regclass);


--
-- TOC entry 1802 (class 2604 OID 17053)
-- Dependencies: 147 148 148
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- TOC entry 1815 (class 0 OID 17039)
-- Dependencies: 146
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY addresses (id, street, plz, city, customer_id, created_at, updated_at) FROM stdin;
11	asd	asd	asd	11	2011-09-08 08:32:09.758937	2011-09-08 08:32:09.784939
12	ert	ert	ert	12	2011-09-08 13:53:11.179099	2011-09-08 13:53:11.246103
\.


--
-- TOC entry 1814 (class 0 OID 17028)
-- Dependencies: 144
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers (id, firstname, lastname, addresses_id, invoices_id, created_at, updated_at, companyname, email) FROM stdin;
11	asd	asd	\N	\N	2011-09-08 08:32:09.773938	2011-09-08 08:32:09.773938	asd	\N
12	ert	ert	\N	\N	2011-09-08 13:53:11.233102	2011-09-08 13:53:11.233102	ert	ert
\.


--
-- TOC entry 1817 (class 0 OID 17058)
-- Dependencies: 150
-- Data for Name: invoice_posses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY invoice_posses (id, invoiceposnr, description, qty, unitprice, total, invoice_id, created_at, updated_at) FROM stdin;
42	1	asd1	1	1.0	1.0	63	2011-09-08 13:42:31.844958	2011-09-08 13:42:31.844958
43	1	asd1	1	1.0	1.0	62	2011-09-08 13:42:39.870399	2011-09-08 13:42:39.870399
\.


--
-- TOC entry 1816 (class 0 OID 17050)
-- Dependencies: 148
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY invoices (id, invoicenr, customer_id, invoice_posses_id, created_at, updated_at) FROM stdin;
62	1	11	\N	2011-09-08 12:27:09.284187	2011-09-08 12:27:09.284187
63	2	11	\N	2011-09-08 13:42:24.839636	2011-09-08 13:42:24.839636
\.


--
-- TOC entry 1813 (class 0 OID 17022)
-- Dependencies: 142
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version) FROM stdin;
20110824134157
20110824134158
20110824134159
20110831085139
20110901115449
20110905094824
20110908134904
\.


--
-- TOC entry 1808 (class 2606 OID 17047)
-- Dependencies: 146 146
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 1806 (class 2606 OID 17036)
-- Dependencies: 144 144
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 1812 (class 2606 OID 17066)
-- Dependencies: 150 150
-- Name: invoice_posses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY invoice_posses
    ADD CONSTRAINT invoice_posses_pkey PRIMARY KEY (id);


--
-- TOC entry 1810 (class 2606 OID 17055)
-- Dependencies: 148 148
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 1804 (class 1259 OID 17025)
-- Dependencies: 142
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- TOC entry 1822 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-09-13 09:56:16

--
-- PostgreSQL database dump complete
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.1rc1
-- Started on 2011-09-13 09:56:16

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1777 (class 1262 OID 1)
-- Dependencies: 1776
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template database';


--
-- TOC entry 440 (class 2612 OID 11574)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

--
-- TOC entry 1779 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-09-13 09:56:16

--
-- PostgreSQL database dump complete
--

-- Completed on 2011-09-13 09:56:16

--
-- PostgreSQL database cluster dump complete
--

