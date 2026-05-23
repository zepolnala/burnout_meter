# Technical Debt Registry

A professional ledger documenting technical debt accepted during the MVP phase of **BurnoutMeter**. We categorize our debt to ensure maintainability and prioritize future refactoring.

---

## 📊 Technical Debt Breakdown

### 1. Accepted Debt (Intentionally Deferred)
*   **Static Local Fixtures for Wearables**: 
    *   *Context*: The `ReplayHealthDataSource` reads a static JSON file (`replay_health_data.json`).
    *   *Impact*: Wearable simulation is identical for all users.
    *   *Mitigation*: We created a deterministic fallback generator (`_generateDeterministicReplay`) that adds distinct variances based on UIDs. Shifting to physical BLE connections is isolated under `HealthDataSource`.
*   **Client-Side Score Creation**:
    *   *Context*: The score is computed client-side and saved directly to `/scores/`.
    *   *Impact*: A malicious client could write artificial scores.
    *   *Mitigation*: Firestore rules enforce that a user can only write scores with their own `userId`. In production, scoring is migrated to serverless Firebase functions, and client write permissions are disabled.

### 2. Intentional Debt (MVP Scope Limitations)
*   **Mocked Trend Visualizations**:
    *   *Context*: The weekly heart rate average bars on `EmployeeShell` render static arrays.
    *   *Impact*: Visually beautiful, but doesn't reflect actual historical queries.
    *   *Mitigation*: Prepares the UI card for real SQLite/Drift databases without introducing bloated charts or heavy visualization packages.
*   **Audit Log Creation from Client**:
    *   *Context*: Audit logs are written by the client application on read requests.
    *   *Impact*: A user could read without generating a log by bypassing the client.
    *   *Mitigation*: Security rules make logs strictly **write-once** (creates allowed, edits/deletions blocked). In production, audit ledger logging is moved to backend triggers (Firestore Eventarc or triggers).

### 3. Future Modularization Roadmap
*   **Microservice Decoupling**: Extract `ScoringEngine` into a standalone Dart package (`burnoutmeter_scoring`) that can be imported both by the client app and the serverless scoring functions, ensuring DRY calculations.
*   **State Telemetry Integration**: Swap our stdout `AppLogger` hooks for an OpenTelemetry adapter that feeds logs directly to GCP Cloud Logging or Datadog dashboards.
