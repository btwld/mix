import 'package:ack/ack.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart'
    show
        Breakpoint,
        BreakpointToken,
        BorderSideToken,
        BoxShadowToken,
        ColorToken,
        DoubleToken,
        DurationToken,
        FontWeightToken,
        IconStyler,
        ImageStyler,
        MixToken,
        RadiusToken,
        ShadowToken,
        SpaceToken,
        TextStyleToken;

import '../errors/mix_schema_error.dart';
import '../errors/schema_error_mapper.dart';
import '../registry/registry.dart';
import '../schema/box_styler_codec.dart';
import '../schema/flex_box_styler_codec.dart';
import '../schema/flex_styler_codec.dart';
import '../schema/icon_styler_codec.dart';
import '../schema/image_styler_codec.dart';
import '../schema/common_codecs.dart';
import '../schema/stack_box_styler_codec.dart';
import '../schema/stack_styler_codec.dart';
import '../schema/styler_branch.dart';
import '../schema/text_styler_codec.dart';
import '../schema/wire_discriminators.dart';
import '../tokens/token_reference_walker.dart';

/// Package version stamped into exported JSON Schema metadata.
const mixSchemaVersion = '0.0.1';

/// Current `mix_schema` wire-format version for top-level style documents.
const mixSchemaFormatVersion = 1;

const int _defaultMaxDepth = 64;
const int _defaultMaxNodes = 10000;
const int _defaultMaxLenientRemovals = 256;
const String _versionKey = 'v';

/// Decode behavior for forward-compatible payloads.
enum MixSchemaDecodeMode {
  /// Reject unknown fields, discriminators, and enum values.
  strict,

  /// Skip unknown values at the smallest enclosing style field or list entry.
  lenient,
}

/// Options for decoding a style document.
final class MixSchemaDecodeOptions {
  /// Creates decode options.
  const MixSchemaDecodeOptions({this.mode = MixSchemaDecodeMode.strict});

  /// How unknown fields, discriminators, and enum values are handled.
  final MixSchemaDecodeMode mode;
}

/// Owned wrapper for a styler branch registered with [MixSchemaContractBuilder].
///
/// The branch currently adapts to the Ack-backed engine internally, but callers
/// register this mix_schema type instead of depending on the engine type at the
/// builder boundary.
final class MixSchemaBranch<T extends Object> {
  /// Creates a branch from JSON decode/encode callbacks.
  ///
  /// Use [validate] for branch-local payload checks. The callback receives the
  /// branch payload after the root `type` discriminator has selected it.
  factory MixSchemaBranch.json({
    required T Function(JsonMap data) decode,
    required JsonMap Function(T value) encode,
    bool Function(JsonMap data)? validate,
    String validationMessage = 'Custom branch payload failed validation.',
  }) {
    AckSchema<JsonMap, JsonMap> input = Ack.object(
      const {},
      additionalProperties: true,
    );
    if (validate != null) {
      input = input.refine(validate, message: validationMessage);
    }

    return MixSchemaBranch._ack(
      Ack.codec<JsonMap, JsonMap, T>(
        input: input,
        decode: decode,
        encode: encode,
        output: Ack.instance<T>(),
      ),
    );
  }

  const MixSchemaBranch._ack(AckSchema<JsonMap, T> schema) : _schema = schema;

  final AckSchema<JsonMap, T> _schema;
}

/// Owned view of the root schema for a frozen [MixSchemaContract].
final class MixSchemaRootSchema {
  const MixSchemaRootSchema._(this._schema);

  final AckSchema<JsonMap, Object> _schema;

