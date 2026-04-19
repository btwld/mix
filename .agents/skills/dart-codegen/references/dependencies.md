# Cross-File Dependencies & Phase Ordering

## How phases work
build_runner computes a global DAG of builders from `required_inputs`, `runs_before`, and `applies_builders`. Builders in the same phase run in parallel on different inputs. A builder sees only outputs from earlier phases. Cycles fail at startup.

## Reading another generator's output

### Step 1: declare the dependency
```yaml
b_builder:
  required_inputs: [".g.dart"]   # waits for any builder producing .g.dart
  runs_before: []                # no targeted ordering needed
```

### Step 2: read it
```dart
class BBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {".dart": [".final.dart"]};

  @override
  Future<void> build(BuildStep step) async {
    final gDartId = step.inputId.changeExtension('.g.dart');
    if (!await step.canRead(gDartId)) return;
    // Full semantic resolution — only works because phase ordering guaranteed A ran.
    final lib = await step.resolver.libraryFor(gDartId);
    // walk lib.classes, lib.topLevelFunctions, etc.
  }
}
```

**Resolver caveat**: `libraryFor` only resolves code transitively imported from the primary input. If you want to resolve a file not imported by your input, read it as a string or ensure it's reachable via imports.

## Aggregation pattern (the injectable pattern — most robust)

Two builders. One per-file (scrapes, writes intermediate cache file). One root-only (discovers all intermediates, emits combined output).

```dart
// Phase 1: emits foo.di.json per annotated file
class ScraperBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {".dart": [".di.json"]};

  @override
  Future<void> build(BuildStep step) async {
    if (!await step.resolver.isLibrary(step.inputId)) return;
    final lib = await step.inputLibrary;
    final entries = _findAnnotatedClasses(lib);
    if (entries.isEmpty) return;
    await step.writeAsString(
      step.inputId.changeExtension('.di.json'),
      jsonEncode(entries),
    );
  }
}

// Phase 2: aggregates all .di.json → di.config.dart
class ConfigBuilder implements Builder {
  static final _manifests = Glob('lib/**/*.di.json');

  @override
  Map<String, List<String>> get buildExtensions => {r'$lib$': ['di.config.dart']};

  @override
  Future<void> build(BuildStep step) async {
    final all = <Map<String, dynamic>>[];
    await for (final id in step.findAssets(_manifests)) {
      all.addAll(jsonDecode(await step.readAsString(id)) as List);
    }
    final code = _emitConfig(all); // use code_builder here
    await step.writeAsString(
      AssetId(step.inputId.package, 'lib/di.config.dart'),
      code,
    );
  }
}
```

With build.yaml:
```yaml
builders:
  scraper:
    auto_apply: dependents
    build_to: cache
    build_extensions: {".dart": [".di.json"]}
  config:
    auto_apply: root_package
    build_to: source
    build_extensions: {"$lib$": ["di.config.dart"]}
    required_inputs: [".di.json"]
```

## Why `$lib$` synthetic input
`$lib$`, `$test$`, `$package$` are synthetic placeholders. Using one tells build_runner "run me exactly once per package against the whole directory." Without it, an aggregator would trigger per-file and duplicate work.

## findAssets scope
Only returns files **in the current package**. For cross-package aggregation, intermediate files must be emitted per-package (using `auto_apply: dependents`) and then discovered by a root-package builder. `findAssets` during a root_package build will find files in dependency packages only if they were emitted to `build_to: cache` by a dependents-applied builder.

## Hard rules
- Cannot `required_inputs` an extension you also produce (self-cycle).
- Cannot read your own output in the same phase. If multi-pass needed, split into two builders with `runs_before`.
- `build_to: source` only runs on root package; `auto_apply: root_package` is the natural pairing.
- Declaring `applies_builders` triggers companion activation; `runs_before` alone doesn't activate anything.
