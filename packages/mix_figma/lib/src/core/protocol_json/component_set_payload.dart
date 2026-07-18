import 'package:mix_component_contract/mix_component_contract.dart';

import '../diagnostics/mix_figma_diagnostic.dart';
import '../identity/mix_figma_lock.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';

/// Builds a plugin write payload for a portable component variant grid.
MixFigmaMappingResult<JsonMap> buildComponentSetPayload(
  PortableComponentDocument component, {
  Map<String, JsonMap> resolvedSlotStyles = const {},
  MixFigmaLock lock = const MixFigmaLock(),
}) {
  final diagnostics = <MixFigmaDiagnostic>[
    for (final item in component.diagnostics) _diagnostic(item),
  ];
  final variants = <Object?>[];
  final pluginVariants = <Object?>[];
  for (final node in component.anatomy.nodes.values) {
    if (_unsupportedNodeReason(node) case final String reason) {
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
  for (final recipe in component.recipes) {
    final styles = <String, Object?>{};
    for (final entry in recipe.styles.entries) {
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

    for (final state in component.states.values) {
      final coordinates = <String, Object?>{
        ...recipe.properties,
        'state': state.id,
      };
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
          properties: coordinates,
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
        for (final property in component.properties.values)
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
          'values': component.states.keys.toList(),
          'default': component.states.containsKey('default')
              ? 'default'
              : component.states.keys.first,
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
  required MixFigmaLock lock,
}) {
  final reason = _unsupportedNodeReason(node);
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
        lock: lock,
      ),
  ];
  final kind = _pluginNodeKind(
    node,
    isRoot: node.id == component.anatomy.rootNodeId,
  );

  return {
    'id': node.id,
    'name': node.id,
    'kind': reason == null ? kind : 'UNSUPPORTED',
    'unsupportedReason': ?reason,
    if (node.kind == .flexBox) 'layout': {'mode': 'HORIZONTAL'},
    if (node.kind == .stack || node.kind == .stackBox)
      'layout': {'mode': 'NONE'},
    if (style is Map && _pluginStyle(style.cast()).isNotEmpty)
      'style': _pluginStyle(style.cast()),
    if (node.kind == .text)
      'text': {
        'characters': _bindingValue(
          node.bindings['text'],
          component: component,
          properties: properties,
          fallback: node.id,
        ),
      },
    if (bindings.isNotEmpty) 'variableBindings': bindings,
    if (children.isNotEmpty) 'children': children,
  };
}

String _pluginNodeKind(ComponentAnatomyNode node, {required bool isRoot}) {
  if (isRoot) return 'FRAME';

  return switch (node.kind) {
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

String? _unsupportedNodeReason(ComponentAnatomyNode node) =>
    switch (node.kind) {
      .spinner => 'Spinner has no neutral Figma component primitive.',
      .icon => 'Icon requires an instance-swap component library mapping.',
      .image =>
        'Image source cannot be embedded in the neutral component payload.',
      .fractionalPosition =>
        'Fractional positioning cannot be represented losslessly.',
      .nestedComponent =>
        'Nested component references require a Figma library mapping.',
      .slot => 'Legacy slot anatomy requires a concrete Figma primitive.',
      .stack || .box || .flexBox || .stackBox || .text => null,
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

JsonMap _pluginStyle(JsonMap document) {
  final result = <String, Object?>{};
  final opacity = document['opacity'];
  if (opacity is num) result['opacity'] = opacity;
  final decoration = document['decoration'] is Map
      ? (document['decoration']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  if (decoration['color'] case final String color) {
    result['fills'] = [
      {'type': 'SOLID', 'color': color, 'visible': true},
    ];
  }
  final radius = decoration['borderRadius'];
  if (radius is num) result['cornerRadius'] = radius;

  return result;
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
