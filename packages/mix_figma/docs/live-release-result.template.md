# Mix Figma live release result

- Date:
- Operator:
- Source Figma URL/file key:
- Disposable destination URL/file key:
- Git commit:
- Plugin build commit:
- Bridge command/config:

## Automated preflight

| Gate | Command | Exit status | Evidence summary |
| --- | --- | --- | --- |
| Focused Dart bridge/sync tests | `cd packages/mix_figma && flutter test` | | |
| Plugin tests | `cd packages/mix_figma_plugin && npm test` | | |
| Plugin typecheck | `cd packages/mix_figma_plugin && npm run typecheck` | | |
| Plugin production build | `cd packages/mix_figma_plugin && npm run build` | | |
| Generated artifacts | `melos run gen:build` | | |
| Repository CI | `melos run ci` | | |
| Repository analysis | `melos run analyze` | | |
| Patch hygiene | `git diff --check` | | |

- Conformance manifest schema/case count:
- Native-fidelity totals:
- Round-trip-fidelity totals:
- Generated/unrelated diff audit:

## Discovery

- Pages inspected:
- Libraries searched:
- Existing identity/name conflicts:
- Approved scope:

## Results

| Gate | Plan id | Apply result | Verify status | Report path | Notes |
| --- | --- | --- | --- | --- | --- |
| Token pull | | | | | |
| Button selection pull | | | | | |
| Input selection pull | | | | | |
| Token push | | | | | |
| Button export | | | | | |
| Input export | | | | | |
| Card export | | | | | |
| Managed-delete opt-out | | | | | |
| Managed-delete opt-in | | | | | |
| Stale-plan rejection | | | | | |

## Evidence

- Fixed-point rerun summaries:
- User-owned sentinel retained:
- Sacrificial managed resource behavior:
- Native visual/structural inspection:
- Known fidelity diagnostics:
- Lock before/after failed verification:

## Invariant evidence matrix

Record an exact test name, report path, plan id, screenshot/node id, or other
reproducible artifact for every row. A green aggregate command alone is not
enough evidence for a row unless the named test was confirmed in its output.

| Invariant | Automated evidence | Live evidence | Result |
| --- | --- | --- | --- |
| Analyze and Preview are read-only; Apply matches the previewed plan | | | |
| Plan ids and operation order are deterministic | | | |
| A stale plan returns `409` without changing Figma or the lock | | | |
| Local writes are staged and rolled back on apply failure | | | |
| Figma write failure is recoverable through undo/error handling | | | |
| A Verify report is persisted before the lock advances | | | |
| Failed read-back or report persistence leaves the lock unchanged | | | |
| Deletion is disabled by default and targets only exact Mix-owned resources | | | |
| Same-named unowned and remote resources are preserved | | | |
| Token modes, aliases, scopes, code syntax, and identities survive read-back | | | |
| Token and component reruns reach a zero-mutation fixed point | | | |
| Native and round-trip loss/normalization/unsupported cases stay explicit | | | |
| Guided UI blocks skipped Preview or mismatched Apply actions | | | |
| Button, Input, and Card satisfy their committed contracts in native Figma | | | |

## Decision

- Result: PASS / FAIL
- Blocking findings:
- Follow-up issues:
