# mix_docs_preview

Flutter preview widgets and manifest for the [Mix](https://github.com/btwld/mix) documentation site.

This package is used by the website to render interactive Flutter previews in the docs. It is not published to pub.dev.

## Structure

The `lib/` layout mirrors the documentation site. When a doc section has multiple preview files, they live in a folder.

- **`lib/overview/`** – Getting started, comparison, utility-first (e.g. `getting_started/hello_mix.dart`).
- **`lib/guides/`** – Styling, directives, design tokens, dynamic styling (variants), animations, gradients. Multi-file sections use subfolders: `animations/`, `design_token/`, `directives/`, `dynamic_styling/`, `gradients/`.
- **`lib/widgets/`** – Box, text, icon, image, flexbox, stack, vbox, pressable, stylewidgets. Multi-file sections use subfolders: `box/`, `text/`, `icon/`, `image/`, `flexbox/`, `stack/`, `vbox/`.
- **`lib/tutorials/`** – Creating context variants, theming, creating a widget (e.g. `creating_a_widget/design_system_button.dart`), controlling widget state.
- **`lib/ecosystem/`** – Ecosystem demos (e.g. `mix_tailwinds.dart`).
- **`lib/components/`** – Shared UI (chip button, scaffold, tokens).
- **`lib/preview_registry.dart`** – Single source of truth for preview IDs and metadata.
- **`tool/generate_previews_manifest.dart`** – Generates `previews-manifest.json` from the registry for the website.
- **`scripts/build_web_previews.sh`** – Builds Flutter web, exports sources, generates the manifest, and optionally copies output to `website/public/previews/`.

## Building previews for the website

From the repo root:

```bash
# Build only (output in packages/mix_docs_preview/build/web/)
bash packages/mix_docs_preview/scripts/build_web_previews.sh --local

# Build and copy to website/public/previews/
bash packages/mix_docs_preview/scripts/build_web_previews.sh
```

CI and Vercel use the same script to produce the preview bundle before building the Next.js site.

## Adding a new preview

1. Add a new Dart file under the doc-matching folder (e.g. `lib/guides/animations/`, `lib/widgets/box/`). Use a new folder when that doc section has more than one file.
2. Register it in `lib/preview_registry.dart`: add a `PreviewEntry` with a doc-scoped `previewId` (e.g. `overview/introduction.0` for the first preview in that doc), `sourcePath` (e.g. `packages/mix_docs_preview/lib/guides/animations/foo.dart`), and `builder`.
3. Re-run the build script so the manifest and sources are updated.
