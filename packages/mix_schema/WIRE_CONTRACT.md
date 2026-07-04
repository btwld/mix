# mix_schema Wire Contract

This document is the source of truth for JSON payloads accepted and produced by
`mix_schema`. The schema encodes representable Mix values, not every possible
runtime object.

## Root Envelope

Every top-level style document is an object with:

- `v`: integer wire-format version. Current version: `1`.
- `type`: styler discriminator.
- styler fields for the selected `type`.

Nested styler objects inside variants or composite stylers do not carry `v`;
they are governed by the enclosing top-level document version.

Styler discriminator values are:

- `box`
- `text`
- `flex`
- `stack`
- `icon`
- `image`
- `flex_box`
- `stack_box`

An unregistered root `type` fails with `unknown_type`.

The full built-in contract accepts all branches above. The shared
`builtInMixSchemaContract` is registry-free and accepts every built-in branch,
including `icon` and `image`. String identity names are resolved per call with
`MixSchemaDecodeOptions`; common icon/image value forms require no app state.

During the v1 transition window, a missing top-level `v` is decoded as v1 with
a warning. Encoded output and exported JSON Schema are canonical and include
`v: 1`. Validation reports the same transition warning even when the document
has other fatal schema errors. Unsupported or malformed `v` fails with
`unsupported_version`.

Missing fields stay unset; Mix runtime defaults are not injected by the schema.
Absent required fields fail with `required_field`.

## Null Semantics

Explicit JSON `null` is forbidden everywhere. Omit a key to leave a field unset.
Null input fails before schema traversal with `null_forbidden` at the offending
path.

Unbounded max box constraints use the string sentinel `"infinity"` for
`maxWidth` and `maxHeight`; this is not a general nullable-field exception.

## Decode Modes

Strict decode is the default and rejects unknown fields, unknown discriminator
values, and unknown enum values anywhere in the document.

Lenient decode is explicit opt-in through `MixSchemaDecodeOptions`. It is only
for forward-compatible additive data. Unknown fields, unknown nested
discriminators, and unknown enum values are skipped at the smallest repairable
property or list entry:

- a styler field for normal styler properties,
- a variant entry for unknown variant data,
- a modifier entry for unknown modifier data,
- the specific `$merge`, `apply`, `modifiers.order`, `modifiers.items`,
  gradient color/stop, shadow, or typography-list entry when that narrower
  removal keeps the surrounding value valid.

The skipped item is reported as a warning with the original path. Structural
problems remain fatal in both modes: bad `v`, unknown root `type`, explicit
null, malformed known fields, and resource-limit failures.

Lenient cleanup removes at most 256 payload properties or entries per decode.
If the document still requires more cleanup, decode fails with `limit_exceeded`
and returns the warnings collected before the cap was hit.

## Versioning & Evolution

Within v1, producers may add new fields, new variant/modifier kinds, new enum
values, and future token kinds. Old strict clients reject those additions. Old
lenient clients degrade by skipping the smallest repairable property, nested
property, or list entry and reporting warnings.

Changing the meaning, unit, type, or canonical spelling of an existing key is
not additive; that requires `v: 2`. Renames must be represented as a new key in
the current version, with the old key documented as deprecated until a future
major format version removes it.

Producers may rely on strict clients failing closed for untrusted data and on
lenient clients applying only fully-known composite values. This codec is an
endpoint and does not preserve unknown fields for proxying.

## Input Limits

Decode and validation preflight untrusted input before Ack traversal:

- maximum nesting depth: 64
- maximum node count: 10,000

Exceeding either cap fails with `limit_exceeded` at the path where the cap is
crossed.

## Generic Diagnostics

`type_mismatch` reports a decoded value that does not match the caller's
requested `decode<T>()` type. `validation_failed` reports an engine validation
failure that does not map to a narrower public code. `transform_failed` reports
a decode or encode transform that threw while processing a value.

## Styler Fields

All field names use lower camel case. `modifiers`, `variants`, and `animation`
are style metadata fields, not spec fields.

### box

- `alignment`: alignment
- `padding`: edge insets
- `margin`: edge insets
- `constraints`: box constraints
- `clipBehavior`: enum name from `Clip`
- `transform`: 16-number `Matrix4` storage list
- `transformAlignment`: alignment
- `decoration`: box decoration
- `foregroundDecoration`: box decoration
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### text

