import 'dart:collection';

enum ComponentPropertyKind { enumeration, string, boolean, icon }

enum ComponentSlotKind { flexBox, text, icon, spinner }

enum ComponentEvidence { declared, effective, resolved, rendered }

enum ComponentSupportStatus { supported, unsupported }

enum ComponentAnatomyNodeKind { stack, slot }

enum ComponentConditionOperator { equals, present }

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
  final Set<String> widgetStates;
  final Map<String, Object?> propertyOverrides;

  ComponentStateDefinition({
    required this.id,
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

final class ComponentVisibilityCondition {
  final String propertyId;
  final ComponentConditionOperator operator;
  final Object? value;

  const ComponentVisibilityCondition({
    required this.propertyId,
    required this.operator,
    this.value,
  });
}

final class ComponentAnatomyNode {
  final String id;
  final ComponentAnatomyNodeKind kind;
  final String? alignment;
  final String? slotId;
  final List<String> children;
  final ComponentVisibilityCondition? visibleWhen;
  final Set<String> maintainedFeatures;

  ComponentAnatomyNode({
    required this.id,
    required this.kind,
    this.alignment,
    this.slotId,
    required List<String> children,
    this.visibleWhen,
    Set<String> maintainedFeatures = const {},
  }) : children = List.unmodifiable(children),
       maintainedFeatures = Set.unmodifiable(maintainedFeatures);
}

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

final class ComponentSlotStyleReference {
  final ComponentSupportStatus status;
  final ComponentEvidence evidence;
  final String? documentPath;
  final List<ComponentDiagnostic> diagnostics;

  ComponentSlotStyleReference({
    required this.status,
    required this.evidence,
    this.documentPath,
    List<ComponentDiagnostic> diagnostics = const [],
  }) : diagnostics = List.unmodifiable(diagnostics);

  bool get isSupported => status == .supported;
}

final class PortableComponentRecipe {
  final String id;
  final Map<String, Object?> properties;
  final Map<String, ComponentSlotStyleReference> styles;

  PortableComponentRecipe({
    required this.id,
    required Map<String, Object?> properties,
    required Map<String, ComponentSlotStyleReference> styles,
  }) : properties = Map.unmodifiable(properties),
       styles = Map.unmodifiable(styles);

  ComponentSlotStyleReference styleFor(String slotId) => styles[slotId]!;
}

final class ComponentSemanticsContract {
  final String role;
  final String labelPropertyId;
  final String enabledPropertyId;
  final String loadingPropertyId;

  const ComponentSemanticsContract({
    required this.role,
    required this.labelPropertyId,
    required this.enabledPropertyId,
    required this.loadingPropertyId,
  });
}

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
  final String id;
  final String label;
  final Map<String, ComponentPropertyDefinition> properties;
  final Map<String, ComponentStateDefinition> states;
  final Map<String, ComponentSlotDefinition> slots;
  final ComponentAnatomy anatomy;
  final List<PortableComponentRecipe> recipes;
  final Map<String, ComponentVisualOracle> oracles;
  final ComponentSemanticsContract semantics;

  PortableComponentDocument({
    required this.id,
    required this.label,
    required Map<String, ComponentPropertyDefinition> properties,
    required Map<String, ComponentStateDefinition> states,
    required Map<String, ComponentSlotDefinition> slots,
    required this.anatomy,
    required List<PortableComponentRecipe> recipes,
    required Map<String, ComponentVisualOracle> oracles,
    required this.semantics,
  }) : properties = UnmodifiableMapView(properties),
       states = UnmodifiableMapView(states),
       slots = UnmodifiableMapView(slots),
       recipes = List.unmodifiable(recipes),
       oracles = UnmodifiableMapView(oracles);
}
