### mix_avoid_defining_tokens_within_scope

Ensure that `MixToken` instances are not created directly inside `MixScope` constructors. Define tokens outside (e.g. top-level or as local constants), then use them as keys in the scope’s maps.

The scope maps tokens to resolved values; the tokens themselves should already exist. Creating them inline makes them unreferenceable elsewhere and can lead to duplication.

#### Don't

```dart
MixScope(
  colors: {
    ColorToken('primary'): Colors.blue,
  },
  child: child,
);
```

#### Do

```dart
final primary = ColorToken('primary');

MixScope(
  colors: {
    primary: Colors.blue,
  },
  child: child,
);
```