- `overflow`: `clip`, `fade`, `ellipsis`, `visible`
- `textAlign`: `left`, `right`, `center`, `justify`, `start`, `end`
- `strutStyle`: strut style
- `textScaler`: `{ "linear": number }`
- `maxLines`: positive integer
- `style`: text style
- `textWidthBasis`: enum name from `TextWidthBasis`
- `textDirection`: `ltr`, `rtl`
- `softWrap`: boolean
- `selectionColor`: color
- `semanticsLabel`: string
- `locale`: locale object
- `textHeightBehavior`: text height behavior
- `textDirectives`: list of text directive names
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### flex

- `direction`: enum name from `Axis`
- `mainAxisAlignment`: enum name from `MainAxisAlignment`
- `crossAxisAlignment`: enum name from `CrossAxisAlignment`
- `mainAxisSize`: enum name from `MainAxisSize`
- `verticalDirection`: enum name from `VerticalDirection`
- `textDirection`: `ltr`, `rtl`
- `textBaseline`: enum name from `TextBaseline`
- `clipBehavior`: enum name from `Clip`
- `spacing`: number
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### stack

- `alignment`: alignment
- `fit`: enum name from `StackFit`
- `textDirection`: `ltr`, `rtl`
- `clipBehavior`: enum name from `Clip`
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### icon

- `icon`: either a resolver name string or an object with:
  - `codePoint`: integer
  - `fontFamily`: optional string
  - `fontPackage`: optional string
  - `fontFamilyFallback`: optional string list
  - `matchTextDirection`: optional boolean

Raw `IconData` value forms are useful for tooling and controlled payloads, but
resolver names are safer for app icons when Flutter icon tree-shaking matters.
- `color`: color
- `size`: number
- `weight`: number
- `grade`: number
- `opticalSize`: number
- `shadows`: list of shadow values or `ShadowToken` reference
- `textDirection`: `ltr`, `rtl`
- `applyTextScaling`: boolean
- `fill`: number
- `semanticsLabel`: string
- `opacity`: number between `0` and `1`
- `blendMode`: enum name from `BlendMode`
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### image

- `image`: either a resolver name string, `{ "url": string, "scale"?: number,
  "webHtmlElementStrategy"?: "never" | "fallback" | "prefer" }` for
  `NetworkImage`, or `{ "asset": string, "package"?: string }` for
  `AssetImage`
- `width`: number
- `height`: number
- `color`: color
- `repeat`: enum name from `ImageRepeat`
- `fit`: enum name from `BoxFit`
- `alignment`: alignment
- `centerSlice`: rect
- `filterQuality`: enum name from `FilterQuality`
- `colorBlendMode`: enum name from `BlendMode`
- `semanticLabel`: string
- `excludeFromSemantics`: boolean
- `gaplessPlayback`: boolean
- `isAntiAlias`: boolean
- `matchTextDirection`: boolean
- `variants`: list of variant payloads
- `modifiers`: modifier payload list or ordered modifier object
- `animation`: animation payload

### flex_box

`flex_box` flattens the representable `box` and `flex` fields into one payload.
When a field name would conflict, `clipBehavior` belongs to the box part and
`flexClipBehavior` belongs to the flex part.

### stack_box

`stack_box` flattens the representable `box` and `stack` fields into one
payload. When a field name would conflict, `alignment` and `clipBehavior` belong
to the box part; `stackAlignment` and `stackClipBehavior` belong to the stack
part.

## Common Values

Scalar and structural constraint failures, including positive-size rules,
non-empty `apply`, and single-source `$merge` carrier requirements, report
`constraint_violation`.

- `color`: `#RRGGBB`, `#AARRGGBB`, `rgb(r,g,b)`, or `rgba(r,g,b,a)`.
- `alignment`: one of `topLeft`, `topCenter`, `topRight`, `centerLeft`,
  `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`, or
  `{ "x": number, "y": number }`.
- `edgeInsets`: either a number for all sides or an object with optional
  `left`, `top`, `right`, `bottom`.
- `radius`: either a non-negative number or `{ "x": number, "y": number }`.
- `borderRadius`: either a radius for all corners or an object with optional
  `topLeft`, `topRight`, `bottomLeft`, `bottomRight`.
- `boxConstraints`: optional non-negative `minWidth`, `maxWidth`, `minHeight`,
  `maxHeight`. The string `"infinity"` is the only unbounded max-bound value.
