# Mix JSON Schema

Status: **v1.0 Draft**
Last updated: 2026-04-20
Companion files: [`registry.json`](./registry.json), [`error-codes.json`](./error-codes.json), [`examples.md`](./examples.md), [`schema.v1.json`](./schema.v1.json)

**Lifecycle stage.** Per the Working with Specs lifecycle, this document is at **Draft**: normative text and ≥1 end-to-end valid example exist. It will advance to **Candidate** when the reference validator, canonicalizer, parser, and serializer (in `packages/mix_schema/`) are implemented and produce implementation feedback, and when at least one independent implementation has validated the contract from this text alone. Until then, substantive changes to the contract are expected.

## Purpose

A public JSON contract for describing Mix widget trees declaratively. Producers (AI agents, design tools, CMS, backends) emit JSON; consumers (Mix-based Flutter runtimes) render it.

## Normative language

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL** in this document are to be interpreted as described in RFC 2119 and RFC 8174 when, and only when, they appear in all capitals, as shown here.

Lowercase "must", "should", etc. are plain English and carry no normative force.

Code blocks inline in this document are **non-normative** — illustrative only. Normative examples (conformance fixtures) live in [`examples.md`](./examples.md); that file explicitly declares which examples are normative and binds each to conformance-test coverage.

Every **MUST** in this specification is tied to one of three rationales: **interoperability** (two conforming implementations would disagree), **safety** (untrusted input could cause harm or non-deterministic behavior), or the **core portability promise** (round-trip / canonical-form invariants). Where the rationale is not obvious from context, it is noted inline.

## Positioning

- **Public contract, not internal serialization.** Mix may refactor internals freely; this schema changes only on its own version cycle.
- **Canonical form is normative.** Sugar exists only at the input boundary; tooling normalizes before any semantic operation.
- **v1.0 is intentionally small.** Unresolved features are deferred.

## Design principles

1. Express Mix intent, not Mix classes.
2. Canonical form is normative; input sugar normalizes to it.
3. Closed enums; `x:` is the only extension point.
4. Strict validation by default (`additionalProperties: false`, discriminated unions).
5. Closures are non-serializable; runtime indirection uses `{ "host": "..." }` tagged objects.
6. Ship less, fully specified. Defer ambiguous features.

---

## v1.0 scope

| In scope | Section |
|---|---|
| Document envelope | §Envelope |
| Widget grammar | §WidgetNode |
| Style grammar | §StyleNode |
| Value primitive | §Value |
| Structured literals (leaf-expanded canonical) | §Structured literals |
| Directive catalog | §Directives |
| Variants | §Variants |
| Modifiers | §Modifiers |
| Implicit animations | §Animation |
| Token namespaces + `x:` extension | §Tokens, §Extensions |
| Host references | §Host references |
| Prop registry | `registry.json` |
| Canonicalization & semantics | §Semantics |
| Versioning | §Versioning |

**Deferred:** `$ref` / named styles, action/event binding, conditional children, iteration / data binding, phase & keyframe animations, multi-mode validation, `ContextVariantBuilder`.

---

## Model and invariants

A Mix JSON document describes a *widget tree* rooted at `root`. Each node in the tree is one of the following concepts:

- **WidgetNode** — a widget instance (e.g. `Box`, `PressableBox`, `FlexBox`). Discriminated by its `widget` field.
- **StyleNode** — the style applied to a widget. Discriminated by its `spec` field. A composite StyleNode (`flexbox` / `stackbox`) nests restricted **SubStyles** containing only `{ spec, props }`.
- **Value** — the primitive unit of a prop. Either a literal, a token reference, a directive pipeline, or a combination. Canonical form requires every leaf to be a Value object.
- **Variant** — conditional style contribution `{ when, style }`. Array order defines precedence.
- **Modifier** — widget-level wrapper (`opacity`, `padding`, `transform`, etc.). Ordered array; `reset` is a destructive sentinel.
- **Directive** — a leaf-level transformation (`darken`, `multiply`, `uppercase`, …). Applied left-to-right at the leaf.
- **Token reference** — `{ "token": "namespace.name" }`. Resolved via inline bundle → host `MixScope` → error.
- **Host reference** — `{ "host": "..." }`. Opaque capability resolved by the consumer runtime.
- **Extension** — any identifier prefixed `x:`. Opaque to validators; owned by the host.

### Invariants

These hold for every valid document:

1. **Canonical normalization is total.** Any valid input — canonical or sugar — has a unique canonical form. `canonicalize(canonicalize(x))` is structurally equal to `canonicalize(x)`.
2. **Validation is pure.** Given (document, schema version, registry version), validation is deterministic and has no external state dependencies.
3. **Per-prop typing is deterministic.** The type expected at any (spec, prop) or (modifier, prop) position is fully determined by `registry.json` for the active schema version.
4. **Resolution is a one-pass pipeline.** Canonicalize → validate → parse → merge variants → apply modifiers → render. Directives apply exactly once per leaf.
5. **Extensions do not affect conformance.** A document that differs only in its `x:` payloads is equal for all conformance purposes; `x:` payloads round-trip unchanged.
6. **Host references are opaque capabilities.** Consumers resolve them against an allowlist; unresolved host refs produce structured errors.
7. **Closed-set discriminators are versioned.** Widgets, specs, modifiers, directive ops, enum values, and token namespaces are pinned per schema version. Additions are MINOR; removals are MAJOR.

---

## Envelope

