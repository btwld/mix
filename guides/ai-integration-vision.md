# Mix AI Integration Vision

## Purpose

This document defines Mix's vision and roadmap for enabling **AI-driven user interfaces**. The goal is to extend Mix beyond traditional developer-authored styling into a framework that supports:

- **Intent-based UI generation**: AI agents creating interfaces from user intent, not explicit code
- **Dynamic screen generation**: Complete screens/views materialized at runtime from structured descriptions
- **Ephemeral interfaces**: UIs that exist temporarily, adapt, and are discarded when no longer needed
- **Agent-to-UI communication**: Bidirectional flow between AI systems and rendered interfaces

This is not about replacing developer-crafted UIs, but enabling a new class of applications where AI participates in UI creation and evolution.

## Related Docs

- `guides/ai-roadmap.md` — unified view of Mix’s AI strategy and how the tracks fit together.
- `guides/ai-agent-ui-roadmap.md` — developer-authored agent UI patterns (streaming, tools, approvals, provenance).
- `guides/ai-integration-review-checklist.md` — review worksheet for collecting decisions/feedback on this document.

This document focuses on **schema-generated / ephemeral UIs** (Track B). The agent UI roadmap covers consistent, trustworthy affordances that both hand-authored and generated UIs should reuse.

## Notes from Feedback Review (Implementation Readiness)

This vision needs to be both aspirational and implementable against **Mix 2.0 as it exists today**. Key items raised in feedback that should be first-class in the vision:

- **Standards alignment:** before finalizing a bespoke schema, evaluate whether an emerging/open “UI schema protocol” should be adopted, adapted, or extended. If we diverge, we should have a compatibility story.
- **Terminology clarity:** avoid name collisions with Mix core types (notably `Style<S>`). Prefer schema names like `MixSchema` / `UiSchema`, and treat the schema “style” payload as *style properties* (not a `Style<S>` instance).
- **Reuse Mix’s resolution pipeline:** schema handlers should produce Mix styles/specs and let existing resolution/rendering machinery do the work, rather than bypassing it.
- **Typed token resolution:** schemas will reference tokens as strings; Mix resolves tokens as typed `MixToken<T>`. A runtime token registry is required.
- **Variant mapping:** schema variant keys (e.g., `onHovered`) must map deterministically to Mix’s `Variant` types (`ContextVariant`, `WidgetStateVariant`, `NamedVariant`).
- **Safe data binding transforms:** any `transform` mechanism must be a closed, registered, trust-gated set (no arbitrary code execution).
- **Tooling/testing/perf:** schema inspector, token/variant trace, fuzz tests for validators, and explicit performance budgets are needed for production readiness.

## Feedback Alignment Checklist (What’s Done vs Open)

This section is a “reviewer-facing” checklist so we can gather complete feedback and avoid repeating the same concerns across reviews.

### Addressed (in this document)
- Interoperability decision point is explicit (`Part 3.0`).
- Schema naming collision with `Style<S>` is called out (`Part 2.1 Naming note`).
- Typed token resolution strategy is described (`Part 3.4 Typed token resolution`).
- Variant mapping requirements are documented (`Part 3.5 Variant mapping`).
- Safe, closed transform registry is required (`Part 3.7 Safe transforms`).
- Handler guidance recommends using Mix’s `StyleBuilder` pipeline (`Part 4.2 Reuse Mix’s rendering pipeline`).
- Roadmap includes these missing foundations (updated Phase 1/2/4 deliverables).

### Still Open (explicit decisions needed)
- **External protocol choice:** adopt/adapt/extend vs Mix-native + adapters (decide before Phase 1 implementation).
- **Canonical internal representation:** should `mix_schema` parse any incoming schema into a single internal AST to support multiple formats?
- **Schema value model:** should “adaptive/responsive” be represented as dedicated value types or expressed purely via variants?
- **Accessibility model:** what is the minimum semantics contract per node (role/label/hint/live-region/focus order)?
- **Debug tooling scope:** what is the minimal “must-have” inspector for v0.1 (tree view, node path, token/variant trace, errors)?
- **Performance budgets:** what are realistic targets per device class (mobile/web/desktop) and per schema size?

---

## Part 1: The Problem Space

### Traditional UI Development
- Developers write code → Compile → Ship → Users interact
- All UI possibilities must be anticipated at development time
- Changes require code updates and redeployment

### AI-Native UI Development
- User expresses intent → AI generates UI → User interacts → AI adapts
- UI possibilities are unbounded, generated on-demand
- Changes happen in real-time without code modifications

### Why This Matters for Mix

Mix's architecture (Specs, Styles, Tokens, Variants) already separates **what** to render from **how** to style it. This separation creates a natural extension point for AI-generated content:

```
Traditional:  Developer → Style → Spec → Widget
AI-Native:    Agent → Schema → Style → Spec → Widget
```

The addition of a **Schema layer** enables AI agents to describe UIs in a structured format that Mix can interpret and render.

---

## Part 2: Core Concepts

### 2.1 StyleSchema

A runtime-interpretable format describing UI structure and styling. AI agents generate StyleSchema; Mix renders it.

#### Naming note

The term **StyleSchema** is provisional. To avoid confusion with Mix’s `Style<S>` type, we should consider renaming this concept to **MixSchema** or **UiSchema**. Regardless of naming, the schema’s `"style"` field represents *style properties* that can be translated into Mix stylers/styles; it is not a serialized `Style<S>` object.

**Key Properties**:
- **Declarative**: Describes what to show, not how to build it
- **Type-validated**: Runtime validation ensures correctness
- **Token-aware**: References design system tokens for consistency
- **Variant-capable**: Supports responsive/state-based styling
- **Composable**: Schemas can reference and compose other schemas

### 2.2 Ephemeral UI

Interfaces generated in response to intent that:
- Exist temporarily during a task or session
- May never be persisted as code
- Can be modified or discarded freely
- Serve immediate needs, not long-term reuse

