# Styler API Guidelines

## Purpose

Define the policy for static factory constructors on Styler classes, enabling dot-shorthand usage while avoiding API bloat.

## The Rule

**Convert `Styler().method(args)` → `Styler.method(args)` when:**
1. The method is the **first call** in the chain
2. The method has a matching factory constructor (see tables below)

Methods used **mid-chain or at the end** (animate, wrap, variants, etc.) do not need factories — they are never the entry point.

## Factory Constructors by Styler

### BoxStyler

| Category | Factories |
|---|---|
| Direct params | `alignment`, `padding`, `margin`, `constraints`, `decoration`, `foregroundDecoration`, `clipBehavior` |
| Decoration | `color`, `gradient`, `border`, `borderRadius`, `elevation` |
| Spacing | `paddingAll`, `paddingX`, `paddingY`, `marginAll`, `marginX`, `marginY` |
| Border radius | `borderRounded` |
| Constraints | `width`, `height`, `size` |
| Transform | `scale`, `rotate` |

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
| All | `icon`, `color`, `size`, `weight`, `fill`, `opacity`, `shadows` |

### ImageStyler

| Category | Factories |
|---|---|
| All | `image`, `width`, `height`, `color`, `fit`, `alignment`, `repeat` |

## Methods WITHOUT Factories (chain-only)

These are used mid-chain or at the end. They should remain as instance methods:

| Category | Methods |
|---|---|
| Animation/modifiers | `animate`, `wrap`, `phaseAnimation`, `keyframeAnimation` |
| Compound box methods | `borderAll`, `borderTop`, `shadowOnly`, `backgroundImageUrl`, `paddingOnly`, `minWidth`, `maxWidth`, `minHeight` |
| Text directives | `uppercase`, `titlecase`, `sentencecase`, `reverse` |
| Variants | `onHovered`, `onPressed`, `onDark`, `onLight`, `onDisabled`, `onFocused`, `variant`, `onBreakpoint` |

**Rationale:** These methods are never used as the first call in a chain. Adding factory constructors for them would add API surface with no practical benefit.

## Dot-Shorthand Usage

Use Dart 3.10+ inferred enum/constant shorthand when context is typed:
```dart
BoxStyler.alignment(.center)
FlexBoxStyler.mainAxisAlignment(.center)
StackBoxStyler.fit(.expand)
FlexStyler.row()  // preset for direction: .horizontal
```

## Code Examples

```dart
// Simple — factory replaces Styler() + first method
BoxStyler.color(Colors.blue)
TextStyler.fontSize(18)
IconStyler.size(24)

// Chained — only the first call uses the factory
BoxStyler.color(Colors.blue).paddingAll(16).borderRounded(8)

// Inside variants — saves parens in common patterns
style.onHovered(BoxStyler.color(Colors.blue))
style.onDark(TextStyler.color(Colors.white))

// Chain-only methods stay as Styler().method()
BoxStyler().borderAll(color: Colors.red, width: 2)
BoxStyler().minWidth(100).maxWidth(300)
TextStyler().uppercase().fontSize(18)

// Mid-chain methods — no change needed
BoxStyler.color(Colors.blue).animate(.easeInOut(100.ms))
BoxStyler.paddingAll(16).wrap(.new().align(alignment: .center))
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
