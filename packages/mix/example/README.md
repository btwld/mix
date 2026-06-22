# mix_example

A small demo app for Mix shadow styling.

It shows the two ways to apply shadow lists with the styler shadow methods
(`BoxStyler.boxShadows` / `BoxStyler.shadows` / `TextStyler.shadows`):

1. **Literal lists** — pass a `List<BoxShadowMix>` / `List<ShadowMix>` directly.
2. **Design tokens** — define a `BoxShadowToken` / `ShadowToken`, bind its value
   once in a `MixScope`, and pass `token.mix()` (a `BoxShadowListMix` /
   `ShadowListMix` reference) straight into the same method.

See [`lib/main.dart`](lib/main.dart).

## Run

```bash
flutter run        # from packages/mix/example
flutter test       # widget smoke test
```

The in-repo `mix` / `mix_annotations` packages are wired via `dependency_overrides`
in `pubspec.yaml`, so the example builds without `melos bootstrap`.
