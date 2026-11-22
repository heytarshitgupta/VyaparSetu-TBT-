BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "account_profile" ADD COLUMN "businessName" text;
ALTER TABLE "account_profile" ADD COLUMN "craftCategory" text;
ALTER TABLE "account_profile" ADD COLUMN "city" text;
ALTER TABLE "account_profile" ADD COLUMN "state" text;
ALTER TABLE "account_profile" ADD COLUMN "address" text;
ALTER TABLE "account_profile" ADD COLUMN "verified" boolean NOT NULL DEFAULT true;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "pricePaise" bigint;
ALTER TABLE "product" ADD COLUMN "category" text;
ALTER TABLE "product" ADD COLUMN "unit" text NOT NULL DEFAULT 'piece'::text;
ALTER TABLE "product" ADD COLUMN "minimumOrderQuantity" bigint NOT NULL DEFAULT 1;
ALTER TABLE "product" ADD COLUMN "city" text;
ALTER TABLE "product" ADD COLUMN "state" text;
ALTER TABLE "product" ADD COLUMN "craft" text;

--
-- MIGRATION VERSION FOR vyaparsetu_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vyaparsetu_ai', '20261122002754056', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261122002754056', "timestamp" = now();

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
