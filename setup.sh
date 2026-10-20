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

is_remote_env() {
  [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] ||
    [ "${CURSOR_CLOUD_ENV:-}" = "true" ] ||
    [ -n "${CURSOR_AGENT:-}" ] ||
    [ "${CODESPACES:-}" = "true" ] ||
    [ "${REMOTE_CONTAINERS:-}" = "true" ] ||
    [ -n "${CODEX_ENV_PYTHON_VERSION:-}" ] ||
    [ "${CI:-}" = "true" ] ||
    [ "${REMOTE_ENV:-}" = "true" ] ||
    [ -f /.dockerenv ] ||
    [ -f /run/.containerenv ]
}

# ----------------------------
# Environment check
# ----------------------------
if ! is_remote_env; then
  die "This setup script is intended for remote/cloud agent environments only.
       Set REMOTE_ENV=true (or CLAUDE_CODE_REMOTE=true) to override, or use standard Flutter/FVM installation."
fi

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$REPO_ROOT"

# ----------------------------
# Config
# ----------------------------
FVM_VERSION="${FVM_VERSION:-4.3.2}"
FVM_INSTALL_DIR="${FVM_INSTALL_DIR:-$HOME/fvm}"
FVM_BIN_DIR="$FVM_INSTALL_DIR/bin"
export FVM_CACHE_PATH="${FVM_CACHE_PATH:-$FVM_INSTALL_DIR}"
export FVM_USE_GIT_CACHE="${FVM_USE_GIT_CACHE:-false}"
PUB_CACHE_BIN="${PUB_CACHE:-$HOME/.pub-cache}/bin"
SYMLINK_DIR="/usr/local/bin"

# ----------------------------
# Requirements
# ----------------------------
if [ "$(uname -s)" = "Linux" ] && have apt-get; then
  MISSING_PKGS=""
  have curl  || MISSING_PKGS="$MISSING_PKGS curl ca-certificates"
  have tar   || MISSING_PKGS="$MISSING_PKGS tar"
  have git   || MISSING_PKGS="$MISSING_PKGS git"
  have unzip || MISSING_PKGS="$MISSING_PKGS unzip"
  have xz    || MISSING_PKGS="$MISSING_PKGS xz-utils"
  have zip   || MISSING_PKGS="$MISSING_PKGS zip"
  have bash  || MISSING_PKGS="$MISSING_PKGS bash"
  if [ -n "$MISSING_PKGS" ]; then
    log "Installing missing system packages:$MISSING_PKGS"
    # shellcheck disable=SC2086
    as_root apt-get update && as_root apt-get install -y --no-install-recommends $MISSING_PKGS
  fi
fi

have curl  || die "curl is required"
have tar   || die "tar is required"
have git   || die "git is required"
have unzip || die "unzip is required"
have xz    || die "xz (xz-utils) is required"
have zip   || die "zip is required"
have bash  || die "bash is required for the FVM install script"

git config --global --get-all safe.directory 2>/dev/null | grep -qx '\*' ||
  git config --global --add safe.directory '*' 2>/dev/null || true

# ----------------------------
# Install FVM
# ----------------------------
if [ ! -x "$FVM_BIN_DIR/fvm" ]; then
  log "Installing FVM ${FVM_VERSION}..."
  curl -fsSL https://fvm.app/install.sh | bash -s "$FVM_VERSION"
fi

if [ -x "$FVM_BIN_DIR/fvm" ]; then
  as_root ln -sf "$FVM_BIN_DIR/fvm" "$SYMLINK_DIR/fvm"
  log "Created symlink: $SYMLINK_DIR/fvm"
fi

export PATH="$FVM_BIN_DIR:$FVM_CACHE_PATH/default/bin:$PUB_CACHE_BIN:$SYMLINK_DIR:$PATH"
have fvm || die "fvm not found on PATH after install"

fvm config --no-use-git-cache --no-update-check >/dev/null 2>&1 || true
log "FVM: $(fvm --version)"

# ----------------------------
# Install Flutter via FVM
# ----------------------------
if [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]; then
  log "Installing Flutter SDK..."
  fvm install --skip-pub-get --fvm-skip-input
else
  log "No .fvmrc found; skipping Flutter install"
fi

if [ -d ".fvm/flutter_sdk/bin" ]; then
  SDK_VERSION="$(basename "$(cd .fvm/flutter_sdk && pwd -P)")"
  fvm global "$SDK_VERSION" --fvm-skip-input >/dev/null 2>&1 || true
  DEFAULT_SDK_BIN="$FVM_CACHE_PATH/default/bin"
  if [ ! -d "$DEFAULT_SDK_BIN" ]; then
    DEFAULT_SDK_BIN="$(cd .fvm/flutter_sdk/bin && pwd -P)"
  fi

  for cmd in flutter dart; do
    if [ -x "$DEFAULT_SDK_BIN/$cmd" ]; then
      as_root ln -sf "$DEFAULT_SDK_BIN/$cmd" "$SYMLINK_DIR/$cmd"
      log "Created symlink: $SYMLINK_DIR/$cmd -> $DEFAULT_SDK_BIN/$cmd"
    fi
  done
fi

flutter config --no-analytics >/dev/null 2>&1 || true
dart --disable-analytics >/dev/null 2>&1 || true
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
  MELOS_VERSION="${MELOS_VERSION:-$(sed -n 's/^[[:space:]]*melos:[[:space:]]*\^*\([0-9][0-9A-Za-z.+_-]*\).*/\1/p' pubspec.yaml 2>/dev/null | head -n 1)}"
  log "Installing melos ${MELOS_VERSION:-latest} and bootstrapping..."
  if [ -n "$MELOS_VERSION" ]; then
    dart pub global activate melos "$MELOS_VERSION" >/dev/null
  else
    dart pub global activate melos >/dev/null
  fi
  if [ -x "$PUB_CACHE_BIN/melos" ]; then
    as_root ln -sf "$PUB_CACHE_BIN/melos" "$SYMLINK_DIR/melos"
    log "Created symlink: $SYMLINK_DIR/melos"
  fi
  melos bootstrap
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
