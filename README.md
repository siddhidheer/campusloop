# CampusLoop

> **Your Campus. Your Community. One Loop.**  
> **Team**: HACKTIVATORS  
> **Track**: Campus Life, Upgraded (Flutter + Serverpod)  

---

## Overview

**CampusLoop** is a unified campus life mobile application built to bridge fragmented student communications. It connects campus events, intelligent study-partner matching, interest-based student communities, and verified campus announcements into one cohesive, beautifully designed mobile experience.

---

## Approved Technology Stack

CampusLoop is strictly built using **only** the approved technology stack:

- **Frontend**: Flutter & Dart (Material 3 custom design system)
- **Backend Framework**: Serverpod 4.0 (Endpoints, RPC dispatch, model definitions)
- **Client**: Serverpod Generated Client (`campusloop_client`)
- **Database**: PostgreSQL (Relational schema, foreign keys, indexes, migrations)
- **Cloud Hosting**: Serverpod Cloud (`serverpod cloud deploy`)
- **Development Environment**: Google Project IDX (Zero local installation required)

> [!NOTE]
> Strictly zero unapproved technologies are used. No Firebase, Supabase, MongoDB, Node.js, Express, or unapproved third-party packages. See [TECH_STACK_AUDIT.md](TECH_STACK_AUDIT.md) for full compliance verification.

---

## Project Structure

```
campusloop/
├── .idx/
│   └── dev.nix                       # Google Project IDX zero-install configuration
├── campusloop_client/                # Serverpod client package
│   ├── lib/
│   │   ├── campusloop_client.dart    # Export barrel
│   │   └── src/protocol/             # Generated RPC protocol & model classes
│   └── pubspec.yaml
├── campusloop_server/                # Serverpod backend server
│   ├── bin/
│   │   └── main.dart                 # Server entry point with JWT auth config
│   ├── config/                       # Serverpod environment configurations
│   │   ├── development.yaml
│   │   ├── production.yaml
│   │   └── passwords.yaml
│   ├── deploy/
│   │   └── schema.sql                # Complete PostgreSQL DDL schema
│   ├── lib/
│   │   ├── server.dart
│   │   └── src/
│   │       ├── endpoints/            # Business logic endpoints (7 endpoints)
│   │       ├── generated/            # Server-side generated models & ORM tables
│   │       └── models/               # Serverpod YAML model definitions (.spy.yaml)
│   ├── migrations/                   # Serverpod database migration files
│   └── pubspec.yaml
├── campusloop_flutter/               # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart                 # App entry point & Serverpod client init
│   │   ├── theme/
│   │   │   └── campus_theme.dart     # Deep teal, coral, cream design system
│   │   ├── widgets/
│   │   │   └── common/               # CampusLoader, EmptyState, chips, cards
│   │   └── screens/
│   │       ├── app_shell.dart        # 5-tab persistent bottom navigation
│   │       ├── auth/                 # Student profile switcher & registration
│   │       ├── home/                 # Personalized dashboard
│   │       ├── discover/             # Campus events & study partner matching
│   │       ├── communities/          # Interest communities & discussion feeds
│   │       ├── updates/              # Official campus announcements & notices
│   │       └── profile/              # Academic details, interests, connections
│   └── pubspec.yaml
├── DEPLOYMENT_GUIDE.md               # Zero-install and Serverpod Cloud instructions
├── TECH_STACK_AUDIT.md               # 100% stack compliance audit
└── VERIFICATION_REPORT.md            # Features, test scenarios, and security report
```

---

## Core Features

1. **Personalized Home Dashboard**:
   - Welcome banner with student profile summary.
   - Quick action shortcuts (Find Partners, Explore Communities, View Events).
   - Horizontal carousels for upcoming events and top communities.
   - Latest campus updates with priority badges.

2. **Discover & Campus Events**:
   - Filter events by category (Technology, Workshop, Cultural, Career, Sports).
   - Case-insensitive search across titles and descriptions.
   - Create new events with interactive date picker and venue inputs.
   - Detailed event bottom sheet with organizer details and capacity limits.

3. **Intelligent Study-Partner Matching**:
   - Subject-based matching algorithm matching students taking the same courses.
   - Match relevance indicators displaying common study subjects.
   - Full request lifecycle: Send Request → Pending → Accept / Reject.
   - Active connections directory with quick profile interaction.

4. **Interest Communities & Feeds**:
   - Browse and search student-run clubs and interest groups.
   - Join and leave communities with automatic member count tracking.
   - Community post feed with pinned announcements.
   - Creator-only community deletion and post management permissions.

5. **Campus Updates & Announcements**:
   - Verified announcements categorized by Academic, Facility, Opportunity, and Notice.
   - Priority indicators (High, Normal) for urgent alerts.
   - Modal reading view with publication timestamp and author information.

6. **Student Profile & Settings**:
   - View academic year, department, and bio.
   - Manage enrolled study subjects and personal interest tags.
   - View joined communities and active study partner connections.
   - Easy profile switcher for testing multi-student interactions.

---

## Quickstart (Zero Local Installation)

Run the entire application in the cloud with zero software installed on your local PC:

1. Import this repository into [Google Project IDX](https://idx.dev).
2. Project IDX boots the container, configures PostgreSQL, installs dependencies, and compiles the code automatically.
3. Start the backend:
   ```bash
   cd campusloop_server
   dart bin/main.dart
   ```
4. Start the Flutter application:
   ```bash
   cd campusloop_flutter
   flutter run -d web-server --web-port 3000
   ```
5. View the interactive Flutter preview directly inside your browser!

For complete step-by-step instructions and production deployment to Serverpod Cloud, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md).
