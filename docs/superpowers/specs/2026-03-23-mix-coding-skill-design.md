# Mix Coding Skill — Design Spec

**Date:** 2026-03-23
**Purpose:** Help Claude write correct Mix code for external developers building Flutter apps with Mix.
**Trigger:** Explicit — user mentions Mix, Mix styling, BoxStyler, variants, or Mix widgets.
**Type:** Rigid — Claude must follow documented patterns, not improvise.

## File Structure

```
skills/mix-coding/
├── mix-coding.md                    # Main skill — core principles + router
├── references/
│   ├── styling.md                   # Fluent API, BoxStyler, TextStyler, etc.
│   ├── variants.md                  # Context variants, widget states
│   ├── animations.md                # Implicit, keyframe, phase
│   ├── tokens.md                    # Design tokens, MixScope, theming
│   ├── widgets.md                   # Box, FlexBox, RowBox, ColumnBox, StackBox, StyledText, StyledIcon, Pressable
│   └── examples.md                  # Curated examples from package source and tests
```

## Main File (`mix-coding.md`)

### Metadata
- Name: `mix-coding`
- Description: "Use when the user asks to write Flutter code using Mix, or mentions Mix styling, BoxStyler, variants, or Mix widgets"

### Content

**1. Core Principles (always loaded):**
- Always use fluent chaining (`BoxStyler().color(...).size(...)`)
- Specs are immutable, styles are builders
- Import `package:mix/mix.dart`
- Dart SDK >=3.11.0 (dot-shorthands enabled)
- Never construct Specs directly — always go through Stylers

**2. Routing Table — maps user intent to reference file:**

| User is asking about... | Load reference |
|---|---|
| Styling a widget, colors, padding, borders, sizing | `styling.md` |
| Hover, press, focus, dark mode, responsive, disabled/custom states | `variants.md` |
| Animations, transitions, keyframes, spring | `animations.md` |
| Design tokens, theming, MixScope | `tokens.md` |
| Which widget to use, Box vs FlexBox/RowBox/ColumnBox, layout | `widgets.md` |
| Needs a concrete example or pattern reference | `examples.md` |

Multiple references may be loaded for a single request (e.g., styling + variants for "a card that changes color on hover").

**3. Common Mistakes:**
- Don't use `Container()` when `Box()` exists
- Don't apply styles inline — define them as variables
- Don't forget `.onHovered()` returns a new styler (immutable chain)
- Don't mix Flutter's `Theme.of(context)` with Mix tokens

## Reference Files

### `references/styling.md`
**Patterns:** Creating styles, chaining methods, merging styles, composing multiple stylers.
**API tables:** BoxStyler methods (color, size, padding, margin, border, shadow, decoration), TextStyler methods (fontSize, fontWeight, color, letterSpacing), IconStyler methods.
**Source refs:** `packages/mix/lib/src/specs/box/`, `packages/mix/lib/src/specs/text/`, `packages/mix/lib/src/specs/icon/`, `packages/mix/test/src/specs/`

### `references/variants.md`
**Patterns:** Adding hover/press/focus states, dark/light mode, responsive sizing, custom context variants, combining multiple variants.
**API tables:** Built-in variant methods (`.onHovered()`, `.onPressed()`, `.onFocused()`, `.onDisabled()`, `.onDark()`, `.onLight()`), breakpoint/platform methods, named variants, and `ContextVariant` creation.
**Source refs:** `packages/mix/lib/src/style/mixins/variant_style_mixin.dart`, `packages/mix/lib/src/style/mixins/widget_state_variant_mixin.dart`, `packages/mix/lib/src/variants/variant.dart`, `packages/mix/test/src/variants/`

### `references/animations.md`
**Patterns:** Implicit animations (auto-animate on state change), keyframe animations (multi-step sequences), phase animations (tap-triggered multi-phase), spring physics.
**API tables:** `.animate()` config, `.keyframeAnimation()` builder, `.phaseAnimation()` builder, curve/duration options.
**Source refs:** `packages/mix/lib/src/animation/`, `packages/mix/lib/src/style/mixins/animation_style_mixin.dart`, `packages/mix/test/src/animation/`

### `references/tokens.md`
**Patterns:** Defining tokens, providing tokens via `MixScope`, using tokens in styles, creating a theme.
**API tables:** `MixToken`, `ColorToken`, `SpaceToken`, `RadiusToken`, `MixScope` widget.
**Source refs:** `packages/mix/lib/src/theme/`, `packages/mix/doc/mix-scope-and-theming.md`, `packages/mix/doc/token-migration-guide.md`, `packages/mix/test/src/theme/`

### `references/widgets.md`
**Patterns:** When to use Box, FlexBox, RowBox, ColumnBox, StackBox, StyledText, StyledIcon, StyledImage, Pressable, and PressableBox.
**API tables:** Widget constructors, required/optional parameters, style parameter types.
**Source refs:** `packages/mix/lib/src/specs/box/`, `packages/mix/lib/src/specs/flexbox/`, `packages/mix/lib/src/specs/stackbox/`, `packages/mix/lib/src/specs/text/`, `packages/mix/lib/src/specs/icon/`, `packages/mix/lib/src/specs/image/`, `packages/mix/lib/src/specs/pressable/`

### `references/examples.md`
**Organization:** Basic → Intermediate → Advanced complexity.
**Each example:** Description, full code, which concepts it demonstrates.
**Source refs:** Paths into `packages/mix/test/` and `packages/mix/lib/src/specs/` for each example.

## Runtime Behavior

1. Main file loads — Claude reads core principles and routing table
2. Claude identifies intent — matches user's request to 1-2 reference files
3. Claude reads relevant references — uses Read tool to load only needed files
4. Claude writes code — following patterns and API from loaded references

## Key Decisions

- **Lazy loading:** Only load references needed for the current request
- **Rigid skill:** Claude must follow documented patterns, not guess at API
- **Source refs:** Point to `packages/mix/lib/src/`, `packages/mix/test/`, and authored docs so Claude can read real implementations
- **External developer focus:** Patterns show how to USE Mix, not how to extend it
