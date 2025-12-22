#!/bin/bash
#
# Mix Development Environment Setup Script
# =========================================
# This script installs all dependencies required to run the Mix project workflows
# including DCM, dart analyze, Melos, and other development tools.
#
# Usage:
#   ./scripts/setup.sh [options]
#
# Options:
#   --skip-fvm         Skip FVM installation (use if FVM is already installed)
#   --skip-flutter     Skip Flutter SDK setup via FVM
#   --skip-dcm         Skip DCM installation
#   --flavor <name>    Use a specific FVM flavor (default: uses .fvmrc default)
#   --ci               Run in CI mode (non-interactive, minimal output)
#   --help             Show this help message
#
# Examples:
#   ./scripts/setup.sh                    # Full setup
#   ./scripts/setup.sh --skip-fvm         # Skip FVM (already installed)
#   ./scripts/setup.sh --flavor mincompat # Use mincompat Flutter version
#   ./scripts/setup.sh --ci               # CI mode for GitHub Actions
#

set -e

# Colors for output (disabled in CI mode)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration defaults
SKIP_FVM=false
SKIP_FLUTTER=false
SKIP_DCM=false
FVM_FLAVOR=""
CI_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-fvm)
            SKIP_FVM=true
            shift
            ;;
        --skip-flutter)
            SKIP_FLUTTER=true
            shift
            ;;
        --skip-dcm)
            SKIP_DCM=true
            shift
            ;;
        --flavor)
            FVM_FLAVOR="$2"
            shift 2
            ;;
        --ci)
            CI_MODE=true
            shift
            ;;
        --help)
            sed -n '2,24p' "$0" | sed 's/^# \?//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Disable colors in CI mode
