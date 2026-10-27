# CampusLoop — Deployment & Execution Guide

**Team**: HACKTIVATORS  
**Track**: Campus Life, Upgraded (Flutter + Serverpod)  
**Target Environments**: Google Project IDX (Zero Local Install) & Serverpod Cloud (Production)

---

## 1. Zero-Install Quickstart with Google Project IDX

Because no local developer tools (Flutter, Dart, PostgreSQL, Docker) are installed on your Windows PC, CampusLoop is pre-configured with `.idx/dev.nix` to run inside **Google Project IDX** (https://idx.dev).

### Step 1: Open the Project in Project IDX
1. Push your CampusLoop workspace to a GitHub repository (or import the workspace folder).
2. Visit [https://idx.dev](https://idx.dev) and sign in with your Google account.
3. Click **"Import a repository"** and select your CampusLoop repository.
4. Project IDX will automatically detect `.idx/dev.nix` and provision:
   - Flutter SDK
   - Dart SDK
   - PostgreSQL 15 server
   - Dart extensions and VS Code environment

### Step 2: Automatic Background Initialization
Upon workspace creation, `.idx/dev.nix` automatically executes:
- Activates `serverpod_cli`: `dart pub global activate serverpod_cli`
- Initializes PostgreSQL cluster at `$HOME/.postgres`
- Sets up database `campusloop` and user `postgres` with password `campusloop_dev_password`
- Runs `pub get` across all 3 packages:
  ```bash
  cd campusloop_server && dart pub get
  cd ../campusloop_client && dart pub get
  cd ../campusloop_flutter && flutter pub get
  ```

### Step 3: Run Database Migrations
In the Project IDX terminal:
```bash
cd campusloop_server
# Option A: Apply migrations using Serverpod CLI
serverpod create-migration
dart bin/main.dart --apply-migrations

# Option B: Direct PostgreSQL DDL application
psql -h localhost -p 5432 -U postgres -d campusloop -f deploy/schema.sql
```

### Step 4: Start the Serverpod Backend
In Terminal 1:
```bash
cd campusloop_server
dart bin/main.dart
```
The Serverpod backend will start on `http://localhost:8080/`.

### Step 5: Seed Sample Data
You can seed demo data either through the app login screen or directly via curl/CLI:
```bash
curl -X POST http://localhost:8080/seed/seedDevelopmentData
```

### Step 6: Launch the Flutter Application
In Terminal 2:
```bash
cd campusloop_flutter
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
```
Project IDX will open an interactive browser preview window showing CampusLoop!

---

## 2. Deploying to Serverpod Cloud (Production)

Serverpod Cloud provides managed hosting for Serverpod backends with integrated PostgreSQL.

### Prerequisites
1. Serverpod Cloud account: [https://serverpod.cloud](https://serverpod.cloud)
2. Serverpod CLI (available in Project IDX or cloud shell).

### Step 1: Authenticate with Serverpod Cloud
In your cloud terminal:
```bash
serverpod cloud login
```
Follow the browser authentication link to connect your Serverpod Cloud account.

### Step 2: Create a Serverpod Cloud Project
```bash
cd campusloop_server
serverpod cloud project create campusloop
```
Note the assigned production URL (e.g., `https://campusloop.serverpod.cloud/`).

### Step 3: Configure Production Passwords & Secrets
Serverpod Cloud uses `config/passwords.yaml` or cloud secrets management:
```bash
# Set production database credentials and JWT secret keys
serverpod cloud secret set jwtRefreshTokenHashPepper "<generate-strong-pepper>"
serverpod cloud secret set jwtHmacSha512PrivateKey "<generate-strong-512-bit-key>"
```

### Step 4: Deploy the Backend
```bash
cd campusloop_server
serverpod cloud deploy
```
This builds and deploys your Serverpod server, applies database migrations to the managed PostgreSQL database, and enables health monitoring.

### Step 5: Point Flutter Client to Production
In `campusloop_flutter/lib/main.dart`:
```dart
void main() {
  // Replace localhost with your Serverpod Cloud URL
  client = Client(
    'https://campusloop.serverpod.cloud/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const CampusLoopApp());
}
```

---

## 3. PostgreSQL Configuration Reference

### Development Configuration (`campusloop_server/config/development.yaml`)
```yaml
port: 8080
publicHost: localhost
publicPort: 8080
database:
  host: localhost
  port: 5432
  name: campusloop
  user: postgres
```

### Production Configuration (`campusloop_server/config/production.yaml`)
```yaml
port: 8080
publicHost: campusloop.serverpod.cloud
publicPort: 443
database:
  host: postgres.serverpod.cloud
  port: 5432
  name: campusloop_prod
  user: serverpod
```

### Database Tables & Relations
- `student_profile`: Core user records (email, department, year, study subjects, interests).
- `campus_event`: Event records with category indexing and organizer foreign key.
- `community`: Interest groups with member counts and category tags.
- `community_membership`: Join table linking profiles to communities with role tracking.
- `community_post`: Community message feed with pinning capabilities.
- `campus_update`: Official announcements with priority levels and publication timestamps.
- `study_partner_request`: Bidirectional connection lifecycle (pending, accepted, rejected).
