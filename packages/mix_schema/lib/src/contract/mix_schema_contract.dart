import 'package:ack/ack.dart';

import '../errors/mix_schema_error.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/registry.dart';
import '../schema/box_styler_codec.dart';
import '../schema/flex_box_styler_codec.dart';
import '../schema/flex_styler_codec.dart';
import '../schema/icon_styler_codec.dart';
import '../schema/image_styler_codec.dart';
import '../schema/stack_box_styler_codec.dart';
import '../schema/stack_styler_codec.dart';
import '../schema/styler_branch.dart';
import '../schema/text_styler_codec.dart';
import 'mix_schema_limits.dart';

const mixSchemaVersion = '0.0.1';

final class MixSchemaContractBuilder {
  MixSchemaContractBuilder({MixSchemaLimits limits = const MixSchemaLimits()})
    : _limits = limits,
      _registryBuilder = RegistryBuilder() {
    _rootSchemaRef = Ack.lazy<JsonMap, Object>(
      'mix_schema_style',
      () => _rootSchema,
    );
  }

  MixSchemaLimits _limits;
  final RegistryBuilder _registryBuilder;
  final Map<String, AckSchema<JsonMap, Object>> _branches = {};
  late final AckSchema<JsonMap, Object> _rootSchemaRef;
  late AckSchema<JsonMap, Object> _rootSchema;
  late FrozenRegistry _frozenRegistry;

  MixSchemaLimits get limits => _limits;
  RegistryBuilder get registry => _registryBuilder;

  MixSchemaContractBuilder withLimits(MixSchemaLimits limits) {
    _limits = limits;

    return this;
  }

  MixSchemaContractBuilder addStyler<T extends Object>(
    String wireType,
    AckSchema<JsonMap, T> schema,
  ) {
    _branches[wireType] = widenStylerBranch(schema, debugName: wireType);

    return this;
  }

  MixSchemaContractBuilder builtIn() {
    addStyler(
      'box',
      boxStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler('text', textStylerCodec(registry: () => _frozenRegistry));
    addStyler('flex', flexStylerCodec(registry: () => _frozenRegistry));
    addStyler('stack', stackStylerCodec(registry: () => _frozenRegistry));
    addStyler('icon', iconStylerCodec(registry: () => _frozenRegistry));
    addStyler('image', imageStylerCodec(registry: () => _frozenRegistry));
    addStyler('flex_box', flexBoxStylerCodec(registry: () => _frozenRegistry));
    addStyler(
      'stack_box',
      stackBoxStylerCodec(registry: () => _frozenRegistry),
    );

    return this;
  }

  MixSchemaContract freeze() {
    final registry = _registryBuilder.freeze();
    _frozenRegistry = registry;
    final root = Ack.discriminated<Object>(
      discriminatorKey: 'type',
      schemas: _branches,
    );
    _rootSchema = root;

    return MixSchemaContract._(
      rootSchema: root,
      limits: _limits,
      registry: registry,
      registeredTypes: _branches.keys.toList(growable: false),
    );
  }
}

final class MixSchemaContract {
  const MixSchemaContract._({
    required this.rootSchema,
    required this.limits,
    required this.registry,
    required this.registeredTypes,
  });

  final AckSchema<JsonMap, Object> rootSchema;
  final MixSchemaLimits limits;
  final FrozenRegistry registry;
  final List<String> registeredTypes;

  MixSchemaValidationResult validate(Object? payload) {
    final limitErrors = validatePayloadLimits(payload, limits);
    if (limitErrors.isNotEmpty) {
      return MixSchemaValidationFailure(limitErrors);
    }

    final result = rootSchema.safeParse(payload);
    if (result.isOk) return const MixSchemaValidationSuccess();

    return MixSchemaValidationFailure(mapSchemaError(result.getError()));
  }

  MixSchemaDecodeResult<T> decode<T extends Object>(Object? payload) {
    final limitErrors = validatePayloadLimits(payload, limits);
    if (limitErrors.isNotEmpty) {
      return MixSchemaDecodeFailure(limitErrors);
    }

    final result = rootSchema.safeParse(payload);
    if (result.isFail) {
      return MixSchemaDecodeFailure(mapSchemaError(result.getError()));
    }

    final value = result.getOrNull();
    if (value is T) return MixSchemaDecodeSuccess<T>(value);

    return MixSchemaDecodeFailure([
      MixSchemaError(
        code: MixSchemaErrorCode.typeMismatch,
        path: '',
        message: 'Decoded value is ${value.runtimeType}, expected $T.',
        value: value,
      ),
    ]);
  }

  MixSchemaEncodeResult encode(Object value) {
    final result = rootSchema.safeEncode(value);
    if (result.isFail) {
      return MixSchemaEncodeFailure(mapSchemaError(result.getError()));
    }

    final encoded = result.getOrNull();
    final limitErrors = validatePayloadLimits(encoded, limits);
    if (limitErrors.isNotEmpty) {
      return MixSchemaEncodeFailure(limitErrors);
    }

    return MixSchemaEncodeSuccess(encoded!);
  }

  JsonMap exportJsonSchema() {
    final exported = Map<String, Object?>.from(rootSchema.toJsonSchema());

    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ...exported,
      'x-mix-schema-contract': 'mix_schema',
      'x-mix-schema-version': mixSchemaVersion,
      'x-mix-schema-limits': limits.toJson(),
    };
  }
}
