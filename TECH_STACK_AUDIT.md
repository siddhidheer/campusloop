# CampusLoop — Strict Technology Stack Audit & Compliance Record

**Team**: HACKTIVATORS  
**Track**: Campus Life, Upgraded (Flutter + Serverpod)  
**Date**: October 2026  
**Status**: 100% STRICT COMPLIANCE CONFIRMED  

---

## 1. Approved Stack Verification Matrix

| Component | Approved Technology | Implemented In | Compliance Status |
|:---|:---|:---|:---:|
| **Frontend UI** | Flutter & Dart | `campusloop_flutter/` | ✅ STRICT COMPLIANCE |
| **Language** | Dart (`>=3.5.0 <4.0.0`) | Entire codebase | ✅ STRICT COMPLIANCE |
| **Backend Framework** | Serverpod 4.0 | `campusloop_server/` | ✅ STRICT COMPLIANCE |
| **Client RPC / Models** | Serverpod Generated Client | `campusloop_client/` | ✅ STRICT COMPLIANCE |
| **Database** | PostgreSQL | `campusloop_server/deploy/schema.sql`, `migrations/` | ✅ STRICT COMPLIANCE |
| **Backend Hosting** | Serverpod Cloud | `campusloop_server/config/production.yaml` | ✅ STRICT COMPLIANCE |
| **Cloud Dev Environment** | Google Project IDX | `.idx/dev.nix` | ✅ ZERO LOCAL INSTALL |

---

## 2. Dependency Audit by Package

### A. `campusloop_flutter/pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  serverpod_flutter: ^4.0.0
  serverpod_auth_idp_flutter: ^4.0.0
  serverpod_auth_idp_client: ^4.0.0
  campusloop_client:
    path: ../campusloop_client

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```
- **Prohibited State Management / Network Packages Checked**:
  - ❌ Provider: NOT USED
  - ❌ Riverpod: NOT USED
  - ❌ Bloc / Cubit: NOT USED (Pure Flutter `StatefulWidget` / `setState` & Serverpod reactive calls)
  - ❌ Dio / Http / Chopper: NOT USED (Serverpod client handles all RPC communication)
  - ❌ Firebase / Supabase: NOT USED
  - ❌ Hive / SharedPreferences / SQLite / Isar: NOT USED (All persistence is PostgreSQL via Serverpod)

### B. `campusloop_server/pubspec.yaml`
```yaml
dependencies:
  serverpod: ^4.0.0
  serverpod_auth_idp_server: ^4.0.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.24.0
  serverpod_test: ^4.0.0
```
- **Prohibited Backend / ORM Packages Checked**:
  - ❌ Express / Node / Nest: NOT USED
  - ❌ Prisma / TypeORM / Drizzle: NOT USED
  - ❌ Mongo / Redis / SQLite / MySQL: NOT USED (PostgreSQL only)
  - ❌ Docker-dependent external tools on local PC: NOT USED

### C. `campusloop_client/pubspec.yaml`
```yaml
dependencies:
  serverpod_client: ^4.0.0
  serverpod_auth_idp_client: ^4.0.0
```
- **Pure Serverpod client package** providing type-safe RPC models and endpoints.

---

## 3. Negative Constraints Verification

| Prohibited Item | Verification Finding | Confirmation |
|:---|:---|:---:|
| Alternative frontend framework (React Native, web, Swift, Kotlin) | Only Flutter used. | Confirmed |
| Non-Dart backend (Go, Python, Java, Node, Rust) | 100% Dart backend using Serverpod. | Confirmed |
| Non-PostgreSQL database (MongoDB, DynamoDB, Firebase Firestore, MySQL) | PostgreSQL DDL and Serverpod models only. | Confirmed |
| Third-party BaaS (Supabase, Firebase, Appwrite, AWS Amplify) | No external BaaS used. | Confirmed |
| Unapproved hosting provider (Vercel, AWS ECS, Heroku, Render) | Configured exclusively for Serverpod Cloud. | Confirmed |
| Local installations requested on user PC | Zero installations required. Runs in Project IDX. | Confirmed |

---

## 4. Architectural Summary

- **Frontend Architecture**: Material 3 theming with custom deep teal, coral, warm cream, and dark navy visual identity. Responsive 5-tab app shell with persistent state preservation (`IndexedStack`).
- **Communication Layer**: Binary WebSocket and HTTP RPC protocols native to Serverpod.
- **Data Persistence**: Relational PostgreSQL database tables with strict foreign keys, b-tree indexes, and uniqueness constraints.
- **Security & Authorization**: Server-side validation on every mutation; creator-only authorization on event updates/deletions, community admin controls, and duplicate prevention.