  /// Exports this root as JSON Schema.
  JsonMap toJsonSchema() => Map<String, Object?>.unmodifiable(
    Map<String, Object?>.from(_schema.toJsonSchema()),
  );
}

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
    MixSchemaBranch<T> schema,
  ) {
    _ensureMutable();
    _branches[wireType] = widenStylerBranch(
      schema._schema,
      debugName: wireType,
    );

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
      MixSchemaBranch._ack(
        boxStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
      ),
    );
    addStyler(
      schemaTypeText,
      MixSchemaBranch._ack(
        textStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
      ),
    );
    addStyler(
      schemaTypeFlex,
      MixSchemaBranch._ack(
        flexStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
      ),
    );
    addStyler(
      schemaTypeStack,
      MixSchemaBranch._ack(
        stackStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
      ),
    );
    if (includeRegistryBacked) {
      addStyler(
        schemaTypeIcon,
        MixSchemaBranch._ack(
          iconStylerCodec(
            rootStyleSchema: _rootSchemaRef,
            registry: () => _frozenRegistry,
          ),
        ),
      );
      addStyler(
        schemaTypeImage,
        MixSchemaBranch._ack(
          imageStylerCodec(
            rootStyleSchema: _rootSchemaRef,
            registry: () => _frozenRegistry,
          ),
        ),
      );
    }
    addStyler(
      schemaTypeFlexBox,
      MixSchemaBranch._ack(
        flexBoxStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
      ),
    );
    addStyler(
      schemaTypeStackBox,
      MixSchemaBranch._ack(
        stackBoxStylerCodec(
          rootStyleSchema: _rootSchemaRef,
          registry: () => _frozenRegistry,
        ),
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
      rootSchema: MixSchemaRootSchema._(root),
      rootAckSchema: root,
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
    required AckSchema<JsonMap, Object> rootAckSchema,
    required this.registry,
    required this.registeredTypes,
  }) : _rootSchema = rootAckSchema;

  /// Root schema view used for schema export and inspection.
  final MixSchemaRootSchema rootSchema;

  final AckSchema<JsonMap, Object> _rootSchema;

  /// Frozen registry used by identity fields such as callbacks and icons.
  final FrozenRegistry registry;

  /// Root `type` discriminator values registered in this contract.
  final List<String> registeredTypes;

  /// Validates [payload] without requiring the caller to choose a Dart type.
  MixSchemaValidationResult validate(Object? payload) {
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixSchemaValidationFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;

    final registryBackedError = _missingRegistryBackedBranchForPayload(
      ready.payload,
    );
    if (registryBackedError != null) {
      return MixSchemaValidationFailure([
        registryBackedError,
      ], warnings: ready.warnings);
    }

    final result = _rootSchema.safeParse(ready.payload);
    if (result.isOk) {
      return MixSchemaValidationSuccess(warnings: ready.warnings);
    }

    return MixSchemaValidationFailure(
      mapSchemaError(result.getError()),
      warnings: ready.warnings,
    );
  }

  /// Decodes [payload] as a Mix styler or custom registered value of type [T].
  MixSchemaDecodeResult<T> decode<T extends Object>(
    Object? payload, {
    MixSchemaDecodeOptions options = const MixSchemaDecodeOptions(),
  }) {
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixSchemaDecodeFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;

    final registryBackedError = _missingRegistryBackedBranchForPayload(
      ready.payload,
    );
    if (registryBackedError != null) {
      return MixSchemaDecodeFailure([
        registryBackedError,
      ], warnings: ready.warnings);
    }

    if (options.mode == MixSchemaDecodeMode.lenient) {
      return _decodeLenient<T>(ready.payload, ready.warnings);
    }

    final result = _rootSchema.safeParse(ready.payload);
    if (result.isFail) {
      return MixSchemaDecodeFailure(
        mapSchemaError(result.getError()),
        warnings: ready.warnings,
      );
    }

    final value = result.getOrNull();
    if (value is T) {
      return MixSchemaDecodeSuccess<T>(value, warnings: ready.warnings);
    }

    return MixSchemaDecodeFailure([
      MixSchemaError(
        code: MixSchemaErrorCode.typeMismatch,
        path: '',
        message: 'Decoded value is ${value.runtimeType}, expected $T.',
        value: value,
      ),
    ], warnings: ready.warnings);
  }

  /// Encodes a representable Mix styler or custom registered value.
  MixSchemaEncodeResult encode(Object value) {
    final registryBackedError = _missingRegistryBackedBranchForValue(value);
    if (registryBackedError != null) {
      return MixSchemaEncodeFailure([registryBackedError]);
    }

    final result = _rootSchema.safeEncode(value);
    if (result.isFail) {
      return MixSchemaEncodeFailure(mapSchemaError(result.getError()));
    }

    final encoded = result.getOrNull();

    return MixSchemaEncodeSuccess({
      ...encoded!,
      _versionKey: mixSchemaFormatVersion,
    });
  }

  /// Exports the registered contract shape as draft-07 JSON Schema metadata.
  JsonMap exportJsonSchema() {
    final exported = _withVersionEnvelope(
      Map<String, Object?>.from(rootSchema.toJsonSchema()),
    );

    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ...exported,
      'x-mix-schema-contract': 'mix_schema',
      'x-mix-schema-version': mixSchemaVersion,
      'x-mix-schema-format-version': mixSchemaFormatVersion,
    };
  }

  MixSchemaDecodeResult<T> _decodeLenient<T extends Object>(
    Object? payload,
    List<MixSchemaError> initialWarnings,
  ) {
    final warnings = [...initialWarnings];
    var current = _deepMutableCopy(payload);
    final journal = _LenientRemovalJournal();
    var removals = 0;

    while (true) {
      final result = _rootSchema.safeParse(current);
      if (result.isOk) {
        final value = result.getOrNull();
        if (value is T) {
          return MixSchemaDecodeSuccess<T>(
            value,
            warnings: List.unmodifiable(warnings),
          );
        }

        return MixSchemaDecodeFailure([
          MixSchemaError(
            code: MixSchemaErrorCode.typeMismatch,
            path: '',
            message: 'Decoded value is ${value.runtimeType}, expected $T.',
            value: value,
          ),
        ], warnings: List.unmodifiable(warnings));
      }

      final errors = mapSchemaError(result.getError());
      var changed = false;
      for (final error in errors) {
        final removalPath = _lenientRemovalPath(error);
        if (removalPath == null) continue;
        if (removals >= _defaultMaxLenientRemovals) {
          return MixSchemaDecodeFailure([
            const MixSchemaError(
              code: MixSchemaErrorCode.limitExceeded,
              path: '',
              message:
                  'Lenient decode exceeded its cleanup removal limit of '
                  '$_defaultMaxLenientRemovals.',
            ),
          ], warnings: List.unmodifiable(warnings));
        }
        final warningPath = journal.originalPathFor(error.path);
        final removalKind = _removePath(current, removalPath);
        if (removalKind == null) continue;
        warnings.add(_asWarning(error, path: warningPath));
        if (removalKind == _RemovalKind.listEntry) {
          journal.record(removalPath);
        }
        removals += 1;
        changed = true;
        break;
      }

      if (!changed) {
        return MixSchemaDecodeFailure(
          errors,
          warnings: List.unmodifiable(warnings),
        );
      }
    }
  }

  MixSchemaError? _missingRegistryBackedBranchForPayload(Object? payload) {
    if (payload is! Map) return null;
    final type = payload['type'];
    if (type is! String || !_isMissingRegistryBackedBranch(type)) return null;

    return _registryBackedBranchError(
      code: MixSchemaErrorCode.unknownType,
      path: '/type',
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

/// Decoded theme document containing flat token values ready for `MixScope`.
final class MixSchemaThemeDocument {
  /// Creates a theme document from canonical Mix token values.
  MixSchemaThemeDocument({required Map<MixToken, Object> tokens})
    : tokens = Map.unmodifiable(tokens);

  /// Flat token map suitable for `MixScope(tokens:)`.
  final Map<MixToken, Object> tokens;
}

/// Dedicated entry point for versioned `type: "theme"` token documents.
final class MixSchemaThemeCodec {
  /// Creates the built-in theme document codec.
  const MixSchemaThemeCodec();

  /// Validates [payload] as a theme document.
  MixSchemaValidationResult validate(Object? payload) {
    return switch (decode(payload)) {
      MixSchemaDecodeSuccess<MixSchemaThemeDocument>(:final warnings) =>
        MixSchemaValidationSuccess(warnings: warnings),
      MixSchemaDecodeFailure<MixSchemaThemeDocument>(
        :final errors,
        :final warnings,
      ) =>
        MixSchemaValidationFailure(errors, warnings: warnings),
    };
  }

  /// Decodes [payload] into a flat token map.
  MixSchemaDecodeResult<MixSchemaThemeDocument> decode(Object? payload) {
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixSchemaDecodeFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;
    final data = ready.payload;
    if (data is! JsonMap) {
      return MixSchemaDecodeFailure([
        MixSchemaError(
          code: MixSchemaErrorCode.typeMismatch,
          path: '',
          message: 'Theme documents must be JSON objects.',
          value: data,
        ),
      ], warnings: ready.warnings);
    }

    final errors = <MixSchemaError>[];
    _validateThemeEnvelope(data, errors);
    if (errors.isNotEmpty) {
      return MixSchemaDecodeFailure(errors, warnings: ready.warnings);
    }

    final state = _ThemeDecodeState();
    for (final kind in _themeTokenKinds) {
      _decodeThemeKind(data, kind, state, errors);
    }
    final tokens = _resolveThemeAliases(state, errors);
    if (errors.isNotEmpty) {
      return MixSchemaDecodeFailure(errors, warnings: ready.warnings);
    }

    return MixSchemaDecodeSuccess(
      MixSchemaThemeDocument(tokens: tokens),
      warnings: ready.warnings,
    );
  }

  /// Encodes [document] as a canonical versioned theme document.
  MixSchemaEncodeResult encode(MixSchemaThemeDocument document) {
    final errors = <MixSchemaError>[];
    final grouped = {
      for (final kind in _themeTokenKinds) kind.field: <String, Object>{},
    };

    for (final entry in document.tokens.entries) {
      final token = entry.key;
      final kind = _themeKindForToken(token);
      if (kind == null) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.unsupportedEncodeValue,
            path: '',
            message:
                'Theme documents can only encode canonical mix_schema token '
                'classes; got ${token.runtimeType}.',
            value: token,
          ),
        );
        continue;
      }

      final path = _joinPath('/${kind.field}', token.name);
      if (!isValidTokenName(token.name)) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.invalidTokenName,
            path: path,
            message: 'Token names must match [A-Za-z0-9_.-]{1,128}.',
            value: token.name,
          ),
        );
        continue;
      }

      final references = tokenReferencesOf(entry.value);
      if (references.isNotEmpty) {
        errors.add(
          MixSchemaError(
            code: MixSchemaErrorCode.constraintViolation,
            path: path,
            message:
                'Theme token values must be concrete; token references are '
                'only allowed as same-kind whole-value aliases in theme JSON.',
            value: references.first.toString(),
          ),
        );
        continue;
      }

      final result = kind.valueSchema.safeEncode(entry.value);
      if (result.isFail) {
        errors.addAll(_withPathPrefix(mapSchemaError(result.getError()), path));
        continue;
      }

      grouped[kind.field]![token.name] = result.getOrNull()!;
    }

    if (errors.isNotEmpty) return MixSchemaEncodeFailure(errors);

    return MixSchemaEncodeSuccess({
      _versionKey: mixSchemaFormatVersion,
      'type': _themeWireType,
      for (final entry in grouped.entries)
        if (entry.value.isNotEmpty)
          entry.key: Map<String, Object?>.unmodifiable(entry.value),
    });
  }

  /// Exports the theme document shape as draft-07 JSON Schema metadata.
  JsonMap exportJsonSchema() {
    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ..._withVersionEnvelope(_themeJsonSchema()),
      'x-mix-schema-contract': 'mix_schema_theme',
      'x-mix-schema-version': mixSchemaVersion,
      'x-mix-schema-format-version': mixSchemaFormatVersion,
    };
  }
}

