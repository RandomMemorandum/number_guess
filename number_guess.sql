--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)
-- Dumped by pg_dump version 12.22 (Ubuntu 12.22-0ubuntu0.20.04.4)

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

DROP DATABASE number_guess;
--
-- Name: number_guess; Type: DATABASE; Schema: -; Owner: freecodecamp
--

CREATE DATABASE number_guess WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE number_guess OWNER TO freecodecamp;

\connect number_guess

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.sessions (
    session_id integer NOT NULL,
    user_id integer NOT NULL,
    game_start timestamp without time zone NOT NULL,
    secret_number integer NOT NULL,
    guesses_to_win integer
);


ALTER TABLE public.sessions OWNER TO freecodecamp;

--
-- Name: sessions_session_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.sessions_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_session_id_seq OWNER TO freecodecamp;

--
-- Name: sessions_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.sessions_session_id_seq OWNED BY public.sessions.session_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(22) NOT NULL
);


ALTER TABLE public.users OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: freecodecamp
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO freecodecamp;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: freecodecamp
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: sessions session_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.sessions ALTER COLUMN session_id SET DEFAULT nextval('public.sessions_session_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.sessions VALUES (1, 1, '2026-05-02 17:52:41', 336, NULL);
INSERT INTO public.sessions VALUES (2, 1, '2026-05-02 17:57:42', 664, 7);
INSERT INTO public.sessions VALUES (3, 1, '2026-05-02 17:59:30', 109, NULL);
INSERT INTO public.sessions VALUES (4, 2, '2026-05-02 17:59:36', 376, 377);
INSERT INTO public.sessions VALUES (5, 2, '2026-05-02 17:59:38', 616, 617);
INSERT INTO public.sessions VALUES (6, 3, '2026-05-02 17:59:41', 524, 525);
INSERT INTO public.sessions VALUES (7, 3, '2026-05-02 17:59:43', 450, 451);
INSERT INTO public.sessions VALUES (8, 2, '2026-05-02 17:59:45', 685, 688);
INSERT INTO public.sessions VALUES (9, 2, '2026-05-02 17:59:48', 142, 143);
INSERT INTO public.sessions VALUES (10, 2, '2026-05-02 17:59:49', 460, 461);
INSERT INTO public.sessions VALUES (12, 4, '2026-05-02 18:01:44', 721, NULL);
INSERT INTO public.sessions VALUES (11, 4, '2026-05-02 18:01:44', 39, 12);
INSERT INTO public.sessions VALUES (13, 5, '2026-05-02 18:01:47', 767, 768);
INSERT INTO public.sessions VALUES (14, 5, '2026-05-02 18:01:50', 776, 777);
INSERT INTO public.sessions VALUES (15, 4, '2026-05-02 18:01:53', 732, 735);
INSERT INTO public.sessions VALUES (16, 4, '2026-05-02 18:01:56', 224, 225);
INSERT INTO public.sessions VALUES (17, 4, '2026-05-02 18:01:57', 978, 979);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.users VALUES (1, 'Jon');
INSERT INTO public.users VALUES (2, 'user_1777759176717');
INSERT INTO public.users VALUES (3, 'user_1777759176716');
INSERT INTO public.users VALUES (4, 'user_1777759304025');
INSERT INTO public.users VALUES (5, 'user_1777759304024');


--
-- Name: sessions_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.sessions_session_id_seq', 17, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: freecodecamp
--

SELECT pg_catalog.setval('public.users_user_id_seq', 5, true);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: sessions fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: freecodecamp
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

