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

The example composes styles before `.pressable()`, then passes content and
callbacks to the reusable builder. Press and hold Save to see its pressed color;
Tab to the controls and use Enter or Space to activate them. The callbacks are
empty demonstration actions. The surrounding FlexBox and heading are ordinary
styled widgets.

For all eight supported stylers, native Icon/Image arguments, reuse and release
migration guidance, see the Mix README and
[`pressable-builders-release-audit.md`](../../../guides/pressable-builders-release-audit.md).
