--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: lukasz
--

CREATE TYPE public.order_status_enum AS ENUM (
    'CANCEL',
    'IN PROGRESS',
    'DONE'
);


ALTER TYPE public.order_status_enum OWNER TO lukasz;

--
-- Name: role_right_enum; Type: TYPE; Schema: public; Owner: lukasz
--

CREATE TYPE public.role_right_enum AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public.role_right_enum OWNER TO lukasz;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    "totalPrice" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.cart OWNER TO lukasz;

--
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_id_seq OWNER TO lukasz;

--
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.category (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    index integer,
    display boolean DEFAULT true NOT NULL,
    "createdBy" integer,
    "updatedBy" integer,
    "parentCategoryId" integer,
    "pictureId" integer
);


ALTER TABLE public.category OWNER TO lukasz;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_id_seq OWNER TO lukasz;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public."order" (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    status public.order_status_enum NOT NULL,
    "createdBy" integer,
    "updatedBy" integer,
    "user" integer
);


ALTER TABLE public."order" OWNER TO lukasz;

--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_id_seq OWNER TO lukasz;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: order_stock; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.order_stock (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    "dateTimeStart" timestamp with time zone,
    "dateTimeEnd" timestamp with time zone,
    "createdBy" integer,
    "updatedBy" integer,
    "orderId" integer,
    "stockId" integer
);


ALTER TABLE public.order_stock OWNER TO lukasz;

--
-- Name: order_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.order_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_stock_id_seq OWNER TO lukasz;

--
-- Name: order_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.order_stock_id_seq OWNED BY public.order_stock.id;


--
-- Name: picture; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.picture (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    name character varying NOT NULL,
    mimetype character varying,
    path character varying,
    "urlHD" character varying,
    "urlMiniature" character varying,
    "createdBy" integer,
    "updatedBy" integer,
    "productReferenceId" integer
);


ALTER TABLE public.picture OWNER TO lukasz;

--
-- Name: picture_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.picture_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.picture_id_seq OWNER TO lukasz;

--
-- Name: picture_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.picture_id_seq OWNED BY public.picture.id;


--
-- Name: product_cart; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.product_cart (
    id integer NOT NULL,
    quantity integer NOT NULL,
    "dateTimeStart" timestamp with time zone NOT NULL,
    "dateTimeEnd" timestamp with time zone NOT NULL,
    "productReferenceId" integer,
    "cartReferenceId" integer
);


ALTER TABLE public.product_cart OWNER TO lukasz;

--
-- Name: product_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.product_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_cart_id_seq OWNER TO lukasz;

--
-- Name: product_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.product_cart_id_seq OWNED BY public.product_cart.id;


--
-- Name: product_reference; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.product_reference (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text NOT NULL,
    index integer,
    display boolean DEFAULT true NOT NULL,
    "brandName" character varying(150) NOT NULL,
    price integer NOT NULL,
    "createdBy" integer,
    "updatedBy" integer,
    "categoryId" integer
);


ALTER TABLE public.product_reference OWNER TO lukasz;

--
-- Name: product_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.product_reference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_reference_id_seq OWNER TO lukasz;

--
-- Name: product_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.product_reference_id_seq OWNED BY public.product_reference.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.role (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    "right" public.role_right_enum DEFAULT 'USER'::public.role_right_enum NOT NULL,
    "createdBy" integer,
    "updatedBy" integer
);


ALTER TABLE public.role OWNER TO lukasz;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO lukasz;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.stock (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    name character varying(50),
    "isAvailable" boolean DEFAULT true NOT NULL,
    "serialNumber" character varying(50) NOT NULL,
    "purchaseDataTime" timestamp with time zone,
    supplier character varying(50),
    sku character varying(50),
    "createdBy" integer,
    "updatedBy" integer,
    "productReference" integer
);


ALTER TABLE public.stock OWNER TO lukasz;

--
-- Name: stock_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_id_seq OWNER TO lukasz;