```jsonc
{
  "$schema":    "https://mix.dev/schema/v1.json",
  "schema":     "1.0.0",
  "mixRuntime": "^2.0.0",
  "tokens":     { /* optional inline bundle */ },
  "root":       <WidgetNode>
}
```

- `schema` — semver of this specification.
- `mixRuntime` — semver range of the target Mix runtime. Advisory. Consumers SHOULD warn on mismatch, MUST NOT hard-fail.
- `tokens` — optional flat-keyed bundle (see §Tokens).

`$schema` points to the formal JSON Schema document (`schema.v1.json`). That schema is authored against **JSON Schema Draft 2020-12**; validators MUST support that dialect. A validator MAY support later drafts only if they are fully backward-compatible with 2020-12 for the constructs used here.

---

## Canonical form vs accepted input

Producers MAY emit sugar; consumers MUST normalize to canonical form before any semantic operation (merge, diff, cache key, comparison) — core-promise (merge and structural equality are only defined on canonical form; skipping normalization causes two implementations to disagree on comparison results).

### Canonical rules

- Every leaf value is a Value object (`{ "value": X }` or `{ "token": "..." }`), never a bare scalar.
- Structured literals use their **leaf-expanded form** (see §Structured literals). Shorthand keys (`all`, `horizontal`, `vertical`, etc.) are sugar.
- Object keys within a node are lexically sorted.
- Arrays with semantic order (`directives`, `variants`, `modifiers`, `children`) keep authored order.
- **Empty optional arrays are omitted**, not emitted as `[]`.
- Omitted optional fields are absent (not `null`).
- **Null is rejected as a Value literal** — `{ "value": null }` is a validation error (`value.null-forbidden`). To clear a prop, omit it.
- Numbers targeting `double` use the `double` JSON form (`16.0`).
- Colors are `#rrggbbaa` lowercase.
- Enum values use the short form (`"center"`, not `"MainAxisAlignment.center"`). Numeric enum indices are rejected.
- Infinity and NaN are rejected.

### Enum allowed values

- Canonical enum values mirror Flutter's short-form names (registry `enums.*`).
- The schema pins the allowed set **per schema version**. New Flutter enum values are not auto-inherited; a MINOR schema bump adds them.
- Aliases normalize at the input boundary. Registry's `enumAliases` lists them. v1.0:
  - `FontWeight.normal` → `w400`
  - `FontWeight.bold` → `w700`
- Unknown enum values (including valid Flutter additions that postdate the schema version) are validation errors.

### Accepted input sugar

- Bare scalar → `{ "value": <x> }`.
- Short-form color (`#rgb`, `#rgba`, `#rrggbb`) → `#rrggbbaa`.
- Structured-literal shorthand (`all`, `horizontal`, `vertical`, Alignment preset names) → leaf-expanded form.
- Integer at a `double` position → normalized to `double`.

A compliant toolchain MUST ship a canonicalizer — interoperability (without a canonicalizer, a toolchain cannot guarantee canonical form at its output boundary, breaking merge / round-trip assumptions for downstream tools); see §Parser & Serializer.

---

## WidgetNode

Closed set, discriminated by `widget`. Invalid combinations (e.g. `text` on a `Box`, both `child` and `children`) fail schema validation.

### Box
```jsonc
{
  "widget": "Box",
  "style":  <StyleNode spec="box">?,
  "child":  <WidgetNode>?
}
```

### FlexBox / RowBox / ColumnBox
```jsonc
{
  "widget":   "FlexBox" | "RowBox" | "ColumnBox",
  "style":    <StyleNode spec="flexbox">?,
  "children": [<WidgetNode>]
}
```

`RowBox` and `ColumnBox` are sugar for `FlexBox` with `direction` fixed. The widget-level direction is **authoritative**: any `style.flex.props.direction` on a `RowBox`/`ColumnBox` is ignored. Producers SHOULD omit `direction` from those widgets' flex sub-style. Lint tools MAY emit `variant.direction-ignored` on conflicts.

### StackBox
```jsonc
{
  "widget":   "StackBox",
  "style":    <StyleNode spec="stackbox">?,
  "children": [<WidgetNode>]
}
```

### StyledText
```jsonc
{
  "widget": "StyledText",
  "text":   "...",
  "style":  <StyleNode spec="text">?
}
```

### StyledIcon / StyledImage
```jsonc
{
  "widget": "StyledIcon",
  "icon":   <Icon literal>,
  "style":  <StyleNode spec="icon">?
}

{
  "widget": "StyledImage",
  "image":  <Image literal>,
  "style":  <StyleNode spec="image">?
}
```

Icon and Image literal shapes are defined in the registry (`literals.Icon`, `literals.Image`).

### Pressable

`Pressable` is a **pure behavior wrapper** with no style of its own.

```jsonc
{
  "widget": "Pressable",
  "child":  <WidgetNode>
}
```

Styling a pressable container uses **`PressableBox`**.

### PressableBox
```jsonc
{
  "widget": "PressableBox",
  "style":  <StyleNode spec="box">?,
  "child":  <WidgetNode>?
}
```

---

## StyleNode

Discriminated by `spec`.

### Leaf specs
```jsonc
{
  "spec":       "box" | "flex" | "text" | "icon" | "image" | "stack",
  "props":      { /* see registry */ },
  "variants":   [<VariantNode>]?,
  "modifiers":  [<ModifierNode>]?,
  "animation":  <AnimationNode>?,

  // Only on spec == "text":
  "textDirectives": [<StringDirective>]?
}
```

