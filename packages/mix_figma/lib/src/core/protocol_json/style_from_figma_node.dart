import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_node_document.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';
import '../mapping/name_mapper.dart';

/// Converts one normalized Figma node into a strict protocol style document.
MixFigmaMappingResult<JsonMap> buildProtocolStyleJsonFromNode(FigmaNode node) {
  final diagnostics = <MixFigmaDiagnostic>[];
  _collectKnownUnsupported(node, diagnostics, path: '/nodes/${node.id}');

  final value = switch (node.type) {
    'TEXT' => _textStyle(node, diagnostics),
    'FRAME' || 'COMPONENT' || 'INSTANCE'
        when node.layoutMode == 'HORIZONTAL' || node.layoutMode == 'VERTICAL' =>
      _flexBoxStyle(node, diagnostics),
    'FRAME' || 'COMPONENT' || 'INSTANCE' => _stackBoxStyle(node, diagnostics),
    'RECTANGLE' ||
    'ELLIPSE' ||
    'COMPONENT' ||
    'INSTANCE' => _boxStyle(node, diagnostics),
    _ => <String, Object?>{'v': 1, 'type': 'box'},
  };

  return MixFigmaMappingResult(value: value, diagnostics: diagnostics);
}

JsonMap _flexBoxStyle(FigmaNode node, List<MixFigmaDiagnostic> diagnostics) {
  final result = _boxFields(node, diagnostics, type: 'flex_box');
  result['direction'] = node.layoutMode.toLowerCase();
  final primary = node.fields['primaryAxisAlignItems'];
  if (primary is String) {
    result['mainAxisAlignment'] = switch (primary) {
      'MIN' => 'start',
      'MAX' => 'end',
      'CENTER' => 'center',
      'SPACE_BETWEEN' => 'spaceBetween',
      _ => 'start',
    };
  }
  final counter = node.fields['counterAxisAlignItems'];
  if (counter is String) {
    result['crossAxisAlignment'] = switch (counter) {
      'MIN' => 'start',
      'MAX' => 'end',
      'CENTER' => 'center',
      'BASELINE' => 'baseline',
      'STRETCH' => 'stretch',
      _ => 'center',
    };
  }
  final spacingTerm = _boundTerm(node, 'itemSpacing');
  final rawSpacing = node.fields['itemSpacing'];
  if (spacingTerm != null || rawSpacing is num) {
    result['spacing'] = spacingTerm ?? rawSpacing;
  }

  return result;
}

JsonMap _stackBoxStyle(FigmaNode node, List<MixFigmaDiagnostic> diagnostics) =>
    _boxFields(node, diagnostics, type: 'stack_box');

JsonMap _boxStyle(FigmaNode node, List<MixFigmaDiagnostic> diagnostics) =>
    _boxFields(node, diagnostics, type: 'box');

JsonMap _boxFields(
  FigmaNode node,
  List<MixFigmaDiagnostic> _, {
  required String type,
}) {
  final result = <String, Object?>{'v': 1, 'type': type};
  final padding = <String, Object?>{
    if (_boundOrNumber(node, 'paddingLeft') case final Object value)
      'left': value,
    if (_boundOrNumber(node, 'paddingTop') case final Object value)
      'top': value,
    if (_boundOrNumber(node, 'paddingRight') case final Object value)
      'right': value,
    if (_boundOrNumber(node, 'paddingBottom') case final Object value)
      'bottom': value,
  };
  if (padding.isNotEmpty) result['padding'] = padding;

  final fillTerm = _boundTerm(node, 'fills');
  final fill = _singleVisiblePaint(node.fields['fills']);
  final color =
      fillTerm ?? (fill?['type'] == 'SOLID' ? _color(fill!['color']!) : null);
  final gradient = fillTerm == null && fill?['type'] == 'GRADIENT_LINEAR'
      ? _linearGradient(fill!)
      : null;
  final radiusTerm = _boundTerm(node, 'cornerRadius');
  final cornerRadius =
      radiusTerm ??
      (node.fields['cornerRadius'] is num ? node.fields['cornerRadius'] : null);
  final border = _uniformBorder(node);
  final shadows = _dropShadows(node.fields['effects']);
  final decoration = {
    'color': ?color,
    'gradient': ?gradient,
    'border': ?border,
    'borderRadius': ?cornerRadius,
    if (shadows.isNotEmpty) 'boxShadow': shadows,
  };
  if (decoration.isNotEmpty) result['decoration'] = decoration;

  final opacity = node.fields['opacity'];
  if (opacity is num && opacity >= 0 && opacity < 1) {
    result['modifiers'] = [
      {'type': 'opacity', 'opacity': opacity},
    ];
  }

  return result;
}

