# Troubleshooting

## Stale results / changes not picked up
**Symptoms**: edits to source don't trigger regeneration, or generated file has outdated content.
**Fix order**:
1. `dart run build_runner clean` then rebuild.
2. Delete `.dart_tool/build/` manually.
3. Check `generate_for` globs — the file may be excluded.
4. If watch mode: restart — some config changes need restart (though 2.9.0+ handles builder-config changes live).

## Conflicting outputs error
**Message**: "Found X declared outputs which already exist on disk..."
**Fix**: Pass `--delete-conflicting-outputs` (or `-d`). Happens after upgrading a generator or changing `build_extensions`.

## "part 'foo.g.dart'; is missing"
**Cause**: user forgot to add `part 'file.g.dart';` to source.
**Prevention**: In your generator, detect the missing part and throw a clear `InvalidGenerationSource` pointing at the library element.

## Analyzer version conflict
**Message**: `version solving failed … analyzer ^11.0.0 required by build_runner …`.
**Fix**:
1. Check build_runner's CHANGELOG for the latest "Allow analyzer X.0.0" entry.
2. Upgrade `build_runner`, `source_gen`, `build`, `analyzer` together.
3. If you pinned analyzer too tight, loosen within the supported range.
4. If a third-party generator is blocking, check if they've published a newer version — retrofit, drift, mockito, json_serializable all break on minor analyzer bumps historically.

## Cycle detected
**Message**: "Cycle in build phase graph".
**Cause**: `required_inputs` / `runs_before` chain loops back.
**Fix**: Draw the phase graph. A builder cannot (directly or transitively) depend on its own output.

## Generator runs on every file → slow builds
**Fix**: Scope `generate_for` in root package's build.yaml:
```yaml
targets:
  $default:
    builders:
      my_pkg|my_gen:
        generate_for: [lib/models/**]
```
Also consider `build_runner build --build-filter="lib/specific/*.dart"` for targeted rebuilds.

## `dart:mirrors` error during AOT
**Cause**: Builder uses reflection, build_runner 2.10+ AOT-compiles builders.
**Fix**: Remove mirrors usage. Use `--force-jit` as temporary escape hatch.

## Resolver returns null or incomplete type
**Cause**: Primary input doesn't transitively import the type you're resolving.
**Fix**: `final isLib = await step.resolver.isLibrary(id);` first. If you need a file not in the import graph, use `readAsString` and parse manually — the resolver won't see it.

## InvalidGenerationSource vs InvalidGenerationSourceError
Source_gen 1.5 renamed the class to `InvalidGenerationSource` (it became an Exception rather than Error). Old typedef preserved. Use the new name. Always pass `element:` for IDE highlighting, and `node:` (AstNode) for even more precise positioning.

## findAssets returns nothing
- It only scans the **current package**. Use `auto_apply: dependents` + cache intermediates + root-package aggregator for cross-package work.
- Your Glob pattern may not match — test with a simple `Glob('lib/**/*.dart')` first.
- You may be using a synthetic input when you shouldn't; `$lib$` runs once, while a regular extension runs per-file.

## Generated file not visible to tests
Use `dart run build_runner test` instead of plain `dart test`. It exposes the cache to the test runner.

## Watch mode rebuild storms
Barrel files cause cascades — changing one export invalidates everything importing the barrel. Use direct imports in annotated files.

## Published package: users can't build
**Cause**: You published without running the build, or you .gitignored the generated files.
**Fix**: For published libraries, **generated code must be included in the publication**. Users installing via pub cannot run build_runner on your sources.

## Private imports / access issues
- `SharedPartBuilder` / `PartBuilder` outputs can access private members of the including library (same library scope).
- `LibraryBuilder` outputs are standalone libraries and CANNOT see private members. If you need private access, choose a part-based builder.
- Part files cannot declare their own imports — all imports go in the user's source file, which is a limitation.
