import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'artifacts/capture_bundle.dart';
import 'artifacts/component_document.dart';

/// A data-only selection for one deterministic component render.
final class PortableComponentSelection {
  final String recipeId;
  final String stateId;
  final String themeId;
  final Map<String, Object?> properties;

  const PortableComponentSelection({
    required this.recipeId,
    required this.stateId,
    required this.themeId,
    this.properties = const {},
  });
}

/// Renders the fixed component-v1 vocabulary without loading producer code.
///
/// The document can select only Stack, FlexBox, StyledText, and StyledIcon.
/// Interaction callbacks and icon identities are supplied by this app, never
/// by repository JSON.
class PortableComponentRenderer extends StatelessWidget {
  const PortableComponentRenderer({
    required this.capture,
    required this.component,
    required this.selection,
    this.onActivate,
    super.key,
  });

  final LoadedCapture capture;
  final PortableComponentDocument component;
  final PortableComponentSelection selection;
  final VoidCallback? onActivate;

  @override
  Widget build(BuildContext context) {
    final render = _ResolvedRender.resolve(
      capture: capture,
      component: component,
      selection: selection,
    );
    final body = _AnatomyRenderer(render: render).buildRoot();
    final canActivate = render.enabled && !render.loading;

    return MixScope(
      tokens: capture.protocolThemes[selection.themeId]!.tokens,
      child: WidgetStateStyleOverride(
        states: render.widgetStates,
        child: Semantics(
          key: const ValueKey('portable-component-button'),
          container: true,
          enabled: canActivate,
          button: true,
          liveRegion: render.loading,
          label: render.label,
          child: ExcludeSemantics(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: canActivate ? onActivate : null,
                canRequestFocus: canActivate,
                child: body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _ResolvedRender {
  final LoadedCapture capture;
  final PortableComponentDocument component;
  final PortableComponentRecipe recipe;
  final ComponentStateDefinition state;
  final String themeId;
  final Map<String, Object?> properties;
  final Set<WidgetState> widgetStates;

  _ResolvedRender({
    required this.capture,
    required this.component,
    required this.recipe,
    required this.state,
    required this.themeId,
    required Map<String, Object?> properties,
    required Set<WidgetState> widgetStates,
  }) : properties = UnmodifiableMapView(properties),
       widgetStates = Set.unmodifiable(widgetStates);

  factory _ResolvedRender.resolve({
    required LoadedCapture capture,
    required PortableComponentDocument component,
    required PortableComponentSelection selection,
  }) {
    final recipe = component.recipes
        .where((candidate) => candidate.id == selection.recipeId)
        .singleOrNull;
    final state = component.states[selection.stateId];
    if (recipe == null || state == null) {
      throw ArgumentError('Selection references an unknown recipe or state.');
    }
    if (!component.oracles.containsKey(selection.themeId) ||
        !capture.protocolThemes.containsKey(selection.themeId)) {
      throw ArgumentError('Selection references an unknown theme.');
    }
    final unknownProperties = selection.properties.keys.toSet().difference(
      component.properties.keys.toSet(),
    );
    if (unknownProperties.isNotEmpty) {
      throw ArgumentError('Selection contains unknown component properties.');
    }
    final values = <String, Object?>{
      for (final definition in component.properties.values)
        definition.id: definition.defaultValue,
      ...recipe.properties,
      ...selection.properties,
      ...state.propertyOverrides,
    };
    for (final definition in component.properties.values) {
      if (!_isValidValue(definition, values[definition.id])) {
        throw ArgumentError(
          'Selection property "${definition.id}" has an invalid value.',
        );
      }
    }

    return _ResolvedRender(
      capture: capture,
      component: component,
      recipe: recipe,
      state: state,
      themeId: selection.themeId,
      properties: values,
      widgetStates: {
        for (final state in state.widgetStates) _widgetState(state),
      },
    );
  }

  String get label =>
      properties[component.semantics.labelPropertyId]! as String;

  bool get enabled =>
      properties[component.semantics.enabledPropertyId]! as bool;

  bool get loading =>
      properties[component.semantics.loadingPropertyId]! as bool;
}

final class _AnatomyRenderer {
  final _ResolvedRender render;

  const _AnatomyRenderer({required this.render});

  Widget _buildNode(ComponentAnatomyNode node) {
    final children = [
      for (final child in node.children)
        _buildNode(render.component.anatomy.nodes[child]!),
    ];
    if (node.kind == .stack) {
      return Stack(alignment: .center, children: children);
    }

    final slot = render.component.slots[node.slotId]!;
    final reference = render.recipe.styleFor(slot.id);
    final child = reference.isSupported
        ? _buildSupportedSlot(slot, reference, children)
        : _UnsupportedSlot(slotId: slot.id, children: children);
    final condition = node.visibleWhen;
    if (condition == null) return child;
    final visible = _conditionMatches(condition, render.properties);

    return Visibility(
      visible: visible,
      maintainState: node.maintainedFeatures.contains('state'),
      maintainAnimation: node.maintainedFeatures.contains('animation'),
      maintainSize: node.maintainedFeatures.contains('size'),
      child: child,
    );
  }

  Widget _buildSupportedSlot(
    ComponentSlotDefinition slot,
    ComponentSlotStyleReference reference,
    List<Widget> children,
  ) {
    final style = render.capture.styleDocuments[reference.documentPath]!;

    return switch (slot.kind) {
      .flexBox => FlexBox(style: style as FlexBoxStyler, children: children),
      .text => StyledText(render.label, style: style as TextStyler),
      .icon => StyledIcon(
        icon: _resolveIcon(render.properties[slot.id]),
        style: style as IconStyler,
      ),
      .spinner => _UnsupportedSlot(slotId: slot.id, children: children),
    };
  }

  Widget buildRoot() => _buildNode(render.component.anatomy.root);
}

class _UnsupportedSlot extends StatelessWidget {
  const _UnsupportedSlot({required this.slotId, required this.children});

  final String slotId;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        border: .all(color: const Color(0xFFE2B84B)),
        borderRadius: .circular(6),
      ),
      child: Padding(
        padding: const .symmetric(vertical: 4, horizontal: 7),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              'Unsupported · $slotId',
              style: const TextStyle(
                color: Color(0xFF725D24),
                fontSize: 10,
                fontWeight: .w700,
              ),
            ),
            if (children.isNotEmpty)
              Row(mainAxisSize: .min, children: children),
          ],
        ),
      ),
    );
  }
}

bool _conditionMatches(
  ComponentVisibilityCondition condition,
  Map<String, Object?> properties,
) {
  final value = properties[condition.propertyId];

  return switch (condition.operator) {
    .equals => value == condition.value,
    .present => value != null && value != '',
  };
}

bool _isValidValue(ComponentPropertyDefinition definition, Object? value) {
  return switch (definition.kind) {
    .enumeration => value is String && definition.values.contains(value),
    .string => value is String,
    .boolean => value is bool,
    .icon =>
      value == null || (value is String && _iconIdentities.containsKey(value)),
  };
}

WidgetState _widgetState(String value) => switch (value) {
  'hovered' => .hovered,
  'pressed' => .pressed,
  'focused' => .focused,
  'disabled' => .disabled,
  'selected' => .selected,
  _ => throw StateError('Parser admitted an unknown widget state.'),
};

IconData? _resolveIcon(Object? value) =>
    value == null ? null : _iconIdentities[value]!;

const _iconIdentities = {
  'add': Icons.add,
  'arrow_forward': Icons.arrow_forward,
  'check': Icons.check,
  'close': Icons.close,
};
