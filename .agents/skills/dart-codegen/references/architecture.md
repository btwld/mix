# Architecture & Package Responsibilities

## The stack
- **build_runner** (CLI orchestrator): `build`, `watch`, `serve`, `clean`, `test`. Flags: `--delete-conflicting-outputs` (`-d`), `--force-aot`, `--workspace`, `--build-filter`, `--verbose-durations`.
- **build**: `Builder`, `BuildStep`, `AssetId` (`package|path`), `Resolver`. BuildStep implements AssetReader + AssetWriter.
- **source_gen**: `Generator`, `GeneratorForAnnotation<T>`, `SharedPartBuilder`, `PartBuilder`, `LibraryBuilder`, `combining_builder`, `ConstantReader`, `TypeChecker`, `LibraryReader`, `InvalidGenerationSource`.
- **code_builder**: `Class`, `Method`, `Field`, `Constructor`, `Extension`, `Mixin`, `Library`, `Reference`, `TypeReference`, `refer()`, `Expression`, `Code`, `DartEmitter`, `Allocator`.
- **analyzer**: `LibraryElement`, `ClassElement`, `MethodElement`, `FieldElement`, `DartType`, `InterfaceType`. Tight version coupling — breaks in minor releases.
- **dart_style**: `DartFormatter(languageVersion:)`. Required param in 3.x.
- **build_test**: `testBuilder`, `TestReaderWriter`, `resolveSource`.

## Builder type decision
| Need | Use |
|---|---|
| Standard .g.dart co-generated with other builders | `SharedPartBuilder` + `GeneratorForAnnotation` |
| Dedicated extension (.freezed.dart), still a part file | `PartBuilder` |
| Standalone importable library (own imports) | `LibraryBuilder` |
| Aggregate many files → one output | raw `Builder` + synthetic input + `findAssets` |
| Non-Dart output (SQL, JSON, proto) | raw `Builder` |
| Cleanup/compression after builds | `PostProcessBuilder` |

`SharedPartBuilder` requires `build_to: cache` and `applies_builders: ["source_gen|combining_builder"]`. The `partId` constructor arg prefixes the intermediate `.g.part` to avoid collisions.

`PartBuilder` must NOT use `.g.dart` extension (conflicts with combining_builder). Use your own like `.freezed.dart`.

`LibraryBuilder` cannot see private members of the user's source library — use part-based builders when private access is needed.

## The two-package pattern (mandatory)
- `foo_annotation/` — runtime dependency. Only annotation classes. No analyzer. No source_gen.
- `foo_generator/` — dev dependency. Depends on analyzer, source_gen, build, code_builder.
- User pubspec: `dependencies: foo_annotation: ...`  +  `dev_dependencies: foo_generator: ..., build_runner: ...`

Every major generator follows this: json_annotation+json_serializable, freezed_annotation+freezed, riverpod_annotation+riverpod_generator, injectable+injectable_generator, auto_route+auto_route_generator.

## Output location
- `build_to: cache` → hidden in `.dart_tool/build/`. For intermediates.
- `build_to: source` → next to inputs. Only runs on root package. For final user-facing files.

## auto_apply
- `none` — explicit opt-in required
- `dependents` — any package depending on generator package (standard for per-file generators)
- `all_packages` — entire dep graph
- `root_package` — only the top-level app (for aggregating builders with `build_to: source`)