--
-- Name: stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.stock_id_seq OWNED BY public.stock.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public."user" (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now(),
    id integer NOT NULL,
    "firstName" character varying(50),
    "lastName" character varying(50),
    "nickName" character varying(50),
    "dateOfBirth" timestamp with time zone,
    "hashedPassword" character varying(250) NOT NULL,
    "phoneNumber" character varying(10),
    email character varying(255) NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "lastConnectionDate" timestamp without time zone,
    "createdBy" integer,
    "updatedBy" integer,
    "avatarId" integer,
    role integer,
    "cartId" integer
);


ALTER TABLE public."user" OWNER TO lukasz;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO lukasz;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_token; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.user_token (
    id integer NOT NULL,
    token character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" integer
);


ALTER TABLE public.user_token OWNER TO lukasz;

--
-- Name: user_token_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.user_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_token_id_seq OWNER TO lukasz;

--
-- Name: user_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.user_token_id_seq OWNED BY public.user_token.id;


--
-- Name: verification_code; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.verification_code (
    id integer NOT NULL,
    type character varying NOT NULL,
    code character varying NOT NULL,
    "expirationDate" timestamp without time zone,
    "maximumTry" integer DEFAULT 0 NOT NULL,
    "userId" integer
);


ALTER TABLE public.verification_code OWNER TO lukasz;

--
-- Name: verification_code_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.verification_code_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.verification_code_id_seq OWNER TO lukasz;

--
-- Name: verification_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.verification_code_id_seq OWNED BY public.verification_code.id;


--
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Name: order_stock id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock ALTER COLUMN id SET DEFAULT nextval('public.order_stock_id_seq'::regclass);


--
-- Name: picture id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.picture ALTER COLUMN id SET DEFAULT nextval('public.picture_id_seq'::regclass);


--
-- Name: product_cart id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_cart ALTER COLUMN id SET DEFAULT nextval('public.product_cart_id_seq'::regclass);


