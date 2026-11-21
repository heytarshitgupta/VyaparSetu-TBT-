BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "account_profile" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "displayName" text NOT NULL,
    "role" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "account_profile_auth_user_idx" ON "account_profile" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "account_profile"
    ADD CONSTRAINT "account_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR vyaparsetu_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vyaparsetu_ai', '20261121211058192-auth-01', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121211058192-auth-01', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
