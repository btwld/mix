#!/usr/bin/env sh
set -eu

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

# ----------------------------
# Config (override via env vars)
# ----------------------------
: "${FVM_INSTALL_DIR:=$HOME/fvm}"         # default per docs  [oai_citation:5‡FVM](https://fvm.app/documentation/getting-started/installation)
: "${FVM_VERSION:=}"                      # optional: install specific FVM version
: "${FORCE_FVM_REINSTALL:=0}"             # 1 = reinstall fvm even if present
: "${PERSIST_PATH:=0}"                    # 1 = write PATH to shell profile (non-Claude)
: "${RUN_DOCTOR:=0}"                      # 1 = fvm flutter doctor -v
: "${SKIP_MELOS:=0}"                      # 1 = skip melos even if melos.yaml exists
: "${SKIP_PUB_GET:=0}"                    # 1 = skip pub get when no melos.yaml
: "${FVM_INSTALL_ARGS:=}"                 # optional extra args for `fvm install` (e.g. --no-setup)

FVM_BIN_DIR="$FVM_INSTALL_DIR/bin"
PUB_CACHE_BIN="$HOME/.pub-cache/bin"

# ----------------------------
# Requirements
# FVM install script requires curl + tar on macOS/Linux  [oai_citation:6‡FVM](https://fvm.app/documentation/getting-started/installation)
# ----------------------------
have curl || die "curl is required"
have tar  || die "tar is required"
have bash || die "bash is required to run the FVM install script (docs use: curl ... | bash)  [oai_citation:7‡FVM](https://fvm.app/documentation/getting-started/installation)"

# ----------------------------
# Install FVM (official install.sh)
# Latest: curl -fsSL https://fvm.app/install.sh | bash  [oai_citation:8‡FVM](https://fvm.app/documentation/getting-started/installation)
# Custom location supported via FVM_INSTALL_DIR env var  [oai_citation:9‡FVM](https://fvm.app/documentation/getting-started/installation)
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
# PATH (current session + optional persistence)
# Install docs: export PATH="<install_dir>/bin:$PATH"  [oai_citation:10‡FVM](https://fvm.app/documentation/getting-started/installation?utm_source=chatgpt.com)
# ----------------------------
persist_path_line() {
  # Keep it simple: fvm + pub-cache
  printf 'export PATH="%s:%s:$PATH"\n' "$FVM_BIN_DIR" "$PUB_CACHE_BIN"
}

persist_path_claude_if_available() {
  if [ -n "${CLAUDE_ENV_FILE:-}" ] && [ -w "${CLAUDE_ENV_FILE:-/dev/null}" ]; then
    line="$(persist_path_line)"
    if ! grep -Fqs "$line" "$CLAUDE_ENV_FILE"; then
      log "Persisting PATH via CLAUDE_ENV_FILE: $CLAUDE_ENV_FILE"
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

  log "Persisting PATH via profile: $profile"
  {
    printf '\n%s\n' "$marker"
    persist_path_line
    printf '%s\n' "# <<< setup.sh fvm <<<"
  } >> "$profile"
}

# ----------------------------
# Project config detection
# FVM uses .fvmrc as primary project config  [oai_citation:11‡FVM](https://fvm.app/documentation/getting-started/configuration)
# Legacy .fvm/fvm_config.json exists for backward compatibility  [oai_citation:12‡FVM](https://fvm.app/documentation/getting-started/configuration)
# ----------------------------
has_fvm_project_config() {
  [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]
}

# ----------------------------
# Main
# ----------------------------
install_fvm

export PATH="$FVM_BIN_DIR:$PUB_CACHE_BIN:$PATH"
have fvm || die "fvm not found on PATH after install (expected in $FVM_BIN_DIR)  [oai_citation:13‡FVM](https://fvm.app/documentation/getting-started/installation?utm_source=chatgpt.com)"

log "FVM:"
fvm --version || true

# Ensure the repo's configured Flutter SDK is downloaded.
# `fvm install` with no version installs from project configuration  [oai_citation:14‡FVM](https://fvm.app/documentation/guides/basic-commands?utm_source=chatgpt.com)
if has_fvm_project_config; then
  log "Running: fvm install ${FVM_INSTALL_ARGS}"
  # shellcheck disable=SC2086
  fvm install $FVM_INSTALL_ARGS
else
  log "No .fvmrc (or legacy .fvm/fvm_config.json) found; skipping 'fvm install'."
  log "FVM resolution order is: project .fvmrc → ancestor .fvmrc → global → system PATH  [oai_citation:15‡FVM](https://fvm.app/documentation/getting-started/faq?utm_source=chatgpt.com)"
fi

# Persist PATH if the environment supports it, otherwise only if requested.
persist_path_claude_if_available || persist_path_profile_if_enabled

log "Flutter (via FVM):"
fvm flutter --version

if [ "$RUN_DOCTOR" = "1" ]; then
  fvm flutter doctor -v || true
fi

# Optional monorepo bootstrapping:
# Melos install: dart pub global activate melos  [oai_citation:16‡Melos](https://melos.invertase.dev/getting-started?utm_source=chatgpt.com)
if [ "$SKIP_MELOS" != "1" ] && [ -f "melos.yaml" ]; then
  log "melos.yaml detected; installing melos and bootstrapping..."
  fvm dart pub global activate melos >/dev/null
  export PATH="$PUB_CACHE_BIN:$PATH"
  # Run melos via fvm exec to ensure correct dart is used
  fvm exec melos bootstrap
else
  if [ "$SKIP_PUB_GET" != "1" ] && [ -f "pubspec.yaml" ]; then
    log "Running: fvm flutter pub get"
    fvm flutter pub get
  fi
fi

log "Setup complete."
