import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

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

/// Renders component-v1 and component-v2 documents without producer code.
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
    final semantics = _ResolvedSemantics(render);
    final canActivate = semantics.enabled && semantics.isInteractive;

    return MixScope(
      tokens: capture.protocolThemes[selection.themeId]!.tokens,
      child: WidgetStateStyleOverride(
        states: render.widgetStates,
        child: Semantics(
          key: ValueKey('portable-component-${component.id}'),
          container: true,
          enabled: semantics.optionalBool('enabled'),
          checked: semantics.optionalBool('checked'),
          mixed: semantics.boolValue('mixed'),
          selected: semantics.boolValue('selected'),
          toggled: semantics.optionalBool('toggled'),
          button: semantics.role == 'button',
          slider: semantics.role == 'slider',
          link: semantics.role == 'link',
          header: semantics.role == 'header',
          textField: semantics.role == 'textField',
          readOnly: semantics.boolValue('readOnly'),
          focusable: semantics.boolValue('focusable'),
          focused: semantics.boolValue('focused'),
          inMutuallyExclusiveGroup: semantics.role == 'radio',
          obscured: semantics.boolValue('obscured'),
          multiline: semantics.boolValue('multiline'),
          hidden: semantics.boolValue('hidden'),
          image: semantics.role == 'image',
          liveRegion: semantics.boolValue('liveRegion'),
          expanded: semantics.optionalBool('expanded'),
          isRequired: semantics.optionalBool('required'),
          maxValueLength: semantics.intValue('maxValueLength'),
          currentValueLength: semantics.intValue('currentValueLength'),
          label: semantics.stringValue('label'),
          value: semantics.stringValue('value'),
          increasedValue: semantics.stringValue('increasedValue'),
          decreasedValue: semantics.stringValue('decreasedValue'),
          hint: semantics.stringValue('hint'),
          onTap: canActivate ? onActivate : null,
          role: semantics.flutterRole,
          validationResult: semantics.boolValue('invalid') ? .invalid : .none,
          child: ExcludeSemantics(
            child: onActivate == null
                ? body
                : GestureDetector(
                    onTap: canActivate ? onActivate : null,
                    behavior: .translucent,
                    child: body,
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
        for (final widgetState in state.widgetStates) _widgetState(widgetState),
      },
    );
  }

  Object? resolve(AtlasPortableBinding binding) => switch (binding.kind) {
    .literal => binding.literalValue,
    .property => properties[binding.propertyId],
    .token => _resolveToken(
      capture,
      themeId: themeId,
      kind: binding.tokenKind!,
      name: binding.tokenName!,
    ),
  };

  Object styleFor(String slotId) {
    final reference = recipe.styleFor(slotId);
    if (!reference.isSupported) {
      throw StateError('Unsupported styles are component-v1 placeholders.');
    }
    final key = component.schema == .v2
        ? componentStyleDocumentKey(component.id, reference.styleId!)
        : reference.documentPath!;

    return capture.styleDocuments[key]!;
  }
}

final class _ResolvedSemantics {
  final _ResolvedRender render;

  const _ResolvedSemantics(this.render);

  String get role => render.component.semantics.role;

  bool get enabled => optionalBool('enabled') ?? true;

  SemanticsRole get flutterRole => switch (role) {
    'tab' => .tab,
    'dialog' => .dialog,
    'menu' => .menu,
    'menuItem' => .menuItem,
    'tooltip' => .tooltip,
    'status' => .status,
    'progressIndicator' =>
      value('value') == null ? .loadingSpinner : .progressBar,
    _ => .none,
  };

  bool get isInteractive => const {
    'button',
    'link',
    'checkbox',
    'radio',
    'switch',
    'slider',
    'textField',
    'menuItem',
    'tab',
  }.contains(role);

  Object? value(String name) {
    final binding = render.component.semantics.bindings[name];

    return binding == null ? null : render.resolve(binding);
  }

  String? stringValue(String name) {
    final result = value(name);
    if (result == null) return null;

    return result.toString();
  }

  bool boolValue(String name) => value(name) == true;

  bool? optionalBool(String name) {
    final result = value(name);

    return result is bool ? result : null;
  }

  int? intValue(String name) {
    final result = value(name);

    return result is int ? result : null;
  }
}

final class _AnatomyRenderer {
  final _ResolvedRender render;

  const _AnatomyRenderer({required this.render});

  Widget _buildNode(ComponentAnatomyNode node) {
    final children = <Widget>[];
    for (final childId in node.children) {
      final child = render.component.anatomy.nodes[childId]!;
      if (_shouldOmit(child)) continue;
      children.add(_buildNode(child));
    }
    final child = switch (node.kind) {
      .stack => Stack(alignment: .center, children: children),
      .slot => _buildV1Slot(node, children),
      .box => Box(
        style: render.styleFor(node.slotId!) as BoxStyler,
        child: _singleOrColumn(children),
      ),
      .flexBox => FlexBox(
        style: render.styleFor(node.slotId!) as FlexBoxStyler,
        children: children,
      ),
      .stackBox => StackBox(
        style: render.styleFor(node.slotId!) as StackBoxStyler,
        children: children,
      ),
      .text => StyledText(
        _stringBinding(node, 'text'),
        style: render.styleFor(node.slotId!) as TextStyler,
      ),
      .icon => StyledIcon(
        icon: _iconBinding(node, 'icon'),
        style: render.styleFor(node.slotId!) as IconStyler,
      ),
      .image => StyledImage(
        style: render.styleFor(node.slotId!) as ImageStyler,
        image: MemoryImage(render.capture.file(_stringBinding(node, 'source'))),
      ),
      .spinner => _buildSpinner(node),
      .fractionalPosition => _buildFractionalPosition(node, children.single),
      .nestedComponent => _buildNestedComponent(node),
    };
    final condition = node.visibleWhen;
    if (condition == null) return child;

    return Visibility(
      visible: _conditionMatches(condition),
      maintainState: node.maintainedFeatures.contains('state'),
      maintainAnimation: node.maintainedFeatures.contains('animation'),
      maintainSize: node.maintainedFeatures.contains('size'),
      maintainSemantics: node.maintainedFeatures.contains('semantics'),
      child: child,
    );
  }

  Widget _buildV1Slot(ComponentAnatomyNode node, List<Widget> children) {
    final slot = render.component.slots[node.slotId]!;
    final reference = render.recipe.styleFor(slot.id);
    if (!reference.isSupported) {
      return _UnsupportedV1Slot(slotId: slot.id, children: children);
    }
    final style = render.styleFor(slot.id);

    return switch (slot.kind) {
      .flexBox => FlexBox(style: style as FlexBoxStyler, children: children),
      .text => StyledText(_legacyLabel, style: style as TextStyler),
      .icon => StyledIcon(
        icon: _resolveIcon(render.properties[slot.id]),
        style: style as IconStyler,
      ),
      .spinner => _UnsupportedV1Slot(slotId: slot.id, children: children),
      .box ||
      .stackBox ||
      .image ||
      .fractionalPosition ||
      .nestedComponent => throw StateError('Component-v1 admitted a v2 slot.'),
    };
  }

  Widget _buildSpinner(ComponentAnatomyNode node) {
    final duration = _optionalBinding(node, 'duration');

    return _PortableArcSpinner(
      size: _optionalDoubleBinding(node, 'size') ?? 24,
      value: _optionalDoubleBinding(node, 'value'),
      strokeWidth: _optionalDoubleBinding(node, 'strokeWidth') ?? 1.5,
      color: _optionalColorBinding(node, 'color'),
      trackColor:
          _optionalColorBinding(node, 'trackColor') ??
          _optionalColorBinding(node, 'backgroundColor'),
      trackStrokeWidth: _optionalDoubleBinding(node, 'trackStrokeWidth'),
      duration: Duration(milliseconds: duration is int ? duration : 1000),
    );
  }

  Widget _buildFractionalPosition(ComponentAnatomyNode node, Widget child) {
    final alignmentValue = _optionalBinding(node, 'alignment');

    return FractionallySizedBox(
      alignment: alignmentValue == null
          ? Alignment.center
          : _alignment(alignmentValue.toString()),
      widthFactor: _optionalDoubleBinding(node, 'widthFactor'),
      heightFactor: _optionalDoubleBinding(node, 'heightFactor'),
      child: child,
    );
  }

  Widget _buildNestedComponent(ComponentAnatomyNode node) {
    final component = render.capture.componentDocuments.singleWhere(
      (candidate) => candidate.id == node.componentId,
    );
    final recipeId = render.resolve(node.recipeBinding!);
    final stateId = render.resolve(node.stateBinding!);
    if (recipeId is! String || stateId is! String) {
      throw StateError('Validated nested coordinates did not resolve to IDs.');
    }

    return PortableComponentRenderer(
      capture: render.capture,
      component: component,
      selection: PortableComponentSelection(
        recipeId: recipeId,
        stateId: stateId,
        themeId: render.themeId,
        properties: {
          for (final entry in node.propertyBindings.entries)
            entry.key: render.resolve(entry.value),
        },
      ),
    );
  }

  bool _shouldOmit(ComponentAnatomyNode node) {
    final condition = node.visibleWhen;

    return condition != null &&
        node.maintainedFeatures.isEmpty &&
        !_conditionMatches(condition);
  }

  bool _conditionMatches(ComponentVisibilityCondition condition) {
    if (condition.source == .widgetState) {
      final active = render.widgetStates.contains(
        _widgetState(condition.widgetState!),
      );

      return condition.operator == .active ? active : !active;
    }
    final value = render.properties[condition.propertyId];

    return switch (condition.operator) {
      .equals => value == condition.value,
      .notEquals => value != condition.value,
      .present => value != null && value != '',
      .absent => value == null || value == '',
      .active || .inactive => throw StateError(
        'Validated property condition used a state operator.',
      ),
    };
  }

  Object? _optionalBinding(ComponentAnatomyNode node, String name) {
    final binding = node.bindings[name];

    return binding == null ? null : render.resolve(binding);
  }

  String _stringBinding(ComponentAnatomyNode node, String name) {
    final value = _optionalBinding(node, name);
    if (value == null) return '';

    return value.toString();
  }

  double? _optionalDoubleBinding(ComponentAnatomyNode node, String name) {
    final value = _optionalBinding(node, name);

    return value is num ? value.toDouble() : null;
  }

  Color? _optionalColorBinding(ComponentAnatomyNode node, String name) {
    final value = _optionalBinding(node, name);
    if (value == null) return null;
    if (value is Color) return value;
    if (value is String) return _parseColor(value);

    throw StateError(
      'Validated color binding resolved to ${value.runtimeType}.',
    );
  }

  IconData? _iconBinding(ComponentAnatomyNode node, String name) =>
      _resolveIcon(_optionalBinding(node, name));

  String get _legacyLabel {
    final property = render.component.semantics.labelPropertyId;

    return property == null
        ? ''
        : (render.properties[property]?.toString() ?? '');
  }

  Widget buildRoot() => _buildNode(render.component.anatomy.root);
}

class _PortableArcSpinner extends StatefulWidget {
  const _PortableArcSpinner({
    required this.size,
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.trackStrokeWidth,
    required this.duration,
  });

  final double size;
  final double? value;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final double? trackStrokeWidth;
  final Duration duration;

  @override
  State<_PortableArcSpinner> createState() => _PortableArcSpinnerState();
}

class _PortableArcSpinnerState extends State<_PortableArcSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..repeat();

  @override
  void didUpdateWidget(covariant _PortableArcSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return CustomPaint(
      painter: _PortableArcSpinnerPainter(
        animation: _controller,
        value: widget.value,
        strokeWidth: widget.strokeWidth,
        color: color,
        trackColor: widget.trackColor,
        trackStrokeWidth: widget.trackStrokeWidth,
      ),
      size: Size.square(widget.size),
    );
  }
}