**Examples**:
- "Show me today's metrics" → Dashboard appears, session ends, gone
- "Help me fill out this form" → Guided form wizard, submission completes, dismissed
- "Compare these two options" → Comparison view generated, decision made, removed

### 2.3 Intent-Based Generation

UI creation driven by user intent rather than explicit specifications:

```
Intent: "I need to see my project status"
   ↓
Agent interprets: User wants project overview, likely KPIs, timeline, blockers
   ↓
Schema generated: Dashboard with status cards, progress indicators, action items
   ↓
Mix renders: Styled, interactive UI using design system tokens
```

The AI handles the translation from fuzzy intent to concrete structure; Mix handles the rendering with consistent styling.

---

## Part 2.4: Relationship to Mix 2.0 APIs (Implementation Reality Check)

This vision should be implemented in a way that keeps `packages/mix` small and stable.

Recommended approach:
- Treat schema rendering as an **add-on package** (`mix_schema` / `mix_runtime_ui`) that depends on Mix 2.0.
- Use Mix 2.0 primitives (tokens, variants, stylers/specs) where possible.
- For components not represented by Mix specs, prefer a registry that can build Flutter widgets directly and apply Mix styling where it is compatible (rather than expanding Mix core to cover every widget).

Key complexity to plan for early:
- **Data binding** and transforms must be safe (data-only), deterministic, and debuggable.
- **Accessibility** in generated trees needs first-class handling (semantics, focus order, announcements).
- **Schema versioning** must be explicit and migration-friendly.

### 2.5 Recommended Architecture: Adapter → Canonical AST → Renderer

To align with feedback and reduce lock-in, implement schema rendering as a layered system:

1) **Adapter(s)**: parse an incoming “wire schema” (whatever format we choose to accept) into…
2) **Canonical internal AST**: a typed representation owned by Mix (`mix_schema`), optimized for validation and rendering.
3) **Renderer**: converts the AST into Mix `Style<S>` + `StyleBuilder` (or direct widgets where necessary).

Benefits:
- Supports multiple schema formats later (import/export) without rewriting rendering logic.
- Keeps validation rules and security/trust boundaries centralized.
- Enables strong debugging: every runtime node can carry a stable `nodeId` and `path`.

Non-goal:
- Supporting “arbitrary widget code” in the schema. The AST is still *data*, not code.

## Part 3: StyleSchema Specification

### 3.0 Interoperability & External Schemas (Decision Needed)

Before locking a schema format, decide whether we want:
- **Adopt** an existing/open UI schema protocol (and map it onto Mix)
- **Adapt/extend** an existing schema with Mix-specific styling extensions (tokens, variants, animations)
- **Define** a Mix-native schema and optionally support import/export adapters later

The decision criteria should include:
- ecosystem interoperability (agents/tools can produce the schema)
- validation and safety model compatibility
- ability to express Mix concepts (tokens, variants, animation, trust boundaries)
- long-term maintenance and versioning costs

#### Compatibility stance (recommended)

Even if we decide to define a Mix-native schema, we should plan for:
- **Adapters in**: accept an external/wire schema and map into the canonical AST.
- **Adapters out**: export canonical AST into an external schema (where possible) for interoperability and debugging.

This avoids “schema fork” concerns while preserving Mix’s ability to represent Mix-specific styling concepts.

### 3.0.1 Schema Versioning and Migration Policy (Missing Detail)

Schemas must be versioned and migration-friendly.

Recommended approach:
- `$schema` identifies a major version, e.g. `mix://schema/v1`.
- Major version bumps are breaking; old versions remain supported for a defined window.
- Provide a migrator pipeline:
  - `v1 → v2` migrator returns either a migrated schema or structured errors.
  - Migration is deterministic and produces the canonical AST.

Policy questions to decide (and document in `mix_schema`):
- How many major versions are supported simultaneously?
- What is the deprecation window?
- Are migrations automatic by default, or opt-in?

### 3.1 Schema Structure

```json
{
  "$schema": "mix://schema/v1",
  "$id": "unique-identifier",

  "type": "box",
  "style": {
    "padding": {"all": 16},
    "color": {"token": "color.surface.primary"},
    "borderRadius": {"all": 12},
    "elevation": 4
  },
  "variants": {
    "onHovered": {"elevation": 8, "scale": 1.02},
    "onDark": {"color": {"token": "color.surface.primaryDark"}}
  },
  "animation": {
    "type": "curve",
    "durationMs": 200,
    "curve": "easeOut"
  },
  "children": [...]
}
```

### 3.1.1 Child vs Children (Structural Rule)

Schemas should be explicit about whether a node accepts a single `child` or multiple `children`.

Recommended default:
- Wrapper-ish components (`pressable`, `scrollable`, etc.): use `child` (single object).
- Layout components (`flex`, `stack`, `grid`, `wrap`): use `children` (array).
- If a type supports both, it must define a precedence rule (recommended: reject schemas that provide both).

This keeps rendering deterministic and reduces “LLM guessed structure” errors.

### 3.2 Component Types

```
Primitives:     box, text, icon, image
Layout:         flex, stack, grid, wrap, scrollable
Interactive:    pressable, input, select, slider
Composite:      card, button, chip, badge (registered patterns)
Custom:         Developer-defined via ComponentRegistry
```

### 3.3 Style Properties

Map directly to Mix's existing style system:

| Schema Property | Mix Equivalent | Notes |
|-----------------|----------------|-------|
| `padding`, `margin` | EdgeInsets utilities | Supports `all`, `x`, `y`, `top`, etc. |
| `color` | `color(...)` on decoration mixin | Token refs or direct values |
| `borderRadius` | BorderRadius utilities | `all`, `topLeft`, etc. |
| `elevation` | `elevation(ElevationShadow)` | Requires mapping to `ElevationShadow` |
| `opacity`, `scale` | Numeric properties | Direct values |
| `spacing` | `spacing(...)` on flex styles | Replaces deprecated `gap` |
| `direction` | `direction(Axis)` on flex styles | Use `Axis.horizontal`/`Axis.vertical` |
| `textStyle` | Text styling | fontSize, fontWeight, color, etc. |
| `flex`, `alignment` | Layout properties | Standard Flutter semantics |

