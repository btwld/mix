# mix_protocol

`mix_protocol` is the versioned JSON wire protocol for representable Mix
styles and token themes. It decodes untrusted JSON into real Mix stylers,
encodes supported runtime stylers into canonical JSON, and exports JSON Schema
for authoring tools.

The package is intentionally narrow:

- one fixed v1 vocabulary for `box`, `text`, `flex`, `stack`, `icon`, `image`,
  `flex_box`, and `stack_box` styles;
- one shared `mixProtocol` façade for styles, themes, and schema export;
- strict decode by default, with bounded lenient recovery for additive data;
- stable path-qualified diagnostics and fail-loud encoding;
- per-call icon and image identity resolution; and
- no public codec registration, Ack types, widget-tree model, transport, or
  persistence policy.

Ack powers the private bidirectional codecs and JSON Schema generation. The
wire semantics and compatibility policy belong to `mix_protocol`; consumers do
not depend on Ack.

## Quick start

```dart
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

final result = mixProtocol.decodeStyle<BoxStyler>({
  'v': 1,
  'type': 'box',
  'padding': 16,
  'decoration': {'color': '#3D5AFE'},
});

final style = switch (result) {
  MixProtocolSuccess<BoxStyler>(:final value) => value,
  MixProtocolFailure<BoxStyler>(:final errors) =>
    throw FormatException('$errors'),
};

final encoded = mixProtocol.encodeStyle(style);
final styleSchema = mixProtocol.exportStyleJsonSchema();
```

Theme documents use the same façade:

```dart
final theme = switch (mixProtocol.decodeTheme(themeJson)) {
  MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
  MixProtocolFailure<MixProtocolTheme>(:final errors) =>
    throw FormatException('$errors'),
};

final scope = MixScope(tokens: theme.tokens, child: app);
final themeSchema = mixProtocol.exportThemeJsonSchema();
```

Every top-level document must carry `v: 1`; nested variant styles inherit the
root version. Explicit JSON `null` is forbidden. Unsupported runtime values
fail encode instead of being silently omitted.

## Protocol, schema, and future documents

These are distinct layers:

- **Protocol:** the accepted payloads, canonical output, versioning, recovery,
  identity, token, and diagnostic semantics implemented here.
- **JSON Schema:** a generated description of the style or theme input shape
  for editors and CI. It is an artifact of the protocol, not a parallel source
  of truth.
- **Document layer:** a future widget-tree or server-driven UI format may embed
  these per-node style payloads. Widget trees, events, and component identity
  are not part of `mix_protocol` v1.

`mix_tailwinds` remains a direct Mix styler producer at runtime. Its test suite
uses `mix_protocol` as a development-only reference consumer to prove that a
broad Tailwinds utility corpus is representable and canonical.

See [GUIDE.md](GUIDE.md) for integration patterns and
[WIRE_CONTRACT.md](WIRE_CONTRACT.md) for the complete v1 grammar.
