# `@MixWidget` annotation + generator — design

**Date:** 2026-04-23
**Packages affected:** `mix_annotations`, `mix_generator`
**Status:** approved (pending spec review)

## Goal

Introduce a `@MixWidget('Name')` annotation that turns a top-level Styler (a variable or a function returning a Styler) into a generated `StatelessWidget` wrapper. The wrapper's constructor mirrors the underlying signatures, and its `build` method reuses the Styler's existing `call(...)` method as the widget-construction entry point.

The feature eliminates the boilerplate of hand-writing `class Card extends StatelessWidget { ... Box(style: ..., child: child) }` every time a reusable styled component is introduced.

## User-facing API

### Annotation

Defined in `packages/mix_annotations/lib/src/annotations.dart`:

```dart
/// Generates a [StatelessWidget] wrapper around an annotated Styler.
///
/// Apply to a top-level variable whose value is a Styler, or to a top-level
/// function that returns a Styler. The generated widget exposes a constructor
/// that mirrors the source's parameters merged with the Styler's `call(...)`
/// signature, and its `build` method invokes that `call(...)` with the
/// widget's fields.
///
/// When [stylable] is true, the generated widget also accepts an optional
/// `style` parameter of the matching Styler type and merges it into the
/// annotated Styler before invoking `call(...)`.
class MixWidget {
  final String name;
  final bool stylable;
  const MixWidget(this.name, {this.stylable = false});
}
```

Exported via `mix_annotations.dart` alongside the existing annotations.

### Usage examples

#### Variable form (minimal)

```dart
part 'cards.g.dart';

@MixWidget('Card')
final card = BoxStyler()
    .paddingAll(16)
    .borderRounded(8)
    .color(Colors.white)
    .clipBehavior(.hardEdge);
```

Generates:

```dart
class Card extends StatelessWidget {
  final Widget? child;
  const Card({super.key, this.child});

  @override
  Widget build(BuildContext context) => card(child: child);
}
```

(`BoxStyler.call({Key? key, Widget? child})` → `child` is `Widget?`, optional.
The widget constructor mirrors that nullability exactly. `Key? key` is always
folded into `super.key`.)

#### Function form

```dart
@MixWidget('Card1')
BoxStyler createCard(Widget child, {Color color = Colors.white}) => BoxStyler()
    .paddingAll(16)
    .borderRounded(8)
    .color(color)
    .clipBehavior(.hardEdge);
```

Generates:

```dart
class Card1 extends StatelessWidget {
  final Widget child;
  final Color color;
  const Card1({super.key, required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) =>
      createCard(child, color: color)(child: child);
}
```

Notes:
- Positional params in the source (`Widget child`) become **named** params on the widget constructor. `required` is applied if the source param is non-nullable without a default.
- The function's `child` and the styler's `call({Widget? child})` share a name, so they collapse into a single widget field and the field is used in both invocations.

#### `stylable: true`

```dart
@MixWidget('Card', stylable: true)
final card = BoxStyler().paddingAll(16).borderRounded(8);
```

Generates:

```dart
class Card extends StatelessWidget {
  final Widget? child;
  final BoxStyler? style;
  const Card({super.key, this.child, this.style});

  @override
  Widget build(BuildContext context) => card.merge(style)(child: child);
}
```

`MixStyler.merge` accepts a nullable argument, so passing `style = null` is a no-op.

## Architecture

### New generator: `MixWidgetGenerator`

Location: `packages/mix_generator/lib/src/mix_widget_generator.dart`.
Extends `GeneratorForAnnotation<MixWidget>` (from `source_gen`).

Handles two element kinds:

1. `TopLevelVariableElement` — the variable's **resolved static type** is read. It must be a subtype of `Style<T>`.
2. `TopLevelFunctionElement` — the function's **return type** is read. Same constraint.

For any other element kind, emit `InvalidGenerationSource`.

### Signature extraction

For each generator invocation the generator produces two ordered parameter lists:

- **Source params** — from the annotated function (empty for variable form).
- **Call params** — from the `call(...)` method on the Styler class.

Each parameter is represented by a small value object capturing:

- `name` (string)
- `type` (analyzer `DartType`, rendered with `getDisplayString`)
- `isPositional` (bool)
- `isRequired` (bool) — true if non-nullable without default in the source
- `defaultValueCode` (nullable string) — the verbatim default literal, if any

### Merging the two lists

The two lists are merged by **parameter name** to produce the widget's field list:

