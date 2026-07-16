# Figma ⇄ Mix Protocol Importer/Exporter — Research & Plan

> Status: research + proposal (July 2026). No implementation yet.
> Scope: building a bidirectional bridge between Figma (variables, styles, nodes)
> and `mix_protocol` documents (theme + style documents).

---

## 1. Why `mix_protocol` is the right substrate

The `packages/mix_protocol` package already provides everything an external
design tool needs to interoperate with Mix, without touching Mix runtime
internals:

| Capability | API | Why it matters for Figma |
|---|---|---|
| Versioned JSON wire format | Format `v: 1`, 8 styler kinds (`box`, `text`, `flex`, `stack`, `icon`, `image`, `flex_box`, `stack_box`) + `theme` documents | Stable interchange format; the Figma tool produces/consumes JSON, never Dart |
| Strict decode → real stylers | `mixProtocol.decodeStyle<T>()` | Untrusted Figma-derived JSON is validated at the boundary with path-qualified errors |
| Canonical, fail-loud encode | `mixProtocol.encodeStyle()` / `encodeTheme()` | Anything unrepresentable fails with `unsupported_encode_value` instead of silently dropping — exports are trustworthy |
| Token/theme model | 11 token groups (`colors`, `spaces`, `doubles`, `radii`, `textStyles`, `shadows`, `boxShadows`, `borders`, `fontWeights`, `breakpoints`, `durations`), same-kind aliases with eager resolution + cycle detection | Maps naturally onto Figma variable collections and aliases |
| Token refs in styles | `{"$token": "color.primary"}` property terms, plus `$merge` and `apply` directives | Mirrors Figma's `boundVariables` (a node property bound to a variable) |
| JSON Schema export | `exportStyleJsonSchema()` / `exportThemeJsonSchema()` (draft-07) | Generate TypeScript types for the Figma plugin; validate payloads plugin-side before they ever reach Dart |
| Document inspection | `inspectStyleDocument()` / `inspectThemeDocument()` (JSON-pointer evidence, alias chains, token occurrences) | Precise mapping between protocol fields and Figma layers/variables for diffing and sync UIs |
| Token preflight | `tokenReferencesOf(style)` | Diff a style's token refs against a theme's declared tokens → catch undeclared tokens before runtime |
| Capability inventory | `schemaInventoryManifest` (supported vs `knownUnsupported`, with reasons) | Drives which Figma properties the tool may export; keeps the tool honest as the protocol evolves |
| Reference consumer pattern | `mix_tailwinds` protocol contract tests (encode → decode → re-encode, assert canonical equality) | The exact validation harness the Figma exporter should copy |

The "Atlas tooling primitives" (PR #984) exist precisely for this class of
tool: typed context-variant value objects, `CssKeywordLinearTransform` for CSS
corner gradients, `WidgetStateStyleOverride` for forcing state variants in
previews, and the document-inspection API.

### Protocol constraints the tool must respect

- Always emit `v: 1` and a valid `type`; never emit explicit `null` (omit keys);
  `"infinity"` sentinel for unbounded constraints; `kind: "space" | "double"` on
  double-valued token refs.
- Decode Figma-derived input in **strict** mode; use lenient mode only for
  forward-compat tolerance and surface its warnings.
- Theme aliases are same-kind and whole-value only, and re-encoding a decoded
  theme flattens aliases — so the Figma tool must keep alias structure in its
  **own** intermediate representation if it wants to round-trip aliases
  losslessly (see §4.3).
- Not representable in v1 (fail-loud): `DecorationImage`, shape borders,
  directional edge insets, `Paint`-backed text foreground/background,
  closure-backed variants/modifiers/animations, phase/keyframe animations.

---

## 2. Figma integration surface (as of July 2026)

### 2.1 The plan-tier problem shapes the architecture

| Surface | Read variables | Write variables | Read styles/nodes | Write styles/nodes | Plan gating |
|---|---|---|---|---|---|
| REST API | `GET /v1/files/:key/variables/local` | `POST /v1/files/:key/variables` | `GET /v1/files/:key` (incl. `boundVariables` on nodes) | ❌ none | Variables endpoints: **Enterprise only**. File GET: any plan (rate-limited by tier/seat) |
| Plugin API | ✅ | ✅ | ✅ | ✅ (paint/text/effect styles + nodes) | **Any plan.** Private org distribution needs Org/Enterprise; Community publish needs Figma review |
| Figma MCP server (GA, Schema 2025) | `get_variable_defs` per selection | remote write-to-canvas (beta, later paid) | ✅ context tools | limited | remote server: all plans |
| Native DTCG import/export (Schema 2025) | export: one JSON per mode | import by drag-in | n/a | n/a | rolling out through 2026; **primitives only** |

Consequences:

1. **The Figma plugin is the only plan-agnostic bidirectional surface.** REST
   variables write is Enterprise-only and will stay a fast-path, not the
   baseline.
2. **Figma variables hold only primitives** (COLOR, FLOAT, STRING, BOOLEAN).
   Mix's composite token kinds (`textStyles`, `shadows`, `boxShadows`,
   `borders`) must round-trip through Figma **styles** (text/effect styles),
   which only the Plugin API can write.
