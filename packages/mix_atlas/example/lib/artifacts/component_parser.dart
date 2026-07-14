import 'dart:convert';
import 'dart:typed_data';

import 'capture_bundle.dart';
import 'capture_parser.dart';
import 'component_document.dart';

abstract final class ComponentDocumentLimits {
  static const maxProperties = 32;
  static const maxEnumValues = 32;
  static const maxStates = 16;
  static const maxSlots = 32;
  static const maxNodes = 64;
  static const maxNodeChildren = 32;
  static const maxAnatomyDepth = 16;
  static const maxRecipes = 256;
  static const maxDiagnosticsPerStyle = 16;
  static const maxOracles = 16;
}

PortableComponentDocument parsePortableComponentDocument(
  Uint8List bytes, {
  required String path,
}) {
  final root = decodeJsonObject(bytes, path: path);
  _expectKeys(root, const {
    'schema',
    'id',
    'label',
    'properties',
    'states',
    'slots',
    'anatomy',
    'recipes',
    'semantics',
    'oracles',
  }, path: path);
  if (_requiredString(root, 'schema', path: '$path/schema') !=
      'mix_atlas/component/v1') {
    throw ArtifactLoadException(
      .unsupportedSchema,
      'Expected schema to be "mix_atlas/component/v1".',
      path: '$path/schema',
    );
  }

  final id = _identifier(root, 'id', path: '$path/id');
  final label = _requiredString(root, 'label', path: '$path/label');
  final properties = _parseProperties(
    _boundedList(
      root,
      'properties',
      path: '$path/properties',
      maximum: ComponentDocumentLimits.maxProperties,
    ),
    path: '$path/properties',
  );
  final states = _parseStates(
    _boundedList(
      root,
      'states',
      path: '$path/states',
      maximum: ComponentDocumentLimits.maxStates,
    ),
    properties: properties,
    path: '$path/states',
  );
  final slots = _parseSlots(
    _boundedList(
      root,
      'slots',
      path: '$path/slots',
      maximum: ComponentDocumentLimits.maxSlots,
    ),
    path: '$path/slots',
  );
  final anatomy = _parseAnatomy(
    _requiredObject(root, 'anatomy', path: '$path/anatomy'),
    properties: properties,
    slots: slots,
    path: '$path/anatomy',
  );
  final recipes = _parseRecipes(
    _boundedList(
      root,
      'recipes',
      path: '$path/recipes',
      maximum: ComponentDocumentLimits.maxRecipes,
    ),
    properties: properties,
    slots: slots,
    path: '$path/recipes',
  );
  final semantics = _parseSemantics(
    _requiredObject(root, 'semantics', path: '$path/semantics'),
    properties: properties,
    path: '$path/semantics',
  );
  final oracles = _parseOracles(
    _boundedList(
      root,
      'oracles',
      path: '$path/oracles',
      maximum: ComponentDocumentLimits.maxOracles,
    ),
    path: '$path/oracles',
  );

  return PortableComponentDocument(
    id: id,
    label: label,
    properties: properties,
    states: states,
    slots: slots,
    anatomy: anatomy,
    recipes: recipes,
    oracles: oracles,
    semantics: semantics,
  );
}

Map<String, ComponentPropertyDefinition> _parseProperties(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentPropertyDefinition>{};
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    final kindName = _requiredString(value, 'kind', path: '$itemPath/kind');
    final definition = switch (kindName) {
      'enum' => _parseEnumProperty(value, id: id, path: itemPath),
      'string' => _parseScalarProperty(
        value,
        id: id,
        kind: .string,
        path: itemPath,
      ),
      'boolean' => _parseScalarProperty(
        value,
        id: id,
        kind: .boolean,
        path: itemPath,
      ),
      'icon' => _parseIconProperty(value, id: id, path: itemPath),
      _ => throw ArtifactLoadException(
        .malformedJson,
        'Unknown component property kind "$kindName".',
        path: '$itemPath/kind',
      ),
    };
    if (result.containsKey(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Component property identifiers must be unique.',
        path: '$itemPath/id',
      );
    }
    result[id] = definition;
  }

  return result;
}