const String _themeWireType = 'theme';
const String _tokenNamePatternSchema = r'^[A-Za-z0-9_.-]{1,128}$';

final List<_ThemeTokenKind> _themeTokenKinds = [
  _ThemeTokenKind(
    field: 'colors',
    tokenType: ColorToken,
    createToken: ColorToken.new,
    valueSchema: _eraseBoundary(colorLiteralCodec()),
  ),
  _ThemeTokenKind(
    field: 'spaces',
    tokenType: SpaceToken,
    createToken: SpaceToken.new,
    valueSchema: _eraseBoundary(numberAsDoubleCodec()),
    aliasKind: tokenKindSpace,
  ),
  _ThemeTokenKind(
    field: 'doubles',
    tokenType: DoubleToken,
    createToken: DoubleToken.new,
    valueSchema: _eraseBoundary(numberAsDoubleCodec()),
    aliasKind: tokenKindDouble,
  ),
  _ThemeTokenKind(
    field: 'radii',
    tokenType: RadiusToken,
    createToken: RadiusToken.new,
    valueSchema: _eraseBoundary(radiusLiteralCodec()),
  ),
  _ThemeTokenKind(
    field: 'textStyles',
    tokenType: TextStyleToken,
    createToken: TextStyleToken.new,
    valueSchema: _eraseBoundary(_themeTextStyleCodec()),
  ),
  _ThemeTokenKind(
    field: 'shadows',
    tokenType: ShadowToken,
    createToken: ShadowToken.new,
    valueSchema: _eraseBoundary(_themeShadowListCodec()),
  ),
  _ThemeTokenKind(
    field: 'boxShadows',
    tokenType: BoxShadowToken,
    createToken: BoxShadowToken.new,
    valueSchema: _eraseBoundary(_themeBoxShadowListCodec()),
  ),
  _ThemeTokenKind(
    field: 'borders',
    tokenType: BorderSideToken,
    createToken: BorderSideToken.new,
    valueSchema: _eraseBoundary(_themeBorderSideCodec()),
  ),
  _ThemeTokenKind(
    field: 'fontWeights',
    tokenType: FontWeightToken,
    createToken: FontWeightToken.new,
    valueSchema: _eraseBoundary(fontWeightLiteralCodec()),
  ),
  _ThemeTokenKind(
    field: 'breakpoints',
    tokenType: BreakpointToken,
    createToken: BreakpointToken.new,
    valueSchema: _eraseBoundary(_themeBreakpointCodec()),
  ),
  _ThemeTokenKind(
    field: 'durations',
    tokenType: DurationToken,
    createToken: DurationToken.new,
    valueSchema: _eraseBoundary(_themeDurationCodec()),
  ),
];