### Composite specs
```jsonc
{
  "spec":       "flexbox",
  "box":        <SubStyle spec="box">?,
  "flex":       <SubStyle spec="flex">?,
  "variants":   [...]?,
  "modifiers":  [...]?,
  "animation":  <...>?
}

{
  "spec":       "stackbox",
  "box":        <SubStyle spec="box">?,
  "stack":      <SubStyle spec="stack">?,
  "variants":   [...]?,
  "modifiers":  [...]?,
  "animation":  <...>?
}
```

Where **SubStyle** is a restricted StyleNode:

```jsonc
{ "spec": "box" | "flex" | "stack", "props": { ... } }
```

Rules:
- A leaf `StyleNode` MUST NOT contain `box`/`flex`/`stack` sub-style fields.
- A composite `StyleNode` MUST NOT contain `props`.
- **SubStyles MUST contain only `spec` and `props`.** No nested `variants`, `modifiers`, `animation`, or `textDirectives` — those belong on the composite root.
- `spec` is required on every StyleNode; never inferred from context.
- In composites, an omitted sub-style means "no change" (partial override).

---

## Value primitive

Every prop value is a **Value** object:

```jsonc
{
  "value":      <literal>?,
  "token":      "namespace.name"?,
  "directives": [<Directive>]?
}
```

Rules:
- At least one of `value`, `token`, `directives` MUST be present.
- `value` and `token` are mutually exclusive.
- `directives`-only Values transform a base supplied by the enclosing context (e.g. a variant tweaking an inherited color).
- Directives apply left-to-right.
- **Directives apply only at leaf Values.** They never appear at a structured-literal root; transform structured-literal sub-fields instead.
- A directive's target type MUST match the leaf type (color/string/number). Type mismatch is a validation error.

Input sugar: a bare scalar is accepted in place of a Value and normalizes to `{ "value": <x> }`.

---

## Structured literals

Structured literals describe Flutter composite types (`EdgeInsets`, `BorderRadius`, `BoxConstraints`, `TextStyle`, `Decoration`, ...).

### Canonical form is leaf-expanded

- The literal body lives under a `"value"` key on the enclosing Value.
- **Every sub-field is itself a Value object** (`{ "value": n }` or `{ "token": "..." }`). Raw scalars inside sub-fields are input sugar, not canonical.
- **Directives appear only on leaf Values inside sub-fields**, never on the literal root.
- Shorthand keys (`all`, `horizontal`, `vertical`, Alignment preset names) are accepted at the input boundary; canonical form expands to the explicit sub-fields declared in the registry.

### Example — `EdgeInsets`

Canonical:
```json
"padding": {
  "value": {
    "top":    { "value": 16.0 },
    "left":   { "value": 16.0 },
    "right":  { "value": 16.0 },
    "bottom": { "value": 16.0 }
  }
}
```

Tokenized sub-field:
```json
"padding": {
  "value": {
    "top":    { "token": "space.lg" },
    "left":   { "token": "space.md" },
    "right":  { "token": "space.md" },
    "bottom": { "token": "space.lg" }
  }
}
```

Sub-field with directive:
```json
"padding": {
  "value": {
    "top":    { "token": "space.lg",
                "directives": [{ "op": "multiply", "factor": 2 }] },
    "left":   { "value": 0.0 },
    "right":  { "value": 0.0 },
    "bottom": { "value": 0.0 }
  }
}
```

Accepted input sugar — all normalize to the expanded form:
```json
"padding": 16
"padding": { "value": 16 }
"padding": { "value": { "all": 16 } }
"padding": { "value": { "horizontal": 16, "vertical": 8 } }
```

### Transform ops (`Matrix4` shape)

`Matrix4` in v1.0 is an **ordered list of semantic transform operations**, not a raw 16-value matrix. The schema does not mirror the Dart `Matrix4` API.

Canonical form — each op is a tagged object using `op` as the discriminator (same form as directives):

```json
"transform": {
  "value": {
    "ops": [
      { "op": "translate", "x": { "value": 12.0 }, "y": { "value": 8.0 } },
      { "op": "scale",     "x": { "value": 1.1  }, "y": { "value": 1.1  } },
      { "op": "rotateZ",   "radians": { "value": 0.2 } }
    ]
  }
}
```

Op parameters are Value objects (`{ value | token | directives }`) like any other leaf.

**v1.0 ops:** `identity`, `translate`, `scale`, `rotateZ`.
**Deferred:** `rotateX`, `rotateY`, `skewX`, `skewY`, perspective, raw 16-value matrices.

Angles are **canonical in radians**. Degree-based input sugar may be added later; not in v1.0.

### Catalog

Full shapes live in the registry (`literals.*`). v1.0 shapes: `EdgeInsets`, `BorderRadius`, `BoxConstraints`, `Size`, `Offset`, `Alignment`, `Matrix4` (transform-ops), `Shadow`, `BorderSide`, `Border`, `Decoration`, `Gradient`, `TextStyle`, `StrutStyle`, `TextScaler`, `TextHeightBehavior`, `Icon`, `Image`.

---

## Directives (closed catalog)

Tagged by `op`. Target type (color/string/number) is inferred from the enclosing leaf's declared type. Mismatch is a validation error.

### Color
| `op` | Props |
|---|---|
| `opacity` | `value: double` |
| `withValues` | `alpha?`, `red?`, `green?`, `blue?` |
| `alpha` | `value: int 0–255` |
| `darken`, `lighten`, `saturate`, `desaturate`, `tint`, `shade`, `brighten` | `amount: int` |
| `withRed`, `withGreen`, `withBlue` | `value: int 0–255` |

