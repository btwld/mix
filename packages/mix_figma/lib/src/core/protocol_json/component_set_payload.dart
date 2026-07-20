import 'package:mix_component_contract/mix_component_contract.dart';

import '../diagnostics/mix_figma_diagnostic.dart';
import '../identity/mix_figma_lock.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';

/// Builds a plugin write payload for a portable component variant grid.
MixFigmaMappingResult<JsonMap> buildComponentSetPayload(
  PortableComponentDocument component, {
  Map<String, JsonMap> resolvedSlotStyles = const {},
  MixFigmaLock lock = .empty,
}) {
  final diagnostics = <MixFigmaDiagnostic>[
    for (final item in component.diagnostics) _diagnostic(item),
  ];
  final variants = <Object?>[];
  final pluginVariants = <Object?>[];
  final anatomyNodes = component.anatomy.nodes.values.toList()
    ..sort((left, right) => left.id.compareTo(right.id));
  for (final node in anatomyNodes) {
    if (_unsupportedNodeReason(component, node) case final String reason) {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'unsupported_component_anatomy_node',
          severity: .warning,
          path: '/anatomy/nodes/${node.id}',
          message: reason,
        ),
      );
    }
  }
  final recipes = component.recipes.toList()
    ..sort((left, right) => left.id.compareTo(right.id));
  final states = component.states.values.toList()..sort(_compareStates);
  for (final recipe in recipes) {
    final styles = <String, Object?>{};
    final styleEntries = recipe.styles.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key));
    for (final entry in styleEntries) {
      final reference = entry.value;
      if (!reference.isSupported) {
        final referenceDiagnostics = reference.diagnostics.map(_diagnostic);
        diagnostics.addAll(referenceDiagnostics);
        styles[entry.key] = {
          'status': 'unsupported',
          'diagnostics': referenceDiagnostics
              .map((diagnostic) => diagnostic.toJson())
              .toList(),
        };
        continue;
      }
      final document = reference.styleId == null
          ? resolvedSlotStyles[reference.documentPath]
          : component.styleLibrary[reference.styleId]?.document;
      if (document == null) {
        final diagnostic = MixFigmaDiagnostic(
          code: 'missing_component_style',
          severity: .error,
          path: '/recipes/${recipe.id}/styles/${entry.key}',
          message: 'The supported slot style could not be resolved.',
        );
        diagnostics.add(diagnostic);
        styles[entry.key] = {
          'status': 'unsupported',
          'diagnostics': [diagnostic.toJson()],
        };
      } else {
        styles[entry.key] = document;
      }
    }

    for (final state in states) {
      final coordinates = <String, Object?>{
        ...recipe.properties,
        'state': state.id,
      };
      final properties = _effectiveProperties(component, recipe, state);
      variants.add({
        'name': coordinates.entries
            .map((entry) => '${entry.key}=${entry.value ?? 'null'}')
            .join(','),
        'properties': coordinates,
        'widgetStates': state.widgetStates.toList()..sort(),
        'propertyOverrides': state.propertyOverrides,
        'anatomy': _anatomy(component.anatomy),
        'styles': styles,
      });
      pluginVariants.add({
        'ref': '${recipe.id}-${state.id}',
        'properties': coordinates,
        'root': _pluginNode(
          component,
          component.anatomy.root,
          styles: styles,
          properties: properties,
          widgetStates: state.widgetStates,
          lock: lock,
        ),
      });
    }
  }

  return MixFigmaMappingResult(
    value: {
      'version': 1,
      'schema': 'mix_figma/component-set-write/v1',
      'id': component.id,
      'ref': component.id,
      'name': component.label,
      'sourceId': ?lock.componentIds[component.id],
      'variants': pluginVariants,
      'identity': {
        'id': component.id,
        'kind': 'componentSet',
        'protocolVersion': 1,
      },
      'diagnostics': diagnostics.map((item) => item.toJson()).toList(),
      'properties': [
        for (final property
            in component.properties.values.toList()
              ..sort((left, right) => left.id.compareTo(right.id)))
          {
            'id': property.id,
            'type': _figmaPropertyType(property.kind),
            if (property.values.isNotEmpty) 'values': property.values,
            'default': ?property.defaultValue,
            'required': property.isRequired,
          },
        {
          'id': 'state',
          'type': 'VARIANT',
          'values': states.map((state) => state.id).toList(),
          'default': component.states.containsKey('default')
              ? 'default'
              : states.first.id,
          'required': true,
        },
      ],
      'components': variants,
    },
    diagnostics: diagnostics,
  );
}

