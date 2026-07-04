# Guide: server-driven, token-themed UI with `mix_schema`

A practical, end-to-end tutorial for using `mix_schema` to ship Mix styles as
**data** — validated JSON that decodes into real Mix stylers on the client.

This guide is task-oriented. For the canonical wire format see
[`WIRE_CONTRACT.md`](WIRE_CONTRACT.md); for the surface summary see
[`README.md`](README.md). Every code sample and payload here matches the current
public API and the package's own tests.

---

## Which use case fits `mix_schema`?

`mix_schema` is a **per-node style contract**, not a widget-tree/layout format.
That boundary decides which integrations work today:

| Candidate | Needs | Works today? |
|---|---|---|
| Figma **frame → whole screen/widget tree** | a document format for the *tree* | **No** — that is the future widget-tree document layer (separate package). |
| Figma **design tokens → app theme** | theme document + token refs + client resolution | **Yes** (theme model). |
| **Server-driven component styling** | versioned envelope, strict/lenient decode, property grammar | **Yes** (format v1 + property grammar). |

**Recommended use case:** *server-driven component theming with the token
palette sourced from Figma (or any design-token source).* Figma is the origin of
your tokens and per-component styles, `mix_schema` is the transport, and
`MixScope` is client-side resolution. The payoff is something plain Mix cannot
do: change a color in Figma → export → ship JSON → every app re-themes live,
with no app-store release.

Whole-tree conversion (Figma frame → screen) is out of scope: `mix_schema`
styles a node; composing nodes into a screen is the future tree layer that will
sit on top of this contract.

---

## Mental model

`mix_schema` deals in two JSON document types. Both decode into **real** Mix
objects — there is no intermediate DTO layer.

```
                 ┌── style document ──►  contract.decode<BoxStyler>()  ──► a real BoxStyler
JSON on the wire ┤
                 └── theme document ──►  MixSchemaThemeCodec().decode() ──► Map<MixToken, Object>
                                                                                    │
                                            MixScope(tokens: …) resolves $token refs at render time
```

- A **style document** is one styler serialized (`type: "box" | "text" | "icon" | …`);
  any value may be a literal or a `{"$token": "name"}` reference.
- A **theme document** (`type: "theme"`) is the token palette — the values
  behind those names.
- The app decodes both, feeds the theme's tokens into `MixScope`, and renders
  stylers normally. Swap the theme document and the subtree re-themes.

Pipeline:

```
Figma variables/styles
      │  (export step: Figma API or Tokens Studio → JSON transform)
      ▼
theme.json  ──┐
              ├─►  backend / CDN  ──►  Flutter app  ──►  MixScope + Mix widgets
button.json ──┘     (validated in CI)     (decode)
```

---

## Step 0 — Setup

`mix_schema` is intentionally unpublished for now (`publish_to: none`), so depend
on it by path or a pinned git ref:

```yaml
# pubspec.yaml
dependencies:
  mix: ^2.0.3
  mix_schema:
    path: ../packages/mix_schema   # or git: with a pinned ref
```

```dart
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';
```

Build one contract and reuse it:

```dart
final contract = MixSchemaContractBuilder().builtIn().freeze();
// or the shared registry-free singleton with every branch:
// final contract = builtInMixSchemaContract;
```

---

## Step 1 — Design tokens → a theme document

Extract Figma **variables** (colors, spacing, radii) and **text styles** into the
theme document's kind-grouped maps. The map names mirror `MixScope(tokens:)`
groups exactly.

```json
{
  "v": 1,
  "type": "theme",
  "colors": {
    "color.surface": "#101820",
    "color.primary": "#3D5AFE",
    "color.onPrimary": "#FFFFFF",
    "color.primaryPressed": { "$token": "color.primary" }
  },
  "spaces": {
    "space.sm": 8,
    "space.md": 16,
    "space.lg": 24
  },
  "radii": {
    "radius.card": 12
  },
  "textStyles": {
    "text.button": { "fontSize": 16, "fontWeight": "w600", "height": 1.2 }
  }
}
```

