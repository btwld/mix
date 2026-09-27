# Mix example apps

| Example | Package | Teaches |
| --- | --- | --- |
| [Getting started](../packages/mix/example) | `mix_example` | Named styles, callable widgets, state variants, and implicit animation |
| [Snacks](snacks) | `example_snacks` | 30 self-contained, copyable interaction demos |
| [Layouts](layouts) | `example_layouts` | Responsive WrapBox and GridBox galleries |

The [Charts](../packages/mix_chart/example) and
[Winds](../packages/mix_winds/example) examples remain beside their packages.

## Local development

From the repository root:

```sh
melos bootstrap
```

Melos discovers these apps, includes them in Flutter tests and analysis, and
generates ignored `pubspec_overrides.yaml` files pointing to local Mix packages.
Do not commit those generated overrides. All three app manifests declare
`mix: ^2.2.0`, so a clean checkout without overrides resolves published Mix.
Local overrides intentionally take precedence over that version constraint.

Run either gallery from its directory:

```sh
cd examples/snacks # or examples/layouts
flutter run -d chrome
```

Web runners are checked in for all three apps. For another target, generate its
runner locally with `flutter create --platforms=macos .` (or your platform).

## Verification and deployment

```sh
melos exec --scope=example_snacks,example_layouts,mix_example -- flutter analyze
melos exec --scope=example_snacks,example_layouts,mix_example -- flutter test
```

Gallery golden tests reuse the repository's licensed Roboto test font under
`packages/mix_winds/example/assets/fonts`; run them inside this checkout.

All apps have `publish_to: none`: they are runnable apps, not pub.dev packages.
For hosted-dependency validation or deployment, use a fresh checkout and run
`flutter pub get` **without Melos bootstrap** in the app directory. Then run
analysis, tests, and `flutter build web`; deploy the resulting `build/web` folder
to your static host. The CI hosted-examples job checks this path independently
of local overrides. The app version (`1.0.0+1`) need not track Mix's version;
their Mix dependency constraints should stay aligned.
