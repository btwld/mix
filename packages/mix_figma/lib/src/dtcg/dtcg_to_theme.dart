import 'package:mix_protocol/mix_protocol.dart';

import '../diagnostics.dart';
import 'dtcg_document.dart';

/// Options controlling DTCG → theme-document conversion.
final class DtcgConversionOptions {
  const DtcgConversionOptions({
    this.groupOverrides = const {},
    this.remPixelRatio,
  });

  /// Routes tokens to a specific theme group by token-path prefix, overriding
  /// the `$type`-based default. Prefixes match whole path segments; the
  /// longest match wins.
  ///
  /// Example: `{'breakpoint': 'breakpoints', 'radius': 'radii'}` sends
  /// `breakpoint.md` to `breakpoints` and `radius.card` to `radii`.
  ///
  /// Valid targets per `$type`: `dimension`/`number` → `spaces`, `doubles`,
  /// `radii`, `breakpoints`; `shadow` → `boxShadows`, `shadows`.
  final Map<String, String> groupOverrides;

  /// Pixels per `rem` for dimension values using the `rem` unit. When null,
  /// `rem` dimensions are skipped with a diagnostic.
  final double? remPixelRatio;
}

/// Result of converting a DTCG document to a `mix_protocol` theme document.
final class DtcgConversionResult {
  const DtcgConversionResult({
    required this.themeDocument,
    required this.diagnostics,
  });

  /// A `{"v": 1, "type": "theme", ...}` document. Validate and decode with
  /// `mixProtocol.decodeTheme`.
  final JsonMap themeDocument;

  /// Everything that could not be represented, and every value adjustment.
  final List<MixFigmaDiagnostic> diagnostics;
}

/// Converts a decoded DTCG 2025.10 design-token document into a
/// `mix_protocol` theme document.
///
/// Figma's native variable export produces one DTCG file per variable mode;
/// call this once per file to get one theme document per mode.
DtcgConversionResult dtcgToThemeDocument(
  Map<String, Object?> document, {
  DtcgConversionOptions options = const DtcgConversionOptions(),
}) {
  final parsed = parseDtcgDocument(document);

  return _Converter(parsed.tokens, options, [...parsed.diagnostics]).convert();
}

