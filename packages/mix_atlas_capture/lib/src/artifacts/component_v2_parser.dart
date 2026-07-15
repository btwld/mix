import 'capture_bundle.dart';
import 'component_document.dart';

const _widgetStates = {
  'hovered',
  'focused',
  'pressed',
  'dragged',
  'selected',
  'scrolledUnder',
  'disabled',
  'error',
};

const _tokenKinds = {
  'color',
  'space',
  'double',
  'radius',
  'textStyle',
  'shadow',
  'boxShadow',
  'border',
  'fontWeight',
  'breakpoint',
  'duration',
};

const _semanticRoles = {
  'none',
  'button',
  'link',
  'checkbox',
  'radio',
  'switch',
  'slider',
  'progressIndicator',
  'textField',
  'image',
  'header',
  'dialog',
  'menu',
  'menuItem',
  'tab',
  'tooltip',
  'status',
};

const _semanticBindingNames = {
  'label',
  'hint',
  'value',
  'increasedValue',
  'decreasedValue',
  'enabled',
  'checked',
  'mixed',
  'toggled',
  'selected',
  'expanded',
  'readOnly',
  'obscured',
  'multiline',
  'focusable',
  'focused',
  'liveRegion',
  'hidden',
  'required',
  'invalid',
  'maxValueLength',
  'currentValueLength',
};

const _styleSlotKinds = {
  ComponentSlotKind.box,
  ComponentSlotKind.flexBox,
  ComponentSlotKind.stackBox,
  ComponentSlotKind.text,
  ComponentSlotKind.icon,
  ComponentSlotKind.image,
};

PortableComponentDocument parsePortableComponentV2(
  Map<String, Object?> root, {
  required String path,
}) {
  _expectKeys(root, const {
    'schema',
    'id',
    'label',
    'properties',
    'states',
    'slots',
    'anatomy',
    'recipes',
    'styles',
    'semantics',
    'oracles',
    'diagnostics',
  }, path: path);

  final id = _identifier(root, 'id', path: '$path/id');
  final properties = _parseProperties(
    _boundedList(root, 'properties', path: '$path/properties', maximum: 64),
    path: '$path/properties',
  );
  final states = _parseStates(
    _boundedList(root, 'states', path: '$path/states', maximum: 32),
    properties: properties,
    path: '$path/states',
  );
  final slots = _parseSlots(
    _boundedList(root, 'slots', path: '$path/slots', maximum: 64),
    path: '$path/slots',
  );
  final anatomy = _parseAnatomy(
    _requiredObject(root, 'anatomy', path: '$path/anatomy'),
    properties: properties,
    slots: slots,
    path: '$path/anatomy',
  );
  final styles = _parseStyleLibrary(
    _requiredObject(root, 'styles', path: '$path/styles'),
    path: '$path/styles',
  );
  final recipes = _parseRecipes(
    _boundedList(root, 'recipes', path: '$path/recipes', maximum: 512),
    properties: properties,
    slots: slots,
    styles: styles,
    path: '$path/recipes',
  );
  _validateStaticNodeBindings(
    anatomy,
    properties: properties,
    states: states,
    recipes: recipes,
    path: '$path/anatomy',
  );
  final semantics = _parseSemantics(
    _requiredObject(root, 'semantics', path: '$path/semantics'),
    properties: properties,
    path: '$path/semantics',
  );
  final oracles = _parseOracles(
    _boundedList(root, 'oracles', path: '$path/oracles', maximum: 16),
    path: '$path/oracles',
  );
  final diagnostics = root.containsKey('diagnostics')
      ? _parseDiagnostics(
          _asList(root['diagnostics'], path: '$path/diagnostics'),
          path: '$path/diagnostics',
          allowEmpty: true,
        )
      : const <ComponentDiagnostic>[];

  return PortableComponentDocument(
    schema: .v2,
    id: id,
    label: _requiredString(root, 'label', path: '$path/label'),
    properties: properties,
    states: states,
    slots: slots,
    anatomy: anatomy,
    recipes: recipes,
    styleLibrary: styles,
    oracles: oracles,
    semantics: semantics,
    diagnostics: diagnostics,
  );
}

void _validateStaticNodeBindings(
  ComponentAnatomy anatomy, {
  required Map<String, ComponentPropertyDefinition> properties,
  required Map<String, ComponentStateDefinition> states,
  required List<PortableComponentRecipe> recipes,
  required String path,
}) {
  for (final node in anatomy.nodes.values) {
    for (final entry in node.bindings.entries) {
      final binding = entry.value;
      if (binding.kind == .token) continue;
      final values = switch (binding.kind) {
        .literal => {binding.literalValue},
        .property => {
          properties[binding.propertyId]!.defaultValue,
          for (final recipe in recipes)
            if (recipe.properties.containsKey(binding.propertyId))
              recipe.properties[binding.propertyId],
          for (final state in states.values)
            if (state.propertyOverrides.containsKey(binding.propertyId))
              state.propertyOverrides[binding.propertyId],
        },
        .token => const <Object?>{},
      };
      if (values.any((value) => !_isStaticNodeBindingValue(entry.key, value))) {
        throw _invalid(
          'Node binding "${entry.key}" can resolve to a value its portable '
              'primitive cannot render.',
          '$path/nodes/${node.id}/bindings/${entry.key}',
        );
      }
    }
  }
}

