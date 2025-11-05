# Claude Code Configuration

This directory contains Claude Code configuration files for the Mix project.

## Files

### `settings.json` (Committed)
Shared team settings that everyone uses. Contains:
- **sessionStart hook**: Runs `scripts/setup.sh` automatically
- **Default model**: Sonnet
- **Default shell**: Bash

### `settings.local.json` (Git-Ignored)
**Create this file** for personal settings that override `settings.json`.

Example:
```json
{
  "model": {
    "default": "opus"
  },
  "hooks": {
    "preToolUse": "echo 'My custom hook'"
  }
}
```

## Settings Precedence

Higher number = higher precedence (wins):

1. User settings (`~/.claude/settings.json`)
2. **Project settings** (`.claude/settings.json`) ← Committed
3. **Project local settings** (`.claude/settings.local.json`) ← Git-ignored
4. Command-line arguments
5. Enterprise policies (cannot override)

## Memory Files

See the root directory for memory files:

- **`AGENTS.md`** (Committed): Architecture and project context
- **`CLAUDE.local.md`** (Symlink → AGENTS.md): Auto-created by setup.sh, git-ignored
- **`CLAUDE.md`** (Git-Ignored): Optional personal instructions

## Quick Start

1. **For team setup**: Run `scripts/setup.sh` (auto-runs via sessionStart hook)
   - Creates symlink: `CLAUDE.local.md` → `AGENTS.md`
   - Claude Code reads `CLAUDE.local.md` which contains architecture context
2. **For personal settings overrides**:
   - Create `.claude/settings.local.json` if needed
3. **Test setup**: Run `scripts/setup.sh` manually

## How Memory Loading Works

When Claude Code starts:
1. Reads `CLAUDE.local.md` (which is a symlink to `AGENTS.md`)
2. Gets full architecture context automatically
3. No need for imports or manual configuration

## Documentation

- **Memory hierarchy (CLAUDE.local.md):** https://docs.claude.com/en/docs/claude-code/memory.md
  - See "Project memory (local)" row in the table for `CLAUDE.local.md` reference
- **Settings docs:** https://docs.claude.com/en/docs/claude-code/settings.md
- **Hooks reference:** https://docs.claude.com/en/docs/claude-code/hooks-reference.md
- **Setup guide (generic):** See `../CLAUDE_CODE_WEB_SETUP_GUIDE.md` in repo root