- If a name appears in both lists, the **source-param** entry wins (this is where user-authored defaults and required-ness live).
- The `Key? key` call param (when present) is dropped from the merged list and is emitted instead as `super.key` on the widget constructor.
- If `stylable: true`, an extra synthetic field named `style` of the Styler's type is appended. The field is nullable and has no default. If a user param is already named `style`, emit `InvalidGenerationSource`.

### Widget emission

For each annotation the generator writes:

1. `class <Name> extends StatelessWidget { ... }` at the top level of the generated part.
2. One `final <Type> <name>;` per merged param (plus `style` when `stylable: true`).
3. A single `const` constructor: `<Name>({super.key, <merged params as named>});`.
   - Required/optional/default follows each param's source description.
4. A single `@override Widget build(BuildContext context)` returning:
   - Variable form: `<varName>[.merge(style)](<callArgs>);`
   - Function form: `<funcName>(<fnArgs>)[.merge(style)](<callArgs>);`
   - `<fnArgs>` preserves the function's positional/named shape using the widget's fields (positional args in declaration order; named args as `name: name`).
   - `<callArgs>` passes each Styler `call(...)` param as `name: name` when named, or as a positional passthrough when the `call` method is positional (e.g. `TextStyler.call(String text)` → `heading(text)`).
   - The `.merge(style)` segment is only emitted when `stylable: true`.

The output is a string fragment appended to the shared part file (one `SharedPartBuilder`).

### Builder wiring

In `packages/mix_generator/lib/mix_generator.dart` add:

```dart
Builder mixWidgetGenerator(BuilderOptions _) {
  return SharedPartBuilder(
    [MixWidgetGenerator()],
    'mix_widget_generator',
    formatOutput: (code, version) =>
        DartFormatter(languageVersion: version).format(code),
  );
}
```

In `packages/mix_generator/build.yaml` add:

```yaml
builders:
  mix_widget_generator:
    import: 'package:mix_generator/mix_generator.dart'
    builder_factories: ['mixWidgetGenerator']
    build_extensions: {'.dart': ['.mix_widget_generator.g.part']}
    auto_apply: dependents
    build_to: cache
    applies_builders: ['source_gen:combining_builder']
```

The new builder is **not** added to the repo-local `targets.$default.builders` block — unlike the three internal builders (which are scoped to `lib/src/specs/**` / `lib/src/properties/**`), `@MixWidget` is user-facing and should be active on any file in a downstream consumer's `lib/`. `auto_apply: dependents` enables that automatically.

## Validation and errors

All errors thrown as `InvalidGenerationSource` with the offending element attached:

- Annotation applied to anything other than a top-level variable or top-level function.
- Resolved type / return type is not a subtype of `Style<T>`.
- Styler class has no `call(...)` method, or declares multiple overloaded `call` methods (Dart doesn't support overloads, so this is guarded implicitly — but we document it).
- `stylable: true` combined with a source parameter named `style`.

## Testing

All tests live in `packages/mix_generator/test/`. Structure mirrors the existing `mix_generator_test.dart` / `styler_generator_test.dart` style: feed source code through `source_gen_test` (or the repo's equivalent harness) and assert on the emitted string.

Cases:

1. **Variable, BoxStyler** — expect `{super.key, Widget? child}` constructor, `build => card(child: child);`.
2. **Variable, TextStyler (positional `call(String text)`)** — expect `{super.key, required String text}`, `build => heading(text);`.
3. **Variable, IconStyler** — expect `{super.key, IconData? icon, String? semanticLabel}`, all optional/nullable.
4. **Variable, FlexBoxStyler (`required List<Widget> children`)** — expect `required List<Widget> children`, `build => row(children: children);`.
5. **Function, overlapping name (`Widget child` in both fn and `call`)** — expect single `child` field, reused in both invocations.
6. **Function, non-overlapping names** — expect all fn params + all call params as separate fields.
7. **Function, positional fn param non-nullable** — expect it emitted as `required` named on the widget constructor.
8. **`stylable: true` on variable form** — expect extra `BoxStyler? style` field, build body includes `.merge(style)`.
9. **`stylable: true` on function form** — same, composed with the function invocation.
10. **Error: annotation on a class** — `InvalidGenerationSource`.
11. **Error: annotated variable's type is not `Style<T>`** — `InvalidGenerationSource`.
12. **Error: `stylable: true` + fn param named `style`** — `InvalidGenerationSource`.

## Out of scope (for this iteration)

- Stateful widgets.
- Annotation on class methods or local variables.
- Custom widget base classes.
- Automatic export / barrel-file aggregation of generated widgets.
- Doc-comment propagation from source to generated widget.

## Open items

None — all clarifying questions resolved during brainstorming.
