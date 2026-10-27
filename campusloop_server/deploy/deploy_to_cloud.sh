#!/usr/bin/env bash
# ==============================================================================
# CampusLoop — Serverpod Cloud Deployment Script
# Team: HACKTIVATORS | Track: Campus Life, Upgraded
# ==============================================================================

set -e

PROJECT_NAME="campusloop"
DEPLOY_TOKEN="01a17e55"

echo "=== Deploying CampusLoop to Serverpod Cloud ==="
echo "Project: $PROJECT_NAME"
echo ""

# Ensure serverpod CLI is available
if ! command -v serverpod &> /dev/null; then
    echo "Serverpod CLI not found in PATH. Installing..."
    dart pub global activate serverpod_cli
    export PATH="$PATH":"$HOME/.pub-cache/bin"
fi

cd "$(dirname "$0")/.."

echo "1. Resolving server dependencies..."
dart pub get

echo "2. Applying database migrations on Serverpod Cloud..."
dart bin/main.dart --mode production --apply-migrations || true

echo "3. Deploying backend to Serverpod Cloud..."
serverpod cloud deploy --project "$PROJECT_NAME" --token "$DEPLOY_TOKEN"

echo ""
echo "=== Deployment Succeeded! ==="
echo "Live URL: https://api.campusloop.serverpod.cloud/"
