# Design Compromises & Architectural Trade-offs

This document chronicles the intentional compromises made in the **BurnoutMeter** MVP prototype. It highlights pragmatic engineering balances between rapid demonstration capability, local testing speed, and scalable production patterns.

---

## ⚖️ MVP Trade-offs Matrix

| Architectural Area | MVP Pragmatic Approach | Final Production SaaS Pattern | Rationale for Compromise |
| :--- | :--- | :--- | :--- |
| **Scoring Execution** | Calculated client-side; score uploaded directly to Firestore `/scores/`. | Handled server-side via Firebase Functions or dedicated Go/Rust microservices. | **Pragmatism**: Client-side execution enables 100% offline-ready emulated demos without maintaining external servers. Firestore rules still guarantee access security. |
| **Wearable Ingestion** | JSON Replay fixture simulating physiological time series. | Direct integration with iOS HealthKit, Android Health Connect, and Garmin Cloud APIs. | **Verification Focus**: Proves the E2E scoring mathematics and team dashboards are structurally sound before writing complex native bridges. |
| **Database Writing** | Client writes computed score documents directly to Firestore. | Restricted to read-only views for employee; scores populated exclusively by backend ingestion workers. | **Simplicity**: Keeps the prototype lightweight and ensures the automated rule test suite can run fully isolated. |
| **Telemetry & Log Management** | Centralized `AppLogger` writing structured ASCII traces to stdout. | Integration with OpenTelemetry, GCP Cloud Logging, and Sentry alerts. | **Pragmatic Observability**: stdout telemetry is easy to read in a local console during a live demo, while maintaining a clean abstraction layer for telemetry integrations. |

---

## 🛠️ Mitigating Architectural Debt

To ensure the MVP remains a robust springboard for a production codebase:
1. **Contract Isolation**: The repository provider layers use abstract domain classes. Shifting from the local emulator to live production APIs is as simple as adding a new concrete class in `/data/` and changing the provider bindings.
2. **Deterministic Calculations**: The clinical metrics engine is completely isolated from Flutter. It can be compiled in pure Dart and run on a serverless Node/Dart worker without modifying a single line of business logic.
