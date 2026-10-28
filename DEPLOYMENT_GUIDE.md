# CampusLoop — Deployment & Execution Guide

**Team**: HACKTIVATORS  
**Track**: Campus Life, Upgraded (Flutter + Serverpod)  
**Environments**: Local Developer Workstation, Serverpod Cloud (Production), GitHub Actions CI/CD, and Google Project IDX

---

## 1. Local Development & Execution Setup

Now that the required developer tooling is installed locally on your Windows workstation, you can develop, test, and package CampusLoop directly.

### Prerequisites & Verification
Verify your local toolchain in PowerShell:
```powershell
flutter --version   # Flutter 3.47.4 (Dart 3.13.3)
dart --version      # Dart SDK version: 3.13.3
serverpod --version # Serverpod version: 4.0.4
```

> [!TIP]
> Ensure both `C:\tools\flutter\bin` and `C:\Users\<user>\AppData\Local\Pub\Cache\bin` are present in your system `PATH` so `flutter`, `dart`, and `serverpod` can be run from any terminal.

### Running the Flutter Client Locally
```powershell
cd campusloop_flutter

# 1. Fetch dependencies
flutter pub get

# 2. Run unit & widget tests
flutter test

# 3. Launch the app in Chrome (Web)
flutter run -d chrome

# 4. Launch on connected Android device or emulator
flutter run
```

### Building the Production Android APK Locally
```powershell
cd campusloop_flutter
flutter build apk --release
```
The output APK is generated at:
`campusloop_flutter/build/app/outputs/flutter-apk/app-release.apk`

---

## 2. Serverpod Cloud Production Backend

The CampusLoop backend is deployed to **Serverpod Cloud** with a managed PostgreSQL database, automated TLS certificates, and real-time health monitoring.

### Live Production Endpoints
- **API Server**: [`https://campusloop1.api.serverpod.space/`](https://campusloop1.api.serverpod.space/)
- **Insights Console**: [`https://campusloop1.insights.serverpod.space/`](https://campusloop1.insights.serverpod.space/)
- **Web Interface**: [`https://campusloop1.serverpod.space/`](https://campusloop1.serverpod.space/)
- **Project ID**: `campusloop1`
- **Podlets**: `1/1 Ready (● Running)`

### Deploying Backend Updates to Serverpod Cloud
Whenever you modify models (`.spy.yaml`) or endpoint code in `campusloop_server/lib/src/endpoints/`:

```powershell
cd campusloop_server

# 1. Re-generate Serverpod models and client protocol
serverpod generate

# 2. Deploy to Serverpod Cloud
serverpod cloud deploy
```

The CLI automatically:
1. Validates generated code across `campusloop_server` and `campusloop_client`.
2. Packages the server bundle into an archive.
3. Uploads the project to Serverpod Cloud.
4. Executes cloud build and container rollout with zero downtime.

### Checking Deployment Status
```powershell
serverpod cloud status live
```

---

## 3. Automated CI/CD & GitHub Releases

CampusLoop utilizes GitHub Actions to automatically compile, verify, and publish release APKs on every commit pushed to `main`.

### Workflow Configuration (`.github/workflows/build_apk.yml`)
- **Triggers**: Pushes to `main` impacting `campusloop_flutter/**`, `campusloop_client/**`, or workflow files.
- **Environment**: `ubuntu-latest` with Java 17 Temurin and Flutter `3.47.4`.
- **Steps**:
  1. Clones repository.
  2. Resolves dependencies across `campusloop_client` and `campusloop_flutter`.
  3. Builds optimized release APK (`flutter build apk --release`).
  4. Uploads build artifacts.
  5. Creates a GitHub Release with the tag (e.g. `v1.0.4-apk`) and attaches `CampusLoop.apk`.

### Releases Directory
All published production builds are available under GitHub Releases:  
[https://github.com/siddhidheer/campusloop/releases](https://github.com/siddhidheer/campusloop/releases)

---

## 4. Google Project IDX Cloud Fallback (Optional)

CampusLoop maintains full compatibility with Google Project IDX for zero-install cloud development:

1. Import repository into [https://idx.dev](https://idx.dev).
2. Project IDX reads `.idx/dev.nix`, automatically installing Flutter, Dart, and PostgreSQL 15.
3. Run the backend:
   ```bash
   cd campusloop_server && dart bin/main.dart
   ```
4. Run the web preview:
   ```bash
   cd campusloop_flutter && flutter run -d web-server --web-port 3000
   ```

---

## 5. PostgreSQL Database Schema & Relational Models

CampusLoop uses 7 core models managed via Serverpod ORM and PostgreSQL migrations:

| Table | Description | Key Fields & Indexes |
|:---|:---|:---|
| `student_profile` | Core student identities | `displayName`, `email` (unique index), `department`, `year`, `studySubjects` (JSONB), `interests` (JSONB) |
| `campus_event` | Campus events & hackathons | `title`, `description`, `category` (indexed), `venue`, `organizerProfileId`, `dateTime` (indexed), `imageUrl` |
| `community` | Student clubs & interest groups | `name` (unique index), `category` (indexed), `interests` (JSONB), `creatorProfileId`, `memberCount` |
| `community_membership` | Join table for clubs | `communityId`, `profileId` (composite unique index), `role` (`admin`/`member`), `joinedAt` |
| `community_post` | Discussion posts within clubs | `communityId` (indexed), `authorProfileId`, `title`, `content`, `isPinned`, `createdAt` (indexed) |
| `campus_update` | Official campus announcements | `title`, `content`, `category` (indexed), `authorProfileId`, `priority`, `isPublished` (indexed), `publishedAt` |
| `study_partner_request` | Peer connection requests | `fromProfileId`, `toProfileId` (composite unique index), `status` (`pending`/`accepted`/`rejected`), `matchingSubjects` |