### 3.4 Value Resolution

```json
// Design token reference
{"token": "color.primary"}

// Design token reference with explicit typing (recommended for validation)
{"token": {"name": "primary", "type": "color"}}

// Direct value
{"value": "#FF5733"}

// Context-adaptive value
{"adaptive": {"light": "#000000", "dark": "#FFFFFF"}}

// Responsive value
{"responsive": {"mobile": 8, "tablet": 16, "desktop": 24}}
```

#### Typed token resolution (required)

Mix tokens are typed (`MixToken<T>`), but schemas reference tokens as strings. This requires a runtime mechanism to map a schema token reference to the correct typed token instance.

Two viable approaches:

1) **Type-in-name convention** (simple for LLMs): `color.<name>`, `space.<name>`, `radius.<name>`, `textStyle.<name>`, `duration.<name>`, `breakpoint.<name>`.
2) **Explicit `{name,type}` token object** (best for validation): `{"token":{"name":"primary","type":"color"}}`.

Where `<name>` may contain additional dots for namespacing, e.g. `color.surface.primary` or `color.text.secondary`.

At runtime, resolution should construct the correct token type by name so it matches the keys stored in `MixScope`:

```dart
sealed class SchemaTokenType {
  static const color = 'color';
  static const space = 'space';
  static const radius = 'radius';
  static const double = 'double';
  static const textStyle = 'textStyle';
  static const borderSide = 'borderSide';
  static const fontWeight = 'fontWeight';
  static const duration = 'duration';
  static const shadow = 'shadow';
  static const boxShadow = 'boxShadow';
  static const breakpoint = 'breakpoint';
}

MixToken<Object> tokenFromRef(String type, String name) {
  return switch (type) {
    'color' => ColorToken(name),
    'space' => SpaceToken(name),
    'radius' => RadiusToken(name),
    'double' => DoubleToken(name),
    'textStyle' => TextStyleToken(name),
    'borderSide' => BorderSideToken(name),
    'fontWeight' => FontWeightToken(name),
    'duration' => DurationToken(name),
    'shadow' => ShadowToken(name),
    'boxShadow' => BoxShadowToken(name),
    'breakpoint' => BreakpointToken(name),
    _ => throw UnsupportedError('Unknown token type: $type'),
  } as MixToken<Object>;
}
```

This should live behind a `TokenRegistry`/`SchemaTokenResolver` abstraction so apps can:
- override naming conventions
- alias old token names
- restrict which tokens are permitted by trust level

Minimal interface sketch:

```dart
abstract class SchemaTokenResolver {
  /// Returns a typed token instance for the given reference, or null if unknown.
  MixToken<Object>? tokenFor({required String type, required String name});

  /// Whether this token reference is permitted under the current trust level.
  bool isAllowed({
    required String type,
    required String name,
    required SchemaTrust trust,
  });
}
```

### 3.5 Variants

```json
{
  "variants": {
    // Widget state variants
    "onHovered": {"scale": 1.05},
    "onPressed": {"opacity": 0.8},
    "onFocused": {"borderColor": {"token": "color.focus.ring"}},
    "onDisabled": {"opacity": 0.5},

    // Context variants
    "onDark": {"color": {"token": "color.text.onDark"}},
    "onMobile": {"padding": {"all": 8}},
    "onLandscape": {"direction": "horizontal"},

    // Named variants (applied explicitly)
    "named:elevated": {"elevation": 8},
    "named:compact": {"padding": {"all": 4}}
  }
}
```

#### Variant mapping (required)

Schema variant keys must map deterministically to Mix variants:

- `onHovered` → `ContextVariant.widgetState(WidgetState.hovered)`
- `onPressed` → `ContextVariant.widgetState(WidgetState.pressed)`
- `onFocused` → `ContextVariant.widgetState(WidgetState.focused)`
- `onDisabled` → `ContextVariant.widgetState(WidgetState.disabled)`
- `onSelected` → `ContextVariant.widgetState(WidgetState.selected)` (if supported)
- `onDark` / `onLight` → `ContextVariant.brightness(Brightness.dark/light)`
- `onMobile` / `onTablet` / `onDesktop` → `ContextVariant.mobile/tablet/desktop()`
- `onPortrait` / `onLandscape` → `ContextVariant.orientation(...)`
- `onLtr` / `onRtl` → `ContextVariant.directionality(...)`
- `named:<key>` → `NamedVariant(<key>)` applied via `namedVariants`

If the schema supports negation or composition, it should reuse existing Mix semantics:
- `onNot(X)` → `ContextVariant.not(X)`
- complex compositions should be expressed as schema templates/registry handlers rather than an unbounded boolean expression language in JSON.

#### Unknown variant keys (default behavior)

If a schema includes an unknown variant key:
- If it matches `named:<key>`, treat it as a named variant override (valid).
- Otherwise, default behavior should be **ignore with warning** (graceful degradation), not hard failure.

Rationale:
- LLMs can hallucinate variant keys; warnings + inspector output are usually better than “no UI renders”.
- Trust boundaries still apply: unknown keys don’t unlock capabilities, they simply don’t apply.

The host app may tighten this (e.g., fail validation for unknown keys) via configuration.

### 3.6 Actions & Events

```json
{
  "type": "pressable",
  "onTap": {
    "action": "navigate",
    "target": "/details"
  },
  "child": {...}
}

{
  "type": "pressable",
  "onTap": {
    "action": "emit",
    "event": "item.selected",
    "payload": {"id": "{{item.id}}"}
  },
  "child": {...}
}

{
  "type": "pressable",
  "onTap": {
    "action": "agent",
    "intent": "show-details",
    "context": {"itemId": "{{item.id}}"}
  },
  "child": {...}
}
```

