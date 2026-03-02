import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contracts/decoded_styler.dart';
import '../contracts/mix_schema_error.dart';
import '../contracts/mix_schema_result.dart';
import '../contracts/styler_type.dart';
import '../registries/registry_bundle.dart';
import '../schemas/payload_schema.dart';
import 'curve_codec.dart';
import 'dto_codecs.dart';

final class MixSchemaCodec {
  const MixSchemaCodec();

  Map<String, Object?> exportEnvelopeSchema() {
    return exportEnvelopeSchemaDefinition();
  }

  Map<String, Object?> exportBoxPayloadSchema() {
    return exportBoxPayloadSchemaDefinition();
  }

  Map<String, Object?> exportTextPayloadSchema() {
    return exportTextPayloadSchemaDefinition();
  }

  Map<String, Object?> exportFlexPayloadSchema() {
    return exportFlexPayloadSchemaDefinition();
  }

  Map<String, Object?> exportIconPayloadSchema() {
    return exportIconPayloadSchemaDefinition();
  }

  Map<String, Object?> exportImagePayloadSchema() {
    return exportImagePayloadSchemaDefinition();
  }

  Map<String, Object?> exportStackPayloadSchema() {
    return exportStackPayloadSchemaDefinition();
  }

  Map<String, Object?> exportFlexBoxPayloadSchema() {
    return exportFlexBoxPayloadSchemaDefinition();
  }

  Map<String, Object?> exportStackBoxPayloadSchema() {
    return exportStackBoxPayloadSchemaDefinition();
  }

  Map<String, Object?> exportTextStyleSchema() {
    return exportTextStyleSchemaDefinition();
  }

  Map<String, Object?> exportStrutStyleSchema() {
    return exportStrutStyleSchemaDefinition();
  }

  Map<String, Object?> exportTextHeightBehaviorSchema() {
    return exportTextHeightBehaviorSchemaDefinition();
  }

  MixSchemaResult<DecodedStyler> decode(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];

    final envelopeValidation = payloadEnvelopeSchema.validate(
      payload,
      debugName: '',
    );
    if (envelopeValidation.isFail) {
      errors.addAll(_mapSchemaError(envelopeValidation.getError()));
    }