- `borderSide`: optional `color`, `width`, `style`, `strokeAlign`.
- `border`: optional `top`, `right`, `bottom`, `left` border sides.
- `boxShadow`: optional `color`, `offset`, `blurRadius`, `spreadRadius`.
- `shadow`: optional `color`, `offset`, `blurRadius`.
- `offset`: `{ "x": number, "y": number }`.
- `rect`: `{ "left": number, "top": number, "right": number, "bottom": number }`.
- `locale`: `{ "languageCode": string, "scriptCode"?: string, "countryCode"?: string }`.
- `matrix4`: exactly 16 numbers.

## Decoration Values

`box.decoration` and `box.foregroundDecoration` support optional `color`,
`border`, `borderRadius`, `shape`, `backgroundBlendMode`, `gradient`, and
`boxShadow`.

`gradient` uses a `kind` discriminator:

- `linear`: optional `begin`, `end`, `colors`, `stops`, `tileMode`, and
  `transform`
- `radial`: optional `center`, `radius`, `focal`, `focalRadius`, `colors`,
  `stops`, `tileMode`, and `transform`
- `sweep`: optional `center`, `startAngle`, `endAngle`, `colors`, `stops`,
  `tileMode`, and `transform`

Gradient colors are color lists, stops are number lists, alignments use the
common `alignment` value, and `tileMode` is a Flutter `TileMode` enum name.
Supported gradient transforms are:

```json
{ "kind": "rotation", "radians": 0.25 }
```

and CSS-keyword linear transforms for bounds-aware Tailwind/CSS corner
directions:

```json
{ "kind": "css_linear", "direction": "to-br" }
```

`direction` accepts `to-r`, `to-br`, `to-b`, `to-bl`, `to-l`, `to-tl`, `to-t`,
and `to-tr`.

Other `GradientTransform` implementations fail encode with
`unsupported_encode_value`.

## Property Terms

Representable `Prop` fields use a property term. A term is normally the field's
plain literal value:

```json
"#336699"
```

Token-capable field positions also accept a token reference object:


```json
{ "$token": "color.text.primary" }
```

Any literal or token term may carry `apply`, a list of directive objects:

```json
{
  "$token": "color.brand",
  "apply": [{ "op": "color_alpha", "alpha": 128 }]
}
```

Multi-source props use an ordered `$merge` term:

```json
{
  "$merge": [
    { "minWidth": 1, "maxWidth": 1 },
    { "minHeight": 2, "maxHeight": 2 }
  ]
}
```

The encoder emits `$merge` only when the runtime prop has multiple sources.
Single-source props stay flat unless the source is a token or needs `apply`.
A one-element `$merge` is accepted only as a carrier for a non-empty `apply`;
canonical encode does not generate it for ordinary single-source props.

`$token`, `$merge`, and `apply` are grammar-owned keys. Token reference objects
may contain only `$token`, optional double-token `kind`, and optional `apply`.
Merge objects may contain only `$merge` and optional `apply`. Unknown
`$`-prefixed markers fail preflight.

Exported JSON Schema uses `#/definitions/mix_schema_property_term` at ordinary
property-term boundaries and `#/definitions/mix_schema_double_property_term` at
double-token-capable boundaries. Those shared definitions constrain
control-marker objects (`$token`, `$merge`, and `apply`) and exclude malformed
marker combinations. Field-specific literal details still come from the runtime
codecs; runtime decode remains authoritative for exact Flutter/Mix value
semantics.

## Token References

Token names must match `[A-Za-z0-9_.-]{1,128}`. Invalid names fail with
`invalid_token_name` at the `$token` path.

The field position selects the canonical Mix token class:

- color fields: `ColorToken`
- radius and border-radius fields: `RadiusToken`
- double-valued spacing fields: `SpaceToken` by default
- other double-valued fields: `DoubleToken` when `"kind": "double"` is present
- text-style fields: `TextStyleToken`
- font-weight fields: `FontWeightToken`
- border-side fields: `BorderSideToken`
- shadow-list fields: `ShadowToken`
- box-shadow-list fields: `BoxShadowToken`
- duration fields: `DurationToken`
- breakpoint variants: `BreakpointToken`

Only double-valued token references may include `"kind": "space"` or
`"kind": "double"`. Decode defaults missing `kind` to `"space"`; canonical
encode always writes `kind` for `SpaceToken` and `DoubleToken`.

