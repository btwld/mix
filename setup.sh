#!/usr/bin/env sh
set -eu

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ----------------------------
# Config
# ----------------------------
FVM_INSTALL_DIR="${FVM_INSTALL_DIR:-$HOME/fvm}"
FVM_BIN_DIR="$FVM_INSTALL_DIR/bin"
PUB_CACHE_BIN="$HOME/.pub-cache/bin"

# ----------------------------
# Requirements
# ----------------------------
have curl || die "curl is required"
have tar  || die "tar is required"
have bash || die "bash is required for the FVM install script"

# ----------------------------
# Install FVM
# ----------------------------
if [ ! -x "$FVM_BIN_DIR/fvm" ]; then
  log "Installing FVM..."
  curl -fsSL https://fvm.app/install.sh | bash
fi

export PATH="$FVM_BIN_DIR:$PUB_CACHE_BIN:$PATH"
have fvm || die "fvm not found on PATH after install"

log "FVM: $(fvm --version)"

# ----------------------------
# Install Flutter via FVM
# ----------------------------
if [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]; then
  log "Installing Flutter SDK..."
  fvm install
else
  log "No .fvmrc found; skipping Flutter install"
fi

log "Flutter: $(fvm flutter --version | head -1)"

# ----------------------------
# Install DCM (Dart Code Metrics)
# ----------------------------
DCM_VERSION="${DCM_VERSION:-1.31.4}"

if ! have dcm; then
  log "Installing DCM ${DCM_VERSION}..."
  case "$(uname -s)" in
    Linux)
      ARCH=$(uname -m)
      case "$ARCH" in
        x86_64)  DEB_ARCH="amd64" ;;
        aarch64) DEB_ARCH="arm64" ;;
        *)       die "Unsupported architecture: $ARCH" ;;
      esac
      DEB_FILE="dcm_${DCM_VERSION}-1_${DEB_ARCH}.deb"
      DEB_URL="https://github.com/CQLabs/homebrew-dcm/releases/download/${DCM_VERSION}/${DEB_FILE}"
      curl -fsSL -o "/tmp/${DEB_FILE}" "$DEB_URL"
      dpkg -i "/tmp/${DEB_FILE}" || die "Failed to install DCM"
      rm -f "/tmp/${DEB_FILE}"
      ;;
    Darwin)
      if have brew; then
        brew tap CQLabs/dcm
        brew install dcm
      else
        die "Homebrew is required to install DCM on macOS"
      fi
      ;;
    *)
      die "Unsupported OS: $(uname -s)"
      ;;
  esac
fi

have dcm && log "DCM: $(dcm --version)"

# Activate DCM if license key is provided
if have dcm && [ -n "${DCM_LICENSE_KEY:-}" ]; then
  log "Activating DCM..."
  dcm activate --license-key="$DCM_LICENSE_KEY"
elif have dcm; then
  log "Note: DCM installed but not activated. Set DCM_LICENSE_KEY to activate."
  log "      For OSS projects, request a free license at https://dcm.dev/pricing/"
fi

# ----------------------------
# Melos bootstrap
# ----------------------------
if [ -f "melos.yaml" ]; then
  log "Installing melos and bootstrapping..."
  fvm dart pub global activate melos >/dev/null
  fvm dart pub global run melos bootstrap
elif [ -f "pubspec.yaml" ]; then
  log "Running: fvm flutter pub get"
  fvm flutter pub get
fi

# ----------------------------
# Setup PATH for direct command access
# ----------------------------
if [ -d ".fvm/flutter_sdk/bin" ]; then
  FLUTTER_SDK_BIN="$(cd .fvm/flutter_sdk/bin && pwd)"
  export PATH="$FLUTTER_SDK_BIN:$PATH"

  # Add to shell profiles for persistence
  PATH_EXPORT="export PATH=\"$FLUTTER_SDK_BIN:\$PATH\""

  for profile in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$profile" ]; then
      if ! grep -q "$FLUTTER_SDK_BIN" "$profile" 2>/dev/null; then
        log "Adding Flutter to PATH in $profile"
        printf '\n# Flutter SDK (added by mix setup)\n%s\n' "$PATH_EXPORT" >> "$profile"
      fi
    fi
  done
fi

log ""
log "Setup complete. Flutter, Dart, and pub-cache are now available."
log ""
log "Run 'source ~/.bashrc' (or ~/.zshrc) or restart your shell to use:"
log "  flutter --version"
log "  dart --version"
log "  melos --version"
