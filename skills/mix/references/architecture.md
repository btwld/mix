# Architecture

Portable model of Mix's resolution pipeline. For repository history and pending
proposals, see the [architecture decision log](https://github.com/btwld/mix/blob/main/ARCHITECTURE.md).
Confirm exact signatures in the installed version.

## Spec, Styler and Widget

A `Spec<S>` stores immutable resolved data and supports copying, interpolation
and equality. Widget-backed specs commonly use `@MixableSpec(target: Foo.new)`
and a generated `_$FooSpec` mixin. Nullable fields leave defaults to rendering.
Use `copyWith()` for changes; do not mutate shared specs.

A `Style<S>` resolves to `StyleSpec<S>`, which combines the spec with animation
and resolved modifiers. Generated stylers extend `MixStyler` and return new
merged instances. `.create()` takes `Prop<V>` fields; normal constructors and
fluent methods accept the ergonomic Flutter/Mix surface.

A `StyleWidget<S>` accepts a style or a pre-resolved `styleSpec`. The latter
bypasses style resolution, not all rendering behavior. Generated callable
stylers construct compatible target widgets. Plain Widget targets need a
compatible named `style` parameter, not inheritance from `StyleWidget`.

## Props and Mix values

`Prop<V>` defers a value until context is available:

| Source | Construction | Behavior |
|---|---|---|
| Concrete value | `Prop.value(v)` | Replacement at resolution |
| Token | `Prop.token(token)` | Resolve a named value or context default |
| Mix value | `Prop.mix(mix)` | Accumulate fieldwise, then resolve |
| Directives only | `Prop.directives(...)` | Transform the resolved value |

`Prop.maybe` and `maybeMix` return null for null inputs. `mergeProp()` collects
sources; during resolution Mix converters may convert compatible plain values
for accumulation. If only plain values remain, the last wins. Directives merge
and run after resolving sources. Avoid describing all style merges as either
unconditional replacement or deep merge.

A `Mix<V>` is a resolvable intermediate value, such as `EdgeInsetsGeometryMix`.
Separate partial Mix inputs can contribute different sides of padding. A later
plain whole value and a later partial Mix value therefore need not behave alike.

## Resolution pipeline

1. `StyleBuilder` builds the style in context and merges active variants.
2. Active patches without declared widget-state dependencies merge first;
   state-dependent patches merge last, stably in declaration order per group.
3. `resolve()` resolves property sources and directives into `StyleSpec<S>`.
4. Style animation interpolates compatible specs.
5. The widget maps spec values to Flutter rendering.
6. Providers expose the resolved style; modifiers wrap the rendered widget.

`StyleVariation` results skip recursive variant merging. `FocusVisibleVariant`
is state-dependent even though it is not a `WidgetStateVariant`; declared
dependencies determine priority. Read [variants](variants.md) before extending
tracking or activation behavior.

## Tokens and wrappers

`MixScope` supplies token values and inherited modifier order. Ordinary tokens
need values; `ContextToken` can compute a default without a scope. A plain
nested scope shadows, while `MixScope.inherit` merges partial overrides.

Modifiers are resolved specs that wrap widgets. A style-local modifier order
wins over the nearest scope and package default; remaining configured types
are appended stably. The resolved order is outermost to innermost, so rendering
wraps the list in reverse. See [modifiers](widget-modifiers-directives.md).

## Where to inspect source

In a Mix checkout: `packages/mix/lib/src/core/` owns resolution, `theme/` owns
scopes/tokens, `modifiers/` owns wrappers, and `specs/box/` is the generated
Spec/Styler/Widget reference. Outside the repo, inspect the resolved package
source or version-pinned API docs rather than copying a declaration catalog.
