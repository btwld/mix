#!/usr/bin/env sh
set -eu

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif have sudo; then
    sudo -n "$@"
  else
    die "Root privileges (or passwordless sudo) required for: $*"
  fi
}

ensure_symlink() {
  if [ "$(readlink "$2" 2>/dev/null || true)" != "$1" ]; then
    as_root ln -sf "$1" "$2"
    log "Created symlink: $2 -> $1"
  fi
}

is_remote_env() {
  [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || [ "${REMOTE_ENV:-}" = "true" ]
}

# ----------------------------
# Environment check
# ----------------------------
if ! is_remote_env; then
  die "This setup script is intended for remote/cloud agent environments only.
       Set REMOTE_ENV=true (or CLAUDE_CODE_REMOTE=true) to override, or use standard Flutter/FVM installation."
fi

REPO_ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
cd "$REPO_ROOT"

# ----------------------------
# Config
# ----------------------------
FVM_VERSION="${FVM_VERSION:-4.3.2}"
FVM_INSTALL_DIR="${FVM_INSTALL_DIR:-$HOME/fvm}"
FVM_BIN_DIR="$FVM_INSTALL_DIR/bin"
PUB_CACHE_BIN="${PUB_CACHE:-$HOME/.pub-cache}/bin"
SYMLINK_DIR="/usr/local/bin"

# ----------------------------
# Requirements
# ----------------------------
have curl  || die "curl is required"
have tar   || die "tar is required"
have git   || die "git is required"
have unzip || die "unzip is required"
have xz    || die "xz (xz-utils) is required"
have zip   || die "zip is required"
have bash  || die "bash is required for the FVM install script"

if ! git config --global --get-all safe.directory 2>/dev/null | grep -qx '\*'; then
  git config --global --add safe.directory '*'
fi

# ----------------------------
# Install FVM
# ----------------------------
CURRENT_FVM_VERSION=""
if [ -x "$FVM_BIN_DIR/fvm" ]; then
  CURRENT_FVM_VERSION="$("$FVM_BIN_DIR/fvm" --version 2>/dev/null || true)"
fi

if [ "$CURRENT_FVM_VERSION" != "$FVM_VERSION" ]; then
  log "Installing FVM ${FVM_VERSION}..."
  curl -fsSL https://fvm.app/install.sh | bash -s "$FVM_VERSION"
fi

export PATH="$FVM_BIN_DIR:$FVM_INSTALL_DIR/default/bin:$PUB_CACHE_BIN:$PATH"
have fvm || die "fvm not found on PATH after install"

fvm config --no-use-git-cache --no-update-check
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

if [ -d ".fvm/flutter_sdk/bin" ]; then
  FLUTTER_SDK_DIR="$(cd .fvm/flutter_sdk && pwd -P)"
  VERSIONS_DIR="$(cd "$FVM_INSTALL_DIR/versions" && pwd -P)"
  SDK_VERSION="${FLUTTER_SDK_DIR#"$VERSIONS_DIR"/}"
  fvm global "$SDK_VERSION"

  DEFAULT_SDK_BIN="$FVM_INSTALL_DIR/default/bin"
  for cmd in flutter dart; do
    if [ -x "$DEFAULT_SDK_BIN/$cmd" ]; then
      ensure_symlink "$DEFAULT_SDK_BIN/$cmd" "$SYMLINK_DIR/$cmd"
    fi
  done
fi

if [ -x "$FVM_BIN_DIR/fvm" ]; then
  ensure_symlink "$FVM_BIN_DIR/fvm" "$SYMLINK_DIR/fvm"
fi

flutter config --no-analytics >/dev/null
dart --disable-analytics >/dev/null
log "Flutter: $(flutter --version | head -n 1)"

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
      as_root dpkg -i "/tmp/${DEB_FILE}" || die "Failed to install DCM"
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
  MELOS_VERSION="$(dart run melos --version | head -n 1)"
  CURRENT_MELOS_VERSION=""
  if [ -x "$PUB_CACHE_BIN/melos" ]; then
    CURRENT_MELOS_VERSION="$("$PUB_CACHE_BIN/melos" --version 2>/dev/null | head -n 1 || true)"
  fi
  if [ "$CURRENT_MELOS_VERSION" != "$MELOS_VERSION" ]; then
    log "Installing melos ${MELOS_VERSION}..."
    dart pub global activate melos "$MELOS_VERSION" >/dev/null
  fi
  if [ -x "$PUB_CACHE_BIN/melos" ]; then
    ensure_symlink "$PUB_CACHE_BIN/melos" "$SYMLINK_DIR/melos"
  fi
  dart run melos bootstrap
elif [ -f "pubspec.yaml" ]; then
  log "Running: flutter pub get"
  flutter pub get
fi

log ""
log "Setup complete. Commands are available globally:"
log "  flutter --version"
log "  dart --version"
log "  fvm --version"
log "  melos --version"
