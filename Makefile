.PHONY: clean get build watch test lint bootstrap

clean:
	@echo "🧹 Cleaning workspace..."
	flutter clean
	rm -rf .dart_tool
	rm -rf pubspec.lock

get:
	@echo "📦 Getting packages..."
	flutter pub get

build:
	@echo "⚙️ Running code generator (build_runner)..."
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	@echo "👀 Watching code changes..."
	flutter pub run build_runner watch --delete-conflicting-outputs

test:
	@echo "🧪 Running tests..."
	flutter test

lint:
	@echo "🔍 Running lints and analyzer..."
	flutter analyze

bootstrap:
	@echo "🚀 Bootstrapping the BurnoutMeter project..."
	chmod +x scripts/bootstrap.sh
	./scripts/bootstrap.sh