Token references decode to unresolved Mix token references. Unknown token names
therefore remain a Mix runtime lookup failure rather than a schema decode
failure. Data-referenced tokens must be registered under the canonical token
class above; scopes that want Dart-side aliases should register equivalent
values under both token classes.

## Directives

Directive objects use core `Directive.key` strings as `op` values. `apply`,
when present, must contain at least one directive object. Supported ops are:

- color: `color_alpha`, `color_brighten`, `color_darken`,
  `color_desaturate`, `color_lighten`, `color_opacity`, `color_saturate`,
  `color_shade`, `color_tint`, `color_with_blue`, `color_with_green`,
  `color_with_red`, `color_with_values`
- string: `capitalize`, `lowercase`, `sentence_case`, `title_case`,
  `uppercase`
- number: `number_abs`, `number_add`, `number_ceil`, `number_clamp`,
  `number_divide`, `number_floor`, `number_multiply`, `number_round`,
  `number_subtract`

Directive params are op-specific and use the core field names: for example
`color_alpha` has only `alpha`, `color_opacity` has only `opacity`,
`number_multiply` has only `factor`, and `number_clamp` has only `min` and
`max`. `color_with_values` may use `alpha`, `red`, `green`, `blue`, and
`colorSpace`; `colorSpace`, when present, is a Flutter `ColorSpace` enum name.
Unknown `op` values fail strict decode with `invalid_enum` at the `apply`
entry's `op` path. Extra params fail strict decode with `unknown_field` at the
extra param path. Lenient decode removes the invalid `apply` entry and reports
the original failing path as a warning. If no valid directives remain, canonical
re-encode omits `apply` and preserves the underlying term when it is otherwise
valid.

## Theme Document

Theme documents use the same version envelope but a dedicated entry point, not
the styler root union:

```json
{ "v": 1, "type": "theme" }
```

The optional token-definition maps mirror `MixScope(tokens:)` groups:

- `colors`: `ColorToken` values
- `spaces`: `SpaceToken` double values
- `doubles`: `DoubleToken` double values
- `radii`: `RadiusToken` values
- `textStyles`: `TextStyleToken` values
- `shadows`: `ShadowToken` list values
- `boxShadows`: `BoxShadowToken` list values
- `borders`: `BorderSideToken` values
- `fontWeights`: `FontWeightToken` values
- `breakpoints`: `BreakpointToken` values
- `durations`: `DurationToken` values

Map keys use the same token-name grammar as style token references. Values use
the same canonical wire shapes as style documents for the same value kind.
Whole-value aliases are allowed only within the same map:

```json
{
  "colors": {
    "color.surface": "#101820",
    "color.background": { "$token": "color.surface" }
  }
}
```

Alias objects may contain only `$token` and, for `spaces` or `doubles`, the
matching `kind` value. Alias objects never carry `apply` or fallback fields.

Aliases are resolved eagerly at theme decode time with cycle detection, so the
decoded theme exposes a flat `Map<MixToken, Object>` ready for
`MixScope(tokens:)`. Cross-kind aliases, missing alias targets, alias cycles,
and nested token references inside concrete theme values fail decode. Encoding a
decoded theme emits the flattened concrete token values; alias syntax is not
preserved.

Theme `textStyles` use the canonical concrete `TextStyle` fields supported by
the style contract: `color`, `backgroundColor`, `fontSize`, `fontWeight`,
`fontStyle`, `letterSpacing`, `debugLabel`, `wordSpacing`, `textBaseline`,
`height`, `fontFamily`, `fontFamilyFallback`, `fontFeatures`,
`fontVariations`, `decoration`, `decorationColor`, `decorationStyle`,
`decorationThickness`, and `shadows`. Nested token references inside those
values fail decode.

## Token Preflight

Style documents intentionally do not fail decode for unknown token names. Tooling
that wants to fail before shipping can decode the style and theme documents,
walk style references, and diff them against the decoded theme:

```dart
final style = contract.decode<BoxStyler>(stylePayload).value;
final theme = const MixSchemaThemeCodec().decode(themePayload).value;

final used = tokenReferencesOf(style);
final declared = theme.tokens.keys.map(MixSchemaTokenReference.fromToken).toSet();
final missing = used.difference(declared);
```

`MixSchemaTokenReference.kind` uses the theme document group name (`colors`,
`spaces`, `doubles`, `radii`, `textStyles`, `shadows`, `boxShadows`, `borders`,
`fontWeights`, `breakpoints`, or `durations`) and `name` uses the token name.

