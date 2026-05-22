# mix_schema

`mix_schema` is the schema-first contract package for validating, decoding,
and exporting Mix UI payloads.

It is designed for three use cases:

- validating structured payloads before they reach runtime widgets
- decoding valid payloads into Mix runtime styles
- exporting the Ack JSON Schema contract so external producers and tooling can
  target Mix without reading Mix internals

## Public surfaces

### Contract surface

Import `package:mix_schema/mix_schema.dart` for the contract-facing APIs.

Main entry points:

- `MixSchemaContractBuilder`: compose a frozen contract, including custom
  top-level styler branches
- `MixSchemaContract`: validate payloads, decode payloads, encode supported
  runtime styles, and export the Ack JSON Schema artifact
- `RegistryBuilder` and `FrozenRegistry`: runtime-value bridge for built-in
  registry-backed fields such as icon data, image providers, animation
  callbacks, and context variant builders

### Producer surface

Import `package:mix_schema/encode.dart` for low-level producer helpers.

This surface intentionally stays narrow. It exposes:

- primitive payload helpers such as `payloadColor()` and `payloadOffset()`
- shared condition helpers such as `payloadBreakpointCondition()`

It does not attempt to be a complete payload builder for the full schema.
Producer discovery and validation should use `MixSchemaContract.rootSchema`,
`decode()`, `encode()`, and `exportJsonSchema()`.

## Validation and decode

```dart
import 'package:mix_schema/mix_schema.dart';

final contract = MixSchemaContract.builtIn();

final validation = contract.validate({
  'type': 'box',
  'padding': {'top': 8.0},
});

if (!validation.ok) {
  throw StateError(validation.errors.first.message);
}

final result = contract.decode({
  'type': 'box',
  'padding': {'top': 8.0},
});

final box = result.value;
```

### Compound context variants

`context_all_of` accepts two or more leaf conditions. The schema deliberately
restricts the allowed leaf set to the following shared context branches:

- `widget_state`
- `enabled`
- `context_brightness`
- `context_breakpoint`
- `context_not_widget_state`

Nested `context_all_of` is intentionally rejected by both the schema and the
runtime. Compound conditions stay flat — flatten them into the leaf list above
when composing producer payloads.

## Registry-backed values

Some built-in fields resolve values from registries at decode time.

Use `RegistryBuilder` for those values and pass the frozen registries into the
contract.

```dart
import 'package:flutter/widgets.dart';
import 'package:mix_schema/mix_schema.dart';

final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
  scope: MixSchemaScope.imageProvider,
)..register('hero', const AssetImage('assets/hero.png'));

final contract = MixSchemaContract.builtIn(registries: [images.freeze()]);
```

Built-in scopes are exposed through `MixSchemaScope`.

## Schema export

`MixSchemaContract.exportJsonSchema()` exposes the Ack JSON Schema artifact for
external producers and AI/tooling integration. The exported schema is derived
from the same Ack schemas used for validation, decode, and supported encode
paths.

```dart
import 'package:mix_schema/mix_schema.dart';

final jsonSchema = MixSchemaContract.builtIn().exportJsonSchema();
```

Custom top-level stylers are registered through
`MixSchemaContractBuilder.register<T>(type, input:, decode:, encode:, output:)`.
Custom type ids must match `^[a-z][a-z0-9_]*$` and cannot use built-in styler
ids. Field ownership and JSON Schema export are derived from the supplied
`input` object schema.

The discriminator `{'type': <id>}` is injected on encode automatically —
producers must **not** emit `type` themselves. The optional `output` schema
attaches runtime-side refinements.

```dart
import 'package:ack/ack.dart';
import 'package:mix_schema/mix_schema.dart';

final builder = MixSchemaContractBuilder()
  ..register<int>(
    'demo',
    input: Ack.object({'value': Ack.integer()}),
    decode: (data) => data['value']! as int,
    encode: (value) => {'value': value},
  );
```

## Current v1 limitations

- Built-in styler branches are codec-backed and can encode direct,
  producer-representable values. Runtime-only values such as token props,
  multi-source props, derived props, unregistered registry values, and
  unsupported animation configs return mapped encode errors. Compound stylers
  intentionally fold their nested Mix props, so multi-source values there are
  representable only where folding is the defined schema semantic.
- Registry-backed runtime values require stable producer ids. Missing ids
  decode as `unknown_registry_id`; unregistered runtime values encode as
  `unknown_registry_value`.
- Enums use strict string names on the wire. Integer enum indexes are rejected.
- Structural payload limits run before validation/decode and after encode
  through `MixSchemaLimits`. Limit failures use `payload_limit_exceeded`, and
  the active limit values are exported under `x-mix-schema-limits`.
- Ack `toJsonSchemaModel()` is not used yet because the current discriminated
  branch shape conflicts with model conversion. `exportJsonSchema()` uses raw
  Ack JSON Schema export.

## Design direction

`mix_schema` is contract-first, not decoder-first.

- Ack definitions are the source of truth for validation and transform.
- Ack JSON Schema export is the source of truth for producer-facing schema
  artifacts.
- External consumers such as `mix_tailwinds` should target stable contract
  surfaces rather than internal implementation details.
