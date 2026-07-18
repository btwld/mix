# Figma Import/Export over the Mix Protocol — Research & Plan

Status: proposal (research complete, no implementation yet)
Date: 2026-07-16

## 1. Goal

Bidirectional bridge between Figma and Mix, using `mix_protocol` documents as the
canonical interchange:

- **Import** — Figma variables, styles, and (later) components become protocol
  theme/style documents, consumable at runtime via `MixScope` or as generated
  Dart token/style code.
- **Export** — Mix themes, styles, and captured component recipes become Figma
  variable collections, paint/text/effect styles, and component sets.

The framing that makes this cheap: **a Figma importer is a protocol *producer*
exactly like `mix_tailwinds` (external DSL → Mix stylers, protocol as the
round-trip oracle), and a Figma exporter is a protocol *consumer* exactly like
Atlas/remix_studio (walks documents, renders/emits per-property output with
diagnostics).** Both roles already have working in-tree precedents.

## 2. What already exists (research inventory)

### 2.1 `packages/mix_protocol` (this repo)

- Versioned v1 JSON wire format, single façade `mixProtocol`:
  `encodeStyle`/`decodeStyle`, `encodeTheme`/`decodeTheme`,
  `exportStyleJsonSchema`/`exportThemeJsonSchema`. Strict + lenient decoding,
  canonical encoding, stable path-qualified error codes.
- 8 styler discriminators (`box`, `text`, `flex`, `stack`, `icon`, `image`,
  `flex_box`, `stack_box`). Property grammar ("terms"): literal,
  `{"$token": name}`, `{"$merge": [...]}` — a JSON mirror of the runtime
  `Prop<T>` source/directive model. Variants, modifiers, animation are
  discriminated sub-objects (`WIRE_CONTRACT.md`).
- Theme documents `{"v":1,"type":"theme","colors":{...},"spaces":{...},...}`
  across 11 token groups; decode directly into `Map<MixToken,Object>` →
  `MixScope(tokens:)`. Aliases resolve eagerly with cycle checks.
