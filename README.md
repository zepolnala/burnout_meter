# BurnoutMeter — B2B Multi-Tenant Wellness SaaS Platform

![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-Passing-brightgreen.svg?style=flat-square)
![E2E Tests](https://img.shields.io/badge/E2E_Tests-Verified-blue.svg?style=flat-square)
![Security Rules](https://img.shields.io/badge/Security-Audited-blue.svg?style=flat-square)

BurnoutMeter is an enterprise B2B wellness platform built with **Flutter and Firebase** that enables early detection of employee psychophysiological load and burnout risk using wearable data (biometrics like HR, HRV, sleep, and respiration) without compromising personal privacy.

Designed strictly under **Privacy-by-Design** principles, this repository serves as a high-performance, clean-architecture production-ready scaffold designed to be audited by a CTO / Lead reviewer.

---

## 🧪 Verification & End-to-End Testing

This repository is backed by a fully automated CI/CD pipeline and comprehensive testing frameworks.

To run the Headless Web End-to-End Tests locally (requires `chromedriver`):
```bash
chmod +x scripts/run_e2e.sh
./scripts/run_e2e.sh
```

To mathematically verify the zero-trust RBAC Firestore security rules:
```bash
cd firestore-tests && npm test
```

---

## 🚀 The 3-Minute Executive Demo Journey

To evaluate the complete end-to-end integration under less than 3 minutes, follow this structured developer path:

### 1. Launch the Local Emulators
Start the secure local Firebase Emulator suite (Auth, Firestore, Consoles):
```bash
chmod +x scripts/run_emulators.sh
./scripts/run_emulators.sh
```

### 2. Boot the Flutter Web / Mobile client
Run the application in your developer environment. Note that the top global banner instantly displays **`[EMULADOR LOCAL ACTIVE]`** to show the emulator mode.

### 3. Bootstrap the Database (Seed)
On the Login screen, click **`Inicializar DB Local (Seed)`**. This runs our idempotent Dart `SeedService`, creating standard multi-tenant parameters, organization `org789`, teams, and default accounts in FirebaseAuth.

### 4. Step-by-Step Interactive Privacy Demo:
*   **Step A (Log in as Employee)**: Use the Quick Selector to enter as **Alan** (`employee_eng1@burnoutmeter.com`).
    *   Click **"Simular Lectura Wearable"** to fetch mock biometrics from the replay data source and trigger the `ScoringEngine` calculations. The circular gauge updates reactively!
*   **Step B (Log in as Manager)**: Sign out and log in as manager **Victor** (`manager_eng@burnoutmeter.com`).
    *   Observe the team list: Alan's score is visible and aggregates to the **"Attention Needed"** dashboard warning.
    *   Observe **Sofía Martín's** card: Her score displays **`🔒 Privado`** because she turned off consent sharing.
*   **Step C (GDPR Server Enforcement)**: Sign out, log back in as **Sofía** (`employee_eng2@burnoutmeter.com`), go to "Privacidad", and turn on score sharing. Log back in as Victor. Her score instantly renders reactively!
*   **Step D (Immutable Security Audits)**: Log out and enter as **Admin** (`admin@burnoutmeter.com`). Review the immutable ledger list: every single query and consent state modification created a permanent log that rules prohibit any actor from deleting.

---

## 🔑 Demo Credentials Directory

All seeded accounts use the standard password: **`password123`**

| Role | Email | Profile Name | Purpose |
| :--- | :--- | :--- | :--- |
| **Employee** | `employee_eng1@burnoutmeter.com` | Alan | Consenting employee. Triggers physiological simulations. |
| **Employee** | `employee_eng2@burnoutmeter.com` | Sofía Martín | Privacy-first employee (Consent sharing initially disabled). |
| **Manager** | `manager_eng@burnoutmeter.com` | Victor | Team Lead managing `teamEng`. Aggregates risk alerts. |
| **Admin** | `admin@burnoutmeter.com` | Global Admin | Multi-Tenant auditor. Consults inmutable audit ledgers. |

---

## 🏛️ Architecture and System Structure

The codebase is organized according to **Clean Architecture** rules, fully isolating domain contracts from presentation layers and database clients:

*   [docs/architecture.md](file:///Users/alan/Burnout%20meter/docs/architecture.md) — Rationale for Flutter, Riverpod, clean routing guards, and architecture levels.
*   [docs/security-model.md](file:///Users/alan/Burnout%20meter/docs/security-model.md) — Multi-tenant Firestore rule designs, owner-only biometrics isolation, and GDPR consent limits.
*   [docs/data-flow.md](file:///Users/alan/Burnout%20meter/docs/data-flow.md) — Sequential diagrams of the scoring pipeline and manager Aggregations.
*   [docs/tradeoffs.md](file:///Users/alan/Burnout%20meter/docs/tradeoffs.md) — Trade-offs made in the MVP (client calculations, Replay JSON fixture) vs production-grade microservices.
*   [docs/technical-debt.md](file:///Users/alan/Burnout%20meter/docs/technical-debt.md) — Registry of accepted and future debt.

---

## 🧪 Testing Verification

The project includes an automated server-side security rules verification suite:
```bash
# Run Mocha tests inside the emulator
chmod +x scripts/run_emulator_tests.sh
./scripts/run_emulator_tests.sh
```
This tests:
*   Managers cannot read raw metrics (`healthSamples`).
*   Managers cannot read scores of employees who disabled sharing consent.
*   Admins and managers cannot edit or delete audit logs.

---

## 🚀 Telemetry & Telemetry Logs

BurnoutMeter is equipped with a centralized developer logging utility `AppLogger` that formats stdout logs using clean visual tags in standard output:
*   `🚀 [STARTUP]` — Prints app initialized states and environment targets.
*   `🔐 [AUTH]` — Tracks active sign-in sessions and sign-out actions.
*   `🔥 [FIRESTORE]` — Captures real-time document stream synchronization.
*   `🛡️ [GDPR_CONSENT]` — Logs employee consent modifications.
*   `🧮 [SCORING]` — Traces HRV calculation thresholds and sleep deprivation decay factors.
