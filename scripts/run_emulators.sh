#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Automatically map Homebrew OpenJDK path if present (macOS standard for keg-only formulas)
if [ -d "/opt/homebrew/opt/openjdk/bin" ]; then
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

echo "=========================================================="
echo "🔥 Starting Firebase Local Emulators for BurnoutMeter 🔥"
echo "=========================================================="

# Check if firebase-tools is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ ERROR: Firebase CLI (firebase-tools) not found."
    echo "Please install it using: npm install -g firebase-tools"
    exit 1
fi

# Run the emulators
firebase emulators:start --only auth,firestore,functions -P demo-burnoutmeter