- **Atlas tooling primitives (#984)**: `document_inspection.dart` — JSON-Pointer
  addressed evidence records for every declared value/directive/selector and
  per-token alias chains; plus `token_reference_walker.dart` (works on live
  runtime objects too) and `WidgetStateStyleOverride` in core Mix for
  deterministic state rendering.
- Coverage is a hand-maintained ratchet (`schema_inventory_manifest.dart`,
  `styler_field_inventory.dart`) with CI drift tests — the protocol tells you
  explicitly what is `supported` vs `knownUnsupported(reason)`.
- Deliberate non-goals we must respect: **no widget-tree/document layer, no
  resolved-spec format, no extension registry**; unpublished (`publish_to: none`).

### 2.2 Component layer (btwld/remix, branch `feat/remix_studio`)

- Portable component contract `mix_atlas/component/v1` and **v2**: `properties`
  (enum/string/icon/bool), `states` (→ `widgetStates`), `slots` (kind:
  flex_box/text/icon/…), `anatomy` (stack/slot node tree with `visibleWhen`
  rules), `recipes` (property combos → per-slot style documents). v2 adds
  embedded styles and typed node **bindings** (token/literal/property).
- **Adapters** (e.g. `fortal_button_protocol_adapter.dart`): project a composite
  component styler into protocol leaf stylers + structured diagnostics
  (`unsupported_slot_primitive`, `unsupported_component_modifier`, …).
- `remix_capture`: producer pipeline → capture bundles (component docs,
  per-recipe style docs, `themes/light.mix.json` + `themes/dark.mix.json`,
  state-matrix PNGs), JSON diffing, directory/GitHub sources.
- Consumers: remix_studio / Atlas (btwld/muse) — catalog, inspect, compare,
  token usage.

### 2.3 Mix core surface relevant to mapping

- Tokens are string-named, typed consts (`ColorToken('brand.primary')` …), name
  charset on the wire is `[A-Za-z0-9_.-]{1,128}`. Resolution via `MixScope`
  (values or per-context resolver functions); Material bridge exists.
- Light/dark is **not** stored on the token: it is a scope swap (two theme docs,
  as in capture fixtures) and/or style-level `BrightnessVariant`
  (`.onDark(...)`).
- Variant split that Figma doesn't make: author-chosen axes → `NamedVariant`/
  `EnumVariant`; interaction states → `WidgetStateVariant`; environment →
  `ContextVariant` (breakpoint, platform, orientation…).
- `FlexBoxSpec` ≈ Figma auto-layout frame nearly 1:1 (`spacing` ↔ gap is the
  cleanest match). Opacity/blur live on **modifiers**, not specs (except
  `IconSpec.opacity`).
- Codegen precedent for "JSON in → Dart out" is
  `packages/mix_tailwinds/tool/gen_registry.dart` (plain script + `dart format`),
  **not** `mix_generator` (analyzer/annotation-based, wrong tool for this).

### 2.4 Figma platform facts (verified against current official docs, 2026)

| Capability | Path | Plan gating | Notes |
|---|---|---|---|
| Read file/node trees, render images | REST `GET /v1/files`, `/images` | all plans | styles endpoints are **metadata-only**; values need a second `/nodes` call |
| Read/write **variables** | REST `/v1/files/:key/variables*` | **Enterprise only** (read *and* write); 4MB POST, ≤40 modes, ≤5000 vars/collection, atomic | unchanged as of Nov 2025 |
| Read/write variables, styles (with values), nodes, components | **Plugin API** | **not plan-gated** (except extended collections) | the only variable read/write path for non-Enterprise; mode count soft caps: 10/collection Pro, 20 Org |
| Plugin → local tooling | manifest `networkAccess.allowedDomains` / `devAllowedDomains` | n/a | localhost bridge is supported and standard |
| DTCG token JSON | native Variables UI export/import (~Nov 2025) | all plans | **manual UI feature; REST still speaks Figma's proprietary schema** |
| Code Connect (Dev Mode snippets) | template files are framework-agnostic → Dart possible | Org/Enterprise + Dev/Full seat | display-only, never writes to canvas |
| Dev Mode MCP server | remote: all plans; desktop: paid plans | write-to-canvas free **in beta**, pricing TBD | future-facing, not a foundation to build on yet |
| Change notifications | Webhooks v2 `LIBRARY_PUBLISH` | includes created/modified/deleted **variables** lists | good for sync freshness |
| DTCG spec | — | — | **stable "2025.10"** (Oct 2025) Final CG Report; no longer "a draft" |

Prior art convergence: every Flutter-facing tool (figma2flutter et al.) consumes
Tokens Studio JSON and codegens Dart — none handle full style values or are
DTCG-native, all are stale. Style Dictionary is the standard transform engine
(v4+ speaks DTCG; no Dart platform out of the box). Specify is defunct.

**Consequence:** a **Figma plugin is the mandatory transport** for anything
plan-agnostic that touches variables or style *values*, in both directions. The
Enterprise REST path and the MCP server are optional accelerators, not the
foundation.

## 3. Architecture

```
            FIGMA SIDE                      NEUTRAL                         MIX SIDE
┌─────────────────────────────┐   ┌────────────────────────┐   ┌───────────────────────────────┐
│ Figma plugin (TS)           │   │ tokens: DTCG 2025.10   │   │ packages/mix_figma (Dart)     │
│  read: variables/modes,     │◄──┤ styles: mix_protocol   ├──►│  dtcg ↔ protocol-theme codec  │
│   styles+values, selection, │   │   style documents      │   │  paint/text/effect → stylers  │
│   boundVariables            │   │ components: portable   │   │  codegen (tokens.g.dart)      │
│  write: variable collections│   │   component docs (v2)  │   │  CLI: import/export/gen/serve │
│   styles, component sets,   │   └────────────────────────┘   │  round-trip + parity checks   │
│   variable bindings         │        files or localhost      └───────────────────────────────┘
└─────────────────────────────┘        bridge (plugin serve)        runtime: MixScope loader
```

Decisions embedded here (each is a re-derivable choice, see §7):

1. **Protocol documents are the canonical style format; DTCG is the canonical
   *token* format at the boundary.** DTCG buys three free integrations (Figma
   native export, Tokens Studio, Style Dictionary) for the cost of one
   `dtcg ↔ mix_protocol theme` converter. Styles and components have no neutral
   standard, so protocol/portable-component docs are used directly.
2. **One plugin, both directions.** Import and export share the mapping tables;
   symmetry is what makes round-trip tests possible.
3. **The tree/component layer stays out of `mix_protocol`** (its docs forbid it).
   Component interchange uses the portable component contract; the Figma
   exporter consumes the same capture bundles Atlas consumes.
4. **Two consumption modes for imported tokens:** runtime (`decodeTheme` →
   `MixScope`) needs zero codegen; generated `tokens.g.dart` (ColorToken consts
   + per-mode scope maps) is sugar for static reference, produced by a
   `gen_registry.dart`-style script.

## 4. Mapping design (the actual hard part)

### 4.1 Tokens / variables

| Figma | Mix | Rule |
|---|---|---|
| Collection mode | one protocol theme document per mode | matches existing `themes/light.mix.json` fixture layout; light/dark modes additionally map to `BrightnessVariant` convention |
| COLOR variable | `colors` group (`ColorToken`) | direct |
| FLOAT variable | `spaces` / `doubles` / `radii` / `fontWeights` | disambiguate by Figma variable `scopes` (`CORNER_RADIUS`→radius, `GAP`/`WIDTH_HEIGHT`→space, `FONT_WEIGHT`→fontWeight, else double); ambiguous/`ALL_SCOPES` → default `doubles` + diagnostic |
| Variable alias | theme-level alias | both sides forbid cycles; protocol resolves eagerly |
| STRING / BOOLEAN variable | no token kind | structured diagnostic, skipped (revisit if a use case appears) |
| Text style | `textStyles` (`TextStyleToken`) | composite → composite; line-height %/px/auto → Flutter `height` multiplier conversion rule + diagnostic when lossy |
| Effect style (drop shadow) | `boxShadows` / `shadows` | spread maps; **inner shadow → diagnostic** (Flutter `BoxShadow` has no inset) |
| Paint style: solid | `colors` | direct |
| Paint style: gradient | **not a token** — emitted as a reusable style fragment (Box styler doc) | no gradient token kind exists; adding one is a protocol change (see §7) |
| Name `group/sub/name` | `group.sub.name` | wire charset forbids `/`; deterministic bidirectional rename, mapping persisted in plugin `pluginData` + a manifest doc |
| `codeSyntax` | n/a — no Dart key exists (`WEB|ANDROID|iOS` only) | keep Dart symbol names in our own manifest; optionally mirror into `WEB` for Dev Mode visibility |

### 4.2 Styles / nodes

| Figma | Mix | Notes |
|---|---|---|
| Auto-layout frame | `flex_box` styler | direction/alignment/gap/padding map directly; **margin has no Figma analog** |
| Plain frame/rect | `box` styler | fills (solid/gradient/image), uniform stroke, per-corner radius, drop shadows, corner smoothing ↔ `RoundedSuperellipseBorderMix` |
| Freeform frame | `stack_box` | per-child absolute position is **not representable** in Mix styling (no Positioned mix) → diagnostic |
| Text node/style | `text` styler | fallback lists, directives, strut etc. have no Figma analog (export skips); Figma truncate ↔ `maxLines`+overflow |
| Layer opacity / blur / blend | Mix **modifiers** (`OpacityModifier`, `BlurModifier`) — except `IconSpec.opacity` | mapping rule targets the modifier list, not spec fields |
| Variable binding on a node prop | `{"$token": name}` term | read via `boundVariables` (import), written via `setBoundVariable` (export) |
| Not in Figma: sweep gradients, per-edge borders, foregroundDecoration, `backgroundBlendMode` | — | export diagnostics, mirroring the remix adapter diagnostic codes |

### 4.3 Components (export-first; import is assisted, later)

| Portable component doc (v2) | Figma |
|---|---|
| `properties` (enum axes) | component set variant properties |
| `states` (`widgetStates`) | a state variant axis (hover/pressed/disabled…), rendered deterministically via `WidgetStateStyleOverride` |
| `recipes` × states matrix | the variant grid |
| `anatomy` stack/slot tree | nested auto-layout frames |
| v2 token bindings | Figma variable bindings on the corresponding node props |

Direction asymmetry is deliberate: **component export is well-defined** (capture
bundle in → component set out); **component import is inference** (which axes
are named variants vs states, which frames are slots) and ships later as an
assisted flow, not automatic.

## 5. Deliverables & phases

New code proposed in this repo (final homes are open question #1):

- `packages/mix_figma/` — Dart package (unpublished, like `mix_protocol`):
  DTCG codec + theme converter, Figma paint/text/effect → styler import,
  export payload builder, token codegen script, CLI
  (`import` / `export` / `gen` / `check` / `serve` for the plugin bridge).
- `tools/figma_plugin/` — TypeScript Figma plugin (read + write), localhost
  bridge in dev, file drop otherwise; private-org distribution.

**Phase 1 — Token import (no plugin needed yet).**
DTCG 2025.10 parser + `dtcg ↔ protocol theme` converter + `MixScope` runtime
loader + `tokens.g.dart` generator + CLI. Inputs that work day one: Figma's
native DTCG UI export and Tokens Studio JSON.
*Validation:* round-trip `dtcg → theme → dtcg` and `decodeTheme` → live
`MixScope` widget test; canonical-encoding equality.

**Phase 2 — Plugin MVP, read side.**
Enumerate collections/modes/variables (+aliases, scopes), local paint/text/
effect styles **with values**, emit DTCG + protocol style fragments; POST to
`mix_figma serve` or download. This defeats both the Enterprise REST gate and
the styles-metadata-only limitation.
*Validation:* fixture Figma file → snapshot bundle golden-tested against the
Phase 1 pipeline; coverage report (`supported`/`unsupported` per entry) in the
style of `protocol/coverage.json`.

**Phase 3 — Node/style import.**
Selected frame → `box`/`flex_box`/`text`/`icon` styler documents, preserving
`boundVariables` as `$token` terms; diagnostics for unmappables (absolute
position, inner shadow, …). Output: protocol docs + optional generated Dart
styler snippets.
*Validation:* import a reference Figma card/button; render with Mix; pixel-diff
against Figma's REST image render (reuse the tailwinds browser-parity budget
approach, ~1–5%).

**Phase 4 — Export (write side).**
Theme docs → variable collections/modes/aliases (+ scope inference, name
mapping); style docs → Figma styles; capture bundles → component sets with
variable bindings per §4.3.
*Validation:* export→import round-trip equality on theme docs; visual parity of
Figma component grid vs `WidgetStateStyleOverride` PNGs from the capture
pipeline.

**Phase 5 — Sync & ecosystem hardening.**
`mix_figma check` drift command (document_inspection evidence + capture-style
JSON diff against a fresh Figma pull); Webhooks `LIBRARY_PUBLISH` listener for
freshness; optional Enterprise REST headless mode; optional Code Connect
template files emitting Mix snippets (Org/Enterprise only); watch Dev Mode MCP
server pricing/stability as a possible second transport.

Phases 1→3 are the importer; Phase 4 the exporter. Each phase lands
independently useful.

## 6. Risks

- **Variables REST is Enterprise-gated (read *and* write)** — accepted; plugin
  is the primary transport by design. Don't burn time on the REST path early.
- **Semantic mismatches are permanent, not bugs**: uniform stroke vs per-edge
  borders, no margin, no inset shadow in Flutter, no sweep gradient in Figma,
  line-height model differences. The mitigation is the protocol's existing
  idiom: structured, path-addressed diagnostics + a coverage ratchet, never
  silent lossiness.
- **Mode semantics**: Figma modes are per-collection dicts; Mix is scope-swap.
  The per-mode-theme-document rule covers it, but non-brightness modes (brand,
  density) need a declared convention (scope swap keyed by app state; possibly
  `NamedVariant`) — decide in Phase 1, document in the converter.
- **Component import inference** is the only genuinely fuzzy area — kept out of
  the critical path (assisted, Phase >5 unless demand pulls it in).
- **`mix_protocol` is v1-stabilizing and unpublished** — same-repo development
  and version-stamped documents (`"v":1` + `mixProtocolVersion`) contain the churn.
- **Figma plugin review/distribution** — private-org publishing needs no review;
  community listing (if ever) does.

## 7. Open questions (need Leo's call)

1. **Where does the code live?** `mix_figma` beside `mix_protocol` here (my
   recommendation: dependency direction and inventory-ratchet tests stay in one
   repo) vs btwld/muse with Atlas. Same question for the TS plugin
   (in-repo `tools/` vs its own repo — I lean in-repo until it stabilizes).
2. **Promote the portable component contract?** Component export needs the
   `mix_atlas/component/v2` parser, which currently lives in
   remix_capture (btwld/remix). Extracting the contract into a shared package
   (here, next to `mix_protocol`) would let mix_figma consume it without a
   cross-repo dev dependency. Recommended, but it moves code Leo may want to
   keep remix-side.
3. **Import ordering vs export ordering.** Plan assumes import-first (tokens are
   the highest-value, lowest-risk slice). If the driving use case is designer
   review of existing Mix components (Atlas-adjacent), swap Phase 4 earlier.
4. **Gradient/text-style tokens.** Figma gradient paint styles have no Mix token
   kind; adding one is a deliberate protocol v-next change (inventory ratchet +
   codec). Ship without it (style-fragment workaround) or scope it into Phase 1?
5. **DTCG at the boundary — confirm.** The alternative (plugin emits protocol
   theme docs directly, skip DTCG) is one less converter but loses Tokens
   Studio/Style Dictionary/native-export interop. I recommend keeping DTCG.

## 8. Sources

- In-repo: `packages/mix_protocol/{README,GUIDE,REQUIREMENTS,WIRE_CONTRACT}.md`,
  `document_inspection.dart`, `schema_inventory_manifest.dart`,
  `packages/mix_tailwinds/tool/gen_registry.dart`, PRs #979/#984, issue #982.
- btwld/remix `feat/remix_studio`: `remix_capture` (component v1/v2 parsers,
  fixtures incl. `themes/*.mix.json`, `protocol/coverage.json`),
  `fortal_button_protocol_adapter.dart`, `apps/remix_studio`.
- Figma: developers.figma.com REST/variables/plugin/Code Connect/MCP/webhooks
  docs (fetched July 2026); DTCG 2025.10 (designtokens.org); Style Dictionary
  v4/v5 docs; Tokens Studio; Material Theme Builder.