sealed class _PreparedPayload {
  const _PreparedPayload();
}

final class _PreparedPayloadSuccess extends _PreparedPayload {
  const _PreparedPayloadSuccess(this.payload, this.warnings);

  final Object? payload;
  final List<MixSchemaError> warnings;
}

final class _PreparedPayloadFailure extends _PreparedPayload {
  const _PreparedPayloadFailure(this.error);

  final MixSchemaError error;
}

_PreparedPayload _preparePayload(Object? payload) {
  if (payload is JsonMap &&
      payload.containsKey(_versionKey) &&
      payload[_versionKey] == null) {
    return const _PreparedPayloadFailure(
      MixSchemaError(
        code: MixSchemaErrorCode.unsupportedVersion,
        path: '/v',
        message: 'mix_schema format version must be integer 1.',
      ),
    );
  }

  final preflightError = _inspectInput(payload);
  if (preflightError != null) return _PreparedPayloadFailure(preflightError);

  final warnings = <MixSchemaError>[];
  if (payload is! JsonMap) return _PreparedPayloadSuccess(payload, warnings);

  final rawVersion = payload[_versionKey];
  if (!payload.containsKey(_versionKey)) {
    warnings.add(
      const MixSchemaError(
        code: MixSchemaErrorCode.requiredField,
        severity: MixSchemaDiagnosticSeverity.warning,
        path: '/v',
        message:
            'Missing format version; treating this document as mix_schema '
            'format v1 for the transition window.',
      ),
    );
  } else if (rawVersion is! int) {
    return _PreparedPayloadFailure(
      MixSchemaError(
        code: MixSchemaErrorCode.unsupportedVersion,
        path: '/v',
        message:
            'mix_schema format version must be integer '
            '$mixSchemaFormatVersion.',
        value: rawVersion,
      ),
    );
  } else if (rawVersion != mixSchemaFormatVersion) {
    return _PreparedPayloadFailure(
      MixSchemaError(
        code: MixSchemaErrorCode.unsupportedVersion,
        path: '/v',
        message:
            'Unsupported mix_schema format version $rawVersion; this decoder '
            'supports version $mixSchemaFormatVersion.',
        value: rawVersion,
      ),
    );
  }

  return _PreparedPayloadSuccess(
    Map<String, Object?>.unmodifiable({
      for (final entry in payload.entries)
        if (entry.key != _versionKey) entry.key: entry.value,
    }),
    List.unmodifiable(warnings),
  );
}

MixSchemaError? _inspectInput(Object? payload) {
  var nodes = 0;
  final stack = [_InputNode(payload, '', 1)];

  while (stack.isNotEmpty) {
    final current = stack.removeLast();
    nodes += 1;
    if (nodes > _defaultMaxNodes) {
      return MixSchemaError(
        code: MixSchemaErrorCode.limitExceeded,
        path: current.path,
        message: 'Payload exceeds the maximum node count of $_defaultMaxNodes.',
      );
    }
    if (current.depth > _defaultMaxDepth) {
      return MixSchemaError(
        code: MixSchemaErrorCode.limitExceeded,
        path: current.path,
        message: 'Payload exceeds the maximum depth of $_defaultMaxDepth.',
      );
    }

    final value = current.value;
    if (value == null) {
      return MixSchemaError(
        code: MixSchemaErrorCode.nullForbidden,
        path: current.path,
        message: 'Explicit JSON null is forbidden; omit the key instead.',
      );
    }

    if (value is JsonMap) {
      final markerError = _inspectControlMarkers(value, current.path);
      if (markerError != null) return markerError;

      for (final entry in value.entries.toList().reversed) {
        stack.add(
          _InputNode(
            entry.value,
            _joinPath(current.path, entry.key),
            current.depth + 1,
          ),
        );
      }
    } else if (value is List) {
      for (var i = value.length - 1; i >= 0; i -= 1) {
        stack.add(
          _InputNode(
            value[i],
            _joinPath(current.path, '$i'),
            current.depth + 1,
          ),
        );
      }
    }
  }

  return null;
}

MixSchemaError? _inspectControlMarkers(JsonMap value, String path) {
  if (value.containsKey(tokenReferenceKey)) {
    final tokenName = value[tokenReferenceKey];
    if (tokenName is String && !isValidTokenName(tokenName)) {
      return MixSchemaError(
        code: MixSchemaErrorCode.invalidTokenName,
        path: _joinPath(path, tokenReferenceKey),
        message: 'Token names must match [A-Za-z0-9_.-]{1,128}.',
        value: tokenName,
      );
    }

    for (final key in value.keys) {
      if (key == tokenReferenceKey || key == tokenKindKey) continue;

      return MixSchemaError(
        code: MixSchemaErrorCode.unknownField,
        path: _joinPath(path, key),
        message:
            'A token reference term may only contain "$tokenReferenceKey" '
            'and "$tokenKindKey".',
        value: key,
      );
    }

    return null;
  }

  for (final key in value.keys) {
    if (!key.startsWith(r'$')) continue;

    return MixSchemaError(
      code: MixSchemaErrorCode.unknownField,
      path: _joinPath(path, key),
      message: key == r'$merge'
          ? r'"$merge" is reserved for the phase 4 property grammar and is not supported in format v1 token terms.'
          : 'Unknown mix_schema control marker "$key".',
      value: key,
    );
  }

  return null;
}

final class _InputNode {
  const _InputNode(this.value, this.path, this.depth);

  final Object? value;
  final String path;
  final int depth;
}

Object? _deepMutableCopy(Object? value) {
  if (value is JsonMap) {
    return {
      for (final entry in value.entries)
        entry.key: _deepMutableCopy(entry.value),
    };
  }
  if (value is List) {
    return [for (final item in value) _deepMutableCopy(item)];
  }

  return value;
}

MixSchemaError _asWarning(MixSchemaError error, {String? path}) {
  return MixSchemaError(
    code: error.code,
    severity: MixSchemaDiagnosticSeverity.warning,
    path: path ?? error.path,
    message: error.message,
    value: error.value,
  );
}

final class _LenientRemovalJournal {
  final List<List<String>> _removals = [];

