# Callable pressable builders

This example uses the Mix source in the parent directory. The callable API is
unreleased and is not available in Mix 2.2.1. Use Flutter 3.44.0 or newer.

From this directory:

```sh
flutter pub get
flutter run -d chrome
```

To verify the web build without launching a browser:

```sh
flutter build web
```

The example composes styles before `.pressable()`, assigns each callable to a
variable, and calls it to build the widget. Press and hold Save to see its
pressed color; Tab to the controls and use Enter or Space to activate them.
The callbacks are empty demonstration actions. `column`, `heading`, and
`buttonLabel` are ordinary callable stylers.

Visible button text supplies its accessible label. Add `semanticsLabel` when
the content does not supply one; repeating the same label makes it spoken twice.

For all eight supported stylers, native Icon/Image arguments, and builder reuse,
see the [Mix README](../README.md) and
[`api-composition-guidelines.md`](../../../guides/api-composition-guidelines.md).
