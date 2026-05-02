# mix_schema_flutter

Flutter runtime bindings for the **Mix JSON Schema** reference implementation.

Bridges typed `MixJsonDocument` models from `mix_schema` to the Mix runtime (`BoxStyler`, `TextStyler`, etc.) and back. Re-exports the entire `mix_schema` API so most consumers depend on `mix_schema_flutter` alone.

See [`guides/mix_schema/spec.md`](../../guides/mix_schema/spec.md) for the normative specification.

## Quickstart

```dart
import 'package:flutter/material.dart';
import 'package:mix_schema_flutter/mix_schema_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final assets = MixSchemaAssets.fromFiles('packages/mix_schema/lib/src/assets');
    final parser = Parser(assets);
    final document = parser.parseValidating(/* JSON map */).document!;

    final scope = MixScope.empty();
    final runtimeParser = RuntimeParser(scope: scope);
    final widget = runtimeParser.toWidget(document.root);

    return MixScope(scope: scope, child: widget);
  }
}
```

## Host references

`HostRef` is the spec's escape hatch for non-serializable surface (custom shaders, custom clippers). Consumers wire their own `HostResolver`:

```dart
final resolver = AllowlistHostResolver({
  'gradient.brand': /* a Shader */,
  'clipper.ticket': /* a CustomClipper */,
});

final parser = RuntimeParser(scope: scope, hostResolver: resolver);
```

Per spec §Security Considerations, the consumer SHOULD maintain an allowlist; ids absent from it fail with `host.unresolved`. The reference `AllowlistHostResolver` matches that guidance.

## Status

**v1.0 Draft.** This package establishes the API shape for the runtime bridge. Per-prop styler dispatch and the full inverse `serializer_from_runtime` expand incrementally as the registry-driven semantic stage matures. See [`guides/mix_schema/EXECUTION.md`](../../guides/mix_schema/EXECUTION.md) Phase 6 for the build plan.

## License

See the repo root `LICENSE`.