bool _isStaticNodeBindingValue(String name, Object? value) {
  if (value == null) return name != 'source';

  return switch (name) {
    'text' => value is String || value is num,
    'icon' => atlasPortableIconIdentities.contains(value),
    'source' => value is String,
    'value' => value is num && value.isFinite && value >= 0 && value <= 1,
    'strokeWidth' ||
    'trackStrokeWidth' => value is num && value.isFinite && value > 0,
    'size' ||
    'widthFactor' ||
    'heightFactor' => value is num && value.isFinite && value >= 0,
    'color' ||
    'backgroundColor' ||
    'trackColor' => value is String && _colorPattern.hasMatch(value),
    'duration' => value is int && value > 0,
    'alignment' => value is String && _alignments.contains(value),
    _ => false,
  };
}

Map<String, ComponentPropertyDefinition> _parseProperties(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentPropertyDefinition>{};
  for (var index = 0; index < values.length; index += 1) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'id',
      'kind',
      'values',
      'default',
      'required',
    }, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (result.containsKey(id)) {
      throw _invalid('Property identifiers must be unique.', '$itemPath/id');
    }
    final kindName = _requiredString(value, 'kind', path: '$itemPath/kind');
    final kind = switch (kindName) {
      'enum' => ComponentPropertyKind.enumeration,
      'string' => ComponentPropertyKind.string,
      'boolean' => ComponentPropertyKind.boolean,
      'number' => ComponentPropertyKind.number,
      'duration' => ComponentPropertyKind.duration,
      'icon' => ComponentPropertyKind.icon,
      _ => throw _malformed(
        'Unknown component property kind "$kindName".',
        '$itemPath/kind',
      ),
    };
    final required = value.containsKey('required')
        ? _requiredBool(value, 'required', path: '$itemPath/required')
        : true;
    final enumValues = <String>[];
    if (kind == .enumeration) {
      final rawValues = _boundedList(
        value,
        'values',
        path: '$itemPath/values',
        maximum: 64,
      );
      for (var valueIndex = 0; valueIndex < rawValues.length; valueIndex++) {
        final enumValue = _asIdentifier(
          rawValues[valueIndex],
          path: '$itemPath/values/$valueIndex',
        );
        if (!enumValues.addIfAbsent(enumValue)) {
          throw _invalid(
            'Enum values must be unique.',
            '$itemPath/values/$valueIndex',
          );
        }
      }
    } else if (value.containsKey('values')) {
      throw _malformed(
        'Only enum properties may declare values.',
        '$itemPath/values',
      );
    }

    final hasDefault = value.containsKey('default');
    if (required && !hasDefault) {
      throw _invalid(
        'Required properties need a deterministic default.',
        '$itemPath/default',
      );
    }
    final defaultValue = value['default'];
    final definition = ComponentPropertyDefinition(
      id: id,
      kind: kind,
      values: enumValues,
      defaultValue: defaultValue,
      isRequired: required,
    );
    if (hasDefault || required) {
      _validatePropertyValue(
        definition,
        defaultValue,
        path: '$itemPath/default',
      );
    }
    result[id] = definition;
  }

  return result;
}

