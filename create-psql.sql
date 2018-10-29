-- DROP DATABASE IF EXISTS kheops;
-- CREATE DATABASE kheops
--   ENCODING = "utf8"
--   LC_COLLATE = "en_US.UTF-8"
--   LC_CTYPE = "en_US.UTF-8";

DROP TABLE IF EXISTS "album";
DROP SEQUENCE IF EXISTS album_pk_seq;
CREATE SEQUENCE album_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "album" (
    "pk" bigint DEFAULT nextval('album_pk_seq') NOT NULL,
    "name" character(255) NOT NULL,
    "description" character(2048),
    "created_time" timestamp NOT NULL,
    "last_event_time" timestamp NOT NULL,
    "add_user_permission" boolean NOT NULL,
    "download_series_permission" boolean NOT NULL,
    "send_series_permission" boolean NOT NULL,
    "delete_series_permission" boolean NOT NULL,
    "add_series_permission" boolean NOT NULL,
    "write_comments_permission" boolean NOT NULL,
    CONSTRAINT "album_pk" PRIMARY KEY ("pk")
) WITH (oids = false);


DROP TABLE IF EXISTS "users";
DROP SEQUENCE IF EXISTS users_pk_seq;
CREATE SEQUENCE users_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "users" (
    "pk" bigint DEFAULT nextval('users_pk_seq') NOT NULL,
    "created_time" timestamp NOT NULL,
    "updated_time" timestamp NOT NULL,
    "google_id" character(255) NOT NULL,
    "google_email" character(255) NOT NULL,
    "inbox_fk" bigint NOT NULL,
    CONSTRAINT "google_email_unique" UNIQUE ("google_email"),
    CONSTRAINT "google_id_unique" UNIQUE ("google_id"),
    CONSTRAINT "users_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "users_inbox_fk_fkey" FOREIGN KEY (inbox_fk) REFERENCES album(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "google_email_index" ON "users" USING btree ("google_email");

CREATE INDEX "google_id_index" ON "users" USING btree ("google_id");


DROP TABLE IF EXISTS "studies";
DROP SEQUENCE IF EXISTS studies_pk_seq;
CREATE SEQUENCE studies_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "studies" (
    "pk" bigint DEFAULT nextval('studies_pk_seq') NOT NULL,
    "created_time" timestamp NOT NULL,
    "updated_time" timestamp NOT NULL,
    "study_uid" character(255) NOT NULL,
    "study_date" character(255),
    "study_time" character(255),
    "timezone_offset_from_utc" character(255),
    "accession_number" character(255),
    "referring_physician_name" character(4095),
    "patient_name" character(4095),
    "patient_id" character(255),
    "patient_birth_date" character(255),
    "patient_sex" character(255),
    "study_id" character(255),
    "populated" boolean,
    CONSTRAINT "studies_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "study_uid_unique" UNIQUE ("study_uid")
) WITH (oids = false);

CREATE INDEX "accession_number_index" ON "studies" USING btree ("accession_number");

CREATE INDEX "patient_id_index" ON "studies" USING btree ("patient_id");

CREATE INDEX "populated_index" ON "studies" USING btree ("populated");

CREATE INDEX "study_date_index" ON "studies" USING btree ("study_date");

CREATE INDEX "study_id_index" ON "studies" USING btree ("study_id");

CREATE INDEX "study_time_index" ON "studies" USING btree ("study_time");

CREATE INDEX "study_uid_index" ON "studies" USING btree ("study_uid");


DROP TABLE IF EXISTS "series";
DROP SEQUENCE IF EXISTS series_pk_seq;
CREATE SEQUENCE series_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "series" (
    "pk" bigint DEFAULT nextval('series_pk_seq') NOT NULL,
    "created_time" timestamp NOT NULL,
    "updated_time" timestamp NOT NULL,
    "modality" character(255),
    "timezone_offset_from_utc" character(255),
    "series_description" character(255),
    "series_uid" character(255) NOT NULL,
    "series_number" integer,
    "number_of_series_related_instances" integer,
    "study_fk" bigint NOT NULL,
    "populated" boolean,
    CONSTRAINT "series_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "series_uid_unique" UNIQUE ("series_uid"),
    CONSTRAINT "series_study_fk_fkey" FOREIGN KEY (study_fk) REFERENCES studies(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "series_populated_index" ON "series" USING btree ("populated");

CREATE INDEX "series_uid_index" ON "series" USING btree ("series_uid");

CREATE INDEX "study_fk_index" ON "series" USING btree ("study_fk");


DROP TABLE IF EXISTS "capabilities";
DROP SEQUENCE IF EXISTS capabilities_pk_seq;
CREATE SEQUENCE capabilities_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "capabilities" (
    "pk" bigint DEFAULT nextval('capabilities_pk_seq') NOT NULL,
    "created_time" timestamp NOT NULL,
    "updated_time" timestamp NOT NULL,
    "expiration_time" timestamp,
    "start_time" timestamp,
    "revoked_time" timestamp,
    "title" character(255),
    "secret" character(255),
    "read_permission" boolean NOT NULL,
    "write_permission" boolean NOT NULL,
    "user_fk" bigint NOT NULL,
    "scope_type" character(255),
    "album_fk" bigint,
    "series_fk" bigint,
    "study_fk" bigint,
    CONSTRAINT "capabilities_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "capabilities_secret_unique" UNIQUE ("secret"),
    CONSTRAINT "capabilities_album_fk_fkey" FOREIGN KEY (album_fk) REFERENCES album(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "capabilities_series_fk_fkey" FOREIGN KEY (series_fk) REFERENCES series(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "capabilities_study_fk_fkey" FOREIGN KEY (study_fk) REFERENCES studies(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "capabilities_user_fk_fkey" FOREIGN KEY (user_fk) REFERENCES users(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "capabilities_secret_index" ON "capabilities" USING btree ("secret");

CREATE INDEX "capabilities_user_fk_index" ON "capabilities" USING btree ("user_fk");


DROP TABLE IF EXISTS "album_series";
CREATE TABLE "album_series" (
    "album_fk" bigint NOT NULL,
    "series_fk" bigint NOT NULL,
    CONSTRAINT "album_series_unique" UNIQUE ("album_fk", "series_fk"),
    CONSTRAINT "album_series_album_fk_fkey" FOREIGN KEY (album_fk) REFERENCES album(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "album_series_series_fk_fkey" FOREIGN KEY (series_fk) REFERENCES series(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);



DROP TABLE IF EXISTS "album_user";
DROP SEQUENCE IF EXISTS album_user_pk_seq;
CREATE SEQUENCE album_user_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "album_user" (
    "pk" bigint DEFAULT nextval('album_user_pk_seq') NOT NULL,
    "album_fk" bigint NOT NULL,
    "user_fk" bigint NOT NULL,
    "admin" boolean NOT NULL,
    "new_series_notifications" boolean NOT NULL,
    "new_comment_notifications" boolean NOT NULL,
    "favorite" boolean NOT NULL,
    CONSTRAINT "album_user_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "album_user_unique" UNIQUE ("album_fk", "user_fk"),
    CONSTRAINT "album_user_album_fk_fkey" FOREIGN KEY (album_fk) REFERENCES album(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "album_user_user_fk_fkey" FOREIGN KEY (user_fk) REFERENCES users(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);



DROP TABLE IF EXISTS "event";
DROP SEQUENCE IF EXISTS event_pk_seq;
CREATE SEQUENCE event_pk_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "event" (
    "pk" bigint DEFAULT nextval('event_pk_seq') NOT NULL,
    "event_type" character(255),
    "album_fk" bigint,
    "study_fk" bigint,
    "event_time" timestamp NOT NULL,
    "user_fk" bigint NOT NULL,
    "private_target_user_fk" bigint,
    "comment" character(1024),
    "mutation_type" character(255),
    "to_user_fk" bigint,
    "series_fk" bigint,
    CONSTRAINT "event_pk" PRIMARY KEY ("pk"),
    CONSTRAINT "event_album_fk_fkey" FOREIGN KEY (album_fk) REFERENCES album(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "event_private_target_user_fk_fkey" FOREIGN KEY (private_target_user_fk) REFERENCES users(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "event_series_fk_fkey" FOREIGN KEY (series_fk) REFERENCES series(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "event_study_fk_fkey" FOREIGN KEY (study_fk) REFERENCES studies(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "event_to_user_fk_fkey" FOREIGN KEY (to_user_fk) REFERENCES users(pk) ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "event_user_fk_fkey" FOREIGN KEY (user_fk) REFERENCES users(pk) ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);
