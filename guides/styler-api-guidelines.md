# Styler API Guidelines

## Purpose

Define the policy for static factory constructors on Styler classes. Factories enable dot-shorthand usage in nested/typed contexts while keeping top-level declarations explicit.

## The Rule

**Base style declaration (first style):**
1. Always start top-level style declarations with `BoxStyler()` (instance constructor), then chain methods
2. Do not use static factory constructors (`BoxStyler.color(...)`) or bare dot-shorthand (`.method()`) at top-level

**Nested style arguments (variants/state/typed params):**
1. Prefer bare shorthand `.method(args)` when the receiving type is known from context
2. Do not pass `BoxStyler().method()` as nested style arguments — use bare shorthand instead

Common typed contexts:
- `.container(.shadow(...))`
- `.onHovered(.color(...))`
- `.onDisabled(.color(...))`

Methods used **mid-chain or at the end** (animate, wrap, variants, etc.) do not need factories — they are never the entry point.

## Factory Constructors by Styler

### BoxStyler

| Category | Factories |
|---|---|
| Direct params | `alignment`, `padding`, `margin`, `constraints`, `decoration`, `foregroundDecoration`, `clipBehavior` |
| Decoration | `color`, `gradient`, `border`, `borderRadius`, `elevation`, `shadow`, `shadows` |
| Constraints | `width`, `height`, `size`, `minWidth`, `maxWidth`, `minHeight`, `maxHeight` |
| Transform | `scale`, `rotate` |
| Animation | `animate` |

### FlexStyler

| Category | Factories |
|---|---|
| Direct params | `direction`, `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, `spacing`, `clipBehavior` |
| Presets | `row`, `column` |

### FlexBoxStyler

All BoxStyler factories + all FlexStyler factories (combined).

### StackStyler

| Category | Factories |
|---|---|
| Direct params | `alignment`, `fit`, `clipBehavior` |

### StackBoxStyler

All BoxStyler factories + `stackAlignment`, `fit`.

### TextStyler

| Category | Factories |
|---|---|
| Layout | `overflow`, `textAlign`, `maxLines`, `softWrap`, `textDirection` |
| Typography | `style`, `color`, `fontSize`, `fontWeight`, `fontStyle`, `letterSpacing`, `wordSpacing`, `height`, `fontFamily`, `decoration` |

### IconStyler

| Category | Factories |
|---|---|
| All | `icon`, `color`, `size`, `weight`, `fill`, `opacity`, `shadows`, `shadow` |

### ImageStyler

| Category | Factories |
|---|---|
| All | `image`, `width`, `height`, `color`, `fit`, `alignment`, `repeat` |

## Methods WITHOUT Factories (chain-only)

These are used mid-chain or at the end. They should remain as instance methods:

| Category | Methods |
|---|---|
| Modifiers | `wrap`, `phaseAnimation`, `keyframeAnimation` |
| Compound spacing | `padding(.all(8))`, `padding(.horizontal(8))`, `padding(.vertical(8))`, `margin(.all(8))`, `margin(.horizontal(8))`, `margin(.vertical(8))`, `padding(.only(left: 8, right: 8))` |
| Compound border | `border(.all())`, `border(.top())`, `borderRadius(.circular())` |
| Compound box methods | `shadow(.color(...).blurRadius(...))`, `backgroundImageUrl` |
| Text directives | `uppercase`, `titlecase`, `sentencecase`, `reverse` |
| Variants | `onHovered`, `onPressed`, `onDark`, `onLight`, `onDisabled`, `onFocused`, `variant`, `onBreakpoint` |

**Rationale:** Factory constructors are reserved for primitives that map to stable style concepts. Compound convenience methods (spacing shortcuts, border shortcuts) remain as instance methods to keep the static API focused.

## Dot-Shorthand Usage

Use Dart 3.11+ inferred enum/constant shorthand when context is typed:
```dart
// Dot-shorthand for enum/constant arguments within chains
BoxStyler().alignment(.center)
FlexBoxStyler().mainAxisAlignment(.center)
StackBoxStyler().fit(.expand)
```

Use bare shorthand for nested typed style arguments:
```dart
final interactive = BoxStyler().color(Colors.blue)
  .onHovered(.shadow(.color(Colors.black12).blurRadius(10)))
  .onDisabled(.color(Colors.grey));
```

## Code Examples

```dart
// Top-level — always start with Styler() instance
BoxStyler().color(Colors.blue)
TextStyler().fontSize(18)
IconStyler().size(24)

// Chained — instance constructor then fluent chain
BoxStyler().color(Colors.blue).padding(.all(16)).borderRadius(.circular(8))

// Inside variants — bare shorthand in typed contexts
style.onHovered(.color(Colors.blue))
style.onDark(.color(Colors.white))

// Constraints and shadows
BoxStyler().minWidth(100).maxWidth(300)
BoxStyler().shadow(.color(Colors.black12).blurRadius(10))

// Compound methods (chain-only, no static factories)
BoxStyler().border(.all(.color(Colors.red).width(2)))
BoxStyler().padding(.all(16)).borderRadius(.circular(8))
final directive = TextStyler().uppercase().fontSize(18);

// Mid-chain methods
BoxStyler().color(Colors.blue).animate(.easeInOut(100.ms))
BoxStyler().padding(.all(16)).wrap(.new().align(alignment: .center))
```

## Testing Requirements

For each styler with static factories:
- Verify each factory matches the equivalent instance-chain result
- Include at least one dot-shorthand assignment test
- Test files: `packages/mix/test/src/specs/<type>/<type>_style_factory_test.dart`

## Audit Checklist

When adding or editing static factories:
1. Update style file factory section and constructors
2. Update corresponding `*_style_factory_test.dart`
3. Run `dart format` and targeted tests
4. Run `dart analyze`
