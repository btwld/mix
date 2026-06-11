import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

import 'tw_config.dart';
import 'tw_semantic.dart';
import 'tw_utils.dart';

typedef TwPayloadTokenLister = List<String> Function(String classNames);
typedef TwPayloadTokenResolver = List<TwParsedClass>? Function(String token);
typedef TwPayloadTokenPredicate = bool Function(String token);
typedef TwPayloadTextShadowResolver = List<ShadowMix>? Function(TwValue value);

typedef _PayloadPropertyApplier =
    bool Function(
      JsonMap payload,
      TwProperty property,
      TwValue value,
      String token,
    );
typedef _PayloadFallbackApplier = bool Function(JsonMap payload, String token);

final class SchemaPayloadUnsupported implements Exception {
  const SchemaPayloadUnsupported(this.errors);

  final List<MixSchemaError> errors;

  @override
  String toString() => 'Unsupported Tailwinds schema payload: $errors';
}

final class TwSchemaPayloadBuilder {
  TwSchemaPayloadBuilder({
    required TwConfig config,
    required TwPayloadTokenLister listTokens,
    required TwPayloadTokenResolver resolveToken,
    required TwPayloadTokenPredicate isBoxLikeDirectOnlyPayloadToken,
    required TwPayloadTokenPredicate isAnimationToken,
    required TwPayloadTextShadowResolver resolveTextShadowMixes,
  }) : _config = config,
       _listTokens = listTokens,
       _resolveToken = resolveToken,
       _isBoxLikeDirectOnlyPayloadToken = isBoxLikeDirectOnlyPayloadToken,
       _isAnimationToken = isAnimationToken,
       _resolveTextShadowMixes = resolveTextShadowMixes;

  final TwConfig _config;
  final TwPayloadTokenLister _listTokens;
  final TwPayloadTokenResolver _resolveToken;
  final TwPayloadTokenPredicate _isBoxLikeDirectOnlyPayloadToken;
  final TwPayloadTokenPredicate _isAnimationToken;
  final TwPayloadTextShadowResolver _resolveTextShadowMixes;
  final MixSchemaContract _schemaContract = MixSchemaContractBuilder()
      .builtIn()
      .freeze();

  JsonMap? tryBuildFlexPayload(String classNames) {
    return _tryBuildPayload(
      classNames: classNames,
      payload: {'type': SchemaStyler.flexBox.wireValue},
      blocksPayload: _isBoxLikeDirectOnlyPayloadToken,
      skipsToken: _isFlexWidgetLayerGapToken,
      applyFallback: _applySharedPayloadFallback,
      applyProperty: _applyFlexPayloadProperty,
    );
  }

  JsonMap? tryBuildBoxPayload(String classNames) {
    return _tryBuildPayload(
      classNames: classNames,
      payload: {'type': SchemaStyler.box.wireValue},
      blocksPayload: _isBoxLikeDirectOnlyPayloadToken,
      applyFallback: _applySharedPayloadFallback,
      applyProperty: _applyBoxPayloadProperty,
    );
  }

  JsonMap? tryBuildTextPayload(String classNames) {
    return _tryBuildPayload(
      classNames: classNames,
      payload: {
        'type': SchemaStyler.text.wireValue,
        'style': <String, Object?>{'height': _config.textDefaults.lineHeight},
      },
      applyFallback: _applyTextPayloadFallback,
      applyProperty: _applyTextPayloadProperty,
    );
  }

  JsonMap encodeFlexPayload(FlexBoxStyler styler) {
    return _encodePayload(styler, expectedType: SchemaStyler.flexBox);
  }

  JsonMap encodeBoxPayload(BoxStyler styler) {
    return _encodePayload(styler, expectedType: SchemaStyler.box);
  }

  JsonMap encodeTextPayload(TextStyler styler) {
    return _encodePayload(styler, expectedType: SchemaStyler.text);
  }

  T decodePayload<T extends Object>(JsonMap payload) {
    final result = _schemaContract.decode<T>(payload);

    return switch (result) {
      MixSchemaDecodeSuccess<T>(:final value) => value,
      MixSchemaDecodeFailure<T>(:final errors) => throw StateError(
        'Tailwinds emitted an invalid schema payload: $errors',
      ),
    };
  }

  JsonMap? _tryBuildPayload({
    required String classNames,
    required JsonMap payload,
    required _PayloadFallbackApplier applyFallback,
    required _PayloadPropertyApplier applyProperty,
    TwPayloadTokenPredicate? blocksPayload,
    TwPayloadTokenPredicate? skipsToken,
  }) {
    for (final token in _listTokens(classNames)) {
      if (_hasSchemaPrefix(token)) return null;
      if (blocksPayload?.call(token) ?? false) return null;
      if (skipsToken?.call(token) ?? false) continue;

      final parsed = _resolveToken(token);
      if (parsed == null || parsed.isEmpty) {
        if (!applyFallback(payload, token)) return null;
        continue;
      }

      for (final p in parsed) {
        if (!applyProperty(payload, p.property, p.value, token)) return null;
      }
    }

    return payload;
  }

  bool _hasSchemaPrefix(String token) {
    return findFirstColonOutsideBrackets(token) > 0;
  }

  bool _isFlexWidgetLayerGapToken(String token) {
    return token.startsWith('gap-x-') || token.startsWith('gap-y-');
  }

  bool _applyFlexPayloadProperty(
    JsonMap payload,
    TwProperty property,
    TwValue value,
    String token,
  ) {
    if (_applyBoxPayloadProperty(payload, property, value, token)) return true;

    switch (property) {
      case TwProperty.display:
        if (value is TwEnumValue && value.value == 'flex') {
          payload['direction'] = Axis.horizontal.name;
        }
      case TwProperty.flexDirection:
        if (value is! TwEnumValue<Axis>) return false;
        payload['direction'] = value.value.name;
      case TwProperty.alignItems:
        if (value is! TwEnumValue<CrossAxisAlignment>) return false;
        payload['crossAxisAlignment'] = value.value.name;
        if (value.value == CrossAxisAlignment.baseline) {
          payload['textBaseline'] = TextBaseline.alphabetic.name;
        }
      case TwProperty.justifyContent:
        if (value is! TwEnumValue<MainAxisAlignment>) return false;
        payload['mainAxisAlignment'] = value.value.name;
      case TwProperty.gap:
        if (value is! TwLengthValue) return false;
        payload['spacing'] = value.value;
      default:
        return false;
    }

    return true;
  }

  bool _applyBoxPayloadProperty(
    JsonMap payload,
    TwProperty property,
    TwValue value,
    String token,
  ) {
    switch (property) {
      case TwProperty.padding:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'all');
      case TwProperty.paddingX:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'x');
      case TwProperty.paddingY:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'y');
      case TwProperty.paddingTop:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'top');
      case TwProperty.paddingRight:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'right');
      case TwProperty.paddingBottom:
        return _setEdgeInsetsPayload(
          payload,
          'padding',
          value,
          sides: 'bottom',
        );
      case TwProperty.paddingLeft:
        return _setEdgeInsetsPayload(payload, 'padding', value, sides: 'left');
      case TwProperty.margin:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'all');
      case TwProperty.marginX:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'x');
      case TwProperty.marginY:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'y');
      case TwProperty.marginTop:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'top');
      case TwProperty.marginRight:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'right');
      case TwProperty.marginBottom:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'bottom');
      case TwProperty.marginLeft:
        return _setEdgeInsetsPayload(payload, 'margin', value, sides: 'left');
      case TwProperty.width:
        return _setConstraintPayload(payload, value, width: true, fixed: true);
      case TwProperty.height:
        return _setConstraintPayload(payload, value, height: true, fixed: true);
      case TwProperty.minWidth:
        return _setConstraintPayload(payload, value, minWidth: true);
      case TwProperty.minHeight:
        return _setConstraintPayload(payload, value, minHeight: true);
      case TwProperty.maxWidth:
        return _setConstraintPayload(payload, value, maxWidth: true);
      case TwProperty.maxHeight:
        return _setConstraintPayload(payload, value, maxHeight: true);
      case TwProperty.backgroundColor:
        if (value is! TwColorValue) return false;
        final color = _payloadColor(value.color);
        if (color == null) return false;
        _decoration(payload)['color'] = color;
      case TwProperty.borderRadius:
        return _setRadiusPayload(payload, value, corners: 'all');
      case TwProperty.borderRadiusTop:
        return _setRadiusPayload(payload, value, corners: 'top');
      case TwProperty.borderRadiusBottom:
        return _setRadiusPayload(payload, value, corners: 'bottom');
      case TwProperty.borderRadiusLeft:
        return _setRadiusPayload(payload, value, corners: 'left');
      case TwProperty.borderRadiusRight:
        return _setRadiusPayload(payload, value, corners: 'right');
      case TwProperty.borderRadiusTopLeft:
        return _setRadiusPayload(payload, value, corners: 'topLeft');
      case TwProperty.borderRadiusTopRight:
        return _setRadiusPayload(payload, value, corners: 'topRight');
      case TwProperty.borderRadiusBottomLeft:
        return _setRadiusPayload(payload, value, corners: 'bottomLeft');
      case TwProperty.borderRadiusBottomRight:
        return _setRadiusPayload(payload, value, corners: 'bottomRight');
      case TwProperty.blur:
        if (value is! TwLengthValue) return false;
        _modifiers(payload).add({'type': 'blur', 'sigma': value.value});
      case TwProperty.boxShadow:
        final shadows = _boxShadowPayload(value);
        if (shadows == null) return false;
        _decoration(payload)['boxShadow'] = shadows;
      case TwProperty.clipBehavior:
        if (value is! TwEnumValue<Clip>) return false;
        payload['clipBehavior'] = value.value.name;
      case TwProperty.textColor:
        if (value is! TwColorValue) return false;
        final color = _payloadColor(value.color);
        if (color == null) return false;
        _defaultTextStyle(payload)['color'] = color;
      case TwProperty.fontSize:
        if (value is! TwLengthValue) return false;
        _defaultTextStyle(payload)['fontSize'] = value.value;
      case TwProperty.fontWeight:
        if (value is! TwEnumValue<FontWeight>) return false;
        _defaultTextStyle(payload)['fontWeight'] = _fontWeightWire(value.value);
      case TwProperty.textShadow:
        final shadows = _textShadowPayload(value);
        if (shadows == null) return false;
        _defaultTextStyle(payload)['shadows'] = shadows;
      default:
        return false;
    }

    return true;
  }

  bool _applyTextPayloadProperty(
    JsonMap payload,
    TwProperty property,
    TwValue value,
    String token,
  ) {
    switch (property) {
      case TwProperty.textColor:
        if (value is! TwColorValue) return false;
        final color = _payloadColor(value.color);
        if (color == null) return false;
        _textStyle(payload)['color'] = color;
      case TwProperty.fontSize:
        if (value is! TwLengthValue) return false;
        _textStyle(payload)['fontSize'] = value.value;
        final key = _findTextSizeKey(token);
        final lineHeight = key == null ? null : tailwindLineHeights[key];
        if (lineHeight != null) _textStyle(payload)['height'] = lineHeight;
      case TwProperty.fontWeight:
        if (value is! TwEnumValue<FontWeight>) return false;
        _textStyle(payload)['fontWeight'] = _fontWeightWire(value.value);
      case TwProperty.textAlign:
        if (value is! TwEnumValue<TextAlign>) return false;
        payload['textAlign'] = value.value.name;
      case TwProperty.lineHeight:
        if (value is! TwLengthValue) return false;
        _textStyle(payload)['height'] = value.value;
      case TwProperty.letterSpacing:
        if (value is! TwLengthValue) return false;
        _textStyle(payload)['letterSpacing'] = value.value;
      case TwProperty.textTransform:
        if (value is! TwEnumValue<String>) return false;
        _textDirectives(payload).add(value.value);
      case TwProperty.textOverflow:
        payload['overflow'] = TextOverflow.ellipsis.name;
        payload['maxLines'] = 1;
        payload['softWrap'] = false;
      case TwProperty.textShadow:
        final shadows = _textShadowPayload(value);
        if (shadows == null) return false;
        _textStyle(payload)['shadows'] = shadows;
      default:
        return false;
    }

    return true;
  }

  bool _applySharedPayloadFallback(JsonMap payload, String token) {
    if (token.startsWith('w-')) {
      final value = _spacePayloadValue(token.substring(2));
      if (value == null) return _isWidgetLayerSizingToken(token.substring(2));
      return _setConstraintPayload(payload, value, width: true, fixed: true);
    }
    if (token.startsWith('h-')) {
      final value = _spacePayloadValue(token.substring(2));
      if (value == null) return _isWidgetLayerSizingToken(token.substring(2));
      return _setConstraintPayload(payload, value, height: true, fixed: true);
    }
    if (token.startsWith('flex-') ||
        token.startsWith('basis-') ||
        token.startsWith('self-') ||
        token.startsWith('shrink') ||
        _isAnimationToken(token)) {
      return true;
    }
    if (token.startsWith('text-')) {
      final key = token.substring(5);
      final color = _config.colorOf(key);
      if (color != null) {
        final wireColor = _payloadColor(color);
        if (wireColor == null) return false;
        _defaultTextStyle(payload)['color'] = wireColor;
        return true;
      }
      final size = _config.fontSizeOf(key, fallback: -1);
      if (size > 0) {
        _defaultTextStyle(payload)['fontSize'] = size;
        final lineHeight = tailwindLineHeights[key];
        if (lineHeight != null) {
          _defaultTextStyle(payload)['height'] = lineHeight;
        }
        return true;
      }
    }

    return false;
  }

  bool _applyTextPayloadFallback(JsonMap payload, String token) {
    if (token == 'leading-even' || token == 'leading-trim') {
      payload['textHeightBehavior'] = {
        'leadingDistribution': TextLeadingDistribution.even.name,
        if (token == 'leading-trim') ...{
          'applyHeightToFirstAscent': false,
          'applyHeightToLastDescent': false,
        },
      };
      return true;
    }
    if (_isAnimationToken(token)) return true;
    if (token.startsWith('text-')) {
      final key = token.substring(5);
      final size = _config.fontSizeOf(key, fallback: -1);
      if (size > 0) {
        _textStyle(payload)['fontSize'] = size;
        final lineHeight = tailwindLineHeights[key];
        if (lineHeight != null) _textStyle(payload)['height'] = lineHeight;
        return true;
      }
      final color = _config.colorOf(key);
      if (color != null) {
        final wireColor = _payloadColor(color);
        if (wireColor == null) return false;
        _textStyle(payload)['color'] = wireColor;
        return true;
      }
    }

    return false;
  }

  bool _setEdgeInsetsPayload(
    JsonMap payload,
    String field,
    TwValue value, {
    required String sides,
  }) {
    if (value is! TwLengthValue) return false;
    final data = _objectField(payload, field);
    switch (sides) {
      case 'all':
        data
          ..['left'] = value.value
          ..['top'] = value.value
          ..['right'] = value.value
          ..['bottom'] = value.value;
      case 'x':
        data
          ..['left'] = value.value
          ..['right'] = value.value;
      case 'y':
        data
          ..['top'] = value.value
          ..['bottom'] = value.value;
      default:
        data[sides] = value.value;
    }

    return true;
  }

  bool _setConstraintPayload(
    JsonMap payload,
    Object value, {
    bool width = false,
    bool height = false,
    bool minWidth = false,
    bool maxWidth = false,
    bool minHeight = false,
    bool maxHeight = false,
    bool fixed = false,
  }) {
    final length = value is TwLengthValue ? value : null;
    if (length == null || length.unit != TwUnit.px) return false;
    final constraints = _objectField(payload, 'constraints');
    if ((width || minWidth) && (fixed || minWidth)) {
      constraints['minWidth'] = length.value;
    }
    if ((width || maxWidth) && (fixed || maxWidth)) {
      constraints['maxWidth'] = length.value;
    }
    if ((height || minHeight) && (fixed || minHeight)) {
      constraints['minHeight'] = length.value;
    }
    if ((height || maxHeight) && (fixed || maxHeight)) {
      constraints['maxHeight'] = length.value;
    }

    return true;
  }

  bool _setRadiusPayload(
    JsonMap payload,
    TwValue value, {
    required String corners,
  }) {
    if (value is! TwLengthValue) return false;
    final radius = value.value;
    final borderRadius = _objectField(_decoration(payload), 'borderRadius');
    switch (corners) {
      case 'all':
        borderRadius
          ..['topLeft'] = radius
          ..['topRight'] = radius
          ..['bottomLeft'] = radius
          ..['bottomRight'] = radius;
      case 'top':
        borderRadius
          ..['topLeft'] = radius
          ..['topRight'] = radius;
      case 'bottom':
        borderRadius
          ..['bottomLeft'] = radius
          ..['bottomRight'] = radius;
      case 'left':
        borderRadius
          ..['topLeft'] = radius
          ..['bottomLeft'] = radius;
      case 'right':
        borderRadius
          ..['topRight'] = radius
          ..['bottomRight'] = radius;
      default:
        borderRadius[corners] = radius;
    }

    return true;
  }

  JsonMap _decoration(JsonMap payload) => _objectField(payload, 'decoration');

  JsonMap _textStyle(JsonMap payload) => _objectField(payload, 'style');

  JsonMap _defaultTextStyle(JsonMap payload) {
    final modifiers = _modifiers(payload);
    for (final modifier in modifiers) {
      if (modifier['type'] == 'default_text_style') {
        return _objectField(modifier, 'style');
      }
    }
    final modifier = <String, Object?>{
      'type': 'default_text_style',
      'style': <String, Object?>{},
    };
    modifiers.add(modifier);

    return modifier['style']! as JsonMap;
  }

  List<JsonMap> _modifiers(JsonMap payload) {
    return (payload['modifiers'] ??= <JsonMap>[]) as List<JsonMap>;
  }

  List<String> _textDirectives(JsonMap payload) {
    return (payload['textDirectives'] ??= <String>[]) as List<String>;
  }

  JsonMap _objectField(JsonMap payload, String field) {
    return (payload[field] ??= <String, Object?>{}) as JsonMap;
  }

  List<JsonMap>? _boxShadowPayload(TwValue value) {
    if (value is! TwEnumValue) return null;

    final shadowValue = value.value;
    if (shadowValue is! List<BoxShadowMix>?) return null;
    final shadows = shadowValue ?? const <BoxShadowMix>[];
    final payload = _encodePayload(
      BoxStyler().boxShadows(shadows),
      expectedType: SchemaStyler.box,
    );
    final decoration = payload['decoration'] as JsonMap?;
    final encoded = decoration?['boxShadow'] as List?;

    return encoded?.cast<JsonMap>() ?? const <JsonMap>[];
  }

  List<JsonMap>? _textShadowPayload(TwValue value) {
    final shadows = _resolveTextShadowMixes(value);
    if (shadows == null) return null;
    final payload = _encodePayload(
      TextStyler().shadows(shadows),
      expectedType: SchemaStyler.text,
    );
    final style = payload['style'] as JsonMap?;
    final encoded = style?['shadows'] as List?;

    return encoded?.cast<JsonMap>() ?? const <JsonMap>[];
  }

  TwLengthValue? _spacePayloadValue(String key) {
    final size = _config.spaceOf(key, fallback: double.nan);
    if (size.isNaN) return null;

    return TwLengthValue(size);
  }

  bool _isWidgetLayerSizingToken(String key) {
    return parseFractionToken(key) != null || _isFullOrScreenKey(key);
  }

  String? _payloadColor(Color color) {
    if (color.runtimeType != Color) return null;

    return payloadColor(color);
  }

  String _fontWeightWire(FontWeight value) {
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
      _ => throw SchemaPayloadUnsupported([
        MixSchemaError(
          code: MixSchemaErrorCode.unsupportedEncodeValue,
          path: '/style/fontWeight',
          message: 'Unsupported FontWeight value: $value.',
          value: value,
        ),
      ]),
    };
  }

  JsonMap _encodePayload(Object styler, {required SchemaStyler expectedType}) {
    final result = _schemaContract.encode(styler);

    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => throw SchemaPayloadUnsupported(
        errors,
      ),
    };
    if (payload['type'] != expectedType.wireValue) {
      throw SchemaPayloadUnsupported([
        MixSchemaError(
          code: MixSchemaErrorCode.typeMismatch,
          path: '/type',
          message:
              'Expected ${expectedType.wireValue} payload, got ${payload['type']}.',
          value: payload['type'],
        ),
      ]);
    }

    return payload;
  }

  String? _findTextSizeKey(String token) {
    if (token.startsWith('text-')) {
      return token.substring(5);
    }
    return null;
  }

  bool _isFullOrScreenKey(String key) => key == 'full' || key == 'screen';
}