### 3.6.1 Accessibility & Semantics (Schema Shape)

Generated UIs must be accessible. Schemas should be able to express a minimum semantics contract per node.

Illustrative schema:

```json
{
  "type": "pressable",
  "semantics": {
    "role": "button",
    "label": "Submit form",
    "hint": "Activates the submission",
    "enabled": true,
    "liveRegion": "polite"
  },
  "child": { "type": "text", "content": "Submit" }
}
```

Renderer mapping guidance:
- `role/label/hint/value/enabled` map to Flutter `Semantics` properties.
- `liveRegion` is used for streaming/progressive updates (must be rate-limited to avoid spam).

### 3.7 Data Binding

```json
{
  "type": "text",
  "content": {"bind": "user.name"},
  "style": {
    "color": {"bind": "user.status", "transform": "statusToColor"}
  }
}

{
  "type": "flex",
  "children": {
    "repeat": "items",
    "as": "item",
    "template": {
      "type": "box",
      "child": {
        "type": "text",
        "content": {"bind": "item.title"}
      }
    }
  }
}
```

#### Safe transforms (required)

Any `transform` concept must be **data-only and deterministic**:
- No arbitrary code execution.
- No user-supplied expressions.
- Only a closed set of transforms registered by the host application.

Recommended shape:
- `transform` is a string key resolved through a `SchemaTransformRegistry`.
- The registry is scoped by trust level (e.g., `SchemaTrust.minimal` allows no transforms).
- Transforms must be pure functions with bounded runtime.

Example:

```dart
typedef SchemaTransform = Object? Function(Object? input, SchemaContext ctx);

final class SchemaTransformRegistry {
  final Map<String, SchemaTransform> transforms;
  const SchemaTransformRegistry(this.transforms);
}

// Example key: "color.fromStatus"
```

### 3.7.1 Built-in Transform Set (Recommended Starter)

To prevent every host app from inventing ad-hoc transforms, define a small “starter set” of commonly useful transforms.

Examples (illustrative keys):
- `text.uppercase` / `text.lowercase` / `text.titlecase`
- `bool.not`
- `list.length`
- `format.date` (locale-aware, host-provided)
- `format.number` (locale-aware, host-provided)

These should be:
- pure/deterministic
- bounded runtime
- trust-gated (e.g., `minimal` may allow none)

### 3.8 Animations: Spec and Mapping (Missing Detail)

Schemas need a deterministic mapping from an animation description to Mix animation configuration.

Example schema:

```json
{
  "animation": {
    "type": "curve",
    "durationMs": 200,
    "curve": "easeOut"
  }
}
```

Mapping guidance (illustrative, exact API may differ):
- `type: "curve"` → `AnimationConfig.curve(duration: ..., curve: ...)`
- `type: "spring"` → `AnimationConfig.spring(...)`
- `type: "keyframes"` → `AnimationConfig.keyframes(...)`

Important constraints:
- Curves must come from a closed allowlist (no arbitrary code).
- Durations must be clamped to safe ranges by trust level (avoid pathological animations).
- Animations must be optional; if omitted, behavior should be deterministic (no implicit animation surprises).

Schema convention:
- Use `durationMs` (not `duration`) for explicitness and easier validation.

---

## Part 4: Component Registry

### 4.1 Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    SchemaRegistry                           │
├────────────────────────────────────────────────────────────┤
│  Built-in Handlers          Custom Handlers                 │
│  ┌──────────────────┐      ┌──────────────────┐           │
│  │ BoxHandler       │      │ DataTableHandler │           │
│  │ TextHandler      │      │ ChartHandler     │           │
│  │ FlexHandler      │      │ FormHandler      │           │
│  │ StackHandler     │      │ CustomCardHandler│           │
│  │ PressableHandler │      │ ...              │           │
│  └──────────────────┘      └──────────────────┘           │
└────────────────────────────────────────────────────────────┘
```

### 4.2 Handler Interface

```dart
abstract class SchemaHandler<S extends Spec<S>> {
  /// Component type this handler manages
  String get type;

  /// Validate schema structure
  ValidationResult validate(Map<String, dynamic> schema);

  /// Convert schema to Mix Style
  Style<S> toStyle(Map<String, dynamic> schema, SchemaContext context);

  /// Build widget from schema
  Widget build(Map<String, dynamic> schema, SchemaContext context);

  /// Property mappings for this component
  Map<String, PropertyMapper> get propertyMappers;
}
```

#### Reuse Mix’s rendering pipeline (recommended)

To stay aligned with Mix 2.0, handlers should avoid building “raw” widgets that bypass Mix’s variant/modifier/animation behaviors.

Recommended default:
- `toStyle(...)` converts schema style properties → a Mix `Style<S>` (typically via stylers or `Style.create`-style constructors).
- `build(...)` uses Mix’s `StyleBuilder<S>` to resolve/apply variants, modifiers, animation, and (optionally) inheritance.

Pseudo-shape:

```dart
Widget build(Map<String, dynamic> schema, SchemaContext context) {
  final style = toStyle(schema, context);
  return StyleBuilder<S>(
    style: style,
    builder: (context, spec) => /* spec-aware widget build */,
  );
}
```

If a component cannot be expressed as a Mix spec today, the handler may build a Flutter widget directly, but should still:
- apply tokens consistently
- respect trust boundaries
- attach accessibility semantics
- provide debug hooks (node path, token/variant trace)

### 4.3 Registration

```dart
// Register built-in handlers
SchemaRegistry.registerBuiltins();

// Register custom handlers
SchemaRegistry.register('data-table', DataTableHandler());
SchemaRegistry.register('chart', ChartHandler());
SchemaRegistry.register('my-card', MyCardHandler());

// Check if handler exists
SchemaRegistry.hasHandler('box'); // true
SchemaRegistry.hasHandler('unknown'); // false
```

### 4.4 Schema Context

```dart
class SchemaContext {
  /// BuildContext for token resolution
  final BuildContext buildContext;

