---
tags:
  - type/spec
  - domain/development
  - domain/ai
updated: 2026-02-26
---

# mix_schema — Implementation Plan

Self-contained blueprint for building the `mix_schema` Dart/Flutter package. An implementing agent needs only this document and access to the Mix 2.0 codebase in this repository (`packages/mix/` and `packages/mix_tailwinds/`).

Canonical frozen contract reference: [mix_schema_v0.1_freeze.md](./mix_schema_v0.1_freeze.md).

## 1. Overview & Scope

### What mix_schema is

A rendering pipeline that bridges AI agent protocols with Mix's styling system:

```
External protocols in → Canonical AST in the middle → Mix renderer out
```

The pattern is already proven by `mix_tailwinds`, which does the same thing for Tailwind CSS class strings instead of JSON payloads. See §15 for transferable implementation patterns.

### v0.1 Frozen Decisions

From `mix_schema_v0.1_freeze.md`:

| Decision | Value |
|----------|-------|
| Schema direction | `adapt` (wire adapters, not direct coupling) |
| Canonical AST | Yes (internal contract) |
| Token format | Explicit object `{type, name}` primary |
| Token naming | `type.<name>` (consistent with Mix's `md.color.primary` pattern) |
| Variant composition | Simple mapping only |
| Transform model | Closed registry (maps to Mix's `Directive<T>` system) |
| Patch/diff | JSON Patch (RFC 6902) — Phase 2 |
| Streaming | Phase 2 |
| Animation key | `durationMs` |

### NOT in v0.1 Scope

- Streaming / partial rendering (Phase 2)
- JSON Patch incremental updates (Phase 2)
- Custom component authoring API
- A2UI v1.0 adapter (budgeted for Q4 2026)
- Agent runtime orchestration
- Network/model integrations

## 2. Package Layout

```
packages/mix_schema/
├── lib/
│   ├── mix_schema.dart                    # Barrel export
│   └── src/
│       ├── ast/
│       │   ├── schema_node.dart           # SchemaNode sealed hierarchy
│       │   ├── schema_values.dart         # SchemaValue sealed hierarchy
│       │   ├── schema_semantics.dart      # Accessibility semantics model
│       │   └── ui_schema_root.dart        # Root container
│       ├── adapters/
│       │   ├── wire_adapter.dart          # WireAdapter interface + AdaptResult
│       │   ├── a2ui_v09_adapter.dart      # A2UI v0.9 draft adapter
│       │   └── a2ui_v08_adapter.dart      # A2UI v0.8 stable compat adapter
│       ├── validate/
│       │   ├── schema_validator.dart      # SchemaValidator interface + ValidationResult
│       │   ├── diagnostics.dart           # SchemaDiagnostic + DiagnosticCode enum
│       │   ├── structural_rules.dart      # Type/field/structure rules
│       │   ├── trust_rules.dart           # Depth/count/action gating
│       │   └── semantic_rules.dart        # a11y rules (role, label, etc.)
│       ├── render/
│       │   ├── schema_renderer.dart       # SchemaRenderer + RenderContext
│       │   ├── schema_registry.dart       # NodeHandler registry
│       │   ├── schema_widget.dart         # Drop-in SchemaWidget
│       │   ├── schema_scope.dart          # SchemaScope InheritedWidget
│       │   └── handlers/
│       │       ├── box_handler.dart
│       │       ├── text_handler.dart
│       │       ├── flex_handler.dart
│       │       ├── stack_handler.dart
│       │       ├── icon_handler.dart
│       │       ├── image_handler.dart
│       │       ├── pressable_handler.dart
│       │       ├── scrollable_handler.dart
│       │       ├── wrap_handler.dart
│       │       ├── input_handler.dart
│       │       └── repeat_handler.dart
│       ├── trust/
│       │   ├── schema_trust.dart          # SchemaTrust enum + limits
│       │   └── capability_matrix.dart     # Trust → capability mapping
│       ├── tokens/
│       │   └── schema_token_resolver.dart # Token ref → MixToken resolution
│       ├── events/
│       │   ├── schema_event.dart          # SchemaEvent sealed hierarchy
│       │   └── schema_action.dart         # SchemaAction sealed hierarchy
│       ├── components/
│       │   ├── component_registry.dart    # Catalog → AST expansion
│       │   └── expansion_templates.dart   # Top-5 component expansions
│       └── engine.dart                    # SchemaEngine facade
├── test/
│   ├── fixtures/
│   │   ├── valid/                         # Valid golden JSON payloads
│   │   ├── invalid/                       # Invalid payloads (each expected diagnostic)
│   │   └── lossy/                         # Lossy adaptation edge cases
│   ├── ast/
│   ├── adapters/
│   ├── validate/
│   ├── render/
│   ├── trust/
│   └── integration/
├── pubspec.yaml
└── analysis_options.yaml
```

### pubspec.yaml

```yaml
name: mix_schema
description: Schema-driven UI rendering for Mix
version: 0.1.0

environment:
  sdk: ">=3.10.0 <4.0.0"
  flutter: ">=3.38.1"

dependencies:
  flutter:
    sdk: flutter
  mix: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  dart_code_metrics_presets: ^2.24.0
```

## 3. Canonical AST Classes

### 3.1 SchemaNode Sealed Hierarchy

```dart
// ast/schema_node.dart

/// Base for all AST nodes. Every node has identity, type, and optional semantics.
sealed class SchemaNode {
  final String nodeId;
  final SchemaSemantics? semantics;
  final Map<String, SchemaValue>? style;
  final SchemaAnimation? animation;
  final Map<String, SchemaValue>? variants; // interaction/theme variants

  const SchemaNode({
    required this.nodeId,
    this.semantics,
    this.style,
    this.animation,
    this.variants,
  });
}

// --- Primitives ---

final class BoxNode extends SchemaNode {
  final SchemaNode? child;

  const BoxNode({
    required super.nodeId,
    this.child,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class TextNode extends SchemaNode {
  final SchemaValue content; // DirectValue<String> or BindingValue

  const TextNode({
    required super.nodeId,
    required this.content,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class IconNode extends SchemaNode {
  final SchemaValue icon; // icon name or codepoint

  const IconNode({
    required super.nodeId,
    required this.icon,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class ImageNode extends SchemaNode {
  final SchemaValue src;
  final String? alt;

  const ImageNode({
    required super.nodeId,
    required this.src,
    this.alt,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Layout ---

final class FlexNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? direction; // "row" | "column"
  final SchemaValue? spacing;
  final SchemaValue? crossAxisAlignment;
  final SchemaValue? mainAxisAlignment;

  const FlexNode({
    required super.nodeId,
    required this.children,
    this.direction,
    this.spacing,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class StackNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? alignment;

  const StackNode({
    required super.nodeId,
    required this.children,
    this.alignment,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class ScrollableNode extends SchemaNode {
  final SchemaNode child;
  final SchemaValue? direction; // "vertical" | "horizontal"

  const ScrollableNode({
    required super.nodeId,
    required this.child,
    this.direction,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class WrapNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? spacing;
  final SchemaValue? runSpacing;

  const WrapNode({
    required super.nodeId,
    required this.children,
    this.spacing,
    this.runSpacing,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Interactive ---

final class PressableNode extends SchemaNode {
  final SchemaNode child;
  final String? actionId;
  final SchemaEvent? onTap;

  const PressableNode({
    required super.nodeId,
    required this.child,
    this.actionId,
    this.onTap,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class InputNode extends SchemaNode {
  final String inputType; // "text" | "toggle" | "slider" | "select" | "date"
  final String fieldId;
  final SchemaValue? label;
  final SchemaValue? hint;
  final SchemaValue? value;
  final Map<String, SchemaValue>? inputProps; // type-specific props

  const InputNode({
    required super.nodeId,
    required this.inputType,
    required this.fieldId,
    this.label,
    this.hint,
    this.value,
    this.inputProps,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Control ---

final class RepeatNode extends SchemaNode {
  final SchemaValue items; // BindingValue to a list
  final SchemaNode template;
  final String itemAlias; // default "item"

  const RepeatNode({
    required super.nodeId,
    required this.items,
    required this.template,
    this.itemAlias = 'item',
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}
```

### 3.2 SchemaValue Sealed Hierarchy

```dart
// ast/schema_values.dart

/// All values in the AST resolve through this hierarchy.
sealed class SchemaValue {
  const SchemaValue();
}

/// Literal value — used directly.
final class DirectValue<T> extends SchemaValue {
  final T value;
  const DirectValue(this.value);
}

/// Token reference — resolves through MixScope at render time.
/// Wire format: {"token": {"type": "color", "name": "primary"}}
/// Shorthand: "color.primary" (normalized by adapter)
final class TokenRef extends SchemaValue {
  final String type;  // "color", "space", "radius", "textStyle", etc.
  final String name;  // "primary", "surface.container", etc.

  const TokenRef({required this.type, required this.name});

  /// Dotted name for Mix token lookup: "color.primary"
  String get tokenName => '$type.$name';
}

/// Brightness-adaptive value — resolves based on theme mode.
/// Wire format: {"adaptive": {"light": "#000000", "dark": "#FFFFFF"}}
final class AdaptiveValue extends SchemaValue {
  final SchemaValue light;
  final SchemaValue dark;

  const AdaptiveValue({required this.light, required this.dark});
}

/// Viewport-responsive value — resolves based on breakpoint.
/// Wire format: {"responsive": {"mobile": 8, "tablet": 16, "desktop": 24}}
final class ResponsiveValue extends SchemaValue {
  final Map<String, SchemaValue> breakpoints; // "mobile", "tablet", "desktop"

  const ResponsiveValue(this.breakpoints);
}

/// Data binding — resolves from SchemaDataContext at render time.
/// Wire format: {"bind": "user.displayName"}
final class BindingValue extends SchemaValue {
  final String path; // JSON Pointer or dot-path

  const BindingValue(this.path);
}

/// Transform — binding + closed-registry transform.
/// Wire format: {"bind": "price", "transform": "currency"}
final class TransformValue extends SchemaValue {
  final String path;
  final String transformKey; // must exist in closed registry

  const TransformValue({required this.path, required this.transformKey});
}
```

### 3.3 SchemaAnimation

```dart
// Included in schema_node.dart or a separate file

final class SchemaAnimation {
  final int durationMs;
  final String? curve;  // "easeOut", "easeInOut", "linear", etc.
  final int? delayMs;

  const SchemaAnimation({
    required this.durationMs,
    this.curve,
    this.delayMs,
  });
}
```

### 3.4 UiSchemaRoot

```dart
// ast/ui_schema_root.dart

final class UiSchemaRoot {
  final String id;
  final String schemaVersion; // "0.1"
  final SchemaNode root;
  final SchemaTrust trust;
  final SchemaEnvironment? environment;

  const UiSchemaRoot({
    required this.id,
    required this.schemaVersion,
    required this.root,
    required this.trust,
    this.environment,
  });
}

final class SchemaEnvironment {
  final Map<String, dynamic>? data;      // initial data context
  final Map<String, dynamic>? state;     // initial local state
  final Map<String, SchemaValue>? tokens; // token overrides
  final List<String>? breakpoints;       // breakpoint names in order

  const SchemaEnvironment({this.data, this.state, this.tokens, this.breakpoints});
}
```

### 3.5 SchemaSemantics

```dart
// ast/schema_semantics.dart

final class SchemaSemantics {
  // Base
  final String? role;       // "button", "heading", "img", "list", etc.
  final String? label;
  final String? hint;
  final String? value;
  final bool? enabled;

  // Interactive
  final bool? selected;
  final bool? checked;
  final bool? expanded;

  // Ordering / relations
  final int? focusOrder;
  final String? labelledBy; // nodeId
  final String? describedBy; // nodeId

  // Live regions
  final String? liveRegionMode; // "polite" | "assertive"
  final bool? liveRegionAtomic;
  final String? liveRegionRelevant; // "additions" | "removals" | "text" | "all"
  final bool? liveRegionBusy;

  const SchemaSemantics({
    this.role,
    this.label,
    this.hint,
    this.value,
    this.enabled,
    this.selected,
    this.checked,
    this.expanded,
    this.focusOrder,
    this.labelledBy,
    this.describedBy,
    this.liveRegionMode,
    this.liveRegionAtomic,
    this.liveRegionRelevant,
    this.liveRegionBusy,
  });
}
```

## 4. Value Resolution Pipeline

Each `SchemaValue` type has a deterministic resolution strategy at render time.

### Resolution order (per property)

```
SchemaValue
  ├── DirectValue<T>     → return value directly
  ├── TokenRef           → SchemaTokenResolver.resolve(ref, context)
  │                        → MixScope.tokenOf<T>(MixToken<T>(ref.tokenName), context)
  │                        → on failure: emit diagnostic, skip property
  ├── AdaptiveValue      → read Theme.of(context).brightness
  │                        → select light/dark branch
  │                        → recursively resolve selected branch
  ├── ResponsiveValue    → read viewport width (MediaQuery or LayoutBuilder)
  │                        → match to highest active breakpoint
  │                        → recursively resolve matched value
  ├── BindingValue       → RenderContext.dataContext?.lookup(path)
  │                        → on null: emit diagnostic, skip property
  └── TransformValue     → resolve binding first
                           → apply registered Directive<T> from closed registry
                           → on unknown transform: emit diagnostic, use raw value
```

### Token type → MixToken mapping

| Token `type` | Mix class | Resolves to |
|-------------|-----------|-------------|
| `"color"` | `ColorToken` | `Color` |
| `"space"` | `SpaceToken` | `double` |
| `"radius"` | `RadiusToken` | `Radius` |
| `"textStyle"` | `TextStyleToken` | `TextStyle` |
| `"borderSide"` | `BorderSideToken` | `BorderSide` |
| `"shadow"` | `ShadowToken` | `List<Shadow>` |
| `"boxShadow"` | `BoxShadowToken` | `List<BoxShadow>` |
| `"fontWeight"` | `FontWeightToken` | `FontWeight` |
| `"duration"` | `DurationToken` | `Duration` |
| `"breakpoint"` | `BreakpointToken` | `Breakpoint` |
| `"double"` | `DoubleToken` | `double` |

### SchemaTokenResolver interface

```dart
// tokens/schema_token_resolver.dart

abstract class SchemaTokenResolver {
  /// Resolve a token reference to a concrete value.
  /// Returns null if the token is not found (caller emits diagnostic).
  T? resolve<T>(TokenRef ref, BuildContext context);
}

/// Default implementation: delegates to MixScope.
final class MixScopeTokenResolver implements SchemaTokenResolver {
  @override
  T? resolve<T>(TokenRef ref, BuildContext context) {
    final mixToken = _createMixToken<T>(ref);
    if (mixToken == null) return null;

    try {
      return MixScope.tokenOf<T>(mixToken, context);
    } catch (_) {
      return null; // token not found — caller emits diagnostic
    }
  }

  MixToken<T>? _createMixToken<T>(TokenRef ref) {
    return switch (ref.type) {
      'color' => ColorToken(ref.tokenName) as MixToken<T>,
      'space' => SpaceToken(ref.tokenName) as MixToken<T>,
      'radius' => RadiusToken(ref.tokenName) as MixToken<T>,
      'textStyle' => TextStyleToken(ref.tokenName) as MixToken<T>,
      'borderSide' => BorderSideToken(ref.tokenName) as MixToken<T>,
      'shadow' => ShadowToken(ref.tokenName) as MixToken<T>,
      'boxShadow' => BoxShadowToken(ref.tokenName) as MixToken<T>,
      'fontWeight' => FontWeightToken(ref.tokenName) as MixToken<T>,
      'duration' => DurationToken(ref.tokenName) as MixToken<T>,
      'breakpoint' => BreakpointToken(ref.tokenName) as MixToken<T>,
      'double' => DoubleToken(ref.tokenName) as MixToken<T>,
      _ => null, // unknown type — caller emits diagnostic
    };
  }
}
```

## 5. Adapter Layer

### 5.1 WireAdapter Interface

```dart
// adapters/wire_adapter.dart

abstract class WireAdapter {
  /// Unique identifier, e.g. "a2ui_v0_9_draft_latest"
  String get id;

  /// Supported wire protocol versions
  List<String> get supportedVersions;

  /// Adapt a wire payload into canonical AST.
  /// Returns root + diagnostics (may succeed with warnings).
  AdaptResult adapt(Object wirePayload, AdaptContext context);
}

final class AdaptContext {
  final SchemaTrust trust;
  final String? sourceVersion; // wire protocol version from payload

  const AdaptContext({required this.trust, this.sourceVersion});
}

final class AdaptResult {
  final UiSchemaRoot? root;
  final List<SchemaDiagnostic> diagnostics;

  const AdaptResult({this.root, this.diagnostics = const []});

  bool get hasErrors =>
    diagnostics.any((d) => d.severity == DiagnosticSeverity.error);
}
```

### 5.2 A2UI v0.9 Adapter

Primary adapter. Implementation approach:

1. Parse JSON `Map<String, dynamic>` wire payload
2. Extract envelope: `id`, `version`, `trust`, `root`
3. Walk root node tree recursively:
   - For each node: read `type`, `nodeId`, `style`, `semantics`, `children`/`child`
   - Map A2UI node types to AST node types (identity mapping for v0.1 — names match)
   - Normalize values: detect token shorthands (`"color.primary"` → `TokenRef(type: 'color', name: 'primary')`)
   - Detect adaptive/responsive wrappers
4. Emit lossy-mapping diagnostics when A2UI features have no AST equivalent
5. Return `UiSchemaRoot`

Token normalization rules:

```dart
SchemaValue _normalizeValue(dynamic raw) {
  if (raw == null) return const DirectValue(null);
  if (raw is num) return DirectValue(raw);
  if (raw is bool) return DirectValue(raw);
  if (raw is String) {
    // Check for token shorthand: "color.primary"
    final dotIndex = raw.indexOf('.');
    if (dotIndex > 0 && _isTokenType(raw.substring(0, dotIndex))) {
      return TokenRef(
        type: raw.substring(0, dotIndex),
        name: raw.substring(dotIndex + 1),
      );
    }
    return DirectValue(raw);
  }
  if (raw is Map<String, dynamic>) {
    if (raw.containsKey('token')) {
      final tok = raw['token'] as Map<String, dynamic>;
      return TokenRef(type: tok['type'], name: tok['name']);
    }
    if (raw.containsKey('adaptive')) {
      final a = raw['adaptive'] as Map<String, dynamic>;
      return AdaptiveValue(
        light: _normalizeValue(a['light']),
        dark: _normalizeValue(a['dark']),
      );
    }
    if (raw.containsKey('responsive')) {
      final r = raw['responsive'] as Map<String, dynamic>;
      return ResponsiveValue(
        r.map((k, v) => MapEntry(k, _normalizeValue(v))),
      );
    }
    if (raw.containsKey('bind')) {
      if (raw.containsKey('transform')) {
        return TransformValue(
          path: raw['bind'],
          transformKey: raw['transform'],
        );
      }
      return BindingValue(raw['bind']);
    }
  }
  // Fallback: wrap as direct value
  return DirectValue(raw);
}
```

### 5.3 A2UI v0.8 Adapter

Compatibility adapter. Same structure as v0.9 but:
- Handle v0.8-specific field names (if different)
- Emit `DiagnosticCode.lossyAdaptation` for features present in v0.8 wire format but unsupported in canonical AST
- Map deprecated field locations to current positions

## 6. Validation Layer

### 6.1 Diagnostic Model

```dart
// validate/diagnostics.dart

enum DiagnosticSeverity { error, warning, info }

/// Stable codes for machine-readable diagnostics.
enum DiagnosticCode {
  // Structural
  unknownNodeType,
  missingRequiredField,
  invalidChildStructure,    // e.g., children on a wrapper node
  invalidValueType,

  // Trust
  depthLimitExceeded,
  nodeCountExceeded,
  actionNotAllowedAtTrustLevel,
  animationComplexityExceeded,

  // Semantic / a11y
  interactiveNodeMissingRole,
  pressableMissingLabel,
  imageMissingAlt,
  liveRegionMissingMode,

  // Adaptation
  lossyAdaptation,          // wire feature has no AST equivalent
  unknownTokenType,
  unknownTransformKey,
  unsupportedWireVersion,
}

final class SchemaDiagnostic {
  final DiagnosticCode code;
  final DiagnosticSeverity severity;
  final String? nodeId;
  final String? path;        // dot-path in the AST, e.g. "root.children[2].style.color"
  final String message;
  final String? suggestion;

  const SchemaDiagnostic({
    required this.code,
    required this.severity,
    this.nodeId,
    this.path,
    required this.message,
    this.suggestion,
  });
}
```

### 6.2 Validator Interface

```dart
// validate/schema_validator.dart

abstract class SchemaValidator {
  ValidationResult validate(UiSchemaRoot root, ValidationContext context);
}

final class ValidationContext {
  final SchemaTrust trust;
  final Set<String>? allowedActions;  // null = use defaults
  final int? maxDepth;                // null = use trust default
  final int? maxNodeCount;            // null = use trust default

  const ValidationContext({
    required this.trust,
    this.allowedActions,
    this.maxDepth,
    this.maxNodeCount,
  });
}

final class ValidationResult {
  final bool isValid;
  final List<SchemaDiagnostic> diagnostics;

  const ValidationResult({
    required this.isValid,
    this.diagnostics = const [],
  });
}
```

### 6.3 Rule Categories

**Structural rules** (`structural_rules.dart`):
- Node `type` is a known AST node type
- Required fields present for each node type (e.g., `TextNode` requires `content`)
- `child` vs `children` used correctly (wrapper nodes: `child`; layout nodes: `children`)
- Value types are valid (no nested `SchemaValue` in invalid positions)

**Trust rules** (`trust_rules.dart`):
- Tree depth ≤ trust limit (minimal: 5, standard: 10, elevated: 20)
- Total node count ≤ trust limit (minimal: 50, standard: 200, elevated: 1000)
- Actions referenced in the tree respect trust-level risk gating
- Animation complexity (total animated nodes) ≤ trust limit

**Semantic rules** (`semantic_rules.dart`):
- Interactive nodes (`PressableNode`, `InputNode`) must have a `role` in semantics
- `PressableNode` must have a semantic `label`
- `ImageNode` should have `alt` or semantic `label` (warning, not error)
- Live regions must specify `mode` if present

## 7. Renderer & Handlers

### 7.1 Core Architecture

```dart
// render/schema_renderer.dart

class SchemaRenderer {
  final SchemaRegistry _registry;
  final SchemaTokenResolver _tokenResolver;

  SchemaRenderer({
    SchemaRegistry? registry,
    SchemaTokenResolver? tokenResolver,
  })  : _registry = registry ?? SchemaRegistry.defaults(),
        _tokenResolver = tokenResolver ?? MixScopeTokenResolver();

  /// Public getter so SchemaEngine (and tests) can access the token resolver.
  SchemaTokenResolver get tokenResolver => _tokenResolver;

  /// Entry point: creates the RenderContext and starts the render walk.
  Widget render(
    UiSchemaRoot root, {
    SchemaTrust? trust,
    SchemaDataContext? dataContext,
    void Function(SchemaEvent)? onEvent,
  }) {
    final context = RenderContext(
      renderer: this,
      tokenResolver: _tokenResolver,
      trust: trust ?? root.trust,
      dataContext: dataContext,
      onEvent: onEvent,
    );
    return _buildNode(root.root, context);
  }

  Widget _buildNode(SchemaNode node, RenderContext context) {
    final handler = _registry.handlerFor(node);
    if (handler == null) {
      return _fallbackWidget(node);
    }
    return handler.build(node, context);
  }

  Widget _fallbackWidget(SchemaNode node) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(8),
      child: Text('Unsupported: ${node.runtimeType}'),
    );
  }
}

// render/schema_registry.dart

class SchemaRegistry {
  final Map<Type, NodeHandler> _handlers;

  SchemaRegistry(this._handlers);

  factory SchemaRegistry.defaults() => SchemaRegistry({
    BoxNode: BoxHandler(),
    TextNode: TextHandler(),
    FlexNode: FlexHandler(),
    StackNode: StackHandler(),
    IconNode: IconHandler(),
    ImageNode: ImageHandler(),
    PressableNode: PressableHandler(),
    ScrollableNode: ScrollableHandler(),
    WrapNode: WrapHandler(),
    InputNode: InputHandler(),
    RepeatNode: RepeatHandler(),
  });

  NodeHandler? handlerFor(SchemaNode node) => _handlers[node.runtimeType];
}
```

### 7.2 RenderContext

```dart
final class RenderContext {
  final SchemaRenderer renderer;
  final SchemaTokenResolver tokenResolver;
  final SchemaTrust trust;
  final SchemaDataContext? dataContext;
  final void Function(SchemaEvent)? onEvent;
  final List<SchemaDiagnostic> diagnostics; // mutable, collects render-time warnings

  RenderContext({
    required this.renderer,
    required this.tokenResolver,
    required this.trust,
    this.dataContext,
    this.onEvent,
    List<SchemaDiagnostic>? diagnostics,
  }) : diagnostics = diagnostics ?? [];

  /// Create a copy with overridden fields (used by RepeatHandler for scoped data).
  RenderContext copyWith({
    SchemaDataContext? dataContext,
    SchemaTrust? trust,
  }) => RenderContext(
    renderer: renderer,
    tokenResolver: tokenResolver,
    trust: trust ?? this.trust,
    dataContext: dataContext ?? this.dataContext,
    onEvent: onEvent,
    diagnostics: diagnostics,
  );

  /// Recursively render a child node.
  Widget buildChild(SchemaNode child) => renderer._buildNode(child, this);

  /// Resolve a SchemaValue to a concrete Dart value.
  T? resolveValue<T>(SchemaValue? value, BuildContext context) {
    if (value == null) return null;
    return switch (value) {
      DirectValue<T> v => v.value,
      DirectValue v => v.value as T?,
      TokenRef ref => tokenResolver.resolve<T>(ref, context),
      AdaptiveValue v => _resolveAdaptive<T>(v, context),
      ResponsiveValue v => _resolveResponsive<T>(v, context),
      BindingValue v => dataContext?.lookup<T>(v.path),
      TransformValue v => _resolveTransform<T>(v, context),
    };
  }

  T? _resolveAdaptive<T>(AdaptiveValue value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return resolveValue<T>(isDark ? value.dark : value.light, context);
  }

  T? _resolveResponsive<T>(ResponsiveValue value, BuildContext context) {
    if (value.breakpoints.isEmpty) return null;

    final width = MediaQuery.sizeOf(context).width;
    final key = width < 768 ? 'mobile' : width < 1024 ? 'tablet' : 'desktop';
    final fallback = value.breakpoints['default'] ?? value.breakpoints.values.first;
    final selected = value.breakpoints[key] ?? fallback;

    return resolveValue<T>(selected, context);
  }

  T? _resolveTransform<T>(TransformValue value, BuildContext context) {
    final raw = dataContext?.lookup<dynamic>(value.path);
    if (raw == null) return null;

    final transformed = SchemaTransforms.closed.apply(
      value.transformKey,
      raw,
      context,
    );
    if (transformed == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.unknownTransformKey,
          severity: DiagnosticSeverity.warning,
          path: value.path,
          message:
              'Unknown transform "${value.transformKey}" - using raw bound value',
        ),
      );
      return raw is T ? raw : null;
    }

    return transformed is T ? transformed : null;
  }
}
```

### 7.2.1 Data Context + Transform Registry (required)

```dart
final class SchemaDataContext {
  final SchemaDataContext? parent;
  final Map<String, dynamic> scope;

  const SchemaDataContext({this.parent, this.scope = const {}});

  factory SchemaDataContext.root([Map<String, dynamic>? seed]) {
    return SchemaDataContext(scope: seed ?? const {});
  }

  SchemaDataContext child({
    required String alias,
    required dynamic item,
    required int index,
  }) {
    return SchemaDataContext(
      parent: this,
      scope: {alias: item, 'index': index, r'$index': index},
    );
  }

  T? lookup<T>(String path) {
    if (path.isEmpty) return null;

    final value = path.startsWith('/')
        ? _lookupJsonPointer(path)
        : _lookupDotPath(path);

    return value is T ? value : null;
  }

  dynamic _lookupDotPath(String path) {
    final segments = path.split('.');
    dynamic current = _resolveRoot(segments.first);
    if (current == null) return parent?._lookupDotPath(path);

    for (final seg in segments.skip(1)) {
      current = _readSegment(current, seg);
      if (current == null) return null;
    }
    return current;
  }

  dynamic _lookupJsonPointer(String path) {
    final segments = path
        .split('/')
        .skip(1)
        .map((s) => s.replaceAll('~1', '/').replaceAll('~0', '~'))
        .toList();
    if (segments.isEmpty) return null;

    dynamic current = _resolveRoot(segments.first);
    if (current == null) return parent?._lookupJsonPointer(path);

    for (final seg in segments.skip(1)) {
      current = _readSegment(current, seg);
      if (current == null) return null;
    }
    return current;
  }

  dynamic _resolveRoot(String key) =>
      scope.containsKey(key) ? scope[key] : _readSegment(scope, key);

  dynamic _readSegment(dynamic current, String segment) {
    final indexMatch = RegExp(r'^(.+)\\[(\\d+)\\]$').firstMatch(segment);
    if (indexMatch != null) {
      final listKey = indexMatch.group(1)!;
      final index = int.parse(indexMatch.group(2)!);
      final list = switch (current) {
        Map<String, dynamic> map => map[listKey],
        _ => null,
      };
      if (list is List && index >= 0 && index < list.length) {
        return list[index];
      }
      return null;
    }

    return switch (current) {
      Map<String, dynamic> map => map[segment],
      List list => int.tryParse(segment) case final i?
          when i >= 0 && i < list.length =>
        list[i],
      _ => null,
    };
  }
}

typedef SchemaTransformFn = dynamic Function(
  dynamic value,
  BuildContext context,
);

final class SchemaTransforms {
  final Map<String, SchemaTransformFn> _registry;
  const SchemaTransforms(this._registry);

  dynamic? apply(String key, dynamic value, BuildContext context) {
    return _registry[key]?.call(value, context);
  }

  static final closed = SchemaTransforms({
    'string': (value, _) => value?.toString(),
    'int': (value, _) => switch (value) {
      int v => v,
      num v => v.toInt(),
      _ => int.tryParse('$value'),
    },
    'double': (value, _) => switch (value) {
      num v => v.toDouble(),
      _ => double.tryParse('$value'),
    },
    'bool': (value, _) => switch (value) {
      bool v => v,
      'true' || '1' => true,
      'false' || '0' => false,
      _ => null,
    },
  });
}
```

### 7.3 NodeHandler Interface

```dart
abstract class NodeHandler<N extends SchemaNode> {
  Widget build(N node, RenderContext context);
}
```

### 7.4 Handler Implementations

Each handler constructs a Mix Styler from AST properties, applies variants, and renders via the corresponding Mix widget.

#### BoxHandler

```dart
class BoxHandler extends NodeHandler<BoxNode> {
  @override
  Widget build(BoxNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = BoxStyler();
      styler = _applyContainerStyle(styler, node.style, ctx, context);
      styler = _applyVariants(
        styler,
        () => BoxStyler(),
        _applyContainerStyle,
        node.variants,
        ctx,
        context,
      );
      styler = _applyAnimation(styler, node.animation);

      final child = node.child != null ? ctx.buildChild(node.child!) : null;

      return Box(style: styler, child: child);
    });
  }
}
```

#### TextHandler

```dart
class TextHandler extends NodeHandler<TextNode> {
  @override
  Widget build(TextNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = TextStyler();
      styler = _applyTextStyle(styler, node.style, ctx, context);
      styler = _applyVariants(
        styler,
        () => TextStyler(),
        _applyTextStyle,
        node.variants,
        ctx,
        context,
      );
      styler = _applyAnimation(styler, node.animation);

      final text = ctx.resolveValue<String>(node.content, context) ?? '';

      return StyledText(text, style: styler);
    });
  }
}
```

#### FlexHandler

```dart
class FlexHandler extends NodeHandler<FlexNode> {
  @override
  Widget build(FlexNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = FlexBoxStyler();

      // Direction
      final dir = ctx.resolveValue<String>(node.direction, context);
      styler = dir == 'row' ? styler.row() : styler.column();

      // Spacing
      final spacing = ctx.resolveValue<double>(node.spacing, context);
      if (spacing != null) styler = styler.spacing(spacing);

      // Alignment
      final cross = ctx.resolveValue<String>(node.crossAxisAlignment, context);
      if (cross != null) styler = styler.crossAxisAlignment(_parseCrossAxis(cross));
      final main = ctx.resolveValue<String>(node.mainAxisAlignment, context);
      if (main != null) styler = styler.mainAxisAlignment(_parseMainAxis(main));

      // Container-level style properties (same methods as BoxStyler via shared mixins)
      // FlexBoxStyler is NOT a BoxStyler subtype — it's a sibling that shares
      // SpacingStyleMixin, ConstraintStyleMixin, DecorationStyleMixin, etc.
      styler = _applyContainerProps(styler, node.style, ctx, context);
      styler = _applyVariants(
        styler,
        () => FlexBoxStyler(),
        _applyContainerProps,
        node.variants,
        ctx,
        context,
      );
      styler = _applyAnimation(styler, node.animation);

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return FlexBox(style: styler, children: children);
    });
  }

  /// Inlined container property switch for FlexBoxStyler (same properties as
  /// _applyContainerStyle but typed for FlexBoxStyler).
  FlexBoxStyler _applyContainerProps(
    FlexBoxStyler styler,
    Map<String, SchemaValue>? style,
    RenderContext ctx,
    BuildContext context,
  ) {
    if (style == null) return styler;
    for (final entry in style.entries) {
      final resolved = ctx.resolveValue<dynamic>(entry.value, context);
      if (resolved == null) continue;
      styler = switch (entry.key) {
        'backgroundColor' => styler.color(resolved as Color),
        'padding' => styler.paddingAll(resolved as double),
        'paddingX' => styler.paddingX(resolved as double),
        'paddingY' => styler.paddingY(resolved as double),
        'margin' => styler.marginAll(resolved as double),
        'width' => styler.width(resolved as double),
        'height' => styler.height(resolved as double),
        'borderRadius' => styler.borderRounded(resolved as double),
        _ => _skipUnknown(styler, entry.key, ctx),
      };
    }
    return styler;
  }
}
```

#### StackHandler

```dart
class StackHandler extends NodeHandler<StackNode> {
  @override
  Widget build(StackNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = StackBoxStyler();

      final alignment = ctx.resolveValue<String>(node.alignment, context);
      if (alignment != null) styler = styler.alignment(_parseAlignment(alignment));

      // Container-level style — same approach as FlexHandler (StackBoxStyler is a
      // MixStyler sibling, not a BoxStyler subtype).
      styler = _applyContainerProps(styler, node.style, ctx, context);
      styler = _applyVariants(
        styler,
        () => StackBoxStyler(),
        _applyContainerProps,
        node.variants,
        ctx,
        context,
      );
      styler = _applyAnimation(styler, node.animation);

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return StackBox(style: styler, children: children);
    });
  }

  StackBoxStyler _applyContainerProps(
    StackBoxStyler styler,
    Map<String, SchemaValue>? style,
    RenderContext ctx,
    BuildContext context,
  ) {
    if (style == null) return styler;
    for (final entry in style.entries) {
      final resolved = ctx.resolveValue<dynamic>(entry.value, context);
      if (resolved == null) continue;
      styler = switch (entry.key) {
        'backgroundColor' => styler.color(resolved as Color),
        'padding' => styler.paddingAll(resolved as double),
        'paddingX' => styler.paddingX(resolved as double),
        'paddingY' => styler.paddingY(resolved as double),
        'margin' => styler.marginAll(resolved as double),
        'width' => styler.width(resolved as double),
        'height' => styler.height(resolved as double),
        'borderRadius' => styler.borderRounded(resolved as double),
        _ => _skipUnknown(styler, entry.key, ctx),
      };
    }
    return styler;
  }
}
```

#### IconHandler

```dart
class IconHandler extends NodeHandler<IconNode> {
  @override
  Widget build(IconNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = IconStyler();
      styler = _applyIconStyle(styler, node.style, ctx, context);
      styler = _applyAnimation(styler, node.animation);

      final iconData = _resolveIcon(ctx.resolveValue(node.icon, context));

      return StyledIcon(icon: iconData, style: styler);
    });
  }
}
```

#### ImageHandler

```dart
class ImageHandler extends NodeHandler<ImageNode> {
  @override
  Widget build(ImageNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = ImageStyler();
      styler = _applyImageStyle(styler, node.style, ctx, context);
      styler = _applyAnimation(styler, node.animation);

      final src = ctx.resolveValue<String>(node.src, context) ?? '';

      return StyledImage(
        NetworkImage(src),
        style: styler,
        semanticLabel: node.alt,
      );
    });
  }
}
```

#### PressableHandler

Note: `PressableBox` is a `StatelessWidget` (not `StyleWidget`). Its `style` parameter takes `BoxStyler?` (optional).

```dart
class PressableHandler extends NodeHandler<PressableNode> {
  @override
  Widget build(PressableNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final child = ctx.buildChild(node.child);

      // Build BoxStyler for press styling (hover/pressed variants)
      BoxStyler? styler;
      if (node.style != null) {
        styler = _applyContainerStyle(BoxStyler(), node.style, ctx, context);
        styler = _applyVariants(
          styler!,
          () => BoxStyler(),
          _applyContainerStyle,
          node.variants,
          ctx,
          context,
        );
      }

      return PressableBox(
        style: styler,
        onPress: () {
          ctx.onEvent?.call(SchemaEvent.tap(
            nodeId: node.nodeId,
            actionId: node.actionId,
          ));
        },
        child: child,
      );
    });
  }
}
```

#### ScrollableHandler

Uses `ScrollViewModifier` — does NOT create a new Spec.

```dart
class ScrollableHandler extends NodeHandler<ScrollableNode> {
  @override
  Widget build(ScrollableNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final child = ctx.buildChild(node.child);
      final dir = ctx.resolveValue<String>(node.direction, context);
      final axis = dir == 'horizontal' ? Axis.horizontal : Axis.vertical;

      // Wrap with ScrollViewModifier via generic modifier factory
      var styler = BoxStyler().wrap(
        WidgetModifierConfig.modifier(
          ScrollViewModifierMix(scrollDirection: axis),
        ),
      );

      return Box(style: styler, child: child);
    });
  }
}
```

#### WrapHandler

Uses Flutter `Wrap` directly (no Mix spec exists for this).

```dart
class WrapHandler extends NodeHandler<WrapNode> {
  @override
  Widget build(WrapNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final spacing = ctx.resolveValue<double>(node.spacing, context) ?? 0;
      final runSpacing = ctx.resolveValue<double>(node.runSpacing, context) ?? 0;

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
      );
    });
  }
}
```

#### InputHandler

Uses Flutter input widgets with Mix-styled containers (no Mix input spec exists).

```dart
class InputHandler extends NodeHandler<InputNode> {
  @override
  Widget build(InputNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      return switch (node.inputType) {
        'text' => _buildTextInput(node, ctx, context),
        'toggle' => _buildToggle(node, ctx, context),
        'slider' => _buildSlider(node, ctx, context),
        'select' => _buildSelect(node, ctx, context),
        'date' => _buildDatePicker(node, ctx, context),
        _ => _buildFallback(node),
      };
    });
  }

  Widget _buildTextInput(InputNode node, RenderContext ctx, BuildContext context) {
    final label = ctx.resolveValue<String>(node.label, context);
    final hint = ctx.resolveValue<String>(node.hint, context);

    return TextField(
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: (value) {
        ctx.onEvent?.call(SchemaEvent.change(
          nodeId: node.nodeId,
          field: node.fieldId,
          value: value,
        ));
      },
    );
  }

  // ... other input builders follow same pattern
}
```

#### RepeatHandler

Control node — iterates data and renders template per item.

```dart
class RepeatHandler extends NodeHandler<RepeatNode> {
  @override
  Widget build(RepeatNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final items = ctx.resolveValue<List>(node.items, context) ?? [];

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            Builder(
              builder: (_) {
                final parentData = ctx.dataContext ?? SchemaDataContext.root();
                final childData = parentData.child(
                  alias: node.itemAlias,
                  item: items[i],
                  index: i,
                );

                return ctx
                    .copyWith(dataContext: childData)
                    .buildChild(node.template);
              },
            ),
        ],
      );
    });
  }
}
```

### 7.5 Shared Style Application Functions

Reusable across handlers. Pattern from `mix_tailwinds` `_applyPropertyToBox()`.

> **Note: Type hierarchy constraint**
>
> `BoxStyler`, `FlexBoxStyler`, and `StackBoxStyler` are **siblings** (all extend `MixStyler` directly), not a subtype chain. They share the same container styling methods (`.paddingAll()`, `.width()`, `.color()`, `.borderRounded()`, etc.) through shared mixins (`SpacingStyleMixin`, `ConstraintStyleMixin`, `DecorationStyleMixin`, `BorderStyleMixin`, `BorderRadiusStyleMixin`), but Dart's type system has no single bound that captures "has these mixin methods". The `_applyContainerStyle` function below is typed for `BoxStyler` and used directly in `BoxHandler` and `PressableHandler`. For `FlexHandler` and `StackHandler`, the same property switch is inlined since `FlexBoxStyler` and `StackBoxStyler` expose identical method names via the same mixins but are distinct types.

```dart
/// Apply container-level style properties to a BoxStyler.
/// FlexHandler and StackHandler inline the same property switch for their
/// respective Styler types (FlexBoxStyler / StackBoxStyler share the same
/// methods via SpacingStyleMixin, ConstraintStyleMixin, etc.).
BoxStyler _applyContainerStyle(
  BoxStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue; // unresolved value — skip gracefully

    styler = switch (entry.key) {
      // Colors
      'backgroundColor' => styler.color(resolved as Color),

      // Spacing
      'padding' => styler.paddingAll(resolved as double),
      'paddingX' => styler.paddingX(resolved as double),
      'paddingY' => styler.paddingY(resolved as double),
      'paddingTop' => styler.paddingTop(resolved as double),
      'paddingBottom' => styler.paddingBottom(resolved as double),
      'paddingLeft' => styler.paddingLeft(resolved as double),
      'paddingRight' => styler.paddingRight(resolved as double),
      'margin' => styler.marginAll(resolved as double),
      'marginX' => styler.marginX(resolved as double),
      'marginY' => styler.marginY(resolved as double),

      // Sizing
      'width' => styler.width(resolved as double),
      'height' => styler.height(resolved as double),
      'minWidth' => styler.minWidth(resolved as double),
      'maxWidth' => styler.maxWidth(resolved as double),
      'minHeight' => styler.minHeight(resolved as double),
      'maxHeight' => styler.maxHeight(resolved as double),

      // Border
      'borderRadius' => styler.borderRounded(resolved as double),

      // Clip
      'clipBehavior' => styler.clipBehavior(_parseClip(resolved as String)),

      // Unknown: skip with diagnostic
      _ => _skipUnknown(styler, entry.key, ctx),
    };
  }

  return styler;
}

/// Emit a diagnostic for an unknown style property and return styler unchanged.
T _skipUnknown<T>(T styler, String property, RenderContext ctx) {
  ctx.diagnostics.add(SchemaDiagnostic(
    code: DiagnosticCode.invalidValueType,
    severity: DiagnosticSeverity.info,
    message: 'Unknown style property "$property" — skipped',
    suggestion: 'Check supported properties for this node type',
  ));
  return styler;
}

/// Apply text-level style properties to a TextStyler.
TextStyler _applyTextStyle(
  TextStyler styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
) {
  if (style == null) return styler;

  for (final entry in style.entries) {
    final resolved = ctx.resolveValue<dynamic>(entry.value, context);
    if (resolved == null) continue;

    styler = switch (entry.key) {
      'color' => styler.color(resolved as Color),
      'fontSize' => styler.fontSize(resolved as double),
      'fontWeight' => styler.fontWeight(_parseFontWeight(resolved)),
      'lineHeight' => styler.height(resolved as double),
      'letterSpacing' => styler.letterSpacing(resolved as double),
      'overflow' => styler.overflow(_parseTextOverflow(resolved as String)),
      'maxLines' => styler.maxLines(resolved as int),
      _ => _skipUnknown(styler, entry.key, ctx),
    };
  }

  return styler;
}
```

## 8. Variant Resolution

### 8.1 Schema → Mix Variant Mapping

All variant methods take a **complete Styler instance** (not a callback). The variant Styler is merged when the variant condition is active. Methods come from two mixins included in all `MixStyler` subclasses:
- `WidgetStateVariantMixin<T, S>`: `.onHovered(T)`, `.onPressed(T)`, `.onFocused(T)`, `.onDisabled(T)`, `.onEnabled(T)`
- `VariantStyleMixin<T, S>`: `.onDark(T)`, `.onLight(T)`, `.onMobile(T)`, `.onTablet(T)`, `.onDesktop(T)`, `.onBreakpoint(Breakpoint, T)`

> **Generic bound rationale**: All concrete Styler types extend `MixStyler<Self, SelfSpec>`, which includes both mixins. The bound `T extends MixStyler<T, S>` guarantees access to `.onHovered()`, `.onDark()`, `.onMobile()`, etc. The factory `T Function()` parameter is needed because we must construct a fresh Styler of the same type for each variant block — Dart can't call `T()` generically.

Pattern from `mix_tailwinds`: use a typed map factory for exhaustive mapping.

```dart
typedef VariantStyleApplier<T> = T Function(
  T styler,
  Map<String, SchemaValue>? style,
  RenderContext ctx,
  BuildContext context,
);

/// Apply variants from the AST to a styler.
/// The factory callback creates a fresh Styler of the same type for building
/// each variant's style properties (e.g., () => BoxStyler(), () => TextStyler()).
T _applyVariants<T extends MixStyler<T, S>, S extends Spec<S>>(
  T styler,
  T Function() factory,
  VariantStyleApplier<T> applyStyle,
  Map<String, SchemaValue>? variants,
  RenderContext ctx,
  BuildContext context,
) {
  if (variants == null) return styler;

  for (final entry in variants.entries) {
    final variantStyler = _buildVariantStyler<T, S>(
      factory,
      applyStyle,
      entry.value,
      ctx,
      context,
    );
    if (variantStyler == null) continue;

    styler = switch (entry.key) {
      // Interaction variants (from WidgetStateVariantMixin)
      'hover' || 'hovered' => styler.onHovered(variantStyler),
      'press' || 'pressed' => styler.onPressed(variantStyler),
      'focus' || 'focused' => styler.onFocused(variantStyler),
      'disabled' => styler.onDisabled(variantStyler),
      'enabled' => styler.onEnabled(variantStyler),

      // Theme variants (from VariantStyleMixin)
      'dark' => styler.onDark(variantStyler),
      'light' => styler.onLight(variantStyler),

      // Breakpoint variants (use convenience methods — Breakpoint.mobile = maxWidth: 767,
      // Breakpoint.tablet = 768-1023, Breakpoint.desktop = minWidth: 1024)
      'mobile' => styler.onMobile(variantStyler),
      'tablet' => styler.onTablet(variantStyler),
      'desktop' => styler.onDesktop(variantStyler),

      _ => styler, // unknown variant — skip
    };
  }

  return styler;
}

/// Build a variant Styler from a variant's style map.
/// Returns null if the variant value can't be resolved to a style map.
T? _buildVariantStyler<T extends MixStyler<T, S>, S extends Spec<S>>(
  T Function() factory,
  VariantStyleApplier<T> applyStyle,
  SchemaValue variantValue,
  RenderContext ctx,
  BuildContext context,
) {
  // Adapter normalization contract: variant blocks must arrive as
  // DirectValue<Map<String, SchemaValue>>.
  final variantStyle = switch (variantValue) {
    DirectValue<Map<String, SchemaValue>>(:final value) => value,
    _ => null,
  };
  if (variantStyle == null) return null;

  return applyStyle(factory(), variantStyle, ctx, context);
}
```

### 8.2 Animation Application

The `.animate()` method is on `AnimationStyleMixin<T, S>`, which is included in `MixStyler`. It accepts `AnimationConfig` (base type). `CurveAnimationConfig` extends `AnimationConfig` and can be passed directly. There is also a convenience factory `AnimationConfig.curve(duration:, curve:, delay:)` that constructs a `CurveAnimationConfig` internally. Both work.

```dart
T _applyAnimation<T extends MixStyler<T, S>, S extends Spec<S>>(
  T styler,
  SchemaAnimation? anim,
) {
  if (anim == null) return styler;

  return styler.animate(CurveAnimationConfig(
    duration: Duration(milliseconds: anim.durationMs),
    curve: _parseCurve(anim.curve),
    delay: anim.delayMs != null ? Duration(milliseconds: anim.delayMs!) : Duration.zero,
  ));
}

Curve _parseCurve(String? name) {
  return switch (name) {
    'linear' => Curves.linear,
    'easeIn' => Curves.easeIn,
    'easeOut' => Curves.easeOut,
    'easeInOut' => Curves.easeInOut,
    'bounceIn' => Curves.bounceIn,
    'bounceOut' => Curves.bounceOut,
    'elasticIn' => Curves.elasticIn,
    'elasticOut' => Curves.elasticOut,
    _ => Curves.easeOut, // default
  };
}
```

## 9. Events & Actions

Adopted from the Flutter GenUI v0 event/action contracts — no parallel vocabulary.

### 9.1 Events (UI → Agent)

```dart
// events/schema_event.dart

sealed class SchemaEvent {
  final String nodeId;
  final DateTime timestamp;

  SchemaEvent({required this.nodeId}) : timestamp = DateTime.now();

  factory SchemaEvent.tap({required String nodeId, String? actionId}) = TapEvent;
  factory SchemaEvent.change({required String nodeId, required String field, dynamic value}) = ChangeEvent;
  factory SchemaEvent.submit({required String nodeId, required Map<String, dynamic> formData}) = SubmitEvent;
  factory SchemaEvent.select({required String nodeId, required List<dynamic> selected}) = SelectEvent;
  factory SchemaEvent.dismiss({required String nodeId, String? reason}) = DismissEvent;
  factory SchemaEvent.scrollEnd({required String nodeId}) = ScrollEndEvent;
}

final class TapEvent extends SchemaEvent { final String? actionId; ... }
final class ChangeEvent extends SchemaEvent { final String field; final dynamic value; ... }
final class SubmitEvent extends SchemaEvent { final Map<String, dynamic> formData; ... }
final class SelectEvent extends SchemaEvent { final List<dynamic> selected; ... }
final class DismissEvent extends SchemaEvent { final String? reason; ... }
final class ScrollEndEvent extends SchemaEvent { ... }
```

### 9.2 Actions (Agent → UI)

```dart
// events/schema_action.dart

sealed class SchemaAction {
  final String type;
  final ActionRisk risk;

  const SchemaAction({required this.type, required this.risk});
}

enum ActionRisk { low, medium, high }

final class NavigateAction extends SchemaAction { final String to; final Map<String, dynamic>? params; ... }
final class OpenUrlAction extends SchemaAction { final String url; final bool external; ... }
final class SetStateAction extends SchemaAction { final String path; final dynamic value; ... }
final class ShowDialogAction extends SchemaAction { final String title; final String body; ... }
final class ShowSnackbarAction extends SchemaAction { final String message; ... }
final class DismissAction extends SchemaAction { ... }
final class ResetStateAction extends SchemaAction { final List<String>? paths; ... }
final class RequestAction extends SchemaAction { final String method; final String url; ... }
final class RefreshAction extends SchemaAction { final String? screenId; ... }
final class EmitEventAction extends SchemaAction { final String name; final Map<String, dynamic>? params; ... }
final class LogEventAction extends SchemaAction { final String name; final Map<String, dynamic>? params; ... }
final class SequenceAction extends SchemaAction { final List<SchemaAction> steps; ... }
final class ConditionalAction extends SchemaAction { final String condition; final SchemaAction then; final SchemaAction? elseAction; ... }
```

### 9.3 Trust → Action Gating

| Trust Level | Low risk | Medium risk | High risk |
|-------------|----------|-------------|-----------|
| `minimal` | Execute | Block | Block |
| `standard` | Execute | Propose-before-execute | Block |
| `elevated` | Execute | Execute | Propose-before-execute |

## 10. Component Expansion Layer

The Flutter GenUI Component Catalog v0 defines ~25 high-level components. These sit above the canonical AST as catalog entries that expand into node trees.

### 10.1 ComponentRegistry

```dart
// components/component_registry.dart

/// Expands a high-level component into a canonical AST subtree.
typedef ComponentExpander = SchemaNode Function(
  Map<String, dynamic> props,
  String nodeId,
);

class ComponentRegistry {
  final Map<String, ComponentExpander> _expanders;

  ComponentRegistry(this._expanders);

  factory ComponentRegistry.defaults() => ComponentRegistry({
    'Card': _expandCard,
    'Button': _expandButton,
    'TextInput': _expandTextInput,
    'Table': _expandTable,
    'ActionGroup': _expandActionGroup,
    // ... remaining catalog components
  });

  /// Returns null if the component type is not registered.
  SchemaNode? expand(String componentType, Map<String, dynamic> props, String nodeId) {
    final expander = _expanders[componentType];
    return expander?.call(props, nodeId);
  }
}
```

### 10.2 Top-5 Expansion Examples

**Card**:
```
Card { title, subtitle, children }
  → BoxNode(style: {borderRadius: 12, elevation: 2, padding: 16})
    → FlexNode(direction: "column", spacing: 8)
      → TextNode(content: title, style: {fontSize: 18, fontWeight: "bold"})
      → TextNode(content: subtitle, style: {fontSize: 14, color: "color.onSurfaceVariant"})
      → ...children
```

**Button**:
```
Button { label, actionId, variant }
  → PressableNode(actionId: actionId)
    → BoxNode(style: variant-dependent)
      → TextNode(content: label, style: {fontWeight: "medium"})
```

**TextInput**:
```
TextInput { id, label, hint }
  → InputNode(inputType: "text", fieldId: id, label: label, hint: hint)
```

**Table**:
```
Table { columns, rows }
  → FlexNode(direction: "column")
    → FlexNode(direction: "row")  // header
      → [TextNode(style: bold) for each column]
    → RepeatNode(items: rows, template:
        FlexNode(direction: "row")
          → [TextNode for each cell])
```

**ActionGroup**:
```
ActionGroup { children, alignment }
  → FlexNode(direction: "row", mainAxisAlignment: alignment, spacing: 8)
    → ...children (expanded buttons/chips)
```

## 11. Public API

### 11.1 SchemaEngine

```dart
// engine.dart

class SchemaEngine {
  final Map<String, WireAdapter> _adapters;
  final SchemaValidator _validator;
  final SchemaRenderer _renderer;
  final ComponentRegistry _components;

  SchemaEngine({
    List<WireAdapter>? adapters,
    SchemaValidator? validator,
    SchemaRenderer? renderer,
    ComponentRegistry? components,
  })  : _adapters = {for (final a in (adapters ?? [])) a.id: a},
        _validator = validator ?? DefaultSchemaValidator(),
        _renderer = renderer ?? SchemaRenderer(),
        _components = components ?? ComponentRegistry.defaults();

  /// Adapt a wire payload to canonical AST.
  AdaptResult adapt(Object wirePayload, {required String adapterId, SchemaTrust trust = SchemaTrust.standard}) {
    final adapter = _adapters[adapterId];
    if (adapter == null) throw ArgumentError('Unknown adapter: $adapterId');
    return adapter.adapt(wirePayload, AdaptContext(trust: trust));
  }

  /// Validate a canonical AST.
  ValidationResult validate(UiSchemaRoot root, {SchemaTrust? trust}) {
    return _validator.validate(root, ValidationContext(trust: trust ?? root.trust));
  }

  /// Build a Flutter widget tree from canonical AST.
  Widget build(UiSchemaRoot root, {void Function(SchemaEvent)? onEvent}) {
    return _renderer.render(root, trust: root.trust, onEvent: onEvent);
  }
}
```

### 11.2 SchemaWidget

```dart
// render/schema_widget.dart

class SchemaWidget extends StatelessWidget {
  final UiSchemaRoot schema;
  final SchemaTrust? trust;
  final void Function(SchemaEvent)? onEvent;
  final Widget Function(List<SchemaDiagnostic>)? onError;

  const SchemaWidget({
    super.key,
    required this.schema,
    this.trust,
    this.onEvent,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final engine = SchemaScope.engineOf(context);
    final validation = engine.validate(schema, trust: trust);

    if (!validation.isValid && onError != null) {
      return onError!(validation.diagnostics);
    }

    return engine.build(schema, onEvent: onEvent);
  }
}
```

### 11.3 SchemaScope

Follows `TwScope` pattern from `mix_tailwinds`: wraps `MixScope` + provides schema config.

```dart
// render/schema_scope.dart

class SchemaScope extends InheritedWidget {
  final SchemaEngine engine;
  final SchemaTrust trust;

  const SchemaScope({
    super.key,
    required this.engine,
    required this.trust,
    required super.child,
  });

  static SchemaEngine engineOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SchemaScope>()!.engine;
  }

  static SchemaTrust trustOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SchemaScope>()!.trust;
  }

  @override
  bool updateShouldNotify(SchemaScope oldWidget) {
    return engine != oldWidget.engine || trust != oldWidget.trust;
  }
}
```

## 12. Trust Model

```dart
// trust/schema_trust.dart

enum SchemaTrust {
  minimal,   // Safest — limited depth, count, actions
  standard,  // Default — balanced safety/capability
  elevated,  // Full capability — requires explicit opt-in
}

// trust/capability_matrix.dart

/// How an action is handled given trust level + risk.
enum ActionPolicy { execute, proposeBeforeExecute, block }

class TrustCapabilities {
  final int maxDepth;
  final int maxNodeCount;
  final int maxAnimatedNodes;

  const TrustCapabilities({
    required this.maxDepth,
    required this.maxNodeCount,
    required this.maxAnimatedNodes,
  });

  static const minimal = TrustCapabilities(
    maxDepth: 5,
    maxNodeCount: 50,
    maxAnimatedNodes: 5,
  );

  static const standard = TrustCapabilities(
    maxDepth: 10,
    maxNodeCount: 200,
    maxAnimatedNodes: 20,
  );

  static const elevated = TrustCapabilities(
    maxDepth: 20,
    maxNodeCount: 1000,
    maxAnimatedNodes: 50,
  );

  static TrustCapabilities forTrust(SchemaTrust trust) => switch (trust) {
    SchemaTrust.minimal => minimal,
    SchemaTrust.standard => standard,
    SchemaTrust.elevated => elevated,
  };

  /// Determines how an action at a given risk level should be handled.
  /// Matches the §9.3 Trust → Action Gating table exactly.
  static ActionPolicy policyFor(SchemaTrust trust, ActionRisk risk) {
    return switch ((trust, risk)) {
      // minimal: only low risk executes
      (SchemaTrust.minimal, ActionRisk.low)    => ActionPolicy.execute,
      (SchemaTrust.minimal, ActionRisk.medium) => ActionPolicy.block,
      (SchemaTrust.minimal, ActionRisk.high)   => ActionPolicy.block,

      // standard: low executes, medium proposes, high blocks
      (SchemaTrust.standard, ActionRisk.low)    => ActionPolicy.execute,
      (SchemaTrust.standard, ActionRisk.medium) => ActionPolicy.proposeBeforeExecute,
      (SchemaTrust.standard, ActionRisk.high)   => ActionPolicy.block,

      // elevated: low+medium execute, high proposes
      (SchemaTrust.elevated, ActionRisk.low)    => ActionPolicy.execute,
      (SchemaTrust.elevated, ActionRisk.medium) => ActionPolicy.execute,
      (SchemaTrust.elevated, ActionRisk.high)   => ActionPolicy.proposeBeforeExecute,
    };
  }
}
```

## 13. Test Strategy

### 13.1 Golden JSON Fixtures

Create `test/fixtures/` with:

**`valid/`**:
- `simple_box.json` — single box with style
- `text_with_tokens.json` — text node using token refs
- `flex_layout.json` — flex with children
- `nested_deep.json` — max-depth tree at standard trust
- `adaptive_colors.json` — adaptive light/dark values
- `responsive_spacing.json` — responsive breakpoint values
- `pressable_with_action.json` — pressable emitting tap event
- `repeat_list.json` — repeat node iterating data

**`invalid/`**:
- `unknown_node_type.json` — triggers `unknownNodeType` diagnostic
- `missing_required_field.json` — text node without content
- `depth_exceeded.json` — exceeds minimal trust depth limit
- `node_count_exceeded.json` — exceeds minimal trust count limit
- `invalid_child_structure.json` — children on a wrapper node

**`lossy/`**:
- `a2ui_v08_deprecated_fields.json` — fields that exist in v0.8 but not canonical AST
- `unknown_token_type.json` — token ref with unsupported type
- `unknown_transform.json` — transform key not in closed registry

### 13.2 Test Categories

**Adapter tests** (`test/adapters/`):
- Round-trip: parse golden fixture → produce `UiSchemaRoot` → verify structure
- Lossy: parse lossy fixture → verify correct diagnostics emitted
- Token normalization: verify shorthand strings → `TokenRef` objects

**Validator tests** (`test/validate/`):
- Each diagnostic code has positive (should pass) + negative (should fail) case
- Trust boundary: same payload at different trust levels → different results
- Semantic: interactive nodes with/without role

**Handler tests** (`test/render/`):
- Widget test per handler: render fixture → verify correct Mix widget type in tree
- Verify styler methods called (via matching rendered widget properties)
- Verify events emitted on interaction (tap, change)

**Integration tests** (`test/integration/`):
- Full pipeline: adapt → validate → render → interact → verify event
- SchemaWidget with SchemaScope: verify token resolution through MixScope
- Trust enforcement: elevated vs minimal trust → different rendering behavior

## 14. Implementation Phases

### Phase 1: AST + Value Model + Diagnostics (no Flutter dependency)

**Scope**: Pure Dart classes — can be tested without Flutter.

Files to create:
- `ast/schema_node.dart` (sealed hierarchy)
- `ast/schema_values.dart` (value hierarchy)
- `ast/schema_semantics.dart`
- `ast/ui_schema_root.dart`
- `validate/diagnostics.dart` (codes + severity)
- `trust/schema_trust.dart`
- `trust/capability_matrix.dart`
- `events/schema_event.dart`
- `events/schema_action.dart`

Tests: Unit tests for AST construction, equality, trust capabilities.

**Depends on**: Nothing.

### Phase 2: Adapter + Validator (parallel with Phase 3)

**Scope**: Wire format parsing and validation rules.

Files to create:
- `adapters/wire_adapter.dart`
- `adapters/a2ui_v09_adapter.dart`
- `adapters/a2ui_v08_adapter.dart`
- `validate/schema_validator.dart`
- `validate/structural_rules.dart`
- `validate/trust_rules.dart`
- `validate/semantic_rules.dart`
- All `test/fixtures/`
- Tests for adapters and validators

**Depends on**: Phase 1 (AST classes).

### Phase 3: Renderer + 5 Core Handlers (parallel with Phase 2)

**Scope**: Rendering pipeline + box, text, flex, stack, icon handlers.

Files to create:
- `render/schema_renderer.dart`
- `render/schema_registry.dart`
- `render/schema_widget.dart`
- `render/schema_scope.dart`
- `tokens/schema_token_resolver.dart`
- `render/handlers/box_handler.dart`
- `render/handlers/text_handler.dart`
- `render/handlers/flex_handler.dart`
- `render/handlers/stack_handler.dart`
- `render/handlers/icon_handler.dart`
- `engine.dart` (SchemaEngine facade)

Tests: Widget tests per handler, integration test for full pipeline.

**Depends on**: Phase 1 (AST classes).

### Phase 4: Remaining Handlers

**Scope**: image, pressable, scrollable, wrap, input, repeat handlers.

Files to create:
- `render/handlers/image_handler.dart`
- `render/handlers/pressable_handler.dart`
- `render/handlers/scrollable_handler.dart`
- `render/handlers/wrap_handler.dart`
- `render/handlers/input_handler.dart`
- `render/handlers/repeat_handler.dart`

**Depends on**: Phase 3 (renderer architecture).

### Phase 5: Component Expansion Layer

**Scope**: Catalog → AST expansion templates for top-5 components.

Files to create:
- `components/component_registry.dart`
- `components/expansion_templates.dart`

**Depends on**: Phase 3 (handlers exist to render expanded trees).

### Phase 6: Events + Actions + Interaction Pipeline

**Scope**: Full event/action processing, trust-gated execution, propose-before-execute.

**Depends on**: Phase 4 (pressable + input handlers emit events).

### Phase 7: Hardening

**Scope**: Performance budgets, accessibility audit, fuzz testing, documentation.

- Profile render times for complex schemas
- Verify Semantics widgets on all interactive handlers
- Fuzz adapter with malformed JSON payloads
- API documentation (dartdoc)

**Depends on**: Phase 6 (all features complete).

## 15. Patterns Reused from mix_tailwinds

These patterns are proven in `mix_tailwinds` and transfer directly.

| Pattern | mix_tailwinds source | mix_schema equivalent |
|---------|---------------------|----------------------|
| Property-to-Styler switch | `_applyPropertyToBox()` in `tw_parser.dart` | `_applyContainerStyle()` + per-handler `_applyContainerProps()` |
| Accumulator for multi-token props | `_BorderAccum`, `_GradientAccum`, `_TransformAccumTracker` | Use for composed properties (border sides + color, gradient stops) |
| Variant map factory | `_flexVariants`, `_boxVariants`, `_textVariants` maps | `_applyVariants()` with string → Mix variant mapping |
| Config scoping | `TwScope` = `MixScope` + `TwConfigProvider` | `SchemaScope` = `MixScope` + `SchemaEngine` |
| Animation config | `parseAnimationFromTokens()` → `CurveAnimationConfig` | `_applyAnimation()` → `CurveAnimationConfig` |
| CSS semantic margin | Strip margin from spec, apply outside `MixInteractionDetector` | Same pattern for `PressableHandler` |
| WidgetModifier wrapping | `styler.wrap(WidgetModifierConfig.blur())` | `styler.wrap(WidgetModifierConfig.modifier(ScrollViewModifierMix(...)))` for scrollable |
| Responsive resolution | `_parseResponsiveToken()` → highest active breakpoint wins | `ResponsiveValue` resolution → same cascade logic |

## 16. Reference Files

### Contracts And Inputs

- `mix_schema_v0.1_freeze.md` — frozen execution contract for this repository
- Flutter GenUI v0 Contract — event model reference (external knowledge-base input)
- Flutter GenUI Actions v0 — action whitelist + risk levels (external knowledge-base input)
- Flutter GenUI Component Catalog v0 — component catalog reference (external knowledge-base input)
- mix_tailwinds as mix_schema Existence Proof — design-pattern reference (external knowledge-base input)

### Mix 2.0 Codebase (implementation reference)

All at `packages/mix/lib/src/`:

| Directory | Key files | Purpose |
|-----------|-----------|---------|
| `specs/box/` | `box_spec.dart`, `box_style.dart`, `box_widget.dart` | BoxSpec/BoxStyler/Box |
| `specs/text/` | `text_spec.dart`, `text_style.dart`, `text_widget.dart` | TextSpec/TextStyler/StyledText |
| `specs/icon/` | `icon_spec.dart`, `icon_style.dart`, `icon_widget.dart` | IconSpec/IconStyler/StyledIcon |
| `specs/image/` | `image_spec.dart`, `image_style.dart`, `image_widget.dart` | ImageSpec/ImageStyler/StyledImage |
| `specs/flex/` | `flex_spec.dart`, `flex_style.dart` | FlexSpec (used via FlexBox) |
| `specs/flexbox/` | `flexbox_spec.dart`, `flexbox_style.dart`, `flexbox_widget.dart` | FlexBoxSpec/FlexBoxStyler/FlexBox |
| `specs/stack/` | `stack_spec.dart`, `stack_style.dart` | StackSpec (used via StackBox) |
| `specs/stackbox/` | `stackbox_spec.dart`, `stackbox_style.dart`, `stackbox_widget.dart` | StackBoxSpec/StackBoxStyler/StackBox |
| `specs/pressable/` | `pressable_widget.dart` | Pressable/PressableBox widgets |
| `theme/tokens/` | `value_tokens.dart` | 11 MixToken types |
| `theme/` | `mix_theme.dart` | MixScope InheritedModel |
| `variants/` | `variant.dart`, `variant_util.dart` | Variant hierarchy + context variants |
| `modifiers/` | `scroll_view_modifier.dart` + 20 others | Widget modifiers |

Also: `packages/mix_tailwinds/lib/src/` for pattern reference.

## Related

- Mix GenUI Integration — project tracker
- Mix GenUI Pitch Deck — pitch deck this implementation enables
- MOC — Architecture — architecture notes index
