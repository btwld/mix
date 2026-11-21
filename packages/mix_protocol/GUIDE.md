# Using `mix_protocol`

`mix_protocol` is for moving Mix styles and token themes across a JSON
boundary. It is a good fit for server-driven component styling, shared design
tokens, preset validation, and authoring tools. It is not a widget-tree format.

The shared API is deliberately core-only:

```dart
final MixProtocol mixProtocol;

mixProtocol.decodeStyle<T>(json);
mixProtocol.encodeStyle(styler);
mixProtocol.decodeTheme(json);
mixProtocol.encodeTheme(theme);
mixProtocol.exportStyleJsonSchema();
mixProtocol.exportThemeJsonSchema();
```

There is no runtime codec registry. A package-defined vocabulary is an immutable
value, and applications opt into the same explicit composition at each protocol
boundary.

## Setup

Add the published pre-release to your app:

```yaml
dependencies:
  mix: ^2.2.0
  mix_protocol: ^1.0.0-alpha.0
```

```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
```

## Compose package vocabularies

An integration package can expose a ready-to-use composition for its common
case. For charts, use:

```dart
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

final result = mixChartProtocol.encodeStyle(chartStyle);
```

Use the vocabulary values directly when constructing the composition manually:

```dart
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

final chartProtocol = MixProtocol.compose([
  mixProtocolCoreVocabulary,
  mixChartVocabulary,
]);
```

The ordinary `mixProtocol` singleton remains core-only. It rejects chart roots
in both strict and lenient modes, so merely adding a package dependency cannot
change the meaning of a core v1 document.

Composition order does not affect the resulting schema or encoded documents.
Non-core vocabulary ids and branch names are sorted after validation. A chart
root uses a versioned namespace such as `mix_chart.v1.line_chart`; nested chart
and core stylers recurse through the same union.

Exported schema identifies required additions:

```json
{
  "x-mix-protocol-vocabularies": [
    { "id": "mix_chart", "wireVersion": 1 }
  ]
}
```

Vocabulary wire versions are protocol majors, independent from the package's
release version.

## Author a vocabulary

Packages define codecs through the Ack-free authoring façade. Declare each
field once and use the supplied reconstruction callback:

```dart
import 'package:mix_protocol/authoring.dart';

final counterVocabulary = MixProtocolVocabulary(
  id: 'counter_styles',
  wireVersion: 1,
  branches: [
    MixProtocolStylerBranch<CounterStyler>(
      name: 'counter',
      codec: (_) {
        final count = MixProtocolField.direct<CounterStyler, int>(
          wire: 'count',
          codec: MixProtocolCodecs.integer(min: 0),
          read: (value) => value.count,
        );

        return MixProtocolStylerCodec(
          fields: [count],
          build: (data) => CounterStyler(count.value(data)),
        );
      },
    ),
  ],
);
```

Use `MixProtocolField.value` for ordinary `Prop<T>` fields,
`MixProtocolField.mix` for Mix-backed properties, and
`MixProtocolField.style` for recursive nested stylers. Standard styler metadata
is represented with `MixProtocolStylerMetadata`. Generated Stylers expose their
source-field names through `StylerFieldMetadata.$stylerFieldNames`, enabling
the core and extension-contributed vocabularies to detect inventory drift
without handwritten field manifests.

Branch runtime types must be concrete and mutually disjoint. Field names use
lower camel case; duplicate names and the protocol-owned `v`, `type`, and `$...`
names are rejected when the composition is built.

For ordinary Mix `Style` subclasses, prefer
`MixProtocolStylerCodec.forStyler`. It wires variants, modifiers, animation,
and generated field inventory once. Handwritten Stylers and output from an
older generator can temporarily supply `ownerFieldInventory`; when neither
generated metadata nor that fallback is available, encoding fails with an
`inventorySkew` diagnostic. The base constructor remains available for
nonstandard codec owners and targeted tests.

## Decode a style

Every top-level style document requires the supported version and a styler
discriminator known to the protocol composition:

```json
{
  "v": 1,
  "type": "box",
  "padding": 16,
  "decoration": { "color": "#3D5AFE", "borderRadius": 12 }
}
```

Decode directly into the expected Mix type and handle both result variants:

```dart
final style = switch (mixProtocol.decodeStyle<BoxStyler>(payload)) {
  MixProtocolSuccess<BoxStyler>(:final value) => value,
  MixProtocolFailure<BoxStyler>(:final errors) =>
    throw FormatException('Invalid style: $errors'),
};
```

The success value is a real `BoxStyler`, not a protocol DTO. A requested Dart
type that does not match the payload's `type` fails with `type_mismatch`.

Grid layout styles use the same boundary. Tracks are discriminated values, and
local constraint branches carry a `Breakpoint` plus a geometry-only patch:

```json
{
  "v": 1,
  "type": "grid_box",
  "columns": [
    { "type": "fixed", "size": 220 },
    { "type": "fr", "fraction": 2 }
  ],
  "autoRows": { "type": "auto" },
  "columnGap": 16,
  "rowGap": 12,
  "constraintBranches": [
    {
      "breakpoint": { "maxWidth": 720 },
      "patch": {
        "columns": [{ "type": "fr", "fraction": 1 }],
        "columnGap": 8,
        "rowGap": 8
      }
    }
  ]
}
```

`constraintBranches` evaluate the Grid's bounded local layout constraints.
They are not viewport `context_breakpoint` variants. Breakpoint token names can
be supplied as `{ "token": "breakpoint.card.compact" }`.

Track values and gaps also accept numeric token references. Use space tokens
for logical-pixel sizes and gaps, and double tokens for fractional weights:

```json
{
  "v": 1,
  "type": "grid_box",
  "columns": [
    {
      "type": "fixed",
      "size": { "$token": "space.grid.sidebar", "kind": "space" }
    },
    {
      "type": "fr",
      "fraction": { "$token": "double.grid.content", "kind": "double" }
    }
  ],
  "columnGap": { "$token": "space.grid.gap", "kind": "space" }
}
```

## Decode a token theme

Theme documents group concrete token values by Mix token kind:

```json
{
  "v": 1,
  "type": "theme",
  "colors": {
    "color.surface": "#101820",
    "color.primary": "#3D5AFE",
    "color.primaryPressed": { "$token": "color.primary" }
  },
  "spaces": {
    "space.sm": 8,
    "space.md": 16
  },
  "radii": {
    "radius.card": 12
  }
}
```

```dart
final theme = switch (mixProtocol.decodeTheme(themePayload)) {
  MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
  MixProtocolFailure<MixProtocolTheme>(:final errors) =>
    throw FormatException('Invalid theme: $errors'),
};

final themedApp = MixScope(tokens: theme.tokens, child: app);
```

Aliases are same-kind, whole-value references. Decode resolves them eagerly,
rejects missing targets and cycles, and exposes an immutable, flat
`Map<MixToken, Object>`. Theme decode is strict in v1.

Supported groups are `colors`, `spaces`, `doubles`, `radii`, `textStyles`,
`shadows`, `boxShadows`, `borders`, `fontWeights`, `breakpoints`, and
`durations`.

## Reference theme tokens from styles

Style fields accept canonical token terms wherever the field's Mix type
supports that token kind:

```json
{
  "v": 1,
  "type": "box",
  "padding": { "$token": "space.md" },
  "decoration": {
    "color": {
      "$token": "color.primary",
      "apply": [{ "op": "color_darken", "amount": 0.1 }]
    },
    "borderRadius": { "$token": "radius.card" }
  }
}
```

Token lookup happens when Mix resolves the styler. To catch missing tokens in
CI, compare the decoded style references with the decoded theme:

```dart
final used = tokenReferencesOf(style);
final declared = theme.tokens.keys
    .map(MixProtocolTokenReference.fromToken)
    .toSet();
final missing = used.difference(declared);

if (missing.isNotEmpty) {
  throw StateError('Undefined theme tokens: $missing');
}
```

Token names match `[A-Za-z0-9_.-]{1,128}`.