Map<String, ComponentStateDefinition> _parseStates(
  List<Object?> values, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  final result = <String, ComponentStateDefinition>{};
  for (var index = 0; index < values.length; index++) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'id',
      'label',
      'widgetStates',
      'properties',
    }, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (result.containsKey(id)) {
      throw _invalid('State identifiers must be unique.', '$itemPath/id');
    }
    final rawWidgetStates = _asList(
      _requiredValue(value, 'widgetStates', path: '$itemPath/widgetStates'),
      path: '$itemPath/widgetStates',
    );
    if (rawWidgetStates.length > _widgetStates.length) {
      throw _malformed('Too many widget states.', '$itemPath/widgetStates');
    }
    final widgetStates = <String>{};
    for (
      var stateIndex = 0;
      stateIndex < rawWidgetStates.length;
      stateIndex++
    ) {
      final state = _asNonEmptyString(
        rawWidgetStates[stateIndex],
        path: '$itemPath/widgetStates/$stateIndex',
      );
      if (!_widgetStates.contains(state) || !widgetStates.add(state)) {
        throw _invalid(
          'Widget states must be supported and unique.',
          '$itemPath/widgetStates/$stateIndex',
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
        throw _invalid(
          'State override references an unknown property.',
          '$itemPath/properties/${entry.key}',
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
      label: value.containsKey('label')
          ? _requiredString(value, 'label', path: '$itemPath/label')
          : null,
      widgetStates: widgetStates,
      propertyOverrides: overrides,
    );
  }
  return result;
}

Map<String, ComponentSlotDefinition> _parseSlots(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentSlotDefinition>{};
  for (var index = 0; index < values.length; index++) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {'id', 'kind'}, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (result.containsKey(id)) {
      throw _invalid('Slot identifiers must be unique.', '$itemPath/id');
    }
    result[id] = ComponentSlotDefinition(
      id: id,
      kind: _slotKind(
        _requiredString(value, 'kind', path: '$itemPath/kind'),
        path: '$itemPath/kind',
      ),
    );
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
    maximum: 128,
  );
  final nodes = <String, ComponentAnatomyNode>{};
  final usedSlots = <String>{};
  for (var index = 0; index < rawNodes.length; index++) {
    final nodePath = '$path/nodes/$index';
    final node = _asObject(rawNodes[index], path: nodePath);
    _expectKeys(node, const {
      'id',
      'kind',
      'slot',
      'children',
      'bindings',
      'visibleWhen',
      'maintain',
      'component',
      'recipe',
      'state',
      'properties',
    }, path: nodePath);
    final id = _identifier(node, 'id', path: '$nodePath/id');
    if (nodes.containsKey(id)) {
      throw _invalid('Node identifiers must be unique.', '$nodePath/id');
    }
    final kind = _nodeKind(
      _requiredString(node, 'kind', path: '$nodePath/kind'),
      path: '$nodePath/kind',
    );
    final children = _identifierList(
      _requiredValue(node, 'children', path: '$nodePath/children'),
      path: '$nodePath/children',
      maximum: 64,
    );
    final slotId = node.containsKey('slot')
        ? _identifier(node, 'slot', path: '$nodePath/slot')
        : null;
    if (slotId != null) {
      final slot = slots[slotId];
      if (slot == null || !usedSlots.add(slotId)) {
        throw _invalid(
          'Node slots must exist and may be used only once.',
          '$nodePath/slot',
        );
      }
      if (!_slotMatchesNode(slot.kind, kind)) {
        throw _invalid(
          'Node kind does not match its stable slot kind.',
          '$nodePath/slot',
        );
      }
    }
    final needsStyleSlot = _nodeUsesStyle(kind);
    if (needsStyleSlot != (slotId != null)) {
      throw _invalid(
        needsStyleSlot
            ? 'Styled nodes require a stable slot.'
            : 'This node kind cannot reference a Mix style slot.',
        '$nodePath/slot',
      );
    }

    final bindings = node.containsKey('bindings')
        ? _parseBindingMap(
            _asObject(node['bindings'], path: '$nodePath/bindings'),
            properties: properties,
            path: '$nodePath/bindings',
            maximum: 16,
          )
        : const <String, AtlasPortableBinding>{};
    _validateNodeBindings(
      kind,
      bindings,
      properties: properties,
      path: '$nodePath/bindings',
    );
    final condition = node.containsKey('visibleWhen')
        ? _parseCondition(
            _asObject(node['visibleWhen'], path: '$nodePath/visibleWhen'),
            properties: properties,
            path: '$nodePath/visibleWhen',
          )
        : null;
    final maintained = node.containsKey('maintain')
        ? _parseMaintained(node['maintain'], path: '$nodePath/maintain')
        : const <String>{};
    if (maintained.isNotEmpty && condition == null) {
      throw _invalid(
        'Maintained visibility requires a condition.',
        '$nodePath/maintain',
      );
    }

    String? nestedComponent;
    AtlasPortableBinding? recipeBinding;
    AtlasPortableBinding? stateBinding;
    var propertyBindings = const <String, AtlasPortableBinding>{};
    if (kind == .nestedComponent) {
      nestedComponent = _identifier(
        node,
        'component',
        path: '$nodePath/component',
      );
      recipeBinding = _parseBinding(
        _requiredValue(node, 'recipe', path: '$nodePath/recipe'),
        properties: properties,
        path: '$nodePath/recipe',
      );
      stateBinding = _parseBinding(
        _requiredValue(node, 'state', path: '$nodePath/state'),
        properties: properties,
        path: '$nodePath/state',
      );
      if (!_bindingMatches(
            recipeBinding,
            properties: properties,
            literal: (value) => value is String,
            propertyKinds: const {.enumeration, .string},
          ) ||
          !_bindingMatches(
            stateBinding,
            properties: properties,
            literal: (value) => value is String,
            propertyKinds: const {.enumeration, .string},
          )) {
        throw _invalid(
          'Nested recipe and state bindings must resolve to strings.',
          nodePath,
        );
      }
      propertyBindings = node.containsKey('properties')
          ? _parseBindingMap(
              _asObject(node['properties'], path: '$nodePath/properties'),
              properties: properties,
              path: '$nodePath/properties',
              maximum: 64,
            )
          : const {};
      if (children.isNotEmpty) {
        throw _invalid(
          'Nested component nodes cannot declare child nodes.',
          '$nodePath/children',
        );
      }
    } else if (node.keys.any(
      const {'component', 'recipe', 'state', 'properties'}.contains,
    )) {
      throw _malformed(
        'Nested-component fields are only valid on nested_component nodes.',
        nodePath,
      );
    }
    if ({
          ComponentAnatomyNodeKind.text,
          ComponentAnatomyNodeKind.icon,
          ComponentAnatomyNodeKind.image,
          ComponentAnatomyNodeKind.spinner,
        }.contains(kind) &&
        children.isNotEmpty) {
      throw _invalid(
        'Leaf visual nodes cannot declare children.',
        '$nodePath/children',
      );
    }
    if (kind == .fractionalPosition && children.length != 1) {
      throw _invalid(
        'Fractional-position nodes require exactly one child.',
        '$nodePath/children',
      );
    }

    nodes[id] = ComponentAnatomyNode(
      id: id,
      kind: kind,
      slotId: slotId,
      visibleWhen: condition,
      maintainedFeatures: maintained,
      bindings: bindings,
      componentId: nestedComponent,
      recipeBinding: recipeBinding,
      stateBinding: stateBinding,
      propertyBindings: propertyBindings,
      children: children,
    );
  }
  if (!nodes.containsKey(root)) {
    throw _invalid('Anatomy root references an unknown node.', '$path/root');
  }
  if (!usedSlots.containsAll(slots.keys)) {
    throw _invalid(
      'Every stable slot must appear exactly once in the anatomy.',
      '$path/nodes',
    );
  }
  _validateTree(nodes, root: root, path: path);

  return ComponentAnatomy(rootNodeId: root, nodes: nodes);
}

