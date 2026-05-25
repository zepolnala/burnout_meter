# Release Candidate (RC) Validation Checklist

This checklist defines the rigorous validation gate that BurnoutMeter must pass before transitioning from a Release Candidate (RC) to a production-ready release. 

---

## 🟩 1. Static Code Analysis & Health

- [x] **0 Lints / 0 Warnings:** `flutter analyze` must run and output `No issues found!`.
- [x] **Reproducible Generation:** `dart run build_runner build --delete-conflicting-outputs` completes without conflict.
- [x] **Dependency Safety:** All libraries in `pubspec.yaml` are pinned to stable, compatible versions.

---

## 🛡️ 2. Security & Zero-Trust Access Rules

- [x] **Raw Biometric Isolation:** Verify that `/healthSamples` rules deny access to Managers and Admins under all circumstances. Only the owning Employee can read/write raw signals.
- [x] **Multi-Tenant Separation:** Verify that `/memberships` and `/scores` read rules restrict access to the active user's `orgId` via:
  ```javascript
  sameOrg(resource.data.orgId)
  ```
  Admins or Managers from Org A must be mathematically blocked from reading data of Org B.
- [x] **Consent Enforcement:** Verify that `/scores` reads are blocked for Managers if:
  ```javascript
  consentSharing(userId) == false
  ```
- [x] **Write-Once Security Ledger:** Verify `/audit_logs` rules prevent any modification or deletion:
  ```javascript
  allow update, delete: if false;
  ```
- [x] **Hardened Database Bootstrapping:** Verify that `/seed_status` write access is restricted to authenticated users only (`allow write: if isAuthenticated()`).

---

## 📊 3. Observability & Telemetry

- [x] **Platform-Safe Crashlytics:** Verify Firebase Crashlytics is initialized with safety wrappers to prevent crashes on unsupported platforms.
- [x] **Debug/Emulator Silence:** Confirm Crashlytics data collection is disabled in local debug or emulator modes:
  ```dart
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode && !useEmulator);
  ```
- [x] **Global Error Boundaries:** Check that `FlutterError.onError` and `PlatformDispatcher.instance.onError` are wired to catch all uncaught exceptions.
- [x] **Riverpod State Observability:** Confirm `AppProviderObserver` is wired to intercept and log provider failures directly to Crashlytics as non-fatal exceptions.
- [x] **Cross-platform Breadcrumbs:** Verify `AppLogger` logs are mirrored to `FirebaseCrashlytics.instance.log` as diagnostic breadcrumbs.

---

## 🧪 4. Automated Testing Gates

- [x] **Scoring Engine Unit Tests:** Verify all physiological equations in `test/scoring_engine_test.dart` pass successfully.
- [x] **Zero-Trust Rule Compliance:** Run and pass all Mocha compliance tests in the `firestore-tests` suite.
- [x] **E2E Simulation Flows:** Pass headless ChromeDriver multi-role simulations.
- [x] **Clean Web Compilation:** Verify that `flutter build web --release` builds successfully.

---

## 👥 5. Live Demo Execution

- [x] **Idempotent Data Seeding:** Database successfully resets and populates when hitting **"Inicializar DB Local (Seed)"**.
- [x] **Role Deflection (RBAC Guards):** Attempting to manually navigate to `/admin` as an Employee or `/employee` as a Manager is intercepted and redirected by `go_router` guards.
- [x] **Privacy Toggle Reactivity:** Disabling consent sharing in the Employee interface instantly masks the score in the Manager's active view.
- [x] **Audit Logging Trail:** Performing queries or updating consent states creates immutable records inside the security ledger.
