# Real-World Generator Architectures

Study these when designing a new generator. Each solves a different problem.

## json_serializable — canonical SharedPartBuilder + GeneratorForAnnotation
- Base: extends `GeneratorForAnnotation<JsonSerializable>`.
- Output: `SharedPartBuilder` → `.json_serializable.g.part` → combining_builder merges into `.g.dart`.
- Extension point: **TypeHelper chain-of-responsibility**. Each helper (BigIntHelper, DateTimeHelper, IterableHelper, MapHelper, ValueHelper…) handles one type family. Tried in order; first match wins.
- Emission: **string templates**, not code_builder.
- Config merging: build.yaml defaults → `@JsonSerializable` → `@JsonKey` per field.
- **Lesson**: for the 90% case (annotate classes, generate helpers), this is the pattern.

## freezed — PartBuilder + custom ParserGenerator
- Output: dedicated `.freezed.dart` via `PartBuilder` (not SharedPartBuilder — it wants its own file).
- Runs before json_serializable (`runs_before: [json_serializable|json_serializable]`).
- Base: custom `ParserGenerator<Freezed>` — **not** `GeneratorForAnnotation`. Why: needs all annotated elements in the library together to understand unions, shared props across constructors, copyWith chains.
- Works with `CompilationUnit` AST, not just Element API.
- Emission: string templates in `templates/` directory.
- **Lesson**: when the output for one class depends on what other classes in the same library look like, subclass `Generator` directly and implement `generate(LibraryReader, BuildStep)`.

## riverpod_generator — SharedPartBuilder with ParserGenerator base
- Same `ParserGenerator` base as freezed (same author: rrousselGit).
- Infers provider kind from return type: `T` → sync, `Future<T>` → future, `Stream<T>` → stream. Function vs class distinguishes notifier style.
- Output → `.g.dart` via combining_builder.
- **Lesson**: return-type-driven generation is clean when your annotation has few options.

## injectable — two-phase aggregation (the canonical DI pattern)
- **Phase 1** (`injectable_builder`): per-file scrape. `@injectable` classes → `.injectable.json` in cache. `auto_apply: dependents`, `build_to: cache`.
- **Phase 2** (`injectable_config_builder`): root-only aggregator. `findAssets(Glob('**/*.injectable.json'))`, validates dependency graph, emits `.config.dart`. `auto_apply: root_package`, `build_to: source`, `required_inputs: [".injectable.json"]`.
- Uses code_builder for Phase 2 emission.
- **Lesson**: this is THE pattern for aggregating across files and packages. The intermediate JSON decouples scanning from aggregation cleanly. Copy this structure for any DI container, registry, or plugin-discovery generator.

## auto_route — analyzer-based aggregation
- User declares route tree in one file: `@AutoRouterConfig()` with explicit type references.
- Generator follows the references through the analyzer to collect `@RoutePage()`-annotated widgets.
- No intermediate files needed because users explicitly list all types.
- Uses **code_builder** (one of the few generators that does).
- **Lesson**: if users can reasonably declare the root of your aggregation, you avoid multi-phase complexity entirely.

## drift — multi-mode generator
- Processes both `.dart` source and its own `.drift` SQL files (via standalone `sqlparser` package).
- Offers multiple build configurations: `SharedPartBuilder` (simple), `drift_dev:analyzer` + `drift_dev:modular` (per-file independent libraries, recommended for larger projects), `drift_dev:not_shared` (middle ground).
- Modular mode generates standalone `.drift.dart` libraries instead of part files — solves the "part files share one library" limitation for big projects.
- **Lesson**: offer modular mode as an option when your generator produces a lot of code per file.

## Pattern summary
| Problem | Reference |
|---|---|
| Per-class helper methods | json_serializable |
| Cross-class library coherence | freezed |
| Return-type-inferred output | riverpod_generator |
| Aggregate across files | injectable |
| Aggregate from a declared root | auto_route |
| Per-file module output | drift modular |

**Observation**: the three largest generators (freezed, json_serializable, riverpod_generator) use **string templates**, not code_builder, for primary output. Code_builder is used mostly by aggregators (injectable, auto_route) where dynamic import management matters more. For your generator, pick based on how dynamic your imports are.
