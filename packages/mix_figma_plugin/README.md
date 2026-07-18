# Mix Figma Bridge plugin

This package is the Figma-side transport for `mix_figma`. It reads and writes
Figma variables, local text/effect/paint styles, selected nodes, and normalized
component-set payloads. The UI talks to the local bridge at
`http://localhost:8787`; the manifest allows that address only as a development
domain.

## Development

```sh
npm ci
npm run gen:types
npm run build
npm test
```

Import `manifest.json` as a development plugin in Figma. `npm run build`
produces `dist/code.js` for the plugin sandbox and a self-contained
`dist/ui.html` for the iframe.

The project uses `strict: true`. `skipLibCheck` is limited to dependency
declarations because the official Figma globals intentionally redeclare DOM
names such as `fetch`, `console`, and `Navigation` in this combined
sandbox/iframe TypeScript project.

`src/generated/*.d.ts` is committed and generated directly from
`../mix_protocol/schema/*.schema.json`. Regeneration is deterministic; schema
changes must be followed by `npm run gen:types`.

## Neutral transport shapes

All bridge DTOs live in `src/types.ts` and are JSON-safe:

- `/pull/tokens` receives `{ variables, styles }`. Collections retain mode IDs,
  variables retain primitive/alias values, scopes, `codeSyntax`, and every
  private `pluginData` entry. Styles retain native values and plugin data.
- `/push/tokens` returns collection/variable/style write payloads. `ref` is the
  stable reference within one payload; `sourceId` is the current Figma ID when
  known. Writers also resolve `mix_figma.id` stamps, so existing IDs survive a
  pull/push cycle.
- `/pull/nodes` receives `{ nodes }`, where `nodes.selection` is a recursive,
  values-bearing snapshot plus structured diagnostics for known lossy cases.
- `/push/components/:id` returns a normalized component-set payload. Each
  payload variant becomes one Figma component named from sorted property
  coordinates. Anatomy nodes are nested frames/text/vector primitives, and
  `variableBindings` contains Figma variable IDs. A later payload can reuse a
  stamped component set and variants through `sourceId` without duplicating
  them.

The plugin stamps identities under these private plugin-data keys:

- `mix_figma.id`
- `mix_figma.kind`
- `mix_figma.protocolVersion`
- `mix_figma.tokenGroup`

Composite protocol values remain native Figma styles. Any protocol-only fields
that Figma cannot represent natively (for example text color in a Figma text
style) can be retained verbatim in payload `pluginData`; the writer never
creates a variable for a composite style.

Unsupported component anatomy is not discarded: the writer creates a named
placeholder frame and returns an `unsupported_component_anatomy_node`
diagnostic. Likewise, selection reads report margin metadata, inner shadows,
absolute auto-layout children, angular/sweep gradients, unequal per-edge
strokes, and foreground-decoration metadata as structured warnings.
