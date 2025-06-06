PGDMP                      }            Opportune Bridge    16.3    16.3 G    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    44591    Opportune Bridge    DATABASE     �   CREATE DATABASE "Opportune Bridge" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';
 "   DROP DATABASE "Opportune Bridge";
                postgres    false                        3079    44608 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1255    44676    update_modified_at_column()    FUNCTION     �   CREATE FUNCTION public.update_modified_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.modified_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.update_modified_at_column();
       public          postgres    false            �            1255    44726 &   update_permission_modified_at_column()    FUNCTION     �   CREATE FUNCTION public.update_permission_modified_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.modified_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 =   DROP FUNCTION public.update_permission_modified_at_column();
       public          postgres    false            �            1255    44620    update_updated_at_column()    FUNCTION     �   CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.update_updated_at_column();
       public          postgres    false            �            1255    44749    update_user_updated_at_column()    FUNCTION     �   CREATE FUNCTION public.update_user_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 6   DROP FUNCTION public.update_user_updated_at_column();
       public          postgres    false            �            1255    44775 #   update_userauth_updated_at_column()    FUNCTION     �   CREATE FUNCTION public.update_userauth_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 :   DROP FUNCTION public.update_userauth_updated_at_column();
       public          postgres    false            �            1259    44884    CustomPermissions    TABLE     �  CREATE TABLE public."CustomPermissions" (
    permission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_id uuid NOT NULL,
    module_id uuid NOT NULL,
    admin_child_user_id uuid,
    is_custom boolean DEFAULT false NOT NULL,
    can_read boolean DEFAULT false NOT NULL,
    can_add boolean DEFAULT false NOT NULL,
    can_edit boolean DEFAULT false NOT NULL,
    can_delete boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT "Permissions_can_add_check" CHECK ((can_add = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_delete_check" CHECK ((can_delete = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_edit_check" CHECK ((can_edit = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_read_check" CHECK ((can_read = ANY (ARRAY[true, false])))
);
 '   DROP TABLE public."CustomPermissions";
       public         heap    postgres    false    2            �            1259    44678    Module    TABLE     C  CREATE TABLE public."Module" (
    module_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    module_name character varying(100) NOT NULL,
    description text NOT NULL,
    is_global boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_by uuid,
    modified_by uuid,
    CONSTRAINT "Module_description_check" CHECK ((char_length(TRIM(BOTH FROM description)) > 0)),
    CONSTRAINT "Module_is_active_check" CHECK ((is_active = ANY (ARRAY[true, false]))),
    CONSTRAINT "Module_is_global_check" CHECK ((is_global = ANY (ARRAY[true, false]))),
    CONSTRAINT module_name_not_empty CHECK ((char_length(TRIM(BOTH FROM module_name)) > 0))
);
    DROP TABLE public."Module";
       public         heap    postgres    false    2            �           0    0    TABLE "Module"    COMMENT     m   COMMENT ON TABLE public."Module" IS 'Stores application modules and their metadata including descriptions.';
          public          postgres    false    217            �            1259    44698    Permissions    TABLE     �  CREATE TABLE public."Permissions" (
    permission_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_id uuid NOT NULL,
    module_id uuid NOT NULL,
    can_read boolean DEFAULT false NOT NULL,
    can_add boolean DEFAULT false NOT NULL,
    can_edit boolean DEFAULT false NOT NULL,
    can_delete boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid,
    modified_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    CONSTRAINT "Permissions_can_add_check" CHECK ((can_add = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_delete_check" CHECK ((can_delete = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_edit_check" CHECK ((can_edit = ANY (ARRAY[true, false]))),
    CONSTRAINT "Permissions_can_read_check" CHECK ((can_read = ANY (ARRAY[true, false])))
);
 !   DROP TABLE public."Permissions";
       public         heap    postgres    false    2            �           0    0    TABLE "Permissions"    COMMENT     �   COMMENT ON TABLE public."Permissions" IS 'Maps roles and optionally users to modules with specific CRUD permissions. Allows admins to assign custom permissions to their child users.';
          public          postgres    false    218            �            1259    44782    RoleHierarchy    TABLE     �  CREATE TABLE public."RoleHierarchy" (
    role_hierarchy_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    parent_role_id uuid NOT NULL,
    child_role_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT "NoSelfReference" CHECK ((parent_role_id <> child_role_id))
);
 #   DROP TABLE public."RoleHierarchy";
       public         heap    postgres    false    2            �           0    0    TABLE "RoleHierarchy"    COMMENT     }   COMMENT ON TABLE public."RoleHierarchy" IS 'Maps parent roles to their child roles, defining the role hierarchy structure.';
          public          postgres    false    221            �            1259    44639    Roles    TABLE     s  CREATE TABLE public."Roles" (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying(50) NOT NULL,
    is_global boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_by uuid,
    updated_by uuid,
    description text DEFAULT ''::text NOT NULL,
    is_parent_role boolean DEFAULT false NOT NULL,
    CONSTRAINT "Roles_is_active_check" CHECK ((is_active = ANY (ARRAY[true, false]))),
    CONSTRAINT "Roles_is_global_check" CHECK ((is_global = ANY (ARRAY[true, false]))),
    CONSTRAINT chk_role_name_lower CHECK (((role_name)::text = lower((role_name)::text))),
    CONSTRAINT role_name_not_empty CHECK ((char_length(TRIM(BOTH FROM role_name)) > 0))
);
    DROP TABLE public."Roles";
       public         heap    postgres    false    2            �           0    0    TABLE "Roles"    COMMENT     B   COMMENT ON TABLE public."Roles" IS 'Stores the roles for users.';
          public          postgres    false    216            �            1259    44751    UserAuth    TABLE     �  CREATE TABLE public."UserAuth" (
    user_auth_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    email character varying(320) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    last_login_at timestamp without time zone,
    failed_attempts integer DEFAULT 0 NOT NULL,
    locked_until timestamp without time zone,
    refresh_token character varying(255),
    refresh_token_expires_at timestamp without time zone,
    token_revoked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "UserAuth_email_check" CHECK ((((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text) AND (POSITION((' '::text) IN (email)) = 0) AND (POSITION((','::text) IN (email)) = 0))),
    CONSTRAINT "UserAuth_failed_attempts_check" CHECK ((failed_attempts >= 0)),
    CONSTRAINT "UserAuth_is_verified_check" CHECK ((is_verified = ANY (ARRAY[true, false]))),
    CONSTRAINT "UserAuth_token_revoked_check" CHECK ((token_revoked = ANY (ARRAY[true, false])))
);
    DROP TABLE public."UserAuth";
       public         heap    postgres    false    2            �           0    0    TABLE "UserAuth"    COMMENT        COMMENT ON TABLE public."UserAuth" IS 'Stores sensitive authentication information, tokens, MFA, and session data for users.';
          public          postgres    false    220            �            1259    44728    Users    TABLE     �  CREATE TABLE public."Users" (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    date_of_birth date,
    gender character varying(10),
    avatar bytea,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "User_date_of_birth_check" CHECK (((date_of_birth IS NULL) OR (date_of_birth <= CURRENT_DATE))),
    CONSTRAINT "User_first_name_check" CHECK ((char_length(TRIM(BOTH FROM first_name)) > 2)),
    CONSTRAINT "User_gender_check" CHECK (((gender IS NULL) OR ((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))),
    CONSTRAINT "User_is_active_check" CHECK ((is_active = ANY (ARRAY[true, false]))),
    CONSTRAINT "User_last_name_check" CHECK ((char_length(TRIM(BOTH FROM last_name)) > 2)),
    CONSTRAINT "User_phone_check" CHECK (((phone)::text ~ '^[0-9+\-\s()]{7,20}$'::text)),
    CONSTRAINT "User_username_check" CHECK (((char_length(TRIM(BOTH FROM username)) > 2) AND ((username)::text ~ '^[A-Za-z0-9_.-]+$'::text))),
    CONSTRAINT user_name_not_empty CHECK ((char_length(TRIM(BOTH FROM username)) > 2))
);
    DROP TABLE public."Users";
       public         heap    postgres    false    2            �           0    0    TABLE "Users"    COMMENT        COMMENT ON TABLE public."Users" IS 'Stores user profile and non-authentication information, including avatar image as bytea.';
          public          postgres    false    219            �            1259    44844    admin_child_user    TABLE     �  CREATE TABLE public.admin_child_user (
    admin_child_user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    admin_id uuid NOT NULL,
    child_id uuid NOT NULL,
    relation_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT no_self_reference CHECK ((admin_id <> child_id))
);
 $   DROP TABLE public.admin_child_user;
       public         heap    postgres    false    2            �           0    0    TABLE admin_child_user    COMMENT     �   COMMENT ON TABLE public.admin_child_user IS 'Maps admin users to their child users, representing hierarchical user relationships for permission and management purposes.';
          public          postgres    false    222            �           0    0     COLUMN admin_child_user.admin_id    COMMENT     ]   COMMENT ON COLUMN public.admin_child_user.admin_id IS 'User ID of the admin (parent user).';
          public          postgres    false    222            �           0    0     COLUMN admin_child_user.child_id    COMMENT     b   COMMENT ON COLUMN public.admin_child_user.child_id IS 'User ID of the child (subordinate user).';
          public          postgres    false    222            �          0    44884    CustomPermissions 
   TABLE DATA           �   COPY public."CustomPermissions" (permission_id, role_id, module_id, admin_child_user_id, is_custom, can_read, can_add, can_edit, can_delete, created_at, updated_at, is_active) FROM stdin;
    public          postgres    false    223   Pr       �          0    44678    Module 
   TABLE DATA           �   COPY public."Module" (module_id, module_name, description, is_global, created_at, modified_at, is_active, created_by, modified_by) FROM stdin;
    public          postgres    false    217   mr       �          0    44698    Permissions 
   TABLE DATA           �   COPY public."Permissions" (permission_id, role_id, module_id, can_read, can_add, can_edit, can_delete, created_at, created_by, modified_at, modified_by) FROM stdin;
    public          postgres    false    218   eu       �          0    44782    RoleHierarchy 
   TABLE DATA           �   COPY public."RoleHierarchy" (role_hierarchy_id, parent_role_id, child_role_id, created_at, updated_at, created_by, updated_by) FROM stdin;
    public          postgres    false    221   �u       �          0    44639    Roles 
   TABLE DATA           �   COPY public."Roles" (role_id, role_name, is_global, created_at, updated_at, is_active, created_by, updated_by, description, is_parent_role) FROM stdin;
    public          postgres    false    216   3w       �          0    44751    UserAuth 
   TABLE DATA           �   COPY public."UserAuth" (user_auth_id, user_id, email, password_hash, is_verified, last_login_at, failed_attempts, locked_until, refresh_token, refresh_token_expires_at, token_revoked, created_at, updated_at) FROM stdin;
    public          postgres    false    220   !{       �          0    44728    Users 
   TABLE DATA           �   COPY public."Users" (user_id, username, first_name, last_name, phone, date_of_birth, gender, avatar, is_active, created_at, updated_at) FROM stdin;
    public          postgres    false    219   >{       �          0    44844    admin_child_user 
   TABLE DATA           �   COPY public.admin_child_user (admin_child_user_id, admin_id, child_id, relation_description, created_at, updated_at, is_active) FROM stdin;
    public          postgres    false    222   [{       �           2606    44901 (   CustomPermissions CustomPermissions_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."CustomPermissions"
    ADD CONSTRAINT "CustomPermissions_pkey" PRIMARY KEY (permission_id);
 V   ALTER TABLE ONLY public."CustomPermissions" DROP CONSTRAINT "CustomPermissions_pkey";
       public            postgres    false    223            �           2606    44695    Module Module_module_name_key 
   CONSTRAINT     c   ALTER TABLE ONLY public."Module"
    ADD CONSTRAINT "Module_module_name_key" UNIQUE (module_name);
 K   ALTER TABLE ONLY public."Module" DROP CONSTRAINT "Module_module_name_key";
       public            postgres    false    217            �           2606    44693    Module Module_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Module"
    ADD CONSTRAINT "Module_pkey" PRIMARY KEY (module_id);
 @   ALTER TABLE ONLY public."Module" DROP CONSTRAINT "Module_pkey";
       public            postgres    false    217            �           2606    44713    Permissions Permissions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT "Permissions_pkey" PRIMARY KEY (permission_id);
 J   ALTER TABLE ONLY public."Permissions" DROP CONSTRAINT "Permissions_pkey";
       public            postgres    false    218            �           2606    44790     RoleHierarchy RoleHierarchy_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public."RoleHierarchy"
    ADD CONSTRAINT "RoleHierarchy_pkey" PRIMARY KEY (role_hierarchy_id);
 N   ALTER TABLE ONLY public."RoleHierarchy" DROP CONSTRAINT "RoleHierarchy_pkey";
       public            postgres    false    221            �           2606    44792 "   RoleHierarchy RoleHierarchy_unique 
   CONSTRAINT     z   ALTER TABLE ONLY public."RoleHierarchy"
    ADD CONSTRAINT "RoleHierarchy_unique" UNIQUE (parent_role_id, child_role_id);
 P   ALTER TABLE ONLY public."RoleHierarchy" DROP CONSTRAINT "RoleHierarchy_unique";
       public            postgres    false    221    221            �           2606    44652    Roles Roles_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY (role_id);
 >   ALTER TABLE ONLY public."Roles" DROP CONSTRAINT "Roles_pkey";
       public            postgres    false    216            �           2606    44654    Roles Roles_role_name_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_role_name_key" UNIQUE (role_name);
 G   ALTER TABLE ONLY public."Roles" DROP CONSTRAINT "Roles_role_name_key";
       public            postgres    false    216            �           2606    44769    UserAuth UserAuth_email_key 
   CONSTRAINT     [   ALTER TABLE ONLY public."UserAuth"
    ADD CONSTRAINT "UserAuth_email_key" UNIQUE (email);
 I   ALTER TABLE ONLY public."UserAuth" DROP CONSTRAINT "UserAuth_email_key";
       public            postgres    false    220            �           2606    44767    UserAuth UserAuth_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public."UserAuth"
    ADD CONSTRAINT "UserAuth_pkey" PRIMARY KEY (user_auth_id);
 D   ALTER TABLE ONLY public."UserAuth" DROP CONSTRAINT "UserAuth_pkey";
       public            postgres    false    220            �           2606    44746    Users User_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);
 =   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "User_pkey";
       public            postgres    false    219            �           2606    44748    Users User_username_key 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "User_username_key" UNIQUE (username);
 E   ALTER TABLE ONLY public."Users" DROP CONSTRAINT "User_username_key";
       public            postgres    false    219            �           2606    44855 &   admin_child_user admin_child_user_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.admin_child_user
    ADD CONSTRAINT admin_child_user_pkey PRIMARY KEY (admin_child_user_id);
 P   ALTER TABLE ONLY public.admin_child_user DROP CONSTRAINT admin_child_user_pkey;
       public            postgres    false    222            �           2606    44715    Permissions role_module_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT role_module_unique UNIQUE (role_id, module_id);
 J   ALTER TABLE ONLY public."Permissions" DROP CONSTRAINT role_module_unique;
       public            postgres    false    218    218            �           2606    44857 #   admin_child_user unique_admin_child 
   CONSTRAINT     l   ALTER TABLE ONLY public.admin_child_user
    ADD CONSTRAINT unique_admin_child UNIQUE (admin_id, child_id);
 M   ALTER TABLE ONLY public.admin_child_user DROP CONSTRAINT unique_admin_child;
       public            postgres    false    222    222            �           2606    44903 )   CustomPermissions unique_role_module_user 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomPermissions"
    ADD CONSTRAINT unique_role_module_user UNIQUE (role_id, module_id, admin_child_user_id);
 U   ALTER TABLE ONLY public."CustomPermissions" DROP CONSTRAINT unique_role_module_user;
       public            postgres    false    223    223    223            �           1259    44696    idx_module_module_name    INDEX     R   CREATE INDEX idx_module_module_name ON public."Module" USING btree (module_name);
 *   DROP INDEX public.idx_module_module_name;
       public            postgres    false    217            �           1259    44804    idx_rolehierarchy_child_role_id    INDEX     d   CREATE INDEX idx_rolehierarchy_child_role_id ON public."RoleHierarchy" USING btree (child_role_id);
 3   DROP INDEX public.idx_rolehierarchy_child_role_id;
       public            postgres    false    221            �           1259    44803     idx_rolehierarchy_parent_role_id    INDEX     f   CREATE INDEX idx_rolehierarchy_parent_role_id ON public."RoleHierarchy" USING btree (parent_role_id);
 4   DROP INDEX public.idx_rolehierarchy_parent_role_id;
       public            postgres    false    221            �           1259    44655    idx_roles_role_name    INDEX     L   CREATE INDEX idx_roles_role_name ON public."Roles" USING btree (role_name);
 '   DROP INDEX public.idx_roles_role_name;
       public            postgres    false    216            �           2620    44697     Module update_module_modified_at    TRIGGER     �   CREATE TRIGGER update_module_modified_at BEFORE UPDATE ON public."Module" FOR EACH ROW EXECUTE FUNCTION public.update_modified_at_column();
 ;   DROP TRIGGER update_module_modified_at ON public."Module";
       public          postgres    false    217    235            �           2620    44727 )   Permissions update_permission_modified_at    TRIGGER     �   CREATE TRIGGER update_permission_modified_at BEFORE UPDATE ON public."Permissions" FOR EACH ROW EXECUTE FUNCTION public.update_permission_modified_at_column();
 D   DROP TRIGGER update_permission_modified_at ON public."Permissions";
       public          postgres    false    236    218            �           2620    44656    Roles update_roles_updated_at    TRIGGER     �   CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON public."Roles" FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
 8   DROP TRIGGER update_roles_updated_at ON public."Roles";
       public          postgres    false    216    234            �           2620    44750    Users update_user_updated_at    TRIGGER     �   CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON public."Users" FOR EACH ROW EXECUTE FUNCTION public.update_user_updated_at_column();
 7   DROP TRIGGER update_user_updated_at ON public."Users";
       public          postgres    false    238    219            �           2620    44776 #   UserAuth update_userauth_updated_at    TRIGGER     �   CREATE TRIGGER update_userauth_updated_at BEFORE UPDATE ON public."UserAuth" FOR EACH ROW EXECUTE FUNCTION public.update_userauth_updated_at_column();
 >   DROP TRIGGER update_userauth_updated_at ON public."UserAuth";
       public          postgres    false    220    237            �           2606    44914 (   CustomPermissions fk_admin_child_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomPermissions"
    ADD CONSTRAINT fk_admin_child_user_id FOREIGN KEY (admin_child_user_id) REFERENCES public.admin_child_user(admin_child_user_id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public."CustomPermissions" DROP CONSTRAINT fk_admin_child_user_id;
       public          postgres    false    4835    222    223            �           2606    44858    admin_child_user fk_admin_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.admin_child_user
    ADD CONSTRAINT fk_admin_id FOREIGN KEY (admin_id) REFERENCES public."Users"(user_id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.admin_child_user DROP CONSTRAINT fk_admin_id;
       public          postgres    false    222    219    4821            �           2606    44863    admin_child_user fk_child_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.admin_child_user
    ADD CONSTRAINT fk_child_id FOREIGN KEY (child_id) REFERENCES public."Users"(user_id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.admin_child_user DROP CONSTRAINT fk_child_id;
       public          postgres    false    219    4821    222            �           2606    44798    RoleHierarchy fk_child_role    FK CONSTRAINT     �   ALTER TABLE ONLY public."RoleHierarchy"
    ADD CONSTRAINT fk_child_role FOREIGN KEY (child_role_id) REFERENCES public."Roles"(role_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public."RoleHierarchy" DROP CONSTRAINT fk_child_role;
       public          postgres    false    4807    216    221            �           2606    44721    Permissions fk_module_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT fk_module_id FOREIGN KEY (module_id) REFERENCES public."Module"(module_id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public."Permissions" DROP CONSTRAINT fk_module_id;
       public          postgres    false    218    217    4814            �           2606    44904    CustomPermissions fk_module_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomPermissions"
    ADD CONSTRAINT fk_module_id FOREIGN KEY (module_id) REFERENCES public."Module"(module_id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public."CustomPermissions" DROP CONSTRAINT fk_module_id;
       public          postgres    false    217    223    4814            �           2606    44793    RoleHierarchy fk_parent_role    FK CONSTRAINT     �   ALTER TABLE ONLY public."RoleHierarchy"
    ADD CONSTRAINT fk_parent_role FOREIGN KEY (parent_role_id) REFERENCES public."Roles"(role_id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."RoleHierarchy" DROP CONSTRAINT fk_parent_role;
       public          postgres    false    216    4807    221            �           2606    44716    Permissions fk_role_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."Permissions"
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES public."Roles"(role_id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public."Permissions" DROP CONSTRAINT fk_role_id;
       public          postgres    false    218    4807    216            �           2606    44909    CustomPermissions fk_role_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomPermissions"
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES public."Roles"(role_id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public."CustomPermissions" DROP CONSTRAINT fk_role_id;
       public          postgres    false    4807    216    223            �           2606    44770    UserAuth fk_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public."UserAuth"
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public."Users"(user_id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public."UserAuth" DROP CONSTRAINT fk_user_id;
       public          postgres    false    220    219    4821            �      x������ � �      �   �  x���ˎ�:�י���rqgv�$�dS�+�>$q��3j���eZHH茔U|����~ĺ��QhUYWF(]w�JR�5�B+�7~$��G�>�Ft8Y7a��{H���<8���� �t�"i�����a\W�÷�3_��!y�J�	�9P<d)+�y#�
�P�e}�����?-���;��JYv��\�PBV
��m)ڢ�y^���U�5�n��^��p��z=���ui�sf^���0�`���$����~=)%�P:Y庯H4�uB��X7(z��F�uI٧3��������=�]M�	�#�+ӈ3�41��C�Y=�?.���� 7G0|��'�xw��D#��t��o���X��m1��'�},��Ə3�Z����@�(���]kK!M�	U�NhYԵ�ͤ0�g}��D��~3|Qa)�9�Krf����p9�b
��� ?]��)�|bW�?�a�q�M�Մ}��3�;�f��QW�-lъR�VHU���H�<�}���ߔ��֪_����)-���@<����%6��#����
��K'~u�ۧn�u�S���tY��E���L��U��ùף�l%[e��ix²�tdvn�5 ^O�.ob��)aG-��I��<O~��N��+���c/�}Ί�K��!om�FvWS�������$]�*�Զl��jYgo��E_)�*G2��g���~��U�+�s8�f�|KB.$n�s�_www? U�S      �      x������ � �      �   �  x����i�1��s��t���
�b[R�%�����a���cf,�&Rp�#lG�1��!�p�N�XG`�VP� ��`���9J>6{`���	P�G���JUϕ���8 ��/�/�Oub_�:�����4��!T��F*�� �}X<3>C�Y��)�E28�Lb�d待�y˖0��i
�vCi�����g���S#	b��2,��w�x3��[�>�����Q�t8�Ho�$b.�:�e'�ٲ�m�U�w�r��:�2��������,��u�����G���^vg�Ӣ���b�*ƷPc�8YǦpdy]�[����aq���5����G������zO�e���;,ф�'!�\�q��g��qV��X�]�v}e��B�>�[��T��o�-S�Ͻ��@T�%U��3��;�������3?      �   �  x��V˒�6<s���"��o._r��*'����@D�X �����V�C.r�J"Eh0��ݐ���bi�DIG^rZ�P�V�m���.X�ZZv�d��?�ݧ��k�X��b�����LB�Vq�H�G�&G$�Dx����u�/D;O�r"�U$z._�'F�h�/�O�q `O���ĉ�	�:�]�+�p��X�nu�-��R�'c�QӁ�6�Tt�cI�J������u6,��b,6���S�ϩ�x z���V���t���5>w�ĭ�'�}&�-+��AI��=!LpA�恄�9d"/��7�a!.A���Q��kZ�BѦ���F�_�Z�� ��^Hf�ѱ9�e�GW�������?�^���r�B�䤋m}�!��LL�f8���ޜ��Ӥ�:��
M:��(�a�����b���ѡA4l�T)A5/<H�����d�f��]��X�&���d|B�zwӇt�#-���_�g���,�c�+�\�@�aEr��a'� ?�F�)��A�����r<�>��u:��
CMD���t�^	�4�Ǧ+Y1=�k�FfD��vw28o�qk�l��� �
ǽ�c�c����p+�����ʻôA�%��:QN�z@M`z�ZE[�84+�ԟ��a��rrڌ�C�Y���Q�L�ְw��� ���ۺ:��$Ω�P"E��Iے�Ġ����A
�۝ �}��RcRhL˺���tE{�X�W�,kY`\����+嘸š���xC��gI������v�3�o2�ԟ?dFF�3�Ή�P�7N��ʾk��(����B�CE�fTJ@�	�7{�|�+�L���:=�H#�w��.�r��i���jPR�<�.y����S��Q�L:PL�A�5�]P�1������u5�/�"w�m|��µ�`^�����|�y�.I��<�����(~�|�~Ⱥ"��-Q�Eug����4�i�������_Hmؽ      �      x������ � �      �      x������ � �      �      x������ � �     