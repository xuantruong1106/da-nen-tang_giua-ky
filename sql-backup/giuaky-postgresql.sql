PGDMP          	            }            giuaky    16.6    16.6 0    k           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            l           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            m           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            n           1262    17382    giuaky    DATABASE     ~   CREATE DATABASE giuaky WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Vietnamese_Vietnam.1252';
    DROP DATABASE giuaky;
                postgres    false                        3079    17477    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            o           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    17400 `   addstudentinfo(character varying, date, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.addstudentinfo(p_full_name character varying, p_date_of_birth date, p_hometown character varying, p_class_name character varying, p_course character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO info_student (full_name, date_of_birth, hometown, class_name, course)
    VALUES (p_full_name, p_date_of_birth, p_hometown, p_class_name, p_course);
END;
$$;
 �   DROP FUNCTION public.addstudentinfo(p_full_name character varying, p_date_of_birth date, p_hometown character varying, p_class_name character varying, p_course character varying);
       public          postgres    false                       1255    17515    check_account(text, text)    FUNCTION     /  CREATE FUNCTION public.check_account(p_email text, p_passwd text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_full_name TEXT;
BEGIN
    SELECT full_name INTO v_full_name
    FROM account
    WHERE email = p_email AND passwd = crypt(p_passwd, passwd);
    
    RETURN v_full_name;
END;
$$;
 A   DROP FUNCTION public.check_account(p_email text, p_passwd text);
       public          postgres    false                       1255    17514     create_account(text, text, text)    FUNCTION     Z  CREATE FUNCTION public.create_account(p_email text, p_passwd text, p_full_name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO account (email, passwd, full_name)
    VALUES (p_email, crypt(p_passwd, gen_salt('bf')), p_full_name);
    RETURN TRUE;
EXCEPTION
    WHEN unique_violation THEN
        RETURN FALSE;
END;
$$;
 T   DROP FUNCTION public.create_account(p_email text, p_passwd text, p_full_name text);
       public          postgres    false                       1255    17556    get_classes_and_courses()    FUNCTION     ;  CREATE FUNCTION public.get_classes_and_courses() RETURNS TABLE(class_name character varying, course_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT c.class_name, co.course_name 
    FROM class c
    JOIN course co ON c.course_id = co.id
    ORDER BY c.class_name;
END;
$$;
 0   DROP FUNCTION public.get_classes_and_courses();
       public          postgres    false            �            1259    17469    account    TABLE     �   CREATE TABLE public.account (
    id integer NOT NULL,
    email text NOT NULL,
    passwd text NOT NULL,
    full_name text NOT NULL
);
    DROP TABLE public.account;
       public         heap    postgres    false            �            1259    17468    account_id_seq    SEQUENCE     �   CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.account_id_seq;
       public          postgres    false    219            p           0    0    account_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;
          public          postgres    false    218            �            1259    17565    class    TABLE     ~   CREATE TABLE public.class (
    id integer NOT NULL,
    class_name character varying(100) NOT NULL,
    course_id integer
);
    DROP TABLE public.class;
       public         heap    postgres    false            �            1259    17564    class_id_seq    SEQUENCE     �   CREATE SEQUENCE public.class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.class_id_seq;
       public          postgres    false    225            q           0    0    class_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.class_id_seq OWNED BY public.class.id;
          public          postgres    false    224            �            1259    17558    course    TABLE     i   CREATE TABLE public.course (
    id integer NOT NULL,
    course_name character varying(100) NOT NULL
);
    DROP TABLE public.course;
       public         heap    postgres    false            �            1259    17557    course_id_seq    SEQUENCE     �   CREATE SEQUENCE public.course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.course_id_seq;
       public          postgres    false    223            r           0    0    course_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.course_id_seq OWNED BY public.course.id;
          public          postgres    false    222            �            1259    17392    info_student    TABLE       CREATE TABLE public.info_student (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    date_of_birth date NOT NULL,
    hometown character varying(255) NOT NULL,
    class_name character varying(100) NOT NULL,
    course character varying(100) NOT NULL
);
     DROP TABLE public.info_student;
       public         heap    postgres    false            �            1259    17391    info_student_id_seq    SEQUENCE     �   CREATE SEQUENCE public.info_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.info_student_id_seq;
       public          postgres    false    217            s           0    0    info_student_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.info_student_id_seq OWNED BY public.info_student.id;
          public          postgres    false    216            �            1259    17527    province    TABLE     �   CREATE TABLE public.province (
    id integer NOT NULL,
    province_name character varying(99) NOT NULL,
    province_code character varying(10) NOT NULL
);
    DROP TABLE public.province;
       public         heap    postgres    false            �            1259    17526    province_id_seq    SEQUENCE     �   CREATE SEQUENCE public.province_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.province_id_seq;
       public          postgres    false    221            t           0    0    province_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.province_id_seq OWNED BY public.province.id;
          public          postgres    false    220            �           2604    17472 
   account id    DEFAULT     h   ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);
 9   ALTER TABLE public.account ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    17568    class id    DEFAULT     d   ALTER TABLE ONLY public.class ALTER COLUMN id SET DEFAULT nextval('public.class_id_seq'::regclass);
 7   ALTER TABLE public.class ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    17561 	   course id    DEFAULT     f   ALTER TABLE ONLY public.course ALTER COLUMN id SET DEFAULT nextval('public.course_id_seq'::regclass);
 8   ALTER TABLE public.course ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    17395    info_student id    DEFAULT     r   ALTER TABLE ONLY public.info_student ALTER COLUMN id SET DEFAULT nextval('public.info_student_id_seq'::regclass);
 >   ALTER TABLE public.info_student ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    17530    province id    DEFAULT     j   ALTER TABLE ONLY public.province ALTER COLUMN id SET DEFAULT nextval('public.province_id_seq'::regclass);
 :   ALTER TABLE public.province ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    221    221            b          0    17469    account 
   TABLE DATA           ?   COPY public.account (id, email, passwd, full_name) FROM stdin;
    public          postgres    false    219   Y7       h          0    17565    class 
   TABLE DATA           :   COPY public.class (id, class_name, course_id) FROM stdin;
    public          postgres    false    225   �8       f          0    17558    course 
   TABLE DATA           1   COPY public.course (id, course_name) FROM stdin;
    public          postgres    false    223   �8       `          0    17392    info_student 
   TABLE DATA           b   COPY public.info_student (id, full_name, date_of_birth, hometown, class_name, course) FROM stdin;
    public          postgres    false    217   �8       d          0    17527    province 
   TABLE DATA           D   COPY public.province (id, province_name, province_code) FROM stdin;
    public          postgres    false    221   |9       u           0    0    account_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.account_id_seq', 4, true);
          public          postgres    false    218            v           0    0    class_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.class_id_seq', 3, true);
          public          postgres    false    224            w           0    0    course_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.course_id_seq', 3, true);
          public          postgres    false    222            x           0    0    info_student_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.info_student_id_seq', 23, true);
          public          postgres    false    216            y           0    0    province_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.province_id_seq', 63, true);
          public          postgres    false    220            �           2606    17476    account account_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.account DROP CONSTRAINT account_pkey;
       public            postgres    false    219            �           2606    17572    class class_course_id_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_course_id_key UNIQUE (course_id);
 C   ALTER TABLE ONLY public.class DROP CONSTRAINT class_course_id_key;
       public            postgres    false    225            �           2606    17570    class class_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.class DROP CONSTRAINT class_pkey;
       public            postgres    false    225            �           2606    17563    course course_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.course DROP CONSTRAINT course_pkey;
       public            postgres    false    223            �           2606    17399    info_student info_student_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.info_student
    ADD CONSTRAINT info_student_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.info_student DROP CONSTRAINT info_student_pkey;
       public            postgres    false    217            �           2606    17532    province province_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.province
    ADD CONSTRAINT province_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.province DROP CONSTRAINT province_pkey;
       public            postgres    false    221            �           2606    17534 #   province province_province_code_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.province
    ADD CONSTRAINT province_province_code_key UNIQUE (province_code);
 M   ALTER TABLE ONLY public.province DROP CONSTRAINT province_province_code_key;
       public            postgres    false    221            �           2606    17573    class class_course_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.class DROP CONSTRAINT class_course_id_fkey;
       public          postgres    false    225    4810    223            b     x�M�;r�@ �z9���vF��ՙ4�l����8��H����L��M���_���C&FR���2\2�i�h��v����_����v}�X!HLX����Q��������fa��\�y�`]f�~��
c�r�2?���U6I(�OДAq��H�k��>K����������l5$Q��ͪd�t�}�í=�~�j�~��k*q&ٽ9�	��c���Nu(���i��._��3�,M�=fٮeMs��F����)/XQ��>jB      h   &   x�3�42���4�2�42����9��A,c�=... q�
      f      x�3��62�2�F\�@Ҙ+F��� ,��      `   �   x�3���K/�|��5O!���<���c��id``�k`�kh�X�p��t��Ë39���<C8�����8K�J����Lu�t-9���2'����И�Ș3hOj�B^Fb	�h#]SdՆՆ\1z\\\ Y�0�      d   �  x�E��jQ�뙧8/��~���@����H���]�W���eH�"�B�.B.&��4R�b�ǾI��Zˍ`>͙�?�Jڭĳ2�&RV�W_����C.���ߪ���yϚ��ůq����ż�ı�`>ò�>�Բ�2FeU���c|_�����~V�X��!2��CO�7�9�x�2��A��i�_�����Y1k�90E=L����c���,��Y��S�X��S�	~�p�V�x0jAL`�@0�k1���P�?�Q�Yγ@e�|_�=lZ��,Ә���FyI޲J�$+��
��$�'��p���>�o�L+�ƣ��4ޛM�,?��HV����7(e����,�ʭT:a�;vPԷ�Y��zֵI5��ns��G�M�����/�2Z��4��P7&�u��U$kM�)ĝ��S�a)�+��IĖ���� X;F�L��%���H������{���(%���vlM
�3L�FR�U���l�<X�6� ��Y~$e٘hW��Cd_�年s[oaR6��L꫒�dYko�&ݢ�s��l:��� �wQ9�VRT . �HQV_�mjx�VS�K��2LGF��Yk�������[Gq�9Vm�� �d�Qz�`ַۯ=e;���ē]���9ʦ���d�1�]BY�S�Z�v���E��Nu �:&�)ʋ�8��;���/��     