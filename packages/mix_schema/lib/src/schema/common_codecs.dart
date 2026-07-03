import 'dart:ui' show ColorSpace;

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../errors/schema_error_mapper.dart';
import 'primitive_wire.dart';

const String tokenReferenceKey = r'$token';
const String mergeReferenceKey = r'$merge';
const String applyDirectivesKey = 'apply';
const String directiveOpKey = 'op';
const String tokenKindKey = 'kind';
const String tokenKindSpace = 'space';
const String tokenKindDouble = 'double';
const String _tokenNamePatternSource = r'^[A-Za-z0-9_.-]{1,128}$';

final RegExp _tokenNamePattern = RegExp(_tokenNamePatternSource);

CodecSchema<num, double> numberAsDoubleCodec() {
  return Ack.number().codec<double>(
    decode: (value) => value.toDouble(),
    encode: (value) => value,
  );
}

CodecSchema<num, double> positiveDoubleCodec() {
  return Ack.number()
      .constrain(
        _PredicateConstraint<num>(
          constraintKey: 'mix_schema_positive_number',
          description: 'Number must be greater than zero.',
          isValidValue: (value) => value > 0,
          message: 'Value must be greater than zero.',
        ),
      )
      .codec<double>(
        decode: (value) => value.toDouble(),
        encode: (value) => value,
      );
}

CodecSchema<num, double> nonNegativeDoubleCodec() {
  return Ack.number()
      .min(0)
      .codec<double>(
        decode: (value) => value.toDouble(),
        encode: (value) => value,
      );
}

CodecSchema<num, double> unitDoubleCodec() {
  return Ack.number()
      .constrain(
        _PredicateConstraint<num>(
          constraintKey: 'mix_schema_unit_number',
          description: 'Number must be between 0 and 1 inclusive.',
          isValidValue: (value) => value >= 0 && value <= 1,
          message: 'Value must be between 0 and 1.',
        ),
      )
      .codec<double>(
        decode: (value) => value.toDouble(),
        encode: (value) => value,
      );
}

CodecSchema<Object, double> doubleTokenCodec() {
  return tokenizedCodec<double, double>(
    literal: numberAsDoubleCodec(),
    decodeToken: (data) {
      final name = data[tokenReferenceKey]! as String;
      final kind = data[tokenKindKey] as String? ?? tokenKindSpace;

      return switch (kind) {
        tokenKindDouble => DoubleToken(name),
        tokenKindSpace => SpaceToken(name),
        _ => throw UnsupportedEncodeValueError(
          kind,
          'Unknown double token kind "$kind".',
        ),
      };
    },
    reference: (token) => token(),
    allowDoubleKind: true,
  );
}

CodecSchema<Object, double> unitDoubleTokenCodec() {
  return tokenizedCodec<double, double>(
    literal: unitDoubleCodec(),
    decodeToken: (data) {
      final name = data[tokenReferenceKey]! as String;
      final kind = data[tokenKindKey] as String? ?? tokenKindSpace;

      return switch (kind) {
        tokenKindDouble => DoubleToken(name),
        tokenKindSpace => SpaceToken(name),
        _ => throw UnsupportedEncodeValueError(
          kind,
          'Unknown double token kind "$kind".',
        ),
      };
    },
    reference: (token) => token(),
    allowDoubleKind: true,
  );
}

CodecSchema<Object, double> nonNegativeDoubleTokenCodec() {
  return tokenizedCodec<double, double>(
    literal: nonNegativeDoubleCodec(),
    decodeToken: (data) {
      final name = data[tokenReferenceKey]! as String;
      final kind = data[tokenKindKey] as String? ?? tokenKindSpace;

      return switch (kind) {
        tokenKindDouble => DoubleToken(name),
        tokenKindSpace => SpaceToken(name),
        _ => throw UnsupportedEncodeValueError(
          kind,
          'Unknown double token kind "$kind".',
        ),
      };
    },
    reference: (token) => token(),
    allowDoubleKind: true,
  );
}

CodecSchema<Object, Color> colorCodec() {
  return tokenizedCodec<Color, Color>(
    literal: colorLiteralCodec(),
    decodeToken: (data) => ColorToken(data[tokenReferenceKey]! as String),
    reference: (token) => token(),
  );
}

CodecSchema<String, Color> colorLiteralCodec() {
  return Ack.codec<String, String, Color>(
    input: _colorWireCodec(),
    decode: _decodeColor,
    encode: encodeColorWire,
  );
}

CodecSchema<Object, Alignment> alignmentCodec() {
  return Ack.codec<Object, Object, Alignment>(
    input: Ack.anyOf([
      Ack.enumString(namedAlignments.keys.toList(growable: false)),
      Ack.object({'x': numberAsDoubleCodec(), 'y': numberAsDoubleCodec()}),
    ]),
    decode: _decodeAlignment,
    encode: encodeAlignmentWire,
  );
}

CodecSchema<JsonMap, Offset> offsetCodec() {
  return Ack.object({
    'x': numberAsDoubleCodec(),
    'y': numberAsDoubleCodec(),
  }).codec<Offset>(
    decode: (data) => Offset(data['x']! as double, data['y']! as double),
    encode: (value) => {'x': value.dx, 'y': value.dy},
  );
}

CodecSchema<JsonMap, Rect> rectCodec() {
  return Ack.object({
    'left': numberAsDoubleCodec(),
    'top': numberAsDoubleCodec(),
    'right': numberAsDoubleCodec(),
    'bottom': numberAsDoubleCodec(),
  }).codec<Rect>(
    decode: (data) => Rect.fromLTRB(
      data['left']! as double,
      data['top']! as double,
      data['right']! as double,
      data['bottom']! as double,
    ),
    encode: (value) => {
      'left': value.left,
      'top': value.top,
      'right': value.right,
      'bottom': value.bottom,
    },
  );
}

CodecSchema<JsonMap, Locale> localeCodec() {
  return Ack.object({
    'languageCode': Ack.string().notEmpty(),
    'scriptCode': Ack.string().notEmpty().optional(),
    'countryCode': Ack.string().notEmpty().optional(),
  }).codec<Locale>(
    decode: (data) => Locale.fromSubtags(
      languageCode: data['languageCode']! as String,
      scriptCode: data['scriptCode'] as String?,
      countryCode: data['countryCode'] as String?,
    ),
    encode: (value) => {
      'languageCode': value.languageCode,
      'scriptCode': value.scriptCode,
      'countryCode': value.countryCode,
    },
  );
}

CodecSchema<List<num>, Matrix4> matrix4Codec() {
  return Ack.list(numberAsDoubleCodec())
      .refine(
        (value) => value.length == 16,
        message: 'Matrix4 payloads must contain exactly 16 numbers.',
      )
      .codec<Matrix4>(
        decode: (value) => Matrix4.fromList(value),
        encode: (value) => value.storage.toList(growable: false),
      );
}

