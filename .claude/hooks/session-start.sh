#!/bin/bash
# SessionStart hook: environment setup and symlink creation
set -e

DIR="${CLAUDE_PROJECT_DIR:-.}"

# ----------------------------
# Environment setup (remote only)
# ----------------------------
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && [ -f "$DIR/setup.sh" ]; then
  if ! command -v flutter >/dev/null 2>&1; then
    echo "Remote environment detected, running setup.sh..."
    bash "$DIR/setup.sh"
  fi
fi

# ----------------------------
# CLAUDE.md symlink
# ----------------------------
if [ -f "$DIR/AGENTS.md" ] && [ ! -e "$DIR/CLAUDE.md" ]; then
  ln -s AGENTS.md "$DIR/CLAUDE.md"
  echo "Created CLAUDE.md -> AGENTS.md"
fi

exit 0
