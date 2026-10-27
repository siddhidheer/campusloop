-- =============================================================================
-- CampusLoop PostgreSQL Schema
-- Team: HACKTIVATORS | Track: Campus Life, Upgraded
-- Technology: Serverpod 4 + PostgreSQL
-- =============================================================================

-- Enable UUID extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- Table: student_profile
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "student_profile" (
    "id" BIGSERIAL PRIMARY KEY,
    "displayName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "department" TEXT,
    "year" BIGINT,
    "bio" TEXT,
    "studySubjects" JSONB NOT NULL DEFAULT '[]',
    "interests" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS "student_profile_email_unique_idx"
    ON "student_profile" ("email");

-- -----------------------------------------------------------------------------
-- Table: campus_event
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "campus_event" (
    "id" BIGSERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "venue" TEXT NOT NULL,
    "organizer" TEXT NOT NULL,
    "organizerProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "dateTime" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    "endDateTime" TIMESTAMP WITHOUT TIME ZONE,
    "imageUrl" TEXT,
    "maxAttendees" BIGINT,
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "campus_event_category_idx"
    ON "campus_event" ("category");

CREATE INDEX IF NOT EXISTS "campus_event_datetime_idx"
    ON "campus_event" ("dateTime");

-- -----------------------------------------------------------------------------
-- Table: community
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "community" (
    "id" BIGSERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "interests" JSONB NOT NULL DEFAULT '[]',
    "creatorProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "memberCount" BIGINT NOT NULL DEFAULT 1,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS "community_name_unique_idx"
    ON "community" ("name");

CREATE INDEX IF NOT EXISTS "community_category_idx"
    ON "community" ("category");

-- -----------------------------------------------------------------------------
-- Table: community_membership
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "community_membership" (
    "id" BIGSERIAL PRIMARY KEY,
    "communityId" BIGINT NOT NULL REFERENCES "community" ("id") ON DELETE CASCADE,
    "profileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "role" TEXT NOT NULL DEFAULT 'member',
    "joinedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS "cm_community_profile_unique_idx"
    ON "community_membership" ("communityId", "profileId");

CREATE INDEX IF NOT EXISTS "cm_profile_idx"
    ON "community_membership" ("profileId");

-- -----------------------------------------------------------------------------
-- Table: community_post
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "community_post" (
    "id" BIGSERIAL PRIMARY KEY,
    "communityId" BIGINT NOT NULL REFERENCES "community" ("id") ON DELETE CASCADE,
    "authorProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "isPinned" BOOLEAN NOT NULL DEFAULT FALSE,
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "cp_community_idx"
    ON "community_post" ("communityId");

CREATE INDEX IF NOT EXISTS "cp_created_idx"
    ON "community_post" ("createdAt");

-- -----------------------------------------------------------------------------
-- Table: campus_update
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "campus_update" (
    "id" BIGSERIAL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "authorProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "priority" TEXT NOT NULL DEFAULT 'normal',
    "isPublished" BOOLEAN NOT NULL DEFAULT TRUE,
    "publishedAt" TIMESTAMP WITHOUT TIME ZONE,
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "cu_category_idx"
    ON "campus_update" ("category");

CREATE INDEX IF NOT EXISTS "cu_published_idx"
    ON "campus_update" ("isPublished");

CREATE INDEX IF NOT EXISTS "cu_published_at_idx"
    ON "campus_update" ("publishedAt");

-- -----------------------------------------------------------------------------
-- Table: study_partner_request
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "study_partner_request" (
    "id" BIGSERIAL PRIMARY KEY,
    "fromProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "toProfileId" BIGINT NOT NULL REFERENCES "student_profile" ("id") ON DELETE CASCADE,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "matchingSubjects" JSONB NOT NULL DEFAULT '[]',
    "message" TEXT,
    "createdAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS "spr_from_to_unique_idx"
    ON "study_partner_request" ("fromProfileId", "toProfileId");

CREATE INDEX IF NOT EXISTS "spr_to_profile_idx"
    ON "study_partner_request" ("toProfileId");

CREATE INDEX IF NOT EXISTS "spr_status_idx"
    ON "study_partner_request" ("status");
