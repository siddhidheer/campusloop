# CampusLoop

> **Your Campus. Your Community. One Loop.**  
> **Team**: HACKTIVATORS  
> **Track**: Campus Life, Upgraded (Flutter + Serverpod)  
> **Latest Release**: [CampusLoop Android App v1.0.6](https://github.com/siddhidheer/campusloop/releases/tag/v1.0.6-apk) (`CampusLoop.apk`)

---

## 📱 Overview

**CampusLoop** is a unified campus life mobile application built to bridge fragmented student communications. It connects campus events, intelligent study-partner matching, interest-based student communities, verified announcements, and an interactive notifications center into one cohesive, beautifully designed mobile experience.

### 🌐 Live Production Backend
- **API Server**: [`https://campusloop1.api.serverpod.space/`](https://campusloop1.api.serverpod.space/)
- **Insights Console**: [`https://campusloop1.insights.serverpod.space/`](https://campusloop1.insights.serverpod.space/)
- **Hosting**: Serverpod Cloud (Managed PostgreSQL + RPC server, Podlets: 1/1 Running)
- **Status**: Live & Verified

---

## 🛠️ Approved Technology Stack

CampusLoop is strictly built using **only** the approved technology stack:

- **Frontend**: Flutter & Dart (Material 3 custom design system, dark mode, rich animations)
- **Backend Framework**: Serverpod 4.0 (Type-safe RPC dispatch, ORM, cascading mutations)
- **Client Protocol**: Serverpod Generated Client (`campusloop_client`)
- **Database**: PostgreSQL on Serverpod Cloud (Relational tables, foreign keys, b-tree indexes, migrations)
- **Cloud Hosting**: Serverpod Cloud (`serverpod cloud deploy`)
- **Local Developer Environment**: Local Flutter SDK 3.47.4, Dart SDK 3.13.3, Serverpod CLI 4.0.4
- **CI/CD & Releases**: GitHub Actions automated release pipeline publishing production Android APKs to GitHub Releases

> [!NOTE]
> Strictly zero unapproved technologies are used. No Firebase, Supabase, MongoDB, Node.js, Express, or unapproved third-party frameworks. See [TECH_STACK_AUDIT.md](TECH_STACK_AUDIT.md) for full compliance verification.

---

## 📁 Project Structure

```
campusloop/
├── .github/workflows/
│   └── build_apk.yml                 # GitHub Actions automated release APK pipeline
├── .idx/
│   └── dev.nix                       # Google Project IDX cloud configuration
├── CampusLoop.apk                     # Official Android Release APK (v1.0.4, 59 MB)
├── campusloop_client/                # Serverpod client package
│   ├── lib/
│   │   ├── campusloop_client.dart    # Export barrel
│   │   └── src/protocol/             # Generated RPC protocol & model classes
│   └── pubspec.yaml
├── campusloop_server/                # Serverpod backend server
│   ├── bin/
│   │   └── main.dart                 # Server entry point with JWT auth config
│   ├── config/                       # Serverpod environment configurations
│   ├── lib/
│   │   ├── server.dart
│   │   └── src/
│   │       ├── endpoints/            # 7 business logic endpoints (events, profile, study partner, etc.)
│   │       ├── generated/            # Server-side generated models & ORM tables
│   │       └── models/               # Serverpod YAML model definitions (.spy.yaml)
│   ├── migrations/                   # Serverpod database migration files
│   └── pubspec.yaml
├── campusloop_flutter/               # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart                 # App entry point & Serverpod client init
│   │   ├── theme/
│   │   │   └── campus_theme.dart     # Deep teal, coral, soft blue, warm amber design system
│   │   ├── models/
│   │   │   └── campus_notification.dart # Unified notifications data model
│   │   ├── widgets/
│   │   │   ├── common/               # CampusLoader, EmptyState, chips, cards, infinity logo
│   │   │   └── home/                 # NotificationsSheet modal with filter chips & inline actions
│   │   └── screens/
│   │       ├── app_shell.dart        # 5-tab persistent bottom navigation with keyed IndexedStack
│   │       ├── auth/                 # Dual-mode authentication (New User vs Existing User)
│   │       ├── home/                 # Personalized dashboard & top-right notifications center
│   │       ├── discover/             # Campus events & intelligent study partner matching
│   │       ├── communities/          # Interest communities & discussion feeds
│   │       ├── updates/              # Official campus announcements & notices
│   │       └── profile/              # Academic details, interests, connections & Danger Zone
│   ├── test/                         # Navigation and smoke widget tests
│   └── pubspec.yaml
├── DEPLOYMENT_GUIDE.md               # Local execution and Serverpod Cloud instructions
├── TECH_STACK_AUDIT.md               # 100% stack compliance audit
└── VERIFICATION_REPORT.md            # Features, test scenarios, and security report
```

---

## 🌟 Core Features

### 1. Notifications Center (Top-Right Bell with Dynamic Badge)
- **Live Counter**: Unread badge indicator updated persistently via `SharedPreferences`.
- **Connection Requests**: Incoming study partner requests with sender's name, department, shared subjects, timestamp, and **Accept** / **Decline** action buttons directly inside the notification card.
- **Campus Updates**: Verified announcements categorized by Academic, Facility, Opportunity, and Notice.
- **Club Activities**: Live activity alerts from campus communities and clubs with active member counts.
- **Campus Events**: Upcoming workshops, hackathons, and cultural fests with venues, dates, and times.
- **Interactive Sheet**: Category filter chips (**All**, **Requests**, **Updates**, **Clubs**, **Events**), "Mark all as read" button, and 1-tap navigation to the corresponding tab.

### 2. Intelligent Study-Partner Matching & Discovery
- **Deterministic Subtab Switching**: Keyed `IndexedStack` guarantees 100% reliable, instant switching between **Events** (tab 0) and **Study Partners** (tab 1) from any dashboard shortcut.
- **Peer Matching**: Subject-based algorithm ranking peers by shared coursework, interest tags, and academic department.
- **Full Request Lifecycle**: Send Request → Pending ⏳ → Accept ✓ / Decline ✗ with bidirectional synchronization.
- **Active Connections Directory**: Displays connected peers with matching subjects.

### 3. Comprehensive Onboarding & Authentication
- **Dual-Mode Authentication**:
  - **New User**: Complete profile setup with student display name, university/institution, 25+ academic departments, custom subjects and interest tags, password creation, and duplicate email protection.
  - **Existing User**: Streamlined sign-in with email & password, credential persistence ("Remember Me"), and automatic pre-fill.

### 4. Danger Zone: Permanent Account & Credential Deletion
- **Deep Cascading Database Deletion**: Deletes the student profile, sent/received study partner requests, community memberships, authored community posts, organized events, and authored updates via Serverpod backend (`deleteAccount`).
- **Complete Credential Wipe**: Purges saved passwords, remembered emails, local registration lists, and cached request states. Allows subsequent fresh re-registration with zero conflicts.

### 5. Campus Communities & Discussion Feeds
- Browse and search student-run clubs and interest groups.
- Join and leave communities with automatic real-time member count adjustments.
- Community post feed with pinned announcements and creator management controls.

### 6. Official Campus Updates & Announcements
- Verified announcements categorized by Academic, Facility, Opportunity, and Notice.
- Priority indicators (High, Normal) for urgent alerts with rich modal reading views.

---

## 🚀 Running Locally

With local developer tools (Flutter, Dart, Serverpod CLI) installed on your machine:

### 1. Prerequisites Check
```powershell
flutter --version   # Flutter 3.47.4 or newer
dart --version      # Dart 3.13.3 or newer
serverpod --version # Serverpod 4.0.4
```

### 2. Run the Flutter Mobile / Web App
```powershell
cd campusloop_flutter
flutter pub get
flutter run -d chrome     # Run as web app
# OR
flutter run               # Run on connected Android device / emulator
```

### 3. Run Automated Tests
```powershell
cd campusloop_flutter
flutter test
```

### 4. Build Android Release APK Locally
```powershell
cd campusloop_flutter
flutter build apk --release
# Generated APK: build/app/outputs/flutter-apk/app-release.apk
```

### 5. Deploy Backend Changes to Serverpod Cloud
```powershell
cd campusloop_server
serverpod generate
serverpod cloud deploy
```

---

## 📦 Direct App Download

The official production release APK can be downloaded directly to any Android device:
- 📱 **Download APK**: [CampusLoop.apk (v1.0.4)](https://github.com/siddhidheer/campusloop/releases/download/v1.0.4-apk/CampusLoop.apk) *(59.00 MB)*
- 📦 **GitHub Releases**: [https://github.com/siddhidheer/campusloop/releases](https://github.com/siddhidheer/campusloop/releases)