ComponentPropertyDefinition _parseEnumProperty(
  Map<String, Object?> value, {
  required String id,
  required String path,
}) {
  _expectKeys(value, const {'id', 'kind', 'values', 'default'}, path: path);
  final rawValues = _boundedList(
    value,
    'values',
    path: '$path/values',
    maximum: ComponentDocumentLimits.maxEnumValues,
  );
  final values = <String>[];
  for (var index = 0; index < rawValues.length; index += 1) {
    final enumValue = _asNonEmptyString(
      rawValues[index],
      path: '$path/values/$index',
    );
    if (!values.addIfAbsent(enumValue)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Enum values must be unique.',
        path: '$path/values/$index',
      );
    }
  }
  final defaultValue = _requiredString(value, 'default', path: '$path/default');
  if (!values.contains(defaultValue)) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Enum default must be one of its declared values.',
      path: '$path/default',
    );
  }

  return ComponentPropertyDefinition(
    id: id,
    kind: .enumeration,
    values: values,
    defaultValue: defaultValue,
    isRequired: true,
  );
}

ComponentPropertyDefinition _parseScalarProperty(
  Map<String, Object?> value, {
  required String id,
  required ComponentPropertyKind kind,
  required String path,
}) {
  _expectKeys(value, const {'id', 'kind', 'default'}, path: path);
  _requireKey(value, 'default', path: '$path/default');
  final defaultValue = value['default'];
  final isValid = switch (kind) {
    .string => defaultValue is String,
    .boolean => defaultValue is bool,
    .enumeration || .icon => false,
  };
  if (!isValid) {
    throw ArtifactLoadException(
      .malformedJson,
      'Property default does not match its declared kind.',
      path: '$path/default',
    );
  }

  return ComponentPropertyDefinition(
    id: id,
    kind: kind,
    defaultValue: defaultValue,
    isRequired: true,
  );
}

ComponentPropertyDefinition _parseIconProperty(
  Map<String, Object?> value, {
  required String id,
  required String path,
}) {
  _expectKeys(value, const {'id', 'kind', 'required'}, path: path);
  final required = _requiredBool(value, 'required', path: '$path/required');

  return ComponentPropertyDefinition(id: id, kind: .icon, isRequired: required);
}

Map<String, ComponentStateDefinition> _parseStates(
  List<Object?> values, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  const allowedWidgetStates = {
    'hovered',
    'pressed',
    'focused',
    'disabled',
    'selected',
  };
  final result = <String, ComponentStateDefinition>{};
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'id',
      'widgetStates',
      'properties',
    }, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (result.containsKey(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Component state identifiers must be unique.',
        path: '$itemPath/id',
      );
    }
    final widgetStates = <String>{};
    final rawStates = _asList(
      _requiredValue(value, 'widgetStates', path: '$itemPath/widgetStates'),
      path: '$itemPath/widgetStates',
    );
    if (rawStates.length > allowedWidgetStates.length) {
      throw ArtifactLoadException(
        .malformedJson,
        'Too many widget states.',
        path: '$itemPath/widgetStates',
      );
    }
    for (var stateIndex = 0; stateIndex < rawStates.length; stateIndex += 1) {
      final statePath = '$itemPath/widgetStates/$stateIndex';
      final state = _asNonEmptyString(rawStates[stateIndex], path: statePath);
      if (!allowedWidgetStates.contains(state) || !widgetStates.add(state)) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Widget state must be supported and unique.',
          path: statePath,
        );
      }
    }
    final overrides = _requiredObject(
      value,
      'properties',
      path: '$itemPath/properties',
    );
    for (final entry in overrides.entries) {
      final definition = properties[entry.key];
      if (definition == null) {
        throw ArtifactLoadException(
          .invalidComponent,
          'State override references an unknown property.',
          path: '$itemPath/properties/${entry.key}',
        );
      }
      _validatePropertyValue(
        definition,
        entry.value,
        path: '$itemPath/properties/${entry.key}',
      );
    }
    result[id] = ComponentStateDefinition(
      id: id,
      widgetStates: widgetStates,
      propertyOverrides: overrides,
    );
  }
  final defaultState = result['default'];
  if (defaultState == null || defaultState.widgetStates.isNotEmpty) {
    throw ArtifactLoadException(
      .invalidComponent,
      'A default state with no widget states is required.',
      path: path,
    );
  }

  return result;
}

