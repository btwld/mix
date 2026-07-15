import 'dart:convert';
import 'dart:typed_data';

import 'package:mix_protocol/mix_protocol.dart';

import '../artifacts/component_document.dart';
import '../artifacts/component_parser.dart';

/// Strictly projects built-in Mix leaf styles into canonical protocol JSON.
///
/// Mix Protocol retains ordered Prop sources, literal and token references,
/// directives, and widget-state variants. A producer-specific composite style
/// stays outside the protocol: adapters extract its built-in leaf stylers and
/// pass those leaves to [projectComposite].
final class AtlasCompositeStyleProjector {
  final MixProtocolEncodeOptions options;

  const AtlasCompositeStyleProjector({
    this.options = const MixProtocolEncodeOptions(),
  });

  Map<String, Object?> projectStyle(Object style, {String path = 'style'}) {
    final result = mixProtocol.encodeStyle(style, options: options);

    return switch (result) {
      MixProtocolSuccess<JsonMap>(:final value) => Map.unmodifiable(value),
      MixProtocolFailure<JsonMap>(:final errors) =>
        throw AtlasPortableProjectionException(path: path, errors: errors),
    };
  }

  Map<String, Map<String, Object?>> projectComposite<T>(
    T composite, {
    required Map<String, Object> Function(T style) slots,
    String path = 'style',
  }) {
    final leaves = slots(composite);

    return Map.unmodifiable({
      for (final entry in leaves.entries)
        entry.key: projectStyle(entry.value, path: '$path/${entry.key}'),
    });
  }
}

final class AtlasPortableProjectionException implements Exception {
  final String path;
  final List<MixProtocolError> errors;

  AtlasPortableProjectionException({
    required this.path,
    required List<MixProtocolError> errors,
  }) : errors = List.unmodifiable(errors);

  @override
  String toString() {
    final details = errors
        .map(
          (error) => '${error.code.wireValue} ${error.path}: ${error.message}',
        )
        .join('; ');

    return 'AtlasPortableProjectionException($path): $details';
  }
}

/// Typed producer API for one strict component-v2 document.
final class AtlasPortableComponentBuilder {
  final String id;
  final String label;
  final AtlasCompositeStyleProjector projector;
  final List<ComponentPropertyDefinition> _properties = [];
  final List<ComponentStateDefinition> _states = [];
  final List<ComponentSlotDefinition> _slots = [];
  final List<ComponentAnatomyNode> _nodes = [];
  final List<PortableComponentRecipe> _recipes = [];
  final Map<String, ComponentStyleLibraryEntry> _styles = {};
  final List<ComponentVisualOracle> _oracles = [];
  final List<ComponentDiagnostic> _diagnostics = [];
  String? _rootNodeId;
  ComponentSemanticsContract? _semantics;

  AtlasPortableComponentBuilder({
    required this.id,
    required this.label,
    this.projector = const AtlasCompositeStyleProjector(),
  });

  AtlasPortableComponentBuilder property(
    ComponentPropertyDefinition definition,
  ) {
    _properties.add(definition);

    return this;
  }

  AtlasPortableComponentBuilder state(ComponentStateDefinition definition) {
    _states.add(definition);

    return this;
  }

  AtlasPortableComponentBuilder slot(ComponentSlotDefinition definition) {
    _slots.add(definition);

    return this;
  }

  AtlasPortableComponentBuilder node(AtlasPortableNode node) {
    _nodes.add(node);

    return this;
  }

  AtlasPortableComponentBuilder root(String nodeId) {
    _rootNodeId = nodeId;

    return this;
  }

  /// Adds a recipe and strictly projects every supplied Mix leaf style.
  AtlasPortableComponentBuilder recipe({
    required String id,
    String? label,
    Map<String, Object?> properties = const {},
    required Map<String, Object> styles,
  }) {
    final references = <String, ComponentSlotStyleReference>{};
    for (final entry in styles.entries) {
      final styleId = '$id/${entry.key}';
      if (_styles.containsKey(styleId)) {
        throw ArgumentError('Duplicate portable style ID "$styleId".');
      }
      _styles[styleId] = ComponentStyleLibraryEntry(
        id: styleId,
        document: projector.projectStyle(
          entry.value,
          path: '${this.id}/recipes/$id/styles/${entry.key}',
        ),
      );
      references[entry.key] = ComponentSlotStyleReference.supported(
        styleId: styleId,
      );
    }
    _recipes.add(
      PortableComponentRecipe(
        id: id,
        label: label,
        properties: properties,
        styles: references,
      ),
    );

    return this;
  }

  AtlasPortableComponentBuilder semantics(AtlasPortableSemantics semantics) {
    _semantics = semantics;

    return this;
  }

  AtlasPortableComponentBuilder oracle(ComponentVisualOracle oracle) {
    _oracles.add(oracle);

    return this;
  }

  AtlasPortableComponentBuilder diagnostic(ComponentDiagnostic diagnostic) {
    _diagnostics.add(diagnostic);

    return this;
  }

