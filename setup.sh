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

log "Setup complete."
