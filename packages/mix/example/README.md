# BoxStyler.pressable example

This example uses the local `mix` package in the parent directory. Requires
Flutter 3.44.0 or newer.

From this directory:

```sh
flutter pub get
flutter run -d chrome
```

To verify the web build without launching a browser:

```sh
flutter build web
```

The example composes a `BoxStyler` and calls `button.pressable(onPress: ..., child: ...)` to construct a `PressableBox`. Press and hold Save to see its pressed color, or focus it with Tab and activate it with Enter or Space.

See the [Mix README](../README.md) and [`api-composition-guidelines.md`](../../../guides/api-composition-guidelines.md) for more composition patterns.
