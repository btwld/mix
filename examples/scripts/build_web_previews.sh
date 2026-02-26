#!/bin/bash
# Build Mix examples for web embedding
#
# Usage:
#   ./scripts/build_web_previews.sh           # Build and copy to website
#   ./scripts/build_web_previews.sh --local   # Build only (no copy)
#
# Output:
#   - Build artifacts in examples/build/web/
#   - Copied to website/public/previews/ (unless --local)
#
# Note: The previews bundle folder is gitignored. Run this script:
#   - Locally before testing the website
#   - In CI/CD before deploying the website

# Exit immediately if any command fails (ensures build errors are not ignored)
set -e

# ============================================================================
# Directory Setup
# Derive all paths from the script's location to ensure consistent behavior
# regardless of where the script is invoked from.
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$(dirname "$SCRIPT_DIR")"       # examples/ directory
PROJECT_DIR="$(dirname "$EXAMPLES_DIR")"       # project root (mix/)
BUILD_DIR="$EXAMPLES_DIR/build/web"            # Flutter web build output
WEBSITE_PREVIEWS_DIR="$PROJECT_DIR/website/public/previews"  # Website public folder (served at /previews)
SOURCES_DIR="$BUILD_DIR/sources"               # Exported Dart sources for docs code view
PREVIEWS_MANIFEST="$BUILD_DIR/previews-manifest.json"  # Preview metadata for website
PREVIEW_CHECK_SCRIPT="$PROJECT_DIR/website/scripts/check-previews-manifest.mjs"

# Parse command line arguments
LOCAL_ONLY=false
if [ "$1" = "--local" ]; then
    LOCAL_ONLY=true
fi

# Change to examples directory for Flutter commands
cd "$EXAMPLES_DIR"

# Ensure Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter not found. Please install Flutter or run setup.sh"
    exit 1
fi

# Verify minimum Flutter version (3.38.1+ required for stable multi-view)
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

echo "Building Mix examples for web..."
echo "Flutter version: $(flutter --version | head -1)"

# ============================================================================
# Build Process
# ============================================================================

# Clean previous builds to ensure fresh output (prevents stale artifacts)
rm -rf "$BUILD_DIR"

# Build Flutter for web in release mode
# Uses CanvasKit renderer by default for best visual fidelity
# --pwa-strategy=none disables service worker generation to prevent 404 errors
# --base-href=/previews/ ensures all relative paths resolve correctly when served from /previews/
flutter build web --release --pwa-strategy=none --base-href=/previews/

# Remove canvaskit (loaded from Google CDN automatically)
# This reduces the build size from ~30MB to ~3MB
rm -rf "$BUILD_DIR/canvaskit"

# ============================================================================
# Export Dart source files for docs code rendering
# This enables reusable code snippets across docs pages by serving source files
# from /previews/sources/...
# ============================================================================
rm -rf "$SOURCES_DIR"
mkdir -p "$SOURCES_DIR"

# Export main examples sources
mkdir -p "$SOURCES_DIR/examples"
cp -R "$EXAMPLES_DIR/lib" "$SOURCES_DIR/examples/lib"

# Export package example sources (e.g., packages/*/example/lib)
PACKAGE_EXAMPLE_LIBS=$(find "$PROJECT_DIR/packages" -maxdepth 3 -type d -path "*/example/lib" 2>/dev/null || true)
if [ -n "$PACKAGE_EXAMPLE_LIBS" ]; then
    while IFS= read -r src_dir; do
        [ -z "$src_dir" ] && continue
        rel_path="${src_dir#$PROJECT_DIR/}"
        dest_path="$SOURCES_DIR/$rel_path"
        mkdir -p "$(dirname "$dest_path")"
        cp -R "$src_dir" "$dest_path"
    done <<< "$PACKAGE_EXAMPLE_LIBS"
fi

# Generate preview manifest from PreviewRegistry.
# This is the single source of truth used by website docs:
# previewId -> sourcePath/snippet metadata.
dart run tool/generate_previews_manifest.dart --output "$PREVIEWS_MANIFEST"

# Validate previewId -> sourcePath snippet resolution against build output.
if [ -f "$PREVIEW_CHECK_SCRIPT" ]; then
    if command -v node &> /dev/null; then
        node "$PREVIEW_CHECK_SCRIPT" "$BUILD_DIR"
    else
        echo "Warning: Node not found. Skipping preview manifest validation."
    fi
else
    echo "Warning: Preview check script not found at $PREVIEW_CHECK_SCRIPT"
fi

# ============================================================================
# Extract build config for runtime use
# This allows FlutterEmbed.tsx to load config dynamically instead of hard-coding
# the engineRevision, which would drift when Flutter is upgraded.
# ============================================================================
BOOTSTRAP_JS="$BUILD_DIR/flutter_bootstrap.js"
CONFIG_OUTPUT="$BUILD_DIR/flutter-build-config.json"

if [ -f "$BOOTSTRAP_JS" ]; then
    # Extract engineRevision from flutter_bootstrap.js
    # In Flutter 3.38+, the buildConfig JSON is in flutter_bootstrap.js:
    #   _flutter.buildConfig = {"engineRevision":"abc123...","builds":[...]};
    ENGINE_REVISION=$(grep -oE '"engineRevision":"[^"]+"' "$BOOTSTRAP_JS" | grep -oE '"[^"]+"$' | tr -d '"' | head -1)

    if [ -z "$ENGINE_REVISION" ]; then
        echo "Error: Could not extract engineRevision from flutter_bootstrap.js"
        exit 1
    fi

    # Generate config JSON for runtime loading
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

# ============================================================================
# Patch flutter_bootstrap.js for multi-view embedding
# The default build auto-calls _flutter.loader.load() which prevents us from
# configuring entrypointBaseUrl for proper path resolution when embedding.
# We remove the auto-load call so FlutterMultiView.tsx can call it with config.
# ============================================================================
BOOTSTRAP_FILE="$BUILD_DIR/flutter_bootstrap.js"
if [ -f "$BOOTSTRAP_FILE" ]; then
    # Check if auto-load exists before patching
    if grep -q "_flutter\.loader\.load();" "$BOOTSTRAP_FILE"; then
        # Remove the trailing _flutter.loader.load(); call
        # This allows FlutterMultiView to call load() with entrypointBaseUrl config
        sed -i.bak 's/_flutter\.loader\.load();$/\/\/ Auto-load disabled for multi-view embedding/' "$BOOTSTRAP_FILE"
        rm -f "$BOOTSTRAP_FILE.bak"

        # Verify patch succeeded
        if grep -q "Auto-load disabled" "$BOOTSTRAP_FILE"; then
            echo "Patched flutter_bootstrap.js for multi-view embedding"
        else
            echo "Error: Bootstrap patch verification failed"
            exit 1
        fi
    else
        echo "Error: flutter_bootstrap.js structure changed - auto-load pattern not found"
        echo "Multi-view embedding requires patching the auto-load call."
        echo "Check if Flutter changed the bootstrap output format."
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
