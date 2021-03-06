PGDMP     /                    x            postgres    12.1    12.1                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    13318    postgres    DATABASE     �   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    2839                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false                       0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    1            �            1255    16536    if_modified_func()    FUNCTION     �  CREATE FUNCTION public.if_modified_func() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'public'
    AS $$
DECLARE
    v_old_data TEXT;
    v_new_data TEXT;
BEGIN
    /*  If this actually for real auditing (where you need to log EVERY action),
        then you would need to use something like dblink or plperl that could log outside the transaction,
        regardless of whether the transaction committed or rolled back.
    */
 
    /* This dance with casting the NEW and OLD values to a ROW is not necessary in pg 9.0+ */
 
    IF (TG_OP = 'UPDATE') THEN
        v_old_data := ROW(OLD.*);
        v_new_data := ROW(NEW.*);
        INSERT INTO logged_actions (schema_name,table_name,user_name,action,original_data,new_data,query) 
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := ROW(OLD.*);
        INSERT INTO logged_actions (schema_name,table_name,user_name,action,original_data,query)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        v_new_data := ROW(NEW.*);
        INSERT INTO logged_actions (schema_name,table_name,user_name,action,new_data,query)
        VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
        RETURN NEW;
    ELSE
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - Other action occurred: %, at %',TG_OP,now();
        RETURN NULL;
    END IF;
 
EXCEPTION
    WHEN data_exception THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [DATA EXCEPTION] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN unique_violation THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [UNIQUE] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE WARNING '[AUDIT.IF_MODIFIED_FUNC] - UDF ERROR [OTHER] - SQLSTATE: %, SQLERRM: %',SQLSTATE,SQLERRM;
        RETURN NULL;
END;
$$;
 )   DROP FUNCTION public.if_modified_func();
       public          postgres    false            �            1259    16501 
   estudantes    TABLE     |   CREATE TABLE public.estudantes (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    id_number integer
);
    DROP TABLE public.estudantes;
       public         heap    postgres    false            �            1259    16499    estudantes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.estudantes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.estudantes_id_seq;
       public          postgres    false    204                       0    0    estudantes_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.estudantes_id_seq OWNED BY public.estudantes.id;
          public          postgres    false    203            �            1259    16522    logged_actions    TABLE     �  CREATE TABLE public.logged_actions (
    schema_name text NOT NULL,
    table_name text NOT NULL,
    user_name text,
    action_tstamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    action text NOT NULL,
    original_data text,
    new_data text,
    query text,
    CONSTRAINT logged_actions_action_check CHECK ((action = ANY (ARRAY['I'::text, 'D'::text, 'U'::text])))
)
WITH (fillfactor='100');
 "   DROP TABLE public.logged_actions;
       public         heap    postgres    false                       0    0    TABLE logged_actions    ACL     7   GRANT SELECT ON TABLE public.logged_actions TO PUBLIC;
          public          postgres    false    205            �
           2604    16504    estudantes id    DEFAULT     n   ALTER TABLE ONLY public.estudantes ALTER COLUMN id SET DEFAULT nextval('public.estudantes_id_seq'::regclass);
 <   ALTER TABLE public.estudantes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    203    204                      0    16501 
   estudantes 
   TABLE DATA           9   COPY public.estudantes (id, nome, id_number) FROM stdin;
    public          postgres    false    204   ;!                 0    16522    logged_actions 
   TABLE DATA           �   COPY public.logged_actions (schema_name, table_name, user_name, action_tstamp, action, original_data, new_data, query) FROM stdin;
    public          postgres    false    205   �!                  0    0    estudantes_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.estudantes_id_seq', 8, true);
          public          postgres    false    203            �
           2606    16540 #   estudantes estudantes_id_number_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.estudantes
    ADD CONSTRAINT estudantes_id_number_key UNIQUE (id_number);
 M   ALTER TABLE ONLY public.estudantes DROP CONSTRAINT estudantes_id_number_key;
       public            postgres    false    204            �
           2606    16506    estudantes estudantes_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.estudantes
    ADD CONSTRAINT estudantes_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.estudantes DROP CONSTRAINT estudantes_pkey;
       public            postgres    false    204            �
           1259    16535    logged_actions_action_idx    INDEX     V   CREATE INDEX logged_actions_action_idx ON public.logged_actions USING btree (action);
 -   DROP INDEX public.logged_actions_action_idx;
       public            postgres    false    205            �
           1259    16534     logged_actions_action_tstamp_idx    INDEX     d   CREATE INDEX logged_actions_action_tstamp_idx ON public.logged_actions USING btree (action_tstamp);
 4   DROP INDEX public.logged_actions_action_tstamp_idx;
       public            postgres    false    205            �
           1259    16533    logged_actions_schema_table_idx    INDEX     �   CREATE INDEX logged_actions_schema_table_idx ON public.logged_actions USING btree ((((schema_name || '.'::text) || table_name)));
 3   DROP INDEX public.logged_actions_schema_table_idx;
       public            postgres    false    205    205    205            �
           2620    16538    estudantes t_if_modified_trg    TRIGGER     �   CREATE TRIGGER t_if_modified_trg AFTER INSERT OR DELETE OR UPDATE ON public.estudantes FOR EACH ROW EXECUTE FUNCTION public.if_modified_func();
 5   DROP TRIGGER t_if_modified_trg ON public.estudantes;
       public          postgres    false    206    204               J   x�3�,IM-.NM-Ҝ1~\F�!���� �1'�4��	�1L2f�nE�)� �9�WiXЂ3$��lH� spy         }  x����n�@���sS�լ��6=\�F�,K�4$D�,�K���4��F�=���?��d�jwJ�J\�*�r�J���XHC�*�a�7�0Ч,__3}b����J�(��I�E��U,JLF�Q{� D��4��CG�(�ps�d�v<B��ͬ�HkFV����|.#Ĵ�@�W o��eΆ�����u�C����c���Z��Sw��x���^$/e���"��^����A��Jwqхs�:��mrЦ��M�[Jj���G�������'h��j7��kQr��V h�BQ�m��ɀ�k�C��`z?s�J�i��o�m�7F�H�\��@�ϐ6�*���Ky=�0�TS�u�G�f�����sK���V��	>.��     