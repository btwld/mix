#!/bin/bash
# Vercel build script for fluttermix.com
#
# This script runs during Vercel's auto-deploy to:
# 1. Install Flutter SDK
# 2. Build the Flutter preview bundle (interactive widget examples)
# 3. Build the Next.js website
#
# Vercel requirement: "Include source files outside of the Root Directory"
# must be enabled in Project Settings > Root Directory. This makes the full
# repo available at /vercel/path0/ while website/ is at /vercel/path1/.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEBSITE_DIR="$(dirname "$SCRIPT_DIR")"

fail() { echo "ERROR: $*" >&2; exit 1; }

# Resolve the monorepo root.
# On Vercel with "Include source files outside Root Directory" enabled,
# the full repo is at /vercel/path0/ while the root directory (website/)
# is mounted at /vercel/path1/. Locally, ".." from website/ is the repo root.
if [ -d "/vercel/path0" ] && [ -f "/vercel/path0/.fvmrc" ]; then
    PROJECT_DIR="/vercel/path0"
elif [ -f "$WEBSITE_DIR/../.fvmrc" ]; then
    PROJECT_DIR="$(cd "$WEBSITE_DIR/.." && pwd)"
else
    fail "Cannot find monorepo root. Ensure 'Include source files outside of the Root Directory' is enabled in Vercel Project Settings."
fi

echo "==> Project root: $PROJECT_DIR"
echo "==> Website dir:  $WEBSITE_DIR"

# ============================================================================
# Install Flutter SDK
# ============================================================================
[ -f "$PROJECT_DIR/.fvmrc" ] || fail ".fvmrc not found at $PROJECT_DIR/.fvmrc"

FLUTTER_VERSION=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$PROJECT_DIR/.fvmrc','utf8')).flutter)")
[ -z "$FLUTTER_VERSION" ] && fail "Could not read Flutter version from .fvmrc"

FLUTTER_DIR="$HOME/flutter"

echo "==> Installing Flutter $FLUTTER_VERSION..."

if [ -d "$FLUTTER_DIR" ] && "$FLUTTER_DIR/bin/flutter" --version 2>/dev/null | grep -q "$FLUTTER_VERSION"; then
    echo "    Flutter $FLUTTER_VERSION already installed (cached)"
else
    rm -rf "$FLUTTER_DIR"
    git clone https://github.com/flutter/flutter.git --branch "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR" \
        || fail "Failed to clone Flutter SDK $FLUTTER_VERSION"
fi

export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"

command -v flutter >/dev/null 2>&1 || fail "Flutter not found on PATH after install"
command -v dart >/dev/null 2>&1    || fail "Dart not found on PATH after install"

echo "    $(flutter --version | head -1)"

# ============================================================================
# Bootstrap monorepo
# ============================================================================
echo "==> Bootstrapping monorepo..."
dart pub global activate melos
cd "$PROJECT_DIR"
melos bootstrap

# ============================================================================
# Build Flutter preview bundle
# ============================================================================
echo "==> Building Flutter preview bundle..."
bash "$PROJECT_DIR/examples/scripts/build_web_previews.sh" --local

# Verify the build produced the expected artifacts
BUILD_DIR="$PROJECT_DIR/examples/build/web"
[ -f "$BUILD_DIR/main.dart.js" ]           || fail "Flutter web build missing: main.dart.js"
[ -f "$BUILD_DIR/flutter_bootstrap.js" ]   || fail "Flutter web build missing: flutter_bootstrap.js"
[ -f "$BUILD_DIR/previews-manifest.json" ] || fail "Flutter web build missing: previews-manifest.json"

echo "    Build verified: main.dart.js, flutter_bootstrap.js, previews-manifest.json"

# ============================================================================
# Copy preview bundle to website
# ============================================================================
echo "==> Copying preview bundle to website/public/previews/..."
rm -rf "$WEBSITE_DIR/public/previews"
mkdir -p "$WEBSITE_DIR/public/previews"
cp -r "$BUILD_DIR"/* "$WEBSITE_DIR/public/previews/"

# Verify the copy succeeded
[ -f "$WEBSITE_DIR/public/previews/previews-manifest.json" ] \
    || fail "Preview manifest not found after copy to public/previews/"
[ -f "$WEBSITE_DIR/public/previews/main.dart.js" ] \
    || fail "main.dart.js not found after copy to public/previews/"

MANIFEST_ENTRIES=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$WEBSITE_DIR/public/previews/previews-manifest.json','utf8')).entries.length)")
echo "    Copied preview bundle ($MANIFEST_ENTRIES preview entries)"

# ============================================================================
# Validate preview manifest
# ============================================================================
echo "==> Validating preview manifest..."
cd "$WEBSITE_DIR"
pnpm run check:previews

# ============================================================================
# Build Next.js
# ============================================================================
echo "==> Building Next.js site..."
pnpm run build

echo "==> Build complete!"