Map<String, ComponentStyleLibraryEntry> _parseStyleLibrary(
  Map<String, Object?> values, {
  required String path,
}) {
  if (values.length > 2048) {
    throw _malformed('Style library exceeds 2048 entries.', path);
  }
  final result = <String, ComponentStyleLibraryEntry>{};
  for (final entry in values.entries) {
    if (!_styleIdPattern.hasMatch(entry.key) || entry.key.contains('..')) {
      throw _malformed(
        'Expected a safe stable style identifier.',
        '$path/${entry.key}',
      );
    }
    result[entry.key] = ComponentStyleLibraryEntry(
      id: entry.key,
      document: _asObject(entry.value, path: '$path/${entry.key}'),
    );
  }

  return result;
}

List<PortableComponentRecipe> _parseRecipes(
  List<Object?> values, {
  required Map<String, ComponentPropertyDefinition> properties,
  required Map<String, ComponentSlotDefinition> slots,
  required Map<String, ComponentStyleLibraryEntry> styles,
  required String path,
}) {
  final result = <PortableComponentRecipe>[];
  final ids = <String>{};
  final styleSlotIds = {
    for (final slot in slots.values)
      if (_styleSlotKinds.contains(slot.kind)) slot.id,
  };
  for (var index = 0; index < values.length; index++) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'id',
      'label',
      'properties',
      'styles',
    }, path: itemPath);
    final id = _identifier(value, 'id', path: '$itemPath/id');
    if (!ids.add(id)) {
      throw _invalid('Recipe identifiers must be unique.', '$itemPath/id');
    }
    final recipeProperties = _requiredObject(
      value,
      'properties',
      path: '$itemPath/properties',
    );
    for (final entry in recipeProperties.entries) {
      final definition = properties[entry.key];
      if (definition == null) {
        throw _invalid(
          'Recipe references an unknown property.',
          '$itemPath/properties/${entry.key}',
        );
      }
      _validatePropertyValue(
        definition,
        entry.value,
        path: '$itemPath/properties/${entry.key}',
      );
    }
    final rawReferences = _requiredObject(
      value,
      'styles',
      path: '$itemPath/styles',
    );
    if (rawReferences.keys.toSet().difference(styleSlotIds).isNotEmpty ||
        styleSlotIds.difference(rawReferences.keys.toSet()).isNotEmpty) {
      throw _invalid(
        'Every recipe must reference one embedded style for every styled slot.',
        '$itemPath/styles',
      );
    }
    final references = <String, ComponentSlotStyleReference>{};
    for (final slotId in styleSlotIds) {
      final styleId = _asNonEmptyString(
        rawReferences[slotId],
        path: '$itemPath/styles/$slotId',
      );
      if (!styles.containsKey(styleId)) {
        throw _invalid(
          'Recipe references an unknown embedded style.',
          '$itemPath/styles/$slotId',
        );
      }
      references[slotId] = ComponentSlotStyleReference.supported(
        styleId: styleId,
      );
    }
    result.add(
      PortableComponentRecipe(
        id: id,
        label: value.containsKey('label')
            ? _requiredString(value, 'label', path: '$itemPath/label')
            : null,
        properties: recipeProperties,
        styles: references,
      ),
    );
  }

  return result;
}