3. Automation via REST must run under a Dev/Full seat (View/Collab seats get
   ~6 file reads **per month**); personal access tokens now expire in ≤ 90
   days, so CI should use OAuth or plan access tokens.

### 2.2 DTCG as the neutral interchange (recommended)

The Design Tokens Format Module **2025.10** is the first stable DTCG release
(Oct 2025). Figma's native variable import/export targets it, Style Dictionary
v5 adopts it as the base format, and Tokens Studio can emit it. Aligning the
token bridge with DTCG means:

- Figma's own export (one DTCG JSON per mode) becomes a free import source —
  no plugin required for the primitives-only path.
- Teams already on Tokens Studio/Style Dictionary can feed the same pipeline.
- Mix gets a documented, tool-neutral token story instead of a bespoke one.

DTCG does **not** standardize modes/theming — the file-per-mode convention
(Figma's) is the pragmatic choice, and it happens to match the protocol's
model exactly: one theme document per mode, layered at runtime via
`MixScope` / `MixScope.inherit`.

---

## 3. Proposed architecture

```
        Figma file                                Flutter app
  ┌──────────────────────┐                  ┌──────────────────────┐
  │ variables/collections │                  │ MixScope(tokens: …)  │
  │ paint/text/effect     │                  │ Box(style: …)        │
  │ styles, nodes         │                  └─────────▲────────────┘
  └───────▲──────┬───────┘                             │ decodeStyle/
          │      │                                     │ decodeTheme
   Plugin API   REST GET (any plan)                    │
   (read+write)  Variables REST (Enterprise fast path) │
          │      │                                     │
  ┌───────┴──────▼───────┐   protocol JSON   ┌─────────┴────────────┐
  │  mix_figma plugin    │◄─────────────────►│  mix_figma (Dart)    │
  │  (TypeScript)        │  theme + style    │  CLI + codecs        │
  │  UI iframe + sandbox │  documents        │  built on            │
  └──────────────────────┘  (+ DTCG files)   │  mix_protocol        │
                                             └──────────────────────┘
```

Two deliverables sharing one contract:

1. **`packages/mix_figma` (Dart, new package)** — the brain. Codecs between
   Figma/DTCG JSON and protocol documents, validation, diffing, and a CLI
   (`dart run mix_figma pull|push|check`). Depends on `mix_protocol` (path
   dep, like the rest of the workspace) and never on Figma network APIs
   directly — it consumes/produces files and optionally calls REST.
2. **Figma plugin (TypeScript)** — the hands inside Figma. Reads/writes
   variables and styles, exports/imports protocol theme documents (and DTCG),
   optionally syncs with a repo endpoint (manifest `networkAccess` allowlist).
   Types generated from `exportStyleJsonSchema()`/`exportThemeJsonSchema()`
   via `json-schema-to-typescript`, so the plugin is structurally checked
   against the same contract.

Everything flows through **protocol documents as the canonical artifact**
checked into the repo (e.g. `design/tokens/light.theme.json`,
`design/tokens/dark.theme.json`). Figma and Flutter are both projections of
those files.

---

## 4. Mapping design

### 4.1 Tokens: Figma variables ⇄ theme documents

| Figma | Mix token group | Notes |
|---|---|---|
| COLOR variable | `colors` | RGBA → `#AARRGGBB` (protocol color forms) |
| FLOAT, scope `CORNER_RADIUS` | `radii` | circular radius |
| FLOAT, scope `GAP` / `WIDTH_HEIGHT` / spacing-ish | `spaces` | default double kind |
| FLOAT, scope `OPACITY` / `EFFECT_FLOAT` / other | `doubles` | `kind: "double"` refs |
| FLOAT, scope `FONT_WEIGHT` | `fontWeights` | snap to 100–900 |
| FLOAT, dedicated "breakpoints" collection | `breakpoints` | by collection-name convention |
| FLOAT, dedicated "durations" collection (ms) | `durations` | by collection-name convention |
| STRING (`FONT_FAMILY` etc.) | folded into `textStyles` | no standalone string token in Mix |
| BOOLEAN | ❌ unsupported | warn + skip (fail-loud report) |
| Figma **text style** | `textStyles` | composite; via styles, not variables |
| Figma **effect style** (drop/inner shadow) | `shadows` / `boxShadows` | composite |
| Stroke on style/component conventions | `borders` | BorderSideToken |
| Variable **alias** | theme alias `{"$token": …}` | Figma aliases are same-type → satisfies protocol's same-kind rule; cross-collection OK since Mix token names are flat |
| Collection **modes** | one theme document per mode | `MixScope` layering at runtime |

Disambiguation inputs, in priority order: explicit **`codeSyntax`** on the
variable (we write the Mix token name + kind there, e.g. `space.md`), then
**variable scopes**, then **collection-name conventions**, then a per-repo
mapping config (`mix_figma.yaml`) for overrides. Figma variable names may not
contain `.`, so `color/primary` (Figma path convention) ⇄ `color.primary`
(Mix token name) with `/ ⇄ .` translation; both fit the protocol's token-name
regex after translation.

### 4.2 Styles: Figma nodes/components ⇄ style documents

Phase-2 scope (import direction first):

| Figma | Protocol |
|---|---|
| Frame fills/strokes/corner radius/effects | `box` decoration (color, gradient incl. `css_linear` transform, border, borderRadius, boxShadow) |
| Auto-layout (direction, gap, padding, alignment) | `flex_box` (padding, spacing, main/cross alignment) |
| Text node + text style | `text` (full TextStyle field set) |
| Absolute-position children | `stack_box` |
| `boundVariables` on a property | `{"$token": …}` property term |
| Component variants named by convention (`state=hover/pressed/disabled/focus`) | `widget_state` variants |
| Mode-conditional values (light/dark collection) | `context_brightness` variant, or resolved per-mode theme (preferred: keep it in tokens) |
| Breakpoint-named frames | `context_breakpoint` variants (min/max width or breakpoint token) |

Fail-loud policy (matching the protocol's own): anything without a clean
mapping (image fills, blend-mode exotica, vector shapes) is reported per node
with a JSON-pointer-style path, never silently approximated. The
`schemaInventoryManifest` is consulted so the tool's coverage claims can't
drift from the protocol's.

### 4.3 Round-trip fidelity

- The protocol flattens theme aliases on re-encode, so the **source of truth
  for alias structure is the authored theme document** (or DTCG file), not a
  decode→encode cycle. `inspectThemeDocument()` exposes both the alias chain
  and resolved value with JSON pointers — use it for diffing instead of
  re-encoding.
- Figma-side identity (variable ids/keys, style keys, node ids) is stored in
  Figma `pluginData` (plugin path) and in a local `mix_figma.lock.json`
  mapping file (REST path), keeping protocol documents clean of Figma ids.
  If we later want ids inside token files, DTCG `$extensions` is the sanctioned
  slot (e.g. `"$extensions": {"dev.fluttermix.figma": {"variableId": …}}`).

---

## 5. Implementation phases

### Phase 0 — Foundations (small, unblocks everything)
- `tool/export_schemas.dart` in `mix_protocol`: emit the style + theme JSON
  Schemas to committed files (e.g. `packages/mix_protocol/schema/`), wired
  into `melos run gen:build` freshness checks. Today schemas exist only at
  runtime; committing them lets non-Dart tooling consume the contract.
- Generate TypeScript types from those schemas; publish as an internal npm
  package or vendored file for the plugin.
- Build a small golden corpus: representative Figma file + its expected theme
  documents (light/dark) and 2–3 style documents.
- Decision record confirming: plugin-first, DTCG-2025.10-aligned, file-per-mode.

### Phase 1 — Token importer (Figma → Mix), the highest-value slice
- `packages/mix_figma`: 
  - DTCG 2025.10 reader → protocol theme documents (covers Figma native
    export, Tokens Studio, Style Dictionary inputs; primitives + aliases).
  - Figma REST reader (`GET /v1/files/:key` + `…/variables/local` when
    available) → same pipeline; graceful degradation when variables REST is
    403 (non-Enterprise): fall back to plugin-exported files.
  - Composite-token extraction from published text/effect styles (REST file
    read exposes style node values) → `textStyles`/`shadows`/`boxShadows`.
  - Validation: `mixProtocol.decodeTheme` strict; `tokenReferencesOf` diff
    against app styles; canonical re-encode check (mix_tailwinds pattern).
  - CLI: `mix_figma pull --file <key> --out design/tokens/`.
- Exit criteria: Figma variables + text/effect styles land as valid theme
  documents that drive a demo app through `MixScope`, light/dark switching
  included.

### Phase 2 — Token exporter (Mix → Figma)
- Figma plugin (TypeScript): import theme documents / DTCG files → create or
  update variable collections, modes, values, aliases; write composite tokens
  as text/effect styles; stamp `codeSyntax` + `pluginData` for round-trip
  identity. Diff-preview UI before applying (plugin has full write access on
  any plan).
- Enterprise fast path: `POST /v1/files/:key/variables` from the CLI for
  primitives-only sync in CI (atomic bulk endpoint, 4 MB / 5,000 vars /
  40 modes limits).
- Exit criteria: `pull → push → pull` is a fixed point on the golden corpus.

### Phase 3 — Style importer (Figma components → style documents)
- Node-tree walker (REST or plugin) → `box`/`flex_box`/`text`/`stack_box`
  documents with token refs from `boundVariables`, widget-state variants from
  component-variant naming conventions, breakpoint variants from frame naming.
- Per-node coverage report driven by `schemaInventoryManifest` (what mapped,
  what didn't, why).
- Exit criteria: a real component (e.g. button with hover/pressed/disabled
  variants) imports to a style document that renders faithfully in Flutter.

### Phase 4 — Exploratory (separate proposals once 1–3 land)
- Style exporter (Mix → Figma nodes/styles) — plugin write-back of style docs.
- Live preview: plugin selection → protocol JSON → hot-reloading Flutter
  preview (leveraging `WidgetStateStyleOverride` to force states).
- Figma MCP server integration and/or Code Connect-style Dev Mode snippets
  (no official Flutter support in Code Connect — an MCP-based approach may be
  the pragmatic route).

---

## 6. Risks & mitigations

| Risk | Mitigation |
|---|---|
| Variables REST is Enterprise-only (unchanged through mid-2026) | Plugin-first architecture; REST is an optional fast path. DTCG file import works with zero API access |
| Figma variables can't hold composites (typography/shadows) | Route composites through Figma text/effect styles via the plugin |
| Lossy/ambiguous FLOAT-variable typing | `codeSyntax` stamping + scopes + collection conventions + `mix_figma.yaml` overrides; never guess silently |
| Alias flattening on protocol re-encode | Authored documents are the source of truth; diff via `inspectThemeDocument`, not re-encode |
| Protocol is v1 and evolving (additive) | Strict decode + inventory-manifest ratchet + schema goldens keep the tool and protocol in lockstep |
| Rate limits / 90-day PATs for CI | OAuth or plan access tokens; Tier-aware backoff on 429 (`Retry-After`); Dev/Full seat required |
| Plugin distribution (private plugins need Org plan) | Publish to Community (Figma review) as the default channel |
| Figma's native DTCG import/export still rolling out, primitives-only | Treat it as one input source among several, not a dependency |

---

## 7. Open questions (for maintainer input)

1. **Package home**: new `packages/mix_figma` in this workspace
   (`publish_to: none` initially, like `mix_protocol`) vs a separate repo for
   the TypeScript plugin? Recommendation: Dart package here; plugin in a
   sibling repo once it needs its own CI/npm toolchain.
2. **DTCG as a first-class read/write format** vs Figma-shaped JSON only?
   Recommendation: yes to DTCG — it buys Tokens Studio/Style Dictionary
   compatibility nearly for free.
3. Should the protocol grow a **string token kind** (Figma STRING variables
   currently have no Mix destination) — or is folding into `textStyles`
   acceptable for v1 of the bridge?
4. Is **import (Figma → Mix)** confirmed as the priority direction for
   phase 1, with export following? (This plan assumes yes.)
