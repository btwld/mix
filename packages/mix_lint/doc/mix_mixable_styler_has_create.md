iml### mix_mixable_styler_has_create

Ensures that every class annotated with `@MixableStyler` defines a named constructor `.create`. The generated Styler mixin and the rest of the Mix API expect this constructor for const instantiation, merging, and default styles (e.g. `const BoxStyler.create()`).

#### Don't

```dart
@MixableStyler()
class MyStyler extends Style<MySpec> with _$MyStylerMixin {
  final Prop<Color>? $color;

  MyStyler({Prop<Color>? color}) : $color = color;
}
```

#### Do

```dart
@MixableStyler()
class MyStyler extends Style<MySpec> with _$MyStylerMixin {
  final Prop<Color>? $color;

  const MyStyler.create({
    Prop<Color>? color,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color;

  MyStyler({Color? color, ...}) : this.create(color: Prop.maybe(color), ...);
}
```
