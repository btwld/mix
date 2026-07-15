import 'dart:collection';

/// Supported portable component document revisions.
enum ComponentDocumentSchema { v1, v2 }

/// JSON-safe property kinds exposed by a portable component.
enum ComponentPropertyKind {
  enumeration,
  string,
  boolean,
  number,
  duration,
  icon,
}

/// Stable style-slot kinds.
enum ComponentSlotKind {
  box,
  flexBox,
  stackBox,
  text,
  icon,
  image,
  spinner,
  fractionalPosition,
  nestedComponent,
}

enum ComponentEvidence { declared, effective, resolved, rendered }

/// Kept for component-v1 compatibility.
///
/// Component-v2 rejects unsupported visual styles instead of rendering a
/// placeholder.
enum ComponentSupportStatus { supported, unsupported }

/// Whitelisted viewer primitives. [stack] and [slot] are component-v1 only.
enum ComponentAnatomyNodeKind {
  stack,
  slot,
  box,
  flexBox,
  stackBox,
  text,
  icon,
  image,
  spinner,
  fractionalPosition,
  nestedComponent,
}

enum ComponentConditionSource { property, widgetState }

enum ComponentConditionOperator {
  equals,
  notEquals,
  present,
  absent,
  active,
  inactive,
}

enum AtlasPortableBindingKind { literal, property, token }

/// Safe icon identities implemented by the producer-independent renderer.
const atlasPortableIconIdentities = {
  'add',
  'arrow_back',
  'arrow_downward',
  'arrow_forward',
  'arrow_upward',
  'check',
  'check_circle',
  'chevron_left',
  'chevron_right',
  'close',
  'error',
  'expand_less',
  'expand_more',
  'info',
  'keyboard_arrow_down',
  'keyboard_arrow_up',
  'menu',
  'more_horiz',
  'more_vert',
  'person',
  'radio_button_checked',
  'radio_button_unchecked',
  'remove',
  'search',
  'star',
  'visibility',
  'visibility_off',
  'warning',
};

/// A safe data binding evaluated by the portable renderer.
///
/// Bindings can contain a JSON scalar, reference a declared component
/// property, or reference a captured Mix token. They cannot contain code,
/// paths, reflection handles, or arbitrary object graphs.
final class AtlasPortableBinding {
  final AtlasPortableBindingKind kind;
  final Object? literalValue;
  final String? propertyId;
  final String? tokenKind;
  final String? tokenName;

  const AtlasPortableBinding._({
    required this.kind,
    this.literalValue,
    this.propertyId,
    this.tokenKind,
    this.tokenName,
  });

  const AtlasPortableBinding.literal(Object? value)
    : this._(kind: .literal, literalValue: value);

  const AtlasPortableBinding.property(String propertyId)
    : this._(kind: .property, propertyId: propertyId);

  const AtlasPortableBinding.token({required String kind, required String name})
    : this._(kind: .token, tokenKind: kind, tokenName: name);

  Map<String, Object?> toJson() => switch (kind) {
    .literal => {'literal': literalValue},
    .property => {'property': propertyId},
    .token => {'token': '${tokenKind!}/${tokenName!}'},
  };
}

final class ComponentPropertyDefinition {
  final String id;
  final ComponentPropertyKind kind;
  final List<String> values;
  final Object? defaultValue;
  final bool isRequired;

  ComponentPropertyDefinition({
    required this.id,
    required this.kind,
    List<String> values = const [],
    this.defaultValue,
    required this.isRequired,
  }) : values = List.unmodifiable(values);
}

final class ComponentStateDefinition {
  final String id;
  final String? label;
  final Set<String> widgetStates;
  final Map<String, Object?> propertyOverrides;

  ComponentStateDefinition({
    required this.id,
    this.label,
    required Set<String> widgetStates,
    required Map<String, Object?> propertyOverrides,
  }) : widgetStates = Set.unmodifiable(widgetStates),
       propertyOverrides = Map.unmodifiable(propertyOverrides);
}