Rules to encode in your export transform:

- **Token names** match `[A-Za-z0-9_.-]{1,128}`; dotted names map cleanly to
  Figma `group/name`.
- **Values use the same canonical wire shapes** as style documents (colors are
  `#RRGGBB` / `#AARRGGBB` / `rgb()` / `rgba()`).
- **Aliases** (`"color.primaryPressed": {"$token": "color.primary"}`) are allowed
  only within the same map, resolved eagerly at decode with cycle detection, and
  cannot carry `apply`. Cross-kind aliases and nested refs inside concrete values
  fail decode by design.

Available token groups: `colors`, `spaces`, `doubles`, `radii`, `textStyles`,
`shadows`, `boxShadows`, `borders`, `fontWeights`, `breakpoints`, `durations`.

The export step itself (Figma REST `GET /files/:key/variables`, or a Tokens
Studio export, piped through a small transform) is ordinary glue — the contract
consumes the tokens you extract; it does not read Figma. Keep that transform in
your repo so a token change is a reviewable diff.

---

## Step 2 — Author component styles as payloads

A primary button as a `box` style document referencing tokens:

```json
{
  "v": 1,
  "type": "box",
  "padding": { "left": { "$token": "space.md" }, "right": { "$token": "space.md" },
               "top": { "$token": "space.sm" }, "bottom": { "$token": "space.sm" } },
  "decoration": {
    "color": { "$token": "color.primary" },
    "borderRadius": { "$token": "radius.card" }
  },
  "variants": [
    {
      "kind": "widget_state",
      "state": "pressed",
      "style": {
        "type": "box",
        "decoration": {
          "color": { "$token": "color.primary", "apply": [ { "op": "color_darken", "amount": 0.1 } ] }
        }
      }
    },
    {
      "kind": "context_breakpoint",
      "token": "breakpoint.tablet",
      "style": { "type": "box", "padding": { "left": { "$token": "space.lg" }, "right": { "$token": "space.lg" } } }
    }
  ]
}
```

Three features in play:

- **`$token` references** — resolved on the client, not baked values.
- **`apply` directives** — `color_darken` composes a transform onto the token for
  the pressed state (27 directives available: color/string/number; see
  WIRE_CONTRACT §Directives).
- **token-backed breakpoint variants** — responsive styling keyed to a
  `BreakpointToken`.

To layer two independently-authored fragments the encoder emits a
`{"$merge": [ …ordered sources… ]}` term; you rarely hand-write it (see Step 7).

---

## Step 3 — Decode and resolve in the app

This is the verified end-to-end pattern (the shape of the package's
`theme_inheritance_demo_test`):

```dart
final contract = MixSchemaContractBuilder().builtIn().freeze();

// 1) Decode the theme → tokens ready for MixScope.
final theme = switch (const MixSchemaThemeCodec().decode(themeJson)) {
  MixSchemaDecodeSuccess(:final value) => value,
  MixSchemaDecodeFailure(:final errors) => throw StateError('bad theme: $errors'),
};

// 2) Decode a component style → a real BoxStyler.
final buttonStyle = switch (contract.decode<BoxStyler>(buttonJson)) {
  MixSchemaDecodeSuccess(:final value) => value,
  MixSchemaDecodeFailure(:final errors) => throw StateError('bad style: $errors'),
};

// 3) Provide the tokens; render the styler like any hand-written one.
Widget build(BuildContext context) {
  return MixScope(
    tokens: theme.tokens,                 // Map<MixToken, Object>
    child: Box(style: buttonStyle, child: const Text('Buy now')),
  );
}
```

Swap `theme.tokens` for a dark-theme document's tokens and the same styler
re-themes. Wrap a subtree in `MixScope.inherit(tokens: override.tokens, child: …)`
to override just that part of the tree.

