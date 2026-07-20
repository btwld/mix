# Mix Figma synchronization

The bridge treats synchronization as a four-step transaction. A successful
write is not considered complete until the result has been read back and shown
to be a fixed point.

## Workflows

| Workflow | Analyze reads | Apply writes | Verify proves |
| --- | --- | --- | --- |
| Token pull | Local Figma variables and styles | Staged Mix theme files | Planned files exist and retained deletions are reported |
| Token push | Figma variables and local styles | Exact approved Figma variable/style operations | A fresh Figma snapshot has no remaining mutation |
| Selection import | Current selection and bound variables | Staged `.style.json` files | Planned style files match the analyzed selection |
| Component export | One Figma component set identified by Mix ref | Exact approved component-set/variant operations | A fresh component-set snapshot has no remaining mutation |

The plugin UI is the supported interactive entry point. Start the bridge from
`packages/mix_figma`:

```bash
dart run tool/mix_figma_cli.dart serve \
  --host 127.0.0.1 \
  --port 8787 \
  --theme-dir ../../design/tokens \
  --style-dir ../../design/styles \
  --component-dir test/fixtures/components \
  --report-dir ../../design/figma-reports
```

Build and import the development plugin from `packages/mix_figma_plugin`, then
paste the session token printed by the bridge, use **Check bridge**, choose a
workflow, and run Analyze, Apply, and Verify in order. A fresh random token is
created for every bridge process; `--auth-token <value>` may be used when a
controlled automation environment needs a predetermined value. For component
export, enter the component document id, such as
`button`, `input`, or `card` when using the committed fixtures.

## Safety contract

- Analyze is read-only and creates a deterministic SHA-256 plan id from the
  current and desired states.
- Apply re-reads the current state supplied by the plugin. A changed state
  produces HTTP `409`; the user must analyze again.
- Every non-preflight endpoint requires the bridge process's bearer token, so
  an unrelated browser page cannot drive the localhost file-writing API.
- Local writes are staged in a temporary sibling directory. Existing managed
  files are backed up and restored if an apply step fails.
- Figma variable/style writes are sequenced, not raced. Token and component
  writes establish an undo boundary and trigger undo when a write throws.
- Deletion is excluded by default. Apply includes destructive operations only
  when the UI checkbox is explicitly enabled.
- A delete must name an exact source id and target a local resource carrying
  the expected `mix_figma.id` (or migrated `mix.key`) ownership stamp. Modes
  may be deleted only from a Mix-owned collection.
- Same-named unowned resources are not adopted. They remain visible as
  preserved/skipped state and are never deleted.
- A cached `sourceId` is only a lookup hint. Updates require the expected Mix
  identity stamp; if an ID now names an unowned resource, that resource is
  preserved and verified read-back repairs the lock with the managed ID.
- Remote library resources are read-only.
- The lock is updated only after a Figma write passes fresh read-back
  verification and every returned Figma id matches the identity-stamped
  resource observed in that read-back. Direct `/lock/tokens` and
  `/lock/components/*` calls are permanently disabled with HTTP `410`.
- Every Verify attempt, including a failed one, persists
  `<report-dir>/<planId>.json` using schema `mix_figma/sync-report/v1`.

`verifiedWithRetainedItems` is a successful result: approved changes converged,
while the workflow retained either user-owned/unmanaged resources or managed
deletions that were not explicitly approved. `failed` means mutations remain
and the lock was not changed.

## Fidelity and support

Fidelity is reported separately for the native target and for a bridge round
trip. The possible values are `exact`, `normalized`, `metadataOnly`, `lossy`,
`unsupported`, and `error`. “Supported” does not imply that both fidelity
dimensions are exact.

| Source feature | Native target | Round trip | Notes |
| --- | --- | --- | --- |
| COLOR variables and aliases | Exact | Exact | Alpha and alias identity are retained |
| Scoped FLOAT variables | Exact or normalized | Exact | Ambiguous floats require scope or `mix_figma.yaml` mapping |
| STRING/BOOLEAN variable-to-theme mapping | Unsupported | Unsupported | Not part of the current Mix primitive theme groups |
| Text styles | Exact for covered fields | Exact for covered fields | Protocol-only fields may be retained in plugin metadata |
| Drop shadows | Exact | Exact | Inner shadows are currently unsupported |
| Solid paint styles | Normalized to a color token | Lossy | The composite paint-style identity is not recreated |
| Gradient paint styles | Native Figma data is readable | Unsupported export | A structured diagnostic is emitted |
| Selection frame/auto-layout mappings | Box/flex mapping | Fixture-validated | Unsupported layout/decorations emit diagnostics |
| Component anatomy | Native nodes for FRAME, TEXT, RECTANGLE, ELLIPSE, LINE | Fixture-validated | Other anatomy becomes a named placeholder with a diagnostic |

Portable component layout, fill, stroke, radius, shadow, opacity, and text
fields are translated into native Figma node properties. New component sets
use hug-content auto layout where applicable and are placed beside existing
top-level content with deterministic spacing; updates preserve the existing
set position.

The executable corpus is
`test/fixtures/conformance/manifest.json`. Dart and TypeScript both validate
the same variable, style, selection, and Button/Input/Card fixtures on every
test run. The manifest is deterministic evidence for supported cases; the
live gate remains required for Plugin API behavior.

Text-style comparison is intentionally scoped to fields controlled by the Mix
payload. Native Figma defaults and user-authored fields outside that contract
are preserved and do not create false drift.

## Recovery

If Apply fails in Figma, the plugin requests undo and reports the error. Inspect
the canvas before retrying and run Analyze again; do not reuse the old plan. If
Verify fails, keep the report, inspect its diagnostics and remaining mutation
count, correct the source or destination, and analyze again. Do not hand-edit
the lock to force convergence.
