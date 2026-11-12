# Custom values and converters

`Prop.value<T>(value)` can carry a custom value without a converter. With only
value/token sources, the last resolved value wins. For example, an application
decoration can be used through the public constructor:

```dart
final style = BoxStyler.create(
  decoration: Prop.value<Decoration>(customDecoration),
).padding(.all(12));
```

This composes with properties such as padding and constraints, which do not
modify the decoration. `DecorationMix.value` is a different API: it constructs
the built-in fieldwise representation and supports `BoxDecoration` and
`ShapeDecoration`, not arbitrary `Decoration` subclasses.

## Fieldwise composition

When a property contains a `Prop.mix` source, Mix attempts to convert its plain
values and resolved tokens to `Mix<T>` before merging. For example,
`BoxStyler().color(...)` contributes a `BoxDecorationMix` to the decoration
property. Combining that with an arbitrary raw decoration requires conversion
and compatible merge behavior; `Prop.value` is not an atomic replacement marker
in this mixed-source case. There is no general rule for recoloring an opaque
decoration, and the built-in converter rejects unsupported decoration types.

For custom fieldwise composition, implement `Mix<T>` and supply it through
`Prop.mix` to the styler's `.create()` constructor. The implementation owns
resolution, equality (`props`), and `merge`. For example, a `PatternDecorationMix`
can merge its own ink and spacing fields and resolve a `PatternDecoration`:

```dart
final base = BoxStyler.create(
  decoration: Prop.mix<Decoration>(PatternDecorationMix(ink: inkToken())),
);
final override = BoxStyler.create(
  decoration: Prop.mix<Decoration>(PatternDecorationMix(spacing: 12)),
);
final style = base.merge(override);
```

`PatternDecorationMix` here is an application-defined `Mix<Decoration>`, not a
subclass of sealed `DecorationMix`. Its merge contract must support every Mix
type it will encounter. Registering a converter does not teach a built-in
`BoxDecorationMix` to merge with an unrelated custom Mix. Use compatible custom
patches for the custom property, or a dedicated generated spec/styler whose
renderer consumes that resolved value.

## Register conversion when raw values also need to participate

Converters are selected by the property's **type argument**, not by the
value's runtime subtype. A `Prop<Decoration>` requests a
`MixConverter<Decoration>`, even when the value is a `PatternDecoration`.
Registering only `MixConverter<PatternDecoration>` will not handle that request.

```dart
// At app startup, for a custom property pipeline whose Mix values share a
// compatible merge contract:
MixConverterRegistry.instance.register<Decoration>(
  SimpleMixConverter<Decoration>(MyDecorationMix.fromDecoration),
);
```

`MyDecorationMix.fromDecoration` is an application-defined conversion function
returning `Mix<Decoration>`. A registration replaces the converter for that
exact type globally, so it must account for every value the application passes
through that type. Built-ins initialize before registration; the first
conversion does not overwrite a startup registration. Later registrations for
the same type take precedence.

`tryConvert<T>` returns null when no converter is registered for `T`.
Exceptions from a registered converter still propagate; it is not a blanket
exception-catching API. Explicit `Prop.mix` avoids conversion for that source,
but other raw sources in the same property can still require converters.

Custom painting can consume a resolved spec without changing Mix itself.
Keep painting behavior and custom merge semantics in the component that owns
them; use Mix for its typed styling inputs, tokens, variants, and modifiers.