### String
| `op` | Props |
|---|---|
| `capitalize`, `uppercase`, `lowercase`, `titleCase`, `sentenceCase` | — |

### Number
| `op` | Props |
|---|---|
| `multiply` | `factor: num` |
| `add` | `addend: num` |
| `subtract` | `subtrahend: num` |
| `divide` | `divisor: num` (≠ 0) |
| `clamp` | `min: num`, `max: num` (min ≤ max) |
| `abs`, `round`, `floor`, `ceil` | — |

Full shapes in `registry.directives`.

---

## Variants

Array of `{ when, style }`. Array order = evaluation order; later entries override earlier ones on conflict.

```jsonc
// State shortcuts
{ "when": "onHovered" | "onPressed" | "onFocused" | "onDisabled"
        | "onEnabled" | "onSelected" | "onError"
        | "onDark"    | "onLight",
  "style": <StyleNode> }

// Named / enum
{ "when": { "named": "primary" }, "style": <StyleNode> }
{ "when": { "enum":  "Size.lg"  }, "style": <StyleNode> }

// Context (closed value sets per context kind)
{ "when": { "context": "breakpoint",     "token":  "breakpoint.md"                         }, "style": ... }
{ "when": { "context": "orientation",    "value":  "portrait"|"landscape"                  }, "style": ... }
{ "when": { "context": "brightness",     "value":  "light"|"dark"                          }, "style": ... }
{ "when": { "context": "platform",       "value":  "android"|"iOS"|"fuchsia"
                                                  |"linux"|"macOS"|"windows"               }, "style": ... }
{ "when": { "context": "directionality", "value":  "ltr"|"rtl"                             }, "style": ... }
{ "when": { "context": "preset",         "value":  "mobile"|"tablet"|"desktop"|"web"       }, "style": ... }

// Negation
{ "when": { "not": <variant> }, "style": <StyleNode> }
```

### Inapplicable state variants

A state variant (e.g. `onHovered`) in a context that cannot produce the state (no `Pressable`, no `WidgetState` carrier) is **not** a validation error. Validation succeeds. At render time, runtimes or lint tools MAY emit a debug diagnostic or warning, but rendering MUST continue without hard failure.

---

## Modifiers

Ordered array. Index 0 is outermost wrapper.

**Modifier props follow the same Value primitive rules as StyleNode props** with two intentional exceptions: the `box` modifier's `style` prop and the `defaultTextStyler` modifier's `style` prop are **raw StyleNodes**, not Values. These two positions nest a full StyleNode (with its own props/variants/modifiers/animation) for composition.

Every other modifier prop accepts a Value object (`{ value|token|directives }`). Canonical form is leaf-expanded and Value-wrapped; input sugar (bare scalar, structured-literal shorthand) is accepted and normalized.

Canonical form:
```jsonc
{ "modifier": "opacity", "props": { "opacity": { "value": 0.5 } } }
{ "modifier": "padding", "props": {
    "padding": { "value": {
      "top":    { "value": 8.0 },
      "left":   { "value": 8.0 },
      "right":  { "value": 8.0 },
      "bottom": { "value": 8.0 }
    } }
} }
{ "modifier": "reset" }
```

Accepted input sugar (normalizes to canonical form above):
```jsonc
{ "modifier": "opacity", "props": { "opacity": 0.5 } }
{ "modifier": "padding", "props": { "padding": 8 } }
{ "modifier": "padding", "props": { "padding": { "value": { "all": 8 } } } }
```

### Closed registry (30)

`opacity`, `blur`, `aspectRatio`, `sizedBox`, `padding`, `align`, `flexible`,
`rotatedBox`, `visibility`, `clipOval`, `clipRect`, `clipRRect`, `clipPath`,
`clipTriangle`, `transform`, `scale`, `rotate`, `translate`, `skew`,
`shaderMask`, `fractionallySizedBox`, `intrinsicHeight`, `intrinsicWidth`,
`iconTheme`, `defaultTextStyle`, `defaultTextStyler`, `box`, `mouseCursor`,
`scrollView`, `reset`.

Per-modifier prop shapes in `registry.modifiers`.

### Reset semantics

`reset` is a destructive sentinel. In a merged modifier list (base + variant contributions concatenated), `reset` at index *i* discards every entry at index `< i`. To survive a later reset, emit modifiers after it, not before.

### Closure surfaces

Modifiers that would require Dart closures (shader callbacks, custom clippers) accept a **host reference** instead:

```json
{ "modifier": "shaderMask", "props": {
    "shader":    { "host": "gradient.brand" },
    "blendMode": { "value": "srcATop" }
} }
```

See §Host references.

---

## Animation (implicit only)

```jsonc
{
  "kind":     "curve" | "decelerate" | "ease" | "easeIn" | "easeInSine"
            | "easeInQuad" | "easeInCubic" | "easeInQuart" | "easeInQuint"
            | "easeInToLinear" | "fastLinearToSlowEaseIn"
            | "fastEaseInToSlowEaseOut",
  "duration": 200,                     // integer ms
  "curve":    "easeOut",               // REQUIRED when kind=="curve"; forbidden otherwise
  "delay":    0                        // integer ms, optional
}
```

Phase and keyframe animations are deferred.

---

## Tokens

Producers reference tokens via `{ "token": "namespace.name" }`.

