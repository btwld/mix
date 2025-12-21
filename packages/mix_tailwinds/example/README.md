# mix_tailwinds parity playground

This example renders the same UI twice: once with `mix_tailwinds` (Flutter) and once with real Tailwind CSS (HTML). Use it to verify that our class parser stays aligned with upstream Tailwind semantics.

## Directory layout

- `lib/main.dart` – Flutter app that drives the Mix `Div`/`Span` widgets. A width slider lets you exercise the responsive tokens (e.g., `md:flex-row`).
- `real_tailwind/index.html` – Standalone CDN-powered Tailwind page that reuses the exact same class strings.

## Run the Flutter preview

```bash
cd packages/mix_tailwinds/example
flutter pub get
flutter run -d macos   # or chrome/ios/android as needed
```

The slider across the top constrains the preview width between 320 px and 1040 px so you can quickly check behavior below and above the Tailwind `md` breakpoint (768 px).

## Run the real Tailwind sample

Open the HTML file directly in a browser (or serve it via any static server):

```bash
cd packages/mix_tailwinds/example
open real_tailwind/index.html
# — or —
python3 -m http.server 5173 --directory real_tailwind
```

Because the document pulls Tailwind from the official CDN, no extra tooling is required. Resize the browser window to the same widths you used in the Flutter app; every class list is identical between both experiences.

## Capture Tailwind screenshots automatically

The Next.js docs site now ships with a Playwright-based helper that boots the Tailwind example page and exports PNGs at a few canonical widths. This gives us artifacts we can diff against Flutter renders (manually for now, or via future tooling).

1. Install the Playwright browser binary once:

   ```bash
   cd website
   yarn install
   npx playwright install chromium
   ```

2. Generate screenshots (defaults: 480 px, 768 px, 1024 px):

   ```bash
   yarn screenshots:tailwind
   # override the dev-server port if needed
   TAILWIND_SCREENSHOT_PORT=4500 yarn screenshots:tailwind
   ```

The PNGs land in `website/screenshots/tailwind-plan-card/`. They’re `.gitignore`’d so you can diff locally or feed them into whatever image comparison pipeline you prefer before committing.

## Generate Flutter goldens + compare

1. Render the Flutter surface into golden PNGs (same widths):

   ```bash
   cd packages/mix_tailwinds/example
   flutter test --update-goldens test/parity_golden_test.dart
   ```

   The outputs live under `packages/mix_tailwinds/example/test/goldens/`.

2. With both sets of PNGs present, run the automated diff:

   ```bash
   cd website
   yarn compare:tailwind
   ```

   The script crops heights to match, runs `pixelmatch`, and writes per-width diff images to `website/screenshots/tailwind-plan-card/diff/` while printing mismatch percentages to the console.

## Notes

- All color, spacing, radius, and typography tokens come from `TwConfig.standard()`, so helping parity means updating a single config map.
- The components intentionally stick to utilities we already support (layout, spacing, border, radius, typography, responsive prefixes, and hover states on the buttons). If you add more classes to the Flutter example, mirror the change in `real_tailwind/index.html` so comparisons stay 1:1.