ComponentSemanticsContract _parseSemantics(
  Map<String, Object?> value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  _expectKeys(value, const {'role', 'bindings'}, path: path);
  final role = _requiredString(value, 'role', path: '$path/role');
  if (!_semanticRoles.contains(role)) {
    throw _invalid('Semantics role is not supported.', '$path/role');
  }
  final bindings = _parseBindingMap(
    _requiredObject(value, 'bindings', path: '$path/bindings'),
    properties: properties,
    path: '$path/bindings',
    maximum: _semanticBindingNames.length,
  );
  final unknown = bindings.keys.toSet().difference(_semanticBindingNames);
  if (unknown.isNotEmpty) {
    throw _malformed(
      'Unknown semantics bindings: ${unknown.toList()..sort()}.',
      '$path/bindings',
    );
  }
  for (final entry in bindings.entries) {
    final stringValue = const {
      'label',
      'hint',
      'value',
      'increasedValue',
      'decreasedValue',
    }.contains(entry.key);
    final lengthValue = const {
      'maxValueLength',
      'currentValueLength',
    }.contains(entry.key);
    final valid = stringValue
        ? _bindingMatches(
            entry.value,
            properties: properties,
            literal: (value) => value is String || value is num,
            propertyKinds: const {.enumeration, .string, .number, .duration},
          )
        : lengthValue
        ? _bindingMatches(
            entry.value,
            properties: properties,
            literal: (value) => value is int && value >= 0,
            propertyKinds: const {.number},
          )
        : _bindingMatches(
            entry.value,
            properties: properties,
            literal: (value) => value is bool,
            propertyKinds: const {.boolean},
          );
    if (!valid) {
      throw _invalid(
        'Semantics binding "${entry.key}" has an incompatible value type.',
        '$path/bindings/${entry.key}',
      );
    }
  }

  return ComponentSemanticsContract(role: role, bindings: bindings);
}

Map<String, ComponentVisualOracle> _parseOracles(
  List<Object?> values, {
  required String path,
}) {
  final result = <String, ComponentVisualOracle>{};
  for (var index = 0; index < values.length; index++) {
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
      throw _invalid(
        'Oracle theme identifiers must be unique.',
        '$itemPath/theme',
      );
    }
    final image = _requiredString(value, 'image', path: '$itemPath/image');
    final metadata = _requiredString(
      value,
      'metadata',
      path: '$itemPath/metadata',
    );
    _validateArtifactPath(image, path: '$itemPath/image');
    _validateArtifactPath(metadata, path: '$itemPath/metadata');
    if (_requiredString(value, 'evidence', path: '$itemPath/evidence') !=
        'rendered') {
      throw _invalid('Oracle evidence must be rendered.', '$itemPath/evidence');
    }
    result[theme] = ComponentVisualOracle(
      themeId: theme,
      imagePath: image,
      metadataPath: metadata,
      evidence: .rendered,
    );
  }

  return result;
}

ComponentVisibilityCondition _parseCondition(
  Map<String, Object?> value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  _expectKeys(value, const {
    'property',
    'state',
    'operator',
    'value',
  }, path: path);
  final hasProperty = value.containsKey('property');
  final hasState = value.containsKey('state');
  if (hasProperty == hasState) {
    throw _invalid(
      'A condition must reference exactly one property or widget state.',
      path,
    );
  }
  final operatorName = _requiredString(
    value,
    'operator',
    path: '$path/operator',
  );
  final operator = switch (operatorName) {
    'equals' => ComponentConditionOperator.equals,
    'not_equals' => ComponentConditionOperator.notEquals,
    'present' => ComponentConditionOperator.present,
    'absent' => ComponentConditionOperator.absent,
    'active' => ComponentConditionOperator.active,
    'inactive' => ComponentConditionOperator.inactive,
    _ => throw _malformed('Unknown condition operator.', '$path/operator'),
  };
  if (hasState) {
    final state = _requiredString(value, 'state', path: '$path/state');
    if (!_widgetStates.contains(state) ||
        !{
          ComponentConditionOperator.active,
          ComponentConditionOperator.inactive,
        }.contains(operator) ||
        value.containsKey('value')) {
      throw _invalid('Invalid widget-state condition.', path);
    }

    return ComponentVisibilityCondition.widgetState(
      state: state,
      operator: operator,
    );
  }
  final propertyId = _identifier(value, 'property', path: '$path/property');
  final property = properties[propertyId];
  if (property == null ||
      {
        ComponentConditionOperator.active,
        ComponentConditionOperator.inactive,
      }.contains(operator)) {
    throw _invalid('Invalid property condition.', path);
  }
  final expectsValue = {
    ComponentConditionOperator.equals,
    ComponentConditionOperator.notEquals,
  }.contains(operator);
  if (expectsValue != value.containsKey('value')) {
    throw _invalid(
      'Condition value does not match its operator.',
      '$path/value',
    );
  }
  if (expectsValue) {
    _validatePropertyValue(property, value['value'], path: '$path/value');
  }

  return ComponentVisibilityCondition(
    propertyId: propertyId,
    operator: operator,
    value: value['value'],
  );
}

