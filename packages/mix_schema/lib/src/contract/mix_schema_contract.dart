import 'package:ack/ack.dart';
import 'package:mix/mix.dart' show IconStyler, ImageStyler;

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

/// Package version stamped into exported JSON Schema metadata.
const mixSchemaVersion = '0.0.1';

/// Mutable builder for assembling a frozen Mix style wire contract.
///
/// Register styler branches directly with [addStyler] or use [builtIn] for the
/// package-supported Mix styler set, then call [freeze] once to obtain an
/// immutable [MixSchemaContract].
final class MixSchemaContractBuilder {
  /// Creates an empty builder.
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

  /// Registry builder used by registry-backed fields in the eventual contract.
  RegistryBuilder get registry => _registryBuilder;

  /// Registers a styler branch for the root `type` discriminator.
  ///
  /// [wireType] is the value accepted in payloads' `type` field. [schema]
  /// decodes and encodes the styler value for that discriminator.
  MixSchemaContractBuilder addStyler<T extends Object>(
    String wireType,
    AckSchema<JsonMap, T> schema,
  ) {
    _ensureMutable();
    _branches[wireType] = widenStylerBranch(schema, debugName: wireType);

    return this;
  }

  /// Registers the package's built-in styler branches.
  ///
  /// By default this includes every built-in styler. Set
  /// [includeRegistryBacked] to `false` for shared contracts that should avoid
  /// `icon` and `image`, whose identity fields need an app-owned registry.
  MixSchemaContractBuilder builtIn({bool includeRegistryBacked = true}) {
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
    if (includeRegistryBacked) {
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
    }
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

  /// Freezes the builder into an immutable contract.
  ///
  /// The builder and its registry cannot be mutated after this call succeeds.
  /// At least one styler branch must be registered before freezing.
  MixSchemaContract freeze() {
    _ensureMutable();
    if (_branches.isEmpty) {
      throw StateError(
        'MixSchemaContractBuilder cannot freeze without registered stylers. '
        'Call builtIn() or addStyler() before freeze().',
      );
    }
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

/// Immutable JSON wire contract for Mix stylers.
///
/// A contract validates payloads, decodes them into real Mix stylers, encodes
/// representable stylers back to JSON, and exports a JSON Schema description of
/// the registered branch set.
final class MixSchemaContract {
  const MixSchemaContract._({
    required this.rootSchema,
    required this.registry,
    required this.registeredTypes,
  });

  /// Root Ack schema used for validation, decode, encode, and schema export.
  final AckSchema<JsonMap, Object> rootSchema;

  /// Frozen registry used by identity fields such as callbacks and icons.
  final FrozenRegistry registry;

  /// Root `type` discriminator values registered in this contract.
  final List<String> registeredTypes;

  /// Validates [payload] without requiring the caller to choose a Dart type.
  MixSchemaValidationResult validate(Object? payload) {
    final registryBackedError = _missingRegistryBackedBranchForPayload(payload);
    if (registryBackedError != null) {
      return MixSchemaValidationFailure([registryBackedError]);
    }

    final result = rootSchema.safeParse(payload);
    if (result.isOk) return const MixSchemaValidationSuccess();

    return MixSchemaValidationFailure(mapSchemaError(result.getError()));
  }

  /// Decodes [payload] as a Mix styler or custom registered value of type [T].
  MixSchemaDecodeResult<T> decode<T extends Object>(Object? payload) {
    final registryBackedError = _missingRegistryBackedBranchForPayload(payload);
    if (registryBackedError != null) {
      return MixSchemaDecodeFailure([registryBackedError]);
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

  /// Encodes a representable Mix styler or custom registered value.
  MixSchemaEncodeResult encode(Object value) {
    final registryBackedError = _missingRegistryBackedBranchForValue(value);
    if (registryBackedError != null) {
      return MixSchemaEncodeFailure([registryBackedError]);
    }

    final result = rootSchema.safeEncode(value);
    if (result.isFail) {
      return MixSchemaEncodeFailure(mapSchemaError(result.getError()));
    }

    final encoded = result.getOrNull();

    return MixSchemaEncodeSuccess(encoded!);
  }

  /// Exports the registered contract shape as draft-07 JSON Schema metadata.
  JsonMap exportJsonSchema() {
    final exported = Map<String, Object?>.from(rootSchema.toJsonSchema());

    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ...exported,
      'x-mix-schema-contract': 'mix_schema',
      'x-mix-schema-version': mixSchemaVersion,
    };
  }

  MixSchemaError? _missingRegistryBackedBranchForPayload(Object? payload) {
    if (payload is! Map) return null;
    final type = payload['type'];
    if (type is! String || !_isMissingRegistryBackedBranch(type)) return null;

    return _registryBackedBranchError(
      code: MixSchemaErrorCode.unknownType,
      path: '#/type',
      wireType: type,
    );
  }

  MixSchemaError? _missingRegistryBackedBranchForValue(Object value) {
    final wireType = switch (value) {
      IconStyler() => schemaTypeIcon,
      ImageStyler() => schemaTypeImage,
      _ => null,
    };
    if (wireType == null || !_isMissingRegistryBackedBranch(wireType)) {
      return null;
    }

    return _registryBackedBranchError(
      code: MixSchemaErrorCode.unsupportedEncodeValue,
      path: '',
      wireType: wireType,
    );
  }

  bool _isMissingRegistryBackedBranch(String wireType) {
    return (wireType == schemaTypeIcon || wireType == schemaTypeImage) &&
        !registeredTypes.contains(wireType);
  }

  MixSchemaError _registryBackedBranchError({
    required MixSchemaErrorCode code,
    required String path,
    required String wireType,
  }) {
    return MixSchemaError(
      code: code,
      path: path,
      message:
          'The "$wireType" styler branch is registry-backed and is not '
          'registered in this contract. Use '
          'MixSchemaContractBuilder().builtIn() with a populated registry for '
          'icon/image payloads.',
    );
  }
}