  /// Active named variants
  final Set<String> activeVariants;

  /// Data bindings for template resolution
  final Map<String, dynamic> bindings;

  /// Parent schema (for nested resolution)
  final Map<String, dynamic>? parentSchema;

  /// Trust level for security
  final SchemaTrust trust;
}
```

---

## Part 5: Resolution Pipeline

### 5.1 Flow

```
Schema JSON
    │
    ▼
┌──────────────────────┐
│ 1. Parse & Validate  │  Structure check, type validation
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ 2. Bind Data         │  Template variables → concrete values
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ 3. Resolve Tokens    │  Token refs → design system values
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ 4. Apply Variants    │  Context/state conditions evaluated
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ 5. Build Style       │  Schema → Style<Spec>
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ 6. Build Widget      │  Style → Widget tree
└──────────────────────┘
```

### 5.2 Error Handling

**Graceful Degradation**:
- Unknown properties → Ignored with warning log
- Invalid values → Fallback to defaults
- Missing required → Error boundary with placeholder
- Type mismatch → Attempt coercion, fallback if fails
- Circular refs → Detected and broken with warning

**Error Boundaries**:
```dart
SchemaWidget(
  schema: generatedSchema,
  onError: (error, stackTrace) => ErrorPlaceholder(
    message: 'Failed to render UI',
    details: error.toString(),
  ),
  fallback: DefaultPlaceholder(),
)
```

Recommended semantics:
- `fallback`: shown when schema is missing/empty, still validating, or intentionally partial (e.g., streaming/incomplete).
- `onError`: shown when validation or rendering fails and the UI cannot be safely rendered; should include structured diagnostics and node path.

Structured diagnostics (recommended):

```dart
enum SchemaErrorSeverity { warning, error, fatal }

final class SchemaError {
  const SchemaError({
    required this.code,
    required this.message,
    required this.severity,
    required this.path,
    this.nodeId,
    this.details,
  });

  final String code; // e.g. 'unknown_property', 'invalid_token', 'depth_exceeded'
  final String message;
  final SchemaErrorSeverity severity;
  final String path;
  final String? nodeId;
  final Map<String, Object?>? details;
}
```

---

## Part 6: Ephemeral UI Lifecycle

### 6.1 Phases

```
┌─────────────────────────────────────────────────────────────────────┐
│                       EPHEMERAL UI LIFECYCLE                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐        │
│  │ Generate │ → │ Render   │ → │ Interact │ → │ Dispose  │        │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘        │
│       │             │              │              │                 │
│       ▼             ▼              ▼              ▼                 │
│  Agent creates  Widget tree   User/agent     Cleanup &             │
│  schema         materialized  modifies       resources freed       │
│                                                                      │
│                 ┌─────────────────────┐                             │
│                 │       Evolve        │  (loop back to Render)      │
│                 │  Schema updated     │                             │
│                 │  UI transitions     │                             │
│                 └─────────────────────┘                             │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 EphemeralScope

Container widget managing ephemeral UI lifecycle:

```dart
EphemeralScope(
  // Unique identifier
  id: 'session-ui-001',

  // Trust level for generated content
  trust: SchemaTrust.restricted,

  // Lifecycle callbacks
  onCreated: (schema) => log('UI created: ${schema.id}'),
  onUpdated: (oldSchema, newSchema) => log('UI updated'),
  onDisposed: () => log('UI disposed'),

  // Resource limits
  maxLifetime: Duration(minutes: 30),
  maxChildren: 100,
  maxDepth: 10,

  child: AgentGeneratedContent(),
)
```

### 6.3 Scoped State

Ephemeral UIs need state without polluting app state:

```dart
EphemeralState(
  scope: 'session-001',
  initial: {'selectedTab': 0, 'expanded': false},
  builder: (context, state, update) {
    return SchemaWidget(
      schema: generatedSchema,
      bindings: {
        ...state,
        'onTabSelect': (index) => update({'selectedTab': index}),
        'onToggle': () => update({'expanded': !state['expanded']}),
      },
    );
  },
)
```

**Properties**:
- State isolated to EphemeralScope
- Automatically cleaned up on dispose
- No persistence by default (opt-in if needed)
- Type-safe access via bindings

### 6.4 Schema Evolution

**Replace**: Full schema replacement
```dart
ephemeralScope.update(newSchema);
```

**Diff**: Partial updates for efficiency (decision needed)

Prefer adopting an existing, well-specified patch format rather than inventing a bespoke patch language.

Recommended default: JSON Patch (RFC 6902) style operations (illustrative):

```json
[
  {
    "op": "replace",
    "path": "/style/color",
    "value": {"token": "color.success"}
  },
  {
    "op": "replace",
    "path": "/children/0/content",
    "value": "Updated text"
  },
  {
    "op": "add",
    "path": "/children/-",
    "value": {"type": "text", "content": "New item"}
  }
]
```

If we keep a custom diff format, it must be fully specified (operators, paths, conflict behavior, validation) and have a clear reason to exist (e.g., better LLM ergonomics, better safety guarantees).

**Animate**: Smooth transitions during evolution
- Schema changes trigger animations automatically
- Custom transition configs per property
- Staggered animations for list changes

### 6.5 Streaming / Progressive Rendering (Required for Agent UIs)

Generated UIs are often produced incrementally. The rendering system should define behavior for:
- **Partial schemas** (schema is incomplete but includes renderable subtrees)
- **Incremental updates** (node-by-node or section-by-section patches)
- **Mid-stream errors** (invalid node encountered partway through generation)

Recommended behavior:
- Allow a “partial mode” where invalid/unknown nodes become placeholders (not hard failures), while valid subtrees still render.
- Use `fallback` for “not enough to render yet” and `onError` only for fatal failures that cannot be safely recovered.
- Require stable `nodeId` so incremental updates can target nodes deterministically.

