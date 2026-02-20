# mix_schema v0.1 Freeze

Date: 2026-02-06
Status: Frozen execution contract for Track B foundation work.

## 1) What we are trying to accomplish

Main goal:
- Ship a **safe, deterministic, debuggable runtime UI layer** for Mix by implementing `mix_schema` as:
  - adapter(s) from wire schema -> canonical AST,
  - validator + trust enforcement,
  - renderer on top of Mix primitives.

In one line:
- **External protocols in, Mix canonical AST in the middle, Mix renderer out.**

## 2) Is this for us to define?

Yes.

`mix_schema` is a new package and internal contract we define.
We intentionally **do not** make any external protocol (A2UI or others) our internal source of truth.

What is external:
- wire payloads, transport envelopes, version churn.

What is ours:
- canonical AST,
- trust model enforcement,
- validation behavior,
- renderer behavior,
- diagnostics/tooling contracts.

## 3) Package boundary (frozen)

- `packages/mix`: core styling/runtime primitives (unchanged in scope)
- `packages/mix_schema`: schema runtime package (new)
  - adapters
  - canonical AST
  - validation + trust
  - rendering + registry
  - diagnostics

Non-goal for v0.1:
- agent runtime orchestration
- network/model integrations
- policy engine beyond trust/capability gating

## 4) v0.1 decisions (frozen)

From the review checklist:
- Schema direction: `adapt`
- Canonical AST: `yes`
- Token format: explicit object (`{type,name}`) as primary
- Token naming: `type.<name>`
- Variant composition: simple mapping only
- Transform model: closed registry
- Patch/diff: JSON Patch (RFC 6902)
- Streaming: phase 2
- Validation: both meta-schema + runtime API
- Structural model: explicit `repeat` node (no `children` overloading)
- Animation key: `durationMs`

Also frozen:
- Perf/a11y contracts are tightened vs previous draft and required in roadmap.

## 5) Canonical AST contract (v0.1)

### 5.1 Node shape

Every node has:
- `nodeId` (stable id)
- `type`
- `path` (deterministic)
- `trust`
- optional `semantics`

Supported node categories in v0.1:
- primitives: `box`, `text`, `icon`, `image`
- layout: `flex`, `stack`, `scrollable`, `wrap` (minimum subset may start smaller)
- interactive: `pressable`, `input` (input can be staged behind phase gate)
- control: `repeat`

### 5.2 Structural rules

- wrapper nodes: `child`
- layout nodes: `children`
- repeat/template nodes: explicit `repeat` node
- reject payloads that mix invalid structure combinations.

### 5.3 Value model

- direct values
- typed token refs
- limited responsive/adaptive constructs
- no executable expressions

### 5.4 Semantics model (minimum)

- base: role, label, hint, value, enabled
- interactive: selected, checked, expanded
- ordering/relations: focusOrder, labelledBy, describedBy
- live regions: mode, atomic, relevant, busy

## 6) Adapter contract (v0.1)

Initial adapters:
- `a2ui_v0_9_draft_latest` (primary latest-target adapter)
- `a2ui_v0_8_stable` (compat/stable fallback adapter)

Version targeting policy (frozen for planning):
- As of 2026-02-06, treat A2UI `v0.9` draft as the latest upstream target.
- Keep `v0.8` support for stable compatibility while upstream finalizes `v1.0`.

Adapter responsibilities:
- parse wire format
- normalize shorthand values (e.g., token string -> explicit token object)
- map protocol-specific event/update shapes into canonical AST/update model
- emit structured diagnostics on lossy/unsupported mappings

Adapter non-responsibilities:
- rendering
- trust policy decisions
- token resolution

## 7) Runtime contracts

### 7.1 Validation

Two layers:
1. authoring/meta-schema validation (shape-level)
2. runtime validation API (cross-field/catalog/trust-aware)

Output contract:
- machine-readable diagnostics with severity, code, nodeId/path.

