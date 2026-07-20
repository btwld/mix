# Controlled Figma live release gate

Run this gate after committed fixtures and automated tests pass. It requires
two Figma Design files:

- **Source**: a controlled, Figma-authored file containing representative
  variables, local styles, selections, and component sets.
- **Destination**: a newly created disposable Design file. Never use a shared
  production library as the destination for this gate.

Record both URLs, file keys, date, operator, plugin build commit, and bridge
commit in a copy of [live-release-result.template.md](live-release-result.template.md).
Do not mutate either file during discovery.

Start a fresh bridge process for the gate and paste its printed session token
into the plugin before discovery. Record neither the token nor other secrets in
the result file.

## Phase 0 — discovery

1. Confirm the authenticated Figma account and permissions.
2. Enumerate every page in both files.
3. Inspect local variable collections, variables, styles, and component sets.
4. List subscribed/available libraries and search for Button, Input, Card,
   color, spacing, and typography assets.
5. Map existing names and Mix identities to the code fixtures. Identify all
   same-named but unowned resources.
6. Freeze scope: tokens, one Button selection, one Input selection, Button,
   Input, and Card component contracts. Obtain explicit approval before any
   destination write.

## Source-file pull gate

The source should include at minimum:

- a color collection with two modes, a primitive, and an alias;
- a scoped FLOAT spacing or radius variable;
- one text style, one drop-shadow style, and one solid paint style;
- one known unsupported example (inner shadow or gradient) to prove honest
  diagnostics;
- representative Button and Input selections.

For token pull and each selection import:

1. Select the workflow and click Analyze.
2. Save the plan id and operation summary.
3. Confirm no file changed during Analyze.
4. Apply with deletion disabled.
5. Verify and save the report path.
6. Analyze again. Expect no create/update/rename operations for the same
   source. Known unsupported inputs must remain explicit diagnostics.

## Disposable-destination push gate

1. Confirm the destination is new or otherwise disposable.
2. Run token push with deletion disabled; Verify must return `verified`.
3. Export `button`, `input`, and `card` individually. Verify each operation.
4. Analyze each workflow again. Expect only `unchanged` or intentional `skip`
   operations.
5. Inspect native Figma results: variable modes/aliases/scopes, local styles,
   component-set names, variant coordinates, anatomy, auto-layout, text, and
   identity stamps.

## Safety probes

Perform these only in the disposable destination:

1. Create a user-owned sentinel resource with the same name as a Mix token or
   style but no Mix identity. Analyze must preserve it and Apply must not
   update or delete it.
2. Add a sacrificial Mix-owned resource that is absent from code. Analyze must
   propose an exact destructive operation.
3. Apply once with deletion disabled. Verify must return
   `verifiedWithRetainedItems`, and the sacrificial resource must remain.
4. Analyze again, explicitly enable deletion, apply, and verify. Only the
   sacrificial Mix-owned resource may disappear; the user-owned sentinel must
   remain.
5. Analyze a change, modify the destination before Apply, then apply the old
   plan. Expect HTTP `409`, no write, no lock change, and a requirement to
   analyze again.

## Pass criteria

- Every planned operation is attributable to a source and exact target.
- Analyze makes no changes.
- All approved writes survive fresh read-back with zero remaining mutations.
- A failed verification leaves `mix_figma.lock.json` unchanged.
- Deletion is opt-in, exact, local, and Mix-owned.
- Same-named unowned and remote resources are preserved.
- Button, Input, and Card are visually usable and structurally faithful to the
  committed contracts.
- Known normalization, loss, and unsupported behavior matches the conformance
  report rather than being silently dropped.
- A report exists for every Verify attempt and the completed result record is
  attached to the release evidence.
