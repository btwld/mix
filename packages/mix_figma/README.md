# mix_figma

Bidirectional bridge between Figma and versioned Mix protocol documents.

The package has two deliberate layers:

- `lib/src/core` performs standalone-Dart JSON parsing, mapping, diagnostics,
  code generation, identity tracking, and plugin payload construction.
- `lib/src/runtime` is the only layer coupled to Flutter, `mix`, and
  `mix_protocol`; it materializes themes/styles, creates `MixScope`s, and
  compares authored inspection evidence without flattening aliases.

Canonical light and dark themes live in `design/tokens`. Regenerate Dart token
declarations with `melos run gen:mix-figma-tokens`.

## CLI

From this package directory:

```bash
dart run tool/mix_figma_cli.dart pull --from dtcg \
  --input light=test/fixtures/dtcg/light.tokens.json \
  --input dark=test/fixtures/dtcg/dark.tokens.json \
  --output-dir ../../design/tokens \
  --tokens-output ../../design/tokens/tokens.g.dart

dart run tool/mix_figma_cli.dart push --input-dir ../../design/tokens
dart run tool/mix_figma_cli.dart check --kind theme \
  --expected ../../design/tokens/light.theme.json \
  --actual ../../design/tokens/light.theme.json
dart run tool/mix_figma_cli.dart serve \
  --port 8787 \
  --theme-dir ../../design/tokens \
  --style-dir ../../design/styles \
  --component-dir test/fixtures/components \
  --report-dir ../../design/figma-reports \
  --config mix_figma.yaml
```

`check` and `serve --validate` use a Flutter-test harness because
`mix_protocol` depends on `dart:ui`; all normal import/export reshaping remains
executable on the standalone Dart VM.

The production workflow is `Analyze -> Preview -> Apply -> Verify`:

- `POST /sync/plan` reads the current state and returns a deterministic plan.
- `POST /sync/apply` rechecks the source fingerprint before staging local
  files or approving exact Figma operations.
- `POST /sync/verify` reads back the result, persists a report, and updates
  `mix_figma.lock.json` only when a Figma write is proven converged.

`serve` prints a fresh session token. Paste it into the plugin before checking
the bridge; all endpoints except CORS preflight require that bearer token. Use
`--auth-token <value>` only for controlled automation that must supply a stable
token.

The bridge supports token pull/push, selection-to-style import, and
component-set export. Reports are written as `<report-dir>/<planId>.json`.
`GET /health` is available for the plugin development loop. `/sync/*` is the
only synchronization API; direct pull/push routes are intentionally absent so
callers cannot bypass preview, stale-plan detection, or read-back verification.
Direct `/lock/*` writes return `410 Gone`; unverified results cannot update
identity state.

See [Synchronization workflow](docs/synchronization.md) for usage, support,
and safety guarantees. See [Live release gate](docs/live-release-gate.md) for
the required controlled Figma validation before a release.
The latest Concepta validation record is
[2026-07-20](docs/live-release-result-2026-07-20.md).

The component fixtures are self-authored or ported static copies from the
portable component-contract producer. Neither production nor tests have a
live dependency on the remix repository.

Use `--config` when a Figma FLOAT needs an explicit protocol-group override:

```yaml
floatGroups:
  variables:
    variable:radius: radii
  collections:
    Core spacing: spaces
```
