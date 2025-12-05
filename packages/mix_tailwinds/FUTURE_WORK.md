# mix_tailwinds Future Work

Roadmap items for future development. These extend the current Tailwind CSS support.

---

## In Progress

### Variant-Aware Transforms

**Status**: Plan complete, ready for implementation

Tailwind's prefixed transforms (`hover:scale-110`, `md:rotate-45`) currently apply unconditionally. This makes transforms respect variant prefixes by integrating with Mix's variant system.

**Plan File**: `.claude/plans/parallel-forging-kahn.md`

**Key Changes**:
- Two-pass parsing: group transforms by prefix, then apply other tokens
- Component-wise inheritance (variants inherit base transform components)
- Remove external Transform wrapper from `tw_widget.dart`
- Transforms flow through Mix's animation system

**Files to Modify**:
| File | Changes |
|------|---------|
| `tw_parser.dart` | Add `_TransformAccum`, `_groupTransformsByPrefix`, variant helpers; modify `parseBox()`/`parseFlex()`; remove `parseTransform()` |
| `tw_widget.dart` | Remove Transform wrapper (lines 69-76) |
| `div_and_span_test.dart` | Add variant transform tests |

**References**:
- [Tailwind Transform](https://tailwindcss.com/docs/scale)
- `tw_parser.dart:640-698` - current parseTransform()
- `tw_parser.dart:702-748` - variant nesting logic (_applyPrefixedToken)

---

## Animation Extensions

### `motion-safe` / `motion-reduce` Variants

Tailwind's accessibility variants for reduced motion preferences.

**Implementation Notes**:
- Check `MediaQuery.disableAnimations` in Flutter
- Apply animation only when `motion-safe:` prefix is used and animations are enabled
- Skip animation when `motion-reduce:` prefix is used or system has reduced motion enabled

**Example**:
```dart
Div(
  classNames: 'motion-safe:transition motion-safe:duration-300 motion-reduce:transition-none',
  child: Text('Respects user motion preferences'),
)
```

**References**:
- [Tailwind prefers-reduced-motion](https://tailwindcss.com/docs/hover-focus-and-other-states#prefers-reduced-motion)

---

## Variants

### Additional State Variants

Currently supported: `hover`, `focus`, `active`, `pressed`, `disabled`, `enabled`, `dark`, `light` + breakpoints

**Missing variants**:

| Variant | Tailwind CSS | Flutter Mapping | Priority |
|---------|-------------|-----------------|----------|
| `focus-visible` | `:focus-visible` | `WidgetState.focused` + keyboard focus detection | High |
| `focus-within` | `:focus-within` | Needs FocusScope tracking | Medium |
| `first`, `last` | `:first-child`, `:last-child` | Requires parent context | Low |
| `odd`, `even` | `:nth-child(odd/even)` | Requires index context | Low |
| `not-*` | `not-hover:`, `not-disabled:` | Invert WidgetState check | Medium |

**References**:
- [Tailwind Pseudo-classes](https://tailwindcss.com/docs/hover-focus-and-other-states)
- `tw_parser.dart:237-268` - current variant maps

### Group and Peer Variants

Style elements based on parent or sibling state.

| Variant | Tailwind CSS | Flutter Mapping | Notes |
|---------|-------------|-----------------|-------|
| `group-hover` | `group-hover:` | Needs GroupProvider context | Parent state |
| `group-focus` | `group-focus:` | Needs GroupProvider context | Parent state |
| `peer-*` | `peer-hover:`, `peer-checked:` | Needs sibling state tracking | Sibling state |

**Implementation Notes**:
- Requires a context provider to track parent/sibling state
- Complex to implement correctly in Flutter's widget tree
- Consider if Mix has existing patterns for this

**References**:
- [Tailwind Group Styling](https://tailwindcss.com/docs/hover-focus-and-other-states#styling-based-on-parent-state)
- [Tailwind Peer Styling](https://tailwindcss.com/docs/hover-focus-and-other-states#styling-based-on-sibling-state)

### Container Query Variants

Apply styles based on container size instead of viewport.

**Example**: `@container md:bg-blue-500` - blue background when container is md width

**Implementation Notes**:
- Flutter doesn't have native container queries
- Would need LayoutBuilder-based detection
- Complex to implement efficiently

**References**:
- [Tailwind Container Queries](https://tailwindcss.com/docs/container)

---

## Filters & Effects

### Filters

CSS filter utilities for visual effects.

| Category | Tokens | Priority |
|----------|--------|----------|
| Blur | `blur-none`, `blur-sm`, `blur`, `blur-md`, `blur-lg`, `blur-xl`, `blur-2xl`, `blur-3xl` | High |
| Brightness | `brightness-0` through `brightness-200` | Medium |
| Contrast | `contrast-0` through `contrast-200` | Medium |
| Grayscale | `grayscale-0`, `grayscale` | Medium |
| Hue Rotate | `hue-rotate-0` through `hue-rotate-180`, `-hue-rotate-*` | Low |
| Invert | `invert-0`, `invert` | Low |
| Saturate | `saturate-0` through `saturate-200` | Medium |
| Sepia | `sepia-0`, `sepia` | Low |
| Drop Shadow | `drop-shadow-*` | Medium |

**Implementation Notes**:
- Use Flutter's `ImageFiltered` or `ColorFiltered` widgets
- Or `BackdropFilter` for backdrop effects
- Consider performance implications
- Note: Current `shadow-*` uses `boxShadows()` (box-shadow), not filter-based drop-shadow

**References**:
- [Tailwind Blur](https://tailwindcss.com/docs/blur)
- [Tailwind Filter](https://tailwindcss.com/docs/filter)
- `tw_parser.dart:19-25` - current shadow elevation tokens

### Backdrop Filters

Apply filters to content behind an element.

| Category | Tokens |
|----------|--------|
| Backdrop Blur | `backdrop-blur-*` |
| Backdrop Brightness | `backdrop-brightness-*` |
| Backdrop Contrast | `backdrop-contrast-*` |
| Backdrop Grayscale | `backdrop-grayscale-*` |
| Backdrop Saturate | `backdrop-saturate-*` |

**Implementation Notes**:
- Use Flutter's `BackdropFilter` widget
- Performance-intensive on mobile
- Consider limiting to specific use cases

**References**:
- [Tailwind Backdrop Filter](https://tailwindcss.com/docs/backdrop-blur)

### Text Shadows

Shadow effects for text.

| Tokens | Example |
|--------|---------|
| `text-shadow-sm`, `text-shadow`, `text-shadow-md`, `text-shadow-lg` | `text-shadow-md` |

**Implementation Notes**:
- Flutter's `TextStyle` has `shadows` property
- Similar implementation to box shadows but applied to text

**References**:
- [Tailwind Text Shadow](https://tailwindcss.com/docs/text-shadow) (v4.x feature)

---

## Transform Extensions

### 3D Transforms

3D transformation utilities.

| Category | Tokens | Notes |
|----------|--------|-------|
| Rotate X/Y | `rotate-x-*`, `rotate-y-*` | 3D rotation around X/Y axis |
| Translate Z | `translate-z-*` | 3D translation on Z axis |
| Perspective | `perspective-*` | 3D perspective distance |
| Perspective Origin | `perspective-origin-*` | Vanishing point |
| Preserve 3D | `transform-style-3d` | Preserve 3D for children |

**Implementation Notes**:
- Flutter's Matrix4 supports 3D transforms
- Need to set `perspective` entry for 3D effect
- Consider performance on complex 3D transforms

**References**:
- [Tailwind Transform 3D](https://tailwindcss.com/docs/rotate) (rotateX/Y in v4.x)
- [MDN transform-style](https://developer.mozilla.org/en-US/docs/Web/CSS/transform-style)

### Skew Transforms

**Status**: Deferred (YAGNI - rare use case)

| Tokens | Notes |
|--------|-------|
| `skew-x-*`, `skew-y-*` | Independent axis skewing |
| `-skew-x-*`, `-skew-y-*` | Negative skew values |

**Implementation Notes**:
- Matrix4 `setEntry` for skew values
- Already have `TransformStyleMixin.skew()` in Mix core

**References**:
- [Tailwind Skew](https://tailwindcss.com/docs/skew)
- `transform_style_mixin.dart:29-35` - existing skew implementation

### Transform Origin

**Status**: Deferred (center default covers 90%+ of use cases)

| Tokens | Flutter Alignment |
|--------|-------------------|
| `origin-center` | `Alignment.center` (default) |
| `origin-top`, `origin-bottom`, `origin-left`, `origin-right` | Corresponding alignments |
| `origin-top-left`, `origin-top-right`, etc. | Corner alignments |

**Implementation Notes**:
- Already supported via `transformAlignment` parameter
- Just need token parsing

**References**:
- [Tailwind Transform Origin](https://tailwindcss.com/docs/transform-origin)
- `box_style.dart:140-147` - transform() with alignment

### Independent Axis Scaling

**Status**: Deferred (YAGNI)

| Tokens |
|--------|
| `scale-x-*`, `scale-y-*` |

**Implementation Notes**:
- Use `Matrix4.diagonal3Values(scaleX, scaleY, 1.0)`
- Would require separate accumulator fields for scaleX/scaleY

**References**:
- [Tailwind Scale](https://tailwindcss.com/docs/scale)

---

## Dynamic Values

### Arbitrary Value Syntax

Custom values using bracket syntax: `[scale-1.5]`, `[rotate-37deg]`, `p-[13px]`

**Implementation Notes**:
- Parse bracket syntax: `[property-value]`
- Extract unit (px, rem, deg, %, etc.)
- Convert to Flutter units
- Already have some arbitrary color support

**Priority**: Medium - enables power users but adds parsing complexity

**References**:
- [Tailwind Arbitrary Values](https://tailwindcss.com/docs/adding-custom-styles#using-arbitrary-values)

---

## Gradients

### Expanded Gradient Support

Currently limited gradient support. Tailwind offers more options.

| Feature | Status | Notes |
|---------|--------|-------|
| `bg-gradient-to-*` | Partial | Basic directions implemented |
| Multiple color stops | Missing | `from-red-500 via-yellow-500 to-green-500` |
| Gradient positions | Missing | `from-10%`, `via-30%`, `to-90%` |
| Radial gradients | Missing | `bg-radial-*` (v4.x) |
| Conic gradients | Missing | `bg-conic-*` (v4.x) |

**References**:
- [Tailwind Gradients](https://tailwindcss.com/docs/background-image#gradient-color-stops)

---

## Performance Hints

### will-change Utilities

Hint to browser/engine about upcoming changes for optimization.

| Token | Flutter Mapping |
|-------|-----------------|
| `will-change-auto` | Default behavior |
| `will-change-scroll` | `saveLayer` hint |
| `will-change-contents` | Mark for repaint |
| `will-change-transform` | RepaintBoundary around transforms |

**Implementation Notes**:
- Flutter doesn't have direct `will-change` equivalent
- Could use `RepaintBoundary` for isolation
- Consider `saveLayer` for compositing hints
- May have limited practical benefit in Flutter

**References**:
- [Tailwind will-change](https://tailwindcss.com/docs/will-change)

---

## Mask Utilities

### CSS Mask Support

Masking utilities for complex clipping.

| Tokens | Notes |
|--------|-------|
| `mask-*` | Mask images |
| `mask-type-*` | Luminance or alpha |
| `mask-position-*` | Mask positioning |
| `mask-size-*` | Mask sizing |
| `mask-repeat-*` | Mask repetition |

**Implementation Notes**:
- Flutter uses `ShaderMask` or `ClipPath` for masking
- Complex to map CSS mask syntax to Flutter
- Consider limiting to common use cases

**References**:
- [Tailwind Mask](https://tailwindcss.com/docs/mask-image) (v4.x feature)

---

## Implemented Features

### Transform Utilities (Implemented)

Tailwind's transform utilities are now fully supported. Transforms build a single composite Matrix4 in Tailwind's fixed order (translate → rotate → scale), ensuring order-independent results.

**Supported Classes**:

| Category | Tokens |
|----------|--------|
| Scale | `scale-0`, `scale-50`, `scale-75`, `scale-90`, `scale-95`, `scale-100`, `scale-105`, `scale-110`, `scale-125`, `scale-150` |
| Rotate | `rotate-0`, `rotate-1`, `rotate-2`, `rotate-3`, `rotate-6`, `rotate-12`, `rotate-45`, `rotate-90`, `rotate-180` + negatives (`-rotate-*`) |
| Translate | `translate-x-{spacing}`, `translate-y-{spacing}` + negatives |

**Usage Example**:
```dart
Div(
  classNames: 'hover:scale-105 transition duration-300',
  child: Text('Hover to scale'),
)
```

**Key Behaviors**:
- `scale-105 rotate-45` produces the same result as `rotate-45 scale-105` (order independent, matching Tailwind)
- Single Transform widget wrapping for performance
- Prefix syntax is recognized: `hover:scale-105`, `md:rotate-45`, `dark:translate-x-4`

**Current Limitation**: Transforms apply unconditionally regardless of prefix. For example, `hover:scale-105` currently applies scale at all times, not just on hover. See "Variant-Aware Transforms" in the "In Progress" section for the planned fix.

---

## Priority Order

| Priority | Item | Rationale |
|----------|------|-----------|
| 1 | Variant-Aware Transforms | Core functionality, plan ready |
| 2 | motion-safe/motion-reduce | Accessibility compliance |
| 3 | Filters (blur, brightness) | Common visual effects |
| 4 | focus-visible variant | Accessibility, keyboard navigation |
| 5 | Text Shadows | Parity with box shadows |
| 6 | Arbitrary values | Power user feature |
| 7 | Additional variants | Completeness |
| 8 | 3D Transforms | Advanced use cases |
| 9 | Backdrop Filters | Performance-sensitive |
| 10 | Group/Peer variants | Complex implementation |
| 11 | Container queries | Non-trivial Flutter mapping |
