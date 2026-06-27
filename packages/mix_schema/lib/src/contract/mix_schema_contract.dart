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
import '../schema/wire_discriminators.dart';

const mixSchemaVersion = '0.0.1';

final class MixSchemaContractBuilder {
  MixSchemaContractBuilder() : _registryBuilder = RegistryBuilder() {
    _rootSchemaRef = Ack.lazy<JsonMap, Object>(
      'mix_schema_style',
      () => _rootSchema,
    );
  }

  final RegistryBuilder _registryBuilder;
  final Map<String, AckSchema<JsonMap, Object>> _branches = {};
  late final AckSchema<JsonMap, Object> _rootSchemaRef;
  late AckSchema<JsonMap, Object> _rootSchema;
  late FrozenRegistry _frozenRegistry;
  bool _isFrozen = false;

  RegistryBuilder get registry => _registryBuilder;

  MixSchemaContractBuilder addStyler<T extends Object>(
    String wireType,
    AckSchema<JsonMap, T> schema,
  ) {
    _ensureMutable();
    _branches[wireType] = widenStylerBranch(schema, debugName: wireType);

    return this;
  }

  MixSchemaContractBuilder builtIn() {
    _ensureMutable();
    addStyler(
      schemaTypeBox,
      boxStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeText,
      textStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeFlex,
      flexStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeStack,
      stackStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeIcon,
      iconStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeImage,
      imageStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeFlexBox,
      flexBoxStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );
    addStyler(
      schemaTypeStackBox,
      stackBoxStylerCodec(
        rootStyleSchema: _rootSchemaRef,
        registry: () => _frozenRegistry,
      ),
    );

    return this;
  }

  MixSchemaContract freeze() {
    _ensureMutable();
    final registry = _registryBuilder.freeze();
    _isFrozen = true;
    _frozenRegistry = registry;
    final root = Ack.discriminated<Object>(
      discriminatorKey: 'type',
      schemas: _branches,
    );
    _rootSchema = root;

    return MixSchemaContract._(
      rootSchema: root,
      registry: registry,
      registeredTypes: List.unmodifiable(_branches.keys),
    );
  }

  void _ensureMutable() {
    if (_isFrozen) {
      throw StateError('MixSchemaContractBuilder cannot be used after freeze.');
    }
  }
}

final class MixSchemaContract {
  const MixSchemaContract._({
    required this.rootSchema,
    required this.registry,
    required this.registeredTypes,
  });

  final AckSchema<JsonMap, Object> rootSchema;
  final FrozenRegistry registry;
  final List<String> registeredTypes;

  MixSchemaValidationResult validate(Object? payload) {
    final result = rootSchema.safeParse(payload);
    if (result.isOk) return const MixSchemaValidationSuccess();

    return MixSchemaValidationFailure(mapSchemaError(result.getError()));
  }

  MixSchemaDecodeResult<T> decode<T extends Object>(Object? payload) {
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

    return MixSchemaEncodeSuccess(encoded!);
  }

  JsonMap exportJsonSchema() {
    final exported = Map<String, Object?>.from(rootSchema.toJsonSchema());

    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ...exported,
      'x-mix-schema-contract': 'mix_schema',
      'x-mix-schema-version': mixSchemaVersion,
    };
  }
}
