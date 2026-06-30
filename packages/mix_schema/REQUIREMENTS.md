# mix_schema Requirements

`mix_schema` is the Ack-owned contract between JSON style payload producers and representable Mix runtime stylers. It validates and decodes inbound payloads, encodes representable runtime stylers, and exports JSON Schema. It is not a general serializer for every Mix object.

Pinned Ack: `btwld/ack` `8daaadace3e0c9969e05eb0fe5633a51c2bb124b`, path `packages/ack`.

Flutter primitive payloads mirror Ack `flutter_codec` branch shapes where they do not erase Mix semantics. Local mirrors must be replaced by `flutter_codec` imports once that package is merged and available to this workspace.

Tailwinds emits accepted utility classes as `mix_schema` payloads, validates/decodes them through `MixSchemaContract`, and then returns Mix stylers from its existing parser APIs. Parser diagnostics remain responsible for unsupported Tailwinds utilities; accepted utilities must not bypass the schema contract with direct styler mutation.

| Rule | Requirement | Implementation | Tests |
| --- | --- | --- | --- |
| R-1 | Ack owns validation, decode, encode, and JSON Schema export. | `MixSchemaContract.rootSchema` | `public_api_contract_test.dart` |
| R-2 | Ack owns the `type` discriminator; branch codecs do not declare or inject it. | `Ack.discriminated(discriminatorKey: 'type')` | `schema_export_golden_test.dart` |
| R-3 | Runtime widening happens only in `widenStylerBranch`. | `src/schema/styler_branch.dart` | `styler_branch_test.dart` |
| R-4 | Strict wire enums use string values only. | `common_codecs.dart`, `encode.dart` | `common_codecs_test.dart` |
| R-5 | Unsupported runtime objects fail encode explicitly. | typed exceptions in `mix_schema_error.dart` | branch/styler encode tests |
| R-6 | App-owned identity uses scoped registries. | `src/registry/` | `registry_*_test.dart` |
| R-7 | Public errors expose stable code, path, message, and offending value. | `schema_error_mapper.dart` | `error_mapper_test.dart` |
| R-8 | Payload limits run before decode and after encode. | `validatePayloadLimits` | `mix_schema_contract_test.dart` |
| R-9 | Tailwinds production code depends only on public `mix_schema.dart` and `encode.dart` and routes accepted utilities through schema payloads. | `packages/mix_tailwinds` imports and parser payload APIs | guard tests, Tailwinds payload contract tests |
| R-10 | Missing payload fields are not filled with Mix runtime defaults. | no schema `withDefault` for runtime defaults | styler tests |
| R-11 | Recursive nested styles use `Ack.lazy`. | `variant_codec.dart` | `variant_codec_test.dart` |
| R-12 | `encode.dart` is a narrow producer helper surface and exports no schema internals. | `lib/encode.dart` only | guard tests |

Public error codes: `type_mismatch`, `required_field`, `unknown_field`, `invalid_enum`, `constraint_violation`, `payload_limit_exceeded`, `unsupported_encode_value`, `unknown_type`, `unknown_registry_id`, `unknown_registry_value`, `validation_failed`, `transform_failed`.

Default limits: depth 32, list length 256, string length 4096, variants per styler 64, modifiers per styler 64.

Registry scopes: `animation_on_end`, `icon_data`, `image_provider`, `context_variant_builder`. Registry ids must match `[A-Za-z0-9_-]{1,96}`.

Encode policy: only values that can be represented without losing semantics are encoded. Tokens, directives, multi-source props, closures without registry ids, arbitrary `Curve`s, spring/phase/keyframe animations, and unsupported modifiers fail with stable public errors.

Acceptance gate: `melos bootstrap`, package tests for `mix_schema` and `mix_tailwinds`, `melos run analyze`, `melos run ci`, and guard searches for forbidden imports/discriminator helpers/default-value codecs must pass before completion.