final class ComponentSlotDefinition {
  final String id;
  final ComponentSlotKind kind;

  const ComponentSlotDefinition({required this.id, required this.kind});
}

/// A visibility condition over a property or forced widget state.
final class ComponentVisibilityCondition {
  final ComponentConditionSource source;
  final String reference;
  final ComponentConditionOperator operator;
  final Object? value;

  const ComponentVisibilityCondition({
    required String propertyId,
    required this.operator,
    this.value,
  }) : source = .property,
       reference = propertyId;

  const ComponentVisibilityCondition.widgetState({
    required String state,
    required this.operator,
  }) : source = .widgetState,
       reference = state,
       value = null;

  String? get propertyId => source == .property ? reference : null;
  String? get widgetState => source == .widgetState ? reference : null;
}

/// One whitelisted visual node in a portable component tree.
final class ComponentAnatomyNode {
  final String id;
  final ComponentAnatomyNodeKind kind;
  final String? alignment;
  final String? slotId;
  final List<String> children;
  final ComponentVisibilityCondition? visibleWhen;
  final Set<String> maintainedFeatures;
  final Map<String, AtlasPortableBinding> bindings;
  final String? componentId;
  final AtlasPortableBinding? recipeBinding;
  final AtlasPortableBinding? stateBinding;
  final Map<String, AtlasPortableBinding> propertyBindings;

  ComponentAnatomyNode({
    required this.id,
    required this.kind,
    this.alignment,
    this.slotId,
    required List<String> children,
    this.visibleWhen,
    Set<String> maintainedFeatures = const {},
    Map<String, AtlasPortableBinding> bindings = const {},
    this.componentId,
    this.recipeBinding,
    this.stateBinding,
    Map<String, AtlasPortableBinding> propertyBindings = const {},
  }) : children = List.unmodifiable(children),
       maintainedFeatures = Set.unmodifiable(maintainedFeatures),
       bindings = Map.unmodifiable(bindings),
       propertyBindings = Map.unmodifiable(propertyBindings);
}

/// Public producer-facing name for a portable visual node.
typedef AtlasPortableNode = ComponentAnatomyNode;

final class ComponentAnatomy {
  final String rootNodeId;
  final Map<String, ComponentAnatomyNode> nodes;

  ComponentAnatomy({
    required this.rootNodeId,
    required Map<String, ComponentAnatomyNode> nodes,
  }) : nodes = Map.unmodifiable(nodes);

  ComponentAnatomyNode get root => nodes[rootNodeId]!;
}

final class ComponentDiagnostic {
  final String code;
  final String severity;
  final String path;
  final String message;

  const ComponentDiagnostic({
    required this.code,
    required this.severity,
    required this.path,
    required this.message,
  });
}

/// Canonical Mix Protocol style embedded in a component-v2 document.
final class ComponentStyleLibraryEntry {
  final String id;
  final Map<String, Object?> document;

  ComponentStyleLibraryEntry({
    required this.id,
    required Map<String, Object?> document,
  }) : document = UnmodifiableMapView(document);
}

final class ComponentSlotStyleReference {
  final ComponentSupportStatus status;
  final ComponentEvidence evidence;
  final String? documentPath;
  final String? styleId;
  final List<ComponentDiagnostic> diagnostics;

  ComponentSlotStyleReference({
    required this.status,
    required this.evidence,
    this.documentPath,
    this.styleId,
    List<ComponentDiagnostic> diagnostics = const [],
  }) : diagnostics = List.unmodifiable(diagnostics);

  factory ComponentSlotStyleReference.supported({
    String? documentPath,
    String? styleId,
    ComponentEvidence evidence = .declared,
  }) => ComponentSlotStyleReference(
    status: .supported,
    evidence: evidence,
    documentPath: documentPath,
    styleId: styleId,
  );

  factory ComponentSlotStyleReference.unsupported({
    required List<ComponentDiagnostic> diagnostics,
    ComponentEvidence evidence = .declared,
  }) => ComponentSlotStyleReference(
    status: .unsupported,
    evidence: evidence,
    diagnostics: diagnostics,
  );