Result types are sealed — handle both arms. A `MixSchemaDecodeSuccess` also
carries `.warnings` (Step 5). A `MixSchemaDecodeFailure` carries `.errors`, each a
`MixSchemaError` with a `.code` (`MixSchemaErrorCode`), a JSON-Pointer `.path`
(e.g. `/decoration/color`), and a `.message`.

---

## Step 4 — Icons and images (per-call resolvers + value forms)

Identity objects (`IconData`, `ImageProvider`) are resolved by name per call, and
registry-free value forms cover common cases:

```dart
const icons = {'home': Icons.home, 'cart': Icons.shopping_cart};

final iconStyle = contract.decode<IconStyler>(
  {'v': 1, 'type': 'icon', 'icon': 'home', 'size': 24},
  options: MixSchemaDecodeOptions(resolveIcon: (name) => icons[name]),
);
```

- `resolveIcon` / `resolveImage` are per-call callbacks — identity is an app
  decision at decode time, not baked into a shared schema.
- Value forms need no app state: `{"codePoint": …}` for icons, `{"url": …}` for
  `NetworkImage`, `{"asset": …}` for `AssetImage`.
- **Caveat:** raw `codePoint` icons defeat Flutter icon tree-shaking. For app
  icons, prefer resolver *names* mapped to `const IconData`; use value forms for
  tooling and controlled payloads.
- Resolver names match `[A-Za-z0-9_-]{1,96}`. A well-formed name the resolver does
  not return fails decode with `unresolved_identity_name`.

---

## Step 5 — Server-driven and safe against untrusted JSON

The versioned envelope is what makes untrusted, evolving payloads safe.

- Every document carries `v: 1`. An unsupported/malformed version fails with
  `unsupported_version` — a real version-skew signal, not a generic error.
- **Strict decode is the default** and is what you want for untrusted server
  payloads: it fails closed on anything unknown.
- **Lenient decode** is the forward-compat path for an old app hitting a newer
  server — unknown fields/variants/enum values are skipped at the smallest
  repairable spot, each reported as a warning with its original path:

```dart
final result = contract.decode<BoxStyler>(
  payloadFromServer,
  options: const MixSchemaDecodeOptions(mode: MixSchemaDecodeMode.lenient),
);
if (result case MixSchemaDecodeSuccess(:final value, :final warnings)) {
  for (final w in warnings) {
    log('skipped forward-compat field at ${w.path}');   // telemetry your version skew
  }
  render(value);
}
```

- Untrusted input is preflighted before the engine runs: **max depth 64**,
  **max 10,000 nodes**, explicit JSON `null` forbidden everywhere, and lenient
  cleanup capped at 256 removals — a JSON bomb fails with `limit_exceeded`, not a
  hang.
- Evolution rule: within `v: 1` you may *add* fields/kinds/enum values (old strict
  clients reject them, old lenient clients skip them). Changing the meaning, unit,
  type, or spelling of an existing key requires `v: 2`.

---

## Step 6 — Author-time and CI safety

By design, a style referencing a token the theme does not define **does not fail
decode** — it becomes a runtime `MixScope` lookup (`StateError` on first frame).
That decoupling is deliberate, so catch gaps before shipping with three tools:

**1. Fast structural rejection:**
```dart
final v = contract.validate(payloadFromCms);   // MixSchemaValidationResult
```

**2. JSON Schema export** — drive editor/CMS validation or type generation from
the real contract (Ack types stay hidden):
```dart
final jsonSchema = contract.exportJsonSchema();
```
Point a CMS field validator or a VS Code `$schema` at this and authors get
inline errors as they type.