Map<String, AtlasPortableBinding> _parseBindingMap(
  Map<String, Object?> values, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
  required int maximum,
}) {
  if (values.length > maximum) {
    throw _malformed('Binding map exceeds $maximum entries.', path);
  }

  return {
    for (final entry in values.entries)
      _bindingName(entry.key, path: '$path/${entry.key}'): _parseBinding(
        entry.value,
        properties: properties,
        path: '$path/${entry.key}',
      ),
  };
}

AtlasPortableBinding _parseBinding(
  Object? value, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  final binding = _asObject(value, path: path);
  if (binding.length != 1) {
    throw _malformed(
      'Binding must contain exactly one of literal, property, or token.',
      path,
    );
  }
  if (binding.containsKey('literal')) {
    final literal = binding['literal'];
    if (!_isJsonScalar(literal)) {
      throw _malformed(
        'Binding literal must be a finite JSON scalar.',
        '$path/literal',
      );
    }

    return AtlasPortableBinding.literal(literal);
  }
  if (binding.containsKey('property')) {
    final property = _asIdentifier(binding['property'], path: '$path/property');
    if (!properties.containsKey(property)) {
      throw _invalid(
        'Binding references an unknown property.',
        '$path/property',
      );
    }

    return AtlasPortableBinding.property(property);
  }
  if (binding.containsKey('token')) {
    final token = _asNonEmptyString(binding['token'], path: '$path/token');
    final separator = token.indexOf('/');
    if (separator <= 0 || separator == token.length - 1) {
      throw _malformed('Token binding must use kind/name.', '$path/token');
    }
    final kind = token.substring(0, separator);
    final name = token.substring(separator + 1);
    if (!_tokenKinds.contains(kind) || !_tokenNamePattern.hasMatch(name)) {
      throw _invalid(
        'Token binding is not a safe supported reference.',
        '$path/token',
      );
    }

    return AtlasPortableBinding.token(kind: kind, name: name);
  }

  throw _malformed('Unknown binding kind.', path);
}

void _validateNodeBindings(
  ComponentAnatomyNodeKind kind,
  Map<String, AtlasPortableBinding> bindings, {
  required Map<String, ComponentPropertyDefinition> properties,
  required String path,
}) {
  final required = switch (kind) {
    .text => const {'text'},
    .icon => const {'icon'},
    .image => const {'source'},
    .box ||
    .flexBox ||
    .stackBox ||
    .spinner ||
    .fractionalPosition ||
    .nestedComponent => const <String>{},
    .stack || .slot => throw StateError('v1 node admitted by v2 parser.'),
  };
  final allowed = switch (kind) {
    .box || .flexBox || .stackBox || .nestedComponent => const <String>{},
    .text => const {'text'},
    .icon => const {'icon'},
    .image => const {'source'},
    .spinner => const {
      'value',
      'strokeWidth',
      'trackStrokeWidth',
      'color',
      'backgroundColor',
      'trackColor',
      'size',
      'duration',
    },
    .fractionalPosition => const {'widthFactor', 'heightFactor', 'alignment'},
    .stack || .slot => throw StateError('v1 node admitted by v2 parser.'),
  };
  final unknown = bindings.keys.toSet().difference(allowed);
  final missing = required.difference(bindings.keys.toSet());
  if (unknown.isNotEmpty || missing.isNotEmpty) {
    throw _invalid(
      'Node bindings do not match its primitive (missing: '
      '${missing.toList()}, unknown: ${unknown.toList()}).',
      path,
    );
  }
  for (final entry in bindings.entries) {
    final valid = switch (entry.key) {
      'text' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is String || value is num,
        propertyKinds: const {.enumeration, .string, .number, .duration},
      ),
      'icon' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: atlasPortableIconIdentities.contains,
        propertyKinds: const {.icon},
      ),
      'source' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is String,
        propertyKinds: const {.string},
      ),
      'value' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) =>
            value is num && value.isFinite && value >= 0 && value <= 1,
        propertyKinds: const {.number},
        tokenKinds: const {'space', 'double'},
      ),
      'strokeWidth' || 'trackStrokeWidth' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is num && value.isFinite && value > 0,
        propertyKinds: const {.number},
        tokenKinds: const {'space', 'double'},
      ),
      'size' || 'widthFactor' || 'heightFactor' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is num && value.isFinite && value >= 0,
        propertyKinds: const {.number},
        tokenKinds: const {'space', 'double'},
      ),
      'color' || 'backgroundColor' || 'trackColor' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is String && _colorPattern.hasMatch(value),
        propertyKinds: const {.string},
        tokenKinds: const {'color'},
      ),
      'duration' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is int && value > 0,
        propertyKinds: const {.duration},
        tokenKinds: const {'duration'},
      ),
      'alignment' => _bindingMatches(
        entry.value,
        properties: properties,
        literal: (value) => value is String && _alignments.contains(value),
        propertyKinds: const {.enumeration, .string},
      ),
      _ => false,
    };
    if (!valid) {
      throw _invalid(
        'Node binding "${entry.key}" has an incompatible value type.',
        '$path/${entry.key}',
      );
    }
  }
}