class _PortableArcSpinnerPainter extends CustomPainter {
  _PortableArcSpinnerPainter({
    required this.animation,
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
    required this.trackStrokeWidth,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final double? value;
  final double strokeWidth;
  final Color color;
  final Color? trackColor;
  final double? trackStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final indicatorThickness = strokeWidth * 2;
    final trackThickness = trackColor == null
        ? 0.0
        : 2 * (trackStrokeWidth ?? strokeWidth);
    final radius =
        math.min(size.width, size.height) / 2 -
        math.max(indicatorThickness, trackThickness);
    if (trackColor != null) {
      canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackThickness
          ..color = trackColor!,
      );
    }
    final progress = value;
    final startAngle =
        math.pi / 3 + (progress == null ? animation.value * 2 * math.pi : 0);
    final sweepAngle = progress == null
        ? 2 * math.pi / 3
        : progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = indicatorThickness
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _PortableArcSpinnerPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.trackStrokeWidth != trackStrokeWidth;
}

class _UnsupportedV1Slot extends StatelessWidget {
  const _UnsupportedV1Slot({required this.slotId, required this.children});

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

Widget? _singleOrColumn(List<Widget> children) => switch (children) {
  [] => null,
  [final child] => child,
  _ => Column(mainAxisSize: .min, children: children),
};

bool _isValidValue(ComponentPropertyDefinition definition, Object? value) {
  if (!definition.isRequired && value == null) return true;

  return switch (definition.kind) {
    .enumeration => value is String && definition.values.contains(value),
    .string => value is String,
    .boolean => value is bool,
    .number => value is num && value.isFinite,
    .duration => value is int && value >= 0,
    .icon => value is String && _iconIdentities.containsKey(value),
  };
}

WidgetState _widgetState(String value) => switch (value) {
  'hovered' => .hovered,
  'focused' => .focused,
  'pressed' => .pressed,
  'dragged' => .dragged,
  'selected' => .selected,
  'scrolledUnder' => .scrolledUnder,
  'disabled' => .disabled,
  'error' => .error,
  _ => throw StateError('Parser admitted an unknown widget state.'),
};

Object _resolveToken(
  LoadedCapture capture, {
  required String themeId,
  required String kind,
  required String name,
}) {
  for (final entry in capture.protocolThemes[themeId]!.tokens.entries) {
    if (entry.key.name == name && _tokenKind(entry.key) == kind) {
      return entry.value;
    }
  }
  throw StateError('Validated binding references a missing token $kind/$name.');
}

String? _tokenKind(MixToken<Object?> token) => switch (token) {
  ColorToken() => 'color',
  SpaceToken() => 'space',
  DoubleToken() => 'double',
  RadiusToken() => 'radius',
  TextStyleToken() => 'textStyle',
  ShadowToken() => 'shadow',
  BoxShadowToken() => 'boxShadow',
  BorderSideToken() => 'border',
  FontWeightToken() => 'fontWeight',
  BreakpointToken() => 'breakpoint',
  DurationToken() => 'duration',
  _ => null,
};

IconData? _resolveIcon(Object? value) {
  if (value == null) return null;
  final icon = _iconIdentities[value];
  if (icon == null) {
    throw StateError('Unknown portable icon identity "$value".');
  }

  return icon;
}

Color _parseColor(String value) {
  final hex = value.startsWith('#') ? value.substring(1) : value;
  final normalized = switch (hex.length) {
    6 => 'FF$hex',
    8 => hex,
    _ => throw StateError(
      'Portable color literals must be #RRGGBB or #AARRGGBB.',
    ),
  };

  return Color(int.parse(normalized, radix: 16));
}

Alignment _alignment(String value) => switch (value) {
  'topLeft' => .topLeft,
  'topCenter' => .topCenter,
  'topRight' => .topRight,
  'centerLeft' => .centerLeft,
  'center' => .center,
  'centerRight' => .centerRight,
  'bottomLeft' => .bottomLeft,
  'bottomCenter' => .bottomCenter,
  'bottomRight' => .bottomRight,
  _ => throw StateError('Unknown portable alignment "$value".'),
};

const _iconIdentities = {
  'add': Icons.add,
  'arrow_back': Icons.arrow_back,
  'arrow_downward': Icons.arrow_downward,
  'arrow_forward': Icons.arrow_forward,
  'arrow_upward': Icons.arrow_upward,
  'check': Icons.check,
  'check_circle': Icons.check_circle,
  'chevron_left': Icons.chevron_left,
  'chevron_right': Icons.chevron_right,
  'close': Icons.close,
  'error': Icons.error,
  'expand_less': Icons.expand_less,
  'expand_more': Icons.expand_more,
  'info': Icons.info,
  'keyboard_arrow_down': Icons.keyboard_arrow_down,
  'keyboard_arrow_up': Icons.keyboard_arrow_up,
  'menu': Icons.menu,
  'more_horiz': Icons.more_horiz,
  'more_vert': Icons.more_vert,
  'person': Icons.person,
  'radio_button_checked': Icons.radio_button_checked,
  'radio_button_unchecked': Icons.radio_button_unchecked,
  'remove': Icons.remove,
  'search': Icons.search,
  'star': Icons.star,
  'visibility': Icons.visibility,
  'visibility_off': Icons.visibility_off,
  'warning': Icons.warning,
};