  String originalPathFor(String path) {
    var segments = _pathSegments(path);
    for (final removal in _removals.reversed) {
      segments = _translateAcrossRemoval(segments, removal);
    }

    return _pathFromSegments(segments);
  }

  void record(List<String> removalPath) {
    _removals.add(List.unmodifiable(removalPath));
  }

  List<String> _translateAcrossRemoval(
    List<String> segments,
    List<String> removal,
  ) {
    if (removal.isEmpty) return segments;
    final removedIndex = int.tryParse(removal.last);
    if (removedIndex == null) return segments;

    final listPath = removal.sublist(0, removal.length - 1);
    if (segments.length <= listPath.length ||
        !_startsWithSegments(segments, listPath)) {
      return segments;
    }

    final currentIndex = int.tryParse(segments[listPath.length]);
    if (currentIndex == null || currentIndex < removedIndex) return segments;

    return [
      ...segments.take(listPath.length),
      '${currentIndex + 1}',
      ...segments.skip(listPath.length + 1),
    ];
  }
}

List<String>? _lenientRemovalPath(MixSchemaError error) {
  if (!_isLenientSkippable(error)) return null;

  final segments = _pathSegments(error.path);
  if (segments.isEmpty) return null;
  if (segments.length == 1 &&
      (segments.single == 'type' || segments.single == _versionKey)) {
    return null;
  }

  final indexedContainer = _deepestIndexedContainer(segments);
  if (indexedContainer != null) {
    final (:container, :index) = indexedContainer;
    final entryPath = segments.sublist(0, index + 2);
    final afterEntry = segments.sublist(index + 2);
    if (container == 'variants' &&
        afterEntry.isNotEmpty &&
        afterEntry.first == 'style') {
      final afterStyle = afterEntry.sublist(1);
      if (afterStyle.isEmpty ||
          (afterStyle.length == 1 && afterStyle.single == 'type')) {
        return entryPath;
      }

      return segments.sublist(0, index + 3 + 1);
    }

    return entryPath;
  }

  return [segments.first];
}

bool _isLenientSkippable(MixSchemaError error) {
  return switch (error.code) {
    MixSchemaErrorCode.unknownField ||
    MixSchemaErrorCode.invalidEnum ||
    MixSchemaErrorCode.unknownType => true,
    _ => false,
  };
}

({String container, int index})? _deepestIndexedContainer(
  List<String> segments,
) {
  for (var i = segments.length - 2; i >= 0; i -= 1) {
    final segment = segments[i];
    if (segment != 'variants' && segment != 'modifiers') continue;
    if (int.tryParse(segments[i + 1]) == null) continue;

    return (container: segment, index: i);
  }

  return null;
}

enum _RemovalKind { mapProperty, listEntry }

_RemovalKind? _removePath(Object? root, List<String> path) {
  if (path.isEmpty) return null;

  Object? parent = root;
  for (final segment in path.take(path.length - 1)) {
    parent = switch (parent) {
      Map<String, Object?>() => parent[segment],
      List() => _readList(parent, segment),
      _ => null,
    };
    if (parent == null) return null;
  }

  final last = path.last;
  if (parent is Map<String, Object?>) {
    if (!parent.containsKey(last)) return null;
    parent.remove(last);

    return _RemovalKind.mapProperty;
  }
  if (parent is List) {
    final index = int.tryParse(last);
    if (index == null || index < 0 || index >= parent.length) return null;
    parent.removeAt(index);

    return _RemovalKind.listEntry;
  }

  return null;
}

Object? _readList(List<Object?> list, String segment) {
  final index = int.tryParse(segment);
  if (index == null || index < 0 || index >= list.length) return null;

  return list[index];
}

List<String> _pathSegments(String path) {
  var normalized = path;
  if (normalized.startsWith('#')) normalized = normalized.substring(1);
  if (normalized.isEmpty) return const [];
  if (normalized.startsWith('/')) normalized = normalized.substring(1);
  if (normalized.isEmpty) return const [];

  return normalized
      .split('/')
      .map((segment) => segment.replaceAll('~1', '/').replaceAll('~0', '~'))
      .toList(growable: false);
}

String _pathFromSegments(List<String> segments) {
  if (segments.isEmpty) return '';

  return '/${segments.map(_escapePathSegment).join('/')}';
}

String _escapePathSegment(String segment) {
  return segment.replaceAll('~', '~0').replaceAll('/', '~1');
}

bool _startsWithSegments(List<String> value, List<String> prefix) {
  if (value.length < prefix.length) return false;
  for (var i = 0; i < prefix.length; i += 1) {
    if (value[i] != prefix[i]) return false;
  }

  return true;
}

String _joinPath(String base, String segment) {
  final encoded = _escapePathSegment(segment);

  return base.isEmpty ? '/$encoded' : '$base/$encoded';
}

JsonMap _withVersionEnvelope(JsonMap schema) {
  final anyOf = schema['anyOf'];
  if (anyOf is List) {
    return {
      ...schema,
      'anyOf': [for (final branch in anyOf) _branchWithVersion(branch)],
    };
  }

  return _branchWithVersion(schema);
}

JsonMap _branchWithVersion(Object? branchValue) {
  if (branchValue is! JsonMap) return {'v': branchValue};

  final properties = Map<String, Object?>.from(
    (branchValue['properties'] as Map?) ?? const {},
  );
  final required = [
    _versionKey,
    ...(branchValue['required'] as List? ?? const []).cast<String>(),
  ];

  return {
    ...branchValue,
    'properties': {
      ...properties,
      _versionKey: {'type': 'integer', 'const': mixSchemaFormatVersion},
    },
    'required': required.toSet().toList(growable: false),
  };
}

void _validateThemeEnvelope(JsonMap data, List<MixSchemaError> errors) {
  if (!data.containsKey('type')) {
    errors.add(
      const MixSchemaError(
        code: MixSchemaErrorCode.requiredField,
        path: '/type',
        message: 'Theme documents require type "theme".',
      ),
    );
  } else if (data['type'] != _themeWireType) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.unknownType,
        path: '/type',
        message: 'Theme document type must be "theme".',
        value: data['type'],
      ),
    );
  }

  final allowed = {'type', for (final kind in _themeTokenKinds) kind.field};
  for (final key in data.keys) {
    if (allowed.contains(key)) continue;
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.unknownField,
        path: _joinPath('', key),
        message: 'Unknown theme document field "$key".',
        value: key,
      ),
    );
  }
}

