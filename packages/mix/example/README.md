# Mix example app

One app contains three sections:

- **Basics:** [getting started](lib/basics/getting_started.dart) is still a
  complete standalone lesson in named styles, callable widgets, state variants,
  and implicit animation.
- **Layouts:** interactive [WrapBox and GridBox galleries](docs/layouts.md).
- **Snacks:** [30 self-contained DartPad examples](docs/snacks.md), whose
  exact source is bundled for the gallery's copy action.

From the repository root, run `melos bootstrap` for the local Mix checkout.
Then, from this directory:

```sh
flutter run -d chrome
flutter test
flutter analyze
```

Without Melos-generated overrides, `flutter pub get` resolves published Mix
(`^2.2.0`). This app is not publishable (`publish_to: none`).

The shared shell uses the application-owned Vanilla preset from Remix
`1.0.0-beta.10`, with a small Mix accent in its local theme. The 30 snippets
remain independent Mix examples so they can still be copied directly into
DartPad without Remix or app-local imports.