Map<String, ComponentSlotDefinition> _parseSlots(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentSlotDefinition>{};
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {'id', 'kind'}, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    final kindName = _requiredString(value, 'kind', path: '$itemPath/kind');
    final kind = switch (kindName) {
      'flex_box' => ComponentSlotKind.flexBox,
      'text' => ComponentSlotKind.text,
      'icon' => ComponentSlotKind.icon,
      'spinner' => ComponentSlotKind.spinner,
      _ => throw ArtifactLoadException(
        .malformedJson,
        'Unknown component slot kind "$kindName".',
        path: '$itemPath/kind',
      ),
    };
    if (result.containsKey(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Component slot identifiers must be unique.',
        path: '$itemPath/id',
      );
    }
    result[id] = ComponentSlotDefinition(id: id, kind: kind);
  }

  return result;
}

ComponentAnatomy _parseAnatomy(
  Map<String, Object?> value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required Map<String, ComponentSlotDefinition> slots,
  required String path,
}) {
  _expectKeys(value, const {'root', 'nodes'}, path: path);
  final root = _identifier(value, 'root', path: '$path/root');
  final rawNodes = _boundedList(
    value,
    'nodes',
    path: '$path/nodes',
    maximum: ComponentDocumentLimits.maxNodes,
  );
  final nodes = <String, ComponentAnatomyNode>{};
  final usedSlots = <String>{};
  for (var index = 0; index < rawNodes.length; index += 1) {
    final nodePath = '$path/nodes/$index';
    final node = _asObject(rawNodes[index], path: nodePath);
    final id = _identifier(node, 'id', path: '$nodePath/id');
    if (nodes.containsKey(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Anatomy node identifiers must be unique.',
        path: '$nodePath/id',
      );
    }
    final kindName = _requiredString(node, 'kind', path: '$nodePath/kind');
    final children = _parseIdentifierList(
      node,
      'children',
      path: '$nodePath/children',
      maximum: ComponentDocumentLimits.maxNodeChildren,
    );
    if (kindName == 'stack') {
      _expectKeys(node, const {
        'id',
        'kind',
        'alignment',
        'children',
      }, path: nodePath);
      final alignment = _requiredString(
        node,
        'alignment',
        path: '$nodePath/alignment',
      );
      if (alignment != 'center') {
        throw ArtifactLoadException(
          .invalidComponent,
          'Component v1 only permits center-aligned stack nodes.',
          path: '$nodePath/alignment',
        );
      }
      nodes[id] = ComponentAnatomyNode(
        id: id,
        kind: .stack,
        alignment: alignment,
        children: children,
      );
      continue;
    }
    if (kindName != 'slot') {
      throw ArtifactLoadException(
        .malformedJson,
        'Unknown anatomy node kind "$kindName".',
        path: '$nodePath/kind',
      );
    }
    _expectKeys(node, const {
      'id',
      'kind',
      'slot',
      'children',
      'visibleWhen',
      'maintain',
    }, path: nodePath);
    final slotId = _identifier(node, 'slot', path: '$nodePath/slot');
    if (!slots.containsKey(slotId) || !usedSlots.add(slotId)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Anatomy slots must exist and may appear only once.',
        path: '$nodePath/slot',
      );
    }
    final visibleWhen = node.containsKey('visibleWhen')
        ? _parseCondition(
            _asObject(node['visibleWhen'], path: '$nodePath/visibleWhen'),
            properties: properties,
            path: '$nodePath/visibleWhen',
          )
        : null;
    final maintained = node.containsKey('maintain')
        ? _parseMaintainedFeatures(node['maintain'], path: '$nodePath/maintain')
        : <String>{};
    if (maintained.isNotEmpty && visibleWhen == null) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Maintained visibility features require a visibility condition.',
        path: '$nodePath/maintain',
      );
    }
    nodes[id] = ComponentAnatomyNode(
      id: id,
      kind: .slot,
      slotId: slotId,
      visibleWhen: visibleWhen,
      maintainedFeatures: maintained,
      children: children,
    );
  }

  if (!nodes.containsKey(root)) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Anatomy root references an unknown node.',
      path: '$path/root',
    );
  }
  if (usedSlots.length != slots.length) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Every stable slot must appear exactly once in the anatomy.',
      path: '$path/nodes',
    );
  }
  _validateAnatomyGraph(nodes, root: root, path: path);

  return ComponentAnatomy(rootNodeId: root, nodes: nodes);
}