JsonMap _pluginNode(
  PortableComponentDocument component,
  ComponentAnatomyNode node, {
  required JsonMap styles,
  required JsonMap properties,
  required Set<String> widgetStates,
  required MixFigmaLock lock,
}) {
  final kind = _effectiveKind(component, node);
  final reason = _unsupportedNodeReason(component, node);
  final style = node.slotId == null ? null : styles[node.slotId];
  final bindings = <String, Object?>{};
  for (final entry in node.bindings.entries) {
    final binding = entry.value;
    if (binding.kind == .token) {
      final tokenKey = _tokenKey(binding.tokenKind!, binding.tokenName!);
      bindings[_pluginBindingField(entry.key)] =
          lock.variableIds[tokenKey] ?? binding.tokenName;
    }
  }
  final children = [
    for (final childId in node.children)
      _pluginNode(
        component,
        component.anatomy.nodes[childId]!,
        styles: styles,
        properties: properties,
        widgetStates: widgetStates,
        lock: lock,
      ),
  ];
  final pluginKind = _pluginNodeKind(
    kind,
    isRoot: node.id == component.anatomy.rootNodeId,
  );
  final styleDocument = style is Map
      ? style.cast<String, Object?>()
      : const <String, Object?>{};
  final pluginStyle = _pluginStyle(styleDocument);
  final pluginLayout = _pluginLayout(kind, styleDocument);

  return {
    'id': node.id,
    'name': node.id,
    'kind': reason == null ? pluginKind : 'UNSUPPORTED',
    'unsupportedReason': ?reason,
    if (pluginLayout.isNotEmpty) 'layout': pluginLayout,
    if (pluginStyle.isNotEmpty) 'style': pluginStyle,
    if (kind == .text)
      'text': {
        'characters': _bindingValue(
          _textBinding(component, node),
          component: component,
          properties: properties,
          fallback: node.id,
        ),
        ..._pluginTextStyle(styleDocument),
      },
    if (node.visibleWhen != null)
      'visible': _isVisible(
        node.visibleWhen!,
        properties: properties,
        widgetStates: widgetStates,
      ),
    if (bindings.isNotEmpty) 'variableBindings': bindings,
    if (children.isNotEmpty) 'children': children,
  };
}

ComponentAnatomyNodeKind _effectiveKind(
  PortableComponentDocument component,
  ComponentAnatomyNode node,
) {
  if (node.kind != .slot) return node.kind;

  return switch (component.slots[node.slotId]?.kind) {
    .box => .box,
    .flexBox => .flexBox,
    .stackBox => .stackBox,
    .text => .text,
    .icon => .icon,
    .image => .image,
    .spinner => .spinner,
    .fractionalPosition => .fractionalPosition,
    .nestedComponent => .nestedComponent,
    null => .slot,
  };
}

String _pluginNodeKind(ComponentAnatomyNodeKind kind, {required bool isRoot}) {
  if (isRoot) return 'FRAME';

  return switch (kind) {
    .text => 'TEXT',
    .box => 'RECTANGLE',
    .flexBox || .stack || .stackBox => 'FRAME',
    .slot ||
    .icon ||
    .image ||
    .spinner ||
    .fractionalPosition ||
    .nestedComponent => 'UNSUPPORTED',
  };
}