  /// Returns canonical JSON after running the same strict parser as the app.
  Map<String, Object?> buildJson() {
    final rootNodeId = _rootNodeId;
    final semantics = _semantics;
    if (rootNodeId == null || semantics == null) {
      throw StateError('Portable component root and semantics are required.');
    }
    final payload = <String, Object?>{
      'schema': 'mix_atlas/component/v2',
      'id': id,
      'label': label,
      'properties': _properties.map(_propertyJson).toList(),
      'states': _states.map(_stateJson).toList(),
      'slots': _slots.map(_slotJson).toList(),
      'anatomy': {'root': rootNodeId, 'nodes': _nodes.map(_nodeJson).toList()},
      'recipes': _recipes.map(_recipeJson).toList(),
      'styles': {
        for (final entry in _styles.entries) entry.key: entry.value.document,
      },
      'semantics': _semanticsJson(semantics),
      'oracles': _oracles.map(_oracleJson).toList(),
      if (_diagnostics.isNotEmpty)
        'diagnostics': _diagnostics.map(_diagnosticJson).toList(),
    };
    final canonical = utf8.encode(jsonEncode(payload));
    parsePortableComponentDocument(
      Uint8List.fromList(canonical),
      path: '$id.component.json',
    );

    return Map.unmodifiable(payload);
  }

  PortableComponentDocument buildDocument() {
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(buildJson())));

    return parsePortableComponentDocument(bytes, path: '$id.component.json');
  }
}

Map<String, Object?> _propertyJson(ComponentPropertyDefinition property) => {
  'id': property.id,
  'kind': switch (property.kind) {
    .enumeration => 'enum',
    .string => 'string',
    .boolean => 'boolean',
    .number => 'number',
    .duration => 'duration',
    .icon => 'icon',
  },
  if (property.kind == .enumeration) 'values': property.values,
  'required': property.isRequired,
  'default': property.defaultValue,
};

Map<String, Object?> _stateJson(ComponentStateDefinition state) => {
  'id': state.id,
  'label': ?state.label,
  'widgetStates': state.widgetStates.toList()..sort(),
  'properties': state.propertyOverrides,
};

Map<String, Object?> _slotJson(ComponentSlotDefinition slot) => {
  'id': slot.id,
  'kind': switch (slot.kind) {
    .box => 'box',
    .flexBox => 'flex_box',
    .stackBox => 'stack_box',
    .text => 'text',
    .icon => 'icon',
    .image => 'image',
    .spinner => 'spinner',
    .fractionalPosition => 'fractional_position',
    .nestedComponent => 'nested_component',
  },
};

Map<String, Object?> _nodeJson(ComponentAnatomyNode node) => {
  'id': node.id,
  'kind': switch (node.kind) {
    .box => 'box',
    .flexBox => 'flex_box',
    .stackBox => 'stack_box',
    .text => 'text',
    .icon => 'icon',
    .image => 'image',
    .spinner => 'spinner',
    .fractionalPosition => 'fractional_position',
    .nestedComponent => 'nested_component',
    .stack || .slot => throw ArgumentError(
      'Component-v1 nodes cannot be generated in component-v2.',
    ),
  },
  'slot': ?node.slotId,
  'children': node.children,
  if (node.bindings.isNotEmpty)
    'bindings': {
      for (final entry in node.bindings.entries)
        entry.key: entry.value.toJson(),
    },
  if (node.visibleWhen != null)
    'visibleWhen': _conditionJson(node.visibleWhen!),
  if (node.maintainedFeatures.isNotEmpty)
    'maintain': node.maintainedFeatures.toList()..sort(),
  'component': ?node.componentId,
  'recipe': ?node.recipeBinding?.toJson(),
  'state': ?node.stateBinding?.toJson(),
  if (node.propertyBindings.isNotEmpty)
    'properties': {
      for (final entry in node.propertyBindings.entries)
        entry.key: entry.value.toJson(),
    },
};

Map<String, Object?> _conditionJson(ComponentVisibilityCondition condition) => {
  if (condition.source == .property)
    'property': condition.propertyId
  else
    'state': condition.widgetState,
  'operator': switch (condition.operator) {
    .equals => 'equals',
    .notEquals => 'not_equals',
    .present => 'present',
    .absent => 'absent',
    .active => 'active',
    .inactive => 'inactive',
  },
  if ({
    ComponentConditionOperator.equals,
    ComponentConditionOperator.notEquals,
  }.contains(condition.operator))
    'value': condition.value,
};

Map<String, Object?> _recipeJson(PortableComponentRecipe recipe) => {
  'id': recipe.id,
  'label': ?recipe.label,
  'properties': recipe.properties,
  'styles': {
    for (final entry in recipe.styles.entries) entry.key: entry.value.styleId,
  },
};

Map<String, Object?> _semanticsJson(ComponentSemanticsContract semantics) => {
  'role': semantics.role,
  'bindings': {
    for (final entry in semantics.bindings.entries)
      entry.key: entry.value.toJson(),
  },
};

Map<String, Object?> _oracleJson(ComponentVisualOracle oracle) => {
  'theme': oracle.themeId,
  'image': oracle.imagePath,
  'metadata': oracle.metadataPath,
  'evidence': oracle.evidence.name,
};

Map<String, Object?> _diagnosticJson(ComponentDiagnostic diagnostic) => {
  'code': diagnostic.code,
  'severity': diagnostic.severity,
  'path': diagnostic.path,
  'message': diagnostic.message,
};
