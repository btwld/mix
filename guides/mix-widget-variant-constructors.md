# MixWidget variant constructors

**Shipped:** [#968](https://github.com/btwld/mix/pull/968), 2026-07-11.
The [architecture decision log](../ARCHITECTURE.md#mixwidget-variant-constructors)
records the rationale and rejected alternatives. This page describes generation.

## Detection and output

A recipe function with a named, nonnullable enum parameter literally named
`variant` generates one constructor per accessible enum constant **alongside**
the unnamed constructor. Required, optional, and defaulted parameters all work;
the enum does not need `EnumVariant` or another Mix mixin.

```dart
enum ButtonVariant { solid, soft, outline }

// In a recipe annotated with @MixWidget(target: RemixButton.new):
ButtonStyler buttonStyle({ButtonVariant variant = .solid}) => switch (variant) {
  .solid => ButtonStyler().color(Colors.blue),
  .soft => ButtonStyler().color(Colors.blue.shade100),
  .outline => ButtonStyler().color(Colors.transparent),
};
```

The generated widget offers `.solid()`, `.soft()`, `.outline()`, and an unnamed
constructor accepting `variant:` for dynamic selection. Named constructors pin
and omit `variant`; the unnamed constructor retains the recipe's default.

Generation rules:

- A top-level style variable has no parameters and generates no variant constructors.
- `variant` must survive the current `factoryParameters` curation.
- Public enum constants and constants in the recipe's own library are eligible.
- Constant docs and deprecation annotations propagate to constructors.
- A constant name colliding with a generated widget type parameter suppresses
  **all** variant constructors, preserving legal Dart and existing builds.
- Other enum parameters remain parameters; there is no size×variant cross-product.

A plain enum is a recipe switch key here, not a runtime named style variant.
The recipe runs on the generated widget's parent rebuild; widget-state changes
inside `StyleBuilder` resolve the existing style without invoking the recipe.

## Parameter curation is still the current API

`widgetParameters` curates target constructor / styler `call()` parameters;
`factoryParameters` curates recipe function parameters. Required recipe
parameters cannot be hidden. Omitting an optional `variant` through curation
silently prevents named constructors.

The [pending proposal](../ARCHITECTURE.md#recipe-parameter-curation) to remove
`factoryParameters` and rename `widgetParameters` to `targetParameters` remains
**unimplemented**. Its old beta target is not current release guidance.
For annotation and generated API examples, see the
[generator README](../packages/mix_generator/README.md) and
[code-generation reference](../skills/mix/references/code-generation.md).
