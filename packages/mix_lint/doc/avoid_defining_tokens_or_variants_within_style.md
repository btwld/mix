### mix_avoid_defining_tokens_or_variants_within_style

Ensure that `Variant` and `MixToken` instances are not created directly inside Style constructors. Instead, instantiate Variant and `MixToken` outside of Style constructors.

`Variant`s and `MixToken`s should be shared across the application. If they are created inside a `Style`, it means that they are local to the `Style`, and it will be harder to reuse them.

#### Don't

```dart
Style(
    const Variant('example')(
        $text.textAlign.center(),
        $box.height(200),
        $box.width(200),
    ),
)
```

```dart
Style(
    $box.color.ref(ColorToken('primary')),
)
```

#### Do

```dart
final example = NamedVariant('example');

Style(
    example(
        $text.textAlign.center(),
        $box.height(200),
        $box.width(200),
    ),
)
```

```dart
final primary = ColorToken('primary');

Style(
    $box.color.ref(primary),
)
```