--
-- Name: product_reference id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_reference ALTER COLUMN id SET DEFAULT nextval('public.product_reference_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: stock id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.stock ALTER COLUMN id SET DEFAULT nextval('public.stock_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_token id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_token ALTER COLUMN id SET DEFAULT nextval('public.user_token_id_seq'::regclass);


--
-- Name: verification_code id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.verification_code ALTER COLUMN id SET DEFAULT nextval('public.verification_code_id_seq'::regclass);


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.cart (id, "totalPrice") FROM stdin;
1	0
2	0
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.category ("createdAt", "updatedAt", id, name, index, display, "createdBy", "updatedBy", "parentCategoryId", "pictureId") FROM stdin;
2024-01-01 00:00:00	\N	1	Snowboard	1	t	1	\N	\N	2
2024-01-01 00:00:00	\N	2	Salomon	1	t	1	\N	1	3
2024-09-03 01:41:39.317788	2024-09-03 01:41:39.317788	3	Bike	1	t	1	1	\N	\N
2024-09-03 01:42:57.601514	2024-09-03 01:42:57.601514	4	Giant	1	t	1	1	3	\N
2024-09-03 01:43:55.939777	2024-09-03 01:43:55.939777	5	Scott	1	t	1	1	3	\N
2024-09-03 01:44:34.445015	2024-09-03 01:44:34.445015	6	Burton	1	t	1	1	1	\N
2024-09-03 01:45:09.349975	2024-09-03 01:45:09.349975	7	Rossignol	1	t	1	1	1	\N
2024-09-03 01:45:40.065103	2024-09-03 01:45:40.065103	8	Skis	1	t	1	1	\N	\N
2024-09-03 01:46:25.295239	2024-09-03 01:46:25.295239	10	Fischer	1	t	1	1	8	\N
2024-09-03 01:46:46.805877	2024-09-03 01:46:46.805877	11	Atomic	1	t	1	1	8	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public."order" ("createdAt", "updatedAt", id, status, "createdBy", "updatedBy", "user") FROM stdin;
\.


--
-- Data for Name: order_stock; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.order_stock ("createdAt", "updatedAt", id, "dateTimeStart", "dateTimeEnd", "createdBy", "updatedBy", "orderId", "stockId") FROM stdin;
\.


--
-- Data for Name: picture; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.picture ("createdAt", "updatedAt", id, name, mimetype, path, "urlHD", "urlMiniature", "createdBy", "updatedBy", "productReferenceId") FROM stdin;
2024-01-01 00:00:00	\N	1	filenameAvatar	image/png	/avatar	/images/avatar/avatar-filenameAvatar-HD-$1725030829982-40d514a7-5102-41cc-bbf0-600.png	/images/avatar/avatar-filenameAvatar-Mini-$1725030829982-40d514a7-5102-41cc-bbf0-600.png	1	\N	\N
2024-01-01 00:00:00	\N	2	filenameCategory	image/png	/category	\N	/images/category/category-filenameCategory-Mini-$1725030829983-40d514a7-5102-41cc-bbf0-766ac23ef601.png	1	\N	\N
2024-01-01 00:00:00	\N	3	filenameCategory	image/png	/category	\N	/images/category/category-filenameCategory-Mini-$1725030829984-40d514a7-5102-41cc-bbf0-766ac23ef602.png	1	\N	\N
2024-01-01 00:00:00	\N	4	filenameSnowboard	image/png	/productReference	/images/productReference/productReference-filenameSnowboard-HD-$1725030829985-40d514a7-5102-41cc-bbf0-766ac23ef603.png	/images/productReference/productReference-filenameSnowboard-Mini-$1725030829985-40d514a7-5102-41cc-bbf0-766ac23ef603.png	1	\N	1
2024-09-03 01:40:37.996068	2024-09-03 01:40:38.035415	6	salomon-huck-knife	image/png	/images/productReference	/images/productReference/productReference-salomon-huck-knife-HD-$1725327637943-32243c79-11a4-4728-97c6-8b581de7f002.png	/images/productReference/productReference-salomon-huck-knife-Mini-$1725327637943-df4f5257-6e51-4d8a-a237-6d9a59ec01e2.png	1	\N	2
2024-09-03 02:28:09.10217	2024-09-03 02:28:09.126316	15	skis-fischer-2	image/png	/images/productReference	/images/productReference/productReference-skis-fischer-2-HD-$1725330489057-6d3469d1-74bd-4c22-a034-0c5775243005.png	/images/productReference/productReference-skis-fischer-2-Mini-$1725330489058-f9d0e853-f794-495e-8974-470848a302f5.png	1	\N	11
2024-09-03 01:58:03.488045	2024-09-03 01:58:03.514562	8	rossignol-XV	image/png	/images/productReference	/images/productReference/productReference-rossignol-XV-HD-$1725328683446-21a6ce53-e984-4f9f-a25a-d00f9b801a22.png	/images/productReference/productReference-rossignol-XV-Mini-$1725328683446-3f8241b6-578d-4212-a44c-a14df020b672.png	1	\N	4
2024-09-03 01:58:43.442521	2024-09-03 01:58:43.464281	9	Rossignol-Exp	image/png	/images/productReference	/images/productReference/productReference-Rossignol-Exp-HD-$1725328723403-ff443f0e-cc63-4397-99e9-0f45c1b48225.png	/images/productReference/productReference-Rossignol-Exp-Mini-$1725328723403-40ffbc7b-a16a-41d0-b821-ed6597582d2d.png	1	\N	5
2024-09-03 02:04:47.959792	2024-09-03 02:04:47.979784	10	vtt-giant-xtc-slr	image/png	/images/productReference	/images/productReference/productReference-vtt-giant-xtc-slr-HD-$1725329087904-b3fddc47-55a6-4f78-8076-93166105b8bf.png	/images/productReference/productReference-vtt-giant-xtc-slr-Mini-$1725329087904-a20b5569-5a06-4f43-80b5-ca06bd13d1a2.png	1	\N	6
2024-09-03 02:12:45.734934	2024-09-03 02:12:45.758384	11	GiantElectric	image/png	/images/productReference	/images/productReference/productReference-GiantElectric-HD-$1725329565688-c7600441-c240-42cf-b5e8-527f1fddd42d.png	/images/productReference/productReference-GiantElectric-Mini-$1725329565688-eb0a68c9-dbd9-40e7-a090-f2ce8221cf7a.png	1	\N	7
2024-09-03 02:17:36.856655	2024-09-03 02:17:36.879014	12	scott1	image/png	/images/productReference	/images/productReference/productReference-scott1-HD-$1725329856798-f2364611-74a9-464c-84de-5d41fabd3eea.png	/images/productReference/productReference-scott1-Mini-$1725329856798-669c95e6-714d-4335-8ce4-f42aeb5b18fc.png	1	\N	8
2024-09-03 02:22:49.978303	2024-09-03 02:22:50.001019	13	scott-2	image/png	/images/productReference	/images/productReference/productReference-scott-2-HD-$1725330169469-02b7bd8e-f6b9-4c95-9ae1-a62a3700af9e.png	/images/productReference/productReference-scott-2-Mini-$1725330169470-1114911a-0508-4c88-a573-2afb31feda88.png	1	\N	9
2024-09-03 02:24:45.998917	2024-09-03 02:24:46.023371	14	ski-fisher-1	image/png	/images/productReference	/images/productReference/productReference-ski-fisher-1-HD-$1725330285854-0fffcdb2-9eb4-437a-8310-fbdb55383a74.png	/images/productReference/productReference-ski-fisher-1-Mini-$1725330285854-7e491151-9946-4d39-a50b-ff77ffff4ed2.png	1	\N	10
2024-09-03 02:32:05.325722	2024-09-03 02:32:05.352282	16	atomic	image/png	/images/productReference	/images/productReference/productReference-atomic-HD-$1725330725285-e52f29ad-7011-4b7a-a88d-582d90e6c030.png	/images/productReference/productReference-atomic-Mini-$1725330725285-adb747de-c9ac-4db5-8f74-1b54bba1484b.png	1	\N	12
\.


--
-- Data for Name: product_cart; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.product_cart (id, quantity, "dateTimeStart", "dateTimeEnd", "productReferenceId", "cartReferenceId") FROM stdin;
\.


--
-- Data for Name: product_reference; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.product_reference ("createdAt", "updatedAt", id, name, description, index, display, "brandName", price, "createdBy", "updatedBy", "categoryId") FROM stdin;
2024-01-01 00:00:00	\N	1	Assassin Pro	Snowboard All-Mountain pour homme !	1	t	Salomon	1000	1	\N	2
2024-09-03 01:40:38.035415	2024-09-03 01:40:38.035415	2	Huck-knife	Le HUCK KNIFE de SALOMON est conçu pour les snowboarders de niveau intermédiaire à confirmé qui recherchent une planche polyvalente et réactive pour le freestyle, les sauts, les transitions et les rails. Son shape True Twin, son flex intermédiaire et ses nombreuses technologies en font un choix idéal pour les riders qui veulent repousser leurs limites dans le snowpark tout en conservant une certaine polyvalence sur les pistes. Avec son Quad Camber et sa ligne de cotes EQ Rad, il offre un équilibre précis entre stabilité, maniabilité et caractère ludique. La combinaison de matériaux de haute qualité assure également une durabilité exceptionnelle pour les riders actifs dans les snowparks et les environnements urbains.	\N	t	Salomon	1100	1	\N	2
2024-09-03 01:58:03.514562	2024-09-03 01:58:03.514562	4	Rossignol XV	La board de Xavier De Le Rue reste, année après année, une des planches leaders du freeride performance. Cette année, elle conserve son caractère tranchant, mais avec un flex adouci sur le centre, tandis que les spatules gardent le même soutien. On la travaille mieux en torsion, elle progresse en virages courts et gagne aussi de l’amorti à vitesse moyenne. On a une fois de plus été séduits par cette board toujours aussi complète et précise, directionnelle mais qui se ride sans être trop agressif.	\N	t	Rossignol	900	1	\N	7
2024-09-03 01:58:43.464281	2024-09-03 01:58:43.464281	5	Rossignol EXP	Destinées à la pratique du freestyle dans ses grandes largeurs  Rocker AmpTek Auto-Turn  Embouts de protection de spatules  Photo non contractuelle	\N	t	Rossignol	1000	1	\N	7
2024-09-03 02:04:47.979784	2024-09-03 02:04:47.979784	6	VTT Giant XTC SLR	Vélo à venir chercher en magasin à Voisins le Bretonneux (78), pas d'envoi possible.  Ce vélo est en stock actuellement en magasin. Pour une autre taille ou autre coloris n'hésitez pas à nous consulter.  Pour des informations détaillées sur toutes les spécifications de ce vélo, vous pouvez vous reporter au site de la marque qui indique les caractéristiques techniques complètes.	\N	t	Giant	800	1	\N	4
2024-09-03 02:12:45.758384	2024-09-03 02:12:45.758384	7	Explore E+	L'autonomie pour une seule charge de batterie peut varier considérablement en fonction des conditions : poids combiné du pilote et de la cargaison; résistance au vent; pression des pneus ; changements de terrain; dénivelé; surface de la route ou du sentier; température extérieure; entretien du vélo électrique; et évidemment l’état de la batterie.  La barre ci-dessous donne une distance approximative. Les conditions varient d'extrêmes à bonnes puis idéales. Les facteurs générant des conditions extrêmes peuvent être une charge lourde, un fort vent de face ou encore des montées abruptes.	\N	t	Giant	1200	1	\N	4
2024-09-03 02:17:36.879014	2024-09-03 02:17:36.879014	8	XC carbone	Le Spark RC Comp offre le mélange parfait entre une ingénierie carbone de pointe, des niveaux d’intégration jamais vus auparavant, et la dose exacte d’un ingrédient secret. Nous voulions rendre cette plateforme plus rapide que jamais en montée comme en descente. En augmentant le débattement, en perfectionnant la géométrie et en appliquant les conseils des meilleurs athlètes du monde, nous avons créé le vélo de course de cross-country ultime. Si vous aimez la vitesse, vous allez adorer ce vélo.	\N	t	Scott	1250	1	\N	5
2024-09-03 02:22:50.001019	2024-09-03 02:22:50.001019	9	Aspect 760	decs scoot 2	\N	t	Scott	800	1	\N	5
2024-09-03 02:24:46.023371	2024-09-03 02:24:46.023371	10	XTR Race	An ideal ski to improve in short to medium turns, on groomed slopes it will satisfy intermediate riders who want to progress with comfort.  Sidecuts: 116.5 73 98  14 m radius for a 150 cm ski	\N	t	Fischer	1200	1	\N	10
2024-09-03 02:28:09.126316	2024-09-03 02:28:09.126316	11	RC4 WC SC MT	Air Carbon TI 0.8 Wood Core with double Titanal shell, reinforced with Air Carbon. Perfect edge grip and extremely smooth running as a result.  Diagocarbon Innovative diagonal positioning of a glass fiber grid for excellent torsional stability with maximum power and stability in turns.  Hole Ski Technology Lower mass inertia moment thanks to less weight in the ski's tip and tail for improved oscillation behaviour, perfectly smooth running and better turning and control.  M-Track A new type of plate construction that yields an optimal stance for a smooth, balanced flex, and more confidence and security at speed.  Sandwich Sidewall Construction Wood core combined with ABS sidewalls in a classic Sandwich Construction for balanced flex and perfect rebound.  Shaped Ti 0.8 Shaped Ti is a titanium inlay matched precisely to the ski geometry. Specific contouring provides the appropriate amount of stability for a given ability level, plus optimal grip and a smooth ride.  Sintered Bases Sintered bases have exceptional waxing properties and a very long service life.  World Cup Tuning Edges and base are given an extremely precise World Cup level finish on the most modern grinding line in the world.	\N	t	Fischer	1100	1	\N	10
2024-09-03 02:32:05.352282	2024-09-03 02:32:05.352282	12	Bent 100	L’Atomic Bent 100 est un ski bispatulé sensationnel, qui fait du fun l’objectif numéro 1 et cela sur tous les terrains. Sa largeur et son profil cambre + double rocker permettent de passer partout en restant toujours maniable, tandis que sa construction est à la fois robuste et bien équilibrée entre performance et accessibilité.	\N	t	Atomic	800	1	\N	11
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.role ("createdAt", "updatedAt", id, name, "right", "createdBy", "updatedBy") FROM stdin;
2024-01-01 00:00:00	\N	1	Developers	ADMIN	\N	\N
2024-01-01 00:00:00	\N	2	Users	USER	\N	\N
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.stock ("createdAt", "updatedAt", id, name, "isAvailable", "serialNumber", "purchaseDataTime", supplier, sku, "createdBy", "updatedBy", "productReference") FROM stdin;
2024-01-01 00:00:00	\N	1	Giant Faith	t	N°00001	2020-01-01 00:00:00+00	Amazon	\N	1	\N	1
2024-01-01 00:00:00	\N	2	Giant Faith	t	N°00002	2020-01-01 00:00:00+00	Amazon	\N	1	\N	1
2024-01-01 00:00:00	\N	3	Giant Faith	t	N°00003	2020-01-01 00:00:00+00	Amazon	\N	1	\N	1
2024-01-01 00:00:00	\N	4	Giant Faith	t	N°00004	2020-01-01 00:00:00+00	Amazon	\N	1	\N	1
2024-01-01 00:00:00	\N	5	Giant Faith	t	N°00005	2020-01-01 00:00:00+00	Amazon	\N	1	\N	1
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public."user" ("createdAt", "updatedAt", id, "firstName", "lastName", "nickName", "dateOfBirth", "hashedPassword", "phoneNumber", email, "isVerified", "lastConnectionDate", "createdBy", "updatedBy", "avatarId", role, "cartId") FROM stdin;
2024-01-01 00:00:00	\N	1	Lukasz	SuperDev	Lulu	1985-07-23 00:00:00+00	$argon2id$v=19$m=65536,t=3,p=4$jTqXIhRXrLmgpBknU6HtYA$eTwliyGdxEgF4pYEQq/r1TYE9nQEVAvSbw6OeAAMlpc	0611111111	grzegorzewski.luk@gmail.com	t	\N	1	\N	1	1	1
2024-01-01 00:00:00	\N	2	Luk	Grz	Zed	1985-07-23 00:00:00+00	$argon2id$v=19$m=65536,t=3,p=4$c430gVPYflc+khCbj29lyg$cBcf2iZLduQdqH5BqZvYIw/vZ0dlJPL6NJV6sEf0W3o	0612345678	zed11temp@gmail.com	f	\N	2	\N	\N	2	2
\.


--
-- Data for Name: user_token; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.user_token (id, token, "createdAt", "userId") FROM stdin;
\.


--
-- Data for Name: verification_code; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.verification_code (id, type, code, "expirationDate", "maximumTry", "userId") FROM stdin;
1	code-verification	7660b397	2024-09-08 02:06:13.34	0	2
\.


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.cart_id_seq', 3, true);


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.category_id_seq', 1, false);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.order_id_seq', 1, false);


