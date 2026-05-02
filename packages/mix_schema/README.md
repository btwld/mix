# mix_schema

Reference Dart implementation of the **Mix JSON Schema** — a public JSON contract for declaring Mix widget trees.

Pure Dart, zero Flutter dependency. Backend tooling, CMS exporters, and AI agents that emit Mix JSON depend on this package directly. Flutter apps that need to render the resulting trees use `mix_schema_flutter`.

See [`guides/mix_schema/spec.md`](../../guides/mix_schema/spec.md) for the normative specification.

## What's in the box

- `Validator` — 4-stage pipeline (bounds → JSON Schema → canonicalize → semantic).
- `Canonicalizer` — sugar → canonical, idempotent.
- `Parser` / `Serializer` — typed model ↔ canonical JSON, structural round-trip.
- 100+ typed Dart classes mirroring the spec (widgets, styles, modifiers, directives, variants, structured literals, host refs).
- 52 normative error codes (`ErrorCode`) loaded from `error-codes.json`.

## Quickstart

```dart
import 'package:mix_schema/mix_schema.dart';

void main() {
  final assets = MixSchemaAssets.fromFiles('lib/src/assets');
  final parser = Parser(assets);

  final result = parser.parseValidating({
    'schema': '1.0.0',
    'root': {
      'widget': 'Box',
      'style': {
        'spec': 'box',
        'props': {'padding': 16}, // sugar — gets canonicalized
      },
    },
  });

  if (!result.isValid) {
    for (final err in result.validation.errors) {
      print(err);
    }
    return;
  }
  print('OK: $${result.document!.root}');
}
```

## Status

**v1.0 Draft.** The contract advances to Candidate when (a) this implementation ships and (b) at least one independent implementation built from `spec.md` text alone validates the contract. See [`guides/mix_schema/IMPLEMENTATION.md`](../../guides/mix_schema/IMPLEMENTATION.md) for the locked architecture and [`guides/mix_schema/EXECUTION.md`](../../guides/mix_schema/EXECUTION.md) for the build runbook.

## Error codes

All errors emitted by the validator/canonicalizer/parser/serializer use codes from `error-codes.json` (52 codes, language-neutral source of truth — Decision #39). Codes are exposed via the `ErrorCode` Dart enum.

## License

See the repo root `LICENSE`.