CodecSchema<Object, Radius> radiusCodec() {
  return tokenizedCodec<Radius, Radius>(
    literal: radiusLiteralCodec(),
    decodeToken: (data) => RadiusToken(data[tokenReferenceKey]! as String),
    reference: (token) => token(),
  );
}

CodecSchema<Object, Radius> radiusLiteralCodec() {
  return Ack.codec<Object, Object, Radius>(
    input: Ack.anyOf([
      nonNegativeDoubleCodec(),
      Ack.object({
        'x': nonNegativeDoubleCodec(),
        'y': nonNegativeDoubleCodec(),
      }),
    ]),
    decode: _decodeRadius,
    encode: _encodeRadius,
  );
}

CodecSchema<JsonMap, BorderSideMix> borderSideCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'width': nonNegativeDoubleTokenCodec().optional(),
    'style': enumCodec({
      'none': BorderStyle.none,
      'solid': BorderStyle.solid,
    }, debugName: 'BorderStyle').optional(),
    'strokeAlign': doubleTokenCodec().optional(),
  }).codec<BorderSideMix>(
    decode: (data) => BorderSideMix(
      color: data['color'] as Color?,
      width: data['width'] as double?,
      style: data['style'] as BorderStyle?,
      strokeAlign: data['strokeAlign'] as double?,
    ),
    encode: (value) => {
      'color': singleValuePropWire(value.$color, 'borderSide.color'),
      'width': singleValuePropWire(value.$width, 'borderSide.width'),
      'style': singleValueProp(value.$style, 'borderSide.style'),
      'strokeAlign': singleValuePropWire(
        value.$strokeAlign,
        'borderSide.strokeAlign',
      ),
    },
  );
}

CodecSchema<JsonMap, BorderMix> borderCodec() {
  return Ack.object({
    'top': _borderSideFieldCodec().optional(),
    'right': _borderSideFieldCodec().optional(),
    'bottom': _borderSideFieldCodec().optional(),
    'left': _borderSideFieldCodec().optional(),
  }).codec<BorderMix>(
    decode: (data) => BorderMix.create(
      top: _borderSideProp(data['top']),
      right: _borderSideProp(data['right']),
      bottom: _borderSideProp(data['bottom']),
      left: _borderSideProp(data['left']),
    ),
    encode: (value) => {
      'top': singleMixPropWire<BorderSideMix, BorderSide>(
        value.$top,
        'border.top',
      ),
      'right': singleMixPropWire<BorderSideMix, BorderSide>(
        value.$right,
        'border.right',
      ),
      'bottom': singleMixPropWire<BorderSideMix, BorderSide>(
        value.$bottom,
        'border.bottom',
      ),
      'left': singleMixPropWire<BorderSideMix, BorderSide>(
        value.$left,
        'border.left',
      ),
    },
  );
}

CodecSchema<Object, EdgeInsetsMix> edgeInsetsCodec() {
  return Ack.codec<Object, Object, EdgeInsetsMix>(
    input: Ack.anyOf([
      doubleTokenCodec(),
      Ack.object({
        'left': doubleTokenCodec().optional(),
        'top': doubleTokenCodec().optional(),
        'right': doubleTokenCodec().optional(),
        'bottom': doubleTokenCodec().optional(),
      }),
    ]),
    decode: _decodeEdgeInsetsMix,
    encode: _encodeEdgeInsetsMix,
  );
}

CodecSchema<JsonMap, BoxShadowMix> boxShadowCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': doubleTokenCodec().optional(),
    'spreadRadius': doubleTokenCodec().optional(),
  }).codec<BoxShadowMix>(
    decode: (data) => BoxShadowMix(
      color: data['color'] as Color?,
      offset: data['offset'] as Offset?,
      blurRadius: data['blurRadius'] as double?,
      spreadRadius: data['spreadRadius'] as double?,
    ),
    encode: (value) => {
      'color': singleValuePropWire(value.$color, 'boxShadow.color'),
      'offset': singleValueProp(value.$offset, 'boxShadow.offset'),
      'blurRadius': singleValuePropWire(
        value.$blurRadius,
        'boxShadow.blurRadius',
      ),
      'spreadRadius': singleValuePropWire(
        value.$spreadRadius,
        'boxShadow.spreadRadius',
      ),
    },
  );
}

CodecSchema<JsonMap, ShadowMix> shadowCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': doubleTokenCodec().optional(),
  }).codec<ShadowMix>(
    decode: (data) => ShadowMix(
      color: data['color'] as Color?,
      offset: data['offset'] as Offset?,
      blurRadius: data['blurRadius'] as double?,
    ),
    encode: (value) => {
      'color': singleValuePropWire(value.$color, 'shadow.color'),
      'offset': singleValueProp(value.$offset, 'shadow.offset'),
      'blurRadius': singleValuePropWire(value.$blurRadius, 'shadow.blurRadius'),
    },
  );
}

CodecSchema<Object, ShadowListMix> shadowListMixCodec() {
  final tokenWireSchema = tokenReferenceWireSchema();
  final tokenCodec = tokenReferenceCodec<List<Shadow>, ShadowListMix>(
    decodeToken: (data) => ShadowToken(data[tokenReferenceKey]! as String),
    reference: (token) => (token as ShadowToken).mix(),
  );

  return Ack.codec<Object, Object, ShadowListMix>(
    input: Ack.anyOf([Ack.list(shadowCodec()), tokenWireSchema]),
    decode: (value) => switch (value) {
      ShadowListMix() => value,
      List<ShadowMix>() => ShadowListMix(value),
      JsonMap() => tokenCodec.safeParse(value).getOrThrow()!,
      _ => throw UnsupportedEncodeValueError(
        value,
        'Shadow lists must be literal shadow arrays or ShadowToken references.',
      ),
    },
    encode: (value) {
      final token = tokenFromReference<List<Shadow>>(value);
      final tokenResult = tokenCodec.safeEncode(value);
      if (tokenResult.isOk) return tokenResult.getOrNull()!;
      if (token != null) throw tokenResult.getError();

      return value.items;
    },
  );
}

CodecSchema<Object, BoxShadowListMix> boxShadowListMixCodec() {
  final tokenWireSchema = tokenReferenceWireSchema();
  final tokenCodec = tokenReferenceCodec<List<BoxShadow>, BoxShadowListMix>(
    decodeToken: (data) => BoxShadowToken(data[tokenReferenceKey]! as String),
    reference: (token) => (token as BoxShadowToken).mix(),
  );

  return Ack.codec<Object, Object, BoxShadowListMix>(
    input: Ack.anyOf([Ack.list(boxShadowCodec()), tokenWireSchema]),
    decode: (value) => switch (value) {
      BoxShadowListMix() => value,
      List<BoxShadowMix>() => BoxShadowListMix(value),
      JsonMap() => tokenCodec.safeParse(value).getOrThrow()!,
      _ => throw UnsupportedEncodeValueError(
        value,
        'Box shadow lists must be literal shadow arrays or BoxShadowToken '
        'references.',
      ),
    },
    encode: (value) {
      final token = tokenFromReference<List<BoxShadow>>(value);
      final tokenResult = tokenCodec.safeEncode(value);
      if (tokenResult.isOk) return tokenResult.getOrNull()!;
      if (token != null) throw tokenResult.getError();

      return value.items;
    },
  );
}

CodecSchema<JsonMap, TextHeightBehaviorMix> textHeightBehaviorCodec() {
  return Ack.object({
    'applyHeightToFirstAscent': Ack.boolean().optional(),
    'applyHeightToLastDescent': Ack.boolean().optional(),
    'leadingDistribution': enumNameCodec(
      TextLeadingDistribution.values,
    ).optional(),
  }).codec<TextHeightBehaviorMix>(
    decode: (data) => TextHeightBehaviorMix(
      applyHeightToFirstAscent: data['applyHeightToFirstAscent'] as bool?,
      applyHeightToLastDescent: data['applyHeightToLastDescent'] as bool?,
      leadingDistribution:
          data['leadingDistribution'] as TextLeadingDistribution?,
    ),
    encode: (value) => {
      'applyHeightToFirstAscent': singleValueProp(
        value.$applyHeightToFirstAscent,
        'textHeightBehavior.applyHeightToFirstAscent',
      ),
      'applyHeightToLastDescent': singleValueProp(
        value.$applyHeightToLastDescent,
        'textHeightBehavior.applyHeightToLastDescent',
      ),
      'leadingDistribution': singleValueProp(
        value.$leadingDistribution,
        'textHeightBehavior.leadingDistribution',
      ),
    },
  );
}

CodecSchema<String, Directive<String>> textDirectiveCodec() {
  return enumCodec({
    'uppercase': const UppercaseStringDirective(),
    'lowercase': const LowercaseStringDirective(),
    'capitalize': const CapitalizeStringDirective(),
    'title_case': const TitleCaseStringDirective(),
    'sentence_case': const SentenceCaseStringDirective(),
  }, debugName: 'TextDirective');
}

CodecSchema<Object, Prop<Value>> valuePropCodec<Value extends Object>(
  AckSchema<Object, Value> valueCodec, {
  required String fieldName,
}) {
  return valueAsPropCodec<Value, Value>(valueCodec, fieldName: fieldName);
}

CodecSchema<Object, Prop<PropValue>> valueAsPropCodec<
  Value extends Object,
  PropValue extends Object
>(AckSchema<Object, Value> valueCodec, {required String fieldName}) {
  return _propTermCodec<Value, PropValue>(
    valueCodec,
    fieldName: fieldName,
    source: _PropSourceKind.value,
  );
}

CodecSchema<Object, Prop<PropValue>> mixPropCodec<
  Value extends Object,
  PropValue extends Object
>(AckSchema<Object, Value> valueCodec, {required String fieldName}) {
  return _propTermCodec<Value, PropValue>(
    valueCodec,
    fieldName: fieldName,
    source: _PropSourceKind.mix,
  );
}

CodecSchema<JsonMap, BoxConstraintsMix> boxConstraintsCodec() {
  return Ack.object({
        'minWidth': nonNegativeDoubleCodec().optional(),
        'maxWidth': _maxConstraintBoundWireSchema().optional(),
        'minHeight': nonNegativeDoubleCodec().optional(),
        'maxHeight': _maxConstraintBoundWireSchema().optional(),
      })
      .constrain(const _BoxConstraintsBoundsConstraint())
      .codec<BoxConstraintsMix>(
        decode: (data) => BoxConstraintsMix(
          minWidth: _readOptionalMinConstraintBound(data, 'minWidth'),
          maxWidth: _readOptionalMaxConstraintBound(data, 'maxWidth'),
          minHeight: _readOptionalMinConstraintBound(data, 'minHeight'),
          maxHeight: _readOptionalMaxConstraintBound(data, 'maxHeight'),
        ),
        encode: _encodeBoxConstraintsMix,
      );
}

CodecSchema<Object, BorderRadiusMix> borderRadiusCodec() {
  return Ack.codec<Object, Object, BorderRadiusMix>(
    input: Ack.anyOf([
      radiusCodec(),
      Ack.object({
        'topLeft': radiusCodec().optional(),
        'topRight': radiusCodec().optional(),
        'bottomLeft': radiusCodec().optional(),
        'bottomRight': radiusCodec().optional(),
      }),
    ]),
    decode: _decodeBorderRadiusMix,
    encode: _encodeBorderRadiusMix,
  );
}

CodecSchema<String, T> enumCodec<T extends Object>(
  Map<String, T> values, {
  String? debugName,
}) {
  return Ack.enumString(values.keys.toList(growable: false)).codec<T>(
    decode: (wire) => values[wire]!,
    encode: (value) {
      final wire = reverseWireLookup(values, value);
      if (wire == null) {
        throw UnsupportedEncodeValueError(
          value,
          'No ${debugName ?? 'enum'} wire value is registered for $value.',
        );
      }

      return wire;
    },
  );
}

CodecSchema<String, T> enumNameCodec<T extends Enum>(List<T> values) {
  return enumCodec({for (final value in values) value.name: value});
}

AckSchema<Object, Object> _maxConstraintBoundWireSchema() {
  return Ack.anyOf([nonNegativeDoubleCodec(), Ack.literal('infinity')]);
}

CodecSchema<String, TextDirection> textDirectionCodec() {
  return enumCodec({
    'ltr': TextDirection.ltr,
    'rtl': TextDirection.rtl,
  }, debugName: 'TextDirection');
}

void failIfPresent(Object? value, String fieldName) {
  if (value == null) return;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" is not representable by this schema.',
  );
}

Object? singleValuePropWire<T extends Object>(Prop<T>? prop, String fieldName) {
  return readPropWire<T, T>(prop, fieldName);
}

T? singleValueProp<T extends Object>(Prop<T>? prop, String fieldName) {
  return readProp<T, T>(prop, fieldName);
}

Object? singleMixPropWire<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  return readPropWire<T, V>(prop, fieldName);
}

T? singleMixProp<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  return readProp<T, V>(prop, fieldName);
}

Object? readPropWire<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  return encodePropTerm<T, V>(
    prop,
    fieldName: fieldName,
    valueCodec: null,
    tokenAware: true,
  );
}

Object? encodePropTerm<T extends Object, V extends Object>(
  Prop<V>? prop, {
  required String fieldName,
  AckSchema<Object, T>? valueCodec,
  bool tokenAware = false,
}) {
  if (prop == null) return null;
  if (prop.sources.isEmpty) {
    throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" has directives but no value sources.',
    );
  }

  final directives = prop.$directives;
  if (prop.sources.length == 1 && (directives == null || directives.isEmpty)) {
    return _encodePropSource<T, V>(
      prop.sources.single,
      fieldName: fieldName,
      valueCodec: valueCodec,
      tokenAware: tokenAware,
    );
  }

  final encodedSources = [
    for (final source in prop.sources)
      _encodePropSource<T, V>(
        source,
        fieldName: fieldName,
        valueCodec: valueCodec,
        tokenAware: tokenAware,
      ),
  ];

  if (prop.sources.length == 1 &&
      directives != null &&
      directives.isNotEmpty &&
      encodedSources.single is JsonMap &&
      (encodedSources.single as JsonMap).containsKey(tokenReferenceKey)) {
    return {
      ...(encodedSources.single as JsonMap),
      applyDirectivesKey: encodeDirectiveList(directives, fieldName),
    };
  }

  return {
    mergeReferenceKey: encodedSources,
    if (directives != null && directives.isNotEmpty)
      applyDirectivesKey: encodeDirectiveList(directives, fieldName),
  };
}

