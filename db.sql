CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA objects;

CREATE TABLE objects.point_types (
    id smallint CONSTRAINT point_types_id_pkey PRIMARY KEY,
    title varchar(16) CONSTRAINT point_types_title NOT NULL
);

CREATE TABLE objects.faculties (
    id smallserial CONSTRAINT faculties_id_pkey PRIMARY KEY,
    title varchar(64) CONSTRAINT faculties_title NOT NULL
);

CREATE TABLE objects.groups (
    id smallserial CONSTRAINT groups_id_pkey PRIMARY KEY,
    faculty_id smallint REFERENCES objects.faculties(id) CONSTRAINT groups_faculties_fkey NOT NULL,
    number smallint CONSTRAINT groups_number NOT NULL
);

CREATE TABLE objects.hostels (
    id smallserial CONSTRAINT hostels_id_pkey PRIMARY KEY,
    title varchar(32) CONSTRAINT hostels_title NOT NULL
);

CREATE TABLE objects.rooms (
    id smallserial CONSTRAINT rooms_id_pkey PRIMARY KEY,
    hostel_id smallint REFERENCES objects.hostels(id) CONSTRAINT rooms_hostel_fkey NOT NULL,
    number smallint CONSTRAINT rooms_number NOT NULL
);

CREATE TABLE objects.positions (
    id smallserial CONSTRAINT positions_id_pkey PRIMARY KEY,
    title varchar(32) CONSTRAINT positions_title NOT NULL
);

CREATE TABLE objects.countries (
    id smallserial CONSTRAINT countries_id_pkey PRIMARY KEY,
    title varchar(32) CONSTRAINT countries_title NOT NULL
);

CREATE TABLE objects.roles (
    id smallserial CONSTRAINT roles_id_pkey PRIMARY KEY,
    title varchar(16) CONSTRAINT roles_title NOT NULL
);

CREATE TABLE objects.accesses (
    id smallserial CONSTRAINT accesses_id_pkey PRIMARY KEY,
    position_id smallint REFERENCES objects.positions(id) CONSTRAINT accesses_role_fkey NOT NULL,
    title varchar(32) CONSTRAINT accesses_title NOT NULL,
    available boolean CONSTRAINT accesses_available NOT NULL DEFAULT false
);

CREATE SCHEMA users;

DROP TABLE users.admins;

CREATE TABLE users.admins (
    id smallserial CONSTRAINT admins_id_pkey PRIMARY KEY,
    name varchar(32) CONSTRAINT admins_name NOT NULL,
    username varchar(32) CONSTRAINT admins_username NOT NULL UNIQUE,
    password varchar(128) CONSTRAINT admins_password NOT NULL,
    position_id smallint REFERENCES objects.positions(id) CONSTRAINT admins_position_fkey NOT NULL,
    role_id smallint REFERENCES objects.roles(id)  CONSTRAINT admins_role_fkey NOT NULL
);

CREATE TABLE objects.admins_to_hostels (
    id smallserial CONSTRAINT admins_to_hostels_id_pkey PRIMARY KEY,
    admin_id smallint REFERENCES users.admins(id)
        CONSTRAINT admins_to_hostels_admin_fkey NOT NULL,
    hostel_id smallint REFERENCES objects.hostels(id)
        CONSTRAINT admins_to_hostels_hostel_fkey NOT NULL
);

CREATE TABLE users.lodgers (
    id serial CONSTRAINT lodger_id_pkey PRIMARY KEY,
    password varchar(128) CONSTRAINT lodgers_password NOT NULL,
    first_name varchar(32) CONSTRAINT lodgers_first_name NOT NULL,
    last_name varchar(32) CONSTRAINT lodgers_last_name NOT NULL,
    fathers_name varchar(32),
    student_book_id integer CONSTRAINT lodgers_student_book_id NOT NULL,
    contract_id integer CONSTRAINT lodgers_contract_id NOT NULL,
    phone_number varchar(16),
    emeerg_phone_number varchar(16),
    citizenship_country_id smallint REFERENCES objects.countries(id)
        CONSTRAINT lodgers_citizenship_country_fkey NOT NULL,
    group_id smallint REFERENCES objects.groups(id) CONSTRAINT lodgers_group_fkey NOT NULL,
    room_id smallint REFERENCES objects.rooms(id) CONSTRAINT lodgers_room_fkey NOT NULL,
    birthday timestamp,
    contract_sign_date timestamp CONSTRAINT lodgers_contract_sign_date NOT NULL
);

CREATE TABLE objects.points (
    id uuid CONSTRAINT points_id_pkey PRIMARY KEY DEFAULT uuid_generate_v4(),
    lodger_id integer REFERENCES users.lodgers(id) CONSTRAINT points_lodger_fkey NOT NULL,
    count smallint CONSTRAINT points_count NOT NULL,
    type_id smallint REFERENCES objects.point_types(id) CONSTRAINT points_point_type_fkey NOT NULL,
    date timestamp,
    creation_date timestamp CONSTRAINT points_creation_date DEFAULT now(),
    admin_id smallint REFERENCES users.admins(id) CONSTRAINT points_admin_fkey NOT NULL,
    comment varchar(256)
);
