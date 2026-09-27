# Getting started with Mix

[lib/main.dart](lib/main.dart) is a complete, small example: explicit colors,
named styles, callable widgets, state variants, and an implicit animation.
Click **Save example**, or focus it with Tab and press Enter. Click again to undo.
`Pressable` owns the button's keyboard, pointer, and semantic behavior.

From the repository root, run `melos bootstrap` to use the local Mix checkout.
Then, from this directory:

```sh
flutter run -d chrome
flutter test
```

Without Melos-generated overrides, `flutter pub get` uses published Mix
(`^2.2.0`). This app is not publishable (`publish_to: none`).

For more examples:

- [Snacks](../../../examples/snacks): 30 bite-sized interaction demos, each with
  a complete source file that the gallery can copy for DartPad.
- [Layouts](../../../examples/layouts): responsive WrapBox and GridBox galleries.
- [Example workspace setup](../../../examples): dependencies, tests, and web builds.