JsonMap _textStyle(FigmaNode node, List<MixFigmaDiagnostic> _) {
  final rawStyle = node.fields['style'] is Map
      ? (node.fields['style']! as Map).cast<String, Object?>()
      : const <String, Object?>{};
  Object? textField(String name) => rawStyle[name] ?? node.fields[name];

  final literalFontSize = _number(textField('fontSize'));
  final fontSize = _boundTerm(node, 'fontSize') ?? literalFontSize;
  final fillTerm = _boundTerm(node, 'fills');
  final fill = _singleVisiblePaint(node.fields['fills']);
  final color =
      fillTerm ?? (fill?['type'] == 'SOLID' ? _color(fill!['color']!) : null);
  final style = {'color': ?color};
  if (_fontFamily(textField('fontFamily') ?? textField('fontName'))
      case final String fontFamily) {
    style['fontFamily'] = fontFamily;
  }
  if (fontSize != null) style['fontSize'] = fontSize;
  final fontWeight =
      _boundTerm(node, 'fontWeight') ??
      _fontWeight(_number(textField('fontWeight')));
  if (fontWeight != null) {
    style['fontWeight'] = fontWeight;
  }
  if (_lineHeightMultiplier(textField('lineHeight'), literalFontSize)
      case final num height) {
    style['height'] = height;
  }
  final letterSpacing =
      _boundTerm(node, 'letterSpacing') ??
      _letterSpacing(textField('letterSpacing'), literalFontSize);
  if (letterSpacing != null) {
    style['letterSpacing'] = letterSpacing;
  }

  return {
    'v': 1,
    'type': 'text',
    if (style.isNotEmpty) 'style': style,
    if (node.fields['maxLines'] is int) 'maxLines': node.fields['maxLines'],
    if (node.fields['textTruncation'] == 'ENDING') 'overflow': 'ellipsis',
  };
}

num? _number(Object? value) => value is num ? value : null;

String? _fontWeight(num? value) =>
    value == null ? null : 'w${(value / 100).round() * 100}';

String? _fontFamily(Object? value) {
  if (value is String) return value;
  if (value is! Map) return null;

  final family = value['family'];

  return family is String ? family : null;
}

num? _lineHeightMultiplier(Object? value, num? fontSize) {
  if (fontSize == null || fontSize == 0) return null;
  if (value is num) return value / fontSize;
  if (value is! Map || value['value'] is! num) return null;
  final lineHeight = value['value']! as num;

  return switch (value['unit']) {
    'PIXELS' => lineHeight / fontSize,
    'PERCENT' || 'INTRINSIC_%' => lineHeight / 100,
    _ => null,
  };
}

num? _letterSpacing(Object? value, num? fontSize) {
  if (value is num) return value;
  if (value is! Map || value['value'] is! num) return null;
  final spacing = value['value']! as num;

  return switch (value['unit']) {
    'PIXELS' => spacing,
    'PERCENT' when fontSize != null => fontSize * spacing / 100,
    _ => null,
  };
}

JsonMap? _boundTerm(FigmaNode node, String property) {
  final value = node.boundVariables[property];
  if (value == null) return null;
  if (value is String) return {r'$token': value};
  if (value is! Map) return null;
  final binding = value.cast<String, Object?>();
  final rawName = binding['name'];
  if (rawName is! String) return null;
  final name = MixFigmaNameMapper.figmaToMix(rawName);
  final kind = binding['kind'];

  return {
    r'$token': name,
    if (kind == 'spaces') 'kind': 'space',
    if (kind == 'doubles') 'kind': 'double',
  };
}

Object? _boundOrNumber(FigmaNode node, String property) =>
    _boundTerm(node, property) ?? _number(node.fields[property]);

JsonMap? _uniformBorder(FigmaNode node) {
  final stroke = _singleVisiblePaint(node.fields['strokes']);
  final color =
      _boundTerm(node, 'strokes') ??
      (stroke?['type'] == 'SOLID' ? _color(stroke!['color']!) : null);
  final width = _boundOrNumber(node, 'strokeWeight');
  if (color == null || width == null) return null;

  JsonMap side() => {'color': color, 'width': width, 'style': 'solid'};

  return {'top': side(), 'right': side(), 'bottom': side(), 'left': side()};
}

JsonMap? _singleVisiblePaint(Object? value) {
  if (value is! List) return null;
  final paints = value
      .whereType<Map>()
      .map((item) => item.cast<String, Object?>())
      .where((item) => item['visible'] != false)
      .toList();

  return paints.length == 1 ? paints.single : null;
}

