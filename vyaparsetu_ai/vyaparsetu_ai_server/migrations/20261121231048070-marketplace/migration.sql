BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product_photo" (
    "id" bigserial PRIMARY KEY,
    "productId" bigint NOT NULL,
    "bytes" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "product_photo_product_idx" ON "product_photo" USING btree ("productId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "trade_request" (
    "id" bigserial PRIMARY KEY,
    "productId" bigint NOT NULL,
    "buyerProfileId" bigint NOT NULL,
    "producerProfileId" bigint NOT NULL,
    "productName" text NOT NULL,
    "quantity" bigint NOT NULL,
    "requirements" text NOT NULL,
    "status" text NOT NULL DEFAULT 'requested'::text,
    "totalPaise" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "trade_request_buyer_idx" ON "trade_request" USING btree ("buyerProfileId");
CREATE INDEX "trade_request_producer_idx" ON "trade_request" USING btree ("producerProfileId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "product_photo"
    ADD CONSTRAINT "product_photo_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "trade_request"
    ADD CONSTRAINT "trade_request_fk_0"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "trade_request"
    ADD CONSTRAINT "trade_request_fk_1"
    FOREIGN KEY("buyerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "trade_request"
    ADD CONSTRAINT "trade_request_fk_2"
    FOREIGN KEY("producerProfileId")
    REFERENCES "account_profile"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR vyaparsetu_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('vyaparsetu_ai', '20261121231048070-marketplace', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121231048070-marketplace', "timestamp" = now();

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
