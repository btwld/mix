# Mix Figma live release result — 2026-07-20

- Date: 2026-07-20
- Operator: Codex with user-approved Figma access
- Production source: [Concepta Design System](https://www.figma.com/design/2Bu2OAnthwwy01z4t1PzQv/Concepta-Design-System) (`2Bu2OAnthwwy01z4t1PzQv`), read-only throughout
- Disposable destination: [Mix Figma Validation — Concepta DS — 2026-07-20](https://www.figma.com/design/Eb531cQRu0gLP5in0llrS5) (`Eb531cQRu0gLP5in0llrS5`)
- Git branch: `leoafarias/figma-import-export-plan`
- Git checkpoint: `5005259a43112898ee0d6f86a49ad71ff6712f26` plus this documented dirty milestone worktree
- Plugin build: same checkpoint/worktree; `dist/code.js` rebuilt at 49.3 kB
- Bridge: localhost `127.0.0.1:8787`, validation theme/style/component/report directories, bearer authentication enabled; the session token is intentionally omitted

## Decision

- Result: **PASS for transactional synchronization and committed component-contract rendering**.
- The production Concepta file was never a write target.
- This is not a claim of automatic Concepta pixel-for-pixel component cloning.
  Component export proves that local portable contracts become usable native
  Figma component sets. Selection pull currently produces a coarse root style,
  not a complete portable component contract.
- The disposable file finishes at a zero-mutation token fixed point with the
  user-owned safety sentinel retained and the sacrificial Mix-owned variable
  removed.

## Automated preflight

| Gate | Command | Exit status | Evidence summary |
| --- | --- | --- | --- |
| Mix Figma tests | `cd packages/mix_figma && flutter test` | 0 | 94 tests passed |
| Focused lint-fix regression | `flutter test test/component_payload_test.dart test/token_sync_planner_test.dart` | 0 | 12 tests passed |
| Plugin tests | `cd packages/mix_figma_plugin && npm test` | 0 | 13 files and 37 tests passed |
| Plugin typecheck | `cd packages/mix_figma_plugin && npm run typecheck` | 0 | TypeScript reported no errors |
| Plugin production build | `cd packages/mix_figma_plugin && npm run build` | 0 | `dist/code.js` built at 49.3 kB |
| Generated artifacts | `melos run gen:build` | 0 | Every generation stage reported `SUCCESS` |
| Repository CI | `melos run ci` | 0 | Flutter and Dart package suites reported `SUCCESS` |
| Repository analysis | `melos run analyze` | 0 | Schema inventory/export, Dart analyzer, and fatal DCM checks reported `SUCCESS` and no issues |
| Patch hygiene | `git diff --check` | 0 | No whitespace errors |

The first final analysis attempt correctly failed on four lint findings. Those
findings were fixed; the focused regression passed; and the full analysis was
rerun to exit status 0. Pub repeatedly printed a stale kernel-cache diagnostic,
but all Melos commands above completed with their recorded exit status.

- Conformance manifest: `mix_figma/conformance/v1`, 8 cases: 1 variables, 1
  styles, 3 selections, and 3 components.
- Accounted variable/style source items: 13.
- Native fidelity: `exact: 8`, `normalized: 3`, `unsupported: 2`.
- Round-trip fidelity: `exact: 9`, `lossy: 1`, `unsupported: 3`.

## Discovery and approved scope

- The source sidebar was inventoried across Cover, Start, Changelog, Brand,
  Foundations, component families, patterns, and Archive. Representative work
  used the variables/styles inventory, Component/Button, Component/Text input,
  and 11 Logo pages.
- The disposable destination contained one page and was the only Figma write
  target.
- Approved destination resources: Mix Tokens, local text/effect styles, Button,
  Input, Card, one temporary Mix-owned deletion sentinel, and one deliberately
  unowned `User/Safety Sentinel` text style.
- Final native identities: Button `3:57`, Input `3:66`, Card `3:73`; lock state
  contains 100 variables, 13 styles, and the three component sets.

## Live results

All report paths below are relative to
`design/figma-validation-2026-07-20/reports/`.

| Gate | Plan id | Verify result | Fixed-point / safety evidence |
| --- | --- | --- | --- |
| Concepta token pull | `713febef5a74fb478d3a8843bfcb5459d5a4dc2ce1c08dadd1fa54329aff179c` | `verified`, remaining 0 | Light/dark themes materialized; rerun proposed zero mutations |
| Button selection pull | `7b6c8889a80d88c2c8d353b793529690844fbf87b28ad05b5d1d5b447a71a241` | `verified`, remaining 0 | `button.style.json` materialized |
| Text Input selection pull | `81da9fb04c863a93ad285c1b685408675c7b6d10e06d201a03757b0877c2dbb7` | `verifiedWithRetainedItems`, remaining 0 | Existing Button file preserved |
| Logo-section selection pull | `822bd236623ac66c5ea7c98b8d5b6495484930686e90123fad7c15afae413be5` | `verifiedWithRetainedItems`, remaining 0 | `brand-assets-logos.style.json`; rerun `+0 ~0 −0 =1`, two unrelated local style files preserved |
| Token push | `588b2469e3a8a2461e48e9a702968401c07507f87e9b370a8588edc14b0fc6db` | `verified`, remaining 0 | Initial `+116`; rerun `+0 ~0 −0 =116` |
| Button export | `6804238f1f442eb76796d1997229790ea924bb8cd6f56dba514bd9724d441ccc` | `verified`, remaining 0 | 6 variants; rerun plan `81d25a061cac…` had zero mutations |
| Input export | `c4e33813d862623b2a425ffa10649c460b37c7ee821d16b1b23a7cd60a18d2c8` | `verified`, remaining 0 | 4 variants; rerun plan `58e448808845…` had zero mutations |
| Card export | `89ec3d35505cfcce3eef4c25aafae59bca48ca2d83ed10b40be57c4b3085183c` | `verified`, remaining 0 | 2 variants; rerun plan `c2a631d7c516…` had zero mutations |
| User-owned sentinel | `6c3bc02030ba70255bd57361de6890d3cf14702b421469087c1e7532d7aa589f` | `verifiedWithRetainedItems`, remaining 0 | `unmanaged_resource_preserved`; sentinel survived every later token/component operation |
| Managed-delete opt-out | `12e0985b4f7671e52a64a91a43fad03c1d49deba844d99e2496781839ca775e1` | `verifiedWithRetainedItems`, pending deletes 1 | Checkbox off; sacrificial Mix-owned variable remained; snapshot in `evidence/managed-delete-opt-out-report.json` |
| Managed-delete opt-in | `b01928d324649e9a8faec52a1df67225094be1b6b089350a7a30384279076b61` | `verifiedWithRetainedItems`, pending deletes 0 | Checkbox explicitly on; only sacrificial Mix-owned variable disappeared; snapshot in `evidence/managed-delete-opt-in-report.json` |
| Stale-plan rejection | stale pre-sentinel token plan | HTTP `409`, no Apply/Verify report by design | Destination was changed after Analyze; old plan was rejected before mutation; fresh Analyze and plan `6c3bc…` converged |

The deterministic delete plan is the same with the opt-in checkbox off or on,
so its canonical `<planId>.json` is overwritten by the later Verify attempt.
The evidence directory preserves the actual opt-out and opt-in reports as
separate snapshots. The final canonical delete report records pending deletes
0, and the final Analyze again reports `+0 ~0 −0 =116 ·1` (the one skipped item
is the unowned safety sentinel).

## Visual evidence

| Artifact | SHA-256 | What it proves |
| --- | --- | --- |
| `evidence/concepta-text-input-source.png` | `4f9554cc92c74cfaea90aa260b5409c24c097e48bb5c3fc0e7c252765a468998` | Read-only Concepta Text Input source and its four authored states |
| `evidence/generated-input-destination.png` | `409c13215bad3b5245016aca4b9f653178c3dde70498c78d262d795fe7160a23` | The local portable Input fixture rendered as a native four-variant Figma set |
| `evidence/component-gallery.png` | `0963ecd926f177a4ee0c782c567b14f941a70d046b82e86b09e3885a190a6c60` | Button, Input, and Card are styled, non-overlapping, and usable together |

All three PNGs are 1465×768 RGB captures. The source/generated pair is an
honest semantic comparison, not a pixel-diff claim: both cover the same Input
state family, but the committed local fixture intentionally has simpler visual
language than Concepta.

## Invariant evidence matrix

| Invariant | Automated evidence | Live evidence | Result |
| --- | --- | --- | --- |
| Analyze is read-only and Apply matches Preview | deterministic sync-plan and plugin workflow tests | Source file unchanged; every mutation followed Preview | Pass |
| Plan ids and operation order are deterministic | sync-plan and sequential plugin-writer tests | Managed-delete reanalysis reproduced the same plan before the source identity changed | Pass |
| Stale plan returns `409` before mutation | `apply rejects a stale plan before either side is mutated` | Old token plan rejected after sentinel creation; fresh plan required | Pass |
| Local writes roll back on failure | local staging/rollback server tests | Not destructively induced against source | Pass |
| Figma write failure is recoverable | plugin undo/error tests | Historical failed report `a7f292…` retained; corrected mapping subsequently converged | Pass |
| Verify report precedes lock advancement | token/component report-before-lock tests | Every successful write has a report and matching final lock identity | Pass |
| Failed verification leaves lock unchanged | failed-readback/report-persistence tests | Historical failed report did not become final state | Pass |
| Deletion is opt-in and exact Mix-owned | planner ownership and exact-delete tests | Opt-out pending 1; opt-in deleted only the sacrificial Mix-owned variable | Pass |
| Unowned and remote resources are preserved | same-name/unowned/remote planner tests | `User/Safety Sentinel` survived all operations | Pass |
| Lock source ids cannot transfer ownership | stale-source-id tests | Sentinel was never adopted despite overlapping token/style inventory | Pass |
| Modes, aliases, scopes, syntax, and identities survive | variable writer/read-back tests | 2 modes, 100 final variables, 13 styles, stable lock ids | Pass with documented unsupported inputs |
| Pull/push/component reruns reach fixed point | token, selection, and component fixed-point tests | Token, logo selection, Button, Input, and Card reruns all proposed zero mutations | Pass |
| Fidelity loss stays explicit | shared manifest and fidelity-report tests | 20 ambiguous-float and 9 unsupported-variable diagnostics on source pull | Pass |
| Guided UI enforces stage order | plugin UI workflow tests | Apply/Verify stayed disabled until their prerequisite stage | Pass |
| Button/Input/Card meet committed contracts | conformance manifest and component payload tests | 6/4/2 native variants, styled and spaced in the gallery | Pass |

## Defects found and corrected during the live gate

- Duplicate diagnostics on both pull and push.
- Missing representation for removed code syntax.
- Double-wrapped letter spacing and absent drop-shadow blend mode.
- False numeric drift and native default fields nested inside lists.
- Verification that did not initially account for operation diagnostics and
  preserved unowned resources.
- Ambiguous retained-item status copy.
- Component payloads that omitted portable layout/paint/type styling, used
  non-hugging roots, and placed new sets on top of one another.

Each code correction has focused regression coverage. After the last fix, the
full package tests, plugin tests/build, generation, repository CI, analysis,
and patch-hygiene gates were rerun.

## Known fidelity limits

- Concepta STRING and BOOLEAN variables are unsupported by current primitive
  Mix theme groups; unsupported items stay diagnostic rather than disappearing.
- Unscoped FLOAT variables are ambiguous unless scope or configuration maps
  them. The live source pull reports 20 such items and 9 unsupported variable
  types.
- Pulling a component-set, logo section, or documentation frame selection
  currently collapses the selected root to a coarse Box/Flex style document;
  it does not synthesize a full reusable component or vector-asset contract.
- The local Button/Input/Card fixtures validate the portable contract and
  native Figma writer. They do not automatically inherit Concepta's visual
  design, naming, or package taxonomy.
