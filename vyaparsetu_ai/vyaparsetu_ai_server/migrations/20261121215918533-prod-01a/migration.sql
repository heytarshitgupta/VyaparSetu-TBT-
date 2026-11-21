BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product" (
    "id" bigserial PRIMARY KEY,
    "producerProfileId" bigint NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "status" text NOT NULL DEFAULT 'draft'::text
);

-- Indexes
CREATE INDEX "product_producer_profile_idx" ON "product" USING btree ("producerProfileId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product"
    ADD CONSTRAINT "product_fk_0"
    FOREIGN KEY("producerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR vyaparsetu_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vyaparsetu_ai', '20261121215918533-prod-01a', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121215918533-prod-01a', "timestamp" = now();

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