ComponentVisibilityCondition _parseCondition(
  Map<String, Object?> value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  final propertyId = _identifier(value, 'property', path: '$path/property');
  final property = properties[propertyId];
  if (property == null) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Visibility condition references an unknown property.',
      path: '$path/property',
    );
  }
  final operatorName = _requiredString(
    value,
    'operator',
    path: '$path/operator',
  );
  if (operatorName == 'present') {
    _expectKeys(value, const {'property', 'operator'}, path: path);
    final supportsPresence = switch (property.kind) {
      .icon || .string => true,
      .enumeration || .boolean => false,
    };
    if (!supportsPresence) {
      throw ArtifactLoadException(
        .invalidComponent,
        'The present operator requires an optional identity or string.',
        path: path,
      );
    }

    return ComponentVisibilityCondition(
      propertyId: propertyId,
      operator: .present,
    );
  }
  if (operatorName != 'equals') {
    throw ArtifactLoadException(
      .malformedJson,
      'Unknown visibility operator "$operatorName".',
      path: '$path/operator',
    );
  }
  _expectKeys(value, const {'property', 'operator', 'value'}, path: path);
  _requireKey(value, 'value', path: '$path/value');
  _validatePropertyValue(property, value['value'], path: '$path/value');

  return ComponentVisibilityCondition(
    propertyId: propertyId,
    operator: .equals,
    value: value['value'],
  );
}

Set<String> _parseMaintainedFeatures(Object? value, {required String path}) {
  const allowed = {'size', 'state', 'animation'};
  final raw = _asList(value, path: path);
  if (raw.length > allowed.length) {
    throw ArtifactLoadException(
      .malformedJson,
      'Too many maintained visibility features.',
      path: path,
    );
  }
  final result = <String>{};
  for (var index = 0; index < raw.length; index += 1) {
    final feature = _asNonEmptyString(raw[index], path: '$path/$index');
    if (!allowed.contains(feature) || !result.add(feature)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Maintained visibility features must be supported and unique.',
        path: '$path/$index',
      );
    }
  }

  return result;
}

void _validateAnatomyGraph(
  Map<String, ComponentAnatomyNode> nodes, {
  required String root,
  required String path,
}) {
  final parents = {for (final id in nodes.keys) id: 0};
  for (final node in nodes.values) {
    for (final child in node.children) {
      if (!nodes.containsKey(child)) {
        throw ArtifactLoadException(
          .invalidComponent,
          'Anatomy node references an unknown child.',
          path: '$path/nodes/${node.id}/children',
        );
      }
      parents[child] = parents[child]! + 1;
    }
  }
  for (final entry in parents.entries) {
    final expected = entry.key == root ? 0 : 1;
    if (entry.value != expected) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Anatomy must be a single rooted tree.',
        path: '$path/nodes/${entry.key}',
      );
    }
  }

  final visiting = <String>{};
  final visited = <String>{};
  void visit(String id, int depth) {
    if (depth > ComponentDocumentLimits.maxAnatomyDepth) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Anatomy exceeds the maximum depth.',
        path: '$path/nodes/$id',
      );
    }
    if (!visiting.add(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Anatomy must not contain cycles.',
        path: '$path/nodes/$id',
      );
    }
    if (visited.contains(id)) {
      visiting.remove(id);

      return;
    }
    for (final child in nodes[id]!.children) {
      visit(child, depth + 1);
    }
    visiting.remove(id);
    visited.add(id);
  }

  visit(root, 1);
  if (visited.length != nodes.length) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Every anatomy node must be reachable from the root.',
      path: '$path/nodes',
    );
  }
}

