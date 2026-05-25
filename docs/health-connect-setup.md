# Google Health Connect Production Setup Guide

This guide details the infrastructure, credentials, and app store registration steps required to promote the Google Health Connect integration in this `feature/health-connect-integration` branch into a live, physical production environment.

---

## 🛠️ 1. Local Android Signature Retrieval

Google Health Connect requires all applications accessing biometrics to be cryptographically signed, and their SHA-1 fingerprints registered in the Google Cloud Console.

Retrieve your local developer signing signature:
```bash
# Extract the SHA-1 fingerprint from the local Android debug keystore
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
```
Copy the **SHA-1 Fingerprint** value from the terminal output (e.g. `2D:3F:8A:...`).

---

## ☁️ 2. Google Cloud Console Configuration

To authorize the OAuth 2.0 handshake between your app and the Google Health services:

1.  Open the [Google Cloud Console](https://console.cloud.google.com/).
2.  Create or select your active **Firebase / BurnoutMeter** Cloud Project.
3.  Go to **APIs & Services** ➔ **Credentials**.
4.  Click **Create Credentials** ➔ **OAuth client ID**.
5.  Configure the client:
    *   **Application type:** `Android`
    *   **Package name:** `com.example.burnout_meter_app` (or your defined application package id)
    *   **SHA-1 certificate fingerprint:** Paste the SHA-1 key copied in Step 1.
6.  Go to the **OAuth consent screen** tab:
    *   Set Publishing Status to **Testing** (or Production).
    *   Add your developer email to the **Test users** list.

---

## 🤖 3. Android System Requirements

For the integration to execute successfully on a physical or emulated device:

1.  **Operating System:** Android 10+ (Health Connect is natively integrated on Android 14+; downloadable as a system app on Android 10-13).
2.  **System App:** Install **Health Connect** from the Google Play Store if it's not pre-installed.
3.  **Mock Biometrics:** Use an app like **Google Fit** or **Samsung Health** on the device to write some mock heart rate or sleep duration samples into the local device database, providing points for BurnoutMeter to retrieve.

---

## 🏗️ 4. Swapping the HealthDataSource Provider in Code

To swap from the deterministic `ReplayHealthDataSource` (used in the `main` branch demo) to the live `HealthConnectDataSource` on this branch:

Open [lib/shared/providers/repository_providers.dart](file:///Users/alan/Burnout%20meter/lib/shared/providers/repository_providers.dart) and update the provider registration:

```dart
// FROM:
final healthDataSourceProvider = Provider<HealthDataSource>((ref) {
  return ReplayHealthDataSource(); // Deterministic JSON Replay
});

// TO:
final healthDataSourceProvider = Provider<HealthDataSource>((ref) {
  return HealthConnectDataSource(); // Real Google Health Connect Driver
});
```

*This architectural swap requires 0 changes to your models, scoring algorithms, rules, or screens—fully demonstrating the power of our clean dependency inversion design.*
