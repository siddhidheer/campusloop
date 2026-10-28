# CampusLoop — Strict Technology Stack Audit & Compliance Record

**Team**: HACKTIVATORS  
**Track**: Campus Life, Upgraded (Flutter + Serverpod)  
**Date**: October 2026  
**Status**: 100% STRICT COMPLIANCE CONFIRMED  

---

## 1. Approved Stack Verification Matrix

| Component | Approved Technology | Implemented In | Compliance Status |
|:---|:---|:---|:---:|
| **Frontend UI** | Flutter & Dart (Material 3) | `campusloop_flutter/` | ✅ STRICT COMPLIANCE |
| **Language** | Dart (`>=3.5.0 <4.0.0`) | Entire codebase | ✅ STRICT COMPLIANCE |
| **Backend Framework** | Serverpod 4.0 | `campusloop_server/` | ✅ STRICT COMPLIANCE |
| **Client RPC / Models** | Serverpod Generated Client | `campusloop_client/` | ✅ STRICT COMPLIANCE |
| **Database** | PostgreSQL | Serverpod Cloud PostgreSQL, `migrations/` | ✅ STRICT COMPLIANCE |
| **Backend Hosting** | Serverpod Cloud | `https://campusloop1.api.serverpod.space/` | ✅ STRICT COMPLIANCE |
| **Local Environment** | Local Flutter, Dart & Serverpod CLI | Workstation (`C:\tools\flutter\bin`, Pub cache) | ✅ VERIFIED LOCAL SETUP |
| **Cloud Dev Environment** | Google Project IDX | `.idx/dev.nix` | ✅ ZERO LOCAL INSTALL OPTION |
| **CI/CD & Distribution** | GitHub Actions & GitHub Releases | `.github/workflows/build_apk.yml` | ✅ AUTOMATED RELEASES |

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
  shared_preferences: ^2.5.3
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
  - ❌ Hive / SQLite / Isar: NOT USED (All core models persist in PostgreSQL via Serverpod; `shared_preferences` is used strictly for offline session tokens, credentials, and notification read receipts)

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
  - ❌ Mongo / Redis / SQLite / MySQL: NOT USED (Managed PostgreSQL via Serverpod only)
  - ❌ External non-Dart microservices: NOT USED

### C. `campusloop_client/pubspec.yaml`
```yaml
dependencies:
  serverpod_client: ^4.0.0
  serverpod_auth_idp_client: ^4.0.0
```

- Pure Serverpod client library providing type-safe RPC models and endpoints.

---

## 3. Negative Constraints Verification

| Prohibited Item | Verification Finding | Confirmation |
|:---|:---|:---:|
| Alternative frontend framework (React Native, web JS frameworks, Swift, Kotlin) | Only Flutter used. | Confirmed ✅ |
| Non-Dart backend (Go, Python, Java, Node, Rust) | 100% Dart backend using Serverpod 4.0. | Confirmed ✅ |
| Non-PostgreSQL database (MongoDB, DynamoDB, Firebase Firestore, MySQL) | PostgreSQL relational schema and Serverpod models only. | Confirmed ✅ |
| Third-party BaaS (Supabase, Firebase, Appwrite, AWS Amplify) | No external BaaS used. Managed Serverpod Cloud backend exclusively. | Confirmed ✅ |
| Unapproved hosting provider (Vercel, AWS ECS, Heroku, Render) | Deployed exclusively to Serverpod Cloud (`campusloop1`). | Confirmed ✅ |
| Prohibited local dependencies | Workstation utilizes official Flutter, Dart SDK, and Serverpod CLI. | Confirmed ✅ |

---

## 4. Architectural Summary

- **Frontend Architecture**: Material 3 theming with custom deep teal, coral, soft blue, and dark navy visual identity. 5-tab app shell with persistent state preservation (`IndexedStack`), dynamic keyed subtab navigation, interactive notifications modal sheet, and danger zone account deletion.
- **Communication Layer**: Binary WebSocket and HTTP RPC protocols native to Serverpod.
- **Data Persistence**: Relational PostgreSQL database tables with strict foreign keys, b-tree indexes, cascading deletions, and uniqueness constraints.
- **Security & Authorization**: Server-side validation on every mutation; creator-only authorization on event updates/deletions, community admin controls, cascading user deletion (`deleteAccount`), and duplicate request prevention.