### Built-in namespaces (closed)

| Namespace | Type |
|---|---|
| `color` | `Color` |
| `radius` | `Radius` |
| `space` | `double` (spacing) |
| `double` | `double` (generic) |
| `breakpoint` | `Breakpoint` |
| `text` | `TextStyle` |
| `borderSide` | `BorderSide` |
| `shadow` | `List<Shadow>` |

### Extension namespaces

Producers MAY define tokens under an `x:` namespace (`x:brand.primary`, `x:motion.soft`). The JSON Schema accepts any matching `x:...` pattern syntactically; the validator does not inspect `x:` token contents. Resolution and type-matching happen at render time via the host runtime's registry.

### Validation rule

A token reference MUST have the form `namespace.name` — it MUST contain at least one `.`. `{ "token": "primary" }` (no namespace) is a validation error.

The namespace is the segment before the first `.`. For a token reference to be valid:
- The namespace MUST be one of the 8 built-ins, OR
- The namespace MUST start with `x:`.

Any other namespace is a validation error. Name lookup (does `color.primary` exist?) happens at resolution time, not validation time.

### Inline `tokens` bundle

Optional. Flat-keyed, matching the reference form:

```json
"tokens": {
  "color.primary": "#2196f3ff",
  "space.md":      16,
  "text.body":     { /* TextStyle literal */ }
}
```

Values accept the same input sugar as Value primitives.

### Resolution precedence

Tokens resolve in this order:

1. Inline document `tokens` bundle (exact fully qualified key match).
2. Host `MixScope`.
3. Unresolved — structured error at render time.

Inline overrides apply only on **exact fully qualified token keys** (e.g. `color.primary`). There is no partial-namespace merging: inlining `color.primary` does not shadow `color.secondary`.

---

## Extensions

`x:` is the only way to introduce custom surface:

```jsonc
{ "widget": "x:my-card",    "style": { "spec": "x:my-card", "props": {...} } }
{ "modifier": "x:parallax", "props": {...} }
{ "when":  { "x:feature-flag": "beta" }, "style": {...} }
```

### Naming rules

- Extension identifiers are `x:<atom>` or `x:<atom>.<path>` for tokens.
- An `atom` matches `[a-z][a-z0-9_-]*` — lowercase ASCII, starts with a letter, no spaces, no dots.
- Path segments (after the first `.` in a token) each match the same atom rule.
- Nested `x:` chaining is forbidden in schema-visible positions (widget/spec/modifier/when discriminators and tokens).
- The validator does not inspect `x:` prop contents; host registries do.
- Unknown `x:` handler at render time MUST produce a structured error (see §Error model), not a silent fallback.

### Round-trip preservation

- Canonicalizers, parsers, and serializers MUST preserve every `x:` field byte-for-structure through the pipeline — core-promise (extension payloads are host-owned; dropping or rewriting them breaks round-trip for documents that carry host-specific data). A document that enters with `{ "x:my-card": { "foo": 1 } }` MUST exit with the same structure.
- Preservation is defined via §Structural equality applied recursively to the `x:` payload. Primitive leaves (string / number / boolean) inside an `x:` payload are compared as opaque JSON.
- Validators MUST NOT rewrite, drop, or normalize the *contents* of `x:` fields. They MAY only reject the document outright if the `x:` identifier itself fails the atom grammar (§Naming rules).
- Nested `x:` keys *inside* an `x:` payload are legal as opaque data. The "no nested `x:` chaining" rule in §Naming rules applies to schema-visible positions (widget/spec/modifier/when discriminators and tokens), not to payload contents owned by the host.

---

## Host references

Runtime-resolved indirection uses a tagged object:

```json
{ "host": "gradient.brand" }
{ "host": "clipper.ticket" }
```

- Legal only in positions where the spec explicitly permits a host reference (see registry fields with `"kind": "host"`, e.g. `shaderMask.shader`, `clipPath.clipper`).
- Producers never use host references where normal Values are expected.
- Resolution failure at render time MUST produce a structured error (`host.unresolved`).
- String-prefix forms (`"host:..."`) are not part of the contract.
- For allowlist policy and capability-discipline rules, see §Security Considerations.

---

## Semantics

### Resolution order

Given a StyleNode, the consumer MUST:

1. Normalize the entire document to canonical form.
2. Resolve base props: each leaf Value → concrete Flutter value. This resolution is a single pass that applies token lookup (if any), then literal parse (if any), then the leaf's directive pipeline left-to-right. Directives are applied exactly once.
3. Evaluate variants in array order. For each active variant, recursively resolve its style (same pipeline, including its own directive pass) and merge over the accumulated result.
4. For composite specs, resolve `box` and `flex`/`stack` sub-styles independently and combine.
5. Attach animation config (see §Merge rules for override semantics).
6. Wrap modifiers outermost-first (array index 0 outermost). Apply `reset` sentinels against the merged modifier list.

### Directives-only Values

A leaf Value consisting only of `directives` transforms a *base* supplied by the enclosing context. A base exists when a prior contribution (base style, earlier variant) has resolved a value at the same leaf position.

- If no base exists at resolution time, the directives-only Value is a resolution-time error (code `directive.no-base`). Validation cannot detect this; it is caught at render time.
- Producers targeting unknown inheritance chains SHOULD supply a `value` or `token` alongside directives.

### Merge rules

Applied on the **canonical, leaf-expanded** form:

