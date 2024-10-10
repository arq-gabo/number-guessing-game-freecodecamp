--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)
-- Dumped by pg_dump version 12.17 (Ubuntu 12.17-1.pgdg22.04+1)

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
-- Name: number_guessing_game; Type: TABLE; Schema: public; Owner: freecodecamp
--

CREATE TABLE public.number_guessing_game (
    username character varying(22) NOT NULL,
    games_played integer DEFAULT 0 NOT NULL,
    best_game integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.number_guessing_game OWNER TO freecodecamp;

--
-- Data for Name: number_guessing_game; Type: TABLE DATA; Schema: public; Owner: freecodecamp
--

INSERT INTO public.number_guessing_game VALUES ('aaron', 1, 15);
INSERT INTO public.number_guessing_game VALUES ('gabriel', 2, 8);
INSERT INTO public.number_guessing_game VALUES ('user_1728579033662', 2, 116);
INSERT INTO public.number_guessing_game VALUES ('user_1728579033663', 5, 590);
INSERT INTO public.number_guessing_game VALUES ('user_1728579098352', 2, 16);
INSERT INTO public.number_guessing_game VALUES ('user_1728579098353', 5, 231);
INSERT INTO public.number_guessing_game VALUES ('user_1728579303463', 2, 95);
INSERT INTO public.number_guessing_game VALUES ('user_1728579303464', 5, 648);


--
-- PostgreSQL database dump complete
--