List<PortableComponentRecipe> _parseRecipes(
  List<Object?> values, {
  required Map<String, ComponentPropertyDefinition> properties,
  required Map<String, ComponentSlotDefinition> slots,
  required String path,
}) {
  final result = <PortableComponentRecipe>[];
  final ids = <String>{};
  final coordinates = <String>{};
  final axes = {
    for (final entry in properties.entries)
      if (entry.value.kind == .enumeration) entry.key,
  };
  if (axes.isEmpty) {
    throw ArtifactLoadException(
      .invalidComponent,
      'At least one enum property is required as a recipe axis.',
      path: path,
    );
  }
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {'id', 'properties', 'styles'}, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (!ids.add(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Recipe identifiers must be unique.',
        path: '$itemPath/id',
      );
    }
    final coordinate = _requiredObject(
      value,
      'properties',
      path: '$itemPath/properties',
    );
    if (coordinate.keys.toSet().difference(axes).isNotEmpty ||
        axes.difference(coordinate.keys.toSet()).isNotEmpty) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Each recipe must provide exactly one value for every enum axis.',
        path: '$itemPath/properties',
      );
    }
    for (final entry in coordinate.entries) {
      _validatePropertyValue(
        properties[entry.key]!,
        entry.value,
        path: '$itemPath/properties/${entry.key}',
      );
    }
    final coordinateKey = jsonEncode(
      Map.fromEntries(
        coordinate.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
    );
    if (!coordinates.add(coordinateKey)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Recipe coordinates must be unique.',
        path: '$itemPath/properties',
      );
    }

    final rawStyles = _requiredObject(
      value,
      'styles',
      path: '$itemPath/styles',
    );
    if (rawStyles.keys.toSet().difference(slots.keys.toSet()).isNotEmpty ||
        slots.keys.toSet().difference(rawStyles.keys.toSet()).isNotEmpty) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Every recipe must declare evidence for every stable slot.',
        path: '$itemPath/styles',
      );
    }
    final styles = <String, ComponentSlotStyleReference>{};
    for (final slot in slots.keys) {
      styles[slot] = _parseStyleReference(
        _asObject(rawStyles[slot], path: '$itemPath/styles/$slot'),
        path: '$itemPath/styles/$slot',
      );
    }
    result.add(
      PortableComponentRecipe(id: id, properties: coordinate, styles: styles),
    );
  }

  return result;
}

ComponentSlotStyleReference _parseStyleReference(
  Map<String, Object?> value, {
  required String path,
}) {
  final statusName = _requiredString(value, 'status', path: '$path/status');
  final evidence = _parseEvidence(
    _requiredString(value, 'evidence', path: '$path/evidence'),
    path: '$path/evidence',
  );
  if (statusName == 'supported') {
    _expectKeys(value, const {'status', 'evidence', 'document'}, path: path);
    final document = _requiredString(value, 'document', path: '$path/document');
    validateArtifactPath(document, path: '$path/document');

    return ComponentSlotStyleReference(
      status: .supported,
      evidence: evidence,
      documentPath: document,
    );
  }
  if (statusName != 'unsupported') {
    throw ArtifactLoadException(
      .malformedJson,
      'Style status must be supported or unsupported.',
      path: '$path/status',
    );
  }
  _expectKeys(value, const {'status', 'evidence', 'diagnostics'}, path: path);
  final rawDiagnostics = _asList(
    _requiredValue(value, 'diagnostics', path: '$path/diagnostics'),
    path: '$path/diagnostics',
  );
  if (rawDiagnostics.isEmpty ||
      rawDiagnostics.length > ComponentDocumentLimits.maxDiagnosticsPerStyle) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Unsupported styles require one or more bounded diagnostics.',
      path: '$path/diagnostics',
    );
  }
  final diagnostics = <ComponentDiagnostic>[];
  for (var index = 0; index < rawDiagnostics.length; index += 1) {
    final diagnosticPath = '$path/diagnostics/$index';
    final diagnostic = _asObject(rawDiagnostics[index], path: diagnosticPath);
    _expectKeys(diagnostic, const {
      'code',
      'severity',
      'path',
      'message',
    }, path: diagnosticPath);
    final severity = _requiredString(
      diagnostic,
      'severity',
      path: '$diagnosticPath/severity',
    );
    if (!const {'info', 'warning', 'error'}.contains(severity)) {
      throw ArtifactLoadException(
        .malformedJson,
        'Diagnostic severity is unsupported.',
        path: '$diagnosticPath/severity',
      );
    }
    diagnostics.add(
      ComponentDiagnostic(
        code: _requiredString(diagnostic, 'code', path: '$diagnosticPath/code'),
        severity: severity,
        path: _requiredString(
          diagnostic,
          'path',
          path: '$diagnosticPath/path',
          allowEmpty: true,
        ),
        message: _requiredString(
          diagnostic,
          'message',
          path: '$diagnosticPath/message',
        ),
      ),
    );
  }

  return ComponentSlotStyleReference(
    status: .unsupported,
    evidence: evidence,
    diagnostics: diagnostics,
  );
}