JsonMap _linearGradient(JsonMap paint) {
  final stops = (paint['gradientStops']! as List)
      .cast<Map>()
      .map((item) => item.cast<String, Object?>())
      .toList();

  return {
    'kind': 'linear',
    'colors': stops.map((stop) => _color(stop['color']!)).toList(),
    'stops': stops.map((stop) => stop['position']).toList(),
  };
}

List<Object?> _dropShadows(Object? value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, Object?>())
      .where(
        (item) => item['visible'] != false && item['type'] == 'DROP_SHADOW',
      )
      .map((effect) {
        final offset = effect['offset'] is Map
            ? (effect['offset']! as Map).cast<String, Object?>()
            : const <String, Object?>{};

        return <String, Object?>{
          'color': _color(effect['color']!),
          'offset': {'x': offset['x'] ?? 0, 'y': offset['y'] ?? 0},
          'blurRadius': effect['radius'] ?? 0,
          if (effect['spread'] != null) 'spreadRadius': effect['spread'],
        };
      })
      .toList(growable: false);
}

String _color(Object value) {
  if (value is String) return value.toUpperCase();
  final color = (value as Map).cast<String, Object?>();
  final alpha = color['a'] is num ? color['a']! as num : 1;
  int byte(num component) => (component * 255).round().clamp(0, 255);
  final rgb = [color['r'], color['g'], color['b']]
      .map((component) => byte(component! as num))
      .map((item) => item.toRadixString(16).padLeft(2, '0'))
      .join();
  final alphaHex = byte(alpha).toRadixString(16).padLeft(2, '0');

  return '#${alphaHex == 'ff' ? '' : alphaHex}$rgb'.toUpperCase();
}

void _collectKnownUnsupported(
  FigmaNode node,
  List<MixFigmaDiagnostic> diagnostics, {
  required String path,
}) {
  void warning(String code, String message, [String suffix = '']) {
    diagnostics.add(
      MixFigmaDiagnostic(
        code: code,
        severity: .warning,
        path: '$path$suffix',
        message: message,
      ),
    );
  }

  if (node.fields['margin'] != null ||
      _hasPluginData(node, 'mix_figma.margin')) {
    warning(
      'unsupported_margin',
      'Figma auto-layout has no margin field.',
      '/margin',
    );
  }
  if (_hasPerEdgeStrokeWeights(node)) {
    warning(
      'unsupported_per_edge_borders',
      'Per-edge Figma strokes cannot be represented as a uniform Mix border.',
      '/individualStrokeWeights',
    );
  }
  if (node.fields['foregroundDecoration'] != null ||
      _hasPluginData(node, 'mix_figma.foregroundDecoration')) {
    warning(
      'unsupported_foreground_decoration',
      'Figma has no foregroundDecoration equivalent.',
      '/foregroundDecoration',
    );
  }
  if (node.fields['layoutPositioning'] == 'ABSOLUTE') {
    warning(
      'unsupported_absolute_positioned_child',
      'Absolute-positioned stack children have no Mix styling equivalent.',
      '/layoutPositioning',
    );
  }
  if (node.fields['effects'] is List &&
      (node.fields['effects']! as List).whereType<Map>().any(
        (effect) =>
            effect['visible'] != false && effect['type'] == 'INNER_SHADOW',
      )) {
    warning(
      'unsupported_inner_shadow',
      'Flutter BoxShadow has no inset shadow equivalent.',
      '/effects',
    );
  }
  if (_containsSweepGradient(node.fields['fills']) ||
      _containsSweepGradient(node.fields['strokes'])) {
    warning(
      'unsupported_sweep_gradient',
      'Angular/sweep gradient conversion is intentionally diagnostic-only.',
      '/fills',
    );
  }
  for (final child in node.children) {
    _collectKnownUnsupported(
      child,
      diagnostics,
      path: '$path/children/${child.id}',
    );
  }
}

bool _hasPluginData(FigmaNode node, String key) {
  final pluginData = node.fields['pluginData'];

  return pluginData is Map &&
      pluginData[key] is String &&
      (pluginData[key]! as String).isNotEmpty;
}

bool _hasPerEdgeStrokeWeights(FigmaNode node) {
  if (node.fields['individualStrokeWeights'] != null) return true;
  final weights = [
    node.fields['strokeTopWeight'],
    node.fields['strokeRightWeight'],
    node.fields['strokeBottomWeight'],
    node.fields['strokeLeftWeight'],
  ];

  return weights.every((weight) => weight is num) && weights.toSet().length > 1;
}

bool _containsSweepGradient(Object? paints) =>
    paints is List &&
    paints.whereType<Map>().any(
      (paint) =>
          paint['visible'] != false && paint['type'] == 'GRADIENT_ANGULAR',
    );
