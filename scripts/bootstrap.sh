#!/bin/bash
set -e

echo "=========================================================="
echo "🚀 Bootstrapping BurnoutMeter Project Scaffold 🚀"
echo "=========================================================="

# Ensure script is run from project root
cd "$(dirname "$0")/.."

echo "➡️ Step 1: Cleaning previous build caches..."
flutter clean

echo "➡️ Step 2: Resolving pubspec.yaml dependencies..."
flutter pub get

echo "➡️ Step 3: Triggering initial code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "➡️ Step 4: Verifying syntax & strict lints..."
flutter analyze

echo "=========================================================="
echo "✅ BurnoutMeter Bootstrap Completed Successfully! ✅"
echo "=========================================================="
