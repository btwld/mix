# Mix Figma live release result — 2026-07-19

- Date: 2026-07-19
- Latest automated revalidation: 2026-07-20
- Automated preflight operator: Codex
- Live gate operator: Pending
- Source Figma URL/file key: Pending controlled source-file creation
- Disposable destination URL/file key: Pending workspace approval
- Git branch: `leoafarias/figma-import-export-plan`
- Git checkpoint: `5005259a43112898ee0d6f86a49ad71ff6712f26` plus the documented dirty milestone worktree
- Plugin build commit: Same checkpoint and worktree
- Bridge command/config: Pending live gate; use the command in
  [synchronization.md](synchronization.md) with a fresh session token

This is a live release record in progress. Automated evidence is complete and
fresh for the current worktree. The controlled Figma gate is intentionally
marked pending; no Figma mutation is represented as verified below.

## Automated preflight

| Gate | Command | Exit status | Evidence summary |
| --- | --- | --- | --- |
| Focused Dart bridge/sync tests | `cd packages/mix_figma && flutter test` | 0 | 88 tests passed, including the nested protocol validation harness |
| Plugin tests | `cd packages/mix_figma_plugin && npm test` | 0 | 13 files and 36 tests passed |
| Plugin typecheck | `cd packages/mix_figma_plugin && npm run typecheck` | 0 | TypeScript reported no errors; also rerun by the production build |
| Plugin production build | `cd packages/mix_figma_plugin && npm run build` | 0 | `dist/code.js` built successfully at 47.7 kB |
| Generated artifacts | `melos run gen:build` | 0 | Every generation subcommand reported `SUCCESS` |
| Repository CI | `melos run ci` | 0 | Flutter and Dart package suites reported `SUCCESS` |
| Repository analysis | `melos run analyze` | 0 | Inventory, schema export, Dart analyzer, and DCM reported `SUCCESS`; DCM found no issues |
| Patch hygiene | `git diff --check` | 0 | No whitespace errors |

- Conformance manifest: `mix_figma/conformance/v1`, 8 uniquely identified
  cases: 2 token/style, 3 selection, and 3 component cases.
- Accounted token/style source items: 13.
- Native-fidelity totals: `exact: 8`, `normalized: 3`, `unsupported: 2`.
- Round-trip-fidelity totals: `exact: 9`, `lossy: 1`, `unsupported: 3`.
- Generated/unrelated diff audit: generation did not add diffs outside
  `.gitignore`, `packages/mix_figma`, and `packages/mix_figma_plugin`.
- Environment note: pub printed recurring `Invalid kernel binary format version`
  cache diagnostics,
  but every Melos stage and the combined process completed with exit status 0.

## Discovery

- Figma MCP authentication: Confirmed for Leo Farias (`leoafarias@gmail.com`).
- Writable workspaces found: Personal and Concepta.
- Workspace selected: Pending. Personal is recommended for isolation.
- Pages inspected: Pending file creation.
- Libraries searched: Pending file creation.
- Existing identity/name conflicts: Pending file creation.
- Approved scope: Pending Phase 0 discovery and explicit approval.
- Mutation status: No source or destination Figma file has been created or
  changed for this gate.

## Results

| Gate | Plan id | Apply result | Verify status | Report path | Notes |
| --- | --- | --- | --- | --- | --- |
| Token pull | Pending | Not run | Pending | Pending | Controlled source required |
| Button selection pull | Pending | Not run | Pending | Pending | Controlled source required |
| Input selection pull | Pending | Not run | Pending | Pending | Controlled source required |
| Token push | Pending | Not run | Pending | Pending | Disposable destination required |
| Button export | Pending | Not run | Pending | Pending | Disposable destination required |
| Input export | Pending | Not run | Pending | Pending | Disposable destination required |
| Card export | Pending | Not run | Pending | Pending | Disposable destination required |
| Managed-delete opt-out | Pending | Not run | Pending | Pending | Disposable destination only |
| Managed-delete opt-in | Pending | Not run | Pending | Pending | Explicit approval required |
| Stale-plan rejection | Pending | Not run | Pending | Pending | Disposable destination only |

## Evidence

- Automated fixed-point evidence:
  `token pull analysis previews files and reaches a fixed point`,
  `selection import plans named style files and reaches a fixed point`,
  `matching token state produces an idempotent preview`, and
  `component payload fingerprints produce a read-back fixed point`.