Object _encodePropSource<T extends Object, V extends Object>(
  PropSource<V> source, {
  required String fieldName,
  AckSchema<Object, T>? valueCodec,
  required bool tokenAware,
}) {
  Object value;
  if (source is TokenSource<V>) {
    if (!tokenAware) {
      throw UnsupportedEncodeValueError(
        source.token,
        'Field "$fieldName" references a token and cannot be represented.',
      );
    }
    value = _referenceForToken<T, V>(source.token, fieldName);
  } else if (source is MixSource<V> && source.mix is T) {
    value = source.mix as T;
  } else if (source is ValueSource<V> && source.value is T) {
    value = source.value as T;
  } else {
    throw UnsupportedEncodeValueError(
      source,
      'Field "$fieldName" is ${source.runtimeType}; expected $T.',
    );
  }

  if (valueCodec == null) return value;

  final result = valueCodec.safeEncode(value as T);
  if (result.isFail) throw result.getError();

  return result.getOrNull()!;
}

Object _referenceForToken<T extends Object, V extends Object>(
  MixToken<V> token,
  String fieldName,
) {
  encodeTokenReference(token, fieldName);

  if (T == TextStyleMix && token is TextStyleToken) {
    return (token as TextStyleToken).mix();
  }
  if (T == ShadowListMix && token is ShadowToken) {
    return (token as ShadowToken).mix();
  }
  if (T == BoxShadowListMix && token is BoxShadowToken) {
    return (token as BoxShadowToken).mix();
  }

  try {
    return token();
  } catch (error) {
    throw UnsupportedEncodeValueError(
      token,
      'Field "$fieldName" references token ${token.runtimeType}, which cannot '
      'be represented as a runtime token reference.',
    );
  }
}

T? readProp<T extends Object, V extends Object>(
  Prop<V>? prop,
  String fieldName,
) {
  if (prop == null) return null;
  if (prop.$directives?.isNotEmpty == true) {
    throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" has directives and cannot be represented.',
    );
  }
  if (prop.sources.length != 1) {
    throw UnsupportedEncodeValueError(
      prop,
      'Field "$fieldName" has ${prop.sources.length} sources; expected one.',
    );
  }

  final source = prop.sources.single;
  if (source is MixSource<V> && source.mix is T) {
    return source.mix as T;
  }
  if (source is ValueSource<V> && source.value is T) {
    return source.value as T;
  }

  throw UnsupportedEncodeValueError(
    prop,
    'Field "$fieldName" is ${source.runtimeType}; expected $T.',
  );
}

CodecSchema<Object, Prop<PropValue>>
_propTermCodec<Value extends Object, PropValue extends Object>(
  AckSchema<Object, Value> valueCodec, {
  required String fieldName,
  required _PropSourceKind source,
}) {
  return Ack.codec<Object, Object, Prop<PropValue>>(
    input: Ack.any(),
    decode: (wire) => _decodePropTerm<Value, PropValue>(
      wire,
      valueCodec: valueCodec,
      fieldName: fieldName,
      source: source,
    ),
    encode: (prop) => encodePropTerm<Value, PropValue>(
      prop,
      fieldName: fieldName,
      valueCodec: valueCodec,
      tokenAware: true,
    )!,
  );
}

Prop<PropValue> _decodePropTerm<Value extends Object, PropValue extends Object>(
  Object wire, {
  required AckSchema<Object, Value> valueCodec,
  required String fieldName,
  required _PropSourceKind source,
}) {
  final apply = wire is JsonMap ? wire[applyDirectivesKey] : null;
  if (wire is JsonMap && wire.containsKey(mergeReferenceKey)) {
    final sources = wire[mergeReferenceKey];
    if (sources is! List || sources.isEmpty) {
      throw UnsupportedEncodeValueError(
        wire,
        'Field "$fieldName" merge terms must be a non-empty list.',
      );
    }
    if (sources.length == 1 &&
        (apply == null || (apply is List && apply.isEmpty))) {
      throw SchemaPathError(
        code: MixSchemaErrorCode.constraintViolation,
        relativePath: '/$mergeReferenceKey',
        reason:
            'Field "$fieldName" merge terms must contain at least two '
            'sources unless directives are applied.',
        value: sources,
      );
    }

    final terms = <Prop<PropValue>>[];
    for (var i = 0; i < sources.length; i += 1) {
      terms.add(
        _decodeMergeTerm<Value, PropValue>(
          sources[i] as Object,
          index: i,
          valueCodec: valueCodec,
          fieldName: fieldName,
          source: source,
        ),
      );
    }

    final merged = terms.reduce((current, next) => current.mergeProp(next));

    return _withDecodedDirectives(merged, apply, fieldName);
  }

  final termWire = wire is JsonMap && wire.containsKey(applyDirectivesKey)
      ? {
          for (final entry in wire.entries)
            if (entry.key != applyDirectivesKey) entry.key: entry.value,
        }
      : wire;
  final result = valueCodec.safeParse(termWire);
  if (result.isFail) throw result.getError();

  final decoded = result.getOrNull()!;
  final prop = switch (source) {
    _PropSourceKind.value => Prop.value<PropValue>(decoded as PropValue),
    _PropSourceKind.mix =>
      decoded is Prop<PropValue>
          ? decoded
          : Prop.mix<PropValue>(decoded as Mix<PropValue>),
  };

  return _withDecodedDirectives(prop, apply, fieldName);
}

Prop<PropValue>
_decodeMergeTerm<Value extends Object, PropValue extends Object>(
  Object wire, {
  required int index,
  required AckSchema<Object, Value> valueCodec,
  required String fieldName,
  required _PropSourceKind source,
}) {
  try {
    return _decodePropTerm<Value, PropValue>(
      wire,
      valueCodec: valueCodec,
      fieldName: fieldName,
      source: source,
    );
  } on SchemaPathError catch (error) {
    throw SchemaPathError(
      code: error.code,
      relativePath: '/$mergeReferenceKey/$index${error.relativePath}',
      reason: error.reason,
      value: error.value,
    );
  } on SchemaError catch (error) {
    final mapped = mapSchemaError(error).first;

    throw SchemaPathError(
      code: mapped.code,
      relativePath: '/$mergeReferenceKey/$index${mapped.path}',
      reason: mapped.message,
      value: mapped.value,
    );
  }
}

