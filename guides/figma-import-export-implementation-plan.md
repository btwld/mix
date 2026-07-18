# Figma Importer/Exporter on the Mix Protocol — Implementation Plan

## Context

Mix has a versioned JSON wire protocol (`packages/mix_protocol`) for styles and
token themes, tooling primitives (document inspection, `WidgetStateStyleOverride`),
a proven producer precedent (`mix_tailwinds`: external format → Mix stylers,
protocol as round-trip oracle in tests), and a consumer ecosystem (Atlas /
remix_studio) built on a portable component contract (`mix_atlas/component/v1|v2`,
currently implemented in btwld/remix `feat/remix_studio` → `remix_capture`).

Goal: bidirectional Figma bridge. Import Figma variables/styles/nodes into
protocol documents (runtime-loadable via `MixScope`, or codegen'd to Dart);
export Mix themes/styles/component captures to Figma variables, styles, and
component sets.

Decisions made by Leo:
- **Everything in this repo**: `packages/mix_figma`, a shared component-contract
  package (scaffolded now), and the TypeScript Figma plugin.
- **Full importer+exporter planned as one multi-phase plan.**
- DTCG 2025.10 is the token boundary format; protocol documents are canonical
  artifacts (checked in under `design/tokens/`); plugin-first transport.

Research is consolidated in `guides/figma-import-export-plan.md` (working tree)
and `git show origin/claude/mix-protocol-figma-research-6mccyq:guides/figma-mix-protocol-plan.md`.

## Pinned constraints (all verified)

- **Protocol**: theme docs have 11 groups (fixed order: colors, spaces, doubles,
  radii, textStyles, shadows, boxShadows, borders, fontWeights, breakpoints,
  durations); token names `^[A-Za-z0-9_.-]{1,128}$`; aliases are same-group,
  whole-value, **flattened on re-encode** → authored docs are the source of
  truth for alias structure; `decodeTheme` is strict-only; no explicit nulls;
  `"infinity"` sentinel; `kind: "space"|"double"` on double token refs; style
  term grammar literal | `{"$token"}` | `{"$merge"}`; 8 styler discriminators.
- **Flutter coupling**: `mix_protocol` imports Flutter → `mix_figma` is a
  melos `flutter_projects` package. Plain `dart run tool/x.dart` works inside
  such packages only if the entrypoint's import graph avoids `dart:ui`
  (`mix_tailwinds/tool/gen_registry.dart` precedent).
- **Repo wiring**: no pub workspace (CLAUDE.md stale — melos + generated
  `pubspec_overrides.yaml`); melos `packages/*` glob auto-discovers packages but
  `categories:` is a manual allowlist; `scripts/exports.dart`
  `_packageExportConfigs` contains only `'mix'` — `mix_protocol`'s barrel is
  hand-written; CI = `.github/workflows/test.yml` passing a `melos-commands`
  string (`schema:inventory && analyze:dart`) to a reusable workflow.
- **Figma (July 2026)**: Variables REST is Enterprise-only both directions;
  styles REST is metadata-only; **Plugin API is plan-agnostic** (reads/writes
  variables+styles+nodes, localhost via manifest `networkAccess`); variables
  hold primitives only → composite token kinds (textStyles/shadows/boxShadows/
  borders) round-trip via Figma text/effect styles; `/` ⇄ `.` name translation;
  FLOAT→group disambiguation priority: codeSyntax stamp → variable scopes →
  collection-name convention → config override → fallback **with mandatory
  warning diagnostic**; identity via `pluginData` + `mix_figma.lock.json`;
  BOOLEAN/STRING variables → diagnostic + skip; Figma native DTCG export =
  one JSON per mode, primitives only.
- **Contract extraction is pure-Dart-able** (verified import chains):
  `component_document.dart` / `component_parser.dart` / `component_v2_parser.dart`
  never call mix_protocol/Flutter themselves; they need only a ~90-line pure
  subset of `capture_bundle.dart`/`capture_parser.dart` (`ArtifactFailureKind`,
  `ArtifactLoadException`, `decodeJsonObject`, `validateArtifactPath`).
  Port source: `/tmp/remix_studio` (shallow clone of btwld/remix
  `feat/remix_studio`; re-clone if missing). Note: v2 has **no static JSON
  fixture** upstream (built in-memory by `test/artifact_fixture.dart`) — one
  must be materialized.

## Architecture principle

`mix_protocol`'s façade is JSON-in/JSON-out, so **a module needs Flutter in its
import graph only if it calls that façade**. Everything else (Figma JSON ⇄
neutral JSON, DTCG ⇄ theme-doc JSON, disambiguation, name mapping, codegen
text, component-doc walking, coverage reports) is pure `Map/List/String/num`
manipulation. Mirror the `mix_tailwinds` split: pure core enforced by a purity
test; Flutter-dependent bridge kept thin; mix_protocol used for validation in
tests (and optionally inline, see Spike 1).

## New packages

### `packages/mix_component_contract` (pure Dart, `dart_projects`)

Recommended name (`mix_atlas_contract` is the alternative if wire-id symmetry
with `mix_atlas/component/*` is preferred — the schema id string is a wire
constant either way).

- `lib/src/`: `component_document.dart`, `component_parser.dart` (v1 + byte
  front door), `component_v2_parser.dart` — ported near-verbatim from
  `/tmp/remix_studio/packages/remix_capture/lib/src/artifacts/`; plus new
  `json_io.dart` + `artifact_exceptions.dart` (the carved pure subset).
- `lib/mix_component_contract.dart`: hand-written curated barrel
  (mix_protocol style).
- `pubspec.yaml`: `publish_to: none`, sdk `>=3.11.0 <4.0.0`, **no
  flutter/mix/mix_protocol deps**, dev_deps `test: ^1.24.4` (mix_generator
  precedent); `analysis_options.yaml` includes `../../lints_with_dcm.yaml`.
- `test/`: ported v1/v2 parser tests on `package:test`; `purity_test.dart`
  (adapted from `packages/mix_tailwinds/test/parser_purity_test.dart`);
  fixtures: copied `button_baseline` v1 component doc + **newly materialized
  static v2 fixture**.

### `packages/mix_figma` (two-layer, `flutter_projects`)

- `lib/src/core/` — **pure** (purity-test enforced), local `JsonMap` typedef:
  - `dtcg/`: `DtcgDocument`/`DtcgToken` model, parser, writer ($extensions
    passthrough; alias strings `{group.token}`).
  - `figma/`: variables document model (collections/modes/variables/aliases/
    scopes/codeSyntax), parser + write-payload writer; styles (values-bearing)
    parser; node document model (fills, auto-layout, boundVariables).
  - `mapping/`: `disambiguateFloatVariable(...)` (priority chain returning
    group + confidence + evidence), `MixFigmaNameMapper` (`/`⇄`.` + name-regex
    validation), `MixFigmaConfig` (override file model).
  - `diagnostics/`: `MixFigmaDiagnostic` (code/severity/path/message),
    `MixFigmaCoverageReport` (mirrors remix `protocol/coverage.json` shape).
  - `identity/`: `mix_figma.lock.json` model (Figma ids stay out of protocol docs).
  - `codegen/`: `generateTokensSource(themeDocument)` → Dart source text
    (gen_registry.dart pattern; output `tokens.g.dart` with token consts +
    per-mode scope maps).
  - `protocol_json/`: `buildProtocolThemeJsonFromDtcg`,
    `buildProtocolThemeJsonFromFigmaVariables` (per mode),
    `buildProtocolStyleJsonFromNode`, `buildFigmaVariableWritePayload`,
    `buildFigmaStylePayloads` (composites → text/effect styles),
    `buildComponentSetPayload` (component doc + resolved slot styles → Figma
    component-set payload).
- `lib/src/runtime/` — the **only** layer importing mix_protocol/Flutter:
  `MixFigmaBridge` (materialize/dematerialize theme+style, `diffableTheme`/
  `diffableStyle` wrapping `inspectThemeDocument`/`inspectStyleDocument`,
  `tokenRefs` wrapping `tokenReferencesOf`); `mix_scope_loader.dart`
  (`MixProtocolTheme` → `MixScope`).
- `tool/`: `gen_tokens.dart` (pure, plain `dart run`); `mix_figma_cli.dart`
  (`pull|push|check|serve` dispatcher); `bridge_server.dart` (localhost HTTP
  for the plugin dev loop: `POST /pull/tokens`, `GET /push/tokens`,
  `POST /pull/nodes`, `GET /push/components/:id`, `GET /health`; pure reshaping
  by default, `?validate=true` routes through `MixFigmaBridge` — see Spike 1).
- `test/`: per-module core tests; runtime bridge/loader flutter_tests;
  `core_purity_test.dart` + `runtime_boundary_test.dart`; fixtures
  (`dtcg/`, `figma_variables/`, `theme_docs/light|dark.theme.json`, `style_docs/`).
- `pubspec.yaml`: mix_protocol template (`publish_to: none`, flutter sdk,
  path deps on `mix`, `mix_protocol`, `mix_component_contract`; `yaml: ^3.1.0`
  for the override file — pure Dart, keeps core purity intact).

### `packages/mix_figma_plugin` (TypeScript; melos ignores it — no pubspec)

- `manifest.json` (networkAccess allowlist incl. localhost dev domain),
  esbuild → `dist/code.js` + single-file `dist/ui.html`.
- `src/`: `main.ts` (sandbox), `ui/` (iframe + postMessage),
  `bridge/dev_bridge_client.ts`, `variables/read|write_variables.ts`,
  `styles/read|write_styles.ts`, `nodes/read_selection.ts`,
  `components/write_component_set.ts`.
- `src/generated/` — **committed** `.d.ts` from mix_protocol's exported JSON
  Schemas via `json-schema-to-typescript` (`npm run gen:types`), so the plugin
  is structurally checked against the same contract.
- Tests with mocked `figma.*` API.

## Phases

### Phase 0 — Foundations
1. **Spike 1 first** (informs CLI design): throwaway script importing
   `package:mix_protocol/mix_protocol.dart`, run via plain `dart run` — record
   whether the standalone VM can execute mix_protocol code (no in-repo
   precedent imports it outside `flutter test`). If it fails, `check`/
   `serve --validate` shell out to a `flutter test`-hosted harness instead.
2. `packages/mix_protocol/tool/export_schemas.dart` (`--write`/`--check`) →
   commit `packages/mix_protocol/schema/style.schema.json` + `theme.schema.json`.
3. Scaffold `mix_component_contract` (port files, carve pure subset,
   materialize static v2 fixture, purity test).
4. Scaffold `mix_figma` skeleton (module stubs, purity/boundary tests) and
   `mix_figma_plugin` (manifest, npm scripts, typegen from committed schemas).
5. Golden corpus: hand-authored DTCG (Figma-native + Tokens Studio shapes),
   Figma-variables JSON, expected `light|dark.theme.json`, 2–3 style docs.
6. Repo wiring (see checklist below).

Exit: `melos run analyze` green; `schema:export --check` fails on drift/passes
clean; contract package green under `dart test` incl. purity; mix_figma green
under `flutter test`; plugin `npm run build && npm test` green with
byte-identical regenerated types.

### Phase 1 — Token import (no plugin)
`core/dtcg/*`, `core/mapping/*`, `buildProtocolThemeJsonFromDtcg`,
`MixFigmaBridge`, `gen_tokens.dart`, CLI `pull --from dtcg`.

Exit: canonical round-trip equality vs `mixProtocol.encodeTheme(decodeTheme(x))`
(`_expectProtocolRoundTrip` pattern from
`packages/mix_tailwinds/test/protocol_contract_test.dart`); decoded theme
drives a real `MixScope` in a widget test incl. light/dark; CLI emits
`design/tokens/*.theme.json` byte-identical to goldens; `tokens.g.dart`
golden test.

### Phase 2 — Plugin read MVP
Plugin `read_variables.ts`/`read_styles.ts`; Dart figma parsers;
`buildProtocolThemeJsonFromFigmaVariables`; bridge server `POST /pull/tokens`;
coverage report wiring.

Exit: fixture plugin-export JSON → same theme goldens as Phase 1; coverage
report enumerates every variable supported/unsupported with reason;
disambiguator unit tests cover all five tiers (fallback asserts a warning
diagnostic — never silent); validate against one **real** moderately complex
Figma export, not just fixtures; plugin tests green against mocked API.

### Phase 3 — Token export/write-back
Plugin `write_variables.ts`/`write_styles.ts` (codeSyntax + pluginData
stamping); `buildFigmaVariableWritePayload`/`buildFigmaStylePayloads`; bridge
`GET /push/tokens`; optional Enterprise REST fast path
(`push --transport rest`, env-gated, marked accelerator).

Exit: **fixed point** — `pull → push → pull` byte-identical on the golden
corpus; `mix_figma.lock.json` preserves variable ids across the cycle;
composites provably route to text/effect styles (write payload never creates a
composite variable); plugin write tests assert stamping.

### Phase 4 — Node/style import
`figma_node_document.dart`, `buildProtocolStyleJsonFromNode`, plugin
`read_selection.ts`, `materializeStyle<T>`.

Exit: reference card/button fixture strict-decodes via
`mixProtocol.decodeStyle<BoxStyler>/<FlexBoxStyler>` with zero errors;
`boundVariables` become `{"$token"}` terms; every known no-analog case
(margin, inner shadow, absolute-positioned stack children, sweep gradient,
per-edge borders, foregroundDecoration) emits a structured diagnostic —
unit-tested per case; style round-trip canonical equality.

### Phase 5 — Component export
`buildComponentSetPayload` + plugin `write_component_set.ts`: anatomy →
nested auto-layout frames; recipes × states → variant grid (states rendered
deterministically via `WidgetStateStyleOverride`,
`packages/mix/lib/src/core/providers/widget_state_style_override.dart`);
v2 bindings → Figma variable bindings.

Exit: ported `button_baseline` v1 fixture + new v2 fixture produce one Figma
component per recipe, named by property coordinates; the fixture's
`spinner: unsupported` case surfaces as a diagnostic, not dropped; README
states fixtures are self-authored/ported copies (no live remix dependency).

### Phase 6 — Sync/drift tooling
`mix_figma_cli.dart check` built on `diffableTheme`/`diffableStyle`
(inspection evidence with alias chains — **never** decode→encode diffing,
which flattens aliases and would report false drift); optional webhook
listener stub (`LIBRARY_PUBLISH` carries variable change lists).

Exit: no-op `pull → push → pull → check` reports zero drift on an **aliased**
theme (explicit regression test for the flattening trap).

## Repo wiring checklist

- `melos.yaml` categories: `packages/mix_figma` → `flutter_projects`;
  `packages/mix_component_contract` → `dart_projects`.
- `melos.yaml` scripts: `schema:export` (`--check`, mirrors `schema:inventory`
  shape) chained into the `analyze` script alongside `schema:inventory` and
  `analyze:dcm`; `gen:schema-export` (`--write`) and `gen:mix-figma-tokens`
  chained into `gen:build` (mirrors `gen:tailwinds-registry` wiring).
- CI `.github/workflows/test.yml`: add `melos run schema:export` to the
  `melos-commands` string; add a path-filtered Node job
  (`packages/mix_figma_plugin/**`: `npm ci && npm run build && npm test`).
- Do **not** register new packages in `scripts/exports.dart` — hand-written
  barrels per `mix_protocol` precedent.
- `.gitignore`: `packages/mix_figma_plugin/dist/` (node_modules already
  globally ignored).
- New `design/tokens/` directory for canonical theme artifacts.
- CLAUDE.md: fix stale "Pub workspace" section (melos + generated
  `pubspec_overrides.yaml`, no pub workspace) and stale package list (add
  mix_protocol, mix_tailwinds, mix_figma, mix_component_contract).
- Commit the research doc `guides/figma-import-export-plan.md` (already in
  working tree) alongside Phase 0.

## Spikes / risks

1. **`dart run` + mix_protocol import** — unverified; design already makes it
   non-blocking (pure CLI paths never touch the façade). Run first in Phase 0.
2. **Alias flattening** — handled: drift diffs use inspection evidence, and
   authored documents are the alias source of truth.
3. **FLOAT disambiguation in real files** — fallback tier always warns; test
   against a real export early in Phase 2.
4. **Figma manifest/networkAccess specifics** — external surface; re-verify at
   plugin implementation time.
5. **`ack` reuse in pure core** — don't; hand-roll structural validation like
   `component_v2_parser.dart` does (`_asObject`/`_requiredString` helpers).

## Key reference files

- `packages/mix_protocol/lib/src/contract/mix_protocol_contract.dart` (façade,
  theme codec, JSON Schema export)
- `packages/mix_protocol/lib/src/inspection/document_inspection.dart`
- `packages/mix_protocol/WIRE_CONTRACT.md`, `test/theme_codec_test.dart`
- `packages/mix_tailwinds/tool/gen_registry.dart`,
  `test/parser_purity_test.dart`, `test/protocol_contract_test.dart`
- `/tmp/remix_studio/packages/remix_capture/lib/src/artifacts/*` (port source;
  re-clone btwld/remix `feat/remix_studio` if missing)
- `melos.yaml`, `.github/workflows/test.yml`, `scripts/exports.dart`

## Verification (end-to-end)

Per phase exit criteria above, plus before each commit:
`melos run gen:build && melos run ci && melos run analyze` (repo convention),
`dart test` in `mix_component_contract`, `npm run build && npm test` in the
plugin, and the golden-corpus fixed-point check
(`pull → push → pull` byte-identical + `check` zero-drift) once Phases 3/6 land.
