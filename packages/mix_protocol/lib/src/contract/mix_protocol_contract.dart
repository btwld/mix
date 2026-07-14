import 'package:ack/ack.dart' hide JsonMap;
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
        MixToken,
        RadiusToken,
        ShadowToken,
        SpaceToken,
        TextStyleToken;

import 'identity_resolution.dart';
import 'json_map.dart';
import '../errors/mix_protocol_error.dart';
import '../errors/schema_error_mapper.dart';
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
const mixProtocolVersion = '1.0.0';

/// Current `mix_protocol` wire-format version for top-level style documents.
const mixProtocolFormatVersion = 1;

const int _defaultMaxDepth = 64;
const int _defaultMaxNodes = 10000;
const int _defaultMaxLenientRemovals = 256;
const String _versionKey = 'v';

/// Decode behavior for forward-compatible payloads.
enum MixProtocolDecodeMode {
  /// Reject unknown fields, discriminators, and enum values.
  strict,

  /// Skip unknown values at the smallest enclosing style field or list entry.
  lenient,
}

/// Options for decoding a style document.
final class MixProtocolDecodeOptions {
  /// Creates decode options.
  const MixProtocolDecodeOptions({
    this.mode = MixProtocolDecodeMode.strict,
    this.resolveIcon,
    this.resolveImage,
  });

  /// How unknown fields, discriminators, and enum values are handled.
  final MixProtocolDecodeMode mode;

  /// Resolves string icon identities for icon styler payloads.
  final MixProtocolIconResolver? resolveIcon;

  /// Resolves string image identities for image styler payloads.
  final MixProtocolImageResolver? resolveImage;
}

/// Options for encoding runtime identity values.
final class MixProtocolEncodeOptions {
  /// Creates encode options.
  const MixProtocolEncodeOptions({
    this.iconNames = const {},
    this.imageNames = const {},
  });

  /// Optional names to emit for icon identities before falling back to value
  /// forms.
  final Map<String, IconData> iconNames;

  /// Optional names to emit for image identities before supported value forms.
  final Map<String, ImageProvider<Object>> imageNames;
}

/// Shared protocol instance for built-in Mix styles and token themes.
final MixProtocol mixProtocol = MixProtocol._builtIn();

/// Versioned JSON protocol for representable Mix styles and token themes.
final class MixProtocol {
  factory MixProtocol._builtIn() {
    final identityContext = MixProtocolIdentityContextHolder();
    late final AckSchema<JsonMap, Object> rootSchema;
    final rootSchemaRef = Ack.lazy<JsonMap, Object>(
      'mix_protocol_style',
      () => rootSchema,
    );
    final branches = <String, AckSchema<JsonMap, Object>>{
      schemaTypeBox: widenStylerBranch(
        boxStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeBox,
      ),
      schemaTypeText: widenStylerBranch(
        textStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeText,
      ),
      schemaTypeFlex: widenStylerBranch(
        flexStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeFlex,
      ),
      schemaTypeStack: widenStylerBranch(
        stackStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeStack,
      ),
      schemaTypeIcon: widenStylerBranch(
        iconStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeIcon,
      ),
      schemaTypeImage: widenStylerBranch(
        imageStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeImage,
      ),
      schemaTypeFlexBox: widenStylerBranch(
        flexBoxStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeFlexBox,
      ),
      schemaTypeStackBox: widenStylerBranch(
        stackBoxStylerCodec(
          rootStyleSchema: rootSchemaRef,
          identityContext: () => identityContext.current,
        ),
        debugName: schemaTypeStackBox,
      ),
    };
    rootSchema = Ack.discriminated<Object>(
      discriminatorKey: 'type',
      schemas: branches,
    );

    return MixProtocol._(
      rootSchema: rootSchema,
      identityContext: identityContext,
    );
  }

  const MixProtocol._({
    required AckSchema<JsonMap, Object> rootSchema,
    required MixProtocolIdentityContextHolder identityContext,
  }) : _rootSchema = rootSchema,
       _identityContext = identityContext;

  final AckSchema<JsonMap, Object> _rootSchema;
  final MixProtocolIdentityContextHolder _identityContext;

  /// Decodes [payload] as a built-in Mix styler of type [T].
  MixProtocolResult<T> decodeStyle<T extends Object>(
    Object? payload, {
    MixProtocolDecodeOptions options = const MixProtocolDecodeOptions(),
  }) {
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixProtocolFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;

    if (options.mode == MixProtocolDecodeMode.lenient) {
      return _withIdentityContext(
        _decodeContext(options),
        () => _decodeLenient<T>(ready.payload, ready.warnings),
      );
    }

    final result = _withIdentityContext(
      _decodeContext(options),
      () => _rootSchema.safeParse(ready.payload),
    );
    if (result.isFail) {
      return MixProtocolFailure(
        mapSchemaError(result.getError()),
        warnings: ready.warnings,
      );
    }

    final value = result.getOrNull();
    if (value is T) {
      return MixProtocolSuccess<T>(value, warnings: ready.warnings);
    }

    return MixProtocolFailure([
      MixProtocolError(
        code: MixProtocolErrorCode.typeMismatch,
        path: '',
        message: 'Decoded value is ${value.runtimeType}, expected $T.',
        value: value,
      ),
    ], warnings: ready.warnings);
  }

  /// Encodes a representable built-in Mix styler.
  MixProtocolResult<JsonMap> encodeStyle(
    Object value, {
    MixProtocolEncodeOptions options = const MixProtocolEncodeOptions(),
  }) {
    final result = _withIdentityContext(
      _encodeContext(options),
      () => _rootSchema.safeEncode(value),
    );
    if (result.isFail) {
      return MixProtocolFailure<JsonMap>(
        _withoutRootEncodeBranchNoise(mapSchemaError(result.getError())),
      );
    }

    final encoded = result.getOrNull();

    return MixProtocolSuccess<JsonMap>({
      ...encoded!,
      _versionKey: mixProtocolFormatVersion,
    });
  }

  R _withIdentityContext<R>(
    MixProtocolIdentityContext context,
    R Function() run,
  ) {
    final previous = _identityContext.current;
    _identityContext.current = context;
    try {
      return run();
    } finally {
      _identityContext.current = previous;
    }
  }

  MixProtocolIdentityContext _decodeContext(MixProtocolDecodeOptions options) {
    return MixProtocolIdentityContext(
      resolveIcon: options.resolveIcon,
      resolveImage: options.resolveImage,
    );
  }

  MixProtocolIdentityContext _encodeContext(MixProtocolEncodeOptions options) {
    return MixProtocolIdentityContext(
      iconNames: options.iconNames,
      imageNames: options.imageNames,
    );
  }

  List<MixProtocolError> _withoutRootEncodeBranchNoise(
    List<MixProtocolError> errors,
  ) {
    final hasSpecificError = errors.any((error) => error.path.isNotEmpty);
    if (!hasSpecificError) return errors;

    return errors
        .where(
          (error) =>
              error.path.isNotEmpty ||
              error.code != MixProtocolErrorCode.unsupportedEncodeValue ||
              !error.message.startsWith('Expected '),
        )
        .toList(growable: false);
  }

  /// Exports the built-in style shape as draft-07 JSON Schema metadata.
  JsonMap exportStyleJsonSchema() {
    final exported = _withPropertyTermDefinitions(
      _withVersionEnvelope(
        Map<String, Object?>.from(_rootSchema.toJsonSchema()),
      ),
    );

    return {
      r'$schema': 'http://json-schema.org/draft-07/schema#',
      ...exported,
      'x-mix-protocol-contract': 'mix_protocol',
      'x-mix-protocol-version': mixProtocolVersion,
      'x-mix-protocol-format-version': mixProtocolFormatVersion,
    };
  }

  /// Decodes a strict versioned token-theme document.
  MixProtocolResult<MixProtocolTheme> decodeTheme(Object? payload) {
    return const _MixProtocolThemeCodec().decode(payload);
  }

  /// Encodes a canonical versioned token-theme document.
  MixProtocolResult<JsonMap> encodeTheme(MixProtocolTheme theme) {
    return const _MixProtocolThemeCodec().encode(theme);
  }

  /// Exports the token-theme shape as draft-07 JSON Schema metadata.
  JsonMap exportThemeJsonSchema() {
    return const _MixProtocolThemeCodec().exportJsonSchema();
  }

  MixProtocolResult<T> _decodeLenient<T extends Object>(
    Object? payload,
    List<MixProtocolError> initialWarnings,
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
          return MixProtocolSuccess<T>(
            value,
            warnings: List.unmodifiable(warnings),
          );
        }

        return MixProtocolFailure([
          MixProtocolError(
            code: MixProtocolErrorCode.typeMismatch,
            path: '',
            message: 'Decoded value is ${value.runtimeType}, expected $T.',
            value: value,
          ),
        ], warnings: List.unmodifiable(warnings));
      }

      final errors = mapSchemaError(result.getError());
      var changed = false;
      final repair = _lenientRepairCandidate(errors);
      if (repair != null) {
        final (:error, :removalPath) = repair;
        if (removals >= _defaultMaxLenientRemovals) {
          return MixProtocolFailure([
            const MixProtocolError(
              code: MixProtocolErrorCode.limitExceeded,
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
          _repairAfterListEntryRemoval(current, removalPath);
        }
        removals += 1;
        changed = true;
      }

      if (!changed) {
        return MixProtocolFailure(
          errors,
          warnings: List.unmodifiable(warnings),
        );
      }
    }
  }
}

/// Decoded theme document containing flat token values ready for `MixScope`.
final class MixProtocolTheme {
  /// Creates a theme document from canonical Mix token values.
  MixProtocolTheme({required Map<MixToken, Object> tokens})
    : tokens = Map.unmodifiable(tokens);

  /// Flat token map suitable for `MixScope(tokens:)`.
  final Map<MixToken, Object> tokens;
}

/// Internal codec for versioned `type: "theme"` token documents.
final class _MixProtocolThemeCodec {
  /// Creates the built-in theme document codec.
  const _MixProtocolThemeCodec();

  /// Decodes [payload] into a flat token map.
  MixProtocolResult<MixProtocolTheme> decode(Object? payload) {
    final prepared = _preparePayload(payload);
    if (prepared case _PreparedPayloadFailure(:final error)) {
      return MixProtocolFailure([error]);
    }
    final ready = prepared as _PreparedPayloadSuccess;
    final data = ready.payload;
    if (data is! JsonMap) {
      return MixProtocolFailure([
        MixProtocolError(
          code: MixProtocolErrorCode.typeMismatch,
          path: '',
          message: 'Theme documents must be JSON objects.',
          value: data,
        ),
      ], warnings: ready.warnings);
    }

    final errors = <MixProtocolError>[];
    _validateThemeEnvelope(data, errors);
    if (errors.isNotEmpty) {
      return MixProtocolFailure(errors, warnings: ready.warnings);
    }

    final state = _ThemeDecodeState();
    for (final kind in _themeTokenKinds) {
      _decodeThemeKind(data, kind, state, errors);
    }
    final tokens = _resolveThemeAliases(state, errors);
    if (errors.isNotEmpty) {
      return MixProtocolFailure(errors, warnings: ready.warnings);
    }

    return MixProtocolSuccess(
      MixProtocolTheme(tokens: tokens),
      warnings: ready.warnings,
    );
  }

  /// Encodes [document] as a canonical versioned theme document.
  MixProtocolResult<JsonMap> encode(MixProtocolTheme document) {
    final errors = <MixProtocolError>[];
    final grouped = {
      for (final kind in _themeTokenKinds) kind.field: <String, Object>{},
    };

    for (final entry in document.tokens.entries) {
      final token = entry.key;
      final kind = _themeKindForToken(token);
      if (kind == null) {
        errors.add(
          MixProtocolError(
            code: MixProtocolErrorCode.unsupportedEncodeValue,
            path: '',
            message:
                'Theme documents can only encode canonical mix_protocol token '
                'classes; got ${token.runtimeType}.',
            value: token,
          ),
        );
        continue;
      }

      final path = _joinPath('/${kind.field}', token.name);
      if (!isValidTokenName(token.name)) {
        errors.add(
          MixProtocolError(
            code: MixProtocolErrorCode.invalidTokenName,
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
          MixProtocolError(
            code: MixProtocolErrorCode.constraintViolation,
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

    if (errors.isNotEmpty) return MixProtocolFailure<JsonMap>(errors);

    return MixProtocolSuccess<JsonMap>({
      _versionKey: mixProtocolFormatVersion,
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
      'x-mix-protocol-contract': 'mix_protocol_theme',
      'x-mix-protocol-version': mixProtocolVersion,
      'x-mix-protocol-format-version': mixProtocolFormatVersion,
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
  final List<MixProtocolError> warnings;
}

final class _PreparedPayloadFailure extends _PreparedPayload {
  const _PreparedPayloadFailure(this.error);

  final MixProtocolError error;
}

_PreparedPayload _preparePayload(Object? payload) {
  if (payload is JsonMap &&
      payload.containsKey(_versionKey) &&
      payload[_versionKey] == null) {
    return const _PreparedPayloadFailure(
      MixProtocolError(
        code: MixProtocolErrorCode.unsupportedVersion,
        path: '/v',
        message: 'mix_protocol format version must be integer 1.',
      ),
    );
  }

  final preflightError = _inspectInput(payload);
  if (preflightError != null) return _PreparedPayloadFailure(preflightError);

  const warnings = <MixProtocolError>[];
  if (payload is! JsonMap) return _PreparedPayloadSuccess(payload, warnings);

  final rawVersion = payload[_versionKey];
  if (!payload.containsKey(_versionKey)) {
    return const _PreparedPayloadFailure(
      MixProtocolError(
        code: MixProtocolErrorCode.requiredField,
        path: '/v',
        message: 'Top-level documents require integer format version 1.',
      ),
    );
  } else if (rawVersion is! int) {
    return _PreparedPayloadFailure(
      MixProtocolError(
        code: MixProtocolErrorCode.unsupportedVersion,
        path: '/v',
        message:
            'mix_protocol format version must be integer '
            '$mixProtocolFormatVersion.',
        value: rawVersion,
      ),
    );
  } else if (rawVersion != mixProtocolFormatVersion) {
    return _PreparedPayloadFailure(
      MixProtocolError(
        code: MixProtocolErrorCode.unsupportedVersion,
        path: '/v',
        message:
            'Unsupported mix_protocol format version $rawVersion; this decoder '
            'supports version $mixProtocolFormatVersion.',
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

MixProtocolError? _inspectInput(Object? payload) {
  var nodes = 0;
  final stack = [_InputNode(payload, '', 1)];

  while (stack.isNotEmpty) {
    final current = stack.removeLast();
    nodes += 1;
    if (nodes > _defaultMaxNodes) {
      return MixProtocolError(
        code: MixProtocolErrorCode.limitExceeded,
        path: current.path,
        message: 'Payload exceeds the maximum node count of $_defaultMaxNodes.',
      );
    }
    if (current.depth > _defaultMaxDepth) {
      return MixProtocolError(
        code: MixProtocolErrorCode.limitExceeded,
        path: current.path,
        message: 'Payload exceeds the maximum depth of $_defaultMaxDepth.',
      );
    }

    final value = current.value;
    if (value == null) {
      return MixProtocolError(
        code: MixProtocolErrorCode.nullForbidden,
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

MixProtocolError? _inspectControlMarkers(JsonMap value, String path) {
  if (value.containsKey(tokenReferenceKey)) {
    final tokenName = value[tokenReferenceKey];
    if (tokenName is String && !isValidTokenName(tokenName)) {
      return MixProtocolError(
        code: MixProtocolErrorCode.invalidTokenName,
        path: _joinPath(path, tokenReferenceKey),
        message: 'Token names must match [A-Za-z0-9_.-]{1,128}.',
        value: tokenName,
      );
    }

    for (final key in value.keys) {
      if (key == tokenReferenceKey ||
          key == tokenKindKey ||
          key == applyDirectivesKey) {
        continue;
      }

      return MixProtocolError(
        code: MixProtocolErrorCode.unknownField,
        path: _joinPath(path, key),
        message:
            'A token reference term may only contain "$tokenReferenceKey" '
            '"$tokenKindKey", and "$applyDirectivesKey".',
        value: key,
      );
    }

    return null;
  }

  if (value.containsKey(mergeReferenceKey)) {
    for (final key in value.keys) {
      if (key == mergeReferenceKey || key == applyDirectivesKey) continue;

      return MixProtocolError(
        code: MixProtocolErrorCode.unknownField,
        path: _joinPath(path, key),
        message:
            'A merge term may only contain "$mergeReferenceKey" and '
            '"$applyDirectivesKey".',
        value: key,
      );
    }

    return null;
  }

  for (final key in value.keys) {
    if (!key.startsWith(r'$')) continue;

    return MixProtocolError(
      code: MixProtocolErrorCode.unknownField,
      path: _joinPath(path, key),
      message: 'Unknown mix_protocol control marker "$key".',
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

MixProtocolError _asWarning(MixProtocolError error, {String? path}) {
  return MixProtocolError(
    code: error.code,
    severity: MixProtocolDiagnosticSeverity.warning,
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

({MixProtocolError error, List<String> removalPath})? _lenientRepairCandidate(
  List<MixProtocolError> errors,
) {
  ({MixProtocolError error, List<String> removalPath})? best;
  for (final error in errors) {
    final removalPath = _lenientRemovalPath(error);
    if (removalPath == null) continue;
    if (best == null || removalPath.length > best.removalPath.length) {
      best = (error: error, removalPath: removalPath);
    }
  }

  return best;
}

List<String>? _lenientRemovalPath(MixProtocolError error) {
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

  if (error.code == MixProtocolErrorCode.unknownField &&
      _isLenientNestedMapPropertyPath(segments)) {
    return segments;
  }

  if ((error.code == MixProtocolErrorCode.invalidEnum ||
          error.code == MixProtocolErrorCode.unknownType) &&
      _isLenientNestedRepairPath(segments)) {
    if (_isNestedDiscriminatorPath(segments)) {
      return segments.sublist(0, segments.length - 1);
    }

    return segments;
  }

  return [segments.first];
}

bool _isLenientSkippable(MixProtocolError error) {
  return switch (error.code) {
    MixProtocolErrorCode.unknownField ||
    MixProtocolErrorCode.invalidEnum ||
    MixProtocolErrorCode.unknownType => true,
    _ => false,
  };
}

({String container, int index})? _deepestIndexedContainer(
  List<String> segments,
) {
  for (var i = segments.length - 2; i >= 0; i -= 1) {
    if (int.tryParse(segments[i + 1]) == null) continue;
    final listPath = segments.sublist(0, i + 1);
    if (!_isLenientListEntryPath(listPath)) continue;

    return (container: segments[i], index: i);
  }

  return null;
}

bool _isLenientListEntryPath(List<String> path) {
  for (final suffix in _lenientListEntryPathSuffixes) {
    if (_endsWithSegments(path, suffix)) return true;
  }

  return false;
}

bool _isLenientNestedMapPropertyPath(List<String> path) {
  if (path.length < 2) return false;
  if (path.first == 'type' || path.first == _versionKey) return false;
  if (path.last == 'type' || path.last == _versionKey) return false;

  return true;
}

bool _isLenientNestedRepairPath(List<String> path) {
  if (path.length < 2) return false;
  if (path.first == 'type' || path.first == _versionKey) return false;
  if (path.last == _versionKey) return false;

  return true;
}

bool _isNestedDiscriminatorPath(List<String> path) {
  if (path.length < 2) return false;

  return path.last == 'type' || path.last == 'kind';
}

const _lenientListEntryPathSuffixes = [
  ['variants'],
  ['modifiers'],
  ['modifiers', 'order'],
  ['modifiers', 'items'],
  [applyDirectivesKey],
  [mergeReferenceKey],
  ['decoration', 'boxShadow'],
  ['decoration', 'gradient', 'colors'],
  ['decoration', 'gradient', 'stops'],
  ['foregroundDecoration', 'boxShadow'],
  ['foregroundDecoration', 'gradient', 'colors'],
  ['foregroundDecoration', 'gradient', 'stops'],
  ['style', 'fontFamilyFallback'],
  ['style', 'fontFeatures'],
  ['style', 'fontVariations'],
  ['style', 'shadows'],
  ['strutStyle', 'fontFamilyFallback'],
  ['shadows'],
];

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

void _repairAfterListEntryRemoval(Object? root, List<String> removedEntryPath) {
  if (removedEntryPath.length < 2) return;

  final listKey = removedEntryPath[removedEntryPath.length - 2];
  if (listKey != applyDirectivesKey && listKey != mergeReferenceKey) return;

  final termPath = removedEntryPath.sublist(0, removedEntryPath.length - 2);
  Object? parent = root;
  for (final segment in termPath) {
    parent = switch (parent) {
      Map<String, Object?>() => parent[segment],
      List() => _readList(parent, segment),
      _ => null,
    };
    if (parent == null) return;
  }

  if (parent is! Map<String, Object?>) return;
  final apply = parent[applyDirectivesKey];
  if (apply is List && apply.isEmpty) parent.remove(applyDirectivesKey);
  _collapseSingleSourceMergeCarrier(root, termPath, parent);
}

void _collapseSingleSourceMergeCarrier(
  Object? root,
  List<String> termPath,
  Map<String, Object?> term,
) {
  if (term.containsKey(applyDirectivesKey)) return;
  if (term.keys.length != 1 || !term.containsKey(mergeReferenceKey)) return;

  final sources = term[mergeReferenceKey];
  if (sources is! List || sources.length != 1) return;

  _replacePath(root, termPath, _deepMutableCopy(sources.single));
}

void _replacePath(Object? root, List<String> path, Object? value) {
  if (path.isEmpty) return;

  Object? parent = root;
  for (final segment in path.take(path.length - 1)) {
    parent = switch (parent) {
      Map<String, Object?>() => parent[segment],
      List() => _readList(parent, segment),
      _ => null,
    };
    if (parent == null) return;
  }

  final last = path.last;
  if (parent is Map<String, Object?>) {
    if (parent.containsKey(last)) parent[last] = value;

    return;
  }

  if (parent is List) {
    final index = int.tryParse(last);
    if (index == null || index < 0 || index >= parent.length) return;
    parent[index] = value;
  }
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

bool _endsWithSegments(List<String> value, List<String> suffix) {
  if (value.length < suffix.length) return false;
  final offset = value.length - suffix.length;
  for (var i = 0; i < suffix.length; i += 1) {
    if (value[offset + i] != suffix[i]) return false;
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

JsonMap _withPropertyTermDefinitions(JsonMap schema) {
  final withPropertyTermRefs = _withDoubleTokenPropertyTermSchemas(
    _replaceAckAnyJsonSchemas(_withNestedPropertyLiteralSchemas(schema))
        as JsonMap,
  );
  final definitions = Map<String, Object?>.from(
    (withPropertyTermRefs['definitions'] as Map?) ?? const {},
  );

  return {
    ...withPropertyTermRefs,
    'definitions': {
      ...definitions,
      'mix_protocol_property_term': _propertyTermJsonSchema(),
      'mix_protocol_double_property_term': _propertyTermJsonSchema(
        allowTokenKind: true,
      ),
      'mix_protocol_property_control_term': _propertyControlTermJsonSchema(),
      'mix_protocol_double_property_control_term':
          _propertyControlTermJsonSchema(allowTokenKind: true),
      'mix_protocol_directive': _directiveJsonSchema(),
      _boxDecorationLiteralSchemaDefinition: _nestedLiteralDefinitionSchema(
        boxDecorationCodec().toJsonSchema(),
        definitionName: _boxDecorationLiteralSchemaDefinition,
      ),
      _strutStyleLiteralSchemaDefinition: _nestedLiteralDefinitionSchema(
        strutStyleMixCodec().toJsonSchema(),
        definitionName: _strutStyleLiteralSchemaDefinition,
      ),
      _textStyleLiteralSchemaDefinition: _nestedLiteralDefinitionSchema(
        textStyleMixLiteralJsonSchema(),
        definitionName: _textStyleLiteralSchemaDefinition,
      ),
    },
  };
}

JsonMap _withDoubleTokenPropertyTermSchemas(JsonMap schema) {
  final anyOf = schema['anyOf'];
  if (anyOf is List) {
    return {
      ...schema,
      'anyOf': [
        for (final branch in anyOf) _withDoubleTokenBranchProperties(branch),
      ],
    };
  }

  return _withDoubleTokenBranchProperties(schema) as JsonMap;
}

Object? _withDoubleTokenBranchProperties(Object? branchValue) {
  if (branchValue is! JsonMap) return branchValue;
  final doubleTokenProperties =
      _doubleTokenRootPropertiesByType[_branchSchemaType(branchValue)];
  if (doubleTokenProperties == null || doubleTokenProperties.isEmpty) {
    return branchValue;
  }

  final properties = Map<String, Object?>.from(
    (branchValue['properties'] as Map?) ?? const {},
  );
  for (final property in doubleTokenProperties) {
    final value = properties[property];
    if (_isGenericPropertyTermRef(value)) {
      properties[property] = _propertyTermFieldJsonSchema(allowTokenKind: true);
    }
  }

  return {...branchValue, 'properties': properties};
}

bool _isGenericPropertyTermRef(Object? value) {
  return value is JsonMap &&
      value.length == 1 &&
      value[r'$ref'] == '#/definitions/mix_protocol_property_term';
}

bool _isGenericPropertyControlTermRef(Object? value) {
  return value is JsonMap &&
      value.length == 1 &&
      value[r'$ref'] == '#/definitions/mix_protocol_property_control_term';
}

const _doubleTokenRootPropertiesByType = {
  schemaTypeBox: {'padding', 'margin'},
  schemaTypeFlex: {'spacing'},
  schemaTypeIcon: {'size', 'weight', 'grade', 'opticalSize', 'fill', 'opacity'},
  schemaTypeImage: {'width', 'height'},
  schemaTypeFlexBox: {'padding', 'margin', 'spacing'},
  schemaTypeStackBox: {'padding', 'margin'},
};

const _doubleTokenNestedPropertyPathsByDefinition = {
  _strutStyleLiteralSchemaDefinition: [
    ['fontSize'],
    ['height'],
    ['leading'],
  ],
  _textStyleLiteralSchemaDefinition: [
    ['fontSize'],
    ['letterSpacing'],
    ['wordSpacing'],
    ['height'],
    ['decorationThickness'],
  ],
};

const _boxDecorationLiteralSchemaDefinition =
    'mix_protocol_box_decoration_literal';
const _strutStyleLiteralSchemaDefinition = 'mix_protocol_strut_style_literal';
const _textStyleLiteralSchemaDefinition = 'mix_protocol_text_style_literal';

JsonMap _withNestedPropertyLiteralSchemas(JsonMap schema) {
  final anyOf = schema['anyOf'];
  if (anyOf is List) {
    return {
      ...schema,
      'anyOf': [
        for (final branch in anyOf) _withNestedBranchLiteralSchemas(branch),
      ],
    };
  }

  return _withNestedBranchLiteralSchemas(schema) as JsonMap;
}

Object? _withNestedBranchLiteralSchemas(Object? branchValue) {
  if (branchValue is! JsonMap) return branchValue;

  final properties = Map<String, Object?>.from(
    (branchValue['properties'] as Map?) ?? const {},
  );
  switch (_branchSchemaType(branchValue)) {
    case schemaTypeBox:
      _setPropertyLiteralSchemaRef(
        properties,
        'decoration',
        _boxDecorationLiteralSchemaDefinition,
      );
      _setPropertyLiteralSchemaRef(
        properties,
        'foregroundDecoration',
        _boxDecorationLiteralSchemaDefinition,
      );
    case schemaTypeText:
      _setPropertyLiteralSchemaRef(
        properties,
        'style',
        _textStyleLiteralSchemaDefinition,
      );
      _setPropertyLiteralSchemaRef(
        properties,
        'strutStyle',
        _strutStyleLiteralSchemaDefinition,
      );
    case schemaTypeFlexBox || schemaTypeStackBox:
      _setPropertyLiteralSchemaRef(
        properties,
        'decoration',
        _boxDecorationLiteralSchemaDefinition,
      );
  }

  return {...branchValue, 'properties': properties};
}

String? _branchSchemaType(JsonMap branch) {
  final properties = branch['properties'];
  if (properties is! Map) return null;
  final type = properties['type'];
  if (type is! Map) return null;

  return type['const'] as String?;
}

void _setPropertyLiteralSchemaRef(
  Map<String, Object?> properties,
  String key,
  String definitionName,
) {
  if (!properties.containsKey(key)) return;
  properties[key] = _propertyTermLiteralFieldRefSchema(definitionName);
}

Object? _replaceAckAnyJsonSchemas(Object? value) {
  if (value is List) {
    return [for (final item in value) _replaceAckAnyJsonSchemas(item)];
  }
  if (value is! Map) return value;

  final map = JsonMap.from(value);
  if (_isAckAnyJsonSchema(map)) {
    return _propertyTermFieldJsonSchema();
  }

  return {
    for (final entry in map.entries)
      entry.key: _replaceAckAnyJsonSchemas(entry.value),
  };
}

bool _isAckAnyJsonSchema(JsonMap value) {
  final anyOf = value['anyOf'];
  if (anyOf is! List || anyOf.length != 6) return false;

  final types = <String>{};
  for (final branch in anyOf) {
    if (branch is! JsonMap) return false;
    final type = branch['type'];
    if (type is! String) return false;
    types.add(type);
  }

  return types.containsAll(const {
        'string',
        'number',
        'integer',
        'boolean',
        'object',
        'array',
      }) &&
      types.length == 6;
}

JsonMap _nestedLiteralDefinitionSchema(
  JsonMap schema, {
  required String definitionName,
}) {
  final replaced = _replaceAckAnyJsonSchemas(schema);
  if (replaced is! JsonMap) return JsonMap.from(replaced as Map);

  return _withDoubleTokenNestedPropertySchemas(
    _wrapTopLevelPropertySchemas(replaced),
    _doubleTokenNestedPropertyPathsByDefinition[definitionName] ?? const [],
  );
}

JsonMap _withDoubleTokenNestedPropertySchemas(
  JsonMap schema,
  List<List<String>> paths,
) {
  var result = schema;
  for (final path in paths) {
    result = _withDoubleTokenPropertyTermAtPath(result, path) as JsonMap;
  }

  return result;
}

Object? _withDoubleTokenPropertyTermAtPath(Object? value, List<String> path) {
  if (path.isEmpty) return _allowDoubleTokenKindInPropertyTerm(value);
  if (value is! Map) return value;

  final map = JsonMap.from(value);
  final anyOf = map['anyOf'];
  if (anyOf is List) {
    return {
      ...map,
      'anyOf': [
        for (final branch in anyOf)
          _withDoubleTokenPropertyTermAtPath(branch, path),
      ],
    };
  }

  final segment = path.first;
  final rest = path.sublist(1);
  if (segment == '*') {
    final items = map['items'];
    if (items == null) return value;
    return {...map, 'items': _withDoubleTokenPropertyTermAtPath(items, rest)};
  }

  final properties = map['properties'];
  if (properties is! Map || !properties.containsKey(segment)) return value;

  return {
    ...map,
    'properties': {
      ...properties,
      segment: _withDoubleTokenPropertyTermAtPath(properties[segment], rest),
    },
  };
}

Object? _allowDoubleTokenKindInPropertyTerm(Object? value) {
  if (value is! Map) return value;

  final map = JsonMap.from(value);
  if (_isGenericPropertyTermRef(map)) {
    return _propertyTermFieldJsonSchema(allowTokenKind: true);
  }
  if (_isGenericPropertyControlTermRef(map)) {
    return {r'$ref': '#/definitions/mix_protocol_double_property_control_term'};
  }

  final anyOf = map['anyOf'];
  if (anyOf is List) {
    return {
      ...map,
      'anyOf': [
        for (final branch in anyOf) _allowDoubleTokenKindInPropertyTerm(branch),
      ],
    };
  }

  return value;
}

JsonMap _wrapTopLevelPropertySchemas(JsonMap schema) {
  final properties = schema['properties'];
  if (properties is! Map) return schema;

  return {
    ...schema,
    'properties': {
      for (final entry in properties.entries)
        entry.key: _propertyTermLiteralFieldSchema(entry.value),
    },
  };
}

Object? _propertyTermLiteralFieldSchema(Object? literalSchema) {
  if (literalSchema is! Map) return literalSchema;

  final schema = JsonMap.from(literalSchema);
  if (_hasPropertyControlTermRef(schema)) return schema;

  return {
    'anyOf': [
      schema,
      {r'$ref': '#/definitions/mix_protocol_property_control_term'},
    ],
  };
}

bool _hasPropertyControlTermRef(JsonMap schema) {
  final anyOf = schema['anyOf'];
  if (anyOf is! List) return false;

  return anyOf.any(
    (branch) =>
        branch is Map &&
        (branch[r'$ref'] ==
                '#/definitions/mix_protocol_property_control_term' ||
            branch[r'$ref'] ==
                '#/definitions/mix_protocol_double_property_control_term'),
  );
}

JsonMap _propertyTermJsonSchema({bool allowTokenKind = false}) {
  return {
    'anyOf': [
      ..._genericPropertyLiteralSchemas(),
      {
        r'$ref': allowTokenKind
            ? '#/definitions/mix_protocol_double_property_control_term'
            : '#/definitions/mix_protocol_property_control_term',
      },
    ],
  };
}

JsonMap _propertyTermFieldJsonSchema({bool allowTokenKind = false}) {
  return {
    r'$ref': allowTokenKind
        ? '#/definitions/mix_protocol_double_property_term'
        : '#/definitions/mix_protocol_property_term',
  };
}

JsonMap _propertyTermLiteralFieldRefSchema(String definitionName) {
  return {
    'anyOf': [
      {r'$ref': '#/definitions/$definitionName'},
      {r'$ref': '#/definitions/mix_protocol_property_control_term'},
    ],
  };
}

List<JsonMap> _genericPropertyLiteralSchemas() {
  return [
    {
      'description':
          'Field-specific scalar, array, or object literal without '
          'property-term control markers; see the enclosing property schema.',
      'not': {'type': 'object'},
    },
    {
      'type': 'object',
      'description':
          'Field-specific object literal without property-term control markers; '
          'see the enclosing property schema.',
      'not': {
        'anyOf': [
          {
            'required': [tokenReferenceKey],
          },
          {
            'required': [mergeReferenceKey],
          },
          {
            'required': [applyDirectivesKey],
          },
        ],
      },
    },
  ];
}

JsonMap _propertyControlTermJsonSchema({bool allowTokenKind = false}) {
  final propertyTermRef = allowTokenKind
      ? '#/definitions/mix_protocol_double_property_term'
      : '#/definitions/mix_protocol_property_term';

  return {
    'anyOf': [
      {
        'type': 'object',
        'properties': {
          tokenReferenceKey: {
            'type': 'string',
            'pattern': _tokenNamePatternSchema,
          },
          if (allowTokenKind)
            tokenKindKey: {
              'type': 'string',
              'enum': [tokenKindSpace, tokenKindDouble],
            },
          applyDirectivesKey: {
            'type': 'array',
            'minItems': 1,
            'items': {r'$ref': '#/definitions/mix_protocol_directive'},
          },
        },
        'required': [tokenReferenceKey],
        'additionalProperties': false,
      },
      {
        'type': 'object',
        'properties': {
          mergeReferenceKey: {
            'type': 'array',
            'minItems': 2,
            'items': {r'$ref': propertyTermRef},
          },
        },
        'required': [mergeReferenceKey],
        'additionalProperties': false,
      },
      {
        'type': 'object',
        'properties': {
          mergeReferenceKey: {
            'type': 'array',
            'minItems': 1,
            'items': {r'$ref': propertyTermRef},
          },
          applyDirectivesKey: {
            'type': 'array',
            'minItems': 1,
            'items': {r'$ref': '#/definitions/mix_protocol_directive'},
          },
        },
        'required': [mergeReferenceKey, applyDirectivesKey],
        'additionalProperties': false,
      },
    ],
  };
}

JsonMap _directiveJsonSchema() {
  JsonMap directiveBranch(
    String op, {
    Map<String, JsonMap> params = const {},
    List<String> requiredParams = const [],
  }) {
    return {
      'type': 'object',
      'properties': {
        directiveOpKey: {'type': 'string', 'const': op},
        ...params,
      },
      'required': [directiveOpKey, ...requiredParams],
      'additionalProperties': false,
    };
  }

  const numberParam = {'type': 'number'};
  const integerParam = {'type': 'integer'};

  return {
    'anyOf': [
      directiveBranch(
        'color_opacity',
        params: const {'opacity': numberParam},
        requiredParams: const ['opacity'],
      ),
      directiveBranch(
        'color_with_values',
        params: const {
          'alpha': numberParam,
          'red': numberParam,
          'green': numberParam,
          'blue': numberParam,
          'colorSpace': {
            'type': 'string',
            'enum': ['sRGB', 'extendedSRGB', 'displayP3'],
          },
        },
      ),
      for (final op in const [
        'color_alpha',
        'color_darken',
        'color_lighten',
        'color_saturate',
        'color_desaturate',
        'color_tint',
        'color_shade',
        'color_brighten',
      ])
        directiveBranch(
          op,
          params: {op == 'color_alpha' ? 'alpha' : 'amount': integerParam},
          requiredParams: [op == 'color_alpha' ? 'alpha' : 'amount'],
        ),
      directiveBranch(
        'color_with_red',
        params: const {'red': integerParam},
        requiredParams: const ['red'],
      ),
      directiveBranch(
        'color_with_green',
        params: const {'green': integerParam},
        requiredParams: const ['green'],
      ),
      directiveBranch(
        'color_with_blue',
        params: const {'blue': integerParam},
        requiredParams: const ['blue'],
      ),
      for (final op in const [
        'uppercase',
        'lowercase',
        'capitalize',
        'title_case',
        'sentence_case',
      ])
        directiveBranch(op),
      directiveBranch(
        'number_multiply',
        params: const {'factor': numberParam},
        requiredParams: const ['factor'],
      ),
      directiveBranch(
        'number_add',
        params: const {'addend': numberParam},
        requiredParams: const ['addend'],
      ),
      directiveBranch(
        'number_subtract',
        params: const {'subtrahend': numberParam},
        requiredParams: const ['subtrahend'],
      ),
      directiveBranch(
        'number_divide',
        params: const {'divisor': numberParam},
        requiredParams: const ['divisor'],
      ),
      directiveBranch(
        'number_clamp',
        params: const {'min': numberParam, 'max': numberParam},
        requiredParams: const ['min', 'max'],
      ),
      for (final op in const [
        'number_abs',
        'number_round',
        'number_floor',
        'number_ceil',
      ])
        directiveBranch(op),
    ],
  };
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
      _versionKey: {'type': 'integer', 'const': mixProtocolFormatVersion},
    },
    'required': required.toSet().toList(growable: false),
  };
}

void _validateThemeEnvelope(JsonMap data, List<MixProtocolError> errors) {
  if (!data.containsKey('type')) {
    errors.add(
      const MixProtocolError(
        code: MixProtocolErrorCode.requiredField,
        path: '/type',
        message: 'Theme documents require type "theme".',
      ),
    );
  } else if (data['type'] != _themeWireType) {
    errors.add(
      MixProtocolError(
        code: MixProtocolErrorCode.unknownType,
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
      MixProtocolError(
        code: MixProtocolErrorCode.unknownField,
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
  List<MixProtocolError> errors,
) {
  final rawMap = data[kind.field];
  if (rawMap == null) return;
  final mapPath = _joinPath('', kind.field);
  final map = _themeJsonMap(rawMap);
  if (map == null) {
    errors.add(
      MixProtocolError(
        code: MixProtocolErrorCode.typeMismatch,
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
        MixProtocolError(
          code: MixProtocolErrorCode.invalidTokenName,
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
        MixProtocolError(
          code: MixProtocolErrorCode.constraintViolation,
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
  List<MixProtocolError> errors,
) {
  if (value is! JsonMap || !value.containsKey(tokenReferenceKey)) return null;

  final rawTarget = value[tokenReferenceKey];
  if (rawTarget is! String) {
    errors.add(
      MixProtocolError(
        code: MixProtocolErrorCode.typeMismatch,
        path: _joinPath(valuePath, tokenReferenceKey),
        message: 'Theme token aliases require a string "$tokenReferenceKey".',
        value: rawTarget,
      ),
    );
    return null;
  }

  final allowedKeys = {
    tokenReferenceKey,
    if (kind.aliasKind != null) tokenKindKey,
  };
  for (final key in value.keys) {
    if (allowedKeys.contains(key)) continue;
    errors.add(
      MixProtocolError(
        code: MixProtocolErrorCode.unknownField,
        path: _joinPath(valuePath, key),
        message:
            'Theme aliases may only contain "$tokenReferenceKey"'
            '${kind.aliasKind == null ? '' : ' and "$tokenKindKey"'} fields.',
        value: key,
      ),
    );
    return rawTarget;
  }
  if (!isValidTokenName(rawTarget)) {
    errors.add(
      MixProtocolError(
        code: MixProtocolErrorCode.invalidTokenName,
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
      MixProtocolError(
        code: MixProtocolErrorCode.unknownField,
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
      MixProtocolError(
        code: MixProtocolErrorCode.constraintViolation,
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
  List<MixProtocolError> errors,
) {
  final allNamesByField = {
    for (final kind in _themeTokenKinds) kind.field: state.namesFor(kind),
  };
  final tokens = <MixToken, Object>{};
  for (final kind in _themeTokenKinds) {
    final resolved = _resolveThemeAliasKind(
      kind: kind,
      state: state,
      allNamesByField: allNamesByField,
      errors: errors,
    );
    final names = state.namesFor(kind).toList(growable: false)..sort();
    for (final name in names) {
      final value = resolved[name];
      if (value != null) tokens[kind.createToken(name)] = value;
    }
  }

  return tokens;
}

Map<String, Object> _resolveThemeAliasKind({
  required _ThemeTokenKind kind,
  required _ThemeDecodeState state,
  required Map<String, Set<String>> allNamesByField,
  required List<MixProtocolError> errors,
}) {
  final resolved = <String, Object>{};
  final failed = <String>{};
  final sameKindNames = allNamesByField[kind.field] ?? const <String>{};
  final names = sameKindNames.toList(growable: false)..sort();

  for (final start in names) {
    if (resolved.containsKey(start) || failed.contains(start)) continue;

    final path = <String>[];
    final visiting = <String>{};
    var current = start;
    Object? terminalValue;

    while (true) {
      final cached = resolved[current];
      if (cached != null) {
        terminalValue = cached;
        break;
      }
      if (failed.contains(current)) {
        failed.addAll(path);
        break;
      }

      final literal = state.literal(kind, current);
      if (literal != null) {
        resolved[current] = literal;
        terminalValue = literal;
        break;
      }

      if (!visiting.add(current)) {
        final source = path.last;
        errors.add(
          MixProtocolError(
            code: MixProtocolErrorCode.constraintViolation,
            path: _joinPath(state.aliasPath(kind, source), tokenReferenceKey),
            message:
                'Theme token alias cycle detected: '
                '${[...path, current].join(' -> ')}.',
            value: current,
          ),
        );
        failed.addAll(path);
        break;
      }

      path.add(current);
      final target = state.aliasTarget(kind, current);
      if (target == null) {
        failed.addAll(path);
        break;
      }
      if (!sameKindNames.contains(target)) {
        _addThemeAliasTargetError(
          kind: kind,
          source: current,
          target: target,
          state: state,
          allNamesByField: allNamesByField,
          errors: errors,
        );
        failed.addAll(path);
        break;
      }

      current = target;
    }

    if (terminalValue != null) {
      for (final alias in path.reversed) {
        resolved[alias] = terminalValue;
      }
    }
  }

  return resolved;
}

void _addThemeAliasTargetError({
  required _ThemeTokenKind kind,
  required String source,
  required String target,
  required _ThemeDecodeState state,
  required Map<String, Set<String>> allNamesByField,
  required List<MixProtocolError> errors,
}) {
  String? crossKindField;
  for (final entry in allNamesByField.entries) {
    if (entry.key == kind.field) continue;
    if (!entry.value.contains(target)) continue;
    crossKindField = entry.key;
    break;
  }
  errors.add(
    MixProtocolError(
      code: MixProtocolErrorCode.constraintViolation,
      path: _joinPath(state.aliasPath(kind, source), tokenReferenceKey),
      message: crossKindField == null
          ? 'Theme token alias target "$target" was not found.'
          : 'Theme token alias target "$target" belongs to '
                '"$crossKindField", not "${kind.field}".',
      value: target,
    ),
  );
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

List<MixProtocolError> _withPathPrefix(
  List<MixProtocolError> errors,
  String prefix,
) {
  return [
    for (final error in errors)
      MixProtocolError(
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
    'debugLabel': Ack.string().optional(),
    'wordSpacing': numberAsDoubleCodec().optional(),
    'textBaseline': enumNameCodec(TextBaseline.values).optional(),
    'height': numberAsDoubleCodec().optional(),
    'fontFamily': Ack.string().optional(),
    'fontFamilyFallback': Ack.list(Ack.string()).optional(),
    'fontFeatures': Ack.list(fontFeatureCodec()).optional(),
    'fontVariations': Ack.list(fontVariationCodec()).optional(),
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
      debugLabel: data['debugLabel'] as String?,
      wordSpacing: data['wordSpacing'] as double?,
      textBaseline: data['textBaseline'] as TextBaseline?,
      height: data['height'] as double?,
      fontFamily: data['fontFamily'] as String?,
      fontFamilyFallback: (data['fontFamilyFallback'] as List?)?.cast<String>(),
      fontFeatures: (data['fontFeatures'] as List?)?.cast<FontFeature>(),
      fontVariations: (data['fontVariations'] as List?)?.cast<FontVariation>(),
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
  failIfPresent(value.foreground, 'theme.textStyle.foreground');
  failIfPresent(value.background, 'theme.textStyle.background');
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
    'debugLabel': value.debugLabel,
    'wordSpacing': value.wordSpacing,
    'textBaseline': value.textBaseline,
    'height': value.height,
    'fontFamily': value.fontFamily,
    'fontFamilyFallback': value.fontFamilyFallback,
    'fontFeatures': value.fontFeatures,
    'fontVariations': value.fontVariations,
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
        constraintKey: 'mix_protocol_theme_breakpoint_bounds',
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