- Ownership and style-projection regressions:
  `stale source ids never adopt unowned resources`,
  `native text style defaults do not create false drift`, and matching plugin
  variable/style source-id tests pass.
- The bridge and plugin client expose synchronization only through the
  transactional `/sync/plan`, `/sync/apply`, and `/sync/verify` lifecycle.
- User-owned sentinel retained: Automated coverage passes; live proof pending.
- Sacrificial managed resource behavior: Automated coverage passes; live proof
  pending.
- Native visual/structural inspection: Pending.
- Known fidelity diagnostics: Corpus assertions pass; live comparison pending.
- Lock before/after failed verification: Automated failure-path assertions pass;
  live stale-plan proof pending.

## Invariant evidence matrix

| Invariant | Automated evidence | Live evidence | Result |
| --- | --- | --- | --- |
| Analyze and Preview are read-only; Apply matches the previewed plan | `sync plan is deterministic and keeps destructive work opt-in`; `rejects operations that were not present in Preview before writing Figma`; `imports a selection without issuing a Figma mutation` | Pending | Automated pass; live pending |
| Plan ids and operation order are deterministic | `sync plan is deterministic and keeps destructive work opt-in`; `writes token resources sequentially inside one undo boundary`; component fingerprint tests | Pending | Automated pass; live pending |
| A stale plan returns `409` without changing Figma or the lock | `apply rejects a stale plan before either side is mutated`; `does not mutate Figma when the bridge rejects a stale plan` | Pending | Automated pass; live pending |
| Local writes are staged and rolled back on apply failure | `a failed local Apply cannot be verified as an applied plan`; `a partial local installation is rolled back before Apply fails` | Not applicable to native canvas inspection | Pass |
| Figma write failure is recoverable through undo/error handling | `writes token resources sequentially inside one undo boundary`; `undoes the whole token write when a later resource fails`; `converts thrown values into correlated operation errors` | Pending controlled failure observation | Automated pass; live pending |
| A Verify report is persisted before the lock advances | `token push writes its lock only after verified read-back`; `a verified read-back does not advance the lock without its report`; component lock/read-back test | Pending | Automated pass; live pending |
| Failed read-back or report persistence leaves the lock unchanged | `failed token read-back never writes the lock`; `a verified read-back does not advance the lock without its report` | Pending | Automated pass; live pending |
| Deletion is disabled by default and targets only exact Mix-owned resources | Sync-plan opt-in test; token/component planner ownership tests; variable/style/component exact-delete tests | Pending opt-out and opt-in probes | Automated pass; live pending |
| Same-named unowned and remote resources are preserved | `same-named unowned resources are preserved instead of adopted`; `remote styles are rejected during Analyze instead of failing in Apply`; unowned variable/component refusal tests | Pending user-owned sentinel | Automated pass; live pending |
| Lock-file source ids are hints and cannot transfer Mix ownership | `stale source ids never adopt unowned resources`; plugin stale-source-id variable and style tests | Pending user-owned sentinel | Automated pass; live pending |
| Token modes, aliases, scopes, code syntax, and identities survive read-back | `creates variables in two passes, resolves modes and aliases, and stamps code syntax and plugin data`; token read-back/lock test | Pending native inspection | Automated pass; live pending |
| Token and component reruns reach a zero-mutation fixed point | Token pull, token push, selection pull, and component fingerprint fixed-point tests | Pending reruns | Automated pass; live pending |
| Native and round-trip loss/normalization/unsupported cases stay explicit | Four shared-manifest tests plus three fidelity-report tests; plugin consumes the same manifest | Pending controlled unsupported examples | Automated pass; live pending |
| Guided UI blocks skipped Preview or mismatched Apply actions | `guides a selection through Analyze, Preview, Apply, and Verify`; workflow preview/stale-plan tests | Pending plugin UI observation | Automated pass; live pending |
| Button, Input, and Card satisfy their committed contracts in native Figma | `selection and Button/Input/Card component cases are executable`; plugin manifest coverage; deterministic anatomy writer tests | Pending native inspection | Automated pass; live pending |

## Decision

- Result: **PENDING LIVE FIGMA GATE**
- Blocking evidence: Controlled Figma source and fresh disposable destination
  have not been created because the writable workspace choice is still pending.
- Follow-up: Select the Personal or Concepta workspace, perform read-only Phase
  0 discovery, approve the exact destination write scope, run every live gate,
  attach plan ids/report paths, and then rerun the final verification commands.
