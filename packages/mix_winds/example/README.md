# mix_winds parity playground

This example renders the same UI twice: once with `mix_winds` (Flutter) and once with real Tailwind CSS (HTML). Use it to verify that our class parser stays aligned with upstream Tailwind semantics.

## Requirements

- Dart SDK `>=3.12.0`
- Flutter `>=3.44.0`

## Directory layout

- `lib/main.dart` – Flutter app that drives the lowercase Tailwind-style element functions. A width slider lets you exercise responsive tokens (for example, `md:flex-row`).
- `real_tailwind/index.html` – Standalone CDN-powered Tailwind page that reuses the exact same class strings.
- `real_tailwind/flowbite-card.html` – Flowbite-style card fixture using semantic Tailwind aliases plus a matching `FlowbiteCardPreview` Flutter implementation.
- `real_tailwind/complex-parity.html` – Pinned Tailwind 4.3.1 reference for ten isolated complex utility, responsive, and interaction cases; paired with `ComplexParityPreview`.
- `real_tailwind/advanced-examples.html` – Five product-scale Northstar operations surfaces paired with `AdvancedParityPreview`: launch command, signal analytics, incident room, release timeline, and capacity map.

## Run the Flutter preview

```bash
cd packages/mix_winds/example
flutter pub get
flutter run -d macos   # or chrome/ios/android as needed
```

The slider across the top constrains the preview width between 320 px and 1040 px so you can quickly check behavior below and above the Tailwind `md` breakpoint (768 px).

## Build the public showcase

The web release is a source-backed comparison lab for the five advanced
examples. It keeps the real Tailwind and native Flutter renderers together,
places their exact HTML and Dart source directly below, and exposes captured
parity evidence in a secondary disclosure. A single engine mounts the selected
Flutter example.

First start the screenshot renderer in one terminal:

```bash
cd packages/mix_winds/example
fvm flutter run -d web-server --web-port=8089 --profile
```

Then generate current parity evidence and build the release in another:

```bash
cd packages/mix_winds/tool/visual-comparison
npm ci
npx playwright install chromium # first time only
npm run compare:advanced
npm run showcase:build
npm run showcase:verify
```

The release output is `packages/mix_winds/example/build/web`. The build
fails before publishing if any required 480/768/1024 capture is missing or its
visual acceptance contract did not pass. It also fingerprints the renderer,
fixtures, web sources, dependency locks, and comparison tooling, so changing
any of them requires a fresh `compare:advanced` run. Showcase selections are
linkable with the `example` and `width` URL parameters.

## Run the real Tailwind sample

Open the HTML file directly in a browser (or serve it via any static server):

```bash
cd packages/mix_winds/example
open real_tailwind/index.html
# — or —
python3 -m http.server 5173 --directory real_tailwind
```

The legacy dashboard pulls Tailwind from the official CDN, while the complex
and advanced fixtures use the comparison tool's pinned Tailwind 4.3.1 browser
build. Resize the browser window to the same widths you used in Flutter; every
paired class list is identical between both experiences.

## Visual comparison tool

A Playwright-based tool captures screenshots of both the Flutter and Tailwind versions at canonical widths (480, 768, 1024 px), then diffs them with `pixelmatch`.

1. Start the Flutter web server:

   ```bash
   cd packages/mix_winds/example
   # If you see "not configured to build on the web", run:
   #   flutter create . --platforms=web
   flutter run -d web-server --web-port=8089 --profile
   ```

2. Run the comparison:

   ```bash
   cd packages/mix_winds/tool/visual-comparison
   npm ci        # first time, or whenever package-lock.json changes
   npm test      # acceptance/report unit tests and browser smoke test
   npm run compare
   npm run compare -- --example=card-alert
   npm run compare -- --example=flowbite-card
   npm run compare:advanced # all five advanced examples at 480/768/1024
   npm run compare:complex # all ten cases at 480/768/1024
   ```

Screenshots and diff images are saved to
`packages/mix_winds/visual-comparison/`. Every comparison enforces its
per-width acceptance contract and regenerates the filterable local report at
`visual-comparison/index.html`, including after a failed run.

## Generate Flutter goldens

Render the Flutter surface into golden PNGs (same widths):

```bash
cd packages/mix_winds/example
flutter test --update-goldens test/parity_golden_test.dart
```

The outputs live under `packages/mix_winds/example/test/goldens/`.

## Notes

- The example starts from `TwConfig.standard()`. Screenshot mode pins both the Flutter and Tailwind reference screenshots to the bundled `TwParityRoboto` font so pixel comparisons do not depend on platform system-font metrics.
- `flowbite-card` extends `TwConfig.standard()` locally for Flowbite semantic aliases such as `bg-neutral-primary-soft`, `rounded-base`, and `text-heading`.
- The advanced suite uses only stock Tailwind 4.3.1 utilities and deliberately combines responsive flex layouts, dense typography, gradients, progress bars, status chips, and `button` interaction states.
- `assets/images/flowbite-card-hero.svg` is retained as the editable source artwork; the Flutter and browser fixtures both render its rasterized PNG counterpart.
- `flowbite-card` maps Flowbite inline SVGs to `TwIcon` with Material icon equivalents. This keeps the Flutter side in the `mix_winds` widget model while avoiding a separate SVG/path renderer.
- The components intentionally stick to utilities we already support (layout, spacing, border, radius, typography, responsive prefixes, and hover states on the buttons). If you add more classes to a Flutter example, mirror the change in its matching `real_tailwind/*.html` fixture so comparisons stay 1:1.
