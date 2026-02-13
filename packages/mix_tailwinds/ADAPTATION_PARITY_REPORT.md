# mix_tailwinds Adaptation and Parity Report

Date: 2026-02-12

## Scope

This report covers visual parity between:

- Tailwind HTML references in `example/real_tailwind/`
- Flutter rendering via `mix_tailwinds` in `example/lib/`

Focus areas:

- Global defaults parity (typography and baseline behavior)
- Gradient parity for `card-alert` and `dashboard`
- Practical strategy for experiments without changing core `mix`

## Current Baseline

Latest visual-comparison runs (profile mode):

- `card-alert`: 480 = `15.17%`, 768 = `5.35%`, 1024 = `5.05%`
- `dashboard`: 480 = `10.13%`, 768 = `8.33%`, 1024 = `7.75%`

Reference artifacts:

- `visual-comparison/card-alert/`
- `visual-comparison/dashboard/`

## Experiment Results (Gradient Strategy A/B)

Implemented strategies in `TwConfig.gradientStrategy`:

- `alignment` (default)
- `angle` (experimental)

Measured results:

- `card-alert` + `alignment`: 480 = `15.17%`, 768 = `5.35%`, 1024 = `5.05%`
- `card-alert` + `angle`: 480 = `37.76%`, 768 = `5.18%`, 1024 = `4.99%`
- `dashboard` + `alignment`: 480 = `10.13%`, 768 = `8.33%`, 1024 = `7.75%`
- `dashboard` + `angle`: 480 = `10.13%`, 768 = `8.33%`, 1024 = `7.75%`

Conclusion:

- `angle` introduces a large regression at `card-alert` 480px and does not improve `dashboard`.
- `alignment` should remain default.

Reference artifacts:

- `visual-comparison/card-alert-angle/`
- `visual-comparison/dashboard-angle/`

## Defaults Parity (Tailwind vs Flutter)

Current architecture is correct for parity setup:

- `TwConfig` controls Tailwind utility scale and base typography defaults.
- `TwScope` injects config via `TwConfigProvider`.
- `TwScope` applies text defaults through `MixScope` + `TextScope`.
- This avoids relying on `ThemeData.textTheme`.

Relevant code:

- `lib/src/tw_config.dart`
- `lib/src/tw_scope.dart`
- `FLUTTER_ADAPTATIONS.md`

## Gradient Findings

Tailwind and Flutter use identical class strings in `card-alert`:

- `min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900`

But sampled colors still show measurable mismatch, especially on upper-right and mid bands.

Latest sample reports:

- `visual-comparison/card-alert/gradient-samples-480-alignment.json`
- `visual-comparison/card-alert-angle/gradient-samples-480-angle.json`

Observed pattern:

- Right/top strip is more purple in Tailwind than Flutter.
- `alignment` shows partial variation but lower spread than Tailwind.
- `angle` over-flattens top-strip colors in Flutter and regresses 480px diff.
- Mismatch is systematic, not random anti-alias noise.

Practical diagnosis:

- This is mainly gradient geometry/rendering parity (CSS vs Flutter), not a random screenshot bug.
- Typography differences still exist, but they are not the primary cause of the large 480 card-alert delta.

## Black/White Diagnostic Harness

Added a simplified parity case to isolate gradient behavior:

- Tailwind reference: `example/real_tailwind/gradient-debug.html`
- Flutter reference: `example/lib/gradient_debug_preview.dart`
- Comparison output: `visual-comparison/gradient-debug/`

This case intentionally uses black/white gradients and hard-stop bands.

Results at 480px (anchor sampling by block):

- `smooth to-r`: close match
  - `visual-comparison/gradient-debug/samples-480-block1-smooth-r.json`
- `hard stops to-r`: close match
  - `visual-comparison/gradient-debug/samples-480-block3-hard-r.json`
- `smooth to-br`: strong mismatch
  - `visual-comparison/gradient-debug/samples-480-block2-smooth-br.json`