--
-- Name: order_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.order_stock_id_seq', 1, false);


--
-- Name: picture_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.picture_id_seq', 3, true);


--
-- Name: product_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.product_cart_id_seq', 1, false);


--
-- Name: product_reference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.product_reference_id_seq', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.role_id_seq', 2, true);


--
-- Name: stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.stock_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.user_id_seq', 2, true);


--
-- Name: user_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.user_token_id_seq', 1, false);


--
-- Name: verification_code_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.verification_code_id_seq', 1, true);


--
-- Name: stock PK_092bc1fc7d860426a1dec5aa8e9; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT "PK_092bc1fc7d860426a1dec5aa8e9" PRIMARY KEY (id);


--
-- Name: order PK_1031171c13130102495201e3e20; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "PK_1031171c13130102495201e3e20" PRIMARY KEY (id);


--
-- Name: order_stock PK_259c5b9be45d406a02f86543c47; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock
    ADD CONSTRAINT "PK_259c5b9be45d406a02f86543c47" PRIMARY KEY (id);


--
-- Name: picture PK_31ccf37c74bae202e771c0c2a38; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.picture
    ADD CONSTRAINT "PK_31ccf37c74bae202e771c0c2a38" PRIMARY KEY (id);


--
-- Name: user_token PK_48cb6b5c20faa63157b3c1baf7f; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_token
    ADD CONSTRAINT "PK_48cb6b5c20faa63157b3c1baf7f" PRIMARY KEY (id);


