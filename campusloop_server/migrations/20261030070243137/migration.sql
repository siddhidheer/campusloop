BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "community_creation_permission" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "profileId" bigint NOT NULL,
    "grantedByEmail" text NOT NULL,
    "grantedByProfileId" bigint NOT NULL,
    "grantedAt" timestamp without time zone NOT NULL,
    "revokedAt" timestamp without time zone,
    "isActive" boolean NOT NULL
);

-- Indexes
CREATE INDEX "ccp_email_idx" ON "community_creation_permission" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "email_verification_otp" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "otpHash" text NOT NULL,
    "salt" text NOT NULL,
    "attempts" bigint NOT NULL,
    "isUsed" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "lastSentAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "email_verification_otp_email_idx" ON "email_verification_otp" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "moderation_log" (
    "id" bigserial PRIMARY KEY,
    "communityId" bigint NOT NULL,
    "authorProfileId" bigint NOT NULL,
    "authorEmail" text NOT NULL,
    "postTitle" text NOT NULL,
    "contentSnippet" text NOT NULL,
    "matchedRule" text NOT NULL,
    "reason" text NOT NULL,
    "isBlocked" boolean NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "modlog_timestamp_idx" ON "moderation_log" USING btree ("timestamp");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "permission_audit_log" (
    "id" bigserial PRIMARY KEY,
    "action" text NOT NULL,
    "adminEmail" text NOT NULL,
    "adminProfileId" bigint NOT NULL,
    "targetEmail" text NOT NULL,
    "targetProfileId" bigint NOT NULL,
    "reason" text,
    "timestamp" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "pal_timestamp_idx" ON "permission_audit_log" USING btree ("timestamp");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "spam_keyword_rule" (
    "id" bigserial PRIMARY KEY,
    "pattern" text NOT NULL,
    "category" text NOT NULL,
    "severity" text NOT NULL,
    "isEnabled" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "skr_pattern_idx" ON "spam_keyword_rule" USING btree ("pattern");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "student_profile" ADD COLUMN "role" text;
ALTER TABLE "student_profile" ADD COLUMN "canCreateCommunity" boolean;
ALTER TABLE "student_profile" ADD COLUMN "isEmailVerified" boolean;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_account" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "salt" text NOT NULL,
    "isEmailVerified" boolean NOT NULL,
    "emailVerifiedAt" timestamp without time zone,
    "role" text NOT NULL,
    "canCreateCommunity" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_account_email_idx" ON "user_account" USING btree ("email");


--
-- MIGRATION VERSION FOR campusloop
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('campusloop', '20261030070243137', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261030070243137', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
