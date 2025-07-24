### mix_avoid_empty_variants

Avoid creating empty variants directly inside `Style`. Empty variants are essentially useless and can make the code harder to read and understand.

#### Don't

```dart
final a = NamedVariant('a');

final wrong_case = Style(
  a(),
);
```

#### Do

```dart
final correct_case = Style(
  a(
    $box.color.amber(),
  ),
);
```