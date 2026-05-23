#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Automatically map Homebrew OpenJDK path if present (macOS standard for keg-only formulas)
if [ -d "/opt/homebrew/opt/openjdk/bin" ]; then
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

echo "=========================================================="
echo "🧪 Running Firestore Security Rules Unit Tests 🧪"
echo "=========================================================="

# Check if firebase-tools is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ ERROR: Firebase CLI (firebase-tools) not found."
    echo "Please install it using: npm install -g firebase-tools"
    exit 1
fi

# Run the rules tests inside the emulator lifecycle (auto shutdown)
firebase emulators:exec --only firestore "cd firestore-tests && npm install && npm run test"
