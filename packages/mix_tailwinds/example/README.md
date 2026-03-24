# mix_tailwinds parity playground

This example renders the same UI twice: once with `mix_tailwinds` (Flutter) and once with real Tailwind CSS (HTML). Use it to verify that our class parser stays aligned with upstream Tailwind semantics.

## Requirements

- Dart SDK `>=3.11.0`
- Flutter `>=3.41.0`

## Directory layout

- `lib/main.dart` – Flutter app that drives the Mix `Div`/`Span` widgets. A width slider lets you exercise the responsive tokens (e.g., `md:flex-row`).
- `real_tailwind/dashboard.html` – Standalone CDN-powered Tailwind page for the dashboard parity sample.
- `web/` – Checked-in Flutter web target so the screenshot workflow works from a fresh checkout.

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
open real_tailwind/dashboard.html
# — or —
python3 -m http.server 5173 --directory real_tailwind
```

Because the document pulls Tailwind from the official CDN, no extra tooling is required. Resize the browser window to the same widths you used in the Flutter app; every class list is identical between both experiences.

## Visual comparison tool

A comparison tool captures screenshots of both the Flutter and Tailwind versions at canonical widths (480, 768, 1024 px), then diffs them with `pixelmatch`.

This workflow is CLI-only:

- run `npm run doctor` and `npm run compare ...`
- the repo script shells out to the global `playwright` CLI
- do not use MCP to generate these screenshots

Machine setup:

   ```bash
   npm install -g playwright@1.56.0
   playwright install chromium
   ```

   Playwright keeps browser binaries in the shared OS cache on macOS at `~/Library/Caches/ms-playwright` unless you override `PLAYWRIGHT_BROWSERS_PATH`. This repo does not own Chromium in `node_modules`.

Project setup:

   ```bash
   cd packages/mix_tailwinds/tool/visual-comparison
   npm install
   npm run doctor
   npm run compare -- --example=dashboard
   npm run compare -- --example=card-alert
   ```

The tool will:

1. Validate the pinned global Playwright CLI version and Chromium cache.
2. Reuse `http://127.0.0.1:8089` when a Flutter web server is already running.
3. Start `fvm flutter run -d web-server --web-port=8089 --profile` automatically when it is not.
4. Save generated artifacts to `packages/mix_tailwinds/visual-comparison/<example>/`.

Internally, the local script calls `playwright screenshot`. The screenshot path is still the Playwright CLI, not MCP.

Each run writes:

- `tailwind-480.png`, `tailwind-768.png`, `tailwind-1024.png`
- `flutter-480.png`, `flutter-768.png`, `flutter-1024.png`
- `side-by-side-480.png`, `side-by-side-768.png`, `side-by-side-1024.png`
- `diff/diff-480.png`, `diff/diff-768.png`, `diff/diff-1024.png`

Useful global Playwright maintenance commands:

```bash
playwright install --list
playwright uninstall --all
```

`playwright uninstall --all` removes browsers for every Playwright installation on the machine, not just this repo.

The website preview build is a separate pipeline:

```bash
bash examples/scripts/build_web_previews.sh --local
```

That command builds the interactive docs preview bundle. It does not generate the visual comparison PNGs above.

## Generate Flutter goldens

Render the Flutter surface into golden PNGs (same widths):

```bash
cd packages/mix_tailwinds/example
flutter test --update-goldens test/parity_golden_test.dart
```

The outputs live under `packages/mix_tailwinds/example/test/goldens/`.

## Notes

- All color, spacing, radius, and typography tokens come from `TwConfig.standard()`, so helping parity means updating a single config map.
- The components intentionally stick to utilities we already support (layout, spacing, border, radius, typography, responsive prefixes, and hover states on the buttons). If you add more classes to the Flutter example, mirror the change in `real_tailwind/dashboard.html` so comparisons stay 1:1.
