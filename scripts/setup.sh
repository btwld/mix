#!/bin/bash
# Setup script for Mix monorepo
# Handles FVM, Melos, and workspace initialization
# Compatible with both local and Claude Code remote environments

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error

# ANSI color codes for better output readability
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
  exit 1
}

log_step() {
  echo ""
  echo -e "${BLUE}▶${NC} ${GREEN}$1${NC}"
  echo "─────────────────────────────────────────────────"
}

# Detect environment
detect_environment() {
  if [ "${CLAUDE_CODE_REMOTE:-false}" = "true" ]; then
    log_info "Environment: Claude Code Remote"
    export IS_REMOTE=true
  else
    log_info "Environment: Local"
    export IS_REMOTE=false
  fi
}

# Verify Claude Code memory setup
verify_claude_memory() {
  log_step "Verifying Claude Code memory"

  if [ ! -f "AGENTS.md" ]; then
    log_warning "AGENTS.md not found"
    return 0
  fi

  if [ ! -f "CLAUDE.md" ]; then
    log_warning "CLAUDE.md not found"
    return 0
  fi

  log_success "AGENTS.md found"
  log_success "CLAUDE.md found (imports AGENTS.md)"
}

# Ensure pub-cache bin is in PATH
setup_path() {
  log_step "Setting up environment PATH"

  export PATH="$HOME/.pub-cache/bin:$PATH"

  # For FVM, also ensure the default Flutter is accessible
  if [ -d "$HOME/.fvm/default/bin" ]; then
    export PATH="$HOME/.fvm/default/bin:$PATH"
  fi

  log_success "PATH configured"
}

# Check and install FVM
setup_fvm() {
  log_step "Setting up FVM (Flutter Version Management)"

  if command -v fvm &> /dev/null; then
    log_success "FVM already installed at $(which fvm)"
    fvm --version
  else
    log_info "Installing FVM via dart pub global activate..."
    dart pub global activate fvm
    log_success "FVM installed"
  fi
}

# Install Flutter using FVM based on .fvmrc configuration
setup_flutter() {
  log_step "Installing Flutter via FVM"

  if [ ! -f ".fvmrc" ]; then
    log_error "No .fvmrc file found. Cannot determine Flutter version."
  fi

  log_info "Reading FVM configuration from .fvmrc..."
  cat .fvmrc

  log_info "Installing Flutter version specified in .fvmrc..."
  fvm install

  log_info "Setting Flutter version for this project..."
  fvm use --force

  # Verify Flutter installation
  log_info "Verifying Flutter installation..."
  fvm flutter --version

  log_success "Flutter ready via FVM"
}

# Install Melos
setup_melos() {
  log_step "Setting up Melos (Workspace Manager)"

  if command -v melos &> /dev/null; then
    log_success "Melos already installed at $(which melos)"
    melos --version
  else
    log_info "Installing Melos via dart pub global activate..."
    dart pub global activate melos
    log_success "Melos installed"
  fi
}

# Install DCM (Dart Code Metrics)
setup_dcm() {
  log_step "Setting up DCM (Dart Code Metrics)"

  if command -v dcm &> /dev/null; then
    log_success "DCM already installed at $(which dcm)"
    dcm --version
  else
    log_info "Installing DCM via dart pub global activate..."
    dart pub global activate dart_code_metrics
    log_success "DCM installed"
  fi
}

# Bootstrap all packages in the workspace
bootstrap_workspace() {
  log_step "Bootstrapping Mix workspace with Melos"

  log_info "Running melos bootstrap..."
  log_info "This will fetch dependencies for all packages in the monorepo"

  melos bootstrap --verbose

  log_success "Workspace bootstrapped successfully"
}

# Generate code for all packages
generate_code() {
  log_step "Generating code with build_runner"

  log_info "Running melos run gen:build..."
  log_info "This will generate code for all packages that depend on build_runner"

  melos run gen:build

  log_success "Code generation complete"
}

# Verify the setup
verify_setup() {
  log_step "Verifying setup"

  log_info "Checking workspace packages..."
  melos list

  log_info "Checking Flutter doctor..."
  fvm flutter doctor -v

  log_success "Setup verified successfully"
}

# Main setup flow
main() {
  echo ""
  echo "════════════════════════════════════════════════"
  echo "  Mix Monorepo Setup"
  echo "════════════════════════════════════════════════"
  echo ""

  detect_environment
  verify_claude_memory
  setup_path
  setup_fvm
  setup_flutter
  setup_melos
  setup_dcm
  bootstrap_workspace
  generate_code
  verify_setup

  echo ""
  echo "════════════════════════════════════════════════"
  echo -e "  ${GREEN}✓ Setup Complete!${NC}"
  echo "════════════════════════════════════════════════"
  echo ""
  echo "Available Melos commands:"
  echo "  • melos run analyze      - Run static analysis"
  echo "  • melos run test:flutter - Run Flutter tests"
  echo "  • melos run test:dart    - Run Dart tests"
  echo "  • melos run gen:build    - Regenerate code"
  echo "  • melos run fix          - Apply lint fixes"
  echo ""
  echo "Ready to build with Mix! 🎨"
  echo ""
}

# Run main function
main

exit 0