## Strict and lenient decode

Strict style decode is the default. It rejects unknown fields, discriminator
values, and enum values, which is the appropriate boundary policy for most
untrusted input.

Lenient mode supports bounded forward compatibility for additive changes:

```dart
final result = mixProtocol.decodeStyle<BoxStyler>(
  payload,
  options: const MixProtocolDecodeOptions(
    mode: MixProtocolDecodeMode.lenient,
  ),
);

if (result case MixProtocolSuccess<BoxStyler>(
  :final value,
  :final warnings,
)) {
  for (final warning in warnings) {
    log('${warning.code.wireValue} at ${warning.path}');
  }
  render(value);
}
```

Lenient decode only removes documented, repairable unknown data at the
smallest safe granule. Known malformed values, a missing or unsupported `v`,
an unknown root style type, explicit `null`, and resource-limit violations
remain fatal.

Preflight limits are fixed at depth 64 and 10,000 JSON nodes. Lenient cleanup
stops after 256 removals. These limits run before or around private Ack schema
traversal and return stable protocol errors.

## Icon and image identities

Common identities can travel as data:

```json
{ "codePoint": 59530, "fontFamily": "MaterialIcons" }
{ "url": "https://example.com/avatar.png", "scale": 2 }
{ "asset": "assets/avatar.png", "package": "app" }
```

Applications can instead use short names and resolve them per decode call:

```dart
final result = mixProtocol.decodeStyle<IconStyler>(
  {'v': 1, 'type': 'icon', 'icon': 'home', 'size': 24},
  options: MixProtocolDecodeOptions(
    resolveIcon: (name) => name == 'home' ? Icons.home : null,
  ),
);
```

Identity names match `[A-Za-z0-9_-]{1,96}`. A valid but unresolved name returns
`unresolved_identity_name`. Prefer named `const IconData` values in Flutter
apps when icon tree shaking matters.

Encoding accepts reverse maps when a producer wants names:

```dart
final result = mixProtocol.encodeStyle(
  IconStyler(icon: Icons.home),
  options: const MixProtocolEncodeOptions(
    iconNames: {'home': Icons.home},
  ),
);
```

Supported value forms are used when no name matches. Unrepresentable image
provider state, such as `NetworkImage.headers`, fails rather than being lost.

## Encode canonical JSON

Encoding is atomic and fail-loud:

```dart
final encoded = switch (mixProtocol.encodeStyle(style)) {
  MixProtocolSuccess<JsonMap>(:final value) => value,
  MixProtocolFailure<JsonMap>(:final errors) =>
    throw StateError('Style is not representable: $errors'),
};
```

The result includes `v: 1`, emits canonical property terms and value forms,
and never returns partial output. Unsupported closures, callbacks, custom token
subclasses, and other unmodeled runtime values return a path-qualified error.

Themes encode through `mixProtocol.encodeTheme(theme)`. Because aliases are
resolved on decode, re-encoding a decoded theme emits flat concrete values.

## Export JSON Schema

Use the generated draft-07 documents for editor integration, CMS validation,
or CI checks:

```dart
final styleSchema = mixProtocol.exportStyleJsonSchema();
final themeSchema = mixProtocol.exportThemeJsonSchema();
```

JSON Schema describes the accepted structural shape. The Dart protocol remains
the semantic authority for canonical encoding, resolution, resource limits,
lenient repair, and diagnostic mapping. Ack is not exposed by the public API.

## mix_winds and future document layers

`mix_winds` should continue to construct Mix stylers directly at runtime.
It uses `mix_protocol` only in tests to encode, strictly decode, and canonically
re-encode representative mix_winds output. Runtime JSON conversion would add
cost and failure modes without changing the resulting style.

A future server-driven widget-tree package can embed these style and theme
documents. Node hierarchy, widget identity, events, data binding, transport,
and persistence should stay outside this per-node v1 protocol.

For every field, discriminator, token term, modifier, variant, and diagnostic,
see [WIRE_CONTRACT.md](WIRE_CONTRACT.md).
