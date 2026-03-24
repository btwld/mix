#!/bin/bash
# Build mix_docs_preview for web embedding (documentation previews)
#
# Usage:
#   ./scripts/build_web_previews.sh           # Build and copy to website
#   ./scripts/build_web_previews.sh --local   # Build only (no copy)
#
# Output:
#   - Build artifacts in packages/mix_docs_preview/build/web/
#   - Copied to website/public/previews/ (unless --local)
#
# Run this script from the mix_docs_preview package directory, or from repo root.
# In CI/CD, run from repo root so PROJECT_DIR is correct.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREVIEWS_PKG_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$(cd "$PREVIEWS_PKG_DIR/../.." && pwd)"
BUILD_DIR="$PREVIEWS_PKG_DIR/build/web"
WEBSITE_PREVIEWS_DIR="$PROJECT_DIR/website/public/previews"
SOURCES_DIR="$BUILD_DIR/sources"
PREVIEWS_MANIFEST="$BUILD_DIR/previews-manifest.json"
PREVIEW_CHECK_SCRIPT="$PROJECT_DIR/website/scripts/check-previews-manifest.mjs"

LOCAL_ONLY=false
if [ "$1" = "--local" ]; then
    LOCAL_ONLY=true
fi

cd "$PREVIEWS_PKG_DIR"

if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter not found. Please install Flutter or run setup.sh"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
REQUIRED_VERSION="3.38.1"

version_ge() {
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}

if [ -z "$FLUTTER_VERSION" ]; then
    echo "Error: Unable to parse Flutter version"
    exit 1
fi

if ! version_ge "$FLUTTER_VERSION" "$REQUIRED_VERSION"; then
    echo "Error: Flutter $REQUIRED_VERSION+ required, found $FLUTTER_VERSION"
    exit 1
fi

echo "Building mix_docs_preview for web..."
echo "Flutter version: $(flutter --version | head -1)"

rm -rf "$BUILD_DIR"

flutter build web --release --pwa-strategy=none --base-href=/previews/

rm -rf "$BUILD_DIR/canvaskit"

rm -rf "$SOURCES_DIR"
mkdir -p "$SOURCES_DIR"

# Export package sources for docs code rendering (manifest sourcePath: packages/mix_docs_preview/lib/...)
mkdir -p "$SOURCES_DIR/packages/mix_docs_preview"
cp -R "$PREVIEWS_PKG_DIR/lib" "$SOURCES_DIR/packages/mix_docs_preview/"

# Run from package dir so tool finds lib/preview_registry.dart; output to build/web
dart run tool/generate_previews_manifest.dart --output "$PREVIEWS_MANIFEST"

if [ -f "$PREVIEW_CHECK_SCRIPT" ]; then
    if command -v node &> /dev/null; then
        node "$PREVIEW_CHECK_SCRIPT" "$BUILD_DIR"
    else
        echo "Warning: Node not found. Skipping preview manifest validation."
    fi
else
    echo "Warning: Preview check script not found at $PREVIEW_CHECK_SCRIPT"
fi

BOOTSTRAP_JS="$BUILD_DIR/flutter_bootstrap.js"
CONFIG_OUTPUT="$BUILD_DIR/flutter-build-config.json"

if [ -f "$BOOTSTRAP_JS" ]; then
    ENGINE_REVISION=$(grep -oE '"engineRevision":"[^"]+"' "$BOOTSTRAP_JS" | grep -oE '"[^"]+"$' | tr -d '"' | head -1)

    if [ -z "$ENGINE_REVISION" ]; then
        echo "Error: Could not extract engineRevision from flutter_bootstrap.js"
        exit 1
    fi

    cat > "$CONFIG_OUTPUT" << EOF
{
  "engineRevision": "$ENGINE_REVISION",
  "builds": [
    {
      "compileTarget": "dart2js",
      "renderer": "canvaskit",
      "mainJsPath": "main.dart.js"
    }
  ]
}
EOF
    echo "Generated flutter-build-config.json (engineRevision: $ENGINE_REVISION)"
else
    echo "Error: flutter_bootstrap.js not found in build output"
    exit 1
fi

BOOTSTRAP_FILE="$BUILD_DIR/flutter_bootstrap.js"
if [ -f "$BOOTSTRAP_FILE" ]; then
    if grep -q "_flutter\.loader\.load();" "$BOOTSTRAP_FILE"; then
        sed -i.bak 's/_flutter\.loader\.load();$/\/\/ Auto-load disabled for multi-view embedding/' "$BOOTSTRAP_FILE"
        rm -f "$BOOTSTRAP_FILE.bak"

        if grep -q "Auto-load disabled" "$BOOTSTRAP_FILE"; then
            echo "Patched flutter_bootstrap.js for multi-view embedding"
        else
            echo "Error: Bootstrap patch verification failed"
            exit 1
        fi
    else
        echo "Error: flutter_bootstrap.js structure changed - auto-load pattern not found"
        exit 1
    fi
else
    echo "Error: flutter_bootstrap.js not found in build output"
    exit 1
fi

echo ""
echo "Build complete! Output: $BUILD_DIR"
echo "Build size: $(du -sh "$BUILD_DIR" | cut -f1)"
echo "Source bundle size: $(du -sh "$SOURCES_DIR" | cut -f1)"

if [ "$LOCAL_ONLY" = false ]; then
    echo ""
    echo "Copying to website/public/previews/..."
    rm -rf "$WEBSITE_PREVIEWS_DIR"
    mkdir -p "$WEBSITE_PREVIEWS_DIR"
    cp -r "$BUILD_DIR"/* "$WEBSITE_PREVIEWS_DIR/"
    echo "Done! Previews ready at: $WEBSITE_PREVIEWS_DIR"
fi

echo ""
echo "To test locally:"
echo "  cd $PROJECT_DIR/website && pnpm dev"
echo "  Open http://localhost:3000/documentation/widgets/box"