This can be staged:
- Phase 1: only full schemas + full replacement.
- Phase 2: patches/diffs + partial-mode rendering for common cases.
- Phase 3: fully streaming-first (progressive tree materialization + live announcements + focus stability).

---

## Part 7: Agent Integration

### 7.1 AgentScope

Provides agent context to the widget tree:

```dart
AgentScope(
  // Agent configuration
  config: AgentConfig(
    capabilities: [
      AgentCapability.generateUI,
      AgentCapability.updateUI,
      AgentCapability.handleEvents,
    ],
  ),

  // Schema registry
  registry: mySchemaRegistry,

  // Design system tokens
  tokens: myDesignTokens,

  // Trust boundaries
  trust: SchemaTrust.restricted,

  // Event handling
  onEvent: (event) => sendToAgent(event),
  onSchemaRequest: (intent) => agentGeneratesSchema(intent),

  child: app,
)
```

### 7.2 Event Flow

**UI → Agent**:
```dart
sealed class SchemaEvent {
  final String schemaId;
  final String componentPath;
  final DateTime timestamp;
}

class TapEvent extends SchemaEvent {}
class InputEvent extends SchemaEvent { final String value; }
class SelectEvent extends SchemaEvent { final dynamic selected; }
class ScrollEvent extends SchemaEvent { final double position; }
class CustomEvent extends SchemaEvent { final Map<String, dynamic> payload; }
```

**Agent → UI**:
```dart
sealed class SchemaUpdate {
  final String schemaId;
}

class ReplaceSchema extends SchemaUpdate {
  final Map<String, dynamic> schema;
}
class DiffSchema extends SchemaUpdate {
  final Map<String, dynamic> diff;
}
class RemoveSchema extends SchemaUpdate {}
class TriggerAnimation extends SchemaUpdate {
  final String animationId;
}
```

### 7.3 Intent Processing

```
User Intent: "Show me a breakdown of expenses"
                      │
                      ▼
┌─────────────────────────────────────────┐
│           Agent Processing               │
├─────────────────────────────────────────┤
│ 1. Parse intent                         │
│ 2. Determine UI requirements            │
│ 3. Select appropriate components        │
│ 4. Generate schema with data bindings   │
│ 5. Apply design system tokens           │
└─────────────────────────────────────────┘
                      │
                      ▼
              Generated Schema
                      │
                      ▼
┌─────────────────────────────────────────┐
│            Mix Rendering                 │
├─────────────────────────────────────────┤
│ 1. Validate schema                      │
│ 2. Resolve tokens and variants          │
│ 3. Build widget tree                    │
│ 4. Attach event handlers                │
│ 5. Render with animations               │
└─────────────────────────────────────────┘
                      │
                      ▼
              Interactive UI
```

---

## Part 8: Security Model

### 8.1 Trust Levels

```dart
enum SchemaTrust {
  /// Full access to all components and capabilities
  full,

  /// Standard access, no dangerous operations
  standard,

  /// Limited to safe components, no external actions
  restricted,

  /// Minimal: text and basic layout only
  minimal,
}
```

### 8.2 Capability Restrictions by Trust Level

| Capability | Full | Standard | Restricted | Minimal |
|------------|------|----------|------------|---------|
| All components | Yes | Yes | Limited | Basic |
| Animations | Yes | Yes | Simple | No |
| Network actions | Yes | No | No | No |
| File system | Yes | No | No | No |
| Custom handlers | Yes | Yes | Registered | No |
| Deep nesting | Yes | Yes | Limited | Very limited |
| Event emission | Yes | Yes | Limited | No |

### 8.3 Validation Rules

**Structural**:
- Maximum nesting depth (default: 20)
- Maximum children count (default: 100)
- Maximum total nodes (default: 1000)
- No circular references

**Content**:
- Property values are data, never code
- URLs validated against allowlist
- No script injection vectors
- Sanitized text content

**Runtime**:
- Rate limiting for rapid updates
- Memory budget per scope
- CPU time limits for resolution

---

## Part 9: Implementation Roadmap

### Phase 1: Foundation
**Goal**: Basic schema rendering

**Deliverables**:
1. Decide schema direction: adopt/adapt external protocol vs Mix-native schema (+ adapters)
2. StyleSchema (naming TBD: MixSchema/UiSchema) specification v1
3. Token reference format + `SchemaTokenResolver` (typed token resolution)
4. Variant key mapping spec (schema → Mix variants)
5. SchemaHandler/registry interfaces aligned with Mix `StyleBuilder`
6. Built-in handlers: box, text, flex, stack, icon
7. SchemaWidget for rendering (error boundaries + debug node path)
8. Basic validation (structure, types, limits)

**Success Criteria**:
- AI generates valid schema → Mix renders it
- Basic styling works (padding, color, borders)
- Errors handled gracefully

### Phase 2: Interactivity
**Goal**: Interactive generated UIs

**Deliverables**:
1. Pressable/input handlers
2. Event system (tap, input, select)
3. EphemeralScope lifecycle
4. EphemeralState management
5. Animation support
6. Variant resolution (leveraging Mix widget-state tracking where possible)
7. Safe transform registry for binding transforms

**Success Criteria**:
- Buttons trigger events
- Forms collect input
- State persists in session
- Smooth animations

### Phase 3: Agent Integration
**Goal**: Full agent-UI workflow

**Deliverables**:
1. AgentScope widget
2. Intent → Schema pipeline
3. Schema diff/update mechanism
4. Bidirectional event flow
5. Data binding system

**Success Criteria**:
- Intent → Generated UI → Interaction → Update cycle works
- Smooth evolution of UIs
- Clean resource management

### Phase 4: Production Readiness
**Goal**: Robust, secure, performant

**Deliverables**:
1. Security model implementation
2. Performance optimization
3. Memory management
4. Accessibility support
5. Developer tooling (schema inspector, token/variant trace, error reports)
6. Documentation (schema spec, registry, trust model, testing)