ComponentSemanticsContract _parseSemantics(
  Map<String, Object?> value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  _expectKeys(value, const {
    'role',
    'labelProperty',
    'enabledProperty',
    'loadingProperty',
  }, path: path);
  final role = _requiredString(value, 'role', path: '$path/role');
  if (role != 'button') {
    throw ArtifactLoadException(
      .invalidComponent,
      'Component v1 only supports button semantics.',
      path: '$path/role',
    );
  }
  final label = _propertyReference(
    value,
    'labelProperty',
    properties: properties,
    kind: .string,
    path: '$path/labelProperty',
  );
  final enabled = _propertyReference(
    value,
    'enabledProperty',
    properties: properties,
    kind: .boolean,
    path: '$path/enabledProperty',
  );
  final loading = _propertyReference(
    value,
    'loadingProperty',
    properties: properties,
    kind: .boolean,
    path: '$path/loadingProperty',
  );

  return ComponentSemanticsContract(
    role: role,
    labelPropertyId: label,
    enabledPropertyId: enabled,
    loadingPropertyId: loading,
  );
}

Map<String, ComponentVisualOracle> _parseOracles(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentVisualOracle>{};
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'theme',
      'image',
      'metadata',
      'evidence',
    }, path: itemPath);
    final theme = _identifier(value, 'theme', path: '$itemPath/theme');
    if (result.containsKey(theme)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Visual oracle theme identifiers must be unique.',
        path: '$itemPath/theme',
      );
    }
    final image = _requiredString(value, 'image', path: '$itemPath/image');
    final metadata = _requiredString(
      value,
      'metadata',
      path: '$itemPath/metadata',
    );
    validateArtifactPath(image, path: '$itemPath/image');
    validateArtifactPath(metadata, path: '$itemPath/metadata');
    final evidence = _parseEvidence(
      _requiredString(value, 'evidence', path: '$itemPath/evidence'),
      path: '$itemPath/evidence',
    );
    if (evidence != .rendered) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Visual oracle evidence must be rendered.',
        path: '$itemPath/evidence',
      );
    }
    result[theme] = ComponentVisualOracle(
      themeId: theme,
      imagePath: image,
      metadataPath: metadata,
      evidence: evidence,
    );
  }

  return result;
}

ComponentEvidence _parseEvidence(String value, {required String path}) {
  return switch (value) {
    'declared' => .declared,
    'effective' => .effective,
    'resolved' => .resolved,
    'rendered' => .rendered,
    _ => throw ArtifactLoadException(
      .malformedJson,
      'Unknown evidence level "$value".',
      path: path,
    ),
  };
}

String _propertyReference(
  Map<String, Object?> value,
  String key, {
  required Map<String, ComponentPropertyDefinition> properties,
  required ComponentPropertyKind kind,
  required String path,
}) {
  final id = _identifier(value, key, path: path);
  if (properties[id]?.kind != kind) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Semantic property reference has the wrong kind.',
      path: path,
    );
  }

  return id;
}

void _validatePropertyValue(
  ComponentPropertyDefinition definition,
  Object? value, {
  required String path,
}) {
  final valid = switch (definition.kind) {
    .enumeration => value is String && definition.values.contains(value),
    .string => value is String,
    .boolean => value is bool,
    .icon =>
      (!definition.isRequired && value == null) ||
          (value is String && _identityPattern.hasMatch(value)),
  };
  if (!valid) {
    throw ArtifactLoadException(
      .invalidComponent,
      'Value does not match property "${definition.id}".',
      path: path,
    );
  }
}

