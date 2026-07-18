import '../diagnostics/mix_figma_diagnostic.dart';
import '../dtcg/dtcg_document.dart';
import '../json_map.dart';
import '../mapping/mapping_result.dart';
import '../mapping/name_mapper.dart';

const _themeGroups = [
  'colors',
  'spaces',
  'doubles',
  'radii',
  'textStyles',
  'shadows',
  'boxShadows',
  'borders',
  'fontWeights',
  'breakpoints',
  'durations',
];

/// Converts flattened DTCG tokens into an authored protocol theme document.
MixFigmaMappingResult<JsonMap> buildProtocolThemeJsonFromDtcg(
  DtcgDocument document,
) {
  final diagnostics = <MixFigmaDiagnostic>[];
  final grouped = {
    for (final group in _themeGroups) group: <String, Object?>{},
  };
  final tokens = document.tokens.values.toList()
    ..sort((left, right) => left.path.compareTo(right.path));

  for (final token in tokens) {
    final group = token.mixGroup ?? _groupFor(token);
    if (group == null || !grouped.containsKey(group)) {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'unsupported_dtcg_type',
          severity: .error,
          path: '/${token.path.replaceAll('.', '/')}',
          message: 'DTCG type "${token.type}" has no Mix token group.',
        ),
      );
      continue;
    }

    String name;
    try {
      name = MixFigmaNameMapper.figmaToMix(token.path);
    } on FormatException catch (error) {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'invalid_token_name',
          severity: .error,
          path: '/${token.path.replaceAll('.', '/')}',
          message: error.message,
        ),
      );
      continue;
    }

    try {
      grouped[group]![name] = _protocolValue(token, group);
    } on FormatException catch (error) {
      diagnostics.add(
        MixFigmaDiagnostic(
          code: 'invalid_dtcg_value',
          severity: .error,
          path: '/${token.path.replaceAll('.', '/')}',
          message: error.message,
        ),
      );
    }
  }

  return MixFigmaMappingResult(
    value: <String, Object?>{
      'v': 1,
      'type': 'theme',
      for (final group in _themeGroups)
        if (grouped[group]!.isNotEmpty) group: grouped[group]!,
    },
    diagnostics: diagnostics,
  );
}

String? _groupFor(DtcgToken token) {
  return switch (token.type) {
    'color' => 'colors',
    'dimension' when token.path.toLowerCase().contains('radius') => 'radii',
    'dimension' when token.path.toLowerCase().contains('breakpoint') =>
      'breakpoints',
    'dimension' => 'spaces',
    'number' => 'doubles',
    'typography' => 'textStyles',
    'shadow' => 'boxShadows',
    'border' || 'strokeStyle' => 'borders',
    'fontWeight' => 'fontWeights',
    'duration' => 'durations',
    _ => null,
  };
}

Object _protocolValue(DtcgToken token, String group) {
  final alias = _alias(token.value);
  if (alias != null) {
    return {
      r'$token': alias,
      if (group == 'spaces') 'kind': 'space',
      if (group == 'doubles') 'kind': 'double',
    };
  }

  return switch (group) {
    'colors' => _color(token.value),
    'spaces' || 'doubles' || 'radii' => _number(token.value),
    'textStyles' => _typography(token.value),
    'shadows' => _shadows(token.value, box: false),
    'boxShadows' => _shadows(token.value, box: true),
    'borders' => _border(token.value),
    'fontWeights' => _fontWeight(token.value),
    'breakpoints' => {'minWidth': _number(token.value)},
    'durations' => _duration(token.value),
    _ => throw FormatException('Unsupported protocol group "$group".'),
  };
}

String? _alias(Object? value) {
  if (value is! String || !value.startsWith('{') || !value.endsWith('}')) {
    return null;
  }

  return value.substring(1, value.length - 1);
}