**3. Token preflight** — diff tokens a style *uses* against tokens a theme
*declares*, and fail the build on a gap:
```dart
final style = contract.decode<BoxStyler>(stylePayload).value!;
final theme = const MixSchemaThemeCodec().decode(themePayload).value!;

final used = tokenReferencesOf(style);
final declared = theme.tokens.keys.map(MixSchemaTokenReference.fromToken).toSet();
final missing = used.difference(declared);

if (missing.isNotEmpty) {
  throw StateError('styles reference undefined tokens: $missing');
}
```
Run this in the PR that regenerates `theme.json`, and a designer deleting a
variable a style still uses becomes a red CI check, not a broken screen.

---

## Step 7 — Reverse direction: author in Dart, ship as data

To write styles in Dart and publish them as JSON (a preset package, a
design-system export), encode is the mirror image — and fail-loud: anything the
wire cannot represent throws with a precise code, never a silent drop.

```dart
final styler = BoxStyler()
    .padding(EdgeInsetsMix(all: 16))
    .decoration(BoxDecorationMix(color: Colors.indigo));

final out = switch (contract.encode(styler)) {
  MixSchemaEncodeSuccess(:final value) => value,      // a JsonMap you can serve
  MixSchemaEncodeFailure(:final errors) => throw StateError('$errors'),
};
```

- A `.merge()`-composed styler round-trips: it encodes as a `$merge` source stack
  and resolves identically after decode.
- To emit resolver *names* for icons instead of value forms, pass a reverse map:
  `MixSchemaEncodeOptions(iconNames: {'home': Icons.home})`.
- Unrepresentable values (a closure, an `onEnd` callback, `decoration.image`) fail
  with `unsupported_encode_value` at build time, not by losing styling silently.

---

## Step 8 — Limits and gotchas

- **Out of scope in v1** (omit, or expect `unsupported_encode_value`):
  `decoration.image` / `DecorationImageMix`, non-standard shape/directional border
  families, preset-only helpers like `ElevationShadow`, and anything
  closure-backed (`onEnd`, `KeyframeAnimationConfig`, custom `Curve` subclasses).
- **Unknown token = runtime error, not decode error** — hence the Step 6
  preflight.
- **Missing `v` is warning-only today** (a transition compromise); it flips to
  fatal before this format is published, so do not rely on omitting it.
- **Whole-tree Figma conversion is not this package** — `mix_schema` is per-node
  style; the tree layer is a future package that will sit on top.

---

## The operational loop

```
Designer edits a color variable in Figma
   └─► export step regenerates theme.json (reviewable PR diff)
        └─► CI runs contract.validate() + tokenReferencesOf() preflight  ✅ or ❌
             └─► merge → backend/CDN serves theme.json + component *.json
                  └─► apps decode (strict) + MixScope(tokens:) → live re-theme, no release
```

A design-token change reaching production behind a validated PR without an
app-store round-trip is exactly what the format's four core policies — versioning,
token references, value-based encode, and per-call identity — were built to make
safe. Plain Mix cannot do it because it exists only at compile time; `mix_schema`
is the bridge to data.

---

## Quick API reference

| Task | Call |
|---|---|
| Build a contract | `MixSchemaContractBuilder().builtIn().freeze()` / `builtInMixSchemaContract` |
| Decode a style | `contract.decode<BoxStyler>(json, options: …)` → `MixSchemaDecodeResult<T>` |
| Decode a theme | `const MixSchemaThemeCodec().decode(json)` → `MixSchemaThemeDocument` (`.tokens`) |
| Encode a styler | `contract.encode(styler, options: …)` → `MixSchemaEncodeResult` |
| Validate only | `contract.validate(json)` → `MixSchemaValidationResult` |
| Export JSON Schema | `contract.exportJsonSchema()` |
| Token preflight | `tokenReferencesOf(styler)` + `MixSchemaTokenReference.fromToken` |
| Decode options | `MixSchemaDecodeOptions(mode:, resolveIcon:, resolveImage:)` |
| Encode options | `MixSchemaEncodeOptions(iconNames:, imageNames:)` |
| Resolve tokens at render | `MixScope(tokens: theme.tokens, child: …)` / `MixScope.inherit(…)` |
