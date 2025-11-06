# Repository Guidelines

## Project Structure & Module Organization
Mix is a Melos-managed monorepo. Runtime code is in `packages/mix/lib/`, annotation APIs in `packages/mix_annotations/`, generators in `packages/mix_generator/`, and lint rules in `packages/mix_lint/`. Sample apps live under `examples/` and `packages/*/demo/`. Shared docs sit in `guides/`, marketing in `website/`, automation helpers in `scripts/`, and static art in `assets/`. Each package keeps unit tests in its `test/` folder.

## Build, Test, and Development Commands
- `melos bootstrap` — install dependencies and link local packages.
- `melos run analyze` — run `dart analyze` plus Dart Code Metrics on every package.
- `melos run gen:build` / `melos run gen:watch` — regenerate sources once or continuously via `build_runner`.
- `melos run test:flutter`, `melos run test:dart`, `melos run test:coverage` — execute Flutter, pure Dart, or coverage suites.
- `melos run ci` — shortcut that runs the primary Flutter and Dart test targets.

## Coding Style & Naming Conventions
Use standard Flutter formatting (two-space indent, trailing commas) and keep imports relative; both rules are enforced through `lints.yaml`. The workspace enables the `dot-shorthands` experiment, so remember to update `analysis_options.yaml` when creating new packages. `lints_with_dcm.yaml` layers Dart Code Metrics rules such as `member-ordering` and `arguments-ordering`; run `melos run lint:fix:all` before pushing to surface violations automatically. Name shared `Style` or `Variant` definitions descriptively (`const outlined = NamedVariant('outlined');`) and align file names with the primary class they export.

## Testing Guidelines
Author focused `*_test.dart` files grouped by widget, utility, or generator. Flutter-facing packages rely on `flutter_test`, while generators and lint packages use `dart test`. Always regenerate sources (`melos run gen:build`) before running tests that touch generated code. Use `melos run test:coverage` when altering rendering primitives, and include golden diffs or storybook screenshots in PRs whenever UI output changes.

## Commit & Pull Request Guidelines
Adopt Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`) as seen throughout history; keep the subject ≤72 characters and mention the impacted module (`feat: mix_generator adds StackBox hook`). PRs should explain intent, link issues (`Fixes #123`), highlight testing status, and attach screenshots for visual tweaks. Update changelogs when bumping versions, verify exports via `melos run exports`, and run `./scripts/verify_changelogs.sh packages` before release PRs.

## Security & Automation Tips
Pin tooling through `.fvm/flutter_sdk` to avoid SDK drift, and keep secrets out of version control (use ignored `.env` files inside `examples/` when necessary). Leverage `melos run api-check` or `dart scripts/api_check.dart` to compare public APIs before tagging a release.