- **Scalar leaf Values** — later wins, full replacement.
- **Structured literals** — shallow-merge on declared sub-fields. Missing sub-fields inherit from the base; present sub-fields override.
- **Array fields** (`modifiers`, `variants`, `directives`, `textDirectives`) — concatenate. Only `reset` (modifiers) discards.
- **Composite specs** — sub-styles (`box`, `flex`, `stack`) merge independently. Absent sub-style = no change.
- **`animation`** — later wins, full replacement. A variant whose only contribution is an `animation` field overrides the base animation and leaves props untouched.

### Variant matching

- Array order decides precedence among matching variants.
- `{ "not": X }` matches iff `X` does not.
- Inapplicable state variants do not match and do not error (§Variants).
- **A variant's contributed style MUST use the same `spec` as the enclosing StyleNode.** Changing `spec` via a variant is a validation error. For composites, the variant's style MUST be a composite of the same kind (`flexbox` / `stackbox`).
- **Named variant activation**: `{ "named": "<name>" }` matches iff the host runtime has activated a variant by that exact string name. The activation mechanism is host-defined (typically an app-level flag).
- **Enum variant activation**: `{ "enum": "<EnumType>.<value>" }` matches iff the host runtime has activated the specified enum member. The host binds the `EnumType` name to a Dart enum.
- **Breakpoint matching**: `{ "context": "breakpoint", "token": "<breakpoint.X>" }` matches iff the current viewport `Size` satisfies the `Breakpoint` resolved from the token. Matching follows Mix's `Breakpoint.matches(Size)` semantics (min/max width/height bounds).

### Directive type validation

- Directive target type MUST match the enclosing leaf type.
- Spec-level `textDirectives` accept only string directives.

### Error model

```jsonc
{
  "path":    "/root/child/style/props/color/directives/1",
  "code":    "directive.type-mismatch",
  "message": "Directive 'darken' expects a Color target; leaf is 'double'.",
  "hint":    "Use a number directive, or change the prop."
}
```

- `code` is a stable machine identifier.
- `path` is a JSON Pointer (RFC 6901).
- The full code catalog is the language-neutral registry `error-codes.json` (sibling of this doc). That file is the source of truth; language implementations (Dart, TypeScript, …) mirror it. Adding a code is a MINOR schema bump; renaming or removing is MAJOR.

### Structural equality

Canonical structural equality between two documents (or nodes) is defined recursively:

- **Objects** are equal iff they have the same key set and, for each key, their values are structurally equal. Key order within an object is not significant; canonical form pins order for serialization, not comparison.
- **Ordered arrays** (`directives`, `variants`, `modifiers`, `children`, `textDirectives`, transform `ops`) are equal iff they have the same length and element-at-index values are structurally equal in order.
- **Strings** are byte-equal (case-sensitive). Colors compare as `#rrggbbaa` lowercase after canonicalization.
- **Numbers** are equal iff numerically equal after the canonical `double` / integer coercion (`16` and `16.0` compare equal when the target is `double`). `NaN` and `±Infinity` are rejected at canonicalization; structural equality never encounters them.
- **Booleans** are equal iff both `true` or both `false`.
- `null` is rejected as a Value literal; structural equality never encounters it.
- **`x:` extension payloads** are compared structurally as opaque JSON — the same rules recursively, with no type-level interpretation.

Text formatting (whitespace, indentation, line breaks) is outside the contract. Two documents that serialize to different text but share the same canonical structural model are equal for all conformance purposes.

---

## Conformance

An implementation claiming conformance to this specification takes on one or more of the roles below. Each role has its own obligations; implementations may combine roles.

### Producer
- A producer MUST emit JSON that validates against `schema.v1.json`.
- A producer MAY emit input sugar (bare scalars, structured-literal shorthand); canonicalization is the consumer's responsibility.
- A producer MUST NOT embed closures, shader callbacks, custom clippers, or arbitrary runtime handlers. It MUST use `{ "host": "..." }` tagged objects at the positions that permit host references.
- A producer SHOULD supply a `value` or `token` alongside `directives` unless an inherited base is guaranteed.

### Validator
Combines JSON-Schema structural checks with semantic checks the schema defers.

- A validator MUST reject any document that fails `schema.v1.json`.
- A validator MUST enforce per-prop type matching against `registry.json`: prop → expected literal / enum / scalar / token namespace.
- A validator MUST recursively enforce Value shape inside structured-literal bodies.
- A validator MUST enforce directive target-type matching, directive argument constraints (e.g. `divide.divisor ≠ 0`, `clamp.min ≤ clamp.max`), and the "directives-only-with-no-base" resolution-time rule.
- A validator MUST emit errors using the codes defined in `error-codes.json`.
- A validator operates in a single strict mode; it MUST NOT offer a lenient fallback.

### Canonicalizer
- A canonicalizer MUST be idempotent: `canonicalize(canonicalize(x))` is structurally equal to `canonicalize(x)`.
- A canonicalizer MUST produce output where every leaf is a Value object and every structured literal uses its leaf-expanded form.
- A canonicalizer MUST preserve the order of `directives`, `variants`, `modifiers`, and `children` arrays.
- A canonicalizer MUST preserve `x:` extension fields unchanged.

### Parser
- A parser MUST accept canonical JSON and produce typed runtime objects.
- A parser MUST surface resolution-time errors (e.g. `directive.no-base`, `token.unresolved`) using the codes in `error-codes.json`.

