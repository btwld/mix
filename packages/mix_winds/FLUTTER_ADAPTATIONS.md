# Flutter adaptations for Tailwind parity

Tailwind candidates compile into Mix stylers and typed Flutter layout plans.
Widgets evaluate the plan where live constraints or parent data are required;
they do not run a second token interpreter. A portable styler alone may omit
runtime behavior. See the [compiler decision](../../ARCHITECTURE.md#winds-compiler-and-flutter-runtime)
and the [visual comparison workflow](COMPARISON_TESTING.md).

## Flex distribution

CSS `flex-1` uses `flex: 1 1 0%`: padding, border and margin remain outside the
zero content basis. When positive content space remains, an owned Tailwind
`Div` flex reserves these extents before distributing the remainder. Two
`flex-1` items in 900px, with 42px of padding/border on only the first, become
471px and 429px rather than two 450px outer boxes.

The adapter delegates measurement and final layout to `RenderFlex`, adjusting
flex-factor ratios for a second pass only when needed. Native `Row`/`Column`
parents retain Flutter's outer-box distribution. The adapter does not replace
CSS min/max freezing or scaled shrink-factor resolution wholesale.

Boundaries:

- If non-content extents consume the line, the adapter falls back to Flutter
  outer-box allocation rather than reproducing CSS's overflowing minimum.
  Move padding/border to an inner `Div` when that boundary must match exactly.
- Hover/press/focus changes to item margin, padding or border widths are not fed
  back into parent distribution. Keep extents stable or animate an inner box.
- CSS flex items have an automatic content-based minimum. Flutter has no
  equivalent phase. Keep `min-w-0` in shared browser markup when needed;
  `min-w-auto` cannot restore CSS's rule inside a Flutter flex parent.

## Alignment, truncation and clipping

`self-start`, `self-center`, and `self-end` override cross-axis positioning.
A `RenderFlex` subclass adjusts those offsets after the container knows its
cross extent; self alignment itself does not add a layout pass. `self-auto`
uses container alignment and is a no-op.

Text truncation needs a bounded width. Use `TruncatedP` or put a `P` with
`truncate` inside a constrained `Div` such as `flex-1 min-w-0`.

**CSS overflow defaults to visible.** Rounded corners alone do not generally
clip descendants. For clipping parity, request `overflow-hidden` explicitly on
the relevant container in both implementations; request truncation separately
on text. Flutter likewise does not clip all overflowing children implicitly.

## Default Typography Parity

Normalize global typography before diagnosing utility mappings. Flutter theme
inheritance can otherwise override the browser's base font metrics. `H1`–`H6`
intentionally have no default heading styles.

| Concern | Configuration |
|---|---|
| Utility colors, spacing, radii, breakpoints, font sizes | `TwConfig.standard().copyWith(...)` scales |
| Base family, size, tracking, line height | `TwConfig.textDefaults` through `TwScope` |
| Application semantics | `MixScope` tokens |
| Native platform typography | `TwTextDefaults.platformDefault()` |

```dart
final base = TwConfig.standard();
final config = base.copyWith(
  colors: {...base.colors, 'brand-500': const Color(0xFF4F46E5)},
  textDefaults: base.textDefaults.copyWith(
    fontFamily: 'Inter',
    fontSize: 16,
    letterSpacing: 0,
    lineHeight: 1.5,
  ),
);

TwScope(config: config, child: MyApp());
```

`TwScope` installs the config provider, tokenized defaults in `MixScope`, and
`TextScope`. Use the same scale configuration for utility parsing and semantic
Mix styles; it does not override `ThemeData.textTheme`.

## Parser and variant boundaries

The generated parser registry recognizes more CSS syntax than Flutter can
represent. Unsupported candidates are not silently converted to unconditional
styles. Use `onDiagnostic` to inspect the code, original token, reason and
available workaround.

| Tailwind feature | Current adaptation |
|---|---|
| `group-*`, `peer-*` | Parsed, ignored and diagnosed; no relative selector state |
| Arbitrary selectors (`[&_p]:mt-4`) | Parsed, ignored and diagnosed; no descendant CSS targeting |
| Container queries (`@...`) | Parsed, ignored and diagnosed; no matching container-query semantics |
| `!important` | Parsed, ignored and diagnosed; no CSS cascade priority model |
| Arbitrary properties (`[color:red]`) | Parsed, ignored and diagnosed; no safe typed mapping |
| `from`/`via`/`to` | Accumulated into `LinearGradientMix` |
| `bg-*/50` | Flutter alpha approximation; no CSS color-mix/OKLAB equivalent |

Translator output is exercised through encode → strict decode → canonical
re-encode using a development-only Protocol dependency. This checks portable
style output, not widget-runtime equivalence.

### Compatibility Ledger Status Notes

The generated compatibility ledger records current behavior, including differences
that still require a 1.0 decision. A ledger entry is an accounting statement, not a
promise that the adaptation is final.

| Tailwind feature | Current mix_winds behavior |
|---|---|
| `active:` | Uses Mix's pressed widget state. |
| `focus-visible:` | Uses Mix's focus-visible state, driven by Mix's app-wide input modality rather than CSS's per-element focus heuristics. As in CSS, focus stops matching after a pointer press until the next keyboard input. Unlike CSS, a text input focused by a pointer press does not match. |
| `dark:` | Uses Flutter platform brightness rather than a CSS selector strategy. |
| `light:` | A mix_winds parser-registry extension that uses Flutter platform brightness as the inverse of `dark:`. |
| `not-hover:` | Uses Mix's inverse-hover runtime state. This is partial support for Tailwind's compound `not` variant; other `not-*` forms remain unsupported and are reported through `onDiagnostic`. |
| `theme-midnight:` | Unsupported and reported through `onDiagnostic`; custom named theme variants require an explicit application-level design. |
| `2xl:` / `3xl:` | `2xl:` uses the standard Flutter breakpoint configuration. `3xl:` is not present in `TwConfig.standard().breakpoints`, so it is unsupported unless the runtime configuration and compatibility policy are extended together. |
| `w-auto` / `h-auto` | Clear the corresponding Flutter minimum and maximum constraints. This is the Flutter representation of automatic sizing, rather than CSS intrinsic layout. |
| `block` | Has no observable style or widget-layout implementation and is classified as unsupported. |


## Responsive runtime selection

The compiler emits declarations for sizing, external margins, flex parent data,
axis and gaps. Widgets resolve those declarations using live constraints.
Responsive widths include fixed, fractional, full and automatic values;
`w-auto` and `h-auto` clear earlier fixed constraints.

Use positive viewport width when available. Otherwise, widget-owned layout
inherits the enclosing Tw flex's responsive width, then falls back to local
constraints without a Tw flex scope. Nested flexes inherit that same width even
when allocated less space, keeping reserved and applied margins consistent.
Native `Row`/`Column` use local fallback. Padding and border variants always
use viewport width, as Mix breakpoints do.

Intrinsic measurement of responsive margins requires a positive viewport or
an enclosing Tw flex scope; without either, selection needs layout constraints.

## Actionable elements

Use `Button` for button counterparts: one Mix `Pressable` owns hover, press,
focus, focus-visible, keyboard activation, disabled state and button semantics.
A null `onPressed` disables it unless `onLongPress` supplies an action. External
margin is outside hit and semantics bounds. Use `Div` for structural elements
and non-button tags, including links.

## Unsupported values and workarounds

| Feature | Boundary / alternative |
|---|---|
| Arbitrary percentages (`w-[50%]`, `h-[25%]`) | Parsed, not applied; use `w-1/2`, `h-1/4` or `FractionallySizedBox` |
| Fractional/percent translation | Unsupported; use pixel values or measured Flutter transforms |
| Fractional/full/arbitrary `basis-*` | Unsupported and diagnosed; spacing-scale basis and `basis-auto` work; `w-1/2 flex-none` approximates a half basis |
| `rgb()`/`hsl()` arbitrary colors | Unsupported; use CSS 3/4/6/8-digit hex or configured colors |

### Text Block Margin Variants

**Tailwind CSS:**
```html
<p className="m-2 hover:m-4">...</p>
```
- Margin changes on hover

**Current Limitation:**
- `P` and heading margins support unprefixed positive utilities such as `mb-4`
  and configured viewport breakpoints such as `md:mb-4`
- `hover:m-4`, `dark:m-2`, `group-hover:m-4`, `@md:m-4`, and selector variants like `[&_p]:mt-4` are skipped instead of becoming unconditional margins
- CSS-semantic box wrappers such as `Div` have the same limitation for
  interactive and contextual margin variants
- Semantic widget compilation reports supported margin utilities with interactive
  variants as `widgetLayerVariantUnsupported`. `Div` and `Button` deliver this
  diagnostic through `onDiagnostic`.
- `TwParser.compileText` and `compileIcon` report this limitation for their
  supported external margins. Direct Box and Flex styler compilation retains
  supported margin variants because Mix can apply those variants.
- Ignored context, container, and selector variants retain their existing
  diagnostic categories.

**Workaround:**
```dart
// Apply interactive padding to a wrapping Div.
Div(
  classNames: 'p-2 hover:p-4',
  child: P(text: '...'),
)

// Or handle margin changes manually with StatefulWidget
```

**Why:** The widget applies external margin outside `StyleBuilder` to preserve the hit-test area.
The compiled layout plan selects viewport breakpoints. The layout plan does not
evaluate interactive or contextual margin variants, so the compiler reports their limitations.