void _decodeThemeKind(
  JsonMap data,
  _ThemeTokenKind kind,
  _ThemeDecodeState state,
  List<MixSchemaError> errors,
) {
  final rawMap = data[kind.field];
  if (rawMap == null) return;
  final mapPath = _joinPath('', kind.field);
  final map = _themeJsonMap(rawMap);
  if (map == null) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.typeMismatch,
        path: mapPath,
        message: 'Theme field "${kind.field}" must be an object map.',
        value: rawMap,
      ),
    );
    return;
  }

  for (final entry in map.entries) {
    final name = entry.key;
    final valuePath = _joinPath(mapPath, name);
    if (!isValidTokenName(name)) {
      errors.add(
        MixSchemaError(
          code: MixSchemaErrorCode.invalidTokenName,
          path: valuePath,
          message: 'Token names must match [A-Za-z0-9_.-]{1,128}.',
          value: name,
        ),
      );
      continue;
    }

    final alias = _readThemeAlias(kind, entry.value, valuePath, errors);
    if (alias != null) {
      state.addAlias(kind, name, alias, valuePath);
      continue;
    }

    final nestedTokenPath = _findNestedTokenMarker(entry.value, valuePath);
    if (nestedTokenPath != null) {
      errors.add(
        MixSchemaError(
          code: MixSchemaErrorCode.constraintViolation,
          path: nestedTokenPath,
          message:
              'Theme token values must be concrete; token references are only '
              'allowed as same-kind whole-value aliases.',
        ),
      );
      continue;
    }

    final result = kind.valueSchema.safeParse(entry.value);
    if (result.isFail) {
      errors.addAll(
        _withPathPrefix(mapSchemaError(result.getError()), valuePath),
      );
      continue;
    }

    state.addLiteral(kind, name, result.getOrNull()!);
  }
}

JsonMap? _themeJsonMap(Object? value) {
  if (value is JsonMap) return value;
  if (value is! Map) return null;
  if (value.keys.any((key) => key is! String)) return null;

  return Map<String, Object?>.from(value);
}

String? _readThemeAlias(
  _ThemeTokenKind kind,
  Object? value,
  String valuePath,
  List<MixSchemaError> errors,
) {
  if (value is! JsonMap || !value.containsKey(tokenReferenceKey)) return null;

  final rawTarget = value[tokenReferenceKey];
  if (rawTarget is! String) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.typeMismatch,
        path: _joinPath(valuePath, tokenReferenceKey),
        message: 'Theme token aliases require a string "$tokenReferenceKey".',
        value: rawTarget,
      ),
    );
    return null;
  }
  if (!isValidTokenName(rawTarget)) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.invalidTokenName,
        path: _joinPath(valuePath, tokenReferenceKey),
        message: 'Token names must match [A-Za-z0-9_.-]{1,128}.',
        value: rawTarget,
      ),
    );
    return null;
  }

  final rawKind = value[tokenKindKey];
  if (rawKind != null && kind.aliasKind == null) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.unknownField,
        path: _joinPath(valuePath, tokenKindKey),
        message:
            'Theme aliases may use "$tokenKindKey" only for spaces or doubles.',
        value: rawKind,
      ),
    );
    return null;
  }
  if (rawKind != null && rawKind != kind.aliasKind) {
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.constraintViolation,
        path: _joinPath(valuePath, tokenKindKey),
        message:
            'Theme aliases must stay within the "${kind.field}" token kind.',
        value: rawKind,
      ),
    );
    return null;
  }

  return rawTarget;
}

Map<MixToken, Object> _resolveThemeAliases(
  _ThemeDecodeState state,
  List<MixSchemaError> errors,
) {
  final allNamesByField = {
    for (final kind in _themeTokenKinds) kind.field: state.namesFor(kind),
  };
  final tokens = <MixToken, Object>{};
  for (final kind in _themeTokenKinds) {
    final resolved = <String, Object>{};
    final names = state.namesFor(kind).toList(growable: false)..sort();
    for (final name in names) {
      final value = _resolveThemeAliasName(
        kind: kind,
        name: name,
        state: state,
        allNamesByField: allNamesByField,
        resolved: resolved,
        stack: const [],
        errors: errors,
      );
      if (value != null) tokens[kind.createToken(name)] = value;
    }
  }

  return tokens;
}

Object? _resolveThemeAliasName({
  required _ThemeTokenKind kind,
  required String name,
  required _ThemeDecodeState state,
  required Map<String, Set<String>> allNamesByField,
  required Map<String, Object> resolved,
  required List<String> stack,
  required List<MixSchemaError> errors,
}) {
  final cached = resolved[name];
  if (cached != null) return cached;

  final literal = state.literal(kind, name);
  if (literal != null) {
    resolved[name] = literal;
    return literal;
  }

  final target = state.aliasTarget(kind, name);
  if (target == null) return null;
  final aliasPath = _joinPath(state.aliasPath(kind, name), tokenReferenceKey);
  if (stack.contains(target)) {
    final cycle = [...stack, name, target].join(' -> ');
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.constraintViolation,
        path: aliasPath,
        message: 'Theme token alias cycle detected: $cycle.',
        value: target,
      ),
    );
    return null;
  }

  final sameKindNames = allNamesByField[kind.field] ?? const <String>{};
  if (!sameKindNames.contains(target)) {
    String? crossKindField;
    for (final entry in allNamesByField.entries) {
      if (entry.key == kind.field) continue;
      if (!entry.value.contains(target)) continue;
      crossKindField = entry.key;
      break;
    }
    errors.add(
      MixSchemaError(
        code: MixSchemaErrorCode.constraintViolation,
        path: aliasPath,
        message: crossKindField == null
            ? 'Theme token alias target "$target" was not found.'
            : 'Theme token alias target "$target" belongs to '
                  '"$crossKindField", not "${kind.field}".',
        value: target,
      ),
    );
    return null;
  }

  final value = _resolveThemeAliasName(
    kind: kind,
    name: target,
    state: state,
    allNamesByField: allNamesByField,
    resolved: resolved,
    stack: [...stack, name],
    errors: errors,
  );
  if (value != null) resolved[name] = value;

  return value;
}

