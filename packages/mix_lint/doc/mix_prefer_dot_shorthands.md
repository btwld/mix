### mix_prefer_dot_shorthands

Prefer Dart's dot shorthand syntax when calling static methods or constructors on types that can be inferred from context. Instead of writing the full type name (e.g. `EdgeInsetsGeometryMix.all(10)` or `TextStyler.color(...)`), use the leading dot (e.g. `.all(10)` or `.color(...)`). This keeps code concise and readable while remaining type-safe.

#### Don't

```dart
final style = BoxStyler()
    .padding(EdgeInsetsGeometryMix.all(10))
```

#### Do

```dart
final style = BoxStyler()
    .padding(.all(10))
```

#### Don't

```dart
final baseStyle = TextStyler()
    .fontWeight(FontWeight.w600)
```

#### Do

```dart
final baseStyle = TextStyler()
    .fontWeight(.w600)
```

#### Don't

```dart
final baseStyle = TextStyler()
    .onHovered(TextStyler.color(Colors.red))
```

#### Do

```dart
final baseStyle = TextStyler()
    .onHovered(.color(Colors.red))
```