Prop<PropValue> _withDecodedDirectives<PropValue extends Object>(
  Prop<PropValue> prop,
  Object? apply,
  String fieldName,
) {
  if (apply == null) return prop;
  if (apply is List && apply.isEmpty) {
    throw SchemaPathError(
      code: MixSchemaErrorCode.constraintViolation,
      relativePath: '/$applyDirectivesKey',
      reason: 'Field "$fieldName" apply must contain at least one directive.',
      value: apply,
    );
  }

  return prop.directives(decodeDirectiveList<PropValue>(apply, fieldName));
}

List<Directive<Value>> decodeDirectiveList<Value extends Object>(
  Object wire,
  String fieldName,
) {
  if (wire is! List) {
    throw UnsupportedEncodeValueError(
      wire,
      'Field "$fieldName" apply must be a list of directive objects.',
    );
  }

  return [
    for (var i = 0; i < wire.length; i += 1)
      _decodeDirective<Value>(wire[i], fieldName, i),
  ];
}

List<JsonMap> encodeDirectiveList<Value extends Object>(
  List<Directive<Value>> directives,
  String fieldName,
) {
  return [
    for (final directive in directives) _encodeDirective(directive, fieldName),
  ];
}

Directive<Value> _decodeDirective<Value extends Object>(
  Object? wire,
  String fieldName,
  int index,
) {
  if (wire is! JsonMap) {
    throw UnsupportedEncodeValueError(
      wire,
      'Field "$fieldName" apply entries must be directive objects.',
    );
  }

  final op = wire[directiveOpKey];
  if (op is! String) {
    throw UnsupportedEncodeValueError(
      wire,
      'Field "$fieldName" directive objects must include string "op".',
    );
  }

  final directive = switch (op) {
    'color_opacity' => _withDirectiveParams(
      wire,
      index,
      const {'opacity'},
      () => OpacityColorDirective(
        _requiredDoubleParam(wire, 'opacity', fieldName),
      ),
    ),
    'color_with_values' => _withDirectiveParams(
      wire,
      index,
      const {'alpha', 'red', 'green', 'blue', 'colorSpace'},
      () => WithValuesColorDirective(
        alpha: _optionalDoubleParam(wire, 'alpha', fieldName),
        red: _optionalDoubleParam(wire, 'red', fieldName),
        green: _optionalDoubleParam(wire, 'green', fieldName),
        blue: _optionalDoubleParam(wire, 'blue', fieldName),
        colorSpace: _optionalColorSpaceParam(wire, fieldName),
      ),
    ),
    'color_alpha' => _withDirectiveParams(
      wire,
      index,
      const {'alpha'},
      () => AlphaColorDirective(_requiredIntParam(wire, 'alpha', fieldName)),
    ),
    'color_darken' => _amountColorDirective(
      wire,
      fieldName,
      index,
      DarkenColorDirective.new,
    ),
    'color_lighten' => _amountColorDirective(
      wire,
      fieldName,
      index,
      LightenColorDirective.new,
    ),
    'color_saturate' => _amountColorDirective(
      wire,
      fieldName,
      index,
      SaturateColorDirective.new,
    ),
    'color_desaturate' => _amountColorDirective(
      wire,
      fieldName,
      index,
      DesaturateColorDirective.new,
    ),
    'color_tint' => _amountColorDirective(
      wire,
      fieldName,
      index,
      TintColorDirective.new,
    ),
    'color_shade' => _amountColorDirective(
      wire,
      fieldName,
      index,
      ShadeColorDirective.new,
    ),
    'color_brighten' => _amountColorDirective(
      wire,
      fieldName,
      index,
      BrightenColorDirective.new,
    ),
    'color_with_red' => _withDirectiveParams(
      wire,
      index,
      const {'red'},
      () => WithRedColorDirective(_requiredIntParam(wire, 'red', fieldName)),
    ),
    'color_with_green' => _withDirectiveParams(
      wire,
      index,
      const {'green'},
      () =>
          WithGreenColorDirective(_requiredIntParam(wire, 'green', fieldName)),
    ),
    'color_with_blue' => _withDirectiveParams(
      wire,
      index,
      const {'blue'},
      () => WithBlueColorDirective(_requiredIntParam(wire, 'blue', fieldName)),
    ),
    'uppercase' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const UppercaseStringDirective(),
    ),
    'lowercase' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const LowercaseStringDirective(),
    ),
    'capitalize' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const CapitalizeStringDirective(),
    ),
    'title_case' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const TitleCaseStringDirective(),
    ),
    'sentence_case' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const SentenceCaseStringDirective(),
    ),
    'number_multiply' => _withDirectiveParams(
      wire,
      index,
      const {'factor'},
      () =>
          MultiplyNumberDirective(_requiredNumParam(wire, 'factor', fieldName)),
    ),
    'number_add' => _withDirectiveParams(
      wire,
      index,
      const {'addend'},
      () => AddNumberDirective(_requiredNumParam(wire, 'addend', fieldName)),
    ),
    'number_subtract' => _withDirectiveParams(
      wire,
      index,
      const {'subtrahend'},
      () => SubtractNumberDirective(
        _requiredNumParam(wire, 'subtrahend', fieldName),
      ),
    ),
    'number_divide' => _withDirectiveParams(
      wire,
      index,
      const {'divisor'},
      () =>
          DivideNumberDirective(_requiredNumParam(wire, 'divisor', fieldName)),
    ),
    'number_clamp' => _withDirectiveParams(
      wire,
      index,
      const {'min', 'max'},
      () => ClampNumberDirective(
        _requiredNumParam(wire, 'min', fieldName),
        _requiredNumParam(wire, 'max', fieldName),
      ),
    ),
    'number_abs' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const AbsNumberDirective(),
    ),
    'number_round' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const RoundNumberDirective(),
    ),
    'number_floor' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const FloorNumberDirective(),
    ),
    'number_ceil' => _withDirectiveParams(
      wire,
      index,
      const {},
      () => const CeilNumberDirective(),
    ),
    _ => throw SchemaPathError(
      code: MixSchemaErrorCode.invalidEnum,
      relativePath: '/$applyDirectivesKey/$index/$directiveOpKey',
      reason: 'Unknown directive op "$op" for field "$fieldName".',
      value: op,
    ),
  };

  return _coerceDirective<Value>(directive, fieldName);
}

T _amountColorDirective<T>(
  JsonMap wire,
  String fieldName,
  int index,
  T Function(int amount) create,
) {
  return _withDirectiveParams(wire, index, const {
    'amount',
  }, () => create(_requiredIntParam(wire, 'amount', fieldName)));
}

T _withDirectiveParams<T>(
  JsonMap wire,
  int index,
  Set<String> allowedParams,
  T Function() create,
) {
  for (final key in wire.keys) {
    if (key == directiveOpKey || allowedParams.contains(key)) continue;

    throw SchemaPathError(
      code: MixSchemaErrorCode.unknownField,
      relativePath: '/$applyDirectivesKey/$index/$key',
      reason: 'Directive "${wire[directiveOpKey]}" does not allow "$key".',
      value: key,
    );
  }

  return create();
}

JsonMap _encodeDirective<Value extends Object>(
  Directive<Value> directive,
  String fieldName,
) {
  if (directive is _NumberDirectiveAdapter) {
    final adapter = directive as _NumberDirectiveAdapter;

    return _encodeNumberDirective(adapter.inner);
  }

  return switch (directive) {
    OpacityColorDirective(:final opacity) => {
      directiveOpKey: directive.key,
      'opacity': opacity,
    },
    WithValuesColorDirective(
      :final alpha,
      :final red,
      :final green,
      :final blue,
      :final colorSpace,
    ) =>
      {
        directiveOpKey: directive.key,
        'alpha': ?alpha,
        'red': ?red,
        'green': ?green,
        'blue': ?blue,
        if (colorSpace != null) 'colorSpace': colorSpace.name,
      },
    AlphaColorDirective(:final alpha) => {
      directiveOpKey: directive.key,
      'alpha': alpha,
    },
    DarkenColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    LightenColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    SaturateColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    DesaturateColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    TintColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    ShadeColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    BrightenColorDirective(:final amount) => {
      directiveOpKey: directive.key,
      'amount': amount,
    },
    WithRedColorDirective(:final red) => {
      directiveOpKey: directive.key,
      'red': red,
    },
    WithGreenColorDirective(:final green) => {
      directiveOpKey: directive.key,
      'green': green,
    },
    WithBlueColorDirective(:final blue) => {
      directiveOpKey: directive.key,
      'blue': blue,
    },
    UppercaseStringDirective() ||
    LowercaseStringDirective() ||
    CapitalizeStringDirective() ||
    TitleCaseStringDirective() ||
    SentenceCaseStringDirective() => {directiveOpKey: directive.key},
    NumberDirective() => _encodeNumberDirective(directive as NumberDirective),
    _ => throw UnsupportedEncodeValueError(
      directive,
      'Directive ${directive.runtimeType} is not representable for '
      'field "$fieldName".',
    ),
  };
}

Directive<Value> _coerceDirective<Value extends Object>(
  Object directive,
  String fieldName,
) {
  if (directive is NumberDirective) {
    if (_valueTypeIs<Value, double>()) {
      return _DoubleNumberDirective(directive) as Directive<Value>;
    }
    if (_valueTypeIs<Value, int>()) {
      return _IntNumberDirective(directive) as Directive<Value>;
    }
    if (_valueTypeIs<Value, num>()) return directive as Directive<Value>;

    throw UnsupportedEncodeValueError(
      directive,
      'Field "$fieldName" does not accept number directive '
      '${directive.key}.',
    );
  }
  if (directive is Directive<Value>) return directive;

  throw UnsupportedEncodeValueError(
    directive,
    'Directive ${directive.runtimeType} is not valid for field "$fieldName".',
  );
}

JsonMap _encodeNumberDirective(NumberDirective directive) {
  return switch (directive) {
    MultiplyNumberDirective(:final factor) => {
      directiveOpKey: directive.key,
      'factor': factor,
    },
    AddNumberDirective(:final addend) => {
      directiveOpKey: directive.key,
      'addend': addend,
    },
    SubtractNumberDirective(:final subtrahend) => {
      directiveOpKey: directive.key,
      'subtrahend': subtrahend,
    },
    DivideNumberDirective(:final divisor) => {
      directiveOpKey: directive.key,
      'divisor': divisor,
    },
    ClampNumberDirective(:final min, :final max) => {
      directiveOpKey: directive.key,
      'min': min,
      'max': max,
    },
    AbsNumberDirective() ||
    RoundNumberDirective() ||
    FloorNumberDirective() ||
    CeilNumberDirective() => {directiveOpKey: directive.key},
    _ => throw UnsupportedEncodeValueError(
      directive,
      'Number directive ${directive.runtimeType} is not representable.',
    ),
  };
}

bool _valueTypeIs<Value extends Object, Expected extends Object>() {
  return <Value>[] is List<Expected>;
}

abstract final class _NumberDirectiveAdapter<T extends num>
    extends Directive<T> {
  const _NumberDirectiveAdapter(this.inner);

  final NumberDirective inner;

  @override
  String get key => inner.key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _NumberDirectiveAdapter<T> && inner == other.inner;

  @override
  int get hashCode => Object.hash(T, inner);
}

final class _DoubleNumberDirective extends _NumberDirectiveAdapter<double> {
  const _DoubleNumberDirective(super.inner);

  @override
  double apply(double value) => inner.apply(value).toDouble();
}

final class _IntNumberDirective extends _NumberDirectiveAdapter<int> {
  const _IntNumberDirective(super.inner);

  @override
  int apply(int value) {
    final result = inner.apply(value);
    if (result is int) return result;
    if (result is double && result == result.roundToDouble()) {
      return result.toInt();
    }

    throw UnsupportedError(
      'Number directive $key resolved to non-integer value $result.',
    );
  }
}

double _requiredDoubleParam(JsonMap data, String key, String fieldName) {
  final value = _requiredNumParam(data, key, fieldName);

  return value.toDouble();
}

double? _optionalDoubleParam(JsonMap data, String key, String fieldName) {
  if (!data.containsKey(key)) return null;

  return _requiredDoubleParam(data, key, fieldName);
}

int _requiredIntParam(JsonMap data, String key, String fieldName) {
  final value = data[key];
  if (value is int) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" directive param "$key" must be an integer.',
  );
}

num _requiredNumParam(JsonMap data, String key, String fieldName) {
  final value = data[key];
  if (value is num && value.isFinite) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" directive param "$key" must be a finite number.',
  );
}

ColorSpace? _optionalColorSpaceParam(JsonMap data, String fieldName) {
  if (!data.containsKey('colorSpace')) return null;
  final value = data['colorSpace'];
  if (value is String) {
    for (final colorSpace in ColorSpace.values) {
      if (colorSpace.name == value) return colorSpace;
    }
  }

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" directive param "colorSpace" must be a ColorSpace '
    'enum name.',
  );
}

enum _PropSourceKind { value, mix }

JsonMap encodeTokenReference(MixToken<dynamic> token, String fieldName) {
  final name = switch (token) {
    ColorToken() when token.runtimeType == ColorToken => token.name,
    RadiusToken() when token.runtimeType == RadiusToken => token.name,
    SpaceToken() when token.runtimeType == SpaceToken => token.name,
    DoubleToken() when token.runtimeType == DoubleToken => token.name,
    BreakpointToken() when token.runtimeType == BreakpointToken => token.name,
    TextStyleToken() when token.runtimeType == TextStyleToken => token.name,
    BorderSideToken() when token.runtimeType == BorderSideToken => token.name,
    ShadowToken() when token.runtimeType == ShadowToken => token.name,
    BoxShadowToken() when token.runtimeType == BoxShadowToken => token.name,
    FontWeightToken() when token.runtimeType == FontWeightToken => token.name,
    DurationToken() when token.runtimeType == DurationToken => token.name,
    _ => throw UnsupportedEncodeValueError(
      token,
      'Field "$fieldName" references custom token ${token.runtimeType}; '
      'only canonical mix_schema token classes can be encoded.',
    ),
  };

  _assertValidTokenName(name, fieldName);

  return {
    tokenReferenceKey: name,
    if (token.runtimeType == SpaceToken) tokenKindKey: tokenKindSpace,
    if (token.runtimeType == DoubleToken) tokenKindKey: tokenKindDouble,
  };
}

AckSchema<String, String> tokenNameCodec() {
  return Ack.string()
      .matches(_tokenNamePatternSource)
      .constrain(const _TokenNameConstraint());
}

bool isValidTokenName(String name) => _tokenNamePattern.hasMatch(name);

void _assertValidTokenName(String name, String fieldName) {
  if (isValidTokenName(name)) return;

  throw InvalidTokenNameError(name, fieldName);
}

CodecSchema<JsonMap, Runtime>
tokenReferenceCodec<TokenValue extends Object, Runtime extends Object>({
  required MixToken<TokenValue> Function(JsonMap data) decodeToken,
  required Runtime Function(MixToken<TokenValue> token) reference,
  bool allowDoubleKind = false,
}) {
  return tokenReferenceWireSchema(
    allowDoubleKind: allowDoubleKind,
  ).codec<Runtime>(
    decode: (data) => reference(decodeToken(data)),
    encode: (value) {
      if (value is double) {
        final token = tokenFromReferenceValue<TokenValue>(value);
        if (token != null) {
          return encodeTokenReference(token, tokenReferenceKey);
        }
      }

      final token = tokenFromReference<TokenValue>(value);
      if (token == null) {
        throw UnsupportedEncodeValueError(
          value,
          'Value is not a token reference.',
        );
      }

      return encodeTokenReference(token, tokenReferenceKey);
    },
  );
}

AckSchema<JsonMap, JsonMap> tokenReferenceWireSchema({
  bool allowDoubleKind = false,
}) {
  return Ack.object({
    tokenReferenceKey: tokenNameCodec(),
    if (allowDoubleKind)
      tokenKindKey: Ack.enumString([
        tokenKindSpace,
        tokenKindDouble,
      ]).optional(),
  });
}

CodecSchema<Object, Runtime>
tokenizedCodec<TokenValue extends Object, Runtime extends Object>({
  required AckSchema<Object, Runtime> literal,
  required MixToken<TokenValue> Function(JsonMap data) decodeToken,
  required Runtime Function(MixToken<TokenValue> token) reference,
  bool allowDoubleKind = false,
}) {
  final tokenCodec = tokenReferenceCodec<TokenValue, Runtime>(
    decodeToken: decodeToken,
    reference: reference,
    allowDoubleKind: allowDoubleKind,
  );

  return Ack.codec<Object, Object, Runtime>(
    input: Ack.any(),
    decode: (value) {
      final schema = value is JsonMap && value.containsKey(tokenReferenceKey)
          ? tokenCodec
          : literal;
      final result = schema.safeParse(value);
      if (result.isFail) throw result.getError();

      return result.getOrNull()!;
    },
    encode: (value) {
      final token = tokenFromReferenceValue<TokenValue>(value);
      final tokenResult = tokenCodec.safeEncode(value);
      if (tokenResult.isOk) return tokenResult.getOrNull()!;
      if (token != null) throw tokenResult.getError();

      final literalResult = literal.safeEncode(value);
      if (literalResult.isFail) throw literalResult.getError();

      return literalResult.getOrNull()!;
    },
  );
}

MixToken<TokenValue>? tokenFromReference<TokenValue extends Object>(
  Object value,
) {
  if (value is! Prop<TokenValue>) return null;
  if (value.sources.length != 1) return null;

  final source = value.sources.single;
  if (source is TokenSource<TokenValue>) return source.token;

  return null;
}

AckSchema<Object, Object> _borderSideFieldCodec() {
  return Ack.anyOf([
    borderSideCodec(),
    tokenReferenceCodec<BorderSide, BorderSide>(
      decodeToken: (data) =>
          BorderSideToken(data[tokenReferenceKey]! as String),
      reference: (token) => token(),
    ),
  ]);
}

Prop<BorderSide>? _borderSideProp(Object? value) {
  return switch (value) {
    null => null,
    Prop<BorderSide>() => value,
    BorderSideMix() => Prop.mix(value),
    _ => throw UnsupportedEncodeValueError(
      value,
      'Border side payload decoded to unsupported ${value.runtimeType}.',
    ),
  };
}

AckSchema<String, String> _colorWireCodec() {
  return Ack.string()
      .matches(
        r'^(?:#[0-9A-Fa-f]{6}|#[0-9A-Fa-f]{8}|rgb\(\s*-?\d+\s*,\s*-?\d+\s*,\s*-?\d+\s*\)|rgba\(\s*-?\d+\s*,\s*-?\d+\s*,\s*-?\d+\s*,\s*-?(?:\d+(?:\.\d+)?|\.\d+)\s*\))$',
      )
      .constrain(
        _PredicateConstraint<String>(
          constraintKey: 'mix_schema_color_wire_range',
          description: 'Color wire values must use in-range CSS channels.',
          isValidValue: _isColorWireInRange,
          message:
              'RGB channels must be between 0 and 255; alpha must be between 0 and 1.',
        ),
      );
}

bool _isColorWireInRange(String value) {
  if (value.startsWith('#')) return true;
  final prefix = value.startsWith('rgb(')
      ? 'rgb('
      : value.startsWith('rgba(')
      ? 'rgba('
      : null;
  if (prefix == null) return false;

  final parts = value.substring(prefix.length, value.length - 1).split(',');
  final expectedCount = prefix == 'rgb(' ? 3 : 4;
  if (parts.length != expectedCount) return false;

  for (final part in parts.take(3)) {
    final channel = int.tryParse(part.trim());
    if (channel == null || channel < 0 || channel > 255) return false;
  }
  if (expectedCount == 3) return true;

  final alpha = double.tryParse(parts[3].trim());

  return alpha != null && alpha >= 0 && alpha <= 1;
}

Color _decodeColor(String value) {
  if (value.startsWith('#')) return _decodeHexColor(value);
  if (value.startsWith('rgb(')) return _decodeRgbColor(value);
  if (value.startsWith('rgba(')) return _decodeRgbaColor(value);

  throw FormatException('Unsupported color format: $value');
}

Color _decodeHexColor(String value) {
  final hex = value.substring(1);
  final argb = hex.length == 6 ? 'FF$hex' : hex;

  return Color(int.parse(argb, radix: 16));
}

Color _decodeRgbColor(String value) {
  final channels = _parseColorChannels(value, prefix: 'rgb(', count: 3);

  return Color.fromARGB(0xFF, channels[0], channels[1], channels[2]);
}

Color _decodeRgbaColor(String value) {
  final channels = _parseColorChannels(value, prefix: 'rgba(', count: 4);

  return Color.fromARGB(channels[3], channels[0], channels[1], channels[2]);
}

