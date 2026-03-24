# Copilot Instructions for `btwld/mix`

## What this repository is
Mix is a Flutter/Dart monorepo for a type-safe styling system.

- `packages/mix`: core framework (spec/style/widget pattern)
- `packages/mix_annotations`: annotations used by codegen
- `packages/mix_generator`: build_runner generator
- `packages/mix_lint`: custom lint plugin
- `packages/mix_docs_preview`: doc preview widgets and manifest for the website
- `website`: docs site

## Fast path for coding agents
1. Read `AGENTS.md` and `melos.yaml` first.
2. Keep changes surgical and package-scoped.
3. If you touch specs, generated files, or exports, run generation before tests.
4. Prefer targeted checks first, then broader checks if needed.

## Setup and verification commands
From repo root:

```bash
melos bootstrap
melos run gen:build
melos run ci
melos run analyze
```

Useful targeted commands:

```bash
melos run test:flutter
melos run test:dart
melos run analyze:dart
melos run analyze:dcm
melos run exports
```

## Codebase conventions that matter
- Dart SDK: `>=3.11.0 <4.0.0`
- Flutter SDK: `>=3.41.0` (repo pins via `.fvmrc`)
- Core architecture: **Spec (immutable)** + **Style (builder)** + **Widget**
- Do not hand-edit generated outputs when a generator exists.
- `packages/mix/lib/mix.dart` is generated; use `melos run exports`.
- If modifying APIs that use codegen, run `melos run gen:build`.

## Change strategy
- Prefer minimal changes in the smallest affected package.
- Avoid cross-package refactors unless explicitly required.
- Match existing coding patterns in nearby files.
- Update tests only where behavior changed.

## Troubleshooting / environment-specific onboarding errors
The following issues were observed in one constrained CI-like onboarding environment (not repository-wide known defects):
If your local setup works, you can ignore this section.

1. `flutter --version` returned: `flutter: command not found`.
2. Running setup with `CLAUDE_CODE_REMOTE=true bash setup.sh` failed:
   - `curl: (6) Could not resolve host: fvm.app`
   - `ERROR: fvm not found on PATH after install`
3. `dart --version` and `melos --version` were also unavailable.

### Work-arounds used
- Used repository docs (`AGENTS.md`, `melos.yaml`) as the authoritative source for commands/conventions.
- Limited changes to documentation-only updates that do not require local Flutter/Dart execution.
- For CI/build diagnosis, rely on GitHub Actions APIs to inspect workflow runs and logs when local tooling is unavailable.
- When parsing large workflow JSON, avoid assuming all keys exist (e.g., use safe access for optional fields like `conclusion`).

## CI/build failure triage guidance
When CI is mentioned, inspect GitHub Actions in this order:
1. List recent workflow runs.
2. Inspect run/job details and logs for failures.
3. Summarize root cause and map it to the smallest repository change.

If a run is `action_required` for `pull_request_target`, verify whether it is awaiting manual approval or blocked by security policy requirements before treating it as a code regression.