**Success Criteria**:
- Security audit passed
- Performance benchmarks met
- Accessibility compliance
- Developer adoption

---

## Part 9.5: Packaging Plan (Strong Recommendation)

To avoid overloading `packages/mix`, implement this vision as separate deliverables:

- `packages/mix_schema` (new): schema model + parsing/validation + rendering + registry + error boundaries.
- `packages/mix_agent_ui` (optional, separate): shared affordances for agent experiences (tool cards, approvals, provenance). Generated UIs should reuse these patterns, not invent new ones.

This also avoids naming conflicts: this doc uses `AgentScope` conceptually; the agent UI package should prefer a more specific name (e.g., `AgentUiScope`) to reduce confusion.

---

## Part 9.6: Tooling, Testing, and Performance Budgets (Required)

This section turns “production readiness” into explicit deliverables reviewers can approve or reject.

### Tooling (minimum viable)
- **Schema inspector**: render tree view with `schemaId`, `nodeId`, and `componentPath`.
- **Resolution trace** (debug-only): show active variants, resolved token refs, and applied transforms per node.
- **Error reporting**: structured errors with severity and fallback behavior; include node path.
- **Authoring-time validation**: a validator that returns structured errors so agents/tools can self-correct before attempting to render.
  - Option A: publish a meta-schema (e.g., JSON Schema) for the wire format.
  - Option B: expose a `validate(schema)` API returning machine-readable diagnostics.

### Testing strategy (minimum viable)
- **Validator tests**: table-driven tests for structural rules (depth/children limits, required fields).
- **Fuzz/property tests**: generate random schemas within limits and ensure parsing/validation never crashes.
- **Golden tests**: snapshot rendered output for a small set of canonical schemas (especially trust boundaries and error states).
- **Migration tests**: for `$schema` version bumps, ensure old schemas migrate or fail with clear diagnostics.

### Performance budgets (proposed starting targets)
Targets should be validated with profiling, but reviewers need something concrete:
- **Parse + validate**: O(n) in number of nodes; no unbounded recursion; enforce max depth.
- **Schema → widget**:
  - “Typical” schema (<= 200 nodes): aim for <16ms on desktop, <32ms on mid-tier mobile.
  - Larger schemas: degrade gracefully via pagination/virtualization (e.g., list handlers).
- **Update/diff**: prefer incremental updates; avoid rebuilding the entire tree for small diffs.
  - Target (small patches): aim for <8ms on desktop for trivial diffs (single property/text updates), with profiling to validate.

### Accessibility contract (minimum viable)
- Schema nodes must be able to carry:
  - role/type (button, text, heading, image, input)
  - label/hint/value
  - enabled/disabled state
  - (optional) live-region announcements for streaming updates
- Renderer must ensure:
  - focus order is stable across diffs
  - streaming updates do not spam announcements

Accessibility staging:
- Phase 1 sets the minimum semantics contract above.
- Phase 4 targets platform-appropriate accessibility compliance (e.g., WCAG-style outcomes), including list/form semantics, heading levels, and robust focus management.

---

## Part 10: Open Questions

### Technical
1. How to handle schema versioning and migration?
2. What's the performance ceiling for schema resolution?
3. How to support offline/cached schemas?
4. How to ensure accessibility in generated UIs?
5. How do we support streaming/partial schemas (progressive rendering, mid-stream recovery)?
6. What is the canonical AST (Dart types) and how stable is it across schema versions?
7. What are update/diff latency targets (separate from cold render budgets)?
8. How do agents validate schemas before sending (meta-schema vs validate API)?

### Design
1. Should there be a shorthand DSL for common patterns?
2. What components belong in the core registry?
3. How tightly coupled to MixScope tokens?
4. What debugging tools are needed?

### Ecosystem
1. How do generated and hand-crafted UIs coexist?
2. How to share/reuse schema templates?
3. How to test agent-generated UI flows?
4. What analytics should be built-in?

---

## Part 11: Success Metrics

### Framework Quality
- Schema spec is stable and versioned
- 15+ built-in component handlers
- <50ms schema-to-widget time (typical)
- Zero critical security vulnerabilities
- 90%+ test coverage on core
- DevTools-grade schema inspector + trace tooling

### Developer Experience
- Clear documentation with examples
- Migration guide from traditional Mix
- Schema validation tooling
- Visual debugging inspector
- Type-safe Dart APIs

### AI Integration
- Works with major LLM providers
- <500ms intent-to-render time
- Smooth animations during updates
- No memory leaks in long sessions
- Graceful degradation on errors

---

## Appendix A: Example Schemas

### Simple Card
```json
{
  "$schema": "mix://schema/v1",
  "type": "box",
  "style": {
    "padding": {"all": 16},
    "color": {"token": "color.surface.card"},
    "borderRadius": {"all": 12},
    "elevation": 2
  },
  "variants": {
    "onHovered": {"elevation": 4}
  },
  "animation": {"type": "curve", "durationMs": 150},
  "children": [
    {
      "type": "text",
      "content": "Card Title",
      "style": {"fontSize": 18, "fontWeight": "bold"}
    },
    {
      "type": "text",
      "content": "Card description goes here",
      "style": {"fontSize": 14, "color": {"token": "color.text.secondary"}}
    }
  ]
}
```

### Data List with Binding
```json
{
  "$schema": "mix://schema/v1",
  "type": "flex",
  "style": {"direction": "column", "spacing": 8},
  "children": {
    "repeat": "items",
    "as": "item",
    "template": {
      "type": "pressable",
      "onTap": {"action": "emit", "event": "item.tap", "payload": {"id": "{{item.id}}"}},
      "child": {
        "type": "box",
        "style": {"padding": {"all": 12}, "color": {"token": "color.surface.primary"}},
        "child": {
          "type": "text",
          "content": {"bind": "item.title"}
        }
      }
    }
  }
}
```