List<int> _parseColorChannels(
  String value, {
  required String prefix,
  required int count,
}) {
  final parts = value.substring(prefix.length, value.length - 1).split(',');
  if (parts.length != count) {
    throw FormatException('Expected $count color channels.');
  }

  final rgb = parts
      .take(3)
      .map((part) {
        final channel = int.parse(part.trim());
        if (channel < 0 || channel > 255) {
          throw FormatException('Color channel out of range: $channel');
        }

        return channel;
      })
      .toList(growable: false);

  if (count == 3) return rgb;

  final alpha = double.parse(parts[3].trim());
  if (alpha < 0 || alpha > 1) {
    throw FormatException('Alpha channel out of range: $alpha');
  }

  return [...rgb, (alpha * 255).round()];
}

Alignment _decodeAlignment(Object value) {
  if (value is String) return namedAlignments[value]!;

  final data = value as JsonMap;

  return Alignment(data['x']! as double, data['y']! as double);
}

Radius _decodeRadius(Object value) {
  if (value is num) return Radius.circular(value.toDouble());

  final data = value as JsonMap;

  return Radius.elliptical(data['x']! as double, data['y']! as double);
}

Object _encodeRadius(Radius value) {
  if (value.x == value.y) return value.x;

  return {'x': value.x, 'y': value.y};
}

EdgeInsetsMix _decodeEdgeInsetsMix(Object value) {
  if (value is num) return EdgeInsetsMix.all(value.toDouble());

  final data = value as JsonMap;

  return EdgeInsetsMix(
    left: data['left'] as double?,
    top: data['top'] as double?,
    right: data['right'] as double?,
    bottom: data['bottom'] as double?,
  );
}

Object _encodeEdgeInsetsMix(EdgeInsetsMix value) {
  final left = singleValuePropWire(value.$left, 'left') as double?;
  final top = singleValuePropWire(value.$top, 'top') as double?;
  final right = singleValuePropWire(value.$right, 'right') as double?;
  final bottom = singleValuePropWire(value.$bottom, 'bottom') as double?;

  return encodeEdgeInsetsWire(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

double? _readOptionalMinConstraintBound(JsonMap data, String key) {
  if (!data.containsKey(key)) return null;

  return data[key] as double;
}

double? _readOptionalMaxConstraintBound(JsonMap data, String key) {
  if (!data.containsKey(key)) return null;
  if (data[key] == 'infinity') return double.infinity;

  return data[key] as double;
}

JsonMap _encodeBoxConstraintsMix(BoxConstraintsMix value) {
  final minWidth = singleValueProp(value.$minWidth, 'minWidth');
  final maxWidth = singleValueProp(value.$maxWidth, 'maxWidth');
  final minHeight = singleValueProp(value.$minHeight, 'minHeight');
  final maxHeight = singleValueProp(value.$maxHeight, 'maxHeight');

  _assertEncodableConstraintBounds(minWidth, maxWidth, 'width');
  _assertEncodableConstraintBounds(minHeight, maxHeight, 'height');

  return {
    if (minWidth != null) 'minWidth': _encodeMinConstraintBound(minWidth),
    if (maxWidth != null) 'maxWidth': _encodeMaxConstraintBound(maxWidth),
    if (minHeight != null) 'minHeight': _encodeMinConstraintBound(minHeight),
    if (maxHeight != null) 'maxHeight': _encodeMaxConstraintBound(maxHeight),
  };
}

double _encodeMinConstraintBound(double value) {
  if (value == double.infinity) {
    throw UnsupportedEncodeValueError(
      value,
      'Minimum constraint bounds cannot be unbounded.',
    );
  }

  return value;
}

Object _encodeMaxConstraintBound(double value) {
  return value == double.infinity ? 'infinity' : value;
}

void _assertEncodableConstraintBounds(double? min, double? max, String axis) {
  if (min == null || max == null || max == double.infinity) return;
  if (min <= max) return;

  throw UnsupportedEncodeValueError({
    'min': min,
    'max': max,
  }, 'Minimum $axis constraint must be less than or equal to maximum $axis.');
}

BorderRadiusMix _decodeBorderRadiusMix(Object value) {
  if (value is Radius) return BorderRadiusMix.all(value);

  final data = value as JsonMap;

  return BorderRadiusMix(
    topLeft: data['topLeft'] as Radius?,
    topRight: data['topRight'] as Radius?,
    bottomLeft: data['bottomLeft'] as Radius?,
    bottomRight: data['bottomRight'] as Radius?,
  );
}

Object _encodeBorderRadiusMix(BorderRadiusMix value) {
  final topLeft = singleValuePropWire(value.$topLeft, 'topLeft');
  final topRight = singleValuePropWire(value.$topRight, 'topRight');
  final bottomLeft = singleValuePropWire(value.$bottomLeft, 'bottomLeft');
  final bottomRight = singleValuePropWire(value.$bottomRight, 'bottomRight');

  if (topLeft != null &&
      topLeft == topRight &&
      topRight == bottomLeft &&
      bottomLeft == bottomRight) {
    return topLeft;
  }

  return {
    'topLeft': topLeft,
    'topRight': topRight,
    'bottomLeft': bottomLeft,
    'bottomRight': bottomRight,
  };
}

final class _PredicateConstraint<T extends Object> extends Constraint<T>
    with Validator<T> {
  const _PredicateConstraint({
    required super.constraintKey,
    required super.description,
    required this.isValidValue,
    required this.message,
  });

  final bool Function(T value) isValidValue;
  final String message;

  @override
  bool isValid(T value) => isValidValue(value);

  @override
  String buildMessage(T value) => message;
}

final class _BoxConstraintsBoundsConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _BoxConstraintsBoundsConstraint()
    : super(
        constraintKey: 'mix_schema_box_constraints_bounds',
        description:
            'Box constraint minimum bounds must not exceed maximum bounds.',
      );

  @override
  bool isValid(JsonMap value) {
    return _isAxisValid(value, 'minWidth', 'maxWidth') &&
        _isAxisValid(value, 'minHeight', 'maxHeight');
  }

  @override
  String buildMessage(JsonMap value) {
    return 'Minimum box constraint bounds must be less than or equal to '
        'their maximum bounds.';
  }

  static bool _isAxisValid(JsonMap value, String minKey, String maxKey) {
    final min = value[minKey] as double?;
    final max = switch (value[maxKey]) {
      'infinity' => double.infinity,
      final double value => value,
      _ => null,
    };
    if (min == null || max == null) return true;

    return min <= max;
  }
}

final class _TokenNameConstraint extends Constraint<String>
    with Validator<String> {
  const _TokenNameConstraint()
    : super(
        constraintKey: 'mix_schema_token_name',
        description: 'Token names must match the mix_schema v1 token grammar.',
      );

  @override
  bool isValid(String value) => isValidTokenName(value);

  @override
  String buildMessage(String value) {
    return 'Token names must match [A-Za-z0-9_.-]{1,128}.';
  }
}
