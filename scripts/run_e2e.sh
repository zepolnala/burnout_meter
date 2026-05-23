#!/bin/bash
set -e

echo "============================================="
echo "🏃‍♂️ Starting BurnoutMeter E2E Web Tests"
echo "============================================="

# Ensure test driver folder exists
mkdir -p test_driver
if [ ! -f test_driver/integration_test.dart ]; then
  echo "import 'package:integration_test/integration_test_driver.dart';" > test_driver/integration_test.dart
  echo "Future<void> main() => integrationDriver();" >> test_driver/integration_test.dart
fi

# Check if chromedriver is available
if ! command -v chromedriver &> /dev/null; then
  echo "⚠️ chromedriver is not installed."
  echo "Please install it (e.g., 'brew install --cask chromedriver' on macOS or 'apt-get install chromium-chromedriver' on Linux) to run web integration tests."
  exit 1
fi

# Start Chromedriver in background
echo "🌐 Starting chromedriver on port 4444..."
chromedriver --port=4444 &
CHROMEDRIVER_PID=$!

# Ensure it's killed when the script exits
trap "echo '🛑 Stopping chromedriver...'; kill $CHROMEDRIVER_PID" EXIT

# Wait for chromedriver to initialize
sleep 3

# Run tests using firebase emulators:exec
echo "🔥 Starting Firebase Emulators and running flutter drive..."
firebase emulators:exec "flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d web-server"

echo "✅ E2E Testing Complete!"
