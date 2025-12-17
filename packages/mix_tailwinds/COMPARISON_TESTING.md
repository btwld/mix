# mix_tailwinds Visual Comparison Testing Guide

This guide is for AI agents performing visual parity testing between real Tailwind CSS and the mix_tailwinds Flutter implementation.

## Goal

Ensure that `mix_tailwinds` renders Flutter widgets that visually match real Tailwind CSS output. When a developer uses the same class string (e.g., `flex gap-4 p-6 bg-blue-50 rounded-xl`) in both:
- A Tailwind CSS HTML page
- A Flutter `Div` widget with mix_tailwinds

The visual output should be identical (or as close as possible given platform differences).

---

## AI Agent Workflow: Live Screenshot Comparison

When the user asks to compare Flutter vs Tailwind rendering, follow these steps:

### Step 1: Start Flutter Web Server

```bash
cd packages/mix_tailwinds/example
flutter run -d web-server --web-port=8089
```

Wait for: `lib/main.dart is being served at http://localhost:8089`

### Step 2: Capture Flutter Screenshots with Playwright

The Flutter app supports a **screenshot mode** via URL query parameters:

```
http://localhost:8089/?screenshot=true&width=480
http://localhost:8089/?screenshot=true&width=768
http://localhost:8089/?screenshot=true&width=1024
```

For each width:
1. Resize viewport: `browser_resize(width, 1200)`
2. Navigate to: `http://localhost:8089/?screenshot=true&width={WIDTH}`
3. Wait 2 seconds for render
4. Take full-page screenshot: `browser_take_screenshot(fullPage: true, filename: "flutter-{WIDTH}.png")`

### Step 3: Capture Tailwind Screenshots with Playwright

For each width (480, 768, 1024):
1. Resize viewport: `browser_resize(width, 1200)`
2. Navigate to: `file:///path/to/packages/mix_tailwinds/example/real_tailwind/index.html`
3. Screenshot the `<main>` element: `browser_take_screenshot(element: "main", ref: "e2", filename: "tailwind-{WIDTH}.png")`

### Step 4: Visual Comparison

Read both screenshots at each breakpoint and compare:
- **Layout**: Flex direction, stacking, alignment
- **Spacing**: Gaps, padding, margins
- **Typography**: Font sizes, weights
- **Colors**: Background, text, borders
- **Responsive**: `md:` breakpoint behavior at 768px

### Step 5: Report Findings

Document any differences found, categorizing as:
- **Parser bug**: Wrong layout/spacing/color (needs fix)
- **Platform difference**: Font rendering, shadows (expected)

---

## Alternative: Golden Test Comparison

### 1. Generate Flutter Golden Images

```bash
cd packages/mix_tailwinds/example
flutter test --update-goldens test/parity_golden_test.dart
```

This creates golden PNGs at:
- `test/goldens/flutter-plan-card-480.png`
- `test/goldens/flutter-plan-card-768.png`
- `test/goldens/flutter-plan-card-1024.png`

### 2. Capture Tailwind Screenshots

Use Playwright to capture screenshots from `real_tailwind/index.html`:

```bash
# Using Playwright MCP tools:
1. Navigate to file:///path/to/packages/mix_tailwinds/example/real_tailwind/index.html
2. Resize browser to 480x1200, screenshot <main> element
3. Resize to 768x1200, screenshot <main> element
4. Resize to 1024x1200, screenshot <main> element
```

### 3. Run Pixel Comparison

```bash
cd website
node ./scripts/compare-tailwind-flutter.mjs
```

This outputs:
- Diff percentages for each breakpoint
- Diff images in `screenshots/tailwind-plan-card/diff/`

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

The diff images (red pixels = differences) help identify problem areas:

### High Diff Concentration Areas

1. **Red blob around text** → Font rendering difference (may be unavoidable platform difference)
2. **Red outline around containers** → Border/radius rendering difference
3. **Red fill in boxes** → Background color mismatch
4. **Red gaps between elements** → Spacing/gap mismatch
5. **Red around shadows** → Shadow rendering difference (Material vs CSS)

### Acceptable Differences (Platform-Specific)

Some differences are expected and acceptable:
- **Font anti-aliasing** - Web and Flutter render fonts differently
- **Sub-pixel rendering** - Minor 1px differences in positioning
- **Shadow rendering** - Flutter uses Material elevation, CSS uses box-shadow

### Unacceptable Differences (Parser Bugs)

These indicate bugs in `tw_parser.dart`:
- **Wrong flex direction** - Items stacking wrong way
- **Missing gaps** - No space between flex items
- **Wrong colors** - Completely different color rendered
- **Missing borders** - Border not appearing at all
- **Wrong sizes** - Element much larger/smaller than expected

---

## Debugging Specific Classes

### Step 1: Identify the Problem Class

Look at the diff image and identify which element has the red pixels. Find the corresponding class string in both:
- `real_tailwind/index.html` - The HTML element
- `example/lib/main.dart` - The Flutter `Div` widget

### Step 2: Check the Parser

Look in `lib/src/tw_parser.dart` for how the class is handled:

```dart
// Example: checking how gap-4 is parsed
// Search for: 'gap-' in tw_parser.dart
```

### Step 3: Check the Config

Look in `lib/src/tw_config.dart` for the value mapping:

```dart
// Example: checking spacing scale
// TwConfig.standard().space['4'] should equal 16.0 (4 * 4px)
```

### Step 4: Verify the Widget Layer

Some properties are handled in `lib/src/tw_widget.dart`:
- Fractional widths (`w-1/2`, `h-1/3`)
- Flex item decorators (`flex-1`, `basis-*`)
- Responsive breakpoint resolution

---

## Reference: Tailwind Value Mappings

### Spacing Scale (space)
| Token | Tailwind | mix_tailwinds | Pixels |
|-------|----------|---------------|--------|
| `0` | 0 | 0.0 | 0px |
| `1` | 0.25rem | 4.0 | 4px |
| `2` | 0.5rem | 8.0 | 8px |
| `4` | 1rem | 16.0 | 16px |
| `6` | 1.5rem | 24.0 | 24px |
| `8` | 2rem | 32.0 | 32px |

### Border Radius Scale (radii)
| Token | Tailwind | mix_tailwinds |
|-------|----------|---------------|
| `rounded` | 0.25rem | 4.0 |
| `rounded-lg` | 0.5rem | 8.0 |
| `rounded-xl` | 0.75rem | 12.0 |
| `rounded-2xl` | 1rem | 16.0 |
| `rounded-full` | 9999px | 9999.0 |

### Font Sizes (fontSizes)
| Token | Tailwind | mix_tailwinds |
|-------|----------|---------------|
| `text-xs` | 0.75rem | 12.0 |
| `text-sm` | 0.875rem | 14.0 |
| `text-base` | 1rem | 16.0 |
| `text-lg` | 1.125rem | 18.0 |
| `text-xl` | 1.25rem | 20.0 |
| `text-2xl` | 1.5rem | 24.0 |
| `text-3xl` | 1.875rem | 30.0 |

### Breakpoints
| Token | Tailwind | mix_tailwinds |
|-------|----------|---------------|
| `sm:` | 640px | 640.0 |
| `md:` | 768px | 768.0 |
| `lg:` | 1024px | 1024.0 |
| `xl:` | 1280px | 1280.0 |

---

## Reporting Findings

When reporting comparison results, use this format:

```markdown
## Visual Comparison Report

**Date**: [date]
**Diff Percentages**:
- 480px: X.XX%
- 768px: X.XX%
- 1024px: X.XX%

### Issues Found

#### Issue 1: [Brief description]
- **Location**: [Which card/section]
- **Tailwind class**: `[class-name]`
- **Expected behavior**: [What Tailwind does]
- **Actual behavior**: [What mix_tailwinds does]
- **Severity**: Critical / Major / Minor / Cosmetic
- **File to fix**: `tw_parser.dart` line XXX

#### Issue 2: ...

### Recommendations
1. [Specific fix suggestion]
2. [Specific fix suggestion]
```

---

## Files Reference

| File | Purpose |
|------|---------|
| `lib/src/tw_parser.dart` | Token parsing logic |
| `lib/src/tw_config.dart` | Value mappings (spacing, colors, etc.) |
| `lib/src/tw_widget.dart` | Div/Span widget implementation |
| `lib/src/tw_utils.dart` | Utility functions (fraction parsing) |
| `example/lib/main.dart` | Flutter test component |
| `example/real_tailwind/index.html` | Tailwind reference HTML |
| `example/test/parity_golden_test.dart` | Golden test generator |
| `website/scripts/compare-tailwind-flutter.mjs` | Pixel diff script |

---

## Known Platform Differences

These differences are expected and not bugs:

1. **Font rendering** - Web uses system fonts with different hinting than Flutter
2. **Shadow spread** - Material elevation != CSS box-shadow
3. **Sub-pixel anti-aliasing** - Different rendering engines
4. **Line height** - Default line heights differ between platforms

Focus on fixing **structural** and **value** differences, not platform rendering differences.
