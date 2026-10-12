# Mix showcase

One app contains four catalog sections:

- **Core widgets:** focused, runnable [Box, Text, Image, and Pressable files](lib/examples/core/).
- **Layouts:** focused [FlexBox, WrapBox, and GridBox files](lib/examples/layouts/)
  plus deeper [interactive galleries](docs/layouts.md).
- **Snacks:** [31 self-contained DartPad examples](docs/snacks.md), with
  category filters and a copy-source action.
- **Charts:** focused [Line, Bar, and Pie examples](lib/examples/charts/)
  backed by `mix_chart`.

The home page is a compact catalog of static previews in `assets/previews/`.
Regenerate the three Layout previews after changing their compositions with
`fvm flutter test tool/generate_layout_previews_test.dart`.
Each layout card opens one interactive example with its code beside it:
GridBox offers width and content controls, and FlexBox and WrapBox follow
the same pattern on their own pages. The layouts index lists the three
primitives without
mounting every demo. The Snacks page leads with four live, code-paired
examples (one per group), keeps the remaining examples in a lightweight
directory, and opens each in a larger detail view. The visible code omits
the standalone app shell and starts with the example's widget before its
supporting styles. **Copy code** copies the complete standalone file; the
Snacks files are DartPad-ready. Catalog metadata lives in
[catalog.dart](lib/catalog/catalog.dart); the shell lives in [main.dart](lib/main.dart).
Each live preview and copied source use the same file. The 31 Snacks live
as flat, standalone files under `lib/examples/snacks/`; their metadata is in
`lib/snacks/catalog.dart`.

The Remix CLI requires the repository's pinned Flutter 3.44.0 toolchain.
From the repository root, run `fvm exec melos bootstrap` for the local Mix
checkout. Then, from this directory:

```sh
fvm flutter run -d chrome
fvm flutter test
fvm flutter analyze --no-fatal-infos
```

Without Melos-generated overrides, `flutter pub get` resolves published Mix
(`^2.2.0`). This app is not publishable (`publish_to: none`).

The shell uses the application-owned **Vanilla** preset from Remix
`1.0.0-beta.10`: `UiButton`, `UiBadge`, `UiCard`, and `UiThemeScope` under
`lib/ui/`. Its local light theme carries the catalog's blue accent. The Snacks
remain independent Mix examples so they can still be copied into DartPad
without Remix or app-local imports.