String? _findNestedTokenMarker(Object? value, String path) {
  if (value is JsonMap) {
    if (value.containsKey(tokenReferenceKey)) {
      return _joinPath(path, tokenReferenceKey);
    }
    for (final entry in value.entries) {
      final found = _findNestedTokenMarker(
        entry.value,
        _joinPath(path, entry.key),
      );
      if (found != null) return found;
    }
  } else if (value is List) {
    for (var i = 0; i < value.length; i += 1) {
      final found = _findNestedTokenMarker(value[i], _joinPath(path, '$i'));
      if (found != null) return found;
    }
  }

  return null;
}

List<MixSchemaError> _withPathPrefix(
  List<MixSchemaError> errors,
  String prefix,
) {
  return [
    for (final error in errors)
      MixSchemaError(
        code: error.code,
        path: error.path.isEmpty ? prefix : '$prefix${error.path}',
        message: error.message,
        value: error.value,
        severity: error.severity,
      ),
  ];
}

JsonMap _themeJsonSchema() {
  return {
    'type': 'object',
    'properties': {
      'type': {'type': 'string', 'const': _themeWireType},
      for (final kind in _themeTokenKinds)
        kind.field: _themeMapJsonSchema(kind),
    },
    'required': ['type'],
    'additionalProperties': false,
  };
}

JsonMap _themeMapJsonSchema(_ThemeTokenKind kind) {
  return {
    'type': 'object',
    'propertyNames': {'type': 'string', 'pattern': _tokenNamePatternSchema},
    'additionalProperties': {
      'anyOf': [kind.valueSchema.toJsonSchema(), _themeAliasJsonSchema(kind)],
    },
  };
}

JsonMap _themeAliasJsonSchema(_ThemeTokenKind kind) {
  return {
    'type': 'object',
    'properties': {
      tokenReferenceKey: {'type': 'string', 'pattern': _tokenNamePatternSchema},
      if (kind.aliasKind != null)
        tokenKindKey: {'type': 'string', 'const': kind.aliasKind},
    },
    'required': [tokenReferenceKey],
    'additionalProperties': false,
  };
}

_ThemeTokenKind? _themeKindForToken(MixToken token) {
  for (final kind in _themeTokenKinds) {
    if (kind.matches(token)) return kind;
  }

  return null;
}

AckSchema<Object, Object> _eraseBoundary(AckSchema<dynamic, dynamic> schema) {
  return schema as AckSchema<Object, Object>;
}

CodecSchema<JsonMap, TextStyle> _themeTextStyleCodec() {
  return Ack.object({
    'color': colorLiteralCodec().optional(),
    'backgroundColor': colorLiteralCodec().optional(),
    'fontSize': numberAsDoubleCodec().optional(),
    'fontWeight': fontWeightLiteralCodec().optional(),
    'fontStyle': fontStyleCodec().optional(),
    'letterSpacing': numberAsDoubleCodec().optional(),
    'wordSpacing': numberAsDoubleCodec().optional(),
    'height': numberAsDoubleCodec().optional(),
    'fontFamily': Ack.string().optional(),
    'decoration': textDecorationCodec().optional(),
    'decorationColor': colorLiteralCodec().optional(),
    'decorationStyle': textDecorationStyleCodec().optional(),
    'decorationThickness': numberAsDoubleCodec().optional(),
    'shadows': _themeShadowListCodec().optional(),
  }).codec<TextStyle>(
    decode: (data) => TextStyle(
      color: data['color'] as Color?,
      backgroundColor: data['backgroundColor'] as Color?,
      fontSize: data['fontSize'] as double?,
      fontWeight: data['fontWeight'] as FontWeight?,
      fontStyle: data['fontStyle'] as FontStyle?,
      letterSpacing: data['letterSpacing'] as double?,
      wordSpacing: data['wordSpacing'] as double?,
      height: data['height'] as double?,
      fontFamily: data['fontFamily'] as String?,
      decoration: data['decoration'] as TextDecoration?,
      decorationColor: data['decorationColor'] as Color?,
      decorationStyle: data['decorationStyle'] as TextDecorationStyle?,
      decorationThickness: data['decorationThickness'] as double?,
      shadows: data['shadows'] as List<Shadow>?,
    ),
    encode: _encodeThemeTextStyle,
  );
}

JsonMap _encodeThemeTextStyle(TextStyle value) {
  failIfPresent(value.debugLabel, 'theme.textStyle.debugLabel');
  failIfPresent(value.fontFamilyFallback, 'theme.textStyle.fontFamilyFallback');
  failIfPresent(value.fontFeatures, 'theme.textStyle.fontFeatures');
  failIfPresent(value.fontVariations, 'theme.textStyle.fontVariations');
  failIfPresent(value.foreground, 'theme.textStyle.foreground');
  failIfPresent(value.background, 'theme.textStyle.background');
  failIfPresent(value.textBaseline, 'theme.textStyle.textBaseline');
  failIfPresent(value.locale, 'theme.textStyle.locale');
  failIfPresent(
    value.leadingDistribution,
    'theme.textStyle.leadingDistribution',
  );
  failIfPresent(value.overflow, 'theme.textStyle.overflow');
  if (!value.inherit) {
    failIfPresent(value.inherit, 'theme.textStyle.inherit');
  }

  return {
    'color': value.color,
    'backgroundColor': value.backgroundColor,
    'fontSize': value.fontSize,
    'fontWeight': value.fontWeight,
    'fontStyle': value.fontStyle,
    'letterSpacing': value.letterSpacing,
    'wordSpacing': value.wordSpacing,
    'height': value.height,
    'fontFamily': value.fontFamily,
    'decoration': value.decoration,
    'decorationColor': value.decorationColor,
    'decorationStyle': value.decorationStyle,
    'decorationThickness': value.decorationThickness,
    'shadows': value.shadows,
  };
}

CodecSchema<JsonMap, BorderSide> _themeBorderSideCodec() {
  return Ack.object({
    'color': colorLiteralCodec().optional(),
    'width': nonNegativeDoubleCodec().optional(),
    'style': enumCodec({
      'none': BorderStyle.none,
      'solid': BorderStyle.solid,
    }, debugName: 'BorderStyle').optional(),
    'strokeAlign': numberAsDoubleCodec().optional(),
  }).codec<BorderSide>(
    decode: (data) => BorderSide(
      color: (data['color'] as Color?) ?? const BorderSide().color,
      width: (data['width'] as double?) ?? const BorderSide().width,
      style: (data['style'] as BorderStyle?) ?? const BorderSide().style,
      strokeAlign:
          (data['strokeAlign'] as double?) ?? const BorderSide().strokeAlign,
    ),
    encode: (value) => {
      'color': value.color,
      'width': value.width,
      'style': value.style,
      'strokeAlign': value.strokeAlign,
    },
  );
}

CodecSchema<List<JsonMap>, List<Shadow>> _themeShadowListCodec() {
  return Ack.list(
    _themeShadowCodec(),
  ).codec<List<Shadow>>(decode: (value) => value, encode: (value) => value);
}

CodecSchema<JsonMap, Shadow> _themeShadowCodec() {
  return Ack.object({
    'color': colorLiteralCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': numberAsDoubleCodec().optional(),
  }).codec<Shadow>(
    decode: (data) => Shadow(
      color: (data['color'] as Color?) ?? const Shadow().color,
      offset: (data['offset'] as Offset?) ?? const Shadow().offset,
      blurRadius: (data['blurRadius'] as double?) ?? const Shadow().blurRadius,
    ),
    encode: (value) => {
      'color': value.color,
      'offset': value.offset,
      'blurRadius': value.blurRadius,
    },
  );
}

CodecSchema<List<JsonMap>, List<BoxShadow>> _themeBoxShadowListCodec() {
  return Ack.list(
    _themeBoxShadowCodec(),
  ).codec<List<BoxShadow>>(decode: (value) => value, encode: (value) => value);
}

CodecSchema<JsonMap, BoxShadow> _themeBoxShadowCodec() {
  return Ack.object({
    'color': colorLiteralCodec().optional(),
    'offset': offsetCodec().optional(),
    'blurRadius': numberAsDoubleCodec().optional(),
    'spreadRadius': numberAsDoubleCodec().optional(),
  }).codec<BoxShadow>(
    decode: (data) => BoxShadow(
      color: (data['color'] as Color?) ?? const BoxShadow().color,
      offset: (data['offset'] as Offset?) ?? const BoxShadow().offset,
      blurRadius:
          (data['blurRadius'] as double?) ?? const BoxShadow().blurRadius,
      spreadRadius:
          (data['spreadRadius'] as double?) ?? const BoxShadow().spreadRadius,
    ),
    encode: (value) => {
      'color': value.color,
      'offset': value.offset,
      'blurRadius': value.blurRadius,
      'spreadRadius': value.spreadRadius,
    },
  );
}

CodecSchema<JsonMap, Breakpoint> _themeBreakpointCodec() {
  return Ack.object({
        'minWidth': numberAsDoubleCodec().optional(),
        'maxWidth': numberAsDoubleCodec().optional(),
        'minHeight': numberAsDoubleCodec().optional(),
        'maxHeight': numberAsDoubleCodec().optional(),
      })
      .constrain(const _ThemeBreakpointBoundsConstraint())
      .codec<Breakpoint>(
        decode: (data) => Breakpoint(
          minWidth: data['minWidth'] as double?,
          maxWidth: data['maxWidth'] as double?,
          minHeight: data['minHeight'] as double?,
          maxHeight: data['maxHeight'] as double?,
        ),
        encode: (value) => {
          'minWidth': value.minWidth,
          'maxWidth': value.maxWidth,
          'minHeight': value.minHeight,
          'maxHeight': value.maxHeight,
        },
      );
}

CodecSchema<int, Duration> _themeDurationCodec() {
  return Ack.integer()
      .min(0)
      .codec<Duration>(
        decode: (value) => Duration(milliseconds: value),
        encode: (value) => value.inMilliseconds,
      );
}

final class _ThemeTokenKind {
  const _ThemeTokenKind({
    required this.field,
    required this.tokenType,
    required this.createToken,
    required this.valueSchema,
    this.aliasKind,
  });

  final String field;
  final Type tokenType;
  final MixToken Function(String name) createToken;
  final AckSchema<Object, Object> valueSchema;
  final String? aliasKind;

  bool matches(MixToken token) => token.runtimeType == tokenType;
}

final class _ThemeDecodeState {
  final Map<String, Map<String, Object>> _literals = {};
  final Map<String, Map<String, String>> _aliases = {};
  final Map<String, Map<String, String>> _aliasPaths = {};

  void addLiteral(_ThemeTokenKind kind, String name, Object value) {
    (_literals[kind.field] ??= {})[name] = value;
  }

  void addAlias(_ThemeTokenKind kind, String name, String target, String path) {
    (_aliases[kind.field] ??= {})[name] = target;
    (_aliasPaths[kind.field] ??= {})[name] = path;
  }

  Object? literal(_ThemeTokenKind kind, String name) {
    return _literals[kind.field]?[name];
  }

  String? aliasTarget(_ThemeTokenKind kind, String name) {
    return _aliases[kind.field]?[name];
  }

  String aliasPath(_ThemeTokenKind kind, String name) {
    return _aliasPaths[kind.field]?[name] ?? _joinPath('/${kind.field}', name);
  }

  Set<String> namesFor(_ThemeTokenKind kind) {
    return {...?_literals[kind.field]?.keys, ...?_aliases[kind.field]?.keys};
  }
}

final class _ThemeBreakpointBoundsConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _ThemeBreakpointBoundsConstraint()
    : super(
        constraintKey: 'mix_schema_theme_breakpoint_bounds',
        description: 'Theme breakpoints require at least one bound.',
      );

  @override
  bool isValid(JsonMap value) {
    return value['minWidth'] != null ||
        value['maxWidth'] != null ||
        value['minHeight'] != null ||
        value['maxHeight'] != null;
  }

  @override
  String buildMessage(JsonMap value) {
    return 'Theme breakpoints require at least one min/max width or height.';
  }
}