bool _bindingMatches(
  AtlasPortableBinding binding, {
  required Map<String, ComponentPropertyDefinition> properties,
  required bool Function(Object? value) literal,
  required Set<ComponentPropertyKind> propertyKinds,
  Set<String> tokenKinds = const {},
}) => switch (binding.kind) {
  .literal => literal(binding.literalValue),
  .property => propertyKinds.contains(properties[binding.propertyId]!.kind),
  .token => tokenKinds.contains(binding.tokenKind),
};

List<ComponentDiagnostic> _parseDiagnostics(
  List<Object?> values, {
  required String path,
  required bool allowEmpty,
}) {
  if ((!allowEmpty && values.isEmpty) || values.length > 64) {
    throw _malformed('Diagnostic count is outside its allowed bounds.', path);
  }
  final result = <ComponentDiagnostic>[];
  for (var index = 0; index < values.length; index++) {
    final itemPath = '$path/$index';
    final value = _asObject(values[index], path: itemPath);
    _expectKeys(value, const {
      'code',
      'severity',
      'path',
      'message',
    }, path: itemPath);
    final severity = _requiredString(
      value,
      'severity',
      path: '$itemPath/severity',
    );
    if (!const {'info', 'warning', 'error'}.contains(severity)) {
      throw _malformed('Unknown diagnostic severity.', '$itemPath/severity');
    }
    result.add(
      ComponentDiagnostic(
        code: _requiredString(value, 'code', path: '$itemPath/code'),
        severity: severity,
        path: _requiredString(
          value,
          'path',
          path: '$itemPath/path',
          allowEmpty: true,
        ),
        message: _requiredString(value, 'message', path: '$itemPath/message'),
      ),
    );
  }

  return result;
}

void _validatePropertyValue(
  ComponentPropertyDefinition definition,
  Object? value, {
  required String path,
}) {
  final optionalNull = !definition.isRequired && value == null;
  final valid =
      optionalNull ||
      switch (definition.kind) {
        .enumeration => value is String && definition.values.contains(value),
        .string => value is String,
        .boolean => value is bool,
        .number => value is num && value.isFinite,
        .duration => value is int && value >= 0,
        .icon => atlasPortableIconIdentities.contains(value),
      };
  if (!valid) {
    throw _invalid('Value does not match property "${definition.id}".', path);
  }
}

void _validateTree(
  Map<String, ComponentAnatomyNode> nodes, {
  required String root,
  required String path,
}) {
  final parents = {for (final id in nodes.keys) id: 0};
  for (final node in nodes.values) {
    for (final child in node.children) {
      if (!nodes.containsKey(child)) {
        throw _invalid(
          'Node references an unknown child.',
          '$path/nodes/${node.id}/children',
        );
      }
      parents[child] = parents[child]! + 1;
    }
  }
  for (final entry in parents.entries) {
    if (entry.value != (entry.key == root ? 0 : 1)) {
      throw _invalid(
        'Anatomy must be a single rooted tree.',
        '$path/nodes/${entry.key}',
      );
    }
  }
  final visiting = <String>{};
  final visited = <String>{};
  void visit(String id, int depth) {
    if (depth > 32) {
      throw _invalid('Anatomy exceeds its depth limit.', '$path/nodes/$id');
    }
    if (!visiting.add(id)) {
      throw _invalid('Anatomy must not contain cycles.', '$path/nodes/$id');
    }
    for (final child in nodes[id]!.children) {
      if (!visited.contains(child)) visit(child, depth + 1);
    }
    visiting.remove(id);
    visited.add(id);
  }

  visit(root, 1);
  if (visited.length != nodes.length) {
    throw _invalid('Every anatomy node must be reachable.', '$path/nodes');
  }
}

Set<String> _parseMaintained(Object? value, {required String path}) {
  const allowed = {'size', 'state', 'animation', 'semantics'};
  final raw = _asList(value, path: path);
  if (raw.length > allowed.length) {
    throw _malformed('Too many maintained visibility features.', path);
  }
  final result = <String>{};
  for (var index = 0; index < raw.length; index++) {
    final feature = _asNonEmptyString(raw[index], path: '$path/$index');
    if (!allowed.contains(feature) || !result.add(feature)) {
      throw _invalid(
        'Maintained features must be supported and unique.',
        '$path/$index',
      );
    }
  }

  return result;
}

ComponentSlotKind _slotKind(String value, {required String path}) =>
    switch (value) {
      'box' => .box,
      'flex_box' => .flexBox,
      'stack_box' => .stackBox,
      'text' => .text,
      'icon' => .icon,
      'image' => .image,
      'spinner' => .spinner,
      'fractional_position' => .fractionalPosition,
      'nested_component' => .nestedComponent,
      _ => throw _malformed('Unknown slot kind "$value".', path),
    };