/// Theme groups in the canonical order of the wire contract.
const _groupOrder = [
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

const _defaultGroupByType = {
  'color': 'colors',
  'dimension': 'spaces',
  'number': 'doubles',
  'fontWeight': 'fontWeights',
  'duration': 'durations',
  'shadow': 'boxShadows',
  'border': 'borders',
  'typography': 'textStyles',
};

const _overridableGroupsByType = {
  'dimension': {'spaces', 'doubles', 'radii', 'breakpoints'},
  'number': {'doubles', 'spaces', 'radii', 'breakpoints'},
  'shadow': {'boxShadows', 'shadows'},
};

const _namedFontWeights = {
  'thin': 100,
  'hairline': 100,
  'extra-light': 200,
  'ultra-light': 200,
  'light': 300,
  'normal': 400,
  'regular': 400,
  'book': 400,
  'medium': 500,
  'semi-bold': 600,
  'demi-bold': 600,
  'bold': 700,
  'extra-bold': 800,
  'ultra-bold': 800,
  'black': 900,
  'heavy': 900,
  'extra-black': 950,
  'ultra-black': 950,
};

const _maxAliasHops = 64;

final _hexColorPattern = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

final class _Converter {
  _Converter(this._tokens, this._options, this._diagnostics);

  final Map<String, DtcgToken> _tokens;
  final DtcgConversionOptions _options;
  final List<MixFigmaDiagnostic> _diagnostics;
  final Map<String, String?> _groupCache = {};

  DtcgConversionResult convert() {
    final groups = <String, Map<String, Object?>>{};

    for (final token in _tokens.values) {
      final group = _groupOf(token.path, const {});
      if (group == null) continue;

      final wire = token.isAlias
          ? _aliasWire(token, group)
          : _wireValue(token, group);
      if (wire == null) continue;

      (groups[group] ??= {})[token.path] = wire;
    }

    final themeDocument = <String, Object?>{
      'v': mixProtocolFormatVersion,
      'type': 'theme',
      for (final group in _groupOrder)
        if (groups[group] case final entries?)
          group: {
            for (final name in entries.keys.toList()..sort())
              name: entries[name],
          },
    };

    return DtcgConversionResult(
      themeDocument: themeDocument,
      diagnostics: _diagnostics,
    );
  }

  void _skip(String path, String message) {
    _diagnostics.add(MixFigmaDiagnostic(path: path, message: message));
  }

  // --- Group resolution ---------------------------------------------------

  /// Resolves the theme group for a token path, following alias chains.
  /// Returns null (with a diagnostic) when the token cannot be represented.
  String? _groupOf(String path, Set<String> visiting) {
    if (_groupCache.containsKey(path)) return _groupCache[path];
    if (visiting.contains(path)) {
      _skip(path, 'alias cycle detected; token skipped');

      return _groupCache[path] = null;
    }

    // Only reachable through alias targets; the referencing token reports it.
    final token = _tokens[path];
    if (token == null) return _groupCache[path] = null;

    String? group;
    if (token.aliasTarget case final target?) {
      if (!_tokens.containsKey(target)) {
        _skip(path, 'alias target "$target" does not exist; token skipped');
      } else {
        group = _groupOf(target, {...visiting, path});
        if (group == null) {
          _skip(path, 'alias target "$target" is not representable; skipped');
        }
      }
    } else if (token.type case final type?) {
      group = _defaultGroupByType[type];
      if (group == null) {
        _skip(path, 'unsupported \$type "$type"; token skipped');
      } else if (_overrideFor(path) case final override?) {
        final allowed = _overridableGroupsByType[type] ?? const <String>{};
        if (allowed.contains(override)) {
          group = override;
        } else {
          _skip(
            path,
            'group override "$override" is not valid for \$type "$type"; '
            'using default "$group"',
          );
        }
      }
    } else {
      _skip(path, r'token has no $type (own or inherited); skipped');
    }

    return _groupCache[path] = group;
  }

  String? _overrideFor(String path) {
    String? best;
    var bestLength = -1;
    for (final entry in _options.groupOverrides.entries) {
      final prefix = entry.key;
      final matches =
          path == prefix ||
          (path.startsWith(prefix) && path.codeUnitAt(prefix.length) == 0x2E);
      if (matches && prefix.length > bestLength) {
        best = entry.value;
        bestLength = prefix.length;
      }
    }

    return best;
  }

  // --- Alias emission -----------------------------------------------------

  JsonMap? _aliasWire(DtcgToken token, String group) {
    final target = token.aliasTarget!;
    if (_groupOf(target, const {}) != group) return null;

    return {
      r'$token': target,
      if (group == 'spaces') 'kind': 'space',
      if (group == 'doubles') 'kind': 'double',
    };
  }

  // --- Concrete values ----------------------------------------------------

  Object? _wireValue(DtcgToken token, String group) {
    final path = token.path;
    final value = token.value;

    return switch (group) {
      'colors' => _color(value, path),
      'spaces' || 'doubles' || 'radii' => _length(value, path),
      'breakpoints' => switch (_length(value, path)) {
        final minWidth? => {'minWidth': minWidth},
        null => null,
      },
      'fontWeights' => _fontWeight(value, path),
      'durations' => _durationMs(value, path),
      'boxShadows' => _shadowList(value, path, allowSpread: true),
      'shadows' => _shadowList(value, path, allowSpread: false),
      'borders' => _border(value, path),
      'textStyles' => _textStyle(value, path),
      _ => null,
    };
  }

  /// Follows alias strings inside composite values to a concrete raw value.
  Object? _deref(Object? value, String path) {
    var current = value;
    var hops = 0;
    while (current is String) {
      final match = RegExp(r'^\{([^{}]+)\}$').firstMatch(current);
      if (match == null) break;
      if (hops++ > _maxAliasHops) {
        _skip(path, 'alias chain exceeds $_maxAliasHops hops; skipped');

        return null;
      }
      final target = _tokens[match.group(1)!];
      if (target == null) {
        _skip(path, 'reference "${match.group(1)}" does not exist; skipped');

        return null;
      }
      current = target.value;
    }

    return current;
  }

  String? _color(Object? raw, String path) {
    final value = _deref(raw, path);
    if (value is String) return _hexColor(value, path);
    if (value is Map<String, Object?>) {
      final colorSpace = value['colorSpace'];
      final components = value['components'];
      final alphaRaw = value['alpha'];
      final alpha = alphaRaw is num ? alphaRaw.toDouble() : 1.0;

      if (colorSpace == 'srgb' &&
          components is List &&
          components.length == 3 &&
          components.every((component) => component is num)) {
        final channels = [
          for (final component in components.cast<num>())
            (component.toDouble().clamp(0, 1) * 255).round(),
        ];

        return _formatArgb(
          (alpha.clamp(0, 1) * 255).round(),
          channels[0],
          channels[1],
          channels[2],
        );
      }

      if (value['hex'] case final String hex) {
        final base = _hexColor(hex, path);
        if (base == null) return null;
        if (base.length == 7 && alpha < 1) {
          final argb = int.parse(base.substring(1), radix: 16);

          return _formatArgb(
            (alpha.clamp(0, 1) * 255).round(),
            (argb >> 16) & 0xFF,
            (argb >> 8) & 0xFF,
            argb & 0xFF,
          );
        }

        return base;
      }

      _skip(
        path,
        'color uses colorSpace "$colorSpace" without a hex fallback; '
        'only srgb components and hex are supported',
      );

      return null;
    }

    _skip(path, 'unrecognized color value; skipped');

    return null;
  }

  /// Normalizes DTCG hex (`#RRGGBB` / `#RRGGBBAA`, alpha last) to the
  /// protocol form (`#RRGGBB` / `#AARRGGBB`, alpha first).
  String? _hexColor(String hex, String path) {
    if (!_hexColorPattern.hasMatch(hex)) {
      _skip(path, 'unrecognized hex color "$hex"; skipped');

      return null;
    }
    final digits = hex.substring(1).toUpperCase();
    if (digits.length == 6) return '#$digits';

    return '#${digits.substring(6)}${digits.substring(0, 6)}';
  }

  String _formatArgb(int alpha, int red, int green, int blue) {
    String pair(int channel) =>
        channel.toRadixString(16).padLeft(2, '0').toUpperCase();
    final rgb = '${pair(red)}${pair(green)}${pair(blue)}';

    return alpha == 0xFF ? '#$rgb' : '#${pair(alpha)}$rgb';
  }

  double? _length(Object? raw, String path) {
    final value = _deref(raw, path);
    if (value is num) return value.toDouble();
    if (value is Map<String, Object?>) {
      final magnitude = value['value'];
      final unit = value['unit'];
      if (magnitude is num) {
        if (unit == 'px') return magnitude.toDouble();
        if (unit == 'rem') {
          if (_options.remPixelRatio case final ratio?) {
            return magnitude.toDouble() * ratio;
          }
          _skip(
            path,
            'rem dimension requires DtcgConversionOptions.remPixelRatio; '
            'skipped',
          );

          return null;
        }
        _skip(path, 'unsupported dimension unit "$unit"; skipped');

        return null;
      }
    }

    _skip(path, 'unrecognized dimension value; skipped');

    return null;
  }

  String? _fontWeight(Object? raw, String path) {
    final value = _deref(raw, path);
    final numeric = switch (value) {
      final num weight => weight.toDouble(),
      final String name => _namedFontWeights[name.toLowerCase()]?.toDouble(),
      _ => null,
    };
    if (numeric == null || numeric < 1 || numeric > 1000) {
      _skip(path, 'unrecognized fontWeight value "$value"; skipped');

      return null;
    }

    final snapped = (numeric / 100).round().clamp(1, 9) * 100;
    if (snapped != numeric) {
      _skip(path, 'fontWeight $value snapped to w$snapped');
    }

    return 'w$snapped';
  }

  int? _durationMs(Object? raw, String path) {
    final value = _deref(raw, path);
    if (value is num) return value.round();
    if (value is Map<String, Object?>) {
      final magnitude = value['value'];
      final unit = value['unit'];
      if (magnitude is num && (unit == 'ms' || unit == 's')) {
        final milliseconds = unit == 's' ? magnitude * 1000 : magnitude;
        if (milliseconds >= 0) return milliseconds.round();
      }
    }

    _skip(path, 'unrecognized duration value; skipped');

    return null;
  }

  List<Object?>? _shadowList(
    Object? raw,
    String path, {
    required bool allowSpread,
  }) {
    final value = _deref(raw, path);
    final layers = value is List ? value : [value];
    final shadows = <Object?>[];

    for (final layer in layers) {
      final resolved = _deref(layer, path);
      if (resolved is! Map<String, Object?>) {
        _skip(path, 'unrecognized shadow layer; token skipped');

        return null;
      }
      if (resolved['inset'] == true) {
        _skip(path, 'inset shadows are not representable; token skipped');

        return null;
      }

      final color = _color(resolved['color'], path);
      final dx = _length(resolved['offsetX'] ?? 0, path);
      final dy = _length(resolved['offsetY'] ?? 0, path);
      final blur = _length(resolved['blur'] ?? 0, path);
      final spread = _length(resolved['spread'] ?? 0, path);
      if (color == null ||
          dx == null ||
          dy == null ||
          blur == null ||
          spread == null) {
        return null;
      }
      if (!allowSpread && spread != 0) {
        _skip(
          path,
          'text shadows cannot carry spread; token skipped '
          '(route it to boxShadows instead)',
        );

        return null;
      }

      shadows.add({
        'color': color,
        'offset': {'x': dx, 'y': dy},
        'blurRadius': blur,
        if (allowSpread && spread != 0) 'spreadRadius': spread,
      });
    }

    return shadows;
  }

  JsonMap? _border(Object? raw, String path) {
    final value = _deref(raw, path);
    if (value is! Map<String, Object?>) {
      _skip(path, 'unrecognized border value; skipped');

      return null;
    }

    final style = _deref(value['style'] ?? 'solid', path);
    if (style != 'solid') {
      _skip(path, 'border style "$style" is not representable; token skipped');

      return null;
    }

    final color = _color(value['color'], path);
    final width = _length(value['width'], path);
    if (color == null || width == null) return null;

    return {'color': color, 'width': width, 'style': 'solid'};
  }

  JsonMap? _textStyle(Object? raw, String path) {
    final value = _deref(raw, path);
    if (value is! Map<String, Object?>) {
      _skip(path, 'unrecognized typography value; skipped');

      return null;
    }

    final style = <String, Object?>{};

    if (value.containsKey('fontFamily')) {
      final family = _deref(value['fontFamily'], path);
      if (family is String) {
        style['fontFamily'] = family;
      } else if (family is List && family.isNotEmpty) {
        final names = family.whereType<String>().toList();
        style['fontFamily'] = names.first;
        if (names.length > 1) {
          style['fontFamilyFallback'] = names.sublist(1);
        }
      } else {
        _skip(path, 'unrecognized fontFamily inside typography; field skipped');
      }
    }
    if (value.containsKey('fontSize')) {
      if (_length(value['fontSize'], path) case final size?) {
        style['fontSize'] = size;
      }
    }
    if (value.containsKey('fontWeight')) {
      if (_fontWeight(value['fontWeight'], path) case final weight?) {
        style['fontWeight'] = weight;
      }
    }
    if (value.containsKey('letterSpacing')) {
      if (_length(value['letterSpacing'], path) case final spacing?) {
        style['letterSpacing'] = spacing;
      }
    }
    if (value.containsKey('lineHeight')) {
      final lineHeight = _deref(value['lineHeight'], path);
      if (lineHeight is num) {
        style['height'] = lineHeight.toDouble();
      } else {
        _skip(path, 'unrecognized lineHeight inside typography; field skipped');
      }
    }

    for (final key in value.keys) {
      if (!const {
        'fontFamily',
        'fontSize',
        'fontWeight',
        'letterSpacing',
        'lineHeight',
      }.contains(key)) {
        _skip(path, 'typography field "$key" is not representable; skipped');
      }
    }

    if (style.isEmpty) {
      _skip(path, 'typography token has no representable fields; skipped');

      return null;
    }

    return style;
  }
}
