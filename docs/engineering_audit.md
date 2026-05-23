# Engineering Audit: BurnoutMeter Platform

**Date:** May 2026
**Type:** Deep Technical & Security Audit
**Objective:** Expose architectural debt, testing gaps, CI/CD fragility, and security flaws without aspirational language.

---

## 1. CI/CD Reliability & GitHub Actions

**Status:** 0% Reliable (Broken in Main)

### Empirical Evidence
The GitHub Actions workflow `BurnoutMeter CI/CD Pipeline` is currently failing immediately at the `Install Dependencies` step.

**Log Extract:**
```text
The plugin `cloud_firestore` requires your app to be migrated to the Android embedding v2.
##[error]Process completed with exit code 1.
```

### Root Cause (Version Drift)
Local development has drifted significantly from the CI environment. The `pubspec.yaml` allows Dart SDK `>=3.0.0 <4.0.0`, and the local machine is running a bleeding-edge/unstable version of Flutter (Web compiler traces show `FLUTTER_VERSION=3.44.0`). 
However, `.github/workflows/flutter_ci.yml` strictly pins Flutter to `3.19.x`. Flutter 3.19 rejects the modern `cloud_firestore` V2 embedding constraints, immediately killing the pipeline.

**Actionable Fix:** Align local and CI SDK constraints exactly. Pin CI to `3.24.x` or the exact local equivalent.

---

## 2. E2E Reliability & Browser Fragility

**Status:** Highly Fragile Locally

### Empirical Evidence
Execution of `scripts/run_e2e.sh` fails on the macOS host environment:
```text
Oops; flutter has exited unexpectedly: "SessionNotCreatedException (500):
session not created: This version of ChromeDriver only supports Chrome version 149
Current browser version is 148.0.7778.179"
```

### Root Cause
The E2E suite depends on an unpinned, globally installed `chromedriver` (via Homebrew) interfacing with the host OS's auto-updating Google Chrome. When Homebrew upgraded `chromedriver` to v149, but the system Chrome was stuck at v148, the bridge broke.

**Impact:** Tests are not reproducible across different developer machines.
**Actionable Fix:** E2E tests should execute inside a Docker container (e.g., using Playwright/Puppeteer images) where the browser and driver binaries are strictly matched and immutable.

---

## 3. Security Audit: Privilege Escalation & Tenant Isolation

**Status:** Critical Vulnerabilities Found

### Vulnerability 1: Client-Side Privilege Escalation
In `firestore.rules`, the `memberships` collection contains the following rule:
```javascript
allow write: if isAuthenticated() && (isAdmin() || isOwner(userId)); 
```
**Impact:** ANY authenticated user can write their own membership document. A malicious employee can simply execute a Firestore `set()` from the browser console:
```javascript
db.collection('memberships').doc(myUid).set({ role: 'admin', orgId: 'my-org' })
```
This grants them immediate, system-wide Administrator access. The "dynamic seeding" assumption completely breaks zero-trust architecture.

### Vulnerability 2: Tenant Isolation Bypass
Because users can write their own memberships, a malicious user can elevate themselves to `manager`, and inject arbitrary `teamId` arrays into their `managedTeamIds` property. 
Because the `scores` read rule only verifies `resource.data.teamId in getMembership().managedTeamIds` (without enforcing `sameOrg`), the attacker can read burnout scores from *other* organizations.

**Actionable Fix:** Client applications must *never* dictate roles. Role assignment must occur via secure Firebase Admin SDK (Cloud Functions) or custom JWT claims. Remove `isOwner(userId)` from membership write rules immediately.

---

## 4. Testing Coverage Audit

**Status:** Abysmal (Less than 5% actual coverage)

### Empirical Evidence
Execution of `flutter test --coverage` combined with `lcov` output yields exactly 36 lines of covered code, entirely confined to `lib/shared/utils/scoring_engine.dart`.

### Gaps
*   **0% UI Coverage:** Not a single widget test exists (the default `widget_test.dart` was deleted because it crashed without a Firebase mock).
*   **0% State Coverage:** Riverpod providers, caching, and health ingestion logic are completely untested natively.
*   **False Positives:** The `integration_test/app_test.dart` only tests a "Happy Path" login. It does not test RBAC deflections, unauthorized access attempts, or network failures.

---

## 5. Technical Debt & Demo-Only Implementations

### Demo-Only Implementations
*   **ReplayHealthDataSource:** The app relies on a hardcoded array of physiological data (`_mockBiometrics`). This is useless for production. There is no actual HealthKit/Google Fit integration interface prepared.
*   **Mock Repositories:** The system uses in-memory `_consents` and `_controllers`. These memory leaks were patched via a `dispose()` method, but the entire persistence layer needs to be rewritten to interface with Firestore.

### Missing Production Concerns
*   **Observability:** `AppLogger` is currently just a wrapper around `print()`. In a production Web app, this is invisible to operators. It must be wired to Sentry, Datadog, or Firebase Crashlytics.
*   **Offline Support:** No offline caching or persistence strategy is defined for the Flutter Web target.
*   **Rebuild Storms:** Riverpod's `StateNotifier` logic currently lacks distinct `select()` statements in the UI, meaning deep updates to team scores might trigger full-page rebuilds across the Manager dashboard.

---

## 6. Summary of Real Constraints

BurnoutMeter is currently an advanced prototype. To declare it "Production-Ready", the following strictly engineered steps must occur:

1.  **Hardcode CI SDKs:** Stop using `3.19.x` in GitHub Actions.
2.  **Fix Firestore Rules:** Strip client write-access to the `memberships` collection.
3.  **Implement Cloud Functions:** Move RBAC assignment and seeding to an isolated Node.js environment.
4.  **Replace WebDrivers:** Migrate E2E testing to a containerized browser environment to escape local ChromeDriver mismatches.
5.  **Write Real Mocks:** Implement `mockito` to allow Widget Tests to run in isolation without crashing the Dart VM.