### 7.2 Trust enforcement

Trust levels gate:
- allowed components
- allowed actions/events
- transforms
- animation complexity
- depth/node limits

### 7.3 Updates

- full replace supported in phase 1
- JSON Patch in phase 2 (`add/remove/replace/test`)
- stable node keys preferred for robust patch targeting

### 7.4 Streaming

Phase 2 requirements:
- stable nodeId
- partial-mode rendering
- non-fatal subtree placeholders
- focus/announcement stability guarantees

## 8) Public API sketch (v0.1)

```dart
abstract class WireAdapter {
  String get id; // e.g. a2ui_v0_9_draft_latest
  AdaptResult adapt(Object wirePayload, AdaptContext context);
}

final class AdaptResult {
  final UiSchemaRoot? root;
  final List<SchemaDiagnostic> diagnostics;
}

abstract class SchemaValidator {
  ValidationResult validate(UiSchemaRoot root, ValidationContext context);
}

abstract class SchemaRenderer {
  Widget render(UiSchemaRoot root, RenderContext context);
}

final class SchemaEngine {
  AdaptResult adapt(Object wirePayload, {required String adapterId});
  ValidationResult validate(UiSchemaRoot root);
  Widget build(UiSchemaRoot root);
}
```

## 9) Suggested package layout

```text
packages/mix_schema/
  lib/
    mix_schema.dart
    src/
      adapters/
        a2ui_v0_9_draft_adapter.dart
        a2ui_v0_8_stable_adapter.dart
      ast/
        schema_node.dart
        schema_values.dart
        schema_semantics.dart
      validate/
        validator.dart
        diagnostics.dart
      render/
        schema_widget.dart
        schema_registry.dart
        handlers/
          box_handler.dart
          text_handler.dart
          flex_handler.dart
          stack_handler.dart
          icon_handler.dart
      trust/
        schema_trust.dart
        capability_matrix.dart
      updates/
        patch_apply.dart
```

## 10) Implementation order (do next)

### Step 1: Freeze contracts in code (no rendering yet)
- AST classes
- diagnostics model
- adapter + validator interfaces
- trust/capability model enums and limits

### Step 2: Basic adaptation and validation
- implement `a2ui_v0_9_draft_latest` adapter
- implement structural/type validator
- implement diagnostic codes and test fixtures
- add compatibility fixtures for `a2ui_v0_8_stable`

### Step 3: Basic rendering
- registry + handlers for `box`, `text`, `flex`, `stack`, `icon`
- `SchemaWidget` with fallback/onError behavior

### Step 4: Phase-2 features
- JSON Patch apply
- repeat node rendering
- streaming partial mode
- semantics/focus/live-region enforcement

## 11) Definition of done for v0.1 foundation

Must be true:
- canonical AST is documented and covered by tests
- `a2ui_v0_9_draft_latest` adapter round-trips golden fixtures
- `a2ui_v0_8_stable` compatibility fixtures pass
- validator returns structured diagnostics (not string-only errors)
- renderer produces stable output for core handlers
- trust limits are enforced and tested
- docs match implementation contracts

## 12) Immediate next part (practical)

Planning gate (no code yet):
1. Approve adapter/version policy (`a2ui_v0_9_draft_latest` primary, `a2ui_v0_8_stable` compatibility).
2. Approve fixture matrix and acceptance criteria for both adapters.
3. Approve v0.1 handler scope and owners.

After gate approval, start with these three concrete tasks:
1. Create `packages/mix_schema` with AST + diagnostics + adapter interfaces.
2. Add first fixture pack (`valid`, `invalid`, `lossy-adapt`) for `a2ui_v0_9_draft_latest`, plus compat fixtures for `a2ui_v0_8_stable`.
3. Implement core validator + 5 base handlers (`box`, `text`, `flex`, `stack`, `icon`).

If these are done, we move from planning to executable foundation.
