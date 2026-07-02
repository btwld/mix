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

The full built-in contract accepts all branches above. The shared
`builtInMixSchemaContract` intentionally excludes `icon` and `image` because
their identity fields require an app-owned registry; freeze a custom
`MixSchemaContractBuilder().builtIn()` contract when those branches are needed.

During the v1 transition window, a missing top-level `v` is decoded as v1 with
a warning. Encoded output and exported JSON Schema are canonical and include
`v: 1`. Unsupported or malformed `v` fails with `unsupported_version`.

Missing fields stay unset; Mix runtime defaults are not injected by the schema.

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
discriminators, and unknown enum values are skipped at the smallest enclosing
named property:

- a styler field for normal styler properties,
- a variant entry for unknown variant data,
- a modifier entry for unknown modifier data.

The skipped item is reported as a warning with the original path. Structural
problems remain fatal in both modes: bad `v`, unknown root `type`, explicit
null, malformed known fields, and resource-limit failures.

## Versioning & Evolution

Within v1, producers may add new fields, new variant/modifier kinds, new enum
values, and future token kinds. Old strict clients reject those additions. Old
lenient clients degrade by skipping the smallest enclosing property or entry and
reporting warnings.

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
- `variants`: list of variant payloads
- `modifiers`: list of modifier payloads
- `animation`: animation payload

### text

- `overflow`: `clip`, `fade`, `ellipsis`, `visible`
- `textAlign`: `left`, `right`, `center`, `justify`, `start`, `end`
- `maxLines`: integer
- `style`: text style
- `textDirection`: `ltr`, `rtl`
- `softWrap`: boolean
- `selectionColor`: color
- `semanticsLabel`: string
- `textHeightBehavior`: text height behavior
- `textDirectives`: list of text directive names
- `variants`: list of variant payloads
- `modifiers`: list of modifier payloads
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
- `modifiers`: list of modifier payloads
- `animation`: animation payload

### stack

- `alignment`: alignment
- `fit`: enum name from `StackFit`
- `textDirection`: `ltr`, `rtl`
- `clipBehavior`: enum name from `Clip`
- `variants`: list of variant payloads
- `modifiers`: list of modifier payloads
- `animation`: animation payload

### icon

- `icon`: registry id from the `icon_data` scope
- `color`: color
- `size`: number
- `weight`: number
- `grade`: number
- `opticalSize`: number
- `textDirection`: `ltr`, `rtl`
- `applyTextScaling`: boolean
- `fill`: number
- `semanticsLabel`: string
- `opacity`: number
- `blendMode`: enum name from `BlendMode`
- `variants`: list of variant payloads
- `modifiers`: list of modifier payloads
- `animation`: animation payload

### image

- `image`: registry id from the `image_provider` scope
- `width`: number
- `height`: number
- `color`: color
- `repeat`: enum name from `ImageRepeat`
- `fit`: enum name from `BoxFit`
- `alignment`: alignment
- `filterQuality`: enum name from `FilterQuality`
- `colorBlendMode`: enum name from `BlendMode`
- `semanticLabel`: string
- `excludeFromSemantics`: boolean
- `gaplessPlayback`: boolean
- `isAntiAlias`: boolean
- `matchTextDirection`: boolean
- `variants`: list of variant payloads
- `modifiers`: list of modifier payloads
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
- `matrix4`: exactly 16 numbers.

## Text Values

`textStyle` supports optional `color`, `backgroundColor`, `fontSize`,
`fontWeight`, `fontStyle`, `letterSpacing`, `wordSpacing`, `height`,
`fontFamily`, `decoration`, `decorationColor`, `decorationStyle`,
`decorationThickness`, and `shadows`.

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
- `context_breakpoint`: `{ "minWidth"?: number, "maxWidth"?: number, "style": styler }`

Only the context variant forms listed above are part of the canonical wire
contract. Composite and closure-backed context variants can be added later only
if Mix exposes typed runtime data that can be encoded without key parsing.

Widget state values are `hovered`, `focused`, `pressed`, `dragged`, `selected`,
`scrolled_under`, `disabled`, and `error`.

## Modifiers

Modifier payloads use a `type` discriminator:

- `opacity`: `{ "opacity": number }`
- `blur`: `{ "sigma": number }`
- `flexible`: optional `flex` integer and `fit` value `tight` or `loose`
- `default_text_style`: optional `style`, `textAlign`, `softWrap`, `overflow`,
  and `maxLines`

## Animation

Animation payloads encode `CurveAnimationConfig`:

- `duration`: non-negative milliseconds
- `curve`: registered curve name
- `delay`: non-negative milliseconds
- `onEnd`: optional registry id if callback encoding is enabled

Unsupported animation config types fail encode.

## Registry Values

Registry ids must match `[A-Za-z0-9_-]{1,96}`. The canonical identity scopes are:

- `icon_data`
- `image_provider`

Animation callbacks use the optional `animation_on_end` scope when `onEnd`
encoding is enabled. Closure-backed context variant builders are not part of the
canonical contract.

## Encode Policy

Styler encode supports fields backed by one value source that can be represented
by this contract. Tokens, directives on non-directive fields, multi-source
props, unregistered identity values, and unsupported runtime objects fail encode
with a public `MixSchemaError`.

Encoded top-level style documents include `v: 1`. Nested style objects emitted
inside variants do not include `v`.
