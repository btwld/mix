# Styler API Guidelines

## Purpose

Define the policy for static factory constructors on Styler classes, enabling dot-shorthand usage while avoiding API bloat.

## The Rule

**Base style declaration (first style):**
1. `Styler().chain` is valid and preferred for top-level style declarations
2. `Styler.factory(...)` is also valid when it improves readability

**Nested style arguments (variants/state/typed params):**
1. Prefer shorthand `.method(args)` when the receiving type is known
2. Do not pass `Styler().chain` as nested style arguments

Common typed contexts:
- `style: .color(...)`
- `.container(.shadow(...))`
- `.onHovered(.color(...))`

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
| Compound spacing | `padding(.all())`, `padding(.horizontal())`, `padding(.vertical())`, `margin(.all())`, `marginX`, `marginY`, `padding(.only())` |
| Compound border | `border(.all())`, `border(.top())`, `borderRadius(.circular())` |
| Compound box methods | `shadow(.color(...).blurRadius(...))`, `backgroundImageUrl` |
| Text directives | `uppercase`, `titlecase`, `sentencecase`, `reverse` |
| Variants | `onHovered`, `onPressed`, `onDark`, `onLight`, `onDisabled`, `onFocused`, `variant`, `onBreakpoint` |

**Rationale:** Factory constructors are reserved for primitives that map to stable style concepts. Compound convenience methods (spacing shortcuts, border shortcuts) remain as instance methods to keep the static API focused.

## Dot-Shorthand Usage

Use Dart 3.11+ inferred enum/constant shorthand when context is typed:
```dart
BoxStyler.alignment(.center)
FlexBoxStyler.mainAxisAlignment(.center)
StackBoxStyler.fit(.expand)
FlexStyler.row()  // preset for direction: .horizontal
```

Use shorthand for typed style arguments too:
```dart
final interactive = BoxStyler.color(Colors.blue)
  .onHovered(.shadow(.color(Colors.black12).blurRadius(10)))
  .onDisabled(.color(Colors.grey));
```

## Code Examples

```dart
// Simple — factory replaces Styler() + first method
BoxStyler.color(Colors.blue)
TextStyler.fontSize(18)
IconStyler.size(24)

// Chained — only the first call uses the factory
BoxStyler.color(Colors.blue).padding(.all(16)).borderRadius(.circular(8))

// Inside variants — saves parens in common patterns
style.onHovered(.color(Colors.blue))
style.onDark(.color(Colors.white))

// Constraint and shadow entry points
BoxStyler.minWidth(100).maxWidth(300)
BoxStyler.shadow(.color(Colors.black12).blurRadius(10))

// Chain-only methods stay as Styler().method()
BoxStyler.border(.all(.color(Colors.red).width(2)))
BoxStyler.padding(.all(16)).borderRadius(.circular(8))
final directive = TextStyler().uppercase().fontSize(18);

// Mid-chain methods — no change needed
BoxStyler.color(Colors.blue).animate(.easeInOut(100.ms))
BoxStyler.padding(.all(16)).wrap(.new().align(alignment: .center))
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
