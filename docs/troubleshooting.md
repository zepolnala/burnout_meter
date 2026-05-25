# Troubleshooting & Developer Support Guide

This document lists solutions to common errors and friction points that developers or evaluators may encounter while setting up or running the BurnoutMeter local development environment.

---

## 🚫 1. Firebase Emulator Port Conflicts

### Symptom:
When running `./scripts/run_emulators.sh`, you see an error like:
```text
Port 8080 is already in use.
Port 9099 is already in use.
```

### Cause:
A previous emulator session was not shut down cleanly, or another local development server (like a web API or Java server) is occupying port `8080` (Firestore) or `9099` (Auth).

### Solution:
Find and terminate the processes holding these ports.
```bash
# Find process on port 8080 (Firestore)
lsof -i :8080
# Find process on port 9099 (Auth)
lsof -i :9099

# Force kill the process using its PID (Process ID)
kill -9 <PID>
```
Then, restart `./scripts/run_emulators.sh`.

---

## 💾 2. Local Database Schema Drift & Cached State

### Symptom:
When running the Employee shell, the application crashes, behaves unexpectedly with local persistence, or Drift fails to compile/read because the local schema is out of sync.

### Cause:
Local SQLite caches are storing an outdated schema from a previous database iteration.

### Solution:
*   **For Web Target (Chrome):** Open Chrome DevTools (F12) → go to the **Application** tab → under **Storage** click **Clear site data**. This completely wipes the browser-cached IndexedDB/SQLite database.
*   **For Mobile Target (Android/iOS):** Uninstall the application from the simulator or physical device and do a clean install. This purges the documents directory.
*   **Code Generation Refresher:** Force-recompile all models by deleting all generated files (`.g.dart`, `.freezed.dart`) and rebuilding:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

---

## 🌐 3. Headless E2E Web Tests and ChromeDriver Version Mismatch

### Symptom:
When running `./scripts/run_e2e.sh`, the test suite fails instantly with:
```text
WebDriverException: session not created: This version of ChromeDriver only supports Chrome version X
```

### Cause:
The version of Google Chrome installed on your machine has auto-updated, and the globally installed `chromedriver` is now outdated.

### Solution:
Update `chromedriver` to match your local Chrome version:
```bash
# On macOS (Homebrew)
brew upgrade --cask chromedriver

# Alternative: Use npm-based chromedriver version to bypass global dependencies
npx chromedriver --port=4444 &
```

---

## 🔑 4. Google Sign-In or Auth "Developer Error 10"

### Symptom:
When running on an Android device or emulator, trying to log in or register triggers a Firebase exception with `Developer Error 10`.

### Cause:
The package signature (SHA-1 fingerprint) of your local Android debug keystore is not registered inside the Google/Firebase Console project settings.

### Solution:
1.  Extract the SHA-1 fingerprint from your local debug keystore:
    ```bash
    keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
    ```
2.  Copy the SHA-1 fingerprint from the terminal output.
3.  Go to the **Firebase Console** → Project Settings → Select your Android App → Add fingerprint → Paste the SHA-1 key and save.
4.  Download the updated `google-services.json` and replace the existing one in `android/app/google-services.json`.