### Serializer
- A serializer MUST produce deterministic canonical JSON from the typed model.
- A serializer MUST preserve `x:` extension payloads from the source model.
- `serialize(parse(x))` MUST be structurally equal to canonical `x` for every canonical `x`.

### Consumer / runtime
- A consumer MUST resolve a parsed spec to a Flutter widget tree following §Semantics resolution order.
- A consumer MUST resolve tokens via the precedence: inline bundle → host `MixScope` → unresolved error.
- A consumer SHOULD emit a debug diagnostic when a state variant appears in a non-state-producing context; it MUST NOT hard-fail.
- A consumer SHOULD warn on `mixRuntime` mismatch; it MUST NOT hard-fail on mismatch.

### Lint tool (optional role)
- A lint tool MAY emit warnings beyond strict errors (unused variants, deeply nested trees, explicit `direction` on `RowBox`/`ColumnBox`, etc.).
- Lint diagnostics MUST NOT affect conformance.

---

## Non-serializable surface

Out of scope permanently:
- `ContextVariantBuilder` — arbitrary closure.
- Custom shader callbacks, custom `CustomClipper`s — use host references (see §Host references and §Security Considerations).
- Raw `ImageProvider` / `IconData` — use `Image` / `Icon` literals.

---

## Security Considerations

### Trust model

Producer JSON is **untrusted input** at the consumer boundary. The consumer is the trust boundary; it MUST validate the document before any semantic operation. Host references are capabilities the host runtime binds — the schema describes only the indirection form (`{ "host": "..." }`); the host is solely responsible for what those identifiers resolve to.

### Resource bounds

To prevent denial-of-service via maliciously crafted documents, validators MUST enforce the following limits and MUST reject any document that exceeds them, emitting a structured error with the corresponding code:

| Limit | Maximum | Error code |
|---|---|---|
| Document size | 1 MB | `envelope.document-too-large` |
| Tree nesting depth (widget + style, combined) | 32 | `canonical.depth-exceeded` |
| Array length (`children`, `variants`, `modifiers`, `directives`, `textDirectives`, `x:` arrays) | 1 024 | `canonical.array-too-long` |
| Directive chain on a single leaf | 16 | `directive.chain-too-long` |
| Token path length | 128 characters | `token.path-too-long` |

### External resolution

- Validators MUST NOT resolve external schemas or follow `$ref` URIs during validation — safety (untrusted documents could trigger SSRF or DoS via crafted `$ref` URIs). (`$ref` is deferred to post-v1.0.)
- Validators MUST NOT perform network I/O during validation.
- Validators MUST NOT read environment variables or file-system resources as part of validation.

### Host references

- Consumers SHOULD maintain an allowlist of permitted `host:` identifiers. Any `host:` identifier absent from the allowlist MUST fail with `host.unresolved`.
- `x:` extension payloads are host-owned; the validator does not inspect their contents. Consumers SHOULD treat `x:` payloads as capabilities subject to the same allowlist discipline as host references.

### Fail-closed default

Any resource-limit breach or unknown host reference MUST produce a structured error (see §Error model). Consumers MUST NOT render partial output from a rejected document — the document is accepted in full or rejected in full.

---

## Versioning

### `schema` (semver)
- MAJOR — removed or renamed canonical keys; changed semantics.
- MINOR — additive (new modifiers, directives, widgets, literals).
- PATCH — clarifications and documentation.

### `mixRuntime` (semver range)
- Advisory. Consumers SHOULD warn on mismatch; MUST NOT hard-fail.

### Migration
Each MAJOR bump ships a migration document and CLI migrator in the reference implementation.

---

## Parser & Serializer

### Architecture

```
  producer JSON
      │
      ▼
   Validator       ← JSON Schema + semantic rules
      │
      ▼
   Canonicalizer   ← sugar → canonical
      │
      ▼
   Parser          ← canonical → typed model → Mix runtime objects
      │
      ▼
   Mix runtime objects
      │
      ▼
   Serializer      ← Mix objects → canonical JSON
      │
      ▼
   canonical JSON
```

### Round-trip guarantees

Stated in terms of **canonical structural equality** on the normalized document model — not byte-equal JSON text. See §Structural equality for the comparison algorithm. The canonical serializer MUST be deterministic; text formatting (whitespace, key spacing, line breaks) is outside the contract.

- **Canonical idempotency** — `canonicalize(canonicalize(x))` is structurally equal to `canonicalize(x)`.
- **Parser ↔ Serializer** — `serialize(parse(x))` is structurally equal to `x` for all canonical `x`.
- **Semantic round-trip** — `parse(serialize(obj))` produces an object that renders identically to `obj`.

Conformance tests compare canonical models via structural equality.

### Deliverables — `packages/mix_schema/`

- `schema/v1.json` — formal JSON Schema (mirror of `guides/mix_schema/schema.v1.json`).
- `schema/prop-registry.json` — machine-readable prop registry (mirror of `guides/mix_schema/registry.json`).
- `schema/error-codes.json` — language-neutral error code registry (mirror of `guides/mix_schema/error-codes.json`).
- `lib/src/types/` — hand-written Dart types.
- `lib/src/validator.dart`, `canonicalizer.dart`, `parser.dart`, `serializer.dart`, `errors.dart`.
- `test/conformance/` — golden inputs, canonical outputs, round-trip tests.

### Error codes

Source of truth is `guides/mix_schema/error-codes.json` (language-neutral). `lib/src/errors.dart` mirrors it for Dart. Adding a code is MINOR; renaming or removing is MAJOR.

---