ComponentAnatomyNodeKind _nodeKind(String value, {required String path}) =>
    switch (value) {
      'box' => .box,
      'flex_box' => .flexBox,
      'stack_box' => .stackBox,
      'text' => .text,
      'icon' => .icon,
      'image' => .image,
      'spinner' => .spinner,
      'fractional_position' => .fractionalPosition,
      'nested_component' => .nestedComponent,
      _ => throw _malformed('Unknown visual node kind "$value".', path),
    };

bool _slotMatchesNode(ComponentSlotKind slot, ComponentAnatomyNodeKind node) =>
    slot.name == node.name;

bool _nodeUsesStyle(ComponentAnatomyNodeKind kind) => {
  ComponentAnatomyNodeKind.box,
  ComponentAnatomyNodeKind.flexBox,
  ComponentAnatomyNodeKind.stackBox,
  ComponentAnatomyNodeKind.text,
  ComponentAnatomyNodeKind.icon,
  ComponentAnatomyNodeKind.image,
}.contains(kind);

List<String> _identifierList(
  Object? value, {
  required String path,
  required int maximum,
}) {
  final raw = _asList(value, path: path);
  if (raw.length > maximum) {
    throw _malformed('List exceeds $maximum entries.', path);
  }
  final result = <String>[];
  for (var index = 0; index < raw.length; index++) {
    final id = _asIdentifier(raw[index], path: '$path/$index');
    if (!result.addIfAbsent(id)) {
      throw _invalid('Identifiers must be unique.', '$path/$index');
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
    throw _malformed('List count must be between 1 and $maximum.', path);
  }

  return values;
}

Map<String, Object?> _requiredObject(
  Map<String, Object?> value,
  String key, {
  required String path,
}) => _asObject(_requiredValue(value, key, path: path), path: path);

Map<String, Object?> _asObject(Object? value, {required String path}) {
  if (value is! Map<Object?, Object?>) {
    throw _malformed('Expected a JSON object.', path);
  }
  final result = <String, Object?>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw _malformed('JSON object keys must be strings.', path);
    }
    result[entry.key! as String] = entry.value;
  }

  return result;
}

List<Object?> _asList(Object? value, {required String path}) {
  if (value is! List<Object?>) {
    throw _malformed('Expected a JSON list.', path);
  }

  return value;
}

Object? _requiredValue(
  Map<String, Object?> map,
  String key, {
  required String path,
}) {
  if (!map.containsKey(key)) {
    throw _malformed('Required field is missing.', path);
  }

  return map[key];
}

String _requiredString(
  Map<String, Object?> map,
  String key, {
  required String path,
  bool allowEmpty = false,
}) {
  final value = _requiredValue(map, key, path: path);
  if (value is! String || (!allowEmpty && value.trim().isEmpty)) {
    throw _malformed(
      'Expected a${allowEmpty ? '' : ' non-empty'} string.',
      path,
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
  if (value is! bool) throw _malformed('Expected a boolean.', path);

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
    throw _malformed('Expected a stable identifier.', path);
  }

  return result;
}

String _bindingName(String value, {required String path}) {
  if (!_bindingNamePattern.hasMatch(value)) {
    throw _malformed('Expected a safe binding name.', path);
  }

  return value;
}

String _asNonEmptyString(Object? value, {required String path}) {
  if (value is! String || value.trim().isEmpty) {
    throw _malformed('Expected a non-empty string.', path);
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
    throw _malformed('Unknown fields: ${unknown.toList()..sort()}.', path);
  }
}

void _validateArtifactPath(String value, {required String path}) {
  if (value.isEmpty ||
      value.length > 512 ||
      value.startsWith('/') ||
      value.contains('\\') ||
      value.contains('\u0000') ||
      value
          .split('/')
          .any((part) => part.isEmpty || part == '.' || part == '..')) {
    throw ArtifactLoadException(
      .unsafePath,
      'Expected a safe relative artifact path.',
      path: path,
    );
  }
}

bool _isJsonScalar(Object? value) =>
    value == null ||
    value is String ||
    value is bool ||
    (value is num && value.isFinite);

ArtifactLoadException _invalid(String message, String path) =>
    .new(.invalidComponent, message, path: path);

ArtifactLoadException _malformed(String message, String path) =>
    .new(.malformedJson, message, path: path);

final _identifierPattern = RegExp(r'^[A-Za-z][A-Za-z0-9_-]{0,63}$');
final _tokenNamePattern = RegExp(r'^[A-Za-z0-9_.-]{1,128}$');
final _styleIdPattern = RegExp(r'^[A-Za-z][A-Za-z0-9_.:/-]{0,159}$');
final _bindingNamePattern = RegExp(r'^[A-Za-z][A-Za-z0-9_-]{0,63}$');
final _colorPattern = RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$');
const _alignments = {
  'topLeft',
  'topCenter',
  'topRight',
  'centerLeft',
  'center',
  'centerRight',
  'bottomLeft',
  'bottomCenter',
  'bottomRight',
};

extension on List<String> {
  bool addIfAbsent(String value) {
    if (contains(value)) return false;
    add(value);

    return true;
  }
}
