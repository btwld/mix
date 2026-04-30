# mix_schema

`mix_schema` is the schema-first contract package for validating, decoding,
and exporting Mix UI payloads.

It is designed for three use cases:

- validating structured payloads before they reach runtime widgets
- decoding valid payloads into Mix runtime styles
- exposing stable contract metadata so external producers and tooling can
  target Mix without reading Mix internals

## Public surfaces

### Contract surface

Import `package:mix_schema/mix_schema.dart` for the contract-facing APIs.

Main entry points:

- `MixSchemaContractBuilder`: compose a frozen contract, including custom
  top-level styler branches
- `MixSchemaContract`: validate payloads, decode payloads, and export contract
  metadata
- `MixSchemaDecoder`: convenience runtime wrapper over `MixSchemaContract`
- `RegistryBuilder` and `FrozenRegistry`: runtime-value bridge for built-in
  registry-backed fields such as image providers, animation callbacks, and
  context variant builders

### Producer surface

Import `package:mix_schema/encode.dart` for low-level producer helpers.

This surface intentionally stays narrow. It exposes:

- wire identifiers such as `SchemaStyler`, `SchemaVariant`, and
  `SchemaModifier`
- primitive payload helpers such as `payloadColor()` and `payloadOffset()`
- shared condition helpers such as `payloadBreakpointCondition()`

It does not attempt to be a complete payload builder for the full schema.
Richer producer discovery should use `MixSchemaContract.exportMetadata()`.

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

If you only need a runtime adapter, use `MixSchemaDecoder`:

```dart
import 'package:mix_schema/mix_schema.dart';

final decoder = MixSchemaDecoder.builtIn();
final result = decoder.decode({'type': 'text'});
```

## Registry-backed values

Some built-in fields resolve values from registries at decode time.

Use `RegistryBuilder` for those values and pass the frozen registries into the
contract or decoder.

```dart
import 'package:flutter/widgets.dart';
import 'package:mix_schema/mix_schema.dart';

final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
  scope: MixSchemaScope.imageProvider,
)..register('hero', const AssetImage('assets/hero.png'));

final contract = MixSchemaContract.builtIn(registries: [images.freeze()]);
```

Built-in scopes are exposed through `MixSchemaScope`.

## Export metadata

`MixSchemaContract.exportMetadata()` exposes stable contract metadata for
external producers and AI/tooling integration.

Today that metadata includes:

- supported top-level styler types
- supported modifier types
- supported variant types
- supported `context_all_of.conditions[].type` values
- top-level metadata fields
- nested variant-style metadata fields
- field ownership per registered styler
- styler fields that are known to be unsupported in v1 payloads
- built-in registry scopes

```dart
import 'package:mix_schema/mix_schema.dart';

final metadata = MixSchemaContract.builtIn().exportMetadata();

final boxFields = metadata.stylerFields['box'];
final topLevelMetadata = metadata.topLevelMetadataFields;
```

Custom top-level stylers must declare their field ownership when they are
registered so exported metadata stays aligned with the runtime contract.

For now that means custom registration duplicates contract information:
callers provide both the `AckSchema` and the exported `fields` list. Keep them
aligned manually until richer Ack-derived export is available. For
object-backed schemas, registration now validates that `fields` matches the
underlying Ack object shape and that `unsupportedFields` stays within that
declared field set.

```dart
final builder = MixSchemaContractBuilder()
  ..register(
    'demo',
    Ack.object({'value': Ack.integer()}).transform<Object>(
      (data) => data['value'] as int,
    ),
    fields: const ['value'],
  );
```

## Current v1 limitations

- `IconStyler.icon` is recognized by the contract but is not representable in
  v1 payloads. It is reported through `unsupportedFields`.
- Export metadata currently provides stable vocabulary and field ownership. It
  does not yet expose the full constraint-level information a future producer
  or AI tool would need to generate valid payloads without implementation
  knowledge.
- A later phase should export deeper Ack-derived schema and constraint details
  instead of stopping at vocabulary and field ownership.

## Design direction

`mix_schema` is contract-first, not decoder-first.

- Ack definitions are the source of truth for validation and transform.
- Contract metadata should come from the same ownership model as decode.
- External consumers such as `mix_tailwinds` should target stable contract
  surfaces rather than internal implementation details.