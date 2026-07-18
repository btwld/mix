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
dart run tool/mix_figma_cli.dart serve --port 8787
```

`check` and `serve --validate` use a Flutter-test harness because
`mix_protocol` depends on `dart:ui`; all normal import/export reshaping remains
executable on the standalone Dart VM.

The server exposes `POST /pull/tokens`, `GET /push/tokens`,
`POST /pull/nodes`, `GET /push/components/:id`, `POST /webhooks/figma`, and
`GET /health`. CORS is enabled for the localhost plugin development loop.

The component fixtures are self-authored or ported static copies from the
portable component-contract producer. Neither production nor tests have a
live dependency on the remix repository.