String? _unsupportedNodeReason(
  PortableComponentDocument component,
  ComponentAnatomyNode node,
) {
  final kind = _effectiveKind(component, node);
  if (kind == .slot) {
    return 'Legacy slot "${node.slotId ?? node.id}" has no slot definition.';
  }

  return switch (kind) {
    .spinner => 'Spinner has no neutral Figma component primitive.',
    .icon => 'Icon requires an instance-swap component library mapping.',
    .image =>
      'Image source cannot be embedded in the neutral component payload.',
    .fractionalPosition =>
      'Fractional positioning cannot be represented losslessly.',
    .nestedComponent =>
      'Nested component references require a Figma library mapping.',
    .slot => null,
    .stack || .box || .flexBox || .stackBox || .text => null,
  };
}

JsonMap _effectiveProperties(
  PortableComponentDocument component,
  PortableComponentRecipe recipe,
  ComponentStateDefinition state,
) => {
  for (final property in component.properties.values)
    ...?_defaultPropertyMap(property),
  ...recipe.properties,
  ...state.propertyOverrides,
};

JsonMap? _defaultPropertyMap(ComponentPropertyDefinition property) {
  final value = property.defaultValue;

  return value == null ? null : {property.id: value};
}

int _compareStates(
  ComponentStateDefinition left,
  ComponentStateDefinition right,
) {
  if (left.id == 'default') return right.id == 'default' ? 0 : -1;
  if (right.id == 'default') return 1;

  return left.id.compareTo(right.id);
}

bool _isVisible(
  ComponentVisibilityCondition condition, {
  required JsonMap properties,
  required Set<String> widgetStates,
}) => switch (condition.source) {
  .property => switch (condition.operator) {
    .equals => properties[condition.reference] == condition.value,
    .notEquals => properties[condition.reference] != condition.value,
    .present => properties[condition.reference] != null,
    .absent => properties[condition.reference] == null,
    .active || .inactive => false,
  },
  .widgetState => switch (condition.operator) {
    .active => widgetStates.contains(condition.reference),
    .inactive => !widgetStates.contains(condition.reference),
    .equals || .notEquals || .present || .absent => false,
  },
};

String _tokenKey(String kind, String name) => switch (kind) {
  'color' => 'colors/$name',
  'space' => 'spaces/$name',
  'double' => 'doubles/$name',
  'radius' => 'radii/$name',
  'fontWeight' => 'fontWeights/$name',
  _ => '$kind/$name',
};

String _pluginBindingField(String field) => switch (field) {
  'color' => 'fill',
  _ => field,
};

Object? _bindingValue(
  AtlasPortableBinding? binding, {
  required PortableComponentDocument component,
  required JsonMap properties,
  required Object fallback,
}) {
  if (binding == null) return fallback;

  return switch (binding.kind) {
    .literal => binding.literalValue,
    .property =>
      properties[binding.propertyId] ??
          component.properties[binding.propertyId]?.defaultValue ??
          fallback,
    .token => binding.tokenName,
  };
}

AtlasPortableBinding? _textBinding(
  PortableComponentDocument component,
  ComponentAnatomyNode node,
) =>
    node.bindings['text'] ??
    (node.slotId != null && node.slotId == component.semantics.labelPropertyId
        ? component.semantics.bindings['label']
        : null);

