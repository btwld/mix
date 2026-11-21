# Winds visual comparison testing

Compare matching Tailwind HTML and Flutter class strings, then geometry and
pixels. This workflow is referenced by the package's agent guide.

## Check source parity first

Compare utility tokens **and their order** in `example/real_tailwind/*.html`
and the matching Flutter preview. Expand reusable components and dynamic
fragments such as `borderClass` or `badgeColor`. Fix example drift before
changing translation or rendering.

## Run captures

From the repository root:

```bash
cd packages/mix_winds/example
fvm flutter run -d web-server --web-port=8089 --profile
```

Wait until the app is served. Profile mode is used for Playwright captures.
In another terminal:

```bash
cd packages/mix_winds/tool/visual-comparison
npm ci
npx playwright install chromium
npm run compare -- --example=dashboard
npm run compare:advanced
npm run compare:complex
```

The default Flutter URL uses port 8089. If a different server is necessary,
check `run-visual-comparison.mjs` for supported URL arguments and keep the
capture URL consistent. Do not regenerate platform scaffolding just to start a
server without first checking the example setup.

The tool captures Tailwind and Flutter, generates tolerant/strict/absolute
diffs and blink GIFs, writes summaries, enforces acceptance at every viewport,
and regenerates `visual-comparison/index.html` even after failure.

- Complex: ten isolated fixtures, Tailwind 4.3.1, widths 480/768/1024, including
  dark-hover and delayed-hover states; `complex-parity/summary.json` aggregates.
- Advanced: five responsive Northstar surfaces; `advanced-parity/summary.json`
  aggregates and fingerprints source inputs. `showcase:build` rejects stale evidence.
- Use `--example=card-alert`, `flowbite-card`, `complex-04`, or an
  `advanced-...` case for focused iteration.

## Interpret the evidence

| Metric | Use |
|---|---|
| `diffPercent` | Tolerant pixelmatch threshold 0.1; broad structural differences |
| `strictDiffPercent` | Threshold 0.01; palette differences with anti-alias classification |
| `exactDiffPercent`, `meanAbsoluteRgbaDelta` | Byte-level evidence; inspect raster/shadow differences before judging layout |

### Acceptance contracts

Each example selects one metric and a maximum for each width. A missing width,
missing capture, or value above the maximum fails the command. Do not raise a
maximum to make a regression pass.

| Cases | Enforced metric | 480 / 768 / 1024 maximum |
|---|---:|---:|
| Complex 03 | Exact | `0 / 0 / 0%` |
| Complex 01, 02, 07, 08, 09, 10 | Strict | `1 / 1 / 1%` |
| Complex 06 | Strict | `3 / 3 / 3%` |
| Complex 04 | Tolerant | `5 / 5 / 5%` |
| Complex 05 | Tolerant | `1 / 1 / 1%` |
| Dashboard | Tolerant | `1.45 / 1.40 / 1.15%` |
| Card alert | Tolerant | `5.11 / 4.19 / 3.62%` |
| Flowbite card | Tolerant | `1.68 / 1.68 / 1.68%` |
| Advanced 01–05 | Tolerant | `5 / 5 / 5%` |


The example configuration is the source for acceptance limits. Do not raise a
maximum to make a regression pass. Missing captures, widths or artifacts fail.
Use non-enforced metrics for diagnosis, not to substitute for the selected one.

Open the generated HTML report for suite/viewport/pass filters, paired captures
and all diff links. Artifacts live under the gitignored
`visual-comparison/<example>/`: captures, `summary.json`, and `diff/` images.
Do not commit generated screenshots, GIFs, summaries or review composites.
Use `.context/visual-review/` for additional scratch evidence.

## Diagnose structural differences before styling

1. Check direction, cross/main-axis alignment, gaps and responsive branches.
2. Measure padding, external margin, width and height.
3. Check palette, border/radius and shadow values against the actual config.
4. Normalize font family, size, weight and line height before interpreting text diffs.

A wrapped line can shift every row below it. Small strict-only regions may be
palette or raster drift. Anti-aliasing and shadow rasterization differ between
engines, but wrong dimensions, missing gaps or wrong values are not explained
by that difference.

Trace the owning stage: `parser/` recognizes candidates, `translate/` maps and
routes them, `tw_config.dart` supplies scales, the compiler emits a typed layout
plan, and `tw_widget.dart` evaluates it. Check the plan before altering widgets.

For structural failures, add focused widget measurements: message bounds,
warning top/bottom, button-row position and equal button widths for card-alert;
tile widths, action-button widths and row separators for dashboard. These tie
a fix to utility semantics rather than screenshot noise.

## Fixture constraints

- Card-alert pins both captures to bundled `TwParityRoboto`; canonical Tailwind
  font sizes remain unchanged. Screenshot mode uses `WidgetsApp` plus `TwScope`
  so Material defaults cannot shadow base typography. Partial text overrides
  must merge with ambient style.
- Dashboard HTML uses `py-10`, placing `main` at y=40. Flutter screenshot mode
  must include that same frame because capture reuses the Tailwind clip.
- Read generated theme data and config for scales; do not maintain copied
  spacing, radius, font-size or breakpoint tables here.

## Golden harness failures versus visual failures

From `packages/mix_winds/example`:

```bash
fvm flutter test test/parity_golden_test.dart
fvm flutter test test/shrink_golden_test.dart test/duration_delay_golden_test.dart
```

A normal mismatch with artifacts under `test/failures/` is visual evidence.
A `FlutterError.onError` lifecycle assertion or a hang is a harness failure:
fix that before updating PNGs. Change committed goldens only after identifying
the cause and confirming the new output is intentional.