### Responsive Dashboard
```json
{
  "$schema": "mix://schema/v1",
  "type": "flex",
  "style": {
    "direction": {"responsive": {"mobile": "column", "tablet": "row"}},
    "spacing": {"responsive": {"mobile": 8, "tablet": 16, "desktop": 24}}
  },
  "children": [
    {
      "type": "box",
      "style": {
        "flex": {"responsive": {"mobile": 1, "tablet": 2}},
        "minHeight": 200
      },
      "slot": "main-content"
    },
    {
      "type": "box",
      "style": {
        "flex": 1,
        "display": {"responsive": {"mobile": "none", "tablet": "flex"}}
      },
      "slot": "sidebar"
    }
  ]
}
```

---

## Appendix B: Glossary

| Term | Definition |
|------|------------|
| **StyleSchema** | JSON format describing UI structure and styling for Mix |
| **Ephemeral UI** | Generated interface with temporary lifecycle |
| **Intent** | User's goal or request that drives UI generation |
| **SchemaHandler** | Component that converts schema type to Mix widgets |
| **EphemeralScope** | Container managing lifecycle of generated UIs |
| **AgentScope** | Provider connecting AI agent to Mix rendering |
| **Schema Evolution** | Process of updating generated UI via diffs |
| **Trust Level** | Security classification limiting schema capabilities |

---

## Appendix C: Canonical AST (Preliminary Sketch)

If we adopt the Adapter → Canonical AST → Renderer architecture (`Part 2.5`), the canonical AST becomes the stable internal contract.

This is intentionally a sketch to guide implementation discussions:

```dart
sealed class SchemaNode {
  const SchemaNode({
    required this.nodeId,
    required this.type,
    required this.path,
    required this.trust,
    this.semantics,
  });

  final String nodeId;
  final String type;
  final String path;
  final SchemaTrust trust;
  final SchemaSemantics? semantics;
}

final class SchemaSemantics {
  const SchemaSemantics({
    required this.role,
    required this.label,
    this.hint,
    this.value,
    this.enabled,
    this.liveRegion,
  });

  final String role;
  final String label;
  final String? hint;
  final String? value;
  final bool? enabled;
  final String? liveRegion; // 'off' | 'polite' | 'assertive'
}

sealed class ColorValue {
  const ColorValue();
}

final class TokenColor extends ColorValue {
  const TokenColor({required this.tokenType, required this.tokenName});
  final String tokenType; // 'color'
  final String tokenName; // e.g. 'surface.primary'
}

final class DirectColor extends ColorValue {
  const DirectColor(this.value);
  final int value; // ARGB
}

final class AdaptiveColor extends ColorValue {
  const AdaptiveColor({required this.light, required this.dark});
  final DirectColor light;
  final DirectColor dark;
}

final class BoxStyleProps {
  const BoxStyleProps({
    this.paddingAll,
    this.color,
    this.borderRadiusAll,
    this.elevation,
  });

  final double? paddingAll;
  final ColorValue? color;
  final double? borderRadiusAll;
  /// Schema uses numeric elevation; handler maps to Mix's ElevationShadow.
  final double? elevation;
}

final class BoxNode extends SchemaNode {
  const BoxNode({
    required super.nodeId,
    required super.path,
    required super.trust,
    required this.style,
    required this.variants,
    required this.children,
    super.semantics,
    this.animation,
  }) : super(type: 'box');

  final BoxStyleProps style;
  final Map<String, BoxStyleProps> variants; // variantKey -> override
  final List<SchemaNode> children;
  final SchemaAnimation? animation;
}

final class SchemaAnimation {
  const SchemaAnimation({
    required this.type,
    required this.durationMs,
    this.curve,
  });

  final String type; // 'curve' | 'spring' | ...
  final int durationMs;
  final String? curve;
}
```

Notes:
- The AST should carry a stable `nodeId` and a deterministic `path` for debugging and diffs.
- Node payloads should remain “data-only” and validated before rendering.
- Prefer typed AST/value types early to avoid “stringly typed” bugs and to make validation + tooling easier.

---

## Appendix D: Example Handler (Box)

This appendix illustrates what a minimal handler might look like when aligned with Mix 2.0’s rendering pipeline.

```dart
final class BoxHandler /* implements SchemaHandler<BoxSpec> */ {
  String get type => 'box';

  // Validation should enforce structural constraints and types.
  // It should also attach node paths for diagnostics.
  void validate(BoxNode node) {
    // required: nodeId/type
    // enforce maxDepth/maxChildren
    // validate style keys and value ranges
    // validate token refs via SchemaTokenResolver + trust
  }

  // Convert schema props into a Mix style (prefer stylers).
  BoxStyler toStyle(BoxStyleProps props /*, SchemaContext ctx */) {
    var s = BoxStyler();
    if (props.paddingAll != null) s = s.paddingAll(props.paddingAll!);
    // if (props.color != null) s = s.color(resolveColor(props.color!, ctx));
    if (props.borderRadiusAll != null) s = s.borderRounded(props.borderRadiusAll!);
    // Schema uses numeric elevation; map to ElevationShadow for Mix
    if (props.elevation != null) {
      s = s.elevation(ElevationShadow(props.elevation!.toInt()));
    }
    return s;
  }

  Widget build(BoxNode node) {
    final style = toStyle(node.style);
    Widget current = Box(style: style, child: _buildChildren(node.children));

    if (node.semantics != null) {
      // Map SchemaSemantics → Flutter Semantics here.
      // current = Semantics(label: node.semantics!.label, child: current);
    }

    return current;
  }

  Widget _buildChildren(List<SchemaNode> children) {
    // In real implementation, delegate back to SchemaRegistry/renderer.
    return const SizedBox.shrink();
  }
}
```

Notes:
- Real handlers should apply `variants` by merging overrides under the mapped Mix variants.
- Prefer building through Mix’s style resolution pipeline where possible; fall back to raw widgets only when needed.

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| 0.1 | 2024-12 | Initial research document |
