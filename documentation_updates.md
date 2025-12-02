# Mix 2.0 Documentation Tasks

Quick reference for documentation updates needed before v2.0 launch.

**Status:** 21 tasks | 8 critical | 10 major | 3 minor

---

## Critical Tasks (Must Fix Before Launch)

### DOC-001: Complete widget-modifiers.mdx Code Examples
**File:** `website/src/content/documentation/guides/widget-modifiers.mdx`

Missing required method implementations in examples:
- Add complete `OpacityModifier` class (copyWith, lerp, resolve, merge)
- Add complete `OpacityModifierMix` class
- Include practical usage example
- Add modifier ordering best practices

---

### DOC-002: Complete design-token.mdx Examples
**File:** `website/src/content/documentation/guides/design-token.mdx`

Custom token examples incomplete:
- Complete `EdgeInsetsGeometryToken` implementation
- Add explanation of `EdgeInsetsGeometryRef` class
- Show multiple token types (ColorToken, RadiusToken, SizeToken)
- Include theme switching examples
- Add guidance on when to create custom tokens

---

### DOC-003: Fix Terminology Inconsistencies
**Files:** Multiple

Standardize these terms:
- "Fluent Styler API" (not "Styler API", "builder API", "chainable API")
- "Context Variants" for theme-based variants
- "Widget State Variants" for interaction-based variants (hover, press, disabled)
- "styled widgets" (lowercase, not "StyleWidgets" or "Mix widgets")

Update glossary in introduction.mdx, then search/replace across all files.

---

### DOC-004: Fix Broken Internal Links
**Files:** `overview/migration.mdx`, `overview/best-practices.mdx`

Fix these links:
- Line 183: modifiers guide link
- Line 189: PressableBox guide link
- Line 200: variants guide link
- Line 62 (best-practices): styled widgets link

Use `/documentation/...` format for all internal links.

---

### DOC-005: Add Prerequisites to getting-started.mdx
**File:** `website/src/content/documentation/overview/getting-started.mdx`

Add prerequisites section before installation:
- Dart SDK >= 3.9.0 (required for dot notation)
- Flutter latest stable
- Optional: Enable dot-notation experiment in analysis_options.yaml
- Link to dot-notation explanation

---

### DOC-006: Expand Directives Guide
**File:** `website/src/content/documentation/guides/directives.mdx`

Guide is only 27 lines. Expand to 200+ lines with:

1. **Understanding Directives** - What they are, when to use
2. **Text Directives** - Examples for all 5:
   - `.capitalize()` - First letter of each word
   - `.uppercase()` - All uppercase
   - `.lowercase()` - All lowercase
   - `.titleCase()` - Title case format
   - `.sentenceCase()` - Sentence case format
3. **Number Directives** - multiply, add, subtract, divide, clamp
4. **Custom Directives** - How to create your own
5. **Best Practices** - When to use vs other approaches

---

### DOC-007: Explain Mix() vs Styler() Pattern
**Files:** `tutorials/creating-a-widget.mdx`, `overview/introduction.mdx`

Add section explaining:
- `BoxStyler()` - For simple styles with fluent API
- `BoxStyler.create()` - For advanced prop-based composition
- When to use each pattern
- How `Prop<T>` works internally
- Update creating-a-widget.mdx comments

---

### DOC-008: Remove Marketing Language
**Files:** `overview/introduction.mdx`, `examples/README.md`

Replace marketing terms with technical descriptions:
- Remove "simple and intuitive", "powerful", "seamless"
- Remove emoji from technical documentation
- Use consistent technical tone
- Keep explanations factual, not promotional

---

## Major Tasks (Should Fix for Polish)

### DOC-009: Fix GitHub Organization Link
**File:** `examples/README.md`

Line 227: Change `https://github.com/conceptadev/mix` to `https://github.com/btwld/mix`

Search for all other conceptadev references and update.

---

### DOC-010: Add Missing Imports to Code Examples
**Files:** Multiple

Add import statements to all non-trivial code blocks:
```dart
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
```

---

### DOC-011: Clarify Token Patterns
**File:** `guides/design-token.mdx`

Add clear guidance on:
- Base `MixToken` class usage
- Each token type with examples
- Step-by-step custom token creation
- Comparison table of built-in tokens
- Common patterns and anti-patterns

---

### DOC-012: Explain Magic Constants
**Files:** `tutorials/creating-a-widget.mdx`, `guides/design-token.mdx`

Add comments explaining:
- Token naming format: `'custom.button.primary'`
- Shadow offset values: `x: 0, y: 5`
- Scale values: `0.9`
- Reference design system values/spacing scale
- Add "Defining Design Constants" section in best-practices

---

### DOC-013: Grammar and Copy Editing
**Files:** Multiple

