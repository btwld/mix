# mix_lint

Lint rules and quick fixes for [Mix](https://github.com/btwld/mix), the Flutter styling framework. `mix_lint` is an analyzer plugin: it reports problems in your IDE and in `dart analyze` / `flutter analyze`.

Requires Dart 3.12 or later (Flutter 3.44 or later).

## Setup

Add the plugin to the top-level `plugins` section of your `analysis_options.yaml`. You do not need to add `mix_lint` to `pubspec.yaml`; the analysis server downloads it.

```yaml
plugins:
  mix_lint: ^2.0.0
```

Then restart the analysis server (or your IDE). Restart it again after any change to the `plugins` section.

## Rules

Warnings catch bugs and are on by default. Lints enforce Mix style and are off until you enable them.

| Rule | Kind | Fix | Checks that |
|---|---|---|---|
| [`missing_create_constructor`](#missing_create_constructor) | Warning | | `@Mixable` and `@MixableStyler` classes have a `.create` constructor |
| [`token_reference_outside_mix`](#token_reference_outside_mix) | Warning | | token references are only passed to Mix APIs |
| [`base_style_after_variant`](#base_style_after_variant) | Lint | | base style calls come before variants |
| [`inline_token_definition`](#inline_token_definition) | Lint | | tokens are not created inside Stylers or `MixScope` |
| [`long_styler_chain`](#long_styler_chain) | Lint | | Styler chains stay short |
| [`unnecessary_styler_constructor`](#unnecessary_styler_constructor) | Lint | Yes | nested Stylers use factory shorthands, such as `.color(...)` |
| [`unnecessary_type_name`](#unnecessary_type_name) | Lint | Yes | Styler arguments use dot shorthands |
| [`variants_without_base_style`](#variants_without_base_style) | Lint | | Stylers set a base style before variants |

### Enable lints and change severity

List rules under `diagnostics`. Use `true` to enable a lint with its default severity, `error`, `warning`, or `info` to set the severity, and `false` to turn off a rule (including a warning).

```yaml
plugins:
  mix_lint:
    version: ^2.0.0
    diagnostics:
      base_style_after_variant: true
      inline_token_definition: true
      long_styler_chain: true
      unnecessary_styler_constructor: true
      unnecessary_type_name: true
      variants_without_base_style: true
      token_reference_outside_mix: error
```

### Suppress a diagnostic

Prefix the rule name with the plugin name:

```dart
// ignore: mix_lint/base_style_after_variant
final style = BoxStyler().onHovered(.color(Colors.blue)).padding(.all(16));
```

Use `// ignore_for_file: mix_lint/<rule>` for a whole file.

Plugins skip files excluded in `analysis_options.yaml`. To keep lints out of generated code:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
```

### Configure rules

Analyzer plugins cannot read rule options from `analysis_options.yaml`. To change a setting, such as the `long_styler_chain` limit, create a small local plugin package:

```yaml
# tool/my_mix_lint/pubspec.yaml
name: my_mix_lint
publish_to: none
environment:
  sdk: ^3.12.0
dependencies:
  mix_lint: ^2.0.0
```

```dart
// tool/my_mix_lint/lib/main.dart
import 'package:mix_lint/mix_lint.dart';

final plugin = MixLintPlugin(
  config: const MixLintConfig(maxStylerChainLength: 20),
);
```

Then enable it by path instead of `mix_lint`. Its rules are namespaced by the new plugin name, for example `// ignore: my_mix_lint/long_styler_chain`.

```yaml
plugins:
  my_mix_lint:
    path: tool/my_mix_lint
    diagnostics:
      long_styler_chain: true
```

## Rule reference

### missing_create_constructor

**Warning.** A class annotated with `@Mixable` or `@MixableStyler` has no `.create` constructor. The generated `merge()` method calls `.create`, so the generated code does not compile without it. The rule stays silent when the annotation turns off `merge()` generation (for example `methods: GeneratedMixMethods.skipMerge`).

Don't:

```dart
@Mixable()
final class ShadowMix extends Mix<Shadow> with Diagnosticable, _$ShadowMixMixin {
  final Prop<Color>? $color;

  ShadowMix({Color? color}) : $color = Prop.maybe(color);
}
```

Do:

```dart
@Mixable()
final class ShadowMix extends Mix<Shadow> with Diagnosticable, _$ShadowMixMixin {
  final Prop<Color>? $color;

  ShadowMix({Color? color}) : this.create(color: Prop.maybe(color));

  const ShadowMix.create({Prop<Color>? color}) : $color = color;
}
```

For new Stylers, prefer `@MixableSpec(target: Widget.new)`; `@MixableStyler` is deprecated.

### token_reference_outside_mix

**Warning.** Calling a token (`$primary()`, `$primary.call()`, or `$body.mix()`) creates a token reference. A reference only resolves inside Mix, against the surrounding `MixScope`. Passed to a Flutter widget or any other API outside Mix, it never resolves.

The rule reports only APIs from other packages, such as Flutter widgets and `dart:core`. It accepts any API that Mix declares and any Mix value type, including types generated in your package. It also stays silent for functions and widgets in your own package, because they may forward the value into Mix. To read a concrete value outside Mix, use `token.resolve(context)`.

Don't:

```dart
final $primary = ColorToken('primary');

Container(color: $primary());
```

Do:

```dart
final $primary = ColorToken('primary');

Box(style: BoxStyler().color($primary()));
Container(color: $primary.resolve(context));
```

The check is syntactic: a reference stored in a variable first (`final c = $primary(); Container(color: c);`) is not detected.

### base_style_after_variant

A base style call, such as `padding()`, comes after a variant, such as `onHovered()`. Keep base style first and variants last so the default appearance reads in one place. `animate()`, `keyframeAnimation()`, `phaseAnimation()`, `wrap()`, `merge()`, and `applyVariants()` may follow variants.

Don't:

```dart
final style = BoxStyler()
    .color(Colors.red)
    .onHovered(.color(Colors.blue))
    .padding(.all(16));
```

Do:

```dart
final style = BoxStyler()
    .color(Colors.red)
    .padding(.all(16))
    .onHovered(.color(Colors.blue))
    .animate(.easeInOut(200.ms));
```

### inline_token_definition

A design token is created inside a Styler chain or a `MixScope`. Tokens are meant to be shared: define each one once and reference it.

Don't:

```dart
final style = BoxStyler().color(ColorToken('primary')());

MixScope(
  colors: {ColorToken('primary'): Colors.blue},
  child: child,
);
```

Do:

```dart
final $primary = ColorToken('primary');

final style = BoxStyler().color($primary());

MixScope(
  colors: {$primary: Colors.blue},
  child: child,
);
```

### long_styler_chain

A Styler chain has more calls than the limit (15 by default). Split large styles into smaller Stylers and combine them with `merge()`. To change the limit, see [Configure rules](#configure-rules).

Do:

```dart
final layout = BoxStyler().padding(.all(8)).margin(.all(4)).alignment(.center);
final surface = BoxStyler().color(Colors.blue).borderRadius(.circular(8));

final card = layout.merge(surface).onHovered(.color(Colors.red));
```

### unnecessary_styler_constructor

An empty Styler constructor starts a chain where the factory shorthand would do. Has a quick fix, including "fix all in file".

The rule reports:

- `BoxStyler().color(...)` passed to another Styler method, such as a variant, where the parameter type is `BoxStyler`;
- `.new().color(...)` anywhere.

Both become `.color(...)`. Every generated Styler setter has a matching factory, so the result is the same.

Don't:

```dart
final style = BoxStyler()
    .color(Colors.white)
    .onHovered(BoxStyler().color(Colors.blue));

final BoxStyler card = .new().padding(.all(16));
```

Do:

```dart
final style = BoxStyler()
    .color(Colors.white)
    .onHovered(.color(Colors.blue));

final BoxStyler card = .padding(.all(16));
```

Top-level declarations such as `final style = BoxStyler()...` keep the constructor, and so do widget arguments such as `Box(style: BoxStyler()...)`, whose parameter type (`Style<BoxSpec>`) gives a dot shorthand nothing to resolve against. The rule stays silent when the first call has no factory, or when the factory would not accept the same arguments.

### unnecessary_type_name

An argument in a Styler expression names a type that dot shorthand can infer from the parameter type. A Styler expression is an argument of a Styler call, or of a Mix call nested inside one. Has a quick fix, including "fix all in file".

Don't:

```dart
BoxStyler().padding(EdgeInsetsGeometryMix.all(16));
TextStyler().fontWeight(FontWeight.w600);
BoxStyler().onNot(.widgetState(WidgetState.hovered), .color(Colors.grey));
```

Do:

```dart
BoxStyler().padding(.all(16));
TextStyler().fontWeight(.w600);
BoxStyler().onNot(.widgetState(.hovered), .color(Colors.grey));
```

The rule only reports a static member or named constructor of the parameter's exact type, because that is where dot shorthand looks it up. It does not report:

- members of another type, such as `Colors.blue` for a `Color` parameter;
- unnamed constructors, such as `BoxShadowMix(...)`;
- Mix code outside Styler expressions, such as `final v = ContextVariant.widgetState(WidgetState.hovered);`;
- code with a language version below 3.10.

### variants_without_base_style

A Styler chain adds variants but sets no base style, so the style has no default appearance. A chain that uses `onBuilder()` is allowed, because it builds the whole style from context.

Don't:

```dart
final style = BoxStyler()
    .onHovered(.color(Colors.blue))
    .onPressed(.color(Colors.green));
```

Do:

```dart
final style = BoxStyler()
    .color(Colors.grey)
    .onHovered(.color(Colors.blue))
    .onPressed(.color(Colors.green));
```

## Renamed rules

`mix_lint` 2.0.0 used the names below. If you configured or ignored them, update `analysis_options.yaml` and your `ignore` comments:

| 2.0.0 name | Current name |
|---|---|
| `mix_avoid_defining_tokens_within_style` | `inline_token_definition` |
| `mix_avoid_defining_tokens_within_scope` | `inline_token_definition` |
| `mix_avoid_token_ref_outside_mix` | `token_reference_outside_mix` |
| `mix_avoid_empty_variants` | `variants_without_base_style` |
| `mix_max_number_of_attributes_per_style` | `long_styler_chain` |
| `mix_mixable_styler_has_create` | `missing_create_constructor` |
| `mix_prefer_dot_shorthands` | `unnecessary_type_name` |
| `mix_variants_last` | `base_style_after_variant` |
