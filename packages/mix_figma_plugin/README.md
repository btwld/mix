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

Start the Dart bridge first, open the plugin, and use the guided workflow:

1. Paste the session token printed by the bridge and check bridge status.
2. Choose token pull, token push, selection import, or component export.
3. Select **Analyze**. This is read-only and produces an operation ledger.
4. Review errors, warnings, creates, updates, and proposed deletions.
5. Select **Apply**. Deletion is disabled unless the plan contains managed
   deletions and the user explicitly enables it.
6. Select **Verify**. Figma writes are read back; only a verified result can
   update the bridge lock.

Token and component writes use one undo boundary and trigger undo on a write
failure. Writers accept only the exact operations approved by the bridge.
The UI also rejects an Apply response whose plan, payload, or operation list
differs from Preview.
Unowned resources are never selected by name for update or deletion, remote
resources are not writable, and an exact delete is refused unless the target
carries the expected Mix identity.

The project uses `strict: true`. `skipLibCheck` is limited to dependency
declarations because the official Figma globals intentionally redeclare DOM
names such as `fetch`, `console`, and `Navigation` in this combined
sandbox/iframe TypeScript project.

`src/generated/*.d.ts` is committed and generated directly from
`../mix_protocol/schema/*.schema.json`. Regeneration is deterministic; schema
changes must be followed by `npm run gen:types`.

## Neutral transport shapes

All bridge DTOs live in `src/types.ts` and are JSON-safe. They travel only
through `/sync/plan`, `/sync/apply`, and `/sync/verify`:

- Token snapshots contain `{ variables, styles }`. Collections retain mode
  IDs; variables retain primitive/alias values, scopes, `codeSyntax`, and every
  private `pluginData` entry. Styles retain native values and plugin data.
- Token Apply responses contain collection/variable/style write payloads.
  `ref` is the stable reference within one payload; `sourceId` is only a lookup
  hint. An existing object is updated only when its Mix identity stamp matches;
  stale IDs never adopt an unowned Figma resource.
- Selection snapshots contain `{ nodes, variables }`, where `nodes.selection`
  is recursive and values-bearing, with structured diagnostics for known lossy
  cases. The variable document lets the bridge resolve bindings in the
  selection.
- Component Apply responses contain a normalized component-set payload. Each
  variant becomes one Figma component named from sorted property coordinates.
  Anatomy nodes are nested frames/text/vector primitives, and
  `variableBindings` contains Figma variable IDs.
- Apply reuses the exact analyzed operations. Verify re-reads Figma and sends
  the write result to the bridge. The bridge records stable IDs only after a
  successful fixed-point check.

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

The shared conformance corpus covers Button, Input, and Card component
contracts and selection snapshots in both Dart and TypeScript. It is a
committed regression baseline, not a substitute for the controlled live gate
in [the bridge runbook](../mix_figma/docs/live-release-gate.md).
