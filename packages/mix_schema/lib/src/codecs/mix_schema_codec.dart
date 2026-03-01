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

    _encodeEdgeInsetsField(
      prop: styler.$padding,
      key: 'padding',
      path: 'data.padding',
      data: data,
      errors: errors,
    );
    _encodeEdgeInsetsField(
      prop: styler.$margin,
      key: 'margin',
      path: 'data.margin',
      data: data,
      errors: errors,
    );
    _encodeConstraintsField(
      prop: styler.$constraints,
      key: 'constraints',
      path: 'data.constraints',
      data: data,
      errors: errors,
    );
    _encodeDecorationField(
      prop: styler.$decoration,
      key: 'decoration',
      path: 'data.decoration',
      data: data,
      errors: errors,
    );
    _encodeDecorationField(
      prop: styler.$foregroundDecoration,
      key: 'foregroundDecoration',
      path: 'data.foregroundDecoration',
      data: data,
      errors: errors,
    );

    final clipBehavior = _extractSingleValue<Clip>(styler.$clipBehavior);
    if (styler.$clipBehavior != null && clipBehavior == null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.invalidValue,
          path: 'data.clipBehavior',
          message:
              'clipBehavior must be a direct value source to be encoded in v1.',
        ),
      );
    } else if (clipBehavior != null) {
      data['clipBehavior'] = clipBehavior.name;
    }

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

    if (styler.$modifier != null) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.modifier',
          message: 'Modifier encoding is not implemented in M2.',
        ),
      );
    }

    final variants = styler.$variants;
    if (variants != null && variants.isNotEmpty) {
      errors.add(
        MixSchemaError.fromCode(
          code: MixSchemaErrorCode.unsupportedMetadata,
          path: 'data.variants',
          message: 'Variants encoding is not implemented in M2.',
        ),
      );
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

    EdgeInsetsGeometryMix? padding;
    final paddingData = data['padding'] as Map<String, Object?>?;
    if (paddingData != null) {
      try {
        padding = DtoCodecs.decodeEdgeInsetsGeometry(paddingData);
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.padding',
            message: error.toString(),
            value: paddingData,
          ),
        );
      }
    }

    EdgeInsetsGeometryMix? margin;
    final marginData = data['margin'] as Map<String, Object?>?;
    if (marginData != null) {
      try {
        margin = DtoCodecs.decodeEdgeInsetsGeometry(marginData);
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.margin',
            message: error.toString(),
            value: marginData,
          ),
        );
      }
    }

    BoxConstraintsMix? constraints;
    final constraintsData = data['constraints'] as Map<String, Object?>?;
    if (constraintsData != null) {
      try {
        constraints = DtoCodecs.decodeBoxConstraints(constraintsData);
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.constraints',
            message: error.toString(),
            value: constraintsData,
          ),
        );
      }
    }

    DecorationMix? decoration;
    final decorationData = data['decoration'] as Map<String, Object?>?;
    if (decorationData != null) {
      try {
        decoration = DtoCodecs.decodeBoxDecoration(decorationData);
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.decoration',
            message: error.toString(),
            value: decorationData,
          ),
        );
      }
    }

    DecorationMix? foregroundDecoration;
    final foregroundDecorationData =
        data['foregroundDecoration'] as Map<String, Object?>?;
    if (foregroundDecorationData != null) {
      try {
        foregroundDecoration = DtoCodecs.decodeBoxDecoration(
          foregroundDecorationData,
        );
      } catch (error) {
        errors.add(
          MixSchemaError.fromCode(
            code: MixSchemaErrorCode.invalidValue,
            path: 'data.foregroundDecoration',
            message: error.toString(),
            value: foregroundDecorationData,
          ),
        );
      }
    }

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

    if (errors.isNotEmpty) {
      return MixSchemaFailure(errors);
    }

    final styler = BoxStyler(
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      clipBehavior: clipBehavior,
      animation: animation,
    );

    return MixSchemaSuccess(
      DecodedStyler(stylerType: StylerType.box, styler: styler),
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

  void _encodeEdgeInsetsField({
    required Prop<EdgeInsetsGeometry>? prop,
    required String key,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) return;

    try {
      final mix = _extractEdgeInsetsGeometryMix(prop, fieldPath: path);
      data[key] = DtoCodecs.encodeEdgeInsetsGeometry(mix);
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

  void _encodeConstraintsField({
    required Prop<BoxConstraints>? prop,
    required String key,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) return;

    try {
      final mix = _extractBoxConstraintsMix(prop, fieldPath: path);
      data[key] = DtoCodecs.encodeBoxConstraints(mix);
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

  void _encodeDecorationField({
    required Prop<Decoration>? prop,
    required String key,
    required String path,
    required Map<String, Object?> data,
    required List<MixSchemaError> errors,
  }) {
    if (prop == null) return;

    try {
      final mix = _extractBoxDecorationMix(prop, fieldPath: path);
      data[key] = DtoCodecs.encodeBoxDecoration(mix);
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
    if (prop.sources.length != 1) {
      throw StateError(
        'Field "$fieldPath" must contain exactly one source for deterministic encoding.',
      );
    }

    final source = prop.sources.single;
    return switch (source) {
      MixSource<EdgeInsetsGeometry>(:final mix) =>
        mix is EdgeInsetsGeometryMix
            ? mix
            : throw StateError(
                'Field "$fieldPath" must use EdgeInsetsGeometryMix.',
              ),
      ValueSource<EdgeInsetsGeometry>(:final value) =>
        EdgeInsetsGeometryMix.value(value),
      _ => throw StateError(
        'Field "$fieldPath" has unsupported source type ${source.runtimeType}.',
      ),
    };
  }

  BoxConstraintsMix _extractBoxConstraintsMix(
    Prop<BoxConstraints> prop, {
    required String fieldPath,
  }) {
    if (prop.sources.length != 1) {
      throw StateError(
        'Field "$fieldPath" must contain exactly one source for deterministic encoding.',
      );
    }

    final source = prop.sources.single;
    return switch (source) {
      MixSource<BoxConstraints>(:final mix) =>
        mix is BoxConstraintsMix
            ? mix
            : throw StateError(
                'Field "$fieldPath" must use BoxConstraintsMix.',
              ),
      ValueSource<BoxConstraints>(:final value) => BoxConstraintsMix.value(
        value,
      ),
      _ => throw StateError(
        'Field "$fieldPath" has unsupported source type ${source.runtimeType}.',
      ),
    };
  }

  BoxDecorationMix _extractBoxDecorationMix(
    Prop<Decoration> prop, {
    required String fieldPath,
  }) {
    if (prop.sources.length != 1) {
      throw StateError(
        'Field "$fieldPath" must contain exactly one source for deterministic encoding.',
      );
    }

    final source = prop.sources.single;
    return switch (source) {
      MixSource<Decoration>(:final mix) =>
        mix is BoxDecorationMix
            ? mix
            : throw StateError(
                'Field "$fieldPath" only supports BoxDecorationMix in v1.',
              ),
      ValueSource<Decoration>(:final value) =>
        value is BoxDecoration
            ? BoxDecorationMix.value(value)
            : throw StateError(
                'Field "$fieldPath" only supports BoxDecoration values in v1.',
              ),
      _ => throw StateError(
        'Field "$fieldPath" has unsupported source type ${source.runtimeType}.',
      ),
    };
  }
}