  bool get isSupported => status == .supported;
}

final class PortableComponentRecipe {
  final String id;
  final String? label;
  final Map<String, Object?> properties;
  final Map<String, ComponentSlotStyleReference> styles;

  PortableComponentRecipe({
    required this.id,
    this.label,
    required Map<String, Object?> properties,
    required Map<String, ComponentSlotStyleReference> styles,
  }) : properties = Map.unmodifiable(properties),
       styles = Map.unmodifiable(styles);

  ComponentSlotStyleReference styleFor(String slotId) => styles[slotId]!;
}

/// Generic, data-only semantics contract for a portable component.
///
/// The keys in [bindings] are Flutter semantics concepts such as `label`,
/// `value`, `enabled`, `checked`, `selected`, `expanded`, and `liveRegion`.
final class ComponentSemanticsContract {
  final String role;
  final Map<String, AtlasPortableBinding> bindings;

  ComponentSemanticsContract({
    required this.role,
    Map<String, AtlasPortableBinding> bindings = const {},
    String? labelPropertyId,
    String? enabledPropertyId,
    String? loadingPropertyId,
  }) : bindings = Map.unmodifiable({
         ...bindings,
         if (labelPropertyId != null)
           'label': AtlasPortableBinding.property(labelPropertyId),
         if (enabledPropertyId != null)
           'enabled': AtlasPortableBinding.property(enabledPropertyId),
         if (loadingPropertyId != null)
           'liveRegion': AtlasPortableBinding.property(loadingPropertyId),
       });

  String? get labelPropertyId => bindings['label']?.propertyId;
  String? get enabledPropertyId => bindings['enabled']?.propertyId;
  String? get loadingPropertyId => bindings['liveRegion']?.propertyId;
}

/// Public producer-facing name for the generic semantics contract.
typedef AtlasPortableSemantics = ComponentSemanticsContract;

/// Internal key used for a decoded component-scoped style.
String componentStyleDocumentKey(String componentId, String styleId) =>
    'component:$componentId:$styleId';

final class ComponentVisualOracle {
  final String themeId;
  final String imagePath;
  final String metadataPath;
  final ComponentEvidence evidence;

  const ComponentVisualOracle({
    required this.themeId,
    required this.imagePath,
    required this.metadataPath,
    required this.evidence,
  });
}

final class PortableComponentDocument {
  final ComponentDocumentSchema schema;
  final String id;
  final String label;
  final Map<String, ComponentPropertyDefinition> properties;
  final Map<String, ComponentStateDefinition> states;
  final Map<String, ComponentSlotDefinition> slots;
  final ComponentAnatomy anatomy;
  final List<PortableComponentRecipe> recipes;
  final Map<String, ComponentStyleLibraryEntry> styleLibrary;
  final Map<String, ComponentVisualOracle> oracles;
  final ComponentSemanticsContract semantics;
  final List<ComponentDiagnostic> diagnostics;

  PortableComponentDocument({
    this.schema = .v1,
    required this.id,
    required this.label,
    required Map<String, ComponentPropertyDefinition> properties,
    required Map<String, ComponentStateDefinition> states,
    required Map<String, ComponentSlotDefinition> slots,
    required this.anatomy,
    required List<PortableComponentRecipe> recipes,
    Map<String, ComponentStyleLibraryEntry> styleLibrary = const {},
    required Map<String, ComponentVisualOracle> oracles,
    required this.semantics,
    List<ComponentDiagnostic> diagnostics = const [],
  }) : properties = UnmodifiableMapView(properties),
       states = UnmodifiableMapView(states),
       slots = UnmodifiableMapView(slots),
       recipes = List.unmodifiable(recipes),
       styleLibrary = UnmodifiableMapView(styleLibrary),
       oracles = UnmodifiableMapView(oracles),
       diagnostics = List.unmodifiable(diagnostics);
}
