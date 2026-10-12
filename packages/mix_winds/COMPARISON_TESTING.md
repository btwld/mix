# mix_winds Visual Comparison Testing Guide

This guide is for AI agents performing visual parity testing between real Tailwind CSS and the mix_winds Flutter implementation. It is the canonical workflow referenced by `packages/mix_winds/AGENTS.md` and `packages/mix_winds/CLAUDE.md`.

## Goal

Ensure that `mix_winds` renders Flutter widgets that visually match real Tailwind CSS output. When a developer uses the same class string (e.g., `flex gap-4 p-6 bg-blue-50 rounded-xl`) in both:
- A Tailwind CSS HTML page
- A Flutter `Div` widget with mix_winds

The visual output should be identical (or as close as possible given platform differences).

---

## Quick Start: Run Visual Comparison

### Step 0: Verify Source Class Parity

Before changing translator or renderer behavior, compare Tailwind HTML `class` strings against Flutter `classNames` strings:

- Confirm corresponding elements use the same utility tokens in the same order.
- Expand reusable Flutter components when comparing against repeated HTML nodes, such as metric tiles and activity rows.
- Expand dynamic Flutter class fragments before comparing, such as `borderClass` and `badgeColor`.

If class strings differ, fix example drift first. If class strings match, continue to layout metrics and pixel comparison; the bug is then in translation, widget placement, or renderer behavior.

### Step 1: Start Flutter Web Server

```bash
cd packages/mix_winds/example
# If you see "not configured to build on the web", run:
#   fvm flutter create . --platforms=web
fvm flutter run -d web-server --web-port=8089 --profile
```

Wait for: `lib/main.dart is being served at http://localhost:8089`

**Note**: Use `--profile` mode for better Playwright compatibility.

### Step 2: Run Comparison Script

```bash
cd packages/mix_winds/tool/visual-comparison
npm ci  # first time, or whenever package-lock.json changes
npx playwright install chromium  # first time only, if Chromium is missing
npm run compare
# Run all five product-scale advanced fixtures (15 screenshot pairs).
npm run compare:advanced
# Run all ten isolated complex parity fixtures (30 screenshot pairs).
npm run compare:complex
```

This script automatically:
1. Captures Tailwind screenshots from the configured `real_tailwind/*.html` fixture
2. Captures Flutter screenshots from `localhost:8089`
3. Generates pixel-diff, amplified absolute-diff, and blink-GIF images
4. Writes `summary.json` with image dimensions and diff percentages
5. Enforces the example's selected metric at every viewport
6. Regenerates `visual-comparison/index.html`, even when the comparison fails

The complex batch pins the browser reference to Tailwind CSS `4.3.1`, captures
480/768/1024px, replays dark-hover and delayed-hover states, and writes an
aggregate `complex-parity/summary.json`.

The advanced batch captures five responsive Northstar operations surfaces and
writes an aggregate `advanced-parity/summary.json`. Each individual summary is
tagged as the `advanced` suite in the HTML report. The aggregate records a
content fingerprint for every source that can affect the showcase or its
evidence; `showcase:build` rejects the aggregate after any of those inputs
change.

### Output

Screenshots and diffs are saved to `visual-comparison/<example>/` (gitignored):
```
visual-comparison/
├── index.html                 # generated live report (gitignored)
├── dashboard/
│   ├── flutter-480.png
│   ├── flutter-768.png
│   ├── flutter-1024.png
│   ├── tailwind-480.png
│   ├── tailwind-768.png
│   ├── tailwind-1024.png
│   ├── summary.json
│   └── diff/
│       ├── absdiff-480.png
│       ├── blink-480.gif
│       ├── diff-480.png
│       ├── diff-768.png
│       └── diff-1024.png
├── card-alert/
│   ├── flutter-480.png
│   ├── ... (same structure)
│   └── diff/
│       └── ...
├── flowbite-card/
│   ├── flutter-480.png
│   ├── ... (same structure)
│   └── diff/
│       └── ...
├── complex-parity/
│   ├── summary.json
│   ├── case-01/
│   │   ├── tailwind-480.png
│   │   ├── flutter-480.png
│   │   ├── summary.json
│   │   └── diff/
│   │       ├── diff-480.png
│   │       ├── strictdiff-480.png
│   │       ├── absdiff-480.png
│   │       └── blink-480.gif
│   └── case-10/
│       └── ...
└── advanced-parity/
    ├── summary.json
    ├── launch-command/
    ├── signal-analytics/
    ├── incident-room/
    ├── release-timeline/
    └── capacity-map/
```

To run a specific example:
```bash
npm run compare -- --example=dashboard
npm run compare -- --example=card-alert
npm run compare -- --example=flowbite-card
npm run compare -- --example=advanced-launch-command
npm run compare -- --example=advanced-signal-analytics
npm run compare -- --example=advanced-incident-room
npm run compare -- --example=advanced-release-timeline
npm run compare -- --example=advanced-capacity-map
npm run compare:advanced
npm run compare -- --example=complex-04
npm run compare:complex
```

Complex-case summaries expose three complementary metrics:

- `diffPercent`: anti-alias-tolerant `pixelmatch` at threshold `0.1`, useful for
  large structural shifts but intentionally insensitive to nearby colors.
- `strictDiffPercent`: `pixelmatch` at threshold `0.01`, which catches named
  palette drift while retaining anti-alias classification.
- `exactDiffPercent` and `meanAbsoluteRgbaDelta`: byte-level evidence. Use these
  to confirm exact output, but do not treat tiny raster/shadow deltas as layout
  failures without inspecting the strict diff and source values.

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

Open `visual-comparison/index.html` after a run. It discovers all available
summaries and provides viewport, suite, and pass/fail filters; paired Tailwind
and Flutter captures; all three scores; and direct links to strict, absolute,
pixelmatch, and blink diffs. Missing artifacts are shown as failures rather
than broken, silent image slots.

Use the non-enforced metrics as diagnostic evidence. A large region can still
come from one structural shift, such as a wrapped line moving every row below
it, while a small strict-only region often indicates palette or raster drift.

`card-alert` 768px note: the comparison harness pins both the Tailwind HTML pages and Flutter screenshot mode to the bundled `TwParityRoboto` font. This keeps glyph metrics deterministic without changing canonical Tailwind sizes; `TwConfig.standard()` still uses the standard Tailwind font scale and system sans stack.

`card-alert` button note: button labels rely on inherited `font-medium` plus Tailwind's base 16px text size. Screenshot previews use a `WidgetsApp` shell with `TwScope` around the captured content so Material text defaults cannot shadow Tailwind defaults; keep default text modifiers merging with the ambient style so partial overrides do not reset base font metrics.

`dashboard` note: the Tailwind reference body uses `py-10`, which places `main` at `y=40`. The visual comparison tool reuses Tailwind's expanded clip for Flutter, so Flutter screenshot mode must include the same vertical frame before rendering the dashboard preview.

---

## What to Look For When Comparing

### Priority 1: Layout Issues

These cause the most visual difference and indicate parser bugs:

| Issue | Tailwind Class | What to Check |
|-------|---------------|---------------|
| **Flex direction** | `flex-row`, `flex-col`, `md:flex-row` | Are items stacking correctly? |
| **Flex alignment** | `items-center`, `justify-between` | Is cross/main axis alignment correct? |
| **Gap spacing** | `gap-4`, `gap-x-2`, `gap-y-6` | Is spacing between flex items correct? |
| **Responsive changes** | `md:flex-row`, `lg:gap-8` | Does layout change at breakpoints? |

### Priority 2: Spacing Issues

| Issue | Tailwind Class | What to Check |
|-------|---------------|---------------|
| **Padding** | `p-4`, `px-6`, `pt-2` | Is internal spacing correct? |
| **Margin** | `m-4`, `mx-auto`, `mt-8` | Is external spacing correct? |
| **Sizing** | `w-full`, `h-12`, `w-1/2` | Are dimensions correct? |

### Priority 3: Visual Styling

| Issue | Tailwind Class | What to Check |
|-------|---------------|---------------|
| **Background color** | `bg-blue-50`, `bg-white` | Is the color correct? |
| **Text color** | `text-gray-700`, `text-blue-600` | Is text colored correctly? |
| **Border** | `border`, `border-gray-200` | Is border visible and correct color? |
| **Border radius** | `rounded-xl`, `rounded-full` | Are corners rounded correctly? |
| **Shadow** | `shadow-lg`, `shadow-none` | Is shadow present and correct size? |

### Priority 4: Typography

| Issue | Tailwind Class | What to Check |
|-------|---------------|---------------|
| **Font size** | `text-sm`, `text-2xl`, `text-base` | Is text size correct? |
| **Font weight** | `font-semibold`, `font-bold` | Is text weight correct? |
| **Text transform** | `uppercase`, `lowercase` | Is casing correct? |

---

## Reading Diff Images

Red pixels in diff images indicate differences between Flutter and Tailwind:

### High Diff Concentration Areas

1. **Red blob around text** - Font rendering difference (platform-specific)
2. **Red outline around containers** - Border/radius rendering difference
3. **Red fill in boxes** - Background color mismatch
4. **Red gaps between elements** - Spacing/gap mismatch
5. **Red around shadows** - Shadow rendering difference

### Acceptable Differences (Platform-Specific)

- **Font anti-aliasing** - Web and Flutter render fonts differently
- **Sub-pixel rendering** - Minor 1px differences in positioning
- **Shadow rasterization** - Flutter and the browser rasterize matching box-shadow values differently
- **Line height** - Minor differences in text vertical positioning

### Unacceptable Differences (Parser Bugs)

- **Wrong flex direction** - Items stacking wrong way
- **Missing gaps** - No space between flex items
- **Wrong colors** - Completely different color rendered
- **Missing borders** - Border not appearing at all
- **Wrong sizes** - Element much larger/smaller than expected

### Clearer Local Diff Artifacts

The comparison tool writes extra artifacts next to each `diff-*.png`:

- `diff/absdiff-<width>.png` amplifies raw channel differences so subtle text, color, and border drift is easier to see.
- `diff/blink-<width>.gif` alternates Tailwind and Flutter frames so layout shifts are obvious.
- `summary.json` records dimensions, all diff metrics, the enforced acceptance
  checks, and generated artifact paths.

Do not commit generated screenshots, GIFs, summaries, or diff images. If you need additional review composites such as triptychs, keep them under `.context/visual-review/`.

For example:

```bash
npm run compare -- --example=card-alert
open ../../visual-comparison/card-alert/diff/blink-768.gif
open ../../visual-comparison/card-alert/diff/absdiff-768.png
```

---

## Debugging Specific Classes

### Step 1: Identify the Problem Class

Look at the diff image and identify which element has the red pixels. Find the
corresponding class string in both `example/real_tailwind/*.html` and its
matching preview under `example/lib/`.

### Step 2: Check the Parser

Look in `lib/src/translate/tw_translator.dart` for utility translation,
`lib/src/translate/tw_routing.dart` for support/target routing, and
`lib/src/parser/` for candidate parsing.

### Step 3: Check the Config

Look in `lib/src/tw_config.dart` for the value mapping.

### Step 4: Verify the Widget Layer

Some properties are handled in `lib/src/tw_widget.dart`:
- Fractional widths (`w-1/2`, `h-1/3`)
- Flex item decorators (`flex-1`, `basis-*`)
- Responsive breakpoint resolution

### Step 5: Add Metric Tests Before Changing Styling

When a visual diff looks structural, add focused widget tests before changing parser or widget behavior. Prefer measuring bounds directly:

- Card-alert: message width/height, warning top/bottom, button row top, equal button widths.
- Dashboard: equal metric tile widths, equal action button widths, row separator/top-border behavior.

This keeps fixes tied to utility semantics instead of chasing screenshot noise.

---

## Reference: Tailwind Value Mappings

### Spacing Scale (space)
| Token | Pixels |
|-------|--------|
| `0` | 0px |
| `1` | 4px |
| `2` | 8px |
| `4` | 16px |
| `6` | 24px |
| `8` | 32px |

### Border Radius Scale (radii)
| Token | Value |
|-------|-------|
| `rounded` | 4px |
| `rounded-lg` | 8px |
| `rounded-xl` | 12px |
| `rounded-2xl` | 16px |
| `rounded-full` | 9999px |

### Font Sizes (fontSizes)
| Token | Size |
|-------|------|
| `text-xs` | 12px |
| `text-sm` | 14px |
| `text-base` | 16px |
| `text-lg` | 18px |
| `text-xl` | 20px |
| `text-2xl` | 24px |
| `text-3xl` | 30px |

### Breakpoints
| Token | Width |
|-------|-------|
| `sm:` | 640px |
| `md:` | 768px |
| `lg:` | 1024px |
| `xl:` | 1280px |

---

## Files Reference

| File | Purpose |
|------|---------|
| `lib/src/parser/` | Candidate parsing, registry data, diagnostics, and routing inputs |
| `lib/src/translate/tw_translator.dart` | Utility-to-Mix translation logic |
| `lib/src/translate/tw_routing.dart` | Candidate support and target routing policy |
| `lib/src/tw_config.dart` | Value mappings (spacing, colors, etc.) |
| `lib/src/tw_widget.dart` | Div/Span widget implementation |
| `lib/src/tw_utils.dart` | Utility functions (fraction parsing) |
| `example/lib/main.dart` | Flutter test component |
| `example/real_tailwind/index.html` | Tailwind reference HTML (uses Tailwind CDN) |
| `tool/visual-comparison/run-visual-comparison.mjs` | Visual comparison script |

---

## Known Platform Differences

These differences are expected and not bugs:

1. **Font rendering** - Web uses system fonts with different hinting than Flutter
2. **Shadow rasterization** - Flutter and browsers rasterize box shadows differently
3. **Sub-pixel anti-aliasing** - Different rendering engines
4. **Line height** - Minor line height differences between platforms

Focus on fixing **structural** and **value** differences, not platform rendering differences.

## Golden Test Notes

`packages/mix_winds/example/test/parity_golden_test.dart` is the Flutter-side golden harness for the dashboard surface. If it fails with a `FlutterError.onError` lifecycle assertion or hangs, fix the harness before updating any golden PNGs.

Expected process:

```bash
cd packages/mix_winds/example
fvm flutter test test/parity_golden_test.dart
```

- A normal golden mismatch with files under `test/failures/` is actionable.
- A harness assertion or hang is not actionable visual evidence.
- Do not update committed goldens unless the root cause is understood and the updated images are the intended new baseline.

Stable supporting goldens should keep passing:

```bash
fvm flutter test test/shrink_golden_test.dart test/duration_delay_golden_test.dart
```
