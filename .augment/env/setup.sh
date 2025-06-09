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
export PATH="$HOME/.fvm_flutter/bin/fvm:$PATH"

# Install Flutter 3.27.0 using FVM
fvm install 3.27.0
fvm use 3.27.0 --force

# Get the Flutter path from FVM directory structure
FLUTTER_PATH="$HOME/fvm/versions/3.27.0"
export PATH="$FLUTTER_PATH/bin:$PATH"

# Add Flutter to PATH permanently
echo "export PATH=\"$FLUTTER_PATH/bin:\$PATH\"" >> $HOME/.profile

# Verify Flutter installation
flutter --version
flutter doctor --android-licenses || true

# Install Melos globally using Dart from Flutter
dart pub global activate melos

# Add Dart global packages to PATH
export PATH="$HOME/.pub-cache/bin:$PATH"
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> $HOME/.profile

# Verify Melos is available
melos --version

# Bootstrap the workspace (install dependencies for all packages)
melos bootstrap

# Generate code for packages that need it (run on all packages without prompting)
melos run gen:build --no-select