String _color(Object? value) {
  if (value is String &&
      RegExp(r'^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$').hasMatch(value)) {
    return value.toUpperCase();
  }
  if (value is Map) {
    final color = value.cast<String, Object?>();
    final components = color['components'];
    if (color['colorSpace'] == 'srgb' &&
        components is List &&
        components.length == 3) {
      final alpha = color['alpha'] is num ? color['alpha']! as num : 1;
      int byte(Object? component) =>
          ((component! as num) * 255).round().clamp(0, 255);
      final bytes = [
        byte(components[0]),
        byte(components[1]),
        byte(components[2]),
      ];
      final rgb = bytes
          .map((item) => item.toRadixString(16).padLeft(2, '0'))
          .join();
      final alphaHex = byte(alpha).toRadixString(16).padLeft(2, '0');

      return '#${alphaHex == 'ff' ? '' : alphaHex}$rgb'.toUpperCase();
    }
  }

  throw const FormatException('Expected a hex or sRGB DTCG color.');
}

num _number(Object? value) {
  if (value is num && value.isFinite) return value;
  if (value is Map) {
    final dimension = value.cast<String, Object?>();
    final number = dimension['value'];
    final unit = dimension['unit'];
    if (number is num && number.isFinite && (unit == 'px' || unit == null)) {
      return number;
    }
  }

  throw const FormatException('Expected a finite number or px dimension.');
}

int _duration(Object? value) {
  if (value is num && value.isFinite) return value.round();
  final duration = value is Map ? value.cast<String, Object?>() : null;
  final number = duration?['value'];
  if (number is num && number.isFinite) {
    final unit = duration?['unit'];

    return switch (unit) {
      'ms' => number.round(),
      's' => (number * 1000).round(),
      _ => throw const FormatException('Duration unit must be ms or s.'),
    };
  }

  throw const FormatException('Expected a DTCG duration.');
}

String _fontWeight(Object? value) {
  if (value is num && value >= 100 && value <= 900) {
    return 'w${(value / 100).round() * 100}';
  }
  if (value is String && RegExp(r'^w[1-9]00$').hasMatch(value)) return value;

  throw const FormatException('Expected a font weight from 100 through 900.');
}

JsonMap _typography(Object? value) {
  final input = value is Map ? value.cast<String, Object?>() : null;
  if (input == null) throw const FormatException('Expected typography object.');
  final family = input['fontFamily'];
  final fontSize = input['fontSize'];

  return {
    if (family is String) 'fontFamily': family,
    if (family is List && family.isNotEmpty) 'fontFamily': family.first,
    if (family is List && family.length > 1)
      'fontFamilyFallback': family.skip(1).toList(),
    if (fontSize != null) 'fontSize': _number(fontSize),
    if (input['fontWeight'] != null)
      'fontWeight': _fontWeight(input['fontWeight']),
    if (input['fontStyle'] is String) 'fontStyle': input['fontStyle'],
    if (input['letterSpacing'] != null)
      'letterSpacing': _number(input['letterSpacing']),
    if (input['lineHeight'] is num) 'height': input['lineHeight'],
  };
}

List<Object?> _shadows(Object? value, {required bool box}) {
  final values = value is List ? value : [value];

  return values
      .map((item) {
        final shadow = item is Map ? item.cast<String, Object?>() : null;
        if (shadow == null) {
          throw const FormatException('Expected shadow object.');
        }

        return <String, Object?>{
          'color': _color(shadow['color']),
          'offset': {
            'x': _number(shadow['offsetX']),
            'y': _number(shadow['offsetY']),
          },
          'blurRadius': _number(shadow['blur']),
          if (box && shadow['spread'] != null)
            'spreadRadius': _number(shadow['spread']),
        };
      })
      .toList(growable: false);
}

JsonMap _border(Object? value) {
  final border = value is Map ? value.cast<String, Object?>() : null;
  if (border == null) throw const FormatException('Expected border object.');

  return {
    'color': _color(border['color']),
    'width': _number(border['width']),
    'style': border['style'] == 'none' ? 'none' : 'solid',
  };
}