- `hard stops to-br`: strong mismatch with black/white band inversion at sampled points
  - `visual-comparison/gradient-debug/samples-480-block4-hard-br.json`

Interpretation:

- Horizontal gradients (`to-r`) match well.
- Diagonal gradients (`to-br`) are where parity diverges.
- This supports the hypothesis that the core issue is directional geometry/projection differences for diagonals, not color tokens.

## Adaptation Strategy

Keep parity work isolated to `mix_tailwinds`:

- Do not modify core `mix`.
- Use parser-level or config-level behavior toggles for experiments.
- Validate every experiment with:
  - visual comparison script
  - gradient sample analysis script
  - focused parser tests

## Typography Findings

`mix_tailwinds` already has the correct default architecture for text parity:

- `TwConfig.textDefaults` as source of truth
- `TwScope` applies defaults through `MixScope` + `TextScope`
- No dependency on `ThemeData.textTheme`

Current guidance:

- Keep using `TwTextDefaults.tailwindSans()` for Tailwind-style defaults.
- If desired for app-level platform matching, switch to `TwTextDefaults.platformDefault()` via `TwConfig.copyWith(...)` in the app layer only.
- Do not change core `mix` for this adaptation.

## Commands Used for Verification

```bash
cd packages/mix_tailwinds
fvm flutter test test/div_and_span_test.dart --plain-name "Gradient direction parity"
fvm flutter analyze

cd tool/visual-comparison
npm run compare -- --example=card-alert --gradient-strategy=alignment
npm run compare -- --example=card-alert --gradient-strategy=angle
npm run compare -- --example=dashboard --gradient-strategy=alignment
npm run compare -- --example=dashboard --gradient-strategy=angle
npm run analyze-gradient -- --example=card-alert --width=480 --output=../../visual-comparison/card-alert/gradient-samples-480-alignment.json
npm run analyze-gradient -- --tailwind=../../visual-comparison/card-alert-angle/tailwind-480.png --flutter=../../visual-comparison/card-alert-angle/flutter-480.png --output=../../visual-comparison/card-alert-angle/gradient-samples-480-angle.json
```

## Recommendation

Default to `gradientStrategy: TwGradientStrategy.cssAngleRect` for `mix_tailwinds`.

Rationale:

- It materially improves the key mobile parity case (`card-alert` 480).
- It preserves tablet/desktop parity.
- `mix_tailwinds` target is Tailwind parity, so CSS-geometry semantics should be default.

## Update: CSS Rect Strategy Implemented

Implemented in `mix_tailwinds`:

- `TwGradientStrategy.cssAngleRect` (legacy `adaptive` kept for compatibility)
- `TwCssKeywordLinearTransform` in parser path for `to-*` directional gradients
- Screenshot query support via `?gradient=css-angle-rect`

Result on real page (`card-alert`):

- `alignment`: 480 = `15.17%`, 768 = `5.35%`, 1024 = `5.05%`
- `css-angle-rect`: 480 = `6.23%`, 768 = `5.28%`, 1024 = `5.01%`

Interpretation:

- Significant mobile-width improvement on the exact page where diagonal mismatch was most visible.
- No regression at tablet/desktop widths.
- This strategy is now the package default.

Reference artifacts:

- `visual-comparison/card-alert-css-angle-rect/`
- `visual-comparison/dashboard-css-angle-rect/`

## gradient-debug Fixture Status

`gradient-debug` has been refactored to parser-driven Tailwind class names on Flutter side:

- `example/lib/gradient_debug_preview.dart`
- `example/real_tailwind/gradient-debug.html`

This means `TwGradientStrategy` now directly affects the Flutter side of this fixture,
so it is valid for strategy A/B comparisons.

Note:

- The fixture now focuses on parser-supported gradient cases (direction + from/via/to).
- Hard-stop inline CSS cases were removed from this fixture to avoid apples-to-oranges
  comparisons against parser output.