--
-- Name: category PK_9c4e4a89e3674fc9f382d733f03; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "PK_9c4e4a89e3674fc9f382d733f03" PRIMARY KEY (id);


--
-- Name: product_reference PK_a3e4a71637aee215ea5325e56c9; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_reference
    ADD CONSTRAINT "PK_a3e4a71637aee215ea5325e56c9" PRIMARY KEY (id);


--
-- Name: product_cart PK_a9eb3c6b183961debec3a968f91; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_cart
    ADD CONSTRAINT "PK_a9eb3c6b183961debec3a968f91" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: cart PK_c524ec48751b9b5bcfbf6e59be7; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT "PK_c524ec48751b9b5bcfbf6e59be7" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: verification_code PK_d702c086da466e5d25974512d46; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.verification_code
    ADD CONSTRAINT "PK_d702c086da466e5d25974512d46" PRIMARY KEY (id);


--
-- Name: user REL_342497b574edb2309ec8c6b62a; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "REL_342497b574edb2309ec8c6b62a" UNIQUE ("cartId");


--
-- Name: user REL_58f5c71eaab331645112cf8cfa; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "REL_58f5c71eaab331645112cf8cfa" UNIQUE ("avatarId");


--
-- Name: category REL_8cba0fbb2aebb8c65ca8c05390; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "REL_8cba0fbb2aebb8c65ca8c05390" UNIQUE ("pictureId");