if [ "$CI_MODE" = true ]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Helper functions
log_step() {
    echo -e "${BLUE}==>${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Helper to add path to PATH (and GITHUB_PATH for CI)
add_to_path() {
    local new_path="$1"
    if [[ ":$PATH:" != *":$new_path:"* ]]; then
        export PATH="$new_path:$PATH"
    fi
    # For GitHub Actions, persist PATH to subsequent steps
    if [ -n "$GITHUB_PATH" ] && [ -f "$GITHUB_PATH" ]; then
        echo "$new_path" >> "$GITHUB_PATH"
    fi
}

# Detect script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo ""
echo "=========================================="
echo "   Mix Development Environment Setup"
echo "=========================================="
echo ""
echo "Project root: $PROJECT_ROOT"
echo ""

cd "$PROJECT_ROOT"

# ============================================
# Step 1: Install FVM (Flutter Version Manager)
# ============================================
if [ "$SKIP_FVM" = false ]; then
    log_step "Installing FVM (Flutter Version Manager)..."

    if check_command fvm; then
        log_success "FVM is already installed: $(fvm --version 2>/dev/null || echo 'version unknown')"
    else
        curl -fsSL https://fvm.app/install.sh | bash

        # Add FVM to PATH for this session and CI
        add_to_path "$HOME/.pub-cache/bin"
        add_to_path "$HOME/fvm/default/bin"

        if check_command fvm; then
            log_success "FVM installed successfully"
        else
            log_error "FVM installation failed"
            exit 1
        fi
    fi
else
    log_warning "Skipping FVM installation (--skip-fvm)"
fi

# Always ensure pub-cache is in PATH
add_to_path "$HOME/.pub-cache/bin"

# ============================================
# Step 2: Setup Flutter SDK via FVM
# ============================================
if [ "$SKIP_FLUTTER" = false ]; then
    log_step "Setting up Flutter SDK via FVM..."

    if [ -f ".fvmrc" ]; then
        if [ -n "$FVM_FLAVOR" ]; then
            log_step "Using FVM flavor: $FVM_FLAVOR"
            fvm use "$FVM_FLAVOR" --force
        else
            # Use the default version from .fvmrc
            FLUTTER_VERSION=$(grep -o '"flutter": "[^"]*"' .fvmrc | cut -d'"' -f4)
            log_step "Using Flutter version from .fvmrc: $FLUTTER_VERSION"
            fvm use --force
        fi

        # Add FVM Flutter SDK to PATH so flutter/dart commands work directly
        add_to_path "$PROJECT_ROOT/.fvm/flutter_sdk/bin"

        # Verify Flutter is available via FVM
        if fvm flutter --version &> /dev/null; then
            log_success "Flutter SDK configured via FVM"
            fvm flutter --version | head -1
        else
            log_error "Flutter SDK setup failed"
            exit 1
        fi
    else
        log_error ".fvmrc file not found in project root"
        exit 1
    fi
else
    log_warning "Skipping Flutter setup (--skip-flutter)"
fi

# ============================================
# Step 3: Install Melos
# ============================================
log_step "Installing Melos..."

if check_command melos; then
    MELOS_VERSION=$(melos --version 2>/dev/null || echo 'unknown')
    log_success "Melos is already installed: $MELOS_VERSION"
else
    dart pub global activate melos

    if check_command melos; then
        log_success "Melos installed successfully: $(melos --version)"
    else
        log_error "Melos installation failed"
        exit 1
    fi
fi

# ============================================
# Step 4: Install DCM (Dart Code Metrics)
# ============================================
if [ "$SKIP_DCM" = false ]; then
    log_step "Installing DCM (Dart Code Metrics)..."

    if check_command dcm; then
        log_success "DCM is already installed"
    else
        dart pub global activate dart_code_metrics

        if check_command dcm; then
            log_success "DCM installed successfully"
        else
            log_warning "DCM installation may require manual PATH configuration"
        fi
    fi
else
    log_warning "Skipping DCM installation (--skip-dcm)"
fi

# ============================================
# Step 5: Bootstrap dependencies with Melos
# ============================================
log_step "Bootstrapping project dependencies with Melos..."

melos bootstrap

log_success "Dependencies bootstrapped successfully"

# ============================================
# Step 6: Verify installation
# ============================================
echo ""
echo "=========================================="
echo "   Installation Summary"
echo "=========================================="
echo ""

# Check all tools
echo "Installed tools:"
echo ""

if check_command fvm; then
    echo -e "  ${GREEN}✓${NC} FVM:     $(fvm --version 2>/dev/null || echo 'installed')"
else
    echo -e "  ${RED}✗${NC} FVM:     not found"
fi

if check_command flutter || fvm flutter --version &> /dev/null; then
    FLUTTER_VER=$(fvm flutter --version 2>/dev/null | head -1 || flutter --version 2>/dev/null | head -1 || echo 'installed')
    echo -e "  ${GREEN}✓${NC} Flutter: $FLUTTER_VER"
else
    echo -e "  ${RED}✗${NC} Flutter: not found"
fi

if check_command dart || fvm dart --version &> /dev/null; then
    DART_VER=$(fvm dart --version 2>&1 | head -1 || dart --version 2>&1 | head -1 || echo 'installed')
    echo -e "  ${GREEN}✓${NC} Dart:    $DART_VER"
else
    echo -e "  ${RED}✗${NC} Dart:    not found"
fi

if check_command melos; then
    echo -e "  ${GREEN}✓${NC} Melos:   $(melos --version 2>/dev/null || echo 'installed')"
else
    echo -e "  ${RED}✗${NC} Melos:   not found"
fi

if [ "$SKIP_DCM" = false ]; then
    if check_command dcm; then
        echo -e "  ${GREEN}✓${NC} DCM:     installed"
    else
        echo -e "  ${YELLOW}⚠${NC} DCM:     not in PATH (may still work via pub)"
    fi
fi

echo ""
echo "=========================================="
echo "   Available Melos Commands"
echo "=========================================="
echo ""
echo "  melos run analyze        - Run all static analysis (dart + DCM)"
echo "  melos run analyze:dart   - Run Dart static analysis only"
echo "  melos run analyze:dcm    - Run DCM static analysis only"
echo "  melos run lint:fix:all   - Auto-fix all linting issues"
echo "  melos run test:flutter   - Run Flutter tests"
echo "  melos run test:dart      - Run Dart tests"
echo "  melos run gen:build      - Generate code (build_runner)"
echo "  melos run ci             - Run full CI pipeline"
echo ""
echo "For full list of commands, run: melos run"
echo ""
log_success "Setup complete! You're ready to develop."
echo ""