    final versionValue = payload['schemaVersion'];
    if (versionValue is int && versionValue != 1) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedSchemaVersion,
          path: 'schemaVersion',
          message:
              "Unsupported schemaVersion '$versionValue'; only '1' is supported in v1.",
          value: versionValue,
        ),
      );
    }

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final stylerTypeWire = payload['stylerType'] as String;
    final stylerType = stylerTypeFromWire(stylerTypeWire);

    if (stylerType == null) {
      return MixSchemaFailure([
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: 'stylerType',
          message: 'Invalid stylerType "$stylerTypeWire".',
          value: stylerTypeWire,
        ),
      ]);
    }

    switch (stylerType) {
      case StylerType.box:
        return _decodeBox(payload, registries: registries);
      case StylerType.text:
        return _decodeText(payload, registries: registries);
      case StylerType.flex:
        return _decodeFlex(payload, registries: registries);
      case StylerType.icon:
        return _decodeIcon(payload, registries: registries);
      case StylerType.image:
        return _decodeImage(payload, registries: registries);
      case StylerType.stack:
        return _decodeStack(payload, registries: registries);
      case StylerType.flexBox:
        return _decodeFlexBox(payload, registries: registries);
      case StylerType.stackBox:
        return _decodeStackBox(payload, registries: registries);
    }
  }

  MixSchemaResult<DecodedStyler> decodeBox(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    return _decodeBox(payload, registries: registries);
  }

  MixSchemaResult<Map<String, Object?>> encode(
    DecodedStyler decoded, {
    required FrozenRegistryBundle registries,
  }) {
    switch (decoded.stylerType) {
      case StylerType.box:
        final box = decoded.boxStyler;
        if (box == null) {
          return MixSchemaFailure([
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: 'styler',
              message:
                  'DecodedStyler with stylerType "box" must contain a BoxStyler instance.',
              value: decoded.styler.runtimeType.toString(),
            ),
          ]);
        }

        return encodeBox(box, registries: registries);
      case StylerType.text:
        final text = decoded.textStyler;
        if (text == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'TextStyler',
          );
        }
        return encodeText(text, registries: registries);
      case StylerType.flex:
        final flex = decoded.flexStyler;
        if (flex == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'FlexStyler',
          );
        }
        return encodeFlex(flex, registries: registries);
      case StylerType.icon:
        final icon = decoded.iconStyler;
        if (icon == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'IconStyler',
          );
        }
        return encodeIcon(icon, registries: registries);
      case StylerType.image:
        final image = decoded.imageStyler;
        if (image == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'ImageStyler',
          );
        }
        return encodeImage(image, registries: registries);
      case StylerType.stack:
        final stack = decoded.stackStyler;
        if (stack == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'StackStyler',
          );
        }
        return encodeStack(stack, registries: registries);
      case StylerType.flexBox:
        final flexBox = decoded.flexBoxStyler;
        if (flexBox == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'FlexBoxStyler',
          );
        }
        return encodeFlexBox(flexBox, registries: registries);
      case StylerType.stackBox:
        final stackBox = decoded.stackBoxStyler;
        if (stackBox == null) {
          return _missingStylerTypeError(
            decoded: decoded,
            expected: 'StackBoxStyler',
          );
        }
        return encodeStackBox(stackBox, registries: registries);
    }
  }

  MixSchemaFailure<Map<String, Object?>> _missingStylerTypeError({
    required DecodedStyler decoded,
    required String expected,
  }) {
    return MixSchemaFailure([
      MixSchemaError.fromCode(
        code: MixSchemaErrorCode.invalidValue,
        path: 'styler',
        message:
            'DecodedStyler with stylerType "${decoded.stylerType.wire}" must contain a $expected instance.',
        value: decoded.styler.runtimeType.toString(),
      ),
    ]);
  }

  MixSchemaResult<Map<String, Object?>> encodeBox(
    BoxStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    _encodeField<EdgeInsetsGeometry, EdgeInsetsGeometryMix>(
      prop: styler.$padding,
      key: 'padding',
      path: 'data.padding',
      data: data,
      errors: errors,
      extract: _extractEdgeInsetsGeometryMix,
      encode: DtoCodecs.encodeEdgeInsetsGeometry,
    );
    _encodeField<EdgeInsetsGeometry, EdgeInsetsGeometryMix>(
      prop: styler.$margin,
      key: 'margin',
      path: 'data.margin',
      data: data,
      errors: errors,
      extract: _extractEdgeInsetsGeometryMix,
      encode: DtoCodecs.encodeEdgeInsetsGeometry,
    );
    _encodeField<BoxConstraints, BoxConstraintsMix>(
      prop: styler.$constraints,
      key: 'constraints',
      path: 'data.constraints',
      data: data,
      errors: errors,
      extract: _extractBoxConstraintsMix,
      encode: DtoCodecs.encodeBoxConstraints,
    );
    _encodeField<Decoration, BoxDecorationMix>(
      prop: styler.$decoration,
      key: 'decoration',
      path: 'data.decoration',
      data: data,
      errors: errors,
      extract: _extractBoxDecorationMix,
      encode: DtoCodecs.encodeBoxDecoration,
    );
    _encodeField<Decoration, BoxDecorationMix>(
      prop: styler.$foregroundDecoration,
      key: 'foregroundDecoration',
      path: 'data.foregroundDecoration',
      data: data,
      errors: errors,
      extract: _extractBoxDecorationMix,
      encode: DtoCodecs.encodeBoxDecoration,
    );
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$alignment,
      key: 'alignment',
      path: 'data.alignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );
    _encodeField<Matrix4, Matrix4>(
      prop: styler.$transform,
      key: 'transform',
      path: 'data.transform',
      data: data,
      errors: errors,
      extract: _extractMatrix4,
      encode: DtoCodecs.encodeMatrix4,
    );
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$transformAlignment,
      key: 'transformAlignment',
      path: 'data.transformAlignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );

    _encodeClipBehaviorField(
      prop: styler.$clipBehavior,
      path: 'data.clipBehavior',
      data: data,
      errors: errors,
    );

    final animation = styler.$animation;
    if (animation != null) {
      switch (animation) {
        case CurveAnimationConfig curveAnimation:
          final animationMap = <String, Object?>{
            'durationMs': curveAnimation.duration.inMilliseconds,
          };

          final curveName = CurveCodec.encode(curveAnimation.curve);
          if (curveName == null) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: 'data.animation.curve',
                message:
                    'Unsupported Curve instance "${curveAnimation.curve.runtimeType}" in v1.',
                value: curveAnimation.curve.runtimeType.toString(),
              ),
            );
          } else {
            animationMap['curve'] = curveName;
          }

          if (curveAnimation.delay != Duration.zero) {
            animationMap['delayMs'] = curveAnimation.delay.inMilliseconds;
          }

          final onEnd = curveAnimation.onEnd;
          if (onEnd != null) {
            final callbackId = registries.animationOnEnd.idOf(onEnd);
            if (callbackId == null) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unknownRegistryId,
                  path: 'data.animation.onEnd',
                  message:
                      'Unknown registry ID for animation onEnd callback in scope "${RegistryScope.animationOnEnd}".',
                  value: onEnd.runtimeType.toString(),
                ),
              );
            } else {
              animationMap['onEnd'] = callbackId;
            }
          }

          if (errors
              .where((error) => error.path.startsWith('data.animation'))
              .isEmpty) {
            data['animation'] = animationMap;
          }
        case _:
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unsupportedMetadata,
              path: 'data.animation',
              message: 'Only CurveAnimationConfig is supported in v1.',
              value: animation.runtimeType.toString(),
            ),
          );
      }
    }

    final modifier = styler.$modifier;
    if (modifier != null) {
      final modifierMap = _encodeModifierConfig(
        modifier,
        path: 'data.modifier',
        registries: registries,
        errors: errors,
      );
      if (modifierMap != null) {
        data['modifier'] = modifierMap;
      }
    }

    _encodeVariantsField<BoxSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! BoxStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message: 'Only BoxStyler is supported in box variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<BoxStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeBox,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is BoxStyler Function(BuildContext),
      expectedContextBuilderType: 'BoxStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    return MixSchemaSuccess({
      'schemaVersion': 1,
      'stylerType': StylerType.box.wire,
      'data': data,
    });
  }

  MixSchemaResult<DecodedStyler> _decodeBox(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];

    final schemaValidation = boxPayloadSchema.validate(payload, debugName: '');
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;

    final alignmentData = data['alignment'] as Map<String, Object?>?;
    final alignment = _decodeFieldValue(
      wire: alignmentData,
      path: 'data.alignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );

    final transformData = data['transform'] as List<Object?>?;
    final transform = _decodeFieldValue(
      wire: transformData,
      path: 'data.transform',
      errors: errors,
      decode: DtoCodecs.decodeMatrix4,
    );

    final transformAlignmentData =
        data['transformAlignment'] as Map<String, Object?>?;
    final transformAlignment = _decodeFieldValue(
      wire: transformAlignmentData,
      path: 'data.transformAlignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );

    final paddingData = data['padding'] as Map<String, Object?>?;
    final padding = _decodeFieldValue(
      wire: paddingData,
      path: 'data.padding',
      errors: errors,
      decode: DtoCodecs.decodeEdgeInsetsGeometry,
    );

    final marginData = data['margin'] as Map<String, Object?>?;
    final margin = _decodeFieldValue(
      wire: marginData,
      path: 'data.margin',
      errors: errors,
      decode: DtoCodecs.decodeEdgeInsetsGeometry,
    );

    final constraintsData = data['constraints'] as Map<String, Object?>?;
    final constraints = _decodeFieldValue(
      wire: constraintsData,
      path: 'data.constraints',
      errors: errors,
      decode: DtoCodecs.decodeBoxConstraints,
    );

    final decorationData = data['decoration'] as Map<String, Object?>?;
    final decoration = _decodeFieldValue(
      wire: decorationData,
      path: 'data.decoration',
      errors: errors,
      decode: DtoCodecs.decodeBoxDecoration,
    );

    final foregroundDecorationData =
        data['foregroundDecoration'] as Map<String, Object?>?;
    final foregroundDecoration = _decodeFieldValue(
      wire: foregroundDecorationData,
      path: 'data.foregroundDecoration',
      errors: errors,
      decode: DtoCodecs.decodeBoxDecoration,
    );

    Clip? clipBehavior;
    final clipBehaviorWire = data['clipBehavior'];
    if (clipBehaviorWire is String) {
      clipBehavior = _findEnumByName(Clip.values, clipBehaviorWire);
      if (clipBehavior == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.clipBehavior',
            message: 'Invalid clipBehavior "$clipBehaviorWire".',
            value: clipBehaviorWire,
          ),
        );
      }
    }

    AnimationConfig? animation;
    final animationData = data['animation'];
    if (animationData is Map<String, Object?>) {
      final durationMs = animationData['durationMs'] as int;
      final curveWire = animationData['curve'] as String;
      final delayMs = animationData['delayMs'] as int?;
      final onEndId = animationData['onEnd'] as String?;

      final curve = CurveCodec.decode(curveWire);
      if (curve == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.animation.curve',
            message: 'Unsupported curve "$curveWire".',
            value: curveWire,
          ),
        );
      }

      VoidCallback? onEnd;
      if (onEndId != null) {
        final callback = registries.animationOnEnd.resolve(onEndId);
        if (callback == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unknownRegistryId,
              path: 'data.animation.onEnd',
              message:
                  'Unknown registry ID "$onEndId" in scope "${RegistryScope.animationOnEnd}".',
              value: onEndId,
            ),
          );
        } else {
          onEnd = callback;
        }
      }

      if (curve != null) {
        animation = AnimationConfig.curve(
          duration: Duration(milliseconds: durationMs),
          curve: curve,
          delay: Duration(milliseconds: delayMs ?? 0),
          onEnd: onEnd,
        );
      }
    }

    WidgetModifierConfig? modifier;
    final modifierData = data['modifier'] as Map<String, Object?>?;
    if (modifierData != null) {
      modifier = _decodeModifierConfig(
        modifierData,
        path: 'data.modifier',
        registries: registries,
        errors: errors,
      );
    }

    final variants = _decodeVariantsField<BoxSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<BoxStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.box,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.boxStyler,
              expectedType: 'BoxStyler',
            );
          },
      emptyStyle: () => BoxStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is BoxStyler Function(BuildContext),
      expectedContextBuilderType: 'BoxStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = BoxStyler(
      alignment: alignment,
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.box, styler: styler),
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeStack(
    StackStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = _encodeStackCoreData(styler, path: 'data', errors: errors);

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<StackSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! StackStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message:
                      'Only StackStyler is supported in stack variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<StackStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeStack,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is StackStyler Function(BuildContext),
      expectedContextBuilderType: 'StackStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.stack,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeFlex(
    FlexStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = _encodeFlexCoreData(styler, path: 'data', errors: errors);

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<FlexSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! FlexStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message:
                      'Only FlexStyler is supported in flex variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<FlexStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeFlex,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is FlexStyler Function(BuildContext),
      expectedContextBuilderType: 'FlexStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.flex,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeText(
    TextStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    _encodeField<TextOverflow, TextOverflow>(
      prop: styler.$overflow,
      key: 'overflow',
      path: 'data.overflow',
      data: data,
      errors: errors,
      extract: _extractTextOverflow,
      encode: (value) => value.name,
    );
    _encodeField<StrutStyle, StrutStyleMix>(
      prop: styler.$strutStyle,
      key: 'strutStyle',
      path: 'data.strutStyle',
      data: data,
      errors: errors,
      extract: _extractStrutStyleMix,
      encode: DtoCodecs.encodeStrutStyle,
    );
    _encodeField<TextAlign, TextAlign>(
      prop: styler.$textAlign,
      key: 'textAlign',
      path: 'data.textAlign',
      data: data,
      errors: errors,
      extract: _extractTextAlign,
      encode: (value) => value.name,
    );
    _encodeField<TextScaler, TextScaler>(
      prop: styler.$textScaler,
      key: 'textScaler',
      path: 'data.textScaler',
      data: data,
      errors: errors,
      extract: _extractTextScaler,
      encode: DtoCodecs.encodeTextScaler,
    );
    _encodeField<int, int>(
      prop: styler.$maxLines,
      key: 'maxLines',
      path: 'data.maxLines',
      data: data,
      errors: errors,
      extract: _extractInt,
      encode: (value) => value,
    );
    _encodeField<TextStyle, TextStyleMix>(
      prop: styler.$style,
      key: 'style',
      path: 'data.style',
      data: data,
      errors: errors,
      extract: _extractTextStyleMix,
      encode: DtoCodecs.encodeTextStyle,
    );
    _encodeField<TextWidthBasis, TextWidthBasis>(
      prop: styler.$textWidthBasis,
      key: 'textWidthBasis',
      path: 'data.textWidthBasis',
      data: data,
      errors: errors,
      extract: _extractTextWidthBasis,
      encode: (value) => value.name,
    );
    _encodeField<TextHeightBehavior, TextHeightBehaviorMix>(
      prop: styler.$textHeightBehavior,
      key: 'textHeightBehavior',
      path: 'data.textHeightBehavior',
      data: data,
      errors: errors,
      extract: _extractTextHeightBehaviorMix,
      encode: DtoCodecs.encodeTextHeightBehavior,
    );
    _encodeField<TextDirection, TextDirection>(
      prop: styler.$textDirection,
      key: 'textDirection',
      path: 'data.textDirection',
      data: data,
      errors: errors,
      extract: _extractTextDirection,
      encode: (value) => value.name,
    );
    _encodeField<bool, bool>(
      prop: styler.$softWrap,
      key: 'softWrap',
      path: 'data.softWrap',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );
    _encodeField<Color, Color>(
      prop: styler.$selectionColor,
      key: 'selectionColor',
      path: 'data.selectionColor',
      data: data,
      errors: errors,
      extract: _extractColor,
      encode: (value) => value.toARGB32(),
    );
    _encodeField<String, String>(
      prop: styler.$semanticsLabel,
      key: 'semanticsLabel',
      path: 'data.semanticsLabel',
      data: data,
      errors: errors,
      extract: _extractString,
      encode: (value) => value,
    );
    _encodeField<Locale, Locale>(
      prop: styler.$locale,
      key: 'locale',
      path: 'data.locale',
      data: data,
      errors: errors,
      extract: _extractLocale,
      encode: DtoCodecs.encodeLocale,
    );

    if (styler.$textDirectives != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.textDirectives',
          message: 'TextStyler.textDirectives is rejected in v1.',
          value: styler.$textDirectives,
        ),
      );
    }

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<TextSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! TextStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message:
                      'Only TextStyler is supported in text variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<TextStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeText,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is TextStyler Function(BuildContext),
      expectedContextBuilderType: 'TextStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.text,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeIcon(
    IconStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    _encodeField<Color, Color>(
      prop: styler.$color,
      key: 'color',
      path: 'data.color',
      data: data,
      errors: errors,
      extract: _extractColor,
      encode: (value) => value.toARGB32(),
    );
    _encodeField<double, double>(
      prop: styler.$size,
      key: 'size',
      path: 'data.size',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$weight,
      key: 'weight',
      path: 'data.weight',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$grade,
      key: 'grade',
      path: 'data.grade',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$opticalSize,
      key: 'opticalSize',
      path: 'data.opticalSize',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeShadowListField(
      prop: styler.$shadows,
      key: 'shadows',
      path: 'data.shadows',
      data: data,
      errors: errors,
    );
    _encodeField<TextDirection, TextDirection>(
      prop: styler.$textDirection,
      key: 'textDirection',
      path: 'data.textDirection',
      data: data,
      errors: errors,
      extract: _extractTextDirection,
      encode: (value) => value.name,
    );
    _encodeField<bool, bool>(
      prop: styler.$applyTextScaling,
      key: 'applyTextScaling',
      path: 'data.applyTextScaling',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$fill,
      key: 'fill',
      path: 'data.fill',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<String, String>(
      prop: styler.$semanticsLabel,
      key: 'semanticsLabel',
      path: 'data.semanticsLabel',
      data: data,
      errors: errors,
      extract: _extractString,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$opacity,
      key: 'opacity',
      path: 'data.opacity',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<BlendMode, BlendMode>(
      prop: styler.$blendMode,
      key: 'blendMode',
      path: 'data.blendMode',
      data: data,
      errors: errors,
      extract: _extractBlendMode,
      encode: (value) => value.name,
    );

    if (styler.$icon != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.icon',
          message: 'IconStyler.icon (IconData) is rejected in v1.',
          value: styler.$icon.runtimeType.toString(),
        ),
      );
    }

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<IconSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! IconStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message:
                      'Only IconStyler is supported in icon variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<IconStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeIcon,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is IconStyler Function(BuildContext),
      expectedContextBuilderType: 'IconStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.icon,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeImage(
    ImageStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    final imageProp = styler.$image;
    if (imageProp != null) {
      try {
        final imageProvider = _extractImageProvider(
          imageProp,
          fieldPath: 'data.image',
        );
        final imageId = registries.imageProvider.idOf(imageProvider);
        if (imageId == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unknownRegistryId,
              path: 'data.image',
              message:
                  'Unknown registry ID for image provider in scope "${RegistryScope.imageProvider}".',
              value: imageProvider.runtimeType.toString(),
            ),
          );
        } else {
          data['image'] = imageId;
        }
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.image',
            message: error.toString(),
          ),
        );
      }
    }

    _encodeField<double, double>(
      prop: styler.$width,
      key: 'width',
      path: 'data.width',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<double, double>(
      prop: styler.$height,
      key: 'height',
      path: 'data.height',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );
    _encodeField<Color, Color>(
      prop: styler.$color,
      key: 'color',
      path: 'data.color',
      data: data,
      errors: errors,
      extract: _extractColor,
      encode: (value) => value.toARGB32(),
    );
    _encodeField<ImageRepeat, ImageRepeat>(
      prop: styler.$repeat,
      key: 'repeat',
      path: 'data.repeat',
      data: data,
      errors: errors,
      extract: _extractImageRepeat,
      encode: (value) => value.name,
    );
    _encodeField<BoxFit, BoxFit>(
      prop: styler.$fit,
      key: 'fit',
      path: 'data.fit',
      data: data,
      errors: errors,
      extract: _extractBoxFit,
      encode: (value) => value.name,
    );
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$alignment,
      key: 'alignment',
      path: 'data.alignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );
    _encodeField<Rect, Rect>(
      prop: styler.$centerSlice,
      key: 'centerSlice',
      path: 'data.centerSlice',
      data: data,
      errors: errors,
      extract: _extractRect,
      encode: DtoCodecs.encodeRect,
    );
    _encodeField<FilterQuality, FilterQuality>(
      prop: styler.$filterQuality,
      key: 'filterQuality',
      path: 'data.filterQuality',
      data: data,
      errors: errors,
      extract: _extractFilterQuality,
      encode: (value) => value.name,
    );
    _encodeField<BlendMode, BlendMode>(
      prop: styler.$colorBlendMode,
      key: 'colorBlendMode',
      path: 'data.colorBlendMode',
      data: data,
      errors: errors,
      extract: _extractBlendMode,
      encode: (value) => value.name,
    );
    _encodeField<String, String>(
      prop: styler.$semanticLabel,
      key: 'semanticLabel',
      path: 'data.semanticLabel',
      data: data,
      errors: errors,
      extract: _extractString,
      encode: (value) => value,
    );
    _encodeField<bool, bool>(
      prop: styler.$excludeFromSemantics,
      key: 'excludeFromSemantics',
      path: 'data.excludeFromSemantics',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );
    _encodeField<bool, bool>(
      prop: styler.$gaplessPlayback,
      key: 'gaplessPlayback',
      path: 'data.gaplessPlayback',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );
    _encodeField<bool, bool>(
      prop: styler.$isAntiAlias,
      key: 'isAntiAlias',
      path: 'data.isAntiAlias',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );
    _encodeField<bool, bool>(
      prop: styler.$matchTextDirection,
      key: 'matchTextDirection',
      path: 'data.matchTextDirection',
      data: data,
      errors: errors,
      extract: _extractBool,
      encode: (value) => value,
    );

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<ImageSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle:
          (style, {required path, required registries, required errors}) {
            if (style is! ImageStyler) {
              errors.add(
                MixSchemaError.fromCode(
                  code: MixSchemaErrorCode.unsupportedMetadata,
                  path: path,
                  message:
                      'Only ImageStyler is supported in image variant styles.',
                  value: style.runtimeType.toString(),
                ),
              );
              return null;
            }

            return _encodeVariantStyleByType<ImageStyler>(
              style: style,
              path: path,
              registries: registries,
              errors: errors,
              encodeStyle: encodeImage,
            );
          },
      isExpectedContextBuilderFn: (value) =>
          value is ImageStyler Function(BuildContext),
      expectedContextBuilderType: 'ImageStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.image,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeFlexBox(
    FlexBoxStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    if (styler.$box case final boxProp?) {
      final boxStyle = _extractNestedBoxStyler(
        boxProp,
        fieldPath: 'data.box',
        errors: errors,
      );
      if (boxStyle != null) {
        _rejectNestedMetadata(
          style: boxStyle,
          path: 'data.box',
          errors: errors,
        );
        data['box'] = _encodeBoxCoreData(
          boxStyle,
          path: 'data.box',
          errors: errors,
        );
      }
    }

    if (styler.$flex case final flexProp?) {
      final flexStyle = _extractNestedFlexStyler(
        flexProp,
        fieldPath: 'data.flex',
        errors: errors,
      );
      if (flexStyle != null) {
        _rejectNestedMetadata(
          style: flexStyle,
          path: 'data.flex',
          errors: errors,
        );
        data['flex'] = _encodeFlexCoreData(
          flexStyle,
          path: 'data.flex',
          errors: errors,
        );
      }
    }

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<FlexBoxSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle: (style, {required path, required registries, required errors}) {
        if (style is! FlexBoxStyler) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unsupportedMetadata,
              path: path,
              message:
                  'Only FlexBoxStyler is supported in flexBox variant styles.',
              value: style.runtimeType.toString(),
            ),
          );
          return null;
        }

        return _encodeVariantStyleByType<FlexBoxStyler>(
          style: style,
          path: path,
          registries: registries,
          errors: errors,
          encodeStyle: encodeFlexBox,
        );
      },
      isExpectedContextBuilderFn: (value) =>
          value is FlexBoxStyler Function(BuildContext),
      expectedContextBuilderType: 'FlexBoxStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.flexBox,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<Map<String, Object?>> encodeStackBox(
    StackBoxStyler styler, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final data = <String, Object?>{};

    if (styler.$box case final boxProp?) {
      final boxStyle = _extractNestedBoxStyler(
        boxProp,
        fieldPath: 'data.box',
        errors: errors,
      );
      if (boxStyle != null) {
        _rejectNestedMetadata(
          style: boxStyle,
          path: 'data.box',
          errors: errors,
        );
        data['box'] = _encodeBoxCoreData(
          boxStyle,
          path: 'data.box',
          errors: errors,
        );
      }
    }

    if (styler.$stack case final stackProp?) {
      final stackStyle = _extractNestedStackStyler(
        stackProp,
        fieldPath: 'data.stack',
        errors: errors,
      );
      if (stackStyle != null) {
        _rejectNestedMetadata(
          style: stackStyle,
          path: 'data.stack',
          errors: errors,
        );
        data['stack'] = _encodeStackCoreData(
          stackStyle,
          path: 'data.stack',
          errors: errors,
        );
      }
    }

    _encodeAnimationField(
      animation: styler.$animation,
      path: 'data.animation',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeModifierField(
      modifier: styler.$modifier,
      path: 'data.modifier',
      data: data,
      registries: registries,
      errors: errors,
    );
    _encodeVariantsField<StackBoxSpec>(
      variants: styler.$variants,
      path: 'data.variants',
      data: data,
      registries: registries,
      errors: errors,
      encodeStyle: (style, {required path, required registries, required errors}) {
        if (style is! StackBoxStyler) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unsupportedMetadata,
              path: path,
              message:
                  'Only StackBoxStyler is supported in stackBox variant styles.',
              value: style.runtimeType.toString(),
            ),
          );
          return null;
        }

        return _encodeVariantStyleByType<StackBoxStyler>(
          style: style,
          path: path,
          registries: registries,
          errors: errors,
          encodeStyle: encodeStackBox,
        );
      },
      isExpectedContextBuilderFn: (value) =>
          value is StackBoxStyler Function(BuildContext),
      expectedContextBuilderType: 'StackBoxStyler Function(BuildContext)',
    );

    return _finalizeEncodedPayload(
      stylerType: StylerType.stackBox,
      data: data,
      errors: errors,
    );
  }

  MixSchemaResult<DecodedStyler> _decodeStack(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = stackPayloadSchema.validate(
      payload,
      debugName: '',
    );
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;
    final core = _decodeStackCoreStyler(data, path: 'data', errors: errors);
    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<StackSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<StackStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.stack,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.stackStyler,
              expectedType: 'StackStyler',
            );
          },
      emptyStyle: () => StackStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is StackStyler Function(BuildContext),
      expectedContextBuilderType: 'StackStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = StackStyler.create(
      alignment: core.$alignment,
      fit: core.$fit,
      textDirection: core.$textDirection,
      clipBehavior: core.$clipBehavior,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.stack, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeFlex(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = flexPayloadSchema.validate(payload, debugName: '');
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;
    final core = _decodeFlexCoreStyler(data, path: 'data', errors: errors);
    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<FlexSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<FlexStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.flex,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.flexStyler,
              expectedType: 'FlexStyler',
            );
          },
      emptyStyle: () => FlexStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is FlexStyler Function(BuildContext),
      expectedContextBuilderType: 'FlexStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = FlexStyler.create(
      direction: core.$direction,
      mainAxisAlignment: core.$mainAxisAlignment,
      crossAxisAlignment: core.$crossAxisAlignment,
      mainAxisSize: core.$mainAxisSize,
      verticalDirection: core.$verticalDirection,
      textDirection: core.$textDirection,
      textBaseline: core.$textBaseline,
      clipBehavior: core.$clipBehavior,
      spacing: core.$spacing,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.flex, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeText(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = textPayloadSchema.validate(payload, debugName: '');
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;

    final overflow = _decodeEnumField<TextOverflow>(
      wire: data['overflow'],
      values: TextOverflow.values,
      path: 'data.overflow',
      label: 'TextOverflow',
      errors: errors,
    );
    final strutStyle = _decodeFieldValue(
      wire: data['strutStyle'] as Map<String, Object?>?,
      path: 'data.strutStyle',
      errors: errors,
      decode: DtoCodecs.decodeStrutStyle,
    );
    final textAlign = _decodeEnumField<TextAlign>(
      wire: data['textAlign'],
      values: TextAlign.values,
      path: 'data.textAlign',
      label: 'TextAlign',
      errors: errors,
    );
    final textScaler = _decodeFieldValue(
      wire: data['textScaler'] as Map<String, Object?>?,
      path: 'data.textScaler',
      errors: errors,
      decode: DtoCodecs.decodeTextScaler,
    );
    final maxLines = data['maxLines'] as int?;
    final style = _decodeFieldValue(
      wire: data['style'] as Map<String, Object?>?,
      path: 'data.style',
      errors: errors,
      decode: DtoCodecs.decodeTextStyle,
    );
    final textWidthBasis = _decodeEnumField<TextWidthBasis>(
      wire: data['textWidthBasis'],
      values: TextWidthBasis.values,
      path: 'data.textWidthBasis',
      label: 'TextWidthBasis',
      errors: errors,
    );
    final textHeightBehavior = _decodeFieldValue(
      wire: data['textHeightBehavior'] as Map<String, Object?>?,
      path: 'data.textHeightBehavior',
      errors: errors,
      decode: DtoCodecs.decodeTextHeightBehavior,
    );
    final textDirection = _decodeEnumField<TextDirection>(
      wire: data['textDirection'],
      values: TextDirection.values,
      path: 'data.textDirection',
      label: 'TextDirection',
      errors: errors,
    );
    final softWrap = data['softWrap'] as bool?;
    final selectionColorInt = data['selectionColor'] as int?;
    final semanticsLabel = data['semanticsLabel'] as String?;
    final locale = _decodeFieldValue(
      wire: data['locale'] as Map<String, Object?>?,
      path: 'data.locale',
      errors: errors,
      decode: DtoCodecs.decodeLocale,
    );

    if (data['textDirectives'] != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.textDirectives',
          message: 'TextStyler.textDirectives is rejected in v1.',
          value: data['textDirectives'],
        ),
      );
    }

    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<TextSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<TextStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.text,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.textStyler,
              expectedType: 'TextStyler',
            );
          },
      emptyStyle: () => TextStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is TextStyler Function(BuildContext),
      expectedContextBuilderType: 'TextStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = TextStyler(
      overflow: overflow,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textScaler: textScaler,
      maxLines: maxLines,
      style: style,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      textDirection: textDirection,
      softWrap: softWrap,
      selectionColor: selectionColorInt == null
          ? null
          : Color(selectionColorInt),
      semanticsLabel: semanticsLabel,
      locale: locale,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.text, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeIcon(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = iconPayloadSchema.validate(payload, debugName: '');
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;

    final colorInt = data['color'] as int?;
    final size = (data['size'] as num?)?.toDouble();
    final weight = (data['weight'] as num?)?.toDouble();
    final grade = (data['grade'] as num?)?.toDouble();
    final opticalSize = (data['opticalSize'] as num?)?.toDouble();
    final shadowsData = data['shadows'] as List<Object?>?;
    final shadows = shadowsData == null
        ? null
        : [
            for (final item in shadowsData)
              if (item is Map<String, Object?>)
                ShadowMix.value(DtoCodecs.decodeShadow(item)),
          ];
    final textDirection = _decodeEnumField<TextDirection>(
      wire: data['textDirection'],
      values: TextDirection.values,
      path: 'data.textDirection',
      label: 'TextDirection',
      errors: errors,
    );
    final applyTextScaling = data['applyTextScaling'] as bool?;
    final fill = (data['fill'] as num?)?.toDouble();
    final semanticsLabel = data['semanticsLabel'] as String?;
    final opacity = (data['opacity'] as num?)?.toDouble();
    final blendMode = _decodeEnumField<BlendMode>(
      wire: data['blendMode'],
      values: BlendMode.values,
      path: 'data.blendMode',
      label: 'BlendMode',
      errors: errors,
    );

    if (data['icon'] != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.icon',
          message: 'IconStyler.icon (IconData) is rejected in v1.',
          value: data['icon'],
        ),
      );
    }

    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<IconSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<IconStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.icon,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.iconStyler,
              expectedType: 'IconStyler',
            );
          },
      emptyStyle: () => IconStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is IconStyler Function(BuildContext),
      expectedContextBuilderType: 'IconStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = IconStyler(
      color: colorInt == null ? null : Color(colorInt),
      size: size,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: fill,
      semanticsLabel: semanticsLabel,
      opacity: opacity,
      blendMode: blendMode,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.icon, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeImage(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = imagePayloadSchema.validate(
      payload,
      debugName: '',
    );
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;
    ImageProvider<Object>? image;
    final imageId = data['image'] as String?;
    if (imageId != null) {
      final resolved = registries.imageProvider.resolve(imageId);
      if (resolved == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unknownRegistryId,
            path: 'data.image',
            message:
                'Unknown registry ID "$imageId" in scope "${RegistryScope.imageProvider}".',
            value: imageId,
          ),
        );
      } else {
        image = resolved;
      }
    }

    final width = (data['width'] as num?)?.toDouble();
    final height = (data['height'] as num?)?.toDouble();
    final colorInt = data['color'] as int?;
    final repeat = _decodeEnumField<ImageRepeat>(
      wire: data['repeat'],
      values: ImageRepeat.values,
      path: 'data.repeat',
      label: 'ImageRepeat',
      errors: errors,
    );
    final fit = _decodeEnumField<BoxFit>(
      wire: data['fit'],
      values: BoxFit.values,
      path: 'data.fit',
      label: 'BoxFit',
      errors: errors,
    );
    final alignment = _decodeFieldValue(
      wire: data['alignment'] as Map<String, Object?>?,
      path: 'data.alignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );
    final centerSlice = _decodeFieldValue(
      wire: data['centerSlice'] as Map<String, Object?>?,
      path: 'data.centerSlice',
      errors: errors,
      decode: DtoCodecs.decodeRect,
    );
    final filterQuality = _decodeEnumField<FilterQuality>(
      wire: data['filterQuality'],
      values: FilterQuality.values,
      path: 'data.filterQuality',
      label: 'FilterQuality',
      errors: errors,
    );
    final colorBlendMode = _decodeEnumField<BlendMode>(
      wire: data['colorBlendMode'],
      values: BlendMode.values,
      path: 'data.colorBlendMode',
      label: 'BlendMode',
      errors: errors,
    );
    final semanticLabel = data['semanticLabel'] as String?;
    final excludeFromSemantics = data['excludeFromSemantics'] as bool?;
    final gaplessPlayback = data['gaplessPlayback'] as bool?;
    final isAntiAlias = data['isAntiAlias'] as bool?;
    final matchTextDirection = data['matchTextDirection'] as bool?;

    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<ImageSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<ImageStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.image,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.imageStyler,
              expectedType: 'ImageStyler',
            );
          },
      emptyStyle: () => ImageStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is ImageStyler Function(BuildContext),
      expectedContextBuilderType: 'ImageStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = ImageStyler(
      image: image,
      width: width,
      height: height,
      color: colorInt == null ? null : Color(colorInt),
      repeat: repeat,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      matchTextDirection: matchTextDirection,
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.image, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeFlexBox(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = flexBoxPayloadSchema.validate(
      payload,
      debugName: '',
    );
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;
    final boxData = data['box'] as Map<String, Object?>?;
    final flexData = data['flex'] as Map<String, Object?>?;
    final box = boxData == null
        ? null
        : _decodeBoxCoreStyler(boxData, path: 'data.box', errors: errors);
    final flex = flexData == null
        ? null
        : _decodeFlexCoreStyler(flexData, path: 'data.flex', errors: errors);

    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<FlexBoxSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<FlexBoxStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.flexBox,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.flexBoxStyler,
              expectedType: 'FlexBoxStyler',
            );
          },
      emptyStyle: () => FlexBoxStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is FlexBoxStyler Function(BuildContext),
      expectedContextBuilderType: 'FlexBoxStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = FlexBoxStyler.create(
      box: box == null ? null : Prop.maybeMix(box),
      flex: flex == null ? null : Prop.maybeMix(flex),
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.flexBox, styler: styler),
    );
  }

  MixSchemaResult<DecodedStyler> _decodeStackBox(
    Map<String, Object?> payload, {
    required FrozenRegistryBundle registries,
  }) {
    final errors = <MixSchemaError>[];
    final schemaValidation = stackBoxPayloadSchema.validate(
      payload,
      debugName: '',
    );
    if (schemaValidation.isFail) {
      errors.addAll(_mapSchemaError(schemaValidation.getError()));
    }
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final data = payload['data'] as Map<String, Object?>;
    final boxData = data['box'] as Map<String, Object?>?;
    final stackData = data['stack'] as Map<String, Object?>?;
    final box = boxData == null
        ? null
        : _decodeBoxCoreStyler(boxData, path: 'data.box', errors: errors);
    final stack = stackData == null
        ? null
        : _decodeStackCoreStyler(stackData, path: 'data.stack', errors: errors);

    final animation = _decodeAnimationConfig(
      data['animation'],
      path: 'data.animation',
      registries: registries,
      errors: errors,
    );
    final modifier = _decodeModifierField(
      data: data,
      path: 'data.modifier',
      registries: registries,
      errors: errors,
    );
    final variants = _decodeVariantsField<StackBoxSpec>(
      data: data,
      path: 'data.variants',
      registries: registries,
      errors: errors,
      decodeStyle:
          (styleData, {required path, required registries, required errors}) {
            return _decodeVariantStyleByType<StackBoxStyler>(
              styleData: styleData,
              path: path,
              stylerType: StylerType.stackBox,
              registries: registries,
              errors: errors,
              pick: (decoded) => decoded.stackBoxStyler,
              expectedType: 'StackBoxStyler',
            );
          },
      emptyStyle: () => StackBoxStyler(),
      isExpectedContextBuilderFn: (value) =>
          value is StackBoxStyler Function(BuildContext),
      expectedContextBuilderType: 'StackBoxStyler Function(BuildContext)',
    );

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = StackBoxStyler.create(
      box: box == null ? null : Prop.maybeMix(box),
      stack: stack == null ? null : Prop.maybeMix(stack),
      animation: animation,
      modifier: modifier,
      variants: variants,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.stackBox, styler: styler),
    );
  }

  BoxStyler _decodeBoxCoreStyler(
    Map<String, Object?> data, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final alignment = _decodeFieldValue(
      wire: data['alignment'] as Map<String, Object?>?,
      path: '$path.alignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );
    final transform = _decodeFieldValue(
      wire: data['transform'] as List<Object?>?,
      path: '$path.transform',
      errors: errors,
      decode: DtoCodecs.decodeMatrix4,
    );
    final transformAlignment = _decodeFieldValue(
      wire: data['transformAlignment'] as Map<String, Object?>?,
      path: '$path.transformAlignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );
    final padding = _decodeFieldValue(
      wire: data['padding'] as Map<String, Object?>?,
      path: '$path.padding',
      errors: errors,
      decode: DtoCodecs.decodeEdgeInsetsGeometry,
    );
    final margin = _decodeFieldValue(
      wire: data['margin'] as Map<String, Object?>?,
      path: '$path.margin',
      errors: errors,
      decode: DtoCodecs.decodeEdgeInsetsGeometry,
    );
    final constraints = _decodeFieldValue(
      wire: data['constraints'] as Map<String, Object?>?,
      path: '$path.constraints',
      errors: errors,
      decode: DtoCodecs.decodeBoxConstraints,
    );
    final decoration = _decodeFieldValue(
      wire: data['decoration'] as Map<String, Object?>?,
      path: '$path.decoration',
      errors: errors,
      decode: DtoCodecs.decodeBoxDecoration,
    );
    final foregroundDecoration = _decodeFieldValue(
      wire: data['foregroundDecoration'] as Map<String, Object?>?,
      path: '$path.foregroundDecoration',
      errors: errors,
      decode: DtoCodecs.decodeBoxDecoration,
    );
    final clipBehavior = _decodeEnumField<Clip>(
      wire: data['clipBehavior'],
      values: Clip.values,
      path: '$path.clipBehavior',
      label: 'clipBehavior',
      errors: errors,
    );

    return BoxStyler(
      alignment: alignment,
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
    );
  }

  FlexStyler _decodeFlexCoreStyler(
    Map<String, Object?> data, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final direction = _decodeEnumField<Axis>(
      wire: data['direction'],
      values: Axis.values,
      path: '$path.direction',
      label: 'Axis',
      errors: errors,
    );
    final mainAxisAlignment = _decodeEnumField<MainAxisAlignment>(
      wire: data['mainAxisAlignment'],
      values: MainAxisAlignment.values,
      path: '$path.mainAxisAlignment',
      label: 'MainAxisAlignment',
      errors: errors,
    );
    final crossAxisAlignment = _decodeEnumField<CrossAxisAlignment>(
      wire: data['crossAxisAlignment'],
      values: CrossAxisAlignment.values,
      path: '$path.crossAxisAlignment',
      label: 'CrossAxisAlignment',
      errors: errors,
    );
    final mainAxisSize = _decodeEnumField<MainAxisSize>(
      wire: data['mainAxisSize'],
      values: MainAxisSize.values,
      path: '$path.mainAxisSize',
      label: 'MainAxisSize',
      errors: errors,
    );
    final verticalDirection = _decodeEnumField<VerticalDirection>(
      wire: data['verticalDirection'],
      values: VerticalDirection.values,
      path: '$path.verticalDirection',
      label: 'VerticalDirection',
      errors: errors,
    );
    final textDirection = _decodeEnumField<TextDirection>(
      wire: data['textDirection'],
      values: TextDirection.values,
      path: '$path.textDirection',
      label: 'TextDirection',
      errors: errors,
    );
    final textBaseline = _decodeEnumField<TextBaseline>(
      wire: data['textBaseline'],
      values: TextBaseline.values,
      path: '$path.textBaseline',
      label: 'TextBaseline',
      errors: errors,
    );
    final clipBehavior = _decodeEnumField<Clip>(
      wire: data['clipBehavior'],
      values: Clip.values,
      path: '$path.clipBehavior',
      label: 'clipBehavior',
      errors: errors,
    );
    final spacing = (data['spacing'] as num?)?.toDouble();

    return FlexStyler(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: spacing,
    );
  }

  StackStyler _decodeStackCoreStyler(
    Map<String, Object?> data, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final alignment = _decodeFieldValue(
      wire: data['alignment'] as Map<String, Object?>?,
      path: '$path.alignment',
      errors: errors,
      decode: DtoCodecs.decodeAlignmentGeometry,
    );
    final fit = _decodeEnumField<StackFit>(
      wire: data['fit'],
      values: StackFit.values,
      path: '$path.fit',
      label: 'StackFit',
      errors: errors,
    );
    final textDirection = _decodeEnumField<TextDirection>(
      wire: data['textDirection'],
      values: TextDirection.values,
      path: '$path.textDirection',
      label: 'TextDirection',
      errors: errors,
    );
    final clipBehavior = _decodeEnumField<Clip>(
      wire: data['clipBehavior'],
      values: Clip.values,
      path: '$path.clipBehavior',
      label: 'clipBehavior',
      errors: errors,
    );

    return StackStyler(
      alignment: alignment,
      fit: fit,
      textDirection: textDirection,
      clipBehavior: clipBehavior,
    );
  }

  Map<String, Object?> _encodeBoxCoreData(
    BoxStyler styler, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final data = <String, Object?>{};
    _encodeField<EdgeInsetsGeometry, EdgeInsetsGeometryMix>(
      prop: styler.$padding,
      key: 'padding',
      path: '$path.padding',
      data: data,
      errors: errors,
      extract: _extractEdgeInsetsGeometryMix,
      encode: DtoCodecs.encodeEdgeInsetsGeometry,
    );
    _encodeField<EdgeInsetsGeometry, EdgeInsetsGeometryMix>(
      prop: styler.$margin,
      key: 'margin',
      path: '$path.margin',
      data: data,
      errors: errors,
      extract: _extractEdgeInsetsGeometryMix,
      encode: DtoCodecs.encodeEdgeInsetsGeometry,
    );
    _encodeField<BoxConstraints, BoxConstraintsMix>(
      prop: styler.$constraints,
      key: 'constraints',
      path: '$path.constraints',
      data: data,
      errors: errors,
      extract: _extractBoxConstraintsMix,
      encode: DtoCodecs.encodeBoxConstraints,
    );
    _encodeField<Decoration, BoxDecorationMix>(
      prop: styler.$decoration,
      key: 'decoration',
      path: '$path.decoration',
      data: data,
      errors: errors,
      extract: _extractBoxDecorationMix,
      encode: DtoCodecs.encodeBoxDecoration,
    );
    _encodeField<Decoration, BoxDecorationMix>(
      prop: styler.$foregroundDecoration,
      key: 'foregroundDecoration',
      path: '$path.foregroundDecoration',
      data: data,
      errors: errors,
      extract: _extractBoxDecorationMix,
      encode: DtoCodecs.encodeBoxDecoration,
    );
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$alignment,
      key: 'alignment',
      path: '$path.alignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );
    _encodeField<Matrix4, Matrix4>(
      prop: styler.$transform,
      key: 'transform',
      path: '$path.transform',
      data: data,
      errors: errors,
      extract: _extractMatrix4,
      encode: DtoCodecs.encodeMatrix4,
    );
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$transformAlignment,
      key: 'transformAlignment',
      path: '$path.transformAlignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );
    _encodeClipBehaviorField(
      prop: styler.$clipBehavior,
      path: '$path.clipBehavior',
      data: data,
      errors: errors,
    );

    return data;
  }

  Map<String, Object?> _encodeFlexCoreData(
    FlexStyler styler, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final data = <String, Object?>{};
    _encodeField<Axis, Axis>(
      prop: styler.$direction,
      key: 'direction',
      path: '$path.direction',
      data: data,
      errors: errors,
      extract: _extractAxis,
      encode: (value) => value.name,
    );
    _encodeField<MainAxisAlignment, MainAxisAlignment>(
      prop: styler.$mainAxisAlignment,
      key: 'mainAxisAlignment',
      path: '$path.mainAxisAlignment',
      data: data,
      errors: errors,
      extract: _extractMainAxisAlignment,
      encode: (value) => value.name,
    );
    _encodeField<CrossAxisAlignment, CrossAxisAlignment>(
      prop: styler.$crossAxisAlignment,
      key: 'crossAxisAlignment',
      path: '$path.crossAxisAlignment',
      data: data,
      errors: errors,
      extract: _extractCrossAxisAlignment,
      encode: (value) => value.name,
    );
    _encodeField<MainAxisSize, MainAxisSize>(
      prop: styler.$mainAxisSize,
      key: 'mainAxisSize',
      path: '$path.mainAxisSize',
      data: data,
      errors: errors,
      extract: _extractMainAxisSize,
      encode: (value) => value.name,
    );
    _encodeField<VerticalDirection, VerticalDirection>(
      prop: styler.$verticalDirection,
      key: 'verticalDirection',
      path: '$path.verticalDirection',
      data: data,
      errors: errors,
      extract: _extractVerticalDirection,
      encode: (value) => value.name,
    );
    _encodeField<TextDirection, TextDirection>(
      prop: styler.$textDirection,
      key: 'textDirection',
      path: '$path.textDirection',
      data: data,
      errors: errors,
      extract: _extractTextDirection,
      encode: (value) => value.name,
    );
    _encodeField<TextBaseline, TextBaseline>(
      prop: styler.$textBaseline,
      key: 'textBaseline',
      path: '$path.textBaseline',
      data: data,
      errors: errors,
      extract: _extractTextBaseline,
      encode: (value) => value.name,
    );
    _encodeClipBehaviorField(
      prop: styler.$clipBehavior,
      path: '$path.clipBehavior',
      data: data,
      errors: errors,
    );
    _encodeField<double, double>(
      prop: styler.$spacing,
      key: 'spacing',
      path: '$path.spacing',
      data: data,
      errors: errors,
      extract: _extractDouble,
      encode: (value) => value,
    );

    return data;
  }

  Map<String, Object?> _encodeStackCoreData(
    StackStyler styler, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    final data = <String, Object?>{};
    _encodeField<AlignmentGeometry, AlignmentGeometry>(
      prop: styler.$alignment,
      key: 'alignment',
      path: '$path.alignment',
      data: data,
      errors: errors,
      extract: _extractAlignmentGeometry,
      encode: DtoCodecs.encodeAlignmentGeometry,
    );
    _encodeField<StackFit, StackFit>(
      prop: styler.$fit,
      key: 'fit',
      path: '$path.fit',
      data: data,
      errors: errors,
      extract: _extractStackFit,
      encode: (value) => value.name,
    );
    _encodeField<TextDirection, TextDirection>(
      prop: styler.$textDirection,
      key: 'textDirection',
      path: '$path.textDirection',
      data: data,
      errors: errors,
      extract: _extractTextDirection,
      encode: (value) => value.name,
    );
    _encodeClipBehaviorField(
      prop: styler.$clipBehavior,
      path: '$path.clipBehavior',
      data: data,
      errors: errors,
    );

    return data;
  }

  void _encodeAnimationField({
    required AnimationConfig? animation,
    required String path,
    required Map<String, Object?> data,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (animation == null) return;
    final encoded = _encodeAnimationConfig(
      animation,
      path: path,
      registries: registries,
      errors: errors,
    );
    if (encoded != null) {
      data['animation'] = encoded;
    }
  }

  Map<String, Object?>? _encodeAnimationConfig(
    AnimationConfig animation, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    switch (animation) {
      case CurveAnimationConfig curveAnimation:
        final startErrors = errors.length;
        final animationMap = <String, Object?>{
          'durationMs': curveAnimation.duration.inMilliseconds,
        };
        final curveName = CurveCodec.encode(curveAnimation.curve);
        if (curveName == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.curve',
              message:
                  'Unsupported Curve instance "${curveAnimation.curve.runtimeType}" in v1.',
              value: curveAnimation.curve.runtimeType.toString(),
            ),
          );
        } else {
          animationMap['curve'] = curveName;
        }
        if (curveAnimation.delay != Duration.zero) {
          animationMap['delayMs'] = curveAnimation.delay.inMilliseconds;
        }
        final onEnd = curveAnimation.onEnd;
        if (onEnd != null) {
          final callbackId = registries.animationOnEnd.idOf(onEnd);
          if (callbackId == null) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.unknownRegistryId,
                path: '$path.onEnd',
                message:
                    'Unknown registry ID for animation onEnd callback in scope "${RegistryScope.animationOnEnd}".',
                value: onEnd.runtimeType.toString(),
              ),
            );
          } else {
            animationMap['onEnd'] = callbackId;
          }
        }

        if (errors.length == startErrors) {
          return animationMap;
        }
        return null;
      case _:
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedMetadata,
            path: path,
            message: 'Only CurveAnimationConfig is supported in v1.',
            value: animation.runtimeType.toString(),
          ),
        );
        return null;
    }
  }

  AnimationConfig? _decodeAnimationConfig(
    Object? value, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (value is! Map<String, Object?>) return null;
    final durationMs = value['durationMs'] as int;
    final curveWire = value['curve'] as String;
    final delayMs = value['delayMs'] as int?;
    final onEndId = value['onEnd'] as String?;

    final curve = CurveCodec.decode(curveWire);
    if (curve == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: '$path.curve',
          message: 'Unsupported curve "$curveWire".',
          value: curveWire,
        ),
      );
      return null;
    }

    VoidCallback? onEnd;
    if (onEndId != null) {
      final callback = registries.animationOnEnd.resolve(onEndId);
      if (callback == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unknownRegistryId,
            path: '$path.onEnd',
            message:
                'Unknown registry ID "$onEndId" in scope "${RegistryScope.animationOnEnd}".',
            value: onEndId,
          ),
        );
      } else {
        onEnd = callback;
      }
    }

    return AnimationConfig.curve(
      duration: Duration(milliseconds: durationMs),
      curve: curve,
      delay: Duration(milliseconds: delayMs ?? 0),
      onEnd: onEnd,
    );
  }

  WidgetModifierConfig? _decodeModifierField({
    required Map<String, Object?> data,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final modifierData = data['modifier'] as Map<String, Object?>?;
    if (modifierData == null) return null;

    return _decodeModifierConfig(
      modifierData,
      path: path,
      registries: registries,
      errors: errors,
    );
  }

  void _encodeModifierField({
    required WidgetModifierConfig? modifier,
    required String path,
    required Map<String, Object?> data,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (modifier == null) return;
    final modifierMap = _encodeModifierConfig(
      modifier,
      path: path,
      registries: registries,
      errors: errors,
    );
    if (modifierMap != null) {
      data['modifier'] = modifierMap;
    }
  }

  void _encodeVariantsField<S extends Spec<S>>({
    required List<VariantStyle<S>>? variants,
    required String path,
    required Map<String, Object?> data,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Map<String, Object?>? Function(
      Style<S> style, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    encodeStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    if (variants == null || variants.isEmpty) return;

    final encodedVariants = _encodeVariants<S>(
      variants,
      path: path,
      registries: registries,
      errors: errors,
      encodeStyle: encodeStyle,
      isExpectedContextBuilderFn: isExpectedContextBuilderFn,
      expectedContextBuilderType: expectedContextBuilderType,
    );
    if (encodedVariants != null) {
      data['variants'] = encodedVariants;
    }
  }

  List<VariantStyle<S>>? _decodeVariantsField<S extends Spec<S>>({
    required Map<String, Object?> data,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Style<S>? Function(
      Map<String, Object?> styleData, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    decodeStyle,
    required Style<S> Function() emptyStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    final variantsData = data['variants'] as List<Object?>?;
    if (variantsData == null) return null;

    return _decodeVariants<S>(
      variantsData,
      path: path,
      registries: registries,
      errors: errors,
      decodeStyle: decodeStyle,
      emptyStyle: emptyStyle,
      isExpectedContextBuilderFn: isExpectedContextBuilderFn,
      expectedContextBuilderType: expectedContextBuilderType,
    );
  }

  TStyle? _decodeVariantStyleByType<TStyle>({
    required Map<String, Object?> styleData,
    required String path,
    required StylerType stylerType,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required TStyle? Function(DecodedStyler decoded) pick,
    required String expectedType,
  }) {
    final result = decode({
      'schemaVersion': 1,
      'stylerType': stylerType.wire,
      'data': styleData,
    }, registries: registries);

    if (result case MixSchemaSuccess<DecodedStyler>(:final value)) {
      final style = pick(value);
      if (style != null) {
        return style;
      }

      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'Variant style could not be decoded as $expectedType.',
          value: styleData,
        ),
      );
      return null;
    }

    final failure = result as MixSchemaFailure<DecodedStyler>;
    for (final nestedError in failure.errors) {
      errors.add(
        _rebaseErrorPath(nestedError, fromPrefix: 'data', toPrefix: path),
      );
    }
    return null;
  }

  Map<String, Object?>? _encodeVariantStyleByType<TStyle>({
    required TStyle style,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required MixSchemaResult<Map<String, Object?>> Function(
      TStyle style, {
      required FrozenRegistryBundle registries,
    })
    encodeStyle,
  }) {
    final result = encodeStyle(style, registries: registries);
    if (result case MixSchemaSuccess<Map<String, Object?>>(
      value: final value,
    )) {
      return value['data'] as Map<String, Object?>;
    }

    final failure = result as MixSchemaFailure<Map<String, Object?>>;
    for (final nestedError in failure.errors) {
      errors.add(
        _rebaseErrorPath(nestedError, fromPrefix: 'data', toPrefix: path),
      );
    }
    return null;
  }

  MixSchemaResult<Map<String, Object?>> _finalizeEncodedPayload({
    required StylerType stylerType,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    return MixSchemaSuccess({
      'schemaVersion': 1,
      'stylerType': stylerType.wire,
      'data': data,
    });
  }

  T? _decodeEnumField<T extends Enum>({
    required Object? wire,
    required List<T> values,
    required String path,
    required String label,
    required List<MixSchemaError> errors,
  }) {
    if (wire == null) return null;
    if (wire is! String) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: '$label must be a string enum value.',
          value: wire,
        ),
      );
      return null;
    }

    final value = _findEnumByName(values, wire);
    if (value == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'Invalid $label "$wire".',
          value: wire,
        ),
      );
    }

    return value;
  }

  void _rejectNestedMetadata({
    required Style style,
    required String path,
    required List<MixSchemaError> errors,
  }) {
    if (style.$animation != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: '$path.animation',
          message: 'Nested style metadata is not allowed in v1 composites.',
          value: style.$animation.runtimeType.toString(),
        ),
      );
    }
    if (style.$modifier != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: '$path.modifier',
          message: 'Nested style metadata is not allowed in v1 composites.',
          value: style.$modifier.runtimeType.toString(),
        ),
      );
    }
    if (style.$variants != null && style.$variants!.isNotEmpty) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: '$path.variants',
          message: 'Nested style metadata is not allowed in v1 composites.',
          value: style.$variants.runtimeType.toString(),
        ),
      );
    }
  }

  BoxStyler? _extractNestedBoxStyler(
    Prop<StyleSpec<BoxSpec>> prop, {
    required String fieldPath,
    required List<MixSchemaError> errors,
  }) {
    try {
      final source = _singleSourceForEncoding(prop, fieldPath: fieldPath);
      return switch (source) {
        MixSource<StyleSpec<BoxSpec>>(:final mix) when mix is BoxStyler => mix,
        _ => throw StateError(
          'Field "$fieldPath" must use a BoxStyler mix source in v1.',
        ),
      };
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: fieldPath,
          message: error.toString(),
        ),
      );
      return null;
    }
  }

  FlexStyler? _extractNestedFlexStyler(
    Prop<StyleSpec<FlexSpec>> prop, {
    required String fieldPath,
    required List<MixSchemaError> errors,
  }) {
    try {
      final source = _singleSourceForEncoding(prop, fieldPath: fieldPath);
      return switch (source) {
        MixSource<StyleSpec<FlexSpec>>(:final mix) when mix is FlexStyler =>
          mix,
        _ => throw StateError(
          'Field "$fieldPath" must use a FlexStyler mix source in v1.',
        ),
      };
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: fieldPath,
          message: error.toString(),
        ),
      );
      return null;
    }
  }

  StackStyler? _extractNestedStackStyler(
    Prop<StyleSpec<StackSpec>> prop, {
    required String fieldPath,
    required List<MixSchemaError> errors,
  }) {
    try {
      final source = _singleSourceForEncoding(prop, fieldPath: fieldPath);
      return switch (source) {
        MixSource<StyleSpec<StackSpec>>(:final mix) when mix is StackStyler =>
          mix,
        _ => throw StateError(
          'Field "$fieldPath" must use a StackStyler mix source in v1.',
        ),
      };
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: fieldPath,
          message: error.toString(),
        ),
      );
      return null;
    }
  }

  void _encodeShadowListField({
    required Prop<List<Shadow>>? prop,
    required String key,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) return;

    try {
      final source = _singleSourceForEncoding(prop, fieldPath: path);
      switch (source) {
        case MixSource<List<Shadow>>(:final mix):
          if (mix is! ShadowListMix) {
            throw StateError(
              'Field "$path" must use ShadowListMix or direct shadow values.',
            );
          }
          data[key] = [
            for (final item in mix.items) DtoCodecs.encodeShadowMix(item),
          ];
        case ValueSource<List<Shadow>>(:final value):
          data[key] = value.map(DtoCodecs.encodeShadow).toList(growable: false);
        default:
          throw StateError('Field "$path" has unsupported shadow source.');
      }
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: error.toString(),
        ),
      );
    }
  }

  WidgetModifierConfig? _decodeModifierConfig(
    Map<String, Object?> data, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    List<Type>? orderOfModifiers;
    final orderData = data['orderOfModifiers'] as List<Object?>?;
    if (orderData != null) {
      final decodedOrder = <Type>[];
      for (var index = 0; index < orderData.length; index++) {
        final orderValue = orderData[index];
        final orderPath = '$path.orderOfModifiers[$index]';
        if (orderValue is! String) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: orderPath,
              message: 'orderOfModifiers entries must be strings.',
              value: orderValue,
            ),
          );
          continue;
        }

        final modifierType = _decodeModifierOrderType(orderValue);
        if (modifierType == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: orderPath,
              message: 'Unsupported modifier order entry "$orderValue" in v1.',
              value: orderValue,
            ),
          );
          continue;
        }

        decodedOrder.add(modifierType);
      }
      orderOfModifiers = decodedOrder;
    }

    List<ModifierMix>? modifiers;
    final modifierItemsData = data['modifiers'] as List<Object?>?;
    if (modifierItemsData != null) {
      final decodedModifiers = <ModifierMix>[];
      for (var index = 0; index < modifierItemsData.length; index++) {
        final item = modifierItemsData[index];
        final itemPath = '$path.modifiers[$index]';
        if (item is! Map<String, Object?>) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: itemPath,
              message: 'Modifier entry must be an object.',
              value: item,
            ),
          );
          continue;
        }

        final decoded = _decodeModifierItem(
          item,
          path: itemPath,
          registries: registries,
          errors: errors,
        );
        if (decoded != null) {
          decodedModifiers.add(decoded);
        }
      }
      modifiers = decodedModifiers;
    }

    return WidgetModifierConfig(
      modifiers: modifiers,
      orderOfModifiers: orderOfModifiers,
    );
  }

  Type? _decodeModifierOrderType(String kind) {
    return switch (kind) {
      'reset' => ResetModifier,
      'opacity' => OpacityModifier,
      'padding' => PaddingModifier,
      'shaderMask' => ShaderMaskModifier,
      'clipOval' => ClipOvalModifier,
      'clipRect' => ClipRectModifier,
      'clipPath' => ClipPathModifier,
      'clipRRect' => ClipRRectModifier,
      'clipTriangle' => ClipTriangleModifier,
      _ => null,
    };
  }

  ModifierMix? _decodeModifierItem(
    Map<String, Object?> data, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final kind = data['kind'];
    if (kind is! String) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: '$path.kind',
          message: 'Modifier kind must be a string.',
          value: kind,
        ),
      );
      return null;
    }

    switch (kind) {
      case 'reset':
        return const ResetModifierMix();
      case 'opacity':
        final opacityValue = data['opacity'];
        if (opacityValue != null && opacityValue is! num) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.opacity',
              message: 'opacity must be a numeric value.',
              value: opacityValue,
            ),
          );
          return null;
        }

        return OpacityModifierMix(
          opacity: opacityValue == null
              ? null
              : (opacityValue as num).toDouble(),
        );
      case 'padding':
        EdgeInsetsGeometryMix? padding;
        final paddingData = data['padding'];
        if (paddingData != null) {
          if (paddingData is! Map<String, Object?>) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.padding',
                message: 'padding must be an object.',
                value: paddingData,
              ),
            );
            return null;
          }

          try {
            padding = DtoCodecs.decodeEdgeInsetsGeometry(paddingData);
          } catch (error) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.padding',
                message: error.toString(),
                value: paddingData,
              ),
            );
            return null;
          }
        }

        return PaddingModifierMix(padding: padding);
      case 'shaderMask':
        final shaderId = data['shaderCallback'];
        if (shaderId is! String) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.shaderCallback',
              message: 'shaderCallback must be a registry ID string.',
              value: shaderId,
            ),
          );
          return null;
        }

        final shaderCallback = registries.modifierShader.resolve(shaderId);
        if (shaderCallback == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unknownRegistryId,
              path: '$path.shaderCallback',
              message:
                  'Unknown registry ID "$shaderId" in scope "${RegistryScope.modifierShader}".',
              value: shaderId,
            ),
          );
          return null;
        }

        BlendMode blendMode = BlendMode.modulate;
        final blendModeValue = data['blendMode'];
        if (blendModeValue != null) {
          if (blendModeValue is! String) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.blendMode',
                message: 'blendMode must be a string enum value.',
                value: blendModeValue,
              ),
            );
            return null;
          }

          final parsedBlendMode = _findEnumByName(
            BlendMode.values,
            blendModeValue,
          );
          if (parsedBlendMode == null) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.blendMode',
                message: 'Invalid blendMode "$blendModeValue".',
                value: blendModeValue,
              ),
            );
            return null;
          }

          blendMode = parsedBlendMode;
        }

        return ShaderMaskModifierMix(
          shaderCallback: shaderCallback,
          blendMode: blendMode,
        );
      case 'clipOval':
        return ClipOvalModifierMix(
          clipper: _decodeClipperRef<Rect>(
            value: data['clipper'],
            path: '$path.clipper',
            registries: registries,
            errors: errors,
          ),
          clipBehavior: _decodeClipValue(
            data['clipBehavior'],
            path: '$path.clipBehavior',
            errors: errors,
          ),
        );
      case 'clipRect':
        return ClipRectModifierMix(
          clipper: _decodeClipperRef<Rect>(
            value: data['clipper'],
            path: '$path.clipper',
            registries: registries,
            errors: errors,
          ),
          clipBehavior: _decodeClipValue(
            data['clipBehavior'],
            path: '$path.clipBehavior',
            errors: errors,
          ),
        );
      case 'clipPath':
        return ClipPathModifierMix(
          clipper: _decodeClipperRef<Path>(
            value: data['clipper'],
            path: '$path.clipper',
            registries: registries,
            errors: errors,
          ),
          clipBehavior: _decodeClipValue(
            data['clipBehavior'],
            path: '$path.clipBehavior',
            errors: errors,
          ),
        );
      case 'clipRRect':
        BorderRadiusGeometryMix? borderRadius;
        final borderRadiusData = data['borderRadius'];
        if (borderRadiusData != null) {
          if (borderRadiusData is! Map<String, Object?>) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.borderRadius',
                message: 'borderRadius must be an object.',
                value: borderRadiusData,
              ),
            );
            return null;
          }

          try {
            borderRadius = DtoCodecs.decodeBorderRadiusGeometry(
              borderRadiusData,
            );
          } catch (error) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.borderRadius',
                message: error.toString(),
                value: borderRadiusData,
              ),
            );
            return null;
          }
        }

        return ClipRRectModifierMix(
          borderRadius: borderRadius,
          clipper: _decodeClipperRef<RRect>(
            value: data['clipper'],
            path: '$path.clipper',
            registries: registries,
            errors: errors,
          ),
          clipBehavior: _decodeClipValue(
            data['clipBehavior'],
            path: '$path.clipBehavior',
            errors: errors,
          ),
        );
      case 'clipTriangle':
        return ClipTriangleModifierMix(
          clipBehavior: _decodeClipValue(
            data['clipBehavior'],
            path: '$path.clipBehavior',
            errors: errors,
          ),
        );
      default:
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedMetadata,
            path: path,
            message: 'Modifier kind "$kind" is not supported in v1.',
            value: kind,
          ),
        );
        return null;
    }
  }

  Clip? _decodeClipValue(
    Object? value, {
    required String path,
    required List<MixSchemaError> errors,
  }) {
    if (value == null) return null;
    if (value is! String) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'clipBehavior must be a string enum value.',
          value: value,
        ),
      );
      return null;
    }

    final clip = _findEnumByName(Clip.values, value);
    if (clip == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'Invalid clipBehavior "$value".',
          value: value,
        ),
      );
      return null;
    }

    return clip;
  }

  CustomClipper<T>? _decodeClipperRef<T extends Object>({
    required Object? value,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (value == null) return null;
    if (value is! String) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'Clipper value must be a registry ID string.',
          value: value,
        ),
      );
      return null;
    }

    final clipper = registries.modifierClipper.resolve(value);
    if (clipper == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unknownRegistryId,
          path: path,
          message:
              'Unknown registry ID "$value" in scope "${RegistryScope.modifierClipper}".',
          value: value,
        ),
      );
      return null;
    }

    if (clipper is! CustomClipper<T>) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message:
              'Registry ID "$value" in scope "${RegistryScope.modifierClipper}" resolved to an incompatible clipper type.',
          value: value,
        ),
      );
      return null;
    }

    return clipper;
  }

  List<VariantStyle<S>>? _decodeVariants<S extends Spec<S>>(
    List<Object?> data, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Style<S>? Function(
      Map<String, Object?> styleData, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    decodeStyle,
    required Style<S> Function() emptyStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    final variants = <VariantStyle<S>>[];
    for (var index = 0; index < data.length; index++) {
      final item = data[index];
      final itemPath = '$path[$index]';
      if (item is! Map<String, Object?>) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: itemPath,
            message: 'Variant entry must be an object.',
            value: item,
          ),
        );
        continue;
      }

      final variant = _decodeVariantItem<S>(
        item,
        path: itemPath,
        registries: registries,
        errors: errors,
        decodeStyle: decodeStyle,
        emptyStyle: emptyStyle,
        isExpectedContextBuilderFn: isExpectedContextBuilderFn,
        expectedContextBuilderType: expectedContextBuilderType,
      );
      if (variant != null) {
        variants.add(variant);
      }
    }

    return variants;
  }

  VariantStyle<S>? _decodeVariantItem<S extends Spec<S>>(
    Map<String, Object?> data, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Style<S>? Function(
      Map<String, Object?> styleData, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    decodeStyle,
    required Style<S> Function() emptyStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    final kind = data['kind'];
    if (kind is! String) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: '$path.kind',
          message: 'Variant kind must be a string.',
          value: kind,
        ),
      );
      return null;
    }

    switch (kind) {
      case 'named':
        final name = data['name'];
        if (name is! String) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.name',
              message: 'Named variant requires a string "name".',
              value: name,
            ),
          );
          return null;
        }

        final styleData = data['style'];
        if (styleData is! Map<String, Object?>) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.style',
              message: 'Named variant requires an object "style".',
              value: styleData,
            ),
          );
          return null;
        }

        final style = decodeStyle(
          styleData,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (style == null) return null;

        return VariantStyle<S>(NamedVariant(name), style);
      case 'widgetState':
        final stateName = data['state'];
        if (stateName is! String) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.state',
              message: 'WidgetState variant requires a string "state".',
              value: stateName,
            ),
          );
          return null;
        }

        final state = _findEnumByName(WidgetState.values, stateName);
        if (state == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.state',
              message: 'Invalid WidgetState "$stateName".',
              value: stateName,
            ),
          );
          return null;
        }

        final styleData = data['style'];
        if (styleData is! Map<String, Object?>) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.style',
              message: 'WidgetState variant requires an object "style".',
              value: styleData,
            ),
          );
          return null;
        }

        final style = decodeStyle(
          styleData,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (style == null) return null;

        return VariantStyle<S>(WidgetStateVariant(state), style);
      case 'contextVariantBuilder':
        final fnId = data['fn'];
        if (fnId is! String) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.fn',
              message: 'ContextVariantBuilder requires a string "fn" ID.',
              value: fnId,
            ),
          );
          return null;
        }

        final resolved = registries.contextVariantBuilder.resolve(fnId);
        if (resolved == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unknownRegistryId,
              path: '$path.fn',
              message:
                  'Unknown registry ID "$fnId" in scope "${RegistryScope.contextVariantBuilder}".',
              value: fnId,
            ),
          );
          return null;
        }

        if (!isExpectedContextBuilderFn(resolved)) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.fn',
              message:
                  'Registry ID "$fnId" in scope "${RegistryScope.contextVariantBuilder}" resolved to an incompatible function type. Expected $expectedContextBuilderType.',
              value: fnId,
            ),
          );
          return null;
        }

        return VariantStyle<S>(
          ContextVariantBuilder(resolved as dynamic),
          emptyStyle(),
        );
      default:
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedMetadata,
            path: path,
            message: 'Variant kind "$kind" is not supported in v1.',
            value: kind,
          ),
        );
        return null;
    }
  }

  Map<String, Object?>? _encodeModifierConfig(
    WidgetModifierConfig modifier, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final result = <String, Object?>{};

    final orderOfModifiers = modifier.$orderOfModifiers;
    if (orderOfModifiers != null) {
      final encodedOrder = <String>[];
      for (var index = 0; index < orderOfModifiers.length; index++) {
        final modifierType = orderOfModifiers[index];
        final entryPath = '$path.orderOfModifiers[$index]';
        final kind = _encodeModifierOrderKind(modifierType);
        if (kind == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: entryPath,
              message: 'Unsupported modifier order type "$modifierType" in v1.',
              value: modifierType.toString(),
            ),
          );
          continue;
        }
        encodedOrder.add(kind);
      }
      result['orderOfModifiers'] = encodedOrder;
    }

    final modifiers = modifier.$modifiers;
    if (modifiers != null) {
      final encodedModifiers = <Object?>[];
      for (var index = 0; index < modifiers.length; index++) {
        final modifierItem = _encodeModifierItem(
          modifiers[index],
          path: '$path.modifiers[$index]',
          registries: registries,
          errors: errors,
        );
        if (modifierItem != null) {
          encodedModifiers.add(modifierItem);
        }
      }
      result['modifiers'] = encodedModifiers;
    }

    return result;
  }

  String? _encodeModifierOrderKind(Type modifierType) {
    return switch (modifierType) {
      ResetModifier => 'reset',
      OpacityModifier => 'opacity',
      PaddingModifier => 'padding',
      ShaderMaskModifier => 'shaderMask',
      ClipOvalModifier => 'clipOval',
      ClipRectModifier => 'clipRect',
      ClipPathModifier => 'clipPath',
      ClipRRectModifier => 'clipRRect',
      ClipTriangleModifier => 'clipTriangle',
      _ => null,
    };
  }

  Map<String, Object?>? _encodeModifierItem(
    ModifierMix modifier, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    switch (modifier) {
      case ResetModifierMix():
        return {'kind': 'reset'};
      case OpacityModifierMix opacityModifier:
        final result = <String, Object?>{'kind': 'opacity'};
        final opacityValue = _extractSingleValue<double>(
          opacityModifier.opacity,
        );
        if (opacityModifier.opacity != null && opacityValue == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.opacity',
              message:
                  'opacity must be a direct value source to be encoded in v1.',
            ),
          );
        } else if (opacityValue != null) {
          result['opacity'] = opacityValue;
        }
        return result;
      case PaddingModifierMix paddingModifier:
        final result = <String, Object?>{'kind': 'padding'};
        final padding = paddingModifier.padding;
        if (padding != null) {
          try {
            final mix = _extractEdgeInsetsGeometryMix(
              padding,
              fieldPath: '$path.padding',
            );
            result['padding'] = DtoCodecs.encodeEdgeInsetsGeometry(mix);
          } catch (error) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.padding',
                message: error.toString(),
              ),
            );
          }
        }
        return result;
      case ShaderMaskModifierMix shaderMaskModifier:
        final callbackId = _encodeShaderCallbackId(
          prop: shaderMaskModifier.shaderCallback,
          path: '$path.shaderCallback',
          registries: registries,
          errors: errors,
        );
        if (callbackId == null) {
          return null;
        }

        final result = <String, Object?>{
          'kind': 'shaderMask',
          'shaderCallback': callbackId,
        };
        final blendMode = _extractSingleValue<BlendMode>(
          shaderMaskModifier.blendMode,
        );
        if (shaderMaskModifier.blendMode != null && blendMode == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.blendMode',
              message:
                  'blendMode must be a direct value source to be encoded in v1.',
            ),
          );
        } else if (blendMode != null) {
          result['blendMode'] = blendMode.name;
        }
        return result;
      case ClipOvalModifierMix clipOvalModifier:
        final result = <String, Object?>{'kind': 'clipOval'};
        final clipperId = _encodeClipperId<Rect>(
          prop: clipOvalModifier.clipper,
          path: '$path.clipper',
          registries: registries,
          errors: errors,
        );
        if (clipperId != null) {
          result['clipper'] = clipperId;
        }
        _encodeClipBehaviorField(
          prop: clipOvalModifier.clipBehavior,
          path: '$path.clipBehavior',
          data: result,
          errors: errors,
        );
        return result;
      case ClipRectModifierMix clipRectModifier:
        final result = <String, Object?>{'kind': 'clipRect'};
        final clipperId = _encodeClipperId<Rect>(
          prop: clipRectModifier.clipper,
          path: '$path.clipper',
          registries: registries,
          errors: errors,
        );
        if (clipperId != null) {
          result['clipper'] = clipperId;
        }
        _encodeClipBehaviorField(
          prop: clipRectModifier.clipBehavior,
          path: '$path.clipBehavior',
          data: result,
          errors: errors,
        );
        return result;
      case ClipPathModifierMix clipPathModifier:
        final result = <String, Object?>{'kind': 'clipPath'};
        final clipperId = _encodeClipperId<Path>(
          prop: clipPathModifier.clipper,
          path: '$path.clipper',
          registries: registries,
          errors: errors,
        );
        if (clipperId != null) {
          result['clipper'] = clipperId;
        }
        _encodeClipBehaviorField(
          prop: clipPathModifier.clipBehavior,
          path: '$path.clipBehavior',
          data: result,
          errors: errors,
        );
        return result;
      case ClipRRectModifierMix clipRRectModifier:
        final result = <String, Object?>{'kind': 'clipRRect'};
        final borderRadius = clipRRectModifier.borderRadius;
        if (borderRadius != null) {
          try {
            final mix = _extractBorderRadiusGeometryMix(
              borderRadius,
              fieldPath: '$path.borderRadius',
            );
            result['borderRadius'] = DtoCodecs.encodeBorderRadiusGeometry(mix);
          } catch (error) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: '$path.borderRadius',
                message: error.toString(),
              ),
            );
          }
        }
        final clipperId = _encodeClipperId<RRect>(
          prop: clipRRectModifier.clipper,
          path: '$path.clipper',
          registries: registries,
          errors: errors,
        );
        if (clipperId != null) {
          result['clipper'] = clipperId;
        }
        _encodeClipBehaviorField(
          prop: clipRRectModifier.clipBehavior,
          path: '$path.clipBehavior',
          data: result,
          errors: errors,
        );
        return result;
      case ClipTriangleModifierMix clipTriangleModifier:
        final result = <String, Object?>{'kind': 'clipTriangle'};
        _encodeClipBehaviorField(
          prop: clipTriangleModifier.clipBehavior,
          path: '$path.clipBehavior',
          data: result,
          errors: errors,
        );
        return result;
      default:
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedMetadata,
            path: path,
            message:
                'Modifier type "${modifier.runtimeType}" is not supported in v1.',
            value: modifier.runtimeType.toString(),
          ),
        );
        return null;
    }
  }

  String? _encodeShaderCallbackId({
    required Prop<ShaderCallback>? prop,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: 'shaderCallback is required for shaderMask modifier.',
        ),
      );
      return null;
    }

    if (prop.sources.length != 1) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message:
              'shaderCallback must contain exactly one direct value source in v1.',
        ),
      );
      return null;
    }

    final source = prop.sources.single;
    if (source case ValueSource<ShaderCallback>(:final value)) {
      final id = registries.modifierShader.idOf(value);
      if (id == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unknownRegistryId,
            path: path,
            message:
                'Unknown registry ID for shader callback in scope "${RegistryScope.modifierShader}".',
            value: value.runtimeType.toString(),
          ),
        );
      }
      return id;
    }

    errors.add(
      MixSchemaError.fromCode(
        code: MixSchemaErrorCode.invalidValue,
        path: path,
        message: 'shaderCallback must use a direct value source in v1.',
      ),
    );
    return null;
  }

  String? _encodeClipperId<T extends Object>({
    required Prop<CustomClipper<T>>? prop,
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) return null;

    if (prop.sources.length != 1) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message:
              'clipper must contain exactly one direct value source in v1.',
        ),
      );
      return null;
    }

    final source = prop.sources.single;
    if (source case ValueSource<CustomClipper<T>>(:final value)) {
      final id = registries.modifierClipper.idOf(value);
      if (id == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unknownRegistryId,
            path: path,
            message:
                'Unknown registry ID for clipper in scope "${RegistryScope.modifierClipper}".',
            value: value.runtimeType.toString(),
          ),
        );
      }
      return id;
    }

    errors.add(
      MixSchemaError.fromCode(
        code: MixSchemaErrorCode.invalidValue,
        path: path,
        message: 'clipper must use a direct value source in v1.',
      ),
    );
    return null;
  }

  void _encodeClipBehaviorField({
    required Prop<Clip>? prop,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    final clipBehavior = _extractSingleValue<Clip>(prop);
    if (prop != null && clipBehavior == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message:
              'clipBehavior must be a direct value source to be encoded in v1.',
        ),
      );
      return;
    }

    if (clipBehavior != null) {
      data['clipBehavior'] = clipBehavior.name;
    }
  }

  List<Object?>? _encodeVariants<S extends Spec<S>>(
    List<VariantStyle<S>> variants, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Map<String, Object?>? Function(
      Style<S> style, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    encodeStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    final encoded = <Object?>[];
    for (var index = 0; index < variants.length; index++) {
      final itemPath = '$path[$index]';
      final variantData = _encodeVariantItem<S>(
        variants[index],
        path: itemPath,
        registries: registries,
        errors: errors,
        encodeStyle: encodeStyle,
        isExpectedContextBuilderFn: isExpectedContextBuilderFn,
        expectedContextBuilderType: expectedContextBuilderType,
      );
      if (variantData != null) {
        encoded.add(variantData);
      }
    }

    return encoded;
  }

  Map<String, Object?>? _encodeVariantItem<S extends Spec<S>>(
    VariantStyle<S> variantStyle, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
    required Map<String, Object?>? Function(
      Style<S> style, {
      required String path,
      required FrozenRegistryBundle registries,
      required List<MixSchemaError> errors,
    })
    encodeStyle,
    required bool Function(Object value) isExpectedContextBuilderFn,
    required String expectedContextBuilderType,
  }) {
    final variant = variantStyle.variant;
    final style = variantStyle.value;

    switch (variant) {
      case NamedVariant named:
        final encodedStyle = encodeStyle(
          style,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (encodedStyle == null) return null;

        return {'kind': 'named', 'name': named.name, 'style': encodedStyle};
      case WidgetStateVariant widgetState:
        final encodedStyle = encodeStyle(
          style,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (encodedStyle == null) return null;

        return {
          'kind': 'widgetState',
          'state': widgetState.state.name,
          'style': encodedStyle,
        };
      case ContextVariantBuilder contextBuilder:
        if (!isExpectedContextBuilderFn(contextBuilder.fn as Object)) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.fn',
              message:
                  'Context variant builder function has incompatible type. Expected $expectedContextBuilderType.',
              value: contextBuilder.fn.runtimeType.toString(),
            ),
          );
          return null;
        }

        final fnId = registries.contextVariantBuilder.idOf(
          contextBuilder.fn as Object,
        );
        if (fnId == null) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.unknownRegistryId,
              path: '$path.fn',
              message:
                  'Unknown registry ID for context variant builder in scope "${RegistryScope.contextVariantBuilder}".',
              value: contextBuilder.fn.runtimeType.toString(),
            ),
          );
          return null;
        }

        return {'kind': 'contextVariantBuilder', 'fn': fnId};
      default:
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedMetadata,
            path: path,
            message:
                'Variant type "${variant.runtimeType}" is not supported in v1.',
            value: variant.runtimeType.toString(),
          ),
        );
        return null;
    }
  }

  MixSchemaError _rebaseErrorPath(
    MixSchemaError error, {
    required String fromPrefix,
    required String toPrefix,
  }) {
    final sourcePath = error.path;
    final rebasedPath = switch (sourcePath) {
      '' => toPrefix,
      _ when sourcePath == fromPrefix => toPrefix,
      _ when sourcePath.startsWith('$fromPrefix.') =>
        '$toPrefix${sourcePath.substring(fromPrefix.length)}',
      _ when sourcePath.startsWith('$fromPrefix[') =>
        '$toPrefix${sourcePath.substring(fromPrefix.length)}',
      _ => _appendPath(toPrefix, sourcePath),
    };

    return MixSchemaError(
      code: error.code,
      path: rebasedPath,
      message: error.message,
      value: error.value,
    );
  }

  List<MixSchemaError> _mapSchemaError(
    SchemaError error, {
    String parentPath = '',
    Object? parentValue,
  }) {
    final currentPath = _composeSchemaPath(
      parentPath,
      error,
      parentValue: parentValue,
    );

    switch (error) {
      case SchemaNestedError(:final errors):
        return [
          for (final nested in errors)
            ..._mapSchemaError(
              nested,
              parentPath: currentPath,
              parentValue: error.value,
            ),
        ];
      case SchemaConstraintsError(:final constraints, :final value):
        return _mapConstraintErrors(
          constraints: constraints,
          currentPath: currentPath,
          value: value,
        );
      case SchemaUnknownError():
        return [
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: currentPath,
            message: 'Unknown schema validation failure.',
            value: error.value,
          ),
        ];
      case _:
        return [
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: currentPath,
            message: 'Schema validation failure.',
            value: error.value,
          ),
        ];
    }
  }

  String _composeSchemaPath(
    String parentPath,
    SchemaError error, {
    Object? parentValue,
  }) {
    final segment = error.name;
    if (segment.isEmpty) return parentPath;

    // Discriminated schemas may surface a branch label as a synthetic segment.
    // Keep paths stable to payload field names by eliding that branch segment.
    final value = error.value;
    if (value is Map<Object?, Object?> && value['kind'] == segment) {
      if (parentValue is Map<Object?, Object?>) {
        for (final entry in parentValue.entries) {
          if (entry.key case final String key
              when identical(entry.value, value)) {
            return _appendPath(parentPath, key);
          }
        }
      }

      return parentPath;
    }

    return _appendPath(parentPath, segment);
  }

  List<MixSchemaError> _mapConstraintErrors({
    required List<ConstraintError> constraints,
    required String currentPath,
    required Object? value,
  }) {
    final errors = <MixSchemaError>[];

    for (final constraint in constraints) {
      switch (constraint.constraintKey) {
        case 'object_no_additional_properties':
          final extras =
              (constraint.context?['unallowedProperties'] as List<Object?>?)
                  ?.whereType<String>()
                  .toList();

          if (extras == null || extras.isEmpty) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.unknownField,
                path: currentPath,
                message: 'Unknown field.',
                value: value,
              ),
            );
            continue;
          }

          final valueMap = value is Map<String, Object?> ? value : null;
          for (final extra in extras) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.unknownField,
                path: _appendPath(currentPath, extra),
                message: "Unknown field '$extra'.",
                value: valueMap?[extra],
              ),
            );
          }
        case 'object_required_properties':
          final missing =
              (constraint.context?['missingProperties'] as List<Object?>?)
                  ?.whereType<String>()
                  .toList();
          if (missing == null || missing.isEmpty) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: currentPath,
                message: constraint.message,
                value: value,
              ),
            );
            continue;
          }

          for (final field in missing) {
            errors.add(
              MixSchemaError.fromCode(
                code: MixSchemaErrorCode.invalidValue,
                path: _appendPath(currentPath, field),
                message: "Missing required field '$field'.",
              ),
            );
          }
        default:
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: currentPath,
              message: constraint.message,
              value: value,
            ),
          );
      }
    }

    return errors;
  }

  String _appendPath(String base, String segment) {
    if (segment.isEmpty) return base;

    final isIndex = int.tryParse(segment) != null;
    if (isIndex) {
      if (base.isEmpty) return '[$segment]';

      return '$base[$segment]';
    }

    if (base.isEmpty) return segment;

    return '$base.$segment';
  }

  T? _extractSingleValue<T extends Object>(Prop<T>? prop) {
    if (prop == null) return null;
    if (prop.sources.length != 1) return null;

    final source = prop.sources.single;
    if (source case ValueSource<T>(:final value)) {
      return value;
    }

    return null;
  }

  T? _findEnumByName<T extends Enum>(List<T> values, String name) {
    for (final value in values) {
      if (value.name == name) return value;
    }

    return null;
  }

  T? _decodeFieldValue<T, W>({
    required W? wire,
    required String path,
    required List<MixSchemaError> errors,
    required T Function(W wire) decode,
  }) {
    if (wire == null) return null;

    try {
      return decode(wire);
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: error.toString(),
          value: wire,
        ),
      );
      return null;
    }
  }

  void _encodeField<T extends Object, R>({
    required Prop<T>? prop,
    required String key,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
    required R Function(Prop<T> prop, {required String fieldPath}) extract,
    required Object? Function(R value) encode,
  }) {
    if (prop == null) return;

    try {
      final extracted = extract(prop, fieldPath: path);
      data[key] = encode(extracted);
    } catch (error) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: path,
          message: error.toString(),
        ),
      );
    }
  }

  EdgeInsetsGeometryMix _extractEdgeInsetsGeometryMix(
    Prop<EdgeInsetsGeometry> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<EdgeInsetsGeometry, EdgeInsetsGeometryMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use EdgeInsetsGeometryMix.',
      fromValue: EdgeInsetsGeometryMix.value,
    );
  }

  BoxConstraintsMix _extractBoxConstraintsMix(
    Prop<BoxConstraints> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<BoxConstraints, BoxConstraintsMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use BoxConstraintsMix.',
      fromValue: BoxConstraintsMix.value,
    );
  }

  BoxDecorationMix _extractBoxDecorationMix(
    Prop<Decoration> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<Decoration, BoxDecorationMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" only supports BoxDecorationMix in v1.',
      fromValue: (value) {
        if (value is BoxDecoration) return BoxDecorationMix.value(value);
        throw StateError(
          'Field "$fieldPath" only supports BoxDecoration values in v1.',
        );
      },
    );
  }

  BorderRadiusGeometryMix _extractBorderRadiusGeometryMix(
    Prop<BorderRadiusGeometry> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<BorderRadiusGeometry, BorderRadiusGeometryMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use BorderRadiusGeometryMix.',
      fromValue: BorderRadiusGeometryMix.value,
    );
  }

  AlignmentGeometry _extractAlignmentGeometry(
    Prop<AlignmentGeometry> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'alignment',
    );
  }

  Matrix4 _extractMatrix4(Prop<Matrix4> prop, {required String fieldPath}) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'Matrix4',
    );
  }

  double _extractDouble(Prop<double> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'double');
  }

  int _extractInt(Prop<int> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'int');
  }

  bool _extractBool(Prop<bool> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'bool');
  }

  String _extractString(Prop<String> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'string');
  }

  Color _extractColor(Prop<Color> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'Color');
  }

  Locale _extractLocale(Prop<Locale> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'Locale');
  }

  TextScaler _extractTextScaler(
    Prop<TextScaler> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextScaler',
    );
  }

  Rect _extractRect(Prop<Rect> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'Rect');
  }

  Axis _extractAxis(Prop<Axis> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'Axis');
  }

  MainAxisAlignment _extractMainAxisAlignment(
    Prop<MainAxisAlignment> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'MainAxisAlignment',
    );
  }

  CrossAxisAlignment _extractCrossAxisAlignment(
    Prop<CrossAxisAlignment> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'CrossAxisAlignment',
    );
  }

  MainAxisSize _extractMainAxisSize(
    Prop<MainAxisSize> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'MainAxisSize',
    );
  }

  VerticalDirection _extractVerticalDirection(
    Prop<VerticalDirection> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'VerticalDirection',
    );
  }

  TextDirection _extractTextDirection(
    Prop<TextDirection> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextDirection',
    );
  }

  TextBaseline _extractTextBaseline(
    Prop<TextBaseline> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextBaseline',
    );
  }

  StackFit _extractStackFit(Prop<StackFit> prop, {required String fieldPath}) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'StackFit',
    );
  }

  TextOverflow _extractTextOverflow(
    Prop<TextOverflow> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextOverflow',
    );
  }

  TextAlign _extractTextAlign(
    Prop<TextAlign> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextAlign',
    );
  }

  TextWidthBasis _extractTextWidthBasis(
    Prop<TextWidthBasis> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'TextWidthBasis',
    );
  }

  BlendMode _extractBlendMode(
    Prop<BlendMode> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'BlendMode',
    );
  }

  ImageRepeat _extractImageRepeat(
    Prop<ImageRepeat> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'ImageRepeat',
    );
  }

  BoxFit _extractBoxFit(Prop<BoxFit> prop, {required String fieldPath}) {
    return _extractDirectValue(prop, fieldPath: fieldPath, valueType: 'BoxFit');
  }

  FilterQuality _extractFilterQuality(
    Prop<FilterQuality> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'FilterQuality',
    );
  }

  TextStyleMix _extractTextStyleMix(
    Prop<TextStyle> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<TextStyle, TextStyleMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use TextStyleMix.',
      fromValue: TextStyleMix.value,
    );
  }

  StrutStyleMix _extractStrutStyleMix(
    Prop<StrutStyle> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<StrutStyle, StrutStyleMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use StrutStyleMix.',
      fromValue: StrutStyleMix.value,
    );
  }

  TextHeightBehaviorMix _extractTextHeightBehaviorMix(
    Prop<TextHeightBehavior> prop, {
    required String fieldPath,
  }) {
    return _extractMixOrValue<TextHeightBehavior, TextHeightBehaviorMix>(
      prop,
      fieldPath: fieldPath,
      mixError: 'Field "$fieldPath" must use TextHeightBehaviorMix.',
      fromValue: TextHeightBehaviorMix.value,
    );
  }

  ImageProvider<Object> _extractImageProvider(
    Prop<ImageProvider<Object>> prop, {
    required String fieldPath,
  }) {
    return _extractDirectValue(
      prop,
      fieldPath: fieldPath,
      valueType: 'ImageProvider',
    );
  }

  PropSource<T> _singleSourceForEncoding<T extends Object>(
    Prop<T> prop, {
    required String fieldPath,
  }) {
    if (prop.sources.length != 1) {
      throw StateError(
        'Field "$fieldPath" must contain exactly one source for deterministic encoding.',
      );
    }

    return prop.sources.single;
  }

  M _extractMixOrValue<T extends Object, M extends Object>(
    Prop<T> prop, {
    required String fieldPath,
    required String mixError,
    required M Function(T value) fromValue,
  }) {
    final source = _singleSourceForEncoding(prop, fieldPath: fieldPath);
    switch (source) {
      case MixSource<T>(:final mix):
        if (mix is M) return mix as M;
        throw StateError(mixError);
      case ValueSource<T>(:final value):
        return fromValue(value);
      default:
        throw StateError(
          'Field "$fieldPath" has unsupported source type ${source.runtimeType}.',
        );
    }
  }

  T _extractDirectValue<T extends Object>(
    Prop<T> prop, {
    required String fieldPath,
    required String valueType,
  }) {
    final source = _singleSourceForEncoding(prop, fieldPath: fieldPath);
    return switch (source) {
      ValueSource<T>(:final value) => value,
      _ => throw StateError(
        'Field "$fieldPath" must use a direct $valueType value source.',
      ),
    };
  }
}
