#!/bin/bash
# SessionStart hook for Mix project
# Detects Claude Code remote environment and provides setup instructions

set -e

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
FLUTTER_SDK_PATH="$PROJECT_DIR/.fvm/flutter_sdk/bin"
FVM_BIN_PATH="$HOME/fvm/bin"
PUB_CACHE_BIN="$HOME/.pub-cache/bin"

# Only run in Claude Code remote environment
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

# Check if Flutter SDK is already installed via FVM
if [ -d "$PROJECT_DIR/.fvm/flutter_sdk/bin" ] && [ -x "$PROJECT_DIR/.fvm/flutter_sdk/bin/flutter" ]; then
  # Flutter is installed - persist PATH to session environment
  if [ -n "$CLAUDE_ENV_FILE" ]; then
    echo "export PATH=\"$FLUTTER_SDK_PATH:$FVM_BIN_PATH:$PUB_CACHE_BIN:\$PATH\"" >> "$CLAUDE_ENV_FILE"
  fi

  FLUTTER_VERSION=$("$PROJECT_DIR/.fvm/flutter_sdk/bin/flutter" --version 2>/dev/null | head -1 || echo "unknown")
  echo "Mix Development Environment Ready"
  echo "=================================="
  echo "$FLUTTER_VERSION"
  echo ""
  echo "Dart, Flutter, FVM, and melos are available in PATH."
  exit 0
fi

# Flutter not installed - show setup instructions
cat << 'EOF'
Mix Development Environment Setup Required
===========================================

Flutter SDK is not installed. To set up the development environment, run:

    bash setup.sh

This will install:
  - FVM (Flutter Version Manager)
  - Flutter SDK (version from .fvmrc)
  - DCM (Dart Code Metrics)
  - melos (monorepo tool)

After setup completes, Flutter and Dart will be available in your PATH.

Verification commands:
    flutter --version
    dart --version
    melos --version
EOF

exit 0
