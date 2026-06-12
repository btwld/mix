# Development Workflow

Creating, modifying, and maintaining specs in the Mix monorepo.

## Monorepo Structure

```text
packages/
  mix/                    # Core framework
  mix_annotations/        # Annotations for codegen
  mix_generator/          # build_runner generator
  mix_lint/               # Analysis server plugin
  mix_lint_test/          # Lint rule tests
  mix_tailwinds/          # Tailwind utility layer
  mix_tailwinds/example/  # Tailwind example app
```

**SDK constraints:** Dart >=3.11.0, Flutter >=3.41.0

## Creating a New Widget-Backed Spec

Follow `packages/mix/lib/src/specs/box/` as the canonical reference.

### Step 1: Create the Spec Class

**File:** `packages/mix/lib/src/specs/<name>/<name>_spec.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../generated_styler_support.dart';
import '<name>_widget.dart';

part '<name>_spec.g.dart';

@MixableSpec(target: Foo.new)
@immutable
final class FooSpec with _$FooSpec {
  @override
  final Color? color;
  @override
  final double? size;

  const FooSpec({this.color, this.size});
}
```

Key rules:

- Use `@MixableSpec(target: Foo.new)` when the spec has a widget target.
- Use `final class FooSpec with _$FooSpec`.
- Fields are nullable, final, resolved spec values; most are Flutter value types, but some specs include Mix runtime values such as directives.
- Include `part '<name>_spec.g.dart'`.
- Add `@MixableField(...)` only when the generated Styler needs field-specific behavior.

### Step 2: Create the Widget

**File:** `packages/mix/lib/src/specs/<name>/<name>_widget.dart`

```dart
import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/style_widget.dart';
import '<name>_spec.dart';

class Foo extends StyleWidget<FooSpec> {
  const Foo({
    super.style = const IdentityStyle(FooSpec()),
    super.styleSpec,
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context, FooSpec spec) {
    return SomeFlutterWidget(
      color: spec.color,
      child: child,
    );
  }
}
```

The generated `FooStyler` will live in `<name>_spec.g.dart`; do not create a separate `<name>_style.dart` unless intentionally maintaining a legacy handwritten Styler.

### Step 3: Run Code Generation

```bash
melos run gen:build
```

This generates `<name>_spec.g.dart`, including `_$FooSpec` and, for `target: Foo.new`, `FooStyler`.

### Step 4: Update Exports

```bash
melos run exports
```

Regenerates `packages/mix/lib/mix.dart`.

## Modifying an Existing Spec

1. Add/remove/change fields in the spec file.
2. Update the widget's `build()` method if the resolved spec changes rendering.
3. Add or adjust `@MixableField(...)` metadata if the generated Styler surface needs custom factory/mixin behavior.
4. Run `melos run gen:build`.
5. Run `melos run ci && melos run analyze`.

Generated Stylers are not edited directly. Edit the spec annotation, fields, widget target, or generator inputs instead.

## Commands Reference

| Command | Purpose |
|---------|---------|
| `melos bootstrap` | Install all dependencies |
| `melos run gen:build` | Clean + regenerate all `*.g.dart` files |
| `melos run gen:watch` | Watch mode for codegen |
| `melos run gen:clean` | Clean generated outputs |
| `melos run ci` | Run all tests (flutter + dart) |
| `melos run test:flutter` | Flutter tests only |
| `melos run test:dart` | Dart tests only |
| `melos run test:coverage` | Tests with coverage report |
| `melos run analyze` | Dart + DCM analysis |
| `melos run fix` | Auto-fix lint issues |
| `melos run exports` | Regenerate `mix.dart` barrel file |
| `melos run api-check` | API compatibility checking |

## Pre-Commit Verification

```bash
melos run gen:build && melos run ci && melos run analyze
```

Always run this before committing changes that touch specs, stylers, generated code, runtime behavior, or shared APIs.

## Adding Type Metadata

When creating Mix types for new Flutter types, update the generator's curated metadata:

**File:** `packages/mix_generator/lib/src/core/curated/type_metadata.dart`

Add or update:

- `typeMetadata` entry keyed by analyzer display name
- `TypeMetadata.mixType` when the Flutter type has a Mix counterpart
- `TypeMetadata.ownerMixins` for generated fluent method ownership
- `TypeCategory` for lerp/snapping behavior
