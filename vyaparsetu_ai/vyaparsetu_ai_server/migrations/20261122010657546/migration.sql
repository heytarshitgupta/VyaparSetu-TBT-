BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_notification" (
    "id" bigserial PRIMARY KEY,
    "profileId" bigint NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "type" text NOT NULL,
    "relatedId" bigint,
    "isRead" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "buyer_requirement" (
    "id" bigserial PRIMARY KEY,
    "buyerProfileId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "quantity" bigint NOT NULL,
    "budgetPaise" bigint,
    "city" text,
    "state" text,
    "status" text NOT NULL DEFAULT 'open'::text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "requirement_response" (
    "id" bigserial PRIMARY KEY,
    "requirementId" bigint NOT NULL,
    "producerProfileId" bigint NOT NULL,
    "message" text NOT NULL,
    "quotedPaise" bigint,
    "status" text NOT NULL DEFAULT 'responded'::text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "wishlist_item" (
    "id" bigserial PRIMARY KEY,
    "buyerProfileId" bigint NOT NULL,
    "productId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "wishlist_buyer_product_idx" ON "wishlist_item" USING btree ("buyerProfileId", "productId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "app_notification"
    ADD CONSTRAINT "app_notification_fk_0"
    FOREIGN KEY("profileId")
    REFERENCES "account_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "buyer_requirement"
    ADD CONSTRAINT "buyer_requirement_fk_0"
    FOREIGN KEY("buyerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "requirement_response"
    ADD CONSTRAINT "requirement_response_fk_0"
    FOREIGN KEY("requirementId")
    REFERENCES "buyer_requirement"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "requirement_response"
    ADD CONSTRAINT "requirement_response_fk_1"
    FOREIGN KEY("producerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "wishlist_item"
    ADD CONSTRAINT "wishlist_item_fk_0"
    FOREIGN KEY("buyerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "wishlist_item"
    ADD CONSTRAINT "wishlist_item_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR vyaparsetu_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vyaparsetu_ai', '20261122010657546', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261122010657546', "timestamp" = now();

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
