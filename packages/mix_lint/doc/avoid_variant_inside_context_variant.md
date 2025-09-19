### mix_avoid_variant_inside_context_variant

`ContextVariant` and the standard `Variant` are applied at different moments during the `Style` lifecycle. Because of this, we strongly recommend that you don't create a `Variant` inside the `ContextVariant`'s scope. Instead, you can combine the `Variant`s using the `&` and `|` operators.

#### Don't

```dart
final variantTest = NamedVariant('test');

Style (
    $box.color.red(),
    $on.hover(
        $box.color.green(),
        variantTest(
            $box.color.blue(),
        )
    ),
)
```

#### Do

```dart
final variantTest = NamedVariant('test');

Style (
    $box.color.red(),
    $on.hover(
        $box.color.green(),
    ),
    ($on.hover & variantTest)(
        $box.color.blue(),
    ),
)
```