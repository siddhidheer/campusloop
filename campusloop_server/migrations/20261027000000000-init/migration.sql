--
-- MIGRATION VERSION: 20261027000000000-init
--
BEGIN;

-- Create student_profile
CREATE TABLE "student_profile" (
    "id" bigserial PRIMARY KEY,
    "displayName" text NOT NULL,
    "email" text NOT NULL,
    "department" text,
    "year" bigint,
    "bio" text,
    "studySubjects" json NOT NULL,
    "interests" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

CREATE UNIQUE INDEX "student_profile_email_unique_idx" ON "student_profile" USING btree ("email");

-- Create campus_event
CREATE TABLE "campus_event" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "venue" text NOT NULL,
    "organizer" text NOT NULL,
    "organizerProfileId" bigint NOT NULL,
    "dateTime" timestamp without time zone NOT NULL,
    "endDateTime" timestamp without time zone,
    "imageUrl" text,
    "maxAttendees" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

CREATE INDEX "campus_event_category_idx" ON "campus_event" USING btree ("category");
CREATE INDEX "campus_event_datetime_idx" ON "campus_event" USING btree ("dateTime");

-- Create community
CREATE TABLE "community" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "interests" json NOT NULL,
    "creatorProfileId" bigint NOT NULL,
    "memberCount" bigint NOT NULL,
    "imageUrl" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

CREATE UNIQUE INDEX "community_name_unique_idx" ON "community" USING btree ("name");

-- Create community_membership
CREATE TABLE "community_membership" (
    "id" bigserial PRIMARY KEY,
    "communityId" bigint NOT NULL,
    "profileId" bigint NOT NULL,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

CREATE UNIQUE INDEX "cm_community_profile_unique_idx" ON "community_membership" USING btree ("communityId", "profileId");

-- Create community_post
CREATE TABLE "community_post" (
    "id" bigserial PRIMARY KEY,
    "communityId" bigint NOT NULL,
    "authorProfileId" bigint NOT NULL,
    "title" text NOT NULL,
    "content" text NOT NULL,
    "isPinned" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Create campus_update
CREATE TABLE "campus_update" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "content" text NOT NULL,
    "category" text NOT NULL,
    "authorProfileId" bigint NOT NULL,
    "priority" text NOT NULL,
    "isPublished" boolean NOT NULL,
    "publishedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Create study_partner_request
CREATE TABLE "study_partner_request" (
    "id" bigserial PRIMARY KEY,
    "fromProfileId" bigint NOT NULL,
    "toProfileId" bigint NOT NULL,
    "status" text NOT NULL,
    "matchingSubjects" json NOT NULL,
    "message" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

COMMIT;
