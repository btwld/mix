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
│   ├── widgets.md                   # Box, HBox, VBox, Text, Icon, Pressable
│   └── examples.md                  # Curated code examples from examples/lib/
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
| Hover, press, focus, dark mode, responsive, selected | `variants.md` |
| Animations, transitions, keyframes, spring | `animations.md` |
| Design tokens, theming, MixScope | `tokens.md` |
| Which widget to use, Box vs HBox, layout | `widgets.md` |
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
**Source refs:** `examples/lib/api/box/`, `examples/lib/api/text/`, `examples/lib/docs/guides/styling.dart`

### `references/variants.md`
**Patterns:** Adding hover/press/focus states, dark/light mode, responsive sizing, custom context variants, combining multiple variants.
**API tables:** Built-in variant methods (`.onHovered()`, `.onPressed()`, `.onFocused()`, `.onSelected()`, `.onDisabled()`, `.onDark()`, `.onLight()`), `ContextVariant` creation.
**Source refs:** `examples/lib/api/context_variants/`, `examples/lib/docs/guides/variants.dart`

### `references/animations.md`
**Patterns:** Implicit animations (auto-animate on state change), keyframe animations (multi-step sequences), phase animations (tap-triggered multi-phase), spring physics.
**API tables:** `.animate()` config, `KeyframeAnimation` builder, `PhaseAnimation` builder, curve/duration options.
**Source refs:** `examples/lib/api/animations/`, `examples/lib/docs/guides/animations/`

### `references/tokens.md`
**Patterns:** Defining tokens, providing tokens via `MixScope`, using tokens in styles, creating a theme.
**API tables:** `MixToken`, `ColorToken`, `SpaceToken`, `RadiusToken`, `MixScope` widget.
**Source refs:** `examples/lib/api/design_system/theme_tokens.dart`, `examples/lib/docs/tutorials/theming.dart`

### `references/widgets.md`
**Patterns:** When to use Box vs HBox vs VBox vs ZBox, Text vs StyledText, Pressable for interactivity.
**API tables:** Widget constructors, required/optional parameters, style parameter types.
**Source refs:** `examples/lib/api/box/`, `examples/lib/api/hbox/`, `examples/lib/api/vbox/`, `examples/lib/docs/widgets/`

### `references/examples.md`
**Organization:** Basic → Intermediate → Advanced complexity.
**Each example:** Description, full code, which concepts it demonstrates.
**Source refs:** Paths into `examples/lib/` for each example.

## Runtime Behavior

1. Main file loads — Claude reads core principles and routing table
2. Claude identifies intent — matches user's request to 1-2 reference files
3. Claude reads relevant references — uses Read tool to load only needed files
4. Claude writes code — following patterns and API from loaded references

## Key Decisions

- **Lazy loading:** Only load references needed for the current request
- **Rigid skill:** Claude must follow documented patterns, not guess at API
- **Source refs:** Point to `examples/lib/` files so Claude can read real implementations
- **External developer focus:** Patterns show how to USE Mix, not how to extend it
