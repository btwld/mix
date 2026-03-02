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

  static AlignmentGeometry decodeAlignmentGeometry(Map<String, Object?> data) {
    final kind = data['kind'] as String;
    switch (kind) {
      case 'alignment':
        return Alignment(
          _asRequiredDouble(data['x'], field: 'x'),
          _asRequiredDouble(data['y'], field: 'y'),
        );
      case 'alignmentDirectional':
        return AlignmentDirectional(
          _asRequiredDouble(data['start'], field: 'start'),
          _asRequiredDouble(data['y'], field: 'y'),
        );
      default:
        throw StateError('Unsupported alignment kind: $kind');
    }
  }

  static Map<String, Object?> encodeAlignmentGeometry(AlignmentGeometry value) {
    return switch (value) {
      Alignment alignment => {
        'kind': 'alignment',
        'x': alignment.x,
        'y': alignment.y,
      },
      AlignmentDirectional directional => {
        'kind': 'alignmentDirectional',
        'start': directional.start,
        'y': directional.y,
      },
      _ => throw StateError(
        'Unsupported AlignmentGeometry type: ${value.runtimeType}',
      ),
    };
  }

  static Matrix4 decodeMatrix4(List<Object?> data) {
    if (data.length != 16) {
      throw StateError(
        'Matrix4 payload must have exactly 16 entries, got ${data.length}.',
      );
    }

    return Matrix4.fromList([
      for (final item in data) _asRequiredDouble(item, field: 'matrixEntry'),
    ]);
  }

  static List<double> encodeMatrix4(Matrix4 value) {
    return value.storage.toList(growable: false);
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
    if (data['image'] != null) {
      throw StateError(
        'BoxDecoration.image is deferred in v1 and is not supported in mix_schema yet.',
      );
    }

    final colorInt = _asInt(data['color']);
    final shadowData = data['boxShadow'] as List<Object?>?;
    final boxShadow = shadowData
        ?.whereType<Map<String, Object?>>()
        .map(decodeBoxShadow)
        .toList();

    final borderData = data['border'] as Map<String, Object?>?;
    final border = borderData != null ? decodeBoxBorder(borderData) : null;

    final borderRadiusData = data['borderRadius'] as Map<String, Object?>?;
    final borderRadius = borderRadiusData != null
        ? decodeBorderRadiusGeometry(borderRadiusData)
        : null;

    final gradientData = data['gradient'] as Map<String, Object?>?;
    final gradient = gradientData != null ? decodeGradient(gradientData) : null;

    final shapeName = data['shape'] as String?;
    final shape = shapeName != null
        ? _enumByName(BoxShape.values, shapeName, field: 'shape')
        : null;

    final backgroundBlendModeName = data['backgroundBlendMode'] as String?;
    final backgroundBlendMode = backgroundBlendModeName != null
        ? _enumByName(
            BlendMode.values,
            backgroundBlendModeName,
            field: 'backgroundBlendMode',
          )
        : null;

    return BoxDecorationMix(
      color: colorInt != null ? Color(colorInt) : null,
      boxShadow: boxShadow,
      border: border,
      borderRadius: borderRadius,
      gradient: gradient,
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
    );
  }

  static Map<String, Object?> encodeBoxDecoration(BoxDecorationMix value) {
    if (value.$image != null) {
      throw StateError(
        'BoxDecoration.image is deferred in v1 and is not supported in mix_schema yet.',
      );
    }

    final result = <String, Object?>{'kind': 'boxDecoration'};

    final color = _directColor(value.$color, field: 'color');
    if (color != null) {
      result['color'] = color.toARGB32();
    }

    final border = _directBoxBorder(value.$border, field: 'border');
    if (border != null) {
      result['border'] = encodeBoxBorder(border);
    }

    final borderRadius = _directBorderRadiusGeometry(
      value.$borderRadius,
      field: 'borderRadius',
    );
    if (borderRadius != null) {
      result['borderRadius'] = encodeBorderRadiusGeometry(borderRadius);
    }

    final gradient = _directGradient(value.$gradient, field: 'gradient');
    if (gradient != null) {
      result['gradient'] = encodeGradient(gradient);
    }

    final shadows = _directBoxShadowList(value.$boxShadow, field: 'boxShadow');
    if (shadows != null && shadows.isNotEmpty) {
      result['boxShadow'] = shadows.map(encodeBoxShadow).toList();
    }

    final shape = _directEnumName(value.$shape, field: 'shape');
    if (shape != null) {
      result['shape'] = shape;
    }

    final blendMode = _directEnumName(
      value.$backgroundBlendMode,
      field: 'backgroundBlendMode',
    );
    if (blendMode != null) {
      result['backgroundBlendMode'] = blendMode;
    }

    return result;
  }

  static BoxShadowMix decodeBoxShadow(Map<String, Object?> data) {
    final colorInt = _asInt(data['color']);
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

  static BoxBorderMix decodeBoxBorder(Map<String, Object?> data) {
    final kind = data['kind'] as String;

    switch (kind) {
      case 'border':
        return BorderMix(
          top: _decodeBorderSideField(data['top']),
          bottom: _decodeBorderSideField(data['bottom']),
          left: _decodeBorderSideField(data['left']),
          right: _decodeBorderSideField(data['right']),
        );
      case 'borderDirectional':
        return BorderDirectionalMix(
          top: _decodeBorderSideField(data['top']),
          bottom: _decodeBorderSideField(data['bottom']),
          start: _decodeBorderSideField(data['start']),
          end: _decodeBorderSideField(data['end']),
        );
      default:
        throw StateError('Unsupported box border kind: $kind');
    }
  }

  static Map<String, Object?> encodeBoxBorder(BoxBorderMix value) {
    return switch (value) {
      BorderMix border => {
        'kind': 'border',
        if (_directBorderSideMix(border.$top, field: 'top') case final top?)
          'top': encodeBorderSide(top),
        if (_directBorderSideMix(border.$bottom, field: 'bottom')
            case final bottom?)
          'bottom': encodeBorderSide(bottom),
        if (_directBorderSideMix(border.$left, field: 'left') case final left?)
          'left': encodeBorderSide(left),
        if (_directBorderSideMix(border.$right, field: 'right')
            case final right?)
          'right': encodeBorderSide(right),
      },
      BorderDirectionalMix border => {
        'kind': 'borderDirectional',
        if (_directBorderSideMix(border.$top, field: 'top') case final top?)
          'top': encodeBorderSide(top),
        if (_directBorderSideMix(border.$bottom, field: 'bottom')
            case final bottom?)
          'bottom': encodeBorderSide(bottom),
        if (_directBorderSideMix(border.$start, field: 'start')
            case final start?)
          'start': encodeBorderSide(start),
        if (_directBorderSideMix(border.$end, field: 'end') case final end?)
          'end': encodeBorderSide(end),
      },
    };
  }

  static BorderSideMix decodeBorderSide(Map<String, Object?> data) {
    final colorInt = _asInt(data['color']);
    final styleName = data['style'] as String?;
    final style = styleName != null
        ? _enumByName(BorderStyle.values, styleName, field: 'style')
        : null;

    return BorderSideMix(
      color: colorInt != null ? Color(colorInt) : null,
      width: _asDouble(data['width']),
      style: style,
      strokeAlign: _asDouble(data['strokeAlign']),
    );
  }

  static Map<String, Object?> encodeBorderSide(BorderSideMix value) {
    return {
      if (_directColor(value.$color, field: 'color') case final color?)
        'color': color.toARGB32(),
      if (_directDouble(value.$width, field: 'width') case final width?)
        'width': width,
      if (_directEnumName(value.$style, field: 'style') case final style?)
        'style': style,
      if (_directDouble(value.$strokeAlign, field: 'strokeAlign')
          case final strokeAlign?)
        'strokeAlign': strokeAlign,
    };
  }

  static BorderRadiusGeometryMix decodeBorderRadiusGeometry(
    Map<String, Object?> data,
  ) {
    final kind = data['kind'] as String;

    switch (kind) {
      case 'borderRadius':
        return BorderRadiusMix(
          topLeft: _decodeRadiusField(data['topLeft']),
          topRight: _decodeRadiusField(data['topRight']),
          bottomLeft: _decodeRadiusField(data['bottomLeft']),
          bottomRight: _decodeRadiusField(data['bottomRight']),
        );
      case 'borderRadiusDirectional':
        return BorderRadiusDirectionalMix(
          topStart: _decodeRadiusField(data['topStart']),
          topEnd: _decodeRadiusField(data['topEnd']),
          bottomStart: _decodeRadiusField(data['bottomStart']),
          bottomEnd: _decodeRadiusField(data['bottomEnd']),
        );
      default:
        throw StateError('Unsupported border radius kind: $kind');
    }
  }

  static Map<String, Object?> encodeBorderRadiusGeometry(
    BorderRadiusGeometryMix value,
  ) {
    return switch (value) {
      BorderRadiusMix radius => {
        'kind': 'borderRadius',
        if (_directRadius(radius.$topLeft, field: 'topLeft')
            case final topLeft?)
          'topLeft': encodeRadius(topLeft),
        if (_directRadius(radius.$topRight, field: 'topRight')
            case final topRight?)
          'topRight': encodeRadius(topRight),
        if (_directRadius(radius.$bottomLeft, field: 'bottomLeft')
            case final bottomLeft?)
          'bottomLeft': encodeRadius(bottomLeft),
        if (_directRadius(radius.$bottomRight, field: 'bottomRight')
            case final bottomRight?)
          'bottomRight': encodeRadius(bottomRight),
      },
      BorderRadiusDirectionalMix radius => {
        'kind': 'borderRadiusDirectional',
        if (_directRadius(radius.$topStart, field: 'topStart')
            case final topStart?)
          'topStart': encodeRadius(topStart),
        if (_directRadius(radius.$topEnd, field: 'topEnd') case final topEnd?)
          'topEnd': encodeRadius(topEnd),
        if (_directRadius(radius.$bottomStart, field: 'bottomStart')
            case final bottomStart?)
          'bottomStart': encodeRadius(bottomStart),
        if (_directRadius(radius.$bottomEnd, field: 'bottomEnd')
            case final bottomEnd?)
          'bottomEnd': encodeRadius(bottomEnd),
      },
    };
  }

  static Radius decodeRadius(Map<String, Object?> data) {
    return Radius.elliptical(
      _asRequiredDouble(data['x'], field: 'x'),
      _asRequiredDouble(data['y'], field: 'y'),
    );
  }

  static Map<String, Object?> encodeRadius(Radius value) {
    return {'x': value.x, 'y': value.y};
  }

  static GradientMix decodeGradient(Map<String, Object?> data) {
    final kind = data['kind'] as String;

    final colors = _decodeColorList(data['colors']);
    final stops = _decodeDoubleList(data['stops']);
    final transformData = data['transform'] as Map<String, Object?>?;
    final transform = transformData != null
        ? decodeGradientTransform(transformData)
        : null;

    switch (kind) {
      case 'linearGradient':
        final beginData = data['begin'] as Map<String, Object?>?;
        final endData = data['end'] as Map<String, Object?>?;
        final tileModeName = data['tileMode'] as String?;

        return LinearGradientMix(
          begin: beginData != null ? decodeAlignmentGeometry(beginData) : null,
          end: endData != null ? decodeAlignmentGeometry(endData) : null,
          tileMode: tileModeName != null
              ? _enumByName(TileMode.values, tileModeName, field: 'tileMode')
              : null,
          transform: transform,
          colors: colors,
          stops: stops,
        );
      case 'radialGradient':
        final centerData = data['center'] as Map<String, Object?>?;
        final focalData = data['focal'] as Map<String, Object?>?;
        final tileModeName = data['tileMode'] as String?;

        return RadialGradientMix(
          center: centerData != null
              ? decodeAlignmentGeometry(centerData)
              : null,
          radius: _asDouble(data['radius']),
          tileMode: tileModeName != null
              ? _enumByName(TileMode.values, tileModeName, field: 'tileMode')
              : null,
          focal: focalData != null ? decodeAlignmentGeometry(focalData) : null,
          focalRadius: _asDouble(data['focalRadius']),
          transform: transform,
          colors: colors,
          stops: stops,
        );
      case 'sweepGradient':
        final centerData = data['center'] as Map<String, Object?>?;
        final tileModeName = data['tileMode'] as String?;

        return SweepGradientMix(
          center: centerData != null
              ? decodeAlignmentGeometry(centerData)
              : null,
          startAngle: _asDouble(data['startAngle']),
          endAngle: _asDouble(data['endAngle']),
          tileMode: tileModeName != null
              ? _enumByName(TileMode.values, tileModeName, field: 'tileMode')
              : null,
          transform: transform,
          colors: colors,
          stops: stops,
        );
      default:
        throw StateError('Unsupported gradient kind: $kind');
    }
  }

  static Map<String, Object?> encodeGradient(GradientMix value) {
    return switch (value) {
      LinearGradientMix gradient => {
        'kind': 'linearGradient',
        if (_directAlignmentGeometry(gradient.$begin, field: 'begin')
            case final begin?)
          'begin': encodeAlignmentGeometry(begin),
        if (_directAlignmentGeometry(gradient.$end, field: 'end')
            case final end?)
          'end': encodeAlignmentGeometry(end),
        if (_directEnumName(gradient.$tileMode, field: 'tileMode')
            case final tileMode?)
          'tileMode': tileMode,
        if (_directGradientTransform(gradient.$transform, field: 'transform')
            case final transform?)
          'transform': encodeGradientTransform(transform),
        if (_directColorList(gradient.$colors, field: 'colors')
            case final colors?)
          'colors': [for (final color in colors) color.toARGB32()],
        if (_directDoubleList(gradient.$stops, field: 'stops')
            case final stops?)
          'stops': stops,
      },
      RadialGradientMix gradient => {
        'kind': 'radialGradient',
        if (_directAlignmentGeometry(gradient.$center, field: 'center')
            case final center?)
          'center': encodeAlignmentGeometry(center),
        if (_directDouble(gradient.$radius, field: 'radius') case final radius?)
          'radius': radius,
        if (_directEnumName(gradient.$tileMode, field: 'tileMode')
            case final tileMode?)
          'tileMode': tileMode,
        if (_directAlignmentGeometry(gradient.$focal, field: 'focal')
            case final focal?)
          'focal': encodeAlignmentGeometry(focal),
        if (_directDouble(gradient.$focalRadius, field: 'focalRadius')
            case final focalRadius?)
          'focalRadius': focalRadius,
        if (_directGradientTransform(gradient.$transform, field: 'transform')
            case final transform?)
          'transform': encodeGradientTransform(transform),
        if (_directColorList(gradient.$colors, field: 'colors')
            case final colors?)
          'colors': [for (final color in colors) color.toARGB32()],
        if (_directDoubleList(gradient.$stops, field: 'stops')
            case final stops?)
          'stops': stops,
      },
      SweepGradientMix gradient => {
        'kind': 'sweepGradient',
        if (_directAlignmentGeometry(gradient.$center, field: 'center')
            case final center?)
          'center': encodeAlignmentGeometry(center),
        if (_directDouble(gradient.$startAngle, field: 'startAngle')
            case final startAngle?)
          'startAngle': startAngle,
        if (_directDouble(gradient.$endAngle, field: 'endAngle')
            case final endAngle?)
          'endAngle': endAngle,
        if (_directEnumName(gradient.$tileMode, field: 'tileMode')
            case final tileMode?)
          'tileMode': tileMode,
        if (_directGradientTransform(gradient.$transform, field: 'transform')
            case final transform?)
          'transform': encodeGradientTransform(transform),
        if (_directColorList(gradient.$colors, field: 'colors')
            case final colors?)
          'colors': [for (final color in colors) color.toARGB32()],
        if (_directDoubleList(gradient.$stops, field: 'stops')
            case final stops?)
          'stops': stops,
      },
    };
  }

  static GradientTransform decodeGradientTransform(Map<String, Object?> data) {
    final kind = data['kind'] as String;
    switch (kind) {
      case 'gradientRotation':
        return GradientRotation(
          _asRequiredDouble(data['radians'], field: 'radians'),
        );
      default:
        throw StateError('Unsupported gradient transform kind: $kind');
    }
  }

  static Map<String, Object?> encodeGradientTransform(GradientTransform value) {
    return switch (value) {
      GradientRotation rotation => {
        'kind': 'gradientRotation',
        'radians': rotation.radians,
      },
      _ => throw StateError(
        'Unsupported GradientTransform type: ${value.runtimeType}',
      ),
    };
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

  static double _asRequiredDouble(Object? value, {required String field}) {
    final parsed = _asDouble(value);
    if (parsed == null) {
      throw StateError('Field "$field" must be a non-null double value.');
    }

    return parsed;
  }

  static int? _asInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double && value == value.roundToDouble()) {
      return value.toInt();
    }

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

  static AlignmentGeometry? _directAlignmentGeometry(
    Prop<AlignmentGeometry>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<AlignmentGeometry>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static List<Color>? _directColorList(
    Prop<List<Color>>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<List<Color>>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static List<double>? _directDoubleList(
    Prop<List<double>>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<List<double>>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static GradientTransform? _directGradientTransform(
    Prop<GradientTransform>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<GradientTransform>(:final value) => value,
      _ => throw StateError('Field "$field" must use a direct value source.'),
    };
  }

  static BoxBorderMix? _directBoxBorder(
    Prop<BoxBorder>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      MixSource<BoxBorder>(:final mix) =>
        mix is BoxBorderMix
            ? mix
            : throw StateError('Field "$field" must use BoxBorderMix.'),
      ValueSource<BoxBorder>(:final value) => BoxBorderMix.value(value),
      _ => throw StateError('Field "$field" has unsupported border source.'),
    };
  }

  static BorderRadiusGeometryMix? _directBorderRadiusGeometry(
    Prop<BorderRadiusGeometry>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      MixSource<BorderRadiusGeometry>(:final mix) =>
        mix is BorderRadiusGeometryMix
            ? mix
            : throw StateError(
                'Field "$field" must use BorderRadiusGeometryMix.',
              ),
      ValueSource<BorderRadiusGeometry>(:final value) =>
        BorderRadiusGeometryMix.value(value),
      _ => throw StateError(
        'Field "$field" has unsupported border radius source.',
      ),
    };
  }

  static GradientMix? _directGradient(
    Prop<Gradient>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      MixSource<Gradient>(:final mix) =>
        mix is GradientMix
            ? mix
            : throw StateError('Field "$field" must use GradientMix.'),
      ValueSource<Gradient>(:final value) => GradientMix.value(value),
      _ => throw StateError('Field "$field" has unsupported gradient source.'),
    };
  }

  static BorderSideMix? _directBorderSideMix(
    Prop<BorderSide>? prop, {
    required String field,
  }) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      MixSource<BorderSide>(:final mix) =>
        mix is BorderSideMix
            ? mix
            : throw StateError('Field "$field" must use BorderSideMix.'),
      ValueSource<BorderSide>(:final value) => BorderSideMix.value(value),
      _ => throw StateError(
        'Field "$field" has unsupported border side source.',
      ),
    };
  }

  static Radius? _directRadius(Prop<Radius>? prop, {required String field}) {
    if (prop == null) return null;

    final source = _singleSource(prop, field: field);
    return switch (source) {
      ValueSource<Radius>(:final value) => value,
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

  static BorderSideMix? _decodeBorderSideField(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, Object?>) {
      throw StateError(
        'Border side payload must be an object, got ${value.runtimeType}.',
      );
    }

    return decodeBorderSide(value);
  }

  static Radius? _decodeRadiusField(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, Object?>) {
      throw StateError(
        'Radius payload must be an object, got ${value.runtimeType}.',
      );
    }

    return decodeRadius(value);
  }

  static List<Color>? _decodeColorList(Object? value) {
    if (value == null) return null;
    if (value is! List<Object?>) {
      throw StateError('Expected color list, got ${value.runtimeType}.');
    }

    return [
      for (final entry in value)
        Color(
          _asInt(entry) ??
              (throw StateError('Color list entries must be non-null ints.')),
        ),
    ];
  }

  static List<double>? _decodeDoubleList(Object? value) {
    if (value == null) return null;
    if (value is! List<Object?>) {
      throw StateError('Expected double list, got ${value.runtimeType}.');
    }

    return [
      for (final entry in value) _asRequiredDouble(entry, field: 'listEntry'),
    ];
  }

  static T _enumByName<T extends Enum>(
    List<T> values,
    String name, {
    required String field,
  }) {
    for (final value in values) {
      if (value.name == name) return value;
    }

    throw StateError('Unsupported $field enum value: $name');
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