--
-- Name: category UQ_23c05c292c439d77b0de816b500; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "UQ_23c05c292c439d77b0de816b500" UNIQUE (name);


--
-- Name: role UQ_ae4578dcaed5adff96595e61660; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "UQ_ae4578dcaed5adff96595e61660" UNIQUE (name);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: category FK_00bcc17ae1cb987a45edc616240; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "FK_00bcc17ae1cb987a45edc616240" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: product_reference FK_1136b88e3ec241a26259cce916b; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_reference
    ADD CONSTRAINT "FK_1136b88e3ec241a26259cce916b" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: role FK_17be5172ac2f4c67687a2e7c67d; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_17be5172ac2f4c67687a2e7c67d" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: order FK_2a142cd65f2cffe2d70de14ff36; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "FK_2a142cd65f2cffe2d70de14ff36" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: order_stock FK_2d3310a24a19c37e6f428010805; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock
    ADD CONSTRAINT "FK_2d3310a24a19c37e6f428010805" FOREIGN KEY ("stockId") REFERENCES public.stock(id);


--
-- Name: order_stock FK_2df465dc91bef55a2dd199317f5; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock
    ADD CONSTRAINT "FK_2df465dc91bef55a2dd199317f5" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: user FK_342497b574edb2309ec8c6b62aa; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_342497b574edb2309ec8c6b62aa" FOREIGN KEY ("cartId") REFERENCES public.cart(id) ON DELETE CASCADE;