Full editing pass for:
- Inconsistent capitalization
- Awkward phrasing
- Missing articles (a/the)
- Run-on sentences
- Passive voice → active voice

**Known issue:** migration.mdx line 204 has "StyledIcon" listed twice (duplicate)

---

### DOC-014: Split Long Tutorial
**File:** `tutorials/creating-a-widget.mdx`

Tutorial is 570 lines. Split into focused tutorials:
1. `creating-a-simple-widget.mdx` - Basic Spec and Styler
2. `adding-variants-to-widgets.mdx` - Variant system
3. `widget-state-variants.mdx` - State management
4. Keep original as overview with links

---

### DOC-015: Add Context Variants Examples
**File:** `guides/dynamic-styling.mdx`

Create comprehensive guide with:
- All 6 context variant types with examples
- State precedence and ordering
- Combining multiple context variants
- Performance considerations

---

### DOC-016: Complete Animation Guide
**File:** `guides/animations.mdx`

Verify and expand:
- Document all 3 animation types (implicit, phase, keyframe)
- Add performance tips
- Include animation state management examples

---

### DOC-017: Verify Example Code Compiles
**File:** `tutorials/creating-a-widget.mdx`

Check shadow example using `BoxShadowMix()`:
- Verify `BoxShadowMix` is correct API
- Update to proper API if incorrect
- Add required imports
- Test that example compiles

---

### DOC-018: Fix stylewidgets.mdx Links
**File:** `widgets/stylewidgets.mdx`

Fix 6 broken links (change `/docs/` to `/documentation/`):

| Line | Current | Correct |
|------|---------|---------|
| 12 | `/docs/widgets/box.mdx` | `/documentation/widgets/box` |
| 25 | `/docs/widgets/flex.mdx` | `/documentation/widgets/flexbox` |
| 40 | `/docs/widgets/text.mdx` | `/documentation/widgets/text` |
| 56 | `/docs/widgets/icon.mdx` | `/documentation/widgets/icon` |
| 63 | `/docs/widgets/image.mdx` | `/documentation/widgets/image` |
| 70 | `/docs/widgets/pressable.mdx` | `/documentation/widgets/pressable` |

---

## Minor Tasks (Nice to Have)

### DOC-019: Standardize Code Formatting
**Files:** Multiple

- Consistent code block formatting
- Standardize indentation (2 spaces)
- Consistent line highlighting format

---

### DOC-020: Add Type Parameter Explanations
**Files:** All widget documentation

Add brief section explaining `StyleSpec` type parameter for each widget.

---

### DOC-021: Create FAQ Page
**File:** New file: `overview/faq.mdx`

Cover common questions:
- When to use Styler vs custom styles
- How to migrate from Mix 1.x
- Performance considerations
- Design token best practices

---

## Implementation Phases

### Phase 1: Blockers (6-8 hours)
- DOC-004: Fix broken links
- DOC-005: Add prerequisites
- DOC-018: Fix stylewidgets.mdx links

### Phase 2: Critical Content (16-24 hours)
- DOC-001: Complete widget-modifiers examples
- DOC-002: Complete design-token examples
- DOC-006: Expand directives guide
- DOC-007: Explain Mix() vs Styler() pattern

### Phase 3: Quality (12-16 hours)
- DOC-003: Terminology standardization
- DOC-008: Remove marketing language
- DOC-009: Fix GitHub links
- DOC-010: Add imports
- DOC-013: Grammar editing

### Phase 4: Polish (4-8 hours)
- DOC-019: Code formatting
- DOC-020: Type parameters
- DOC-021: FAQ page

---

## Launch Checklist

Documentation is ready when:

- [ ] All internal links work (0 broken links)
- [ ] All code examples compile
- [ ] Terminology consistent across all docs
- [ ] No spelling or grammar errors
- [ ] `flutter analyze` passes on example files
- [ ] Prerequisites clearly stated

---

## Files Requiring Updates

**Critical files:**
- `website/src/content/documentation/guides/widget-modifiers.mdx`
- `website/src/content/documentation/guides/design-token.mdx`
- `website/src/content/documentation/guides/directives.mdx`
- `website/src/content/documentation/overview/getting-started.mdx`
- `website/src/content/documentation/overview/migration.mdx`
- `website/src/content/documentation/overview/best-practices.mdx`
- `website/src/content/documentation/widgets/stylewidgets.mdx`

**Major files:**
- `examples/README.md`
- `website/src/content/documentation/tutorials/creating-a-widget.mdx`
- `website/src/content/documentation/guides/dynamic-styling.mdx`
- `website/src/content/documentation/guides/animations.mdx`
- `website/src/content/documentation/overview/introduction.mdx`

**New file:**
- `website/src/content/documentation/overview/faq.mdx`
