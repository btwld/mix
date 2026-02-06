# mix_tailwinds parity playground

This example renders the same UI twice: once with `mix_tailwinds` (Flutter) and once with real Tailwind CSS (HTML). Use it to verify that our class parser stays aligned with upstream Tailwind semantics.

## Requirements

- Dart SDK `>=3.10.0`
- Flutter `>=3.38.1`

## Directory layout

- `lib/main.dart` – Flutter app that drives the Mix `Div`/`Span` widgets. A width slider lets you exercise the responsive tokens (e.g., `md:flex-row`).
- `real_tailwind/index.html` – Standalone CDN-powered Tailwind page that reuses the exact same class strings.

## Run the Flutter preview

```bash
cd packages/mix_tailwinds/example
flutter pub get
flutter run -d macos   # or chrome/ios/android as needed
```

The slider across the top constrains the preview width between 320 px and 1040 px so you can quickly check behavior below and above the Tailwind `md` breakpoint (768 px).

## Run the real Tailwind sample

Open the HTML file directly in a browser (or serve it via any static server):

```bash
cd packages/mix_tailwinds/example
open real_tailwind/index.html
# — or —
python3 -m http.server 5173 --directory real_tailwind
```

Because the document pulls Tailwind from the official CDN, no extra tooling is required. Resize the browser window to the same widths you used in the Flutter app; every class list is identical between both experiences.

## Visual comparison tool

A Playwright-based tool captures screenshots of both the Flutter and Tailwind versions at canonical widths (480, 768, 1024 px), then diffs them with `pixelmatch`.

1. Start the Flutter web server:

   ```bash
   cd packages/mix_tailwinds/example
   flutter run -d web-server --web-port=8089 --profile
   ```

2. Run the comparison:

   ```bash
   cd packages/mix_tailwinds/tool/visual-comparison
   npm install   # first time only
   npm run compare
   ```

Screenshots and diff images are saved to `packages/mix_tailwinds/visual-comparison/`.

## Generate Flutter goldens

Render the Flutter surface into golden PNGs (same widths):

```bash
cd packages/mix_tailwinds/example
flutter test --update-goldens test/parity_golden_test.dart
```

The outputs live under `packages/mix_tailwinds/example/test/goldens/`.

## Notes

- All color, spacing, radius, and typography tokens come from `TwConfig.standard()`, so helping parity means updating a single config map.
- The components intentionally stick to utilities we already support (layout, spacing, border, radius, typography, responsive prefixes, and hover states on the buttons). If you add more classes to the Flutter example, mirror the change in `real_tailwind/index.html` so comparisons stay 1:1.
