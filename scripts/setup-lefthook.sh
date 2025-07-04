#!/bin/bash

echo "🚀 Setting up Lefthook..."

# Install lefthook if not already installed
if ! command -v lefthook &> /dev/null; then
    echo "📥 Installing lefthook..."
    
    if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
        brew install lefthook
    else
        curl -sSfL https://raw.githubusercontent.com/evilmartians/lefthook/master/install.sh | sh
    fi
fi

# Install git hooks
echo "🔗 Installing Git hooks..."
lefthook install

echo "✅ Done! Your commits will now be checked for:"
echo "   - Formatting issues (dart format)"
echo "   - Analyzer errors (dart analyze)"