--
-- Name: product_reference FK_3db94b86d8a4ef9e9728bf7c156; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_reference
    ADD CONSTRAINT "FK_3db94b86d8a4ef9e9728bf7c156" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: picture FK_4ca8f2e62a6ca87e53cadb58cf9; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.picture
    ADD CONSTRAINT "FK_4ca8f2e62a6ca87e53cadb58cf9" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: stock FK_504fa71ab2541f76b3710fcea88; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT "FK_504fa71ab2541f76b3710fcea88" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: user FK_58f5c71eaab331645112cf8cfa5; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_58f5c71eaab331645112cf8cfa5" FOREIGN KEY ("avatarId") REFERENCES public.picture(id) ON DELETE CASCADE;


--
-- Name: role FK_64a1786ac86cd459077a53f411f; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_64a1786ac86cd459077a53f411f" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: user FK_6620cd026ee2b231beac7cfe578; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_6620cd026ee2b231beac7cfe578" FOREIGN KEY (role) REFERENCES public.role(id);


--
-- Name: order FK_6807ee8d7ff4c3349f781c2b28e; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "FK_6807ee8d7ff4c3349f781c2b28e" FOREIGN KEY ("user") REFERENCES public."user"(id);


--
-- Name: stock FK_6be62c1de6177b81bf70a524986; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT "FK_6be62c1de6177b81bf70a524986" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: product_cart FK_7b8cd4a794f1762d5f18fca05dd; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_cart
    ADD CONSTRAINT "FK_7b8cd4a794f1762d5f18fca05dd" FOREIGN KEY ("cartReferenceId") REFERENCES public.cart(id);


--
-- Name: order_stock FK_807f42f99b46ece5e42d88364ba; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock
    ADD CONSTRAINT "FK_807f42f99b46ece5e42d88364ba" FOREIGN KEY ("orderId") REFERENCES public."order"(id);


--
-- Name: user FK_82319f64187836b307e6d6ba08d; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_82319f64187836b307e6d6ba08d" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: category FK_8cba0fbb2aebb8c65ca8c05390f; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "FK_8cba0fbb2aebb8c65ca8c05390f" FOREIGN KEY ("pictureId") REFERENCES public.picture(id);


--
-- Name: order_stock FK_9af086fb9e7575cbc55fb4c904a; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.order_stock
    ADD CONSTRAINT "FK_9af086fb9e7575cbc55fb4c904a" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: verification_code FK_9d714363703b95d7bb9a9be0248; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.verification_code
    ADD CONSTRAINT "FK_9d714363703b95d7bb9a9be0248" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: category FK_9e5435ba76dbc1f1a0705d4db43; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "FK_9e5435ba76dbc1f1a0705d4db43" FOREIGN KEY ("parentCategoryId") REFERENCES public.category(id);


--
-- Name: user FK_a19025a009be58684a63961aaf3; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_a19025a009be58684a63961aaf3" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: product_cart FK_a1a3d419caad5c398eb0fdf3107; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_cart
    ADD CONSTRAINT "FK_a1a3d419caad5c398eb0fdf3107" FOREIGN KEY ("productReferenceId") REFERENCES public.product_reference(id);


--
-- Name: stock FK_c79f2a29a7da0af836829505404; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT "FK_c79f2a29a7da0af836829505404" FOREIGN KEY ("productReference") REFERENCES public.product_reference(id);


--
-- Name: picture FK_cb05ca3312be22f65a74e6623c2; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.picture
    ADD CONSTRAINT "FK_cb05ca3312be22f65a74e6623c2" FOREIGN KEY ("productReferenceId") REFERENCES public.product_reference(id);


--
-- Name: picture FK_cf8e46f10d20682d52ff4b55c30; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.picture
    ADD CONSTRAINT "FK_cf8e46f10d20682d52ff4b55c30" FOREIGN KEY ("createdBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: user_token FK_d37db50eecdf9b8ce4eedd2f918; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_token
    ADD CONSTRAINT "FK_d37db50eecdf9b8ce4eedd2f918" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: category FK_dbec3186ea4b206ce9694e3bb88; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "FK_dbec3186ea4b206ce9694e3bb88" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: product_reference FK_f6ac6e3ef77b0bc27eb8349a94f; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.product_reference
    ADD CONSTRAINT "FK_f6ac6e3ef77b0bc27eb8349a94f" FOREIGN KEY ("categoryId") REFERENCES public.category(id);


--
-- Name: order FK_fa6a675e30b3b9e71a9388bf288; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "FK_fa6a675e30b3b9e71a9388bf288" FOREIGN KEY ("updatedBy") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--
