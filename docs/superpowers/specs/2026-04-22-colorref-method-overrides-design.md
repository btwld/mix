# ColorRef: Override Non-Deprecated Color Transform Methods With Directives

## Problem

`ColorRef` (in `packages/mix/lib/src/theme/tokens/token_refs.dart`) is a token
reference that `implements Color`. It satisfies the `Color` interface by
relying on `ValueRef<Color>.noSuchMethod`, which throws
`UnimplementedError` with a helpful message for any member access.

That is correct for members that require a resolved value (accessors like
`a`, `r`, `g`, `b`, `colorSpace`, `toARGB32()`, `computeLuminance()`) — those
need a `BuildContext` to resolve the token.

It is **wrong** for the transform methods that return a new `Color`
(`withValues`, `withAlpha`, `withRed`, `withGreen`, `withBlue`,
`withOpacity`). These represent a transformation that can be *deferred* until
resolution. The `directive.dart` file already defines a directive for every
one of these transforms
(`WithValuesColorDirective`, `AlphaColorDirective`, `WithRedColorDirective`,
`WithGreenColorDirective`, `WithBlueColorDirective`, `OpacityColorDirective`) —
but nothing currently wires them up.

Today, calling `someColorRef.withAlpha(128)` throws. It should instead return
a new `ColorRef` carrying an `AlphaColorDirective(128)` to be applied at
resolution time.

## Goal

Let users chain `Color` transform methods fluently on a `ColorRef`. Each
chained call appends a directive to the underlying `Prop<Color>`. At
resolution, the base color is resolved from the token and each directive is
applied in order.

## Non-Goals

- Not overriding accessors (`a`, `r`, `g`, `b`, `colorSpace`, `toARGB32()`,
  `computeLuminance()`). They continue to fall through to
  `ValueRef.noSuchMethod`.
- Not overriding deprecated int getters (`value`, `alpha`, `red`, `green`,
  `blue`, `opacity`). They continue to fall through to `noSuchMethod`.
- Not exposing HSL-based directives (`darken`, `lighten`, `saturate`, etc.)
  on `ColorRef`. Those are extension methods in `internal_extensions.dart` and
  use static dispatch — they cannot be overridden. Out of scope.
- No new directive classes — all six transforms already have matching
  directives in `directive.dart`.

## Design

Six instance-method overrides on `ColorRef`. Each constructs the matching
directive, appends it to the underlying `Prop<Color>` via the inherited
`directives(...)` helper, and wraps the result in a new `ColorRef`.

```dart
final class ColorRef extends Prop<Color>
    with ValueRef<Color>
    implements Color {
  ColorRef(super.prop) : super.fromProp();

  @override
  Color withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) => ColorRef(directives([
        WithValuesColorDirective(
          alpha: alpha,
          red: red,
          green: green,
          blue: blue,
          colorSpace: colorSpace,
        ),
      ]));

  @override
  Color withAlpha(int a) => ColorRef(directives([AlphaColorDirective(a)]));

  @override
  Color withRed(int r) => ColorRef(directives([WithRedColorDirective(r)]));

  @override
  Color withGreen(int g) => ColorRef(directives([WithGreenColorDirective(g)]));

  @override
  Color withBlue(int b) => ColorRef(directives([WithBlueColorDirective(b)]));

  @override
  Color withOpacity(double opacity) =>
      ColorRef(directives([OpacityColorDirective(opacity)]));
}
```

### Notes

- `directives(...)` is inherited from `Prop` and returns `Prop<Color>` with
  the new directives merged into any existing ones. Wrapping it in
  `ColorRef(...)` preserves the token-reference identity.
- Return type is declared as `Color` (to satisfy the `Color` interface) but
  the actual runtime type is `ColorRef`. Callers that hold a `ColorRef`
  typed variable keep the concrete type; callers that hold a `Color` typed
  variable continue to see `Color`.
- `operator ==`, `hashCode`, `toString()` remain inherited from `Prop`.
  No change.
- The deprecation marker on `withOpacity` is **not** propagated to the
  override (per the author's instruction). Callers through the `Color`
  interface still see the upstream deprecation; callers through `ColorRef`
  do not.

### Resolution flow (unchanged)

1. `Prop<Color>.resolveProp(context)` resolves the `TokenSource` to a
   concrete `Color` from `MixScope`.
2. `PropOps.applyDirectives` iterates the `$directives` list and calls
   `apply(value)` on each, in order.

The six transforms already define `apply(Color)` correctly, so no resolution
logic changes.

## Tests

Add a new test group in `packages/mix/test/src/core/prop_refs_test.dart`
(the file that already covers `ColorRef` behavior) — or a new
`colorref_overrides_test.dart` file under the same folder if that reads
cleaner. Cover:

1. **Each override produces a `ColorRef` with the expected directive.**
   For every one of the six methods, call it on a plain `ColorRef` and
   assert:
   - The result is a `ColorRef` (not a plain `Prop<Color>` or a raw
     `Color`).
   - `$directives` contains exactly the directive class expected, with the
     expected constructor arguments.
   - The underlying `sources` list is preserved (still a `TokenSource` for
     the original token).

2. **Chaining accumulates directives in call order.**
   `ref.withAlpha(10).withRed(20).withBlue(30)` → a `ColorRef` whose
   `$directives` is `[AlphaColorDirective(10), WithRedColorDirective(20),
   WithBlueColorDirective(30)]` in that exact order.

3. **Resolution applies directives after the token resolves.**
   Set up a `MixScope` that resolves the token to a known `Color`. Call
   `.resolveProp(context)` on a chained `ColorRef` and assert the result
   equals manually applying the directives to the base color.

4. **Regression: accessors and deprecated members still throw via
   `noSuchMethod`.** Confirm that `colorRef.a`, `colorRef.r`,
   `colorRef.computeLuminance()`, `(colorRef as dynamic).alpha`, etc. still
   throw `UnimplementedError` with the "Cannot access" message. Guards the
   non-goal boundary: we do not accidentally broaden the override surface.

5. **`withValues` with multiple named args round-trips.** All five
   parameters (`alpha`, `red`, `green`, `blue`, `colorSpace`) pass through
   to `WithValuesColorDirective` correctly.

## Risks

- `directives(...)` on `Prop` has a name collision potential with future
  `Color` API if Flutter ever adds a `directives` member. Not a current
  concern, just noted.
- The override declares return type `Color` but constructs `ColorRef`. If
  a caller later passes the result to `Color.lerp` or similar, it flows
  through as a `Color`; the directives accumulate but are invisible unless
  resolved through Mix. This is consistent with how all the other
  `*Ref` types behave when passed outside the Mix resolution path.

## Out of scope

- Refactoring `directive.dart`.
- Adding HSL fluent API (`darken`/`lighten`/etc.) to `ColorRef`.
- Touching any other `*Ref` class.