## Text Values

`textStyle` supports optional `color`, `backgroundColor`, `fontSize`,
`fontWeight`, `fontStyle`, `letterSpacing`, `debugLabel`, `wordSpacing`,
`textBaseline`, `height`, `fontFamily`, `fontFamilyFallback`, `fontFeatures`,
`fontVariations`, `decoration`, `decorationColor`, `decorationStyle`,
`decorationThickness`, and `shadows`.

`fontFeatures` are objects with a four-character `feature` tag and non-negative
integer `value`. `fontVariations` are objects with a four-character `axis` tag
and numeric `value`.

`strutStyle` supports optional `fontFamily`, `fontFamilyFallback`, `fontSize`,
`fontWeight`, `fontStyle`, `height`, `leading`, and `forceStrutHeight`.

`textScaler` supports only linear scalers as `{ "linear": number }`.
Non-linear/custom `TextScaler` implementations fail encode.

`textHeightBehavior` supports optional `applyHeightToFirstAscent`,
`applyHeightToLastDescent`, and `leadingDistribution`.

Text directive values are `uppercase`, `lowercase`, `capitalize`, `title_case`,
and `sentence_case`.

## Variants

Variant payloads use a `kind` discriminator:

- `named`: `{ "name": string, "style": styler }`
- `widget_state`: `{ "state": widgetState, "style": styler }`
- `enabled`: `{ "style": styler }`
- `context_not_widget_state`: `{ "state": widgetState, "style": styler }`
- `context_brightness`: `{ "brightness": "light" | "dark", "style": styler }`
- `context_breakpoint`: either
  `{ "minWidth"?: number, "maxWidth"?: number, "style": styler }` or
  `{ "token": tokenName, "style": styler }`
- `context_orientation`: `{ "orientation": "portrait" | "landscape",
  "style": styler }`
- `context_directionality`: `{ "textDirection": "ltr" | "rtl",
  "style": styler }`
- `context_platform`: `{ "platform": targetPlatform, "style": styler }`
- `context_web`: `{ "style": styler }`
- `context_not`: `{ "variant": contextVariantSelector, "style": styler }`

`context_not.variant` is a recursive context-variant selector using the same
`kind` and data fields above, but without `style`. Explicit nesting is
preserved; `not(not(web))` encodes as nested `context_not` selectors rather
than being normalized away.

Only the context variant forms listed above are part of the canonical wire
contract. Closure-backed `ContextVariantBuilder` and custom size predicates are
not represented by v1.

Widget state values are `hovered`, `focused`, `pressed`, `dragged`, `selected`,
`scrolled_under`, `disabled`, and `error`.

## Modifiers

The `modifiers` field is normally a list of modifier payloads in application
order. If a custom modifier application order is required, `modifiers` may be
an object with optional `order` and `items`:

```json
{
  "order": ["blur", "opacity"],
  "items": [{ "type": "opacity", "opacity": 0.5 }]
}
```

`order` values use the same kind strings as modifier payload `type` values.
Modifier payloads use a `type` discriminator. Supported kinds are:

- `align`: optional `alignment`, `widthFactor`, and `heightFactor`
- `aspect_ratio`: optional positive `aspectRatio`
- `blur`: required `sigma`
- `box`: required nested box `style`
- `clip_oval`, `clip_rect`, `clip_triangle`: optional `clipBehavior`
- `clip_r_rect`: optional `borderRadius` and `clipBehavior`
- `default_text_style`: optional `style`, `textAlign`, `softWrap`, `overflow`,
  and positive `maxLines`
- `default_text_styler`: required nested text `style`
- `flexible`: optional non-negative `flex` integer and `fit` value `tight` or
  `loose`
- `fractionally_sized_box`: optional `widthFactor`, `heightFactor`, and
  `alignment`
- `icon_theme`: optional `color`, `size`, `fill`, `weight`, `grade`,
  `opticalSize`, `opacity` between `0` and `1`, `shadows`, and
  `applyTextScaling`
- `intrinsic_height`, `intrinsic_width`: no fields
- `opacity`: required `opacity` between `0` and `1`
- `padding`: required `padding`
- `rotate`: optional `radians` and `alignment`
- `rotated_box`: optional `quarterTurns`
- `scale`: optional `x`, `y`, and `alignment`
- `scroll_view`: optional `scrollDirection`, `reverse`, `padding`, and
  `clipBehavior`
