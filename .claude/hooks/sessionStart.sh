#!/bin/bash
# Claude Code Web - Session Start Hook
# This script runs when a Claude Code session starts in the web environment

set -e  # Exit on error

echo "🚀 Initializing Mix workspace..."

# Check if we're in the remote (web) environment
if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  echo "📦 Running in Claude Code remote environment"

  # Install Melos globally if not available
  if ! command -v melos &> /dev/null; then
    echo "📥 Installing Melos..."
    dart pub global activate melos
    export PATH="$PATH:$HOME/.pub-cache/bin"
  fi

  # Bootstrap the workspace
  echo "🔧 Bootstrapping Melos workspace..."
  melos bootstrap

  # Run code generation
  echo "🏗️  Running code generation..."
  melos run gen:build

  # Set environment variables for this session
  echo "FLUTTER_ENV=development" >> "$CLAUDE_ENV_FILE"
  echo "MELOS_WORKSPACE=mix_workspace" >> "$CLAUDE_ENV_FILE"

  echo "✅ Environment setup complete!"
  echo ""
  echo "Available Melos commands:"
  echo "  • melos run analyze        - Run all static analysis"
  echo "  • melos run test:flutter   - Run Flutter tests"
  echo "  • melos run test:dart      - Run Dart tests"
  echo "  • melos run gen:build      - Generate code"
  echo "  • melos run lint:fix:all   - Fix linting issues"
  echo ""
else
  echo "ℹ️  Running in local environment - skipping remote setup"
fi

# Always show workspace info
echo "📊 Workspace packages:"
melos list --relative 2>/dev/null || echo "  (Run 'melos bootstrap' to see packages)"
