#!/bin/bash
# Setup script for First-App-Building

set -e

echo "🚀 Setting up First-App-Building..."

# Check Flutter
echo "📱 Checking Flutter..."
flutter --version

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Run analysis
echo "🔍 Running analysis..."
flutter analyze

# Run tests
echo "🧪 Running tests..."
flutter test

echo "✅ Setup complete!"
echo ""
echo "To run the app:"
echo "  flutter run -d \"iPhone 16\"  # iOS Simulator"
echo "  flutter run -d chrome         # Web"