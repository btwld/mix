# mix_tailwinds Visual Comparison Testing Guide

This guide is for AI agents performing visual parity testing between real Tailwind CSS and the mix_tailwinds Flutter implementation.

## Goal

Ensure that `mix_tailwinds` renders Flutter widgets that visually match real Tailwind CSS output. When a developer uses the same class string (e.g., `flex gap-4 p-6 bg-blue-50 rounded-xl`) in both:
- A Tailwind CSS HTML page
- A Flutter `Div` widget with mix_tailwinds

The visual output should be identical (or as close as possible given platform differences).

---

## Quick Start: Run Visual Comparison

### Step 1: Start Flutter Web Server

```bash
cd packages/mix_tailwinds/example
flutter run -d web-server --web-port=8089 --profile
```

Wait for: `lib/main.dart is being served at http://localhost:8089`

**Note**: Use `--profile` mode for better Playwright compatibility.

### Step 2: Run Comparison Script

```bash
cd packages/mix_tailwinds/tool/visual-comparison
npm install  # first time only
npm run compare
```

This script automatically:
1. Captures Tailwind screenshots from `real_tailwind/index.html`
2. Captures Flutter screenshots from `localhost:8089`
3. Generates pixel-diff images
4. Reports diff percentages

### Output

Screenshots and diffs are saved to `visual-comparison/<example>/` (gitignored):
```
visual-comparison/
├── dashboard/
│   ├── flutter-480.png
│   ├── flutter-768.png
│   ├── flutter-1024.png
│   ├── tailwind-480.png
│   ├── tailwind-768.png
│   ├── tailwind-1024.png
│   └── diff/
│       ├── diff-480.png
│       ├── diff-768.png
│       └── diff-1024.png
└── card-alert/
    ├── flutter-480.png
    ├── ... (same structure)
    └── diff/
        └── ...
```

To run a specific example:
```bash
npm run compare -- --example=dashboard
npm run compare -- --example=card-alert
```

### Interpreting Results

| Diff % | Interpretation |
|--------|----------------|
| < 3% | Excellent parity (font rendering differences only) |
| 3-5% | Good parity (minor differences) |
| 5-15% | Moderate diff (likely structural issues) |
| > 15% | High diff (parser bugs likely) |

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
- **Shadow rendering** - Flutter uses Material elevation, CSS uses box-shadow
- **Line height** - Minor differences in text vertical positioning

### Unacceptable Differences (Parser Bugs)

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

Look in `lib/src/tw_parser.dart` for how the class is handled.

### Step 3: Check the Config

Look in `lib/src/tw_config.dart` for the value mapping.

### Step 4: Verify the Widget Layer

Some properties are handled in `lib/src/tw_widget.dart`:
- Fractional widths (`w-1/2`, `h-1/3`)
- Flex item decorators (`flex-1`, `basis-*`)
- Responsive breakpoint resolution

---

## Deep Analysis with Codex Agent

After running the visual comparison, use the Codex MCP agent for automated deep analysis of parity issues.

### Running Codex Visual Parity Analysis

Invoke the Codex agent with this configuration:

```
Tool: mcp__plugin_codex_codex__codex
Model: gpt-5.2-codex
Config: { "reasoning_effort": "xhigh" }
Sandbox: read-only
CWD: packages/mix_tailwinds
```

### Image Paths for Analysis

Reference these paths when prompting Codex:

**Dashboard Example:**
- `visual-comparison/dashboard/tailwind-480.png` - Tailwind CSS reference
- `visual-comparison/dashboard/flutter-480.png` - Flutter mix_tailwinds output
- `visual-comparison/dashboard/diff/diff-480.png` - Pixel diff highlighting

**Card-Alert Example:**
- `visual-comparison/card-alert/tailwind-480.png` - Tailwind CSS reference
- `visual-comparison/card-alert/flutter-480.png` - Flutter mix_tailwinds output
- `visual-comparison/card-alert/diff/diff-480.png` - Pixel diff highlighting

Also available at 768px and 1024px widths.

### Example Codex Prompt

```
Perform a DEEP visual parity analysis between Tailwind CSS examples and Flutter mix_tailwinds.

Image paths:
- visual-comparison/dashboard/tailwind-480.png
- visual-comparison/dashboard/flutter-480.png
- visual-comparison/dashboard/diff/diff-480.png
- visual-comparison/card-alert/tailwind-480.png
- visual-comparison/card-alert/flutter-480.png
- visual-comparison/card-alert/diff/diff-480.png

Tasks:
1. Read Flutter examples in example/lib/
2. Read Tailwind HTML in example/real_tailwind/
3. Analyze parser in lib/src/tw_parser.dart
4. Analyze widget in lib/src/tw_widget.dart
5. Cross-reference each Tailwind class with its Flutter implementation
6. Identify ALL potential sources of visual differences

Focus on: gradients, spacing, sizing, typography, colors, borders, shadows, flexbox behavior.
```

### Expected Output

Codex returns YAML with:
- `parity_analysis` - Per-example breakdown with issue severity
- `parser_findings` - Issues in tw_parser.dart
- `widget_findings` - Issues in tw_widget.dart
- `priority_fixes` - Ranked list of recommended fixes
- `summary` - Overall assessment and issue counts

### Interpreting Codex Results

| Severity | Meaning |
|----------|---------|
| CRITICAL | Will cause runtime failures |
| MAJOR | Significant visual difference (missing badge, collapsed spacing) |
| MINOR | Noticeable but not breaking (line-height, hover states) |
| COSMETIC | Platform-specific (shadow blur, font anti-aliasing) |

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
| `lib/src/tw_parser.dart` | Token parsing logic |
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
2. **Shadow spread** - Material elevation != CSS box-shadow
3. **Sub-pixel anti-aliasing** - Different rendering engines
4. **Line height** - Minor line height differences between platforms

Focus on fixing **structural** and **value** differences, not platform rendering differences.
