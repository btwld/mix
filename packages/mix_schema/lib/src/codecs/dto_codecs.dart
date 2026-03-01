import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DtoCodecs {
  static EdgeInsetsGeometryMix decodeEdgeInsetsGeometry(
    Map<String, Object?> data,
  ) {
    final kind = data['kind'] as String;
    switch (kind) {
      case 'edgeInsets':
        return EdgeInsetsMix(
          left: _asDouble(data['left']),
          top: _asDouble(data['top']),
          right: _asDouble(data['right']),
          bottom: _asDouble(data['bottom']),
        );
      case 'edgeInsetsDirectional':
        return EdgeInsetsDirectionalMix(
          start: _asDouble(data['start']),
          top: _asDouble(data['top']),
          end: _asDouble(data['end']),
          bottom: _asDouble(data['bottom']),
        );
      default:
        throw StateError('Unsupported edge insets kind: $kind');
    }
  }

  static Map<String, Object?> encodeEdgeInsetsGeometry(
    EdgeInsetsGeometryMix value,
  ) {
    switch (value) {
      case EdgeInsetsMix edgeInsets:
        return {
          'kind': 'edgeInsets',
          if (_directDouble(edgeInsets.$left, field: 'left') case final left?)
            'left': left,
          if (_directDouble(edgeInsets.$top, field: 'top') case final top?)
            'top': top,
          if (_directDouble(edgeInsets.$right, field: 'right')
              case final right?)
            'right': right,
          if (_directDouble(edgeInsets.$bottom, field: 'bottom')
              case final bottom?)
            'bottom': bottom,
        };
      case EdgeInsetsDirectionalMix edgeInsetsDirectional:
        return {
          'kind': 'edgeInsetsDirectional',
          if (_directDouble(edgeInsetsDirectional.$start, field: 'start')
              case final start?)
            'start': start,
          if (_directDouble(edgeInsetsDirectional.$top, field: 'top')
              case final top?)
            'top': top,
          if (_directDouble(edgeInsetsDirectional.$end, field: 'end')
              case final end?)
            'end': end,
          if (_directDouble(edgeInsetsDirectional.$bottom, field: 'bottom')
              case final bottom?)
            'bottom': bottom,
        };
    }
  }

  static BoxConstraintsMix decodeBoxConstraints(Map<String, Object?> data) {
    return BoxConstraintsMix(
      minWidth: _asDouble(data['minWidth']),
      maxWidth: _asDouble(data['maxWidth']),
      minHeight: _asDouble(data['minHeight']),
      maxHeight: _asDouble(data['maxHeight']),
    );
  }

  static Map<String, Object?> encodeBoxConstraints(BoxConstraintsMix value) {
    return {
      if (_directDouble(value.$minWidth, field: 'minWidth')
          case final minWidth?)
        'minWidth': minWidth,
      if (_directDouble(value.$maxWidth, field: 'maxWidth')
          case final maxWidth?)
        'maxWidth': maxWidth,
      if (_directDouble(value.$minHeight, field: 'minHeight')
          case final minHeight?)
        'minHeight': minHeight,
      if (_directDouble(value.$maxHeight, field: 'maxHeight')
          case final maxHeight?)
        'maxHeight': maxHeight,
    };
  }

  static BoxDecorationMix decodeBoxDecoration(Map<String, Object?> data) {
    final colorInt = data['color'] as int?;
    final shadowData = data['boxShadow'] as List<Object?>?;
    final boxShadow = shadowData
        ?.whereType<Map<String, Object?>>()
        .map(decodeBoxShadow)
        .toList();

    return BoxDecorationMix(
      color: colorInt != null ? Color(colorInt) : null,
      boxShadow: boxShadow,
    );
  }

  static Map<String, Object?> encodeBoxDecoration(BoxDecorationMix value) {
    final result = <String, Object?>{'kind': 'boxDecoration'};

    final color = _directColor(value.$color, field: 'color');
    if (color != null) {
      result['color'] = color.toARGB32();
    }

    final shadows = _directBoxShadowList(value.$boxShadow, field: 'boxShadow');
    if (shadows != null && shadows.isNotEmpty) {
      result['boxShadow'] = shadows.map(encodeBoxShadow).toList();
    }

    return result;
  }

  static BoxShadowMix decodeBoxShadow(Map<String, Object?> data) {
    final colorInt = data['color'] as int?;
    final offsetData = data['offset'] as Map<String, Object?>?;
    final dx = _asDouble(offsetData?['dx']) ?? 0.0;
    final dy = _asDouble(offsetData?['dy']) ?? 0.0;

    return BoxShadowMix(
      color: colorInt != null ? Color(colorInt) : null,
      offset: Offset(dx, dy),
      blurRadius: _asDouble(data['blurRadius']),
      spreadRadius: _asDouble(data['spreadRadius']),
    );
  }

  static Map<String, Object?> encodeBoxShadow(BoxShadowMix value) {
    final result = <String, Object?>{};

    final color = _directColor(value.$color, field: 'color');
    if (color != null) {
      result['color'] = color.toARGB32();
    }

    final offset = _directOffset(value.$offset, field: 'offset');
    if (offset != null) {
      result['offset'] = {'dx': offset.dx, 'dy': offset.dy};
    }

    final blurRadius = _directDouble(value.$blurRadius, field: 'blurRadius');
    if (blurRadius != null) {
      result['blurRadius'] = blurRadius;
    }

    final spreadRadius = _directDouble(
      value.$spreadRadius,
      field: 'spreadRadius',
    );
    if (spreadRadius != null) {
      result['spreadRadius'] = spreadRadius;
    }

    return result;
  }

  static TextStyleMix decodeTextStyle(Map<String, Object?> data) {
    final colorInt = _asInt(data['color']);
    return TextStyleMix(
      color: colorInt != null ? Color(colorInt) : null,
      fontSize: _asDouble(data['fontSize']),
      fontWeight: _fontWeightFromName(data['fontWeight'] as String?),
      fontStyle: _fontStyleFromName(data['fontStyle'] as String?),
      letterSpacing: _asDouble(data['letterSpacing']),
      wordSpacing: _asDouble(data['wordSpacing']),
      height: _asDouble(data['height']),
      fontFamily: data['fontFamily'] as String?,
    );
  }

  static Map<String, Object?> encodeTextStyle(TextStyleMix value) {
    return {
      if (_directColor(value.$color, field: 'color') case final color?)
        'color': color.toARGB32(),
      if (_directDouble(value.$fontSize, field: 'fontSize')
          case final fontSize?)
        'fontSize': fontSize,
      if (_directFontWeightName(value.$fontWeight, field: 'fontWeight')
          case final fontWeight?)
        'fontWeight': fontWeight,
      if (_directEnumName(value.$fontStyle, field: 'fontStyle')
          case final fontStyle?)
        'fontStyle': fontStyle,
      if (_directDouble(value.$letterSpacing, field: 'letterSpacing')
          case final letterSpacing?)
        'letterSpacing': letterSpacing,
      if (_directDouble(value.$wordSpacing, field: 'wordSpacing')
          case final wordSpacing?)
        'wordSpacing': wordSpacing,
      if (_directDouble(value.$height, field: 'height') case final height?)
        'height': height,
      if (_directString(value.$fontFamily, field: 'fontFamily')
          case final fontFamily?)
        'fontFamily': fontFamily,
    };
  }

  static StrutStyleMix decodeStrutStyle(Map<String, Object?> data) {
    return StrutStyleMix(
      fontFamily: data['fontFamily'] as String?,
      fontSize: _asDouble(data['fontSize']),
      fontWeight: _fontWeightFromName(data['fontWeight'] as String?),
      fontStyle: _fontStyleFromName(data['fontStyle'] as String?),
      height: _asDouble(data['height']),
      leading: _asDouble(data['leading']),
      forceStrutHeight: data['forceStrutHeight'] as bool?,
    );
  }

  static Map<String, Object?> encodeStrutStyle(StrutStyleMix value) {
    return {
      if (_directString(value.$fontFamily, field: 'fontFamily')
          case final fontFamily?)
        'fontFamily': fontFamily,
      if (_directDouble(value.$fontSize, field: 'fontSize')
          case final fontSize?)
        'fontSize': fontSize,
      if (_directFontWeightName(value.$fontWeight, field: 'fontWeight')
          case final fontWeight?)
        'fontWeight': fontWeight,
      if (_directEnumName(value.$fontStyle, field: 'fontStyle')
          case final fontStyle?)
        'fontStyle': fontStyle,
      if (_directDouble(value.$height, field: 'height') case final height?)
        'height': height,
      if (_directDouble(value.$leading, field: 'leading') case final leading?)
        'leading': leading,
      if (_directBool(value.$forceStrutHeight, field: 'forceStrutHeight')
          case final forceStrutHeight?)
        'forceStrutHeight': forceStrutHeight,
    };
  }

  static TextHeightBehaviorMix decodeTextHeightBehavior(
    Map<String, Object?> data,
  ) {
    return TextHeightBehaviorMix(
      applyHeightToFirstAscent: data['applyHeightToFirstAscent'] as bool?,
      applyHeightToLastDescent: data['applyHeightToLastDescent'] as bool?,
      leadingDistribution: _textLeadingDistributionFromName(
        data['leadingDistribution'] as String?,
      ),
    );
  }

  static Map<String, Object?> encodeTextHeightBehavior(
    TextHeightBehaviorMix value,
  ) {
    return {
      if (_directBool(
            value.$applyHeightToFirstAscent,
            field: 'applyHeightToFirstAscent',
          )
          case final firstAscent?)
        'applyHeightToFirstAscent': firstAscent,
      if (_directBool(
            value.$applyHeightToLastDescent,
            field: 'applyHeightToLastDescent',
          )
          case final lastDescent?)
        'applyHeightToLastDescent': lastDescent,
      if (_directEnumName(
            value.$leadingDistribution,
            field: 'leadingDistribution',
          )
          case final leadingDistribution?)
        'leadingDistribution': leadingDistribution,
    };
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();

    throw StateError('Expected num-compatible value, got ${value.runtimeType}');
  }

  static int? _asInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;

    throw StateError('Expected int value, got ${value.runtimeType}');
  }

  static double? _directDouble(Prop<double>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<double>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static bool? _directBool(Prop<bool>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<bool>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static String? _directString(Prop<String>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<String>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static String? _directEnumName<T extends Enum>(
    Prop<T>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<T>(:final value) => value.name,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static String? _directFontWeightName(
    Prop<FontWeight>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    final value = switch (source) {
      ValueSource<FontWeight>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };

    return switch (value) {
      FontWeight.w100 => 'w100',
      FontWeight.w200 => 'w200',
      FontWeight.w300 => 'w300',
      FontWeight.w400 => 'w400',
      FontWeight.w500 => 'w500',
      FontWeight.w600 => 'w600',
      FontWeight.w700 => 'w700',
      FontWeight.w800 => 'w800',
      FontWeight.w900 => 'w900',
      _ => throw StateError('Unsupported FontWeight value: $value'),
    };
  }

  static Color? _directColor(Prop<Color>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<Color>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static Offset? _directOffset(Prop<Offset>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<Offset>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static List<BoxShadowMix>? _directBoxShadowList(
    Prop<List<BoxShadow>>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    switch (source) {
      case MixSource<List<BoxShadow>>(:final mix):
        if (mix is BoxShadowListMix) {
          return mix.items;
        }
        throw StateError(
          'Field "$field" must use BoxShadowListMix to encode box shadows.',
        );
      case ValueSource<List<BoxShadow>>(:final value):
        return value.map(BoxShadowMix.value).toList();
      default:
        throw StateError('Field "$field" has unsupported shadow source.');
    }
  }

  static PropSource<T> _singleSource<T extends Object>(
    Prop<T> prop, {
    required String field,
  }) {
    if (prop.sources.length != 1) {
      throw StateError(
        'Field "$field" must contain exactly one source for deterministic encoding.',
      );
    }

    return prop.sources.single;
  }

  static FontWeight? _fontWeightFromName(String? name) {
    if (name == null) return null;
    return switch (name) {
      'w100' => FontWeight.w100,
      'w200' => FontWeight.w200,
      'w300' => FontWeight.w300,
      'w400' => FontWeight.w400,
      'w500' => FontWeight.w500,
      'w600' => FontWeight.w600,
      'w700' => FontWeight.w700,
      'w800' => FontWeight.w800,
      'w900' => FontWeight.w900,
      _ => throw StateError('Unsupported FontWeight value: $name'),
    };
  }

  static FontStyle? _fontStyleFromName(String? name) {
    if (name == null) return null;
    return switch (name) {
      'normal' => FontStyle.normal,
      'italic' => FontStyle.italic,
      _ => throw StateError('Unsupported FontStyle value: $name'),
    };
  }

  static TextLeadingDistribution? _textLeadingDistributionFromName(
    String? name,
  ) {
    if (name == null) return null;
    return switch (name) {
      'proportional' => TextLeadingDistribution.proportional,
      'even' => TextLeadingDistribution.even,
      _ => throw StateError('Unsupported TextLeadingDistribution value: $name'),
    };
  }
}
