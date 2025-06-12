#!/bin/bash
set -e

# Update system packages
sudo apt-get update

# Install required system dependencies
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install FVM (Flutter Version Management)
curl -fsSL https://fvm.app/install.sh | bash

# Source the profile to get FVM in PATH
source $HOME/.profile || true

# Add FVM to PATH for current session
export PATH="$HOME/.pub-cache/bin:$PATH"

# Install Flutter version from .fvmrc (this also runs 'fvm use' and creates symlink)
fvm install

# Verify the correct version is installed
if [ -f ".fvmrc" ] && [ -f ".fvm/version" ]; then
    EXPECTED_VERSION=$(grep -o '"flutter": *"[^"]*"' .fvmrc | sed 's/"flutter": *"//;s/"$//')
    INSTALLED_VERSION=$(cat .fvm/version)
    
    if [ "$EXPECTED_VERSION" != "$INSTALLED_VERSION" ]; then
        echo "Warning: Version mismatch!"
        echo "Expected version from .fvmrc: $EXPECTED_VERSION"
        echo "Installed version in .fvm/version: $INSTALLED_VERSION"
        echo "Running 'fvm use' to correct this..."
        fvm use --force
    else
        echo "✓ Flutter version $INSTALLED_VERSION correctly installed"
    fi
else
    echo "Warning: Could not verify Flutter version installation"
fi

# Set up PATH to use the project's Flutter SDK symlink
PROJECT_FLUTTER_PATH="$(pwd)/.fvm/flutter_sdk"

# Verify the symlink exists
if [ ! -L "$PROJECT_FLUTTER_PATH" ]; then
    echo "Error: Flutter SDK symlink not found at $PROJECT_FLUTTER_PATH"
    echo "Running 'fvm use' to create it..."
    fvm use --force
fi

export PATH="$PROJECT_FLUTTER_PATH/bin:$PATH"

# Add project Flutter to PATH for current session
export FLUTTER_ROOT="$PROJECT_FLUTTER_PATH"

# Verify Flutter installation using the local symlink
"$PROJECT_FLUTTER_PATH/bin/flutter" --version
flutter doctor --android-licenses || true

# Install Melos globally using Dart from Flutter
dart pub global activate melos

# Verify Melos is available
melos --version

# Bootstrap the workspace (install dependencies for all packages)
melos bootstrap