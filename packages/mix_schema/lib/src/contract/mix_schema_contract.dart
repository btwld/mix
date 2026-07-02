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

/// Current `mix_schema` wire-format version for top-level style documents.
const mixSchemaFormatVersion = 1;

const int _defaultMaxDepth = 64;
const int _defaultMaxNodes = 10000;
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
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixSchemaValidationFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;

    final registryBackedError = _missingRegistryBackedBranchForPayload(
      ready.payload,
    );
    if (registryBackedError != null) {
      return MixSchemaValidationFailure([registryBackedError]);
    }

    final result = rootSchema.safeParse(ready.payload);
    if (result.isOk) {
      return MixSchemaValidationSuccess(warnings: ready.warnings);
    }

    return MixSchemaValidationFailure(mapSchemaError(result.getError()));
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

    final result = rootSchema.safeParse(ready.payload);
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

    final result = rootSchema.safeEncode(value);
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

    for (var attempt = 0; attempt < _defaultMaxNodes; attempt += 1) {
      final result = rootSchema.safeParse(current);
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
        if (!_removePath(current, removalPath)) continue;
        warnings.add(_asWarning(error));
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

    return MixSchemaDecodeFailure([
      const MixSchemaError(
        code: MixSchemaErrorCode.limitExceeded,
        path: '',
        message: 'Lenient decode exceeded its cleanup iteration limit.',
      ),
    ], warnings: List.unmodifiable(warnings));
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

MixSchemaError _asWarning(MixSchemaError error) {
  return MixSchemaError(
    code: error.code,
    severity: MixSchemaDiagnosticSeverity.warning,
    path: error.path,
    message: error.message,
    value: error.value,
  );
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

bool _removePath(Object? root, List<String> path) {
  if (path.isEmpty) return false;

  Object? parent = root;
  for (final segment in path.take(path.length - 1)) {
    parent = switch (parent) {
      Map<String, Object?>() => parent[segment],
      List() => _readList(parent, segment),
      _ => null,
    };
    if (parent == null) return false;
  }

  final last = path.last;
  if (parent is Map<String, Object?>) {
    if (!parent.containsKey(last)) return false;
    parent.remove(last);

    return true;
  }
  if (parent is List) {
    final index = int.tryParse(last);
    if (index == null || index < 0 || index >= parent.length) return false;
    parent.removeAt(index);

    return true;
  }

  return false;
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

String _joinPath(String base, String segment) {
  final encoded = segment.replaceAll('~', '~0').replaceAll('/', '~1');

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