List<String> _parseIdentifierList(
  Map<String, Object?> value,
  String key, {
  required String path,
  required int maximum,
}) {
  final raw = _asList(_requiredValue(value, key, path: path), path: path);
  if (raw.length > maximum) {
    throw ArtifactLoadException(
      .malformedJson,
      'List exceeds its item limit of $maximum.',
      path: path,
    );
  }
  final result = <String>[];
  for (var index = 0; index < raw.length; index += 1) {
    final id = _asIdentifier(raw[index], path: '$path/$index');
    if (!result.addIfAbsent(id)) {
      throw ArtifactLoadException(
        .invalidComponent,
        'Identifiers in this list must be unique.',
        path: '$path/$index',
      );
    }
  }

  return result;
}

List<Object?> _boundedList(
  Map<String, Object?> value,
  String key, {
  required String path,
  required int maximum,
}) {
  final values = _asList(_requiredValue(value, key, path: path), path: path);
  if (values.isEmpty || values.length > maximum) {
    throw ArtifactLoadException(
      .malformedJson,
      'List item count must be between 1 and $maximum.',
      path: path,
    );
  }

  return values;
}

Map<String, Object?> _requiredObject(
  Map<String, Object?> map,
  String key, {
  required String path,
}) => _asObject(_requiredValue(map, key, path: path), path: path);

Map<String, Object?> _asObject(Object? value, {required String path}) {
  if (value is! Map<Object?, Object?>) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a JSON object.',
      path: path,
    );
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw ArtifactLoadException(
        .malformedJson,
        'JSON object keys must be strings.',
        path: path,
      );
    }
    result[entry.key as String] = entry.value;
  }

  return result;
}

List<Object?> _asList(Object? value, {required String path}) {
  if (value is! List<Object?>) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a JSON list.',
      path: path,
    );
  }

  return value;
}

Object? _requiredValue(
  Map<String, Object?> map,
  String key, {
  required String path,
}) {
  _requireKey(map, key, path: path);

  return map[key];
}

void _requireKey(Map<String, Object?> map, String key, {required String path}) {
  if (!map.containsKey(key)) {
    throw ArtifactLoadException(
      .malformedJson,
      'Required field is missing.',
      path: path,
    );
  }
}

String _requiredString(
  Map<String, Object?> map,
  String key, {
  required String path,
  bool allowEmpty = false,
}) {
  final value = _requiredValue(map, key, path: path);
  if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a${allowEmpty ? '' : ' non-empty'} string.',
      path: path,
    );
  }

  return value;
}

bool _requiredBool(
  Map<String, Object?> map,
  String key, {
  required String path,
}) {
  final value = _requiredValue(map, key, path: path);
  if (value is! bool) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a boolean.',
      path: path,
    );
  }

  return value;
}

String _identifier(
  Map<String, Object?> map,
  String key, {
  required String path,
}) => _asIdentifier(_requiredValue(map, key, path: path), path: path);

String _asIdentifier(Object? value, {required String path}) {
  final result = _asNonEmptyString(value, path: path);
  if (!_identifierPattern.hasMatch(result)) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a stable identifier.',
      path: path,
    );
  }

  return result;
}

String _asNonEmptyString(Object? value, {required String path}) {
  if (value is! String || value.trim().isEmpty) {
    throw ArtifactLoadException(
      .malformedJson,
      'Expected a non-empty string.',
      path: path,
    );
  }

  return value;
}

void _expectKeys(
  Map<String, Object?> map,
  Set<String> allowed, {
  required String path,
}) {
  final unknown = map.keys.toSet().difference(allowed);
  if (unknown.isNotEmpty) {
    throw ArtifactLoadException(
      .malformedJson,
      'Unknown fields: ${unknown.toList()..sort()}.',
      path: path,
    );
  }
}

final _identifierPattern = RegExp(r'^[A-Za-z][A-Za-z0-9_-]{0,63}$');
final _identityPattern = RegExp(r'^[A-Za-z0-9_-]{1,96}$');

extension on List<String> {
  bool addIfAbsent(String value) {
    if (contains(value)) return false;
    add(value);

    return true;
  }
}
