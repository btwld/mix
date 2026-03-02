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
      case _:
        return MixSchemaFailure([
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedStylerType,
            path: 'stylerType',
            message:
                'Styler type "${stylerType.wire}" is not implemented in M2.',
            value: stylerType.wire,
          ),
        ]);
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
      case _:
        return MixSchemaFailure([
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.unsupportedStylerType,
            path: 'stylerType',
            message:
                'Styler type "${decoded.stylerType.wire}" is not implemented in M2.',
            value: decoded.stylerType.wire,
          ),
        ]);
    }
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

    final variants = styler.$variants;
    if (variants != null && variants.isNotEmpty) {
      final encodedVariants = _encodeVariants(
        variants,
        path: 'data.variants',
        registries: registries,
        errors: errors,
      );
      if (encodedVariants != null) {
        data['variants'] = encodedVariants;
      }
    }

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

    List<VariantStyle<BoxSpec>>? variants;
    final variantsData = data['variants'] as List<Object?>?;
    if (variantsData != null) {
      variants = _decodeVariants(
        variantsData,
        path: 'data.variants',
        registries: registries,
        errors: errors,
      );
    }

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

  List<VariantStyle<BoxSpec>>? _decodeVariants(
    List<Object?> data, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final variants = <VariantStyle<BoxSpec>>[];
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

      final variant = _decodeVariantItem(
        item,
        path: itemPath,
        registries: registries,
        errors: errors,
      );
      if (variant != null) {
        variants.add(variant);
      }
    }

    return variants;
  }

  VariantStyle<BoxSpec>? _decodeVariantItem(
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

        final style = _decodeNestedVariantStyle(
          styleData,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (style == null) return null;

        return VariantStyle<BoxSpec>(NamedVariant(name), style);
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

        final style = _decodeNestedVariantStyle(
          styleData,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (style == null) return null;

        return VariantStyle<BoxSpec>(WidgetStateVariant(state), style);
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

        if (resolved is! BoxStyler Function(BuildContext)) {
          errors.add(
            MixSchemaError.fromCode(
              code: MixSchemaErrorCode.invalidValue,
              path: '$path.fn',
              message:
                  'Registry ID "$fnId" in scope "${RegistryScope.contextVariantBuilder}" resolved to an incompatible function type.',
              value: fnId,
            ),
          );
          return null;
        }

        return VariantStyle<BoxSpec>(
          ContextVariantBuilder<BoxStyler>(resolved),
          BoxStyler(),
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

  BoxStyler? _decodeNestedVariantStyle(
    Map<String, Object?> styleData, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final result = _decodeBox({
      'schemaVersion': 1,
      'stylerType': StylerType.box.wire,
      'data': styleData,
    }, registries: registries);

    if (result case MixSchemaSuccess<DecodedStyler>(:final value)) {
      final styler = value.boxStyler;
      if (styler == null) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: path,
            message: 'Variant style could not be decoded as BoxStyler.',
            value: styleData,
          ),
        );
        return null;
      }

      return styler;
    }

    final failure = result as MixSchemaFailure<DecodedStyler>;
    for (final nestedError in failure.errors) {
      errors.add(
        _rebaseErrorPath(nestedError, fromPrefix: 'data', toPrefix: path),
      );
    }

    return null;
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

  List<Object?>? _encodeVariants(
    List<VariantStyle<BoxSpec>> variants, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final encoded = <Object?>[];
    for (var index = 0; index < variants.length; index++) {
      final itemPath = '$path[$index]';
      final variantData = _encodeVariantItem(
        variants[index],
        path: itemPath,
        registries: registries,
        errors: errors,
      );
      if (variantData != null) {
        encoded.add(variantData);
      }
    }

    return encoded;
  }

  Map<String, Object?>? _encodeVariantItem(
    VariantStyle<BoxSpec> variantStyle, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final variant = variantStyle.variant;
    final style = variantStyle.value;

    switch (variant) {
      case NamedVariant named:
        final encodedStyle = _encodeBoxVariantStyle(
          style,
          path: '$path.style',
          registries: registries,
          errors: errors,
        );
        if (encodedStyle == null) return null;

        return {'kind': 'named', 'name': named.name, 'style': encodedStyle};
      case WidgetStateVariant widgetState:
        final encodedStyle = _encodeBoxVariantStyle(
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

  Map<String, Object?>? _encodeBoxVariantStyle(
    Object style, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
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

    return _encodeNestedVariantStyle(
      style,
      path: path,
      registries: registries,
      errors: errors,
    );
  }

  Map<String, Object?>? _encodeNestedVariantStyle(
    BoxStyler style, {
    required String path,
    required FrozenRegistryBundle registries,
    required List<MixSchemaError> errors,
  }) {
    final result = encodeBox(style, registries: registries);
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