## Roadmap

### v1.0 — Public contract + reference toolchain *(current target)*
This document + registry + reference parser/serializer/validator + ≥5 normative examples + conformance suite.

### v1.1
`$ref` / named styles; host-bound actions/events; phase animations; TypeScript validator; producer SDKs.

### v1.2
Conditional children; iteration / data binding; keyframe animations.

### v2.0
Any MAJOR change; ships with migrator.

---

## DX deliverables before v1.0 lock

- [ ] Formal `schema/v1.json` (JSON Schema document).
- [ ] Machine-readable `schema/prop-registry.json` (copy of `guides/mix_schema/registry.json`).
- [ ] Language-neutral `schema/error-codes.json` (copy of `guides/mix_schema/error-codes.json`).
- [ ] Reference validator, canonicalizer, parser, serializer (Dart).
- [ ] Hand-written Dart types mirroring the schema.
- [ ] Conformance test suite (round-trip via structural equality).
- [ ] ≥ 5 end-to-end normative examples.
- [ ] Authoring guide for producer authors.

---

## Remaining open items

1. **Enum table consistency pass** — mechanical check of registry enums against current Flutter SDK; any value that ships in Flutter but is missing from the registry gets added (MINOR bump). Policy is locked (mirror Flutter, pinned per schema version); only the content sweep remains.
2. **Compound variant conditions** (`and`/`or`) — deferred to post-v1.0; revisit only if real producers hit the wall.

---

## Decisions (locked)

| # | Decision | Pick |
|---|---|---|
| 1 | Public contract vs internal serialization | Public contract |
| 2 | Canonical vs accepted input | Both; canonical normative |
| 3 | Value shape | `{ value?, token?, directives? }` |
| 4 | Directive naming | Short `op` keys |
| 5 | Variants shape | Tagged array, array-order precedence |
| 6 | Modifier order + reset | Array order + `reset` sentinel |
| 7 | Animation discriminator | `kind` field (implicit only in v1.0) |
| 8 | Non-serializable | Exclusion + `{ "host": "..." }` tagged objects |
| 9 | Extensibility | `x:` prefix, no nesting |
| 10 | Strictness | Strict default, discriminated unions |
| 11 | Versioning | Split `schema` + `mixRuntime` |
| 12 | Icon/Image descriptors | Structured literals |
| 13 | Prop registry | Machine-readable JSON + doc summary |
| 14 | Structured-literal directives | Leaf-only |
| 15 | Canonical structured literals | Leaf-expanded |
| 16 | State-variant mismatch | Not a schema error; runtime diagnostic allowed |
| 17 | Round-trip guarantee | Canonical structural equality |
| 18 | `x:` token namespaces | Allowed |
| 19 | `Pressable` style | Removed; use `PressableBox` |
| 20 | Event/action fields in v1.0 | Removed (deferred to v1.1) |
| 21 | Host refs form | `{ "host": "..." }` tagged objects |
| 22 | Validation modes | Single strict mode |
| 23 | Modifier prop canonical form | Values (same as StyleNode props) |
| 24 | Composite sub-styles | `spec` + `props` only; no nested variants/modifiers/animation |
| 25 | Variant changing `spec` | Forbidden; validation error |
| 26 | Token form | `namespace.name` required (must contain `.`) |
| 27 | `Pressable.child` / `PressableBox.child` | Required / optional |
| 28 | `Alignment` literal | Unified (`{x, y}` canonical; presets as sugar); no separate `AlignmentDirectional` literal |
| 29 | Integer → `double` coercion | Accept int at `double` positions; reject string-form numbers |
| 30 | Inline `tokens` bundle values | Accept same input sugar as Value primitives |
| 31 | `Matrix4` shape | Ordered transform-ops list (no Dart API leakage) |
| 32 | v1.0 transform ops | `identity`, `translate`, `scale`, `rotateZ` only |
| 33 | Transform-op discriminator | `op` field (same as directives) |
| 34 | Angle canonical unit | Radians |
| 35 | Enum allowed set | Mirror Flutter's public surface; pinned per schema version |
| 36 | Enum aliases | `FontWeight.normal` → `w400`, `bold` → `w700` (input sugar only) |
| 37 | Token resolution precedence | Inline bundle → host MixScope → unresolved error |
| 38 | Token override scope | Exact fully qualified keys only; no namespace merging |
| 39 | Error code registry | Language-neutral `error-codes.json` is source of truth |
| 40 | `x:` atom grammar | `[a-z][a-z0-9_-]*`; no spaces, uppercase, or dots inside an atom |
| 41 | Empty optional arrays | Omitted in canonical form |

---

## Normative examples (v1.0 deliverable)

See [`examples.md`](./examples.md). Each example is part of the v1.0 contract and doubles as a conformance fixture. Covered:

- Animated button — `PressableBox`, state variants, implicit animation, directive on token.
- Responsive grid item — breakpoint + orientation variants.
- Form input — named + state + context variants, text directives, token refs.
- Themed card (dark mode) — token refs + `onDark` + shadows.
- Composite widget — `flexbox` with partial variant contribution.

---

## References

- Mix source: `packages/mix/lib/src/`
- Machine-readable prop registry: [`registry.json`](./registry.json)
- Error code registry: [`error-codes.json`](./error-codes.json)
- Formal JSON Schema: [`schema.v1.json`](./schema.v1.json)
- Normative examples: [`examples.md`](./examples.md)
- RFC 6901 (JSON Pointer) — error paths.