JsonMap _pluginStyle(JsonMap document) {
  final result = <String, Object?>{};
  final modifiers = document['modifiers'] is List
      ? (document['modifiers']! as List).whereType<Map>()
      : const Iterable<Map>.empty();
  num? modifierOpacity;
  for (final modifier in modifiers) {
    if (modifier['type'] == 'opacity' && modifier['opacity'] is num) {
      modifierOpacity = modifier['opacity']! as num;
      break;
    }
  }
  final opacity = document['opacity'] ?? modifierOpacity;
  if (opacity is num) result['opacity'] = opacity;
  final decoration = document['decoration'] is Map
      ? (document['decoration']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  final textStyle = document['style'] is Map
      ? (document['style']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  final fillColor = textStyle['color'] ?? decoration['color'];
  if (fillColor case final String color) {
    result['fills'] = [_pluginPaint(color)];
  }
  final radius = decoration['borderRadius'];
  if (radius is num) result['cornerRadius'] = radius;
  if (_uniformBorder(decoration['border']) case final border?) {
    result['strokes'] = [_pluginPaint(border.color)];
    result['strokeWeight'] = border.width;
  }
  if (decoration['boxShadow'] is List) {
    final effects = (decoration['boxShadow']! as List)
        .whereType<Map>()
        .map((item) => item.cast<String, Object?>())
        .where((item) => item['color'] is String)
        .map((shadow) {
          final offset = shadow['offset'] is Map
              ? (shadow['offset']! as Map).cast<String, Object?>()
              : const <String, Object?>{};

          return <String, Object?>{
            'type': 'DROP_SHADOW',
            'color': _rgba(shadow['color']),
            'offset': {'x': offset['x'] ?? 0, 'y': offset['y'] ?? 0},
            'radius': shadow['blurRadius'] ?? 0,
            if (shadow['spreadRadius'] != null)
              'spread': shadow['spreadRadius'],
            'blendMode': 'NORMAL',
            'visible': true,
          };
        })
        .toList(growable: false);
    if (effects.isNotEmpty) result['effects'] = effects;
  }

  return result;
}

JsonMap _pluginLayout(ComponentAnatomyNodeKind kind, JsonMap document) {
  if (kind == .stack || kind == .stackBox) return {'mode': 'NONE'};
  if (kind != .flexBox) return const {};
  final padding = document['padding'] is Map
      ? (document['padding']! as Map).cast<String, Object?>()
      : const <String, Object?>{};

  return {
    'mode': document['direction'] == 'vertical' ? 'VERTICAL' : 'HORIZONTAL',
    'primaryAxisAlignItems': ?_mainAxisAlignment(document['mainAxisAlignment']),
    'counterAxisAlignItems': ?_crossAxisAlignment(
      document['crossAxisAlignment'],
    ),
    if (document['spacing'] is num) 'itemSpacing': document['spacing'],
    if (padding['top'] is num) 'paddingTop': padding['top'],
    if (padding['right'] is num) 'paddingRight': padding['right'],
    if (padding['bottom'] is num) 'paddingBottom': padding['bottom'],
    if (padding['left'] is num) 'paddingLeft': padding['left'],
  };
}

JsonMap _pluginTextStyle(JsonMap document) {
  final style = document['style'] is Map
      ? (document['style']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  final fontFamily = style['fontFamily'];
  final fontWeight = style['fontWeight'];
  final height = style['height'];
  final letterSpacing = style['letterSpacing'];

  return {
    if (fontFamily is String)
      'fontName': {
        'family': fontFamily,
        'style': _figmaFontStyle(fontWeight, style['fontStyle']),
      },
    if (style['fontSize'] is num) 'fontSize': style['fontSize'],
    if (height is num) 'lineHeight': {'unit': 'PERCENT', 'value': height * 100},
    if (letterSpacing is num)
      'letterSpacing': {'unit': 'PIXELS', 'value': letterSpacing},
  };
}

String? _mainAxisAlignment(Object? value) => switch (value) {
  'start' => 'MIN',
  'end' => 'MAX',
  'center' => 'CENTER',
  'spaceBetween' => 'SPACE_BETWEEN',
  _ => null,
};

String? _crossAxisAlignment(Object? value) => switch (value) {
  'start' => 'MIN',
  'end' => 'MAX',
  'center' => 'CENTER',
  'baseline' => 'BASELINE',
  _ => null,
};

String _figmaFontStyle(Object? weight, Object? style) {
  final number =
      (weight is String && weight.startsWith('w')
          ? int.tryParse(weight.substring(1))
          : weight is num
          ? weight.round()
          : null) ??
      400;
  final label = switch (number) {
    <= 100 => 'Thin',
    <= 200 => 'Extra Light',
    <= 300 => 'Light',
    <= 400 => 'Regular',
    <= 500 => 'Medium',
    <= 600 => 'Semi Bold',
    <= 700 => 'Bold',
    <= 800 => 'Extra Bold',
    _ => 'Black',
  };

  return style == 'italic' ? '$label Italic' : label;
}

({String color, num width})? _uniformBorder(Object? value) {
  if (value is! Map) return null;
  final border = value.cast<String, Object?>();
  final sides = ['top', 'right', 'bottom', 'left']
      .map((name) => border[name])
      .whereType<Map>()
      .map((side) => side.cast<String, Object?>())
      .toList();
  if (sides.isEmpty) return null;
  final first = sides.first;
  final color = first['color'];
  final width = first['width'];
  if (color is! String || width is! num) return null;
  if (sides.any((side) => side['color'] != color || side['width'] != width)) {
    return null;
  }

  return (color: color, width: width);
}

JsonMap _pluginPaint(String color) {
  final rgba = _rgba(color);

  return {
    'type': 'SOLID',
    'color': {'r': rgba['r'], 'g': rgba['g'], 'b': rgba['b']},
    'opacity': rgba['a'],
    'visible': true,
  };
}

JsonMap _rgba(Object? value) {
  if (value is! String ||
      !RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    throw const FormatException('Expected protocol hex color.');
  }
  final hex = value.substring(1);
  final hasAlpha = hex.length == 8;
  final offset = hasAlpha ? 2 : 0;
  double channel(int start) =>
      int.parse(hex.substring(offset + start, offset + start + 2), radix: 16) /
      255;

  return {
    'r': channel(0),
    'g': channel(2),
    'b': channel(4),
    'a': hasAlpha ? int.parse(hex.substring(0, 2), radix: 16) / 255 : 1.0,
  };
}

JsonMap _anatomy(ComponentAnatomy anatomy) => {
  'root': anatomy.rootNodeId,
  'nodes': [for (final node in anatomy.nodes.values) _node(node)],
};

JsonMap _node(ComponentAnatomyNode node) => {
  'id': node.id,
  'kind': _nodeKind(node.kind),
  'layoutMode': switch (node.kind) {
    .flexBox => 'HORIZONTAL',
    .stack || .stackBox => 'NONE',
    .slot ||
    .box ||
    .text ||
    .icon ||
    .image ||
    .spinner ||
    .fractionalPosition ||
    .nestedComponent => 'NONE',
  },
  'slot': ?node.slotId,
  'children': node.children,
  'alignment': ?node.alignment,
  if (node.visibleWhen != null)
    'visibleWhen': {
      if (node.visibleWhen!.propertyId != null)
        'property': node.visibleWhen!.propertyId,
      if (node.visibleWhen!.widgetState != null)
        'state': node.visibleWhen!.widgetState,
      'operator': node.visibleWhen!.operator.name,
      if (node.visibleWhen!.value != null) 'value': node.visibleWhen!.value,
    },
  if (node.bindings.isNotEmpty)
    'bindings': {
      for (final entry in node.bindings.entries)
        entry.key: entry.value.toJson(),
    },
  'component': ?node.componentId,
  'recipe': ?node.recipeBinding?.toJson(),
  'state': ?node.stateBinding?.toJson(),
  if (node.propertyBindings.isNotEmpty)
    'properties': {
      for (final entry in node.propertyBindings.entries)
        entry.key: entry.value.toJson(),
    },
};

String _figmaPropertyType(ComponentPropertyKind kind) => switch (kind) {
  .enumeration => 'VARIANT',
  .boolean => 'BOOLEAN',
  .icon => 'INSTANCE_SWAP',
  .string || .number || .duration => 'TEXT',
};

String _nodeKind(ComponentAnatomyNodeKind kind) => switch (kind) {
  .flexBox => 'flex_box',
  .stackBox => 'stack_box',
  .fractionalPosition => 'fractional_position',
  .nestedComponent => 'nested_component',
  .stack || .slot || .box || .text || .icon || .image || .spinner => kind.name,
};

MixFigmaDiagnostic _diagnostic(ComponentDiagnostic diagnostic) => .new(
  code: diagnostic.code,
  severity: switch (diagnostic.severity) {
    'error' => .error,
    'warning' => .warning,
    _ => .info,
  },
  path: diagnostic.path,
  message: diagnostic.message,
);
