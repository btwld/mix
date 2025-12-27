#!/usr/bin/env sh
set -eu

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ----------------------------
# Config (override via env vars)
# ----------------------------
: "${FVM_INSTALL_DIR:=$HOME/fvm}"
: "${FVM_VERSION:=}"
: "${FORCE_FVM_REINSTALL:=0}"
: "${PERSIST_PATH:=0}"
: "${RUN_DOCTOR:=0}"
: "${SKIP_MELOS:=0}"
: "${SKIP_PUB_GET:=0}"
: "${FVM_INSTALL_ARGS:=}"

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
install_fvm() {
  if [ -x "$FVM_BIN_DIR/fvm" ] && [ "$FORCE_FVM_REINSTALL" != "1" ]; then
    return 0
  fi

  log "Installing FVM into: $FVM_INSTALL_DIR"
  if [ -n "$FVM_VERSION" ]; then
    FVM_INSTALL_DIR="$FVM_INSTALL_DIR" curl -fsSL https://fvm.app/install.sh | bash -s -- "$FVM_VERSION"
  else
    FVM_INSTALL_DIR="$FVM_INSTALL_DIR" curl -fsSL https://fvm.app/install.sh | bash
  fi
}

# ----------------------------
# PATH persistence
# ----------------------------
persist_path_line() {
  printf 'export PATH="%s:%s:$PATH"\n' "$FVM_BIN_DIR" "$PUB_CACHE_BIN"
}

persist_path_claude_if_available() {
  if [ -n "${CLAUDE_ENV_FILE:-}" ] && [ -w "${CLAUDE_ENV_FILE:-/dev/null}" ]; then
    line="$(persist_path_line)"
    if ! grep -Fqs "$line" "$CLAUDE_ENV_FILE"; then
      log "Persisting PATH via CLAUDE_ENV_FILE"
      printf '%s' "$line" >> "$CLAUDE_ENV_FILE"
    fi
    return 0
  fi
  return 1
}

persist_path_profile_if_enabled() {
  [ "$PERSIST_PATH" = "1" ] || return 0

  shell_name="$(basename "${SHELL:-sh}")"
  if [ "$shell_name" = "zsh" ]; then profile="$HOME/.zshrc"
  elif [ "$shell_name" = "bash" ]; then profile="$HOME/.bashrc"
  else profile="$HOME/.profile"
  fi

  marker="# >>> setup.sh fvm >>>"
  if [ -f "$profile" ] && grep -Fqs "$marker" "$profile"; then
    return 0
  fi

  log "Persisting PATH via: $profile"
  {
    printf '\n%s\n' "$marker"
    persist_path_line
    printf '%s\n' "# <<< setup.sh fvm <<<"
  } >> "$profile"
}

# ----------------------------
# Project config detection
# ----------------------------
has_fvm_project_config() {
  [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]
}

# ----------------------------
# Main
# ----------------------------
install_fvm

export PATH="$FVM_BIN_DIR:$PUB_CACHE_BIN:$PATH"
have fvm || die "fvm not found on PATH after install"

log "FVM: $(fvm --version)"

if has_fvm_project_config; then
  log "Running: fvm install ${FVM_INSTALL_ARGS}"
  # shellcheck disable=SC2086
  fvm install $FVM_INSTALL_ARGS
else
  log "No .fvmrc found; skipping 'fvm install'"
fi

persist_path_claude_if_available || persist_path_profile_if_enabled

log "Flutter: $(fvm flutter --version | head -1)"

if [ "$RUN_DOCTOR" = "1" ]; then
  fvm flutter doctor -v || true
fi

# Melos bootstrap for monorepos
if [ "$SKIP_MELOS" != "1" ] && [ -f "melos.yaml" ]; then
  log "Installing melos and bootstrapping..."
  fvm dart pub global activate melos >/dev/null
  fvm dart pub global run melos bootstrap
elif [ "$SKIP_PUB_GET" != "1" ] && [ -f "pubspec.yaml" ]; then
  log "Running: fvm flutter pub get"
  fvm flutter pub get
fi

log "Setup complete."
