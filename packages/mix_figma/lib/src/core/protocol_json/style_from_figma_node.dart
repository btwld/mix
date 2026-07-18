import '../diagnostics/mix_figma_diagnostic.dart';
import '../figma/figma_node_document.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';

/// Converts one normalized Figma node into a strict protocol style document.
MixFigmaMappingResult<JsonMap> buildProtocolStyleJsonFromNode(FigmaNode node) {
  final diagnostics = <MixFigmaDiagnostic>[];
  _collectKnownUnsupported(node, diagnostics, path: '/nodes/${node.id}');

  final value = switch (node.type) {
    'TEXT' => _textStyle(node, diagnostics),
    'FRAME'
        when node.layoutMode == 'HORIZONTAL' || node.layoutMode == 'VERTICAL' =>
      _flexBoxStyle(node, diagnostics),
    'FRAME' => _stackBoxStyle(node, diagnostics),
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
    if (node.fields['paddingLeft'] is num) 'left': node.fields['paddingLeft'],
    if (node.fields['paddingTop'] is num) 'top': node.fields['paddingTop'],
    if (node.fields['paddingRight'] is num)
      'right': node.fields['paddingRight'],
    if (node.fields['paddingBottom'] is num)
      'bottom': node.fields['paddingBottom'],
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
  final shadows = _dropShadows(node.fields['effects']);
  final decoration = {
    'color': ?color,
    'gradient': ?gradient,
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
  final fontSize = rawStyle['fontSize'];
  final fillTerm = _boundTerm(node, 'fills');
  final fill = _singleVisiblePaint(node.fields['fills']);
  final color =
      fillTerm ?? (fill?['type'] == 'SOLID' ? _color(fill!['color']!) : null);
  final style = {'color': ?color};
  if (rawStyle['fontFamily'] case final String fontFamily) {
    style['fontFamily'] = fontFamily;
  }
  if (fontSize is num) style['fontSize'] = fontSize;
  if (rawStyle['fontWeight'] is num) {
    style['fontWeight'] =
        'w${((rawStyle['fontWeight']! as num) / 100).round() * 100}';
  }
  if (rawStyle['lineHeight'] is num && fontSize is num && fontSize != 0) {
    style['height'] = (rawStyle['lineHeight']! as num) / fontSize;
  }
  if (rawStyle['letterSpacing'] case final num letterSpacing) {
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

JsonMap? _boundTerm(FigmaNode node, String property) {
  final value = node.boundVariables[property];
  if (value == null) return null;
  if (value is String) return {r'$token': value};
  if (value is! Map) return null;
  final binding = value.cast<String, Object?>();
  final name = binding['name'];
  if (name is! String) return null;
  final kind = binding['kind'];

  return {
    r'$token': name,
    if (kind == 'spaces') 'kind': 'space',
    if (kind == 'doubles') 'kind': 'double',
  };
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

  if (node.fields['margin'] != null) {
    warning(
      'unsupported_margin',
      'Figma auto-layout has no margin field.',
      '/margin',
    );
  }
  if (node.fields['individualStrokeWeights'] != null) {
    warning(
      'unsupported_per_edge_borders',
      'Per-edge Figma strokes cannot be represented as a uniform Mix border.',
      '/individualStrokeWeights',
    );
  }
  if (node.fields['foregroundDecoration'] != null) {
    warning(
      'unsupported_foreground_decoration',
      'Figma has no foregroundDecoration equivalent.',
      '/foregroundDecoration',
    );
  }
  if (node.fields['layoutPositioning'] == 'ABSOLUTE') {
    warning(
      'unsupported_absolute_position',
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
  if (node.fields['fills'] is List &&
      (node.fields['fills']! as List).whereType<Map>().any(
        (paint) =>
            paint['visible'] != false && paint['type'] == 'GRADIENT_ANGULAR',
      )) {
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