- `sized_box`: optional `width` and `height`
- `skew`: optional `skewX`, `skewY`, and `alignment`
- `transform`: optional `transform` matrix and `alignment`
- `translate`: optional `x` and `y`
- `visibility`: optional `visible`

Custom clippers, `ScrollPhysics`, shader masks, mouse cursors, reset/internal
modifiers, and unknown modifier kinds are not represented by v1.

## Animation

Animation payloads encode the data-only implicit animation configs.

`CurveAnimationConfig` uses the legacy object form:

- `duration`: non-negative milliseconds or `DurationToken` reference
- `curve`: registered curve name, or `{ "cubic": [a, b, c, d] }` for `Cubic`
- `delay`: optional non-negative milliseconds or `DurationToken` reference.
  Missing `delay` decodes as `0`; canonical encode emits `delay`.

`SpringAnimationConfig` uses:

- `spring.mass`: positive number
- `spring.stiffness`: positive number
- `spring.damping`: non-negative number

`PhaseAnimationConfig`, `KeyframeAnimationConfig`, custom `Curve` subclasses,
and animation configs carrying `onEnd` callbacks fail encode. Callback-over-wire
is outside v1 and should be revisited with the future event/tree layer.

## V1 Unsupported Field Families

The inventory ratchet explicitly classifies several Mix data families as outside
the canonical v1 contract. Producers must omit these fields or expect
`unsupported_encode_value` on encode:

- `decoration.image` and `DecorationImageMix`
- shape and directional border families not listed in Common Values
- preset-only helpers such as `ElevationShadow`

## Identity Values

Resolver names must match `[A-Za-z0-9_-]{1,96}`. Decode uses per-call
`MixSchemaDecodeOptions(resolveIcon:, resolveImage:)` callbacks for string
identity names:

```dart
final decoded = builtInMixSchemaContract.decode<IconStyler>(
  {'type': 'icon', 'icon': 'home'},
  options: MixSchemaDecodeOptions(resolveIcon: (name) => icons[name]),
);
```

Encoding can emit resolver names with per-call reverse maps:

```dart
final encoded = builtInMixSchemaContract.encode(
  IconStyler(icon: homeIcon),
  options: MixSchemaEncodeOptions(iconNames: {'home': homeIcon}),
);
```

Without a reverse map, `IconData` encodes as its value object. Prefer resolver
names for app icons when Flutter icon tree-shaking matters. `NetworkImage`
and `AssetImage` encode as their value forms when all state is represented by
the wire contract. `NetworkImage.headers`, `AssetImage.bundle`, and other
`ImageProvider` implementations fail encode with `unresolved_identity_value`.
A well-formed string name that the resolver does not return fails decode with
`unresolved_identity_name`. Closure-backed context variant builders and
callback identities are not part of the canonical contract.

## Encode Policy

Styler encode supports representable value sources, canonical token references,
directive applications, ordered multi-source props through the property-term
grammar, and supported identity value forms. Custom token subclasses,
unresolved identity values, unsupported directive types, and unsupported runtime
objects fail encode with a public `MixSchemaError`.

Encode errors use stable public codes. `unsupported_encode_value` reports values
that the v1 contract intentionally cannot represent. `inventory_skew` reports a
developer/runtime mismatch where a Mix styler exposes a field that is not covered
by the schema encoder inventory.

The runtime `inventory_skew` guard covers the built-in styler roots
(`BoxStyler`, `TextStyler`, `FlexStyler`, `StackStyler`, `IconStyler`,
`ImageStyler`, `FlexBoxStyler`, and `StackBoxStyler`) plus Phase 4 nested
families that have dedicated encode maps: `BoxDecorationMix`,
`LinearGradientMix`, `RadialGradientMix`, `SweepGradientMix`, `TextStyleMix`,
`StrutStyleMix`, `WidgetModifierConfig`, and supported modifier mix payloads.
Nested types that remain unsupported are tracked by the inventory manifest and
backlog. Named missing/stale fields are included when the schema inventory can
identify them; runtime count-only skew includes `expectedFieldCount` and
`actualFieldCount`. A net-zero runtime change that removes one field and adds
another field with the same total count is not detectable by the count-only
fallback.

Encoded top-level style documents include `v: 1`. Nested style objects emitted
inside variants do not include `v`.
