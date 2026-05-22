import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/branch_codec.dart';
import '../../core/numeric_codecs.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

const List<SchemaVariant> sharedContextVariantLeafTypes = [
  .widgetState,
  .enabled,
  .brightness,
  .breakpoint,
  .notWidgetState,
];

int variantLeafSortPriority(SchemaVariant leaf) {
  return switch (leaf) {
    .widgetState => 1,
    .enabled || .brightness || .breakpoint || .notWidgetState => 0,
    .named || .contextAllOf || .contextBuilder => throw StateError(
      'Unsupported shared context leaf type: $leaf',
    ),
  };
}

final class ContextVariantLeaf {
  final ContextVariant variant;
  final String canonicalKey;

  const ContextVariantLeaf({required this.variant, required this.canonicalKey});

  int get sortPriority => switch (variant) {
    WidgetStateVariant priority => priority.sortPriority,
    _ => 0,
  };
}

typedef VariantConditionLeafBuilder = ContextVariantLeaf Function(JsonMap data);
typedef VariantConditionLeafEncoder = JsonMap Function(ContextVariantLeaf leaf);
typedef VariantConditionMatcher = bool Function(Variant variant);

final class VariantConditionDefinition {
  final SchemaVariant type;
  final CodecSchema<JsonMap, ContextVariantLeaf> codec;
  final VariantConditionLeafBuilder buildLeaf;
  final VariantConditionLeafEncoder _encodeLeaf;
  final VariantConditionMatcher _matchesVariant;

  const VariantConditionDefinition({
    required this.type,
    required this.codec,
    required this.buildLeaf,
    required VariantConditionLeafEncoder encodeLeaf,
    required VariantConditionMatcher matchesVariant,
  }) : _encodeLeaf = encodeLeaf,
       _matchesVariant = matchesVariant;

  AckSchema<JsonMap, ContextVariantLeaf> buildLeafSchema() {
    return codec;
  }

  bool matchesVariant(Variant variant) => _matchesVariant(variant);

  CodecSchema<JsonMap, VariantStyle<S>> buildVariantSchema<
    S extends Spec<S>,
    T extends Style<S>
  >(AckSchema<JsonMap, T> styleSchema) {
    final inputSchema = codec.inputSchema;
    if (inputSchema is! ObjectSchema) {
      throw StateError('Variant condition codecs must be object-backed.');
    }

    return Ack.codec<JsonMap, JsonMap, VariantStyle<S>>(
      input: inputSchema.copyWith(
        properties: {...inputSchema.properties, 'style': styleSchema},
      ),
      decode: (data) =>
          VariantStyle<S>(buildLeaf(data).variant, data['style']! as T),
      encode: (value) {
        final variant = value.variant;
        if (variant is! ContextVariant) {
          throw ArgumentError('Expected a context variant.');
        }

        return {
          'type': type.wireValue,
          ..._encodeLeaf(
            ContextVariantLeaf(variant: variant, canonicalKey: variant.key),
          ),
          'style': value.value as T,
        };
      },
      output: Ack.instance<VariantStyle<S>>().refine(
        (value) => _matchesVariant(value.variant),
        message: 'Variant style does not match ${type.wireValue}.',
      ),
    );
  }

  JsonMap encodeLeaf(ContextVariantLeaf leaf) {
    return codec.encode(leaf)!;
  }

  JsonMap encode(JsonMap fields) {
    return encodeLeaf(buildLeaf(fields));
  }
}

CodecSchema<JsonMap, ContextVariantLeaf> _leafCodec({
  required SchemaVariant type,
  required ObjectSchema input,
  required VariantConditionLeafBuilder decode,
  required VariantConditionLeafEncoder encode,
  required VariantConditionMatcher matchesVariant,
}) {
  return standaloneBranchCodec<ContextVariantLeaf, ContextVariantLeaf>(
    type: type.wireValue,
    input: input,
    decode: decode,
    encode: encode,
    outputRefinement: (leaf) => matchesVariant(leaf.variant),
    outputRefinementMessage:
        'Context variant leaf does not match this condition.',
  );
}

final Map<SchemaVariant, VariantConditionDefinition>
variantConditionDefinitions = _buildVariantConditionDefinitions();

Map<SchemaVariant, VariantConditionDefinition>
_buildVariantConditionDefinitions() {
  final definitions = {
    for (final type in sharedContextVariantLeafTypes)
      type: _buildSharedVariantConditionDefinition(type),
  };

  assert(
    definitions.length == sharedContextVariantLeafTypes.length &&
        sharedContextVariantLeafTypes.every(definitions.containsKey),
    'variantConditionDefinitions must cover every shared context leaf type.',
  );

  return Map.unmodifiable(definitions);
}

VariantConditionDefinition _buildSharedVariantConditionDefinition(
  SchemaVariant type,
) {
  switch (type) {
    case .widgetState:
      ContextVariantLeaf buildLeaf(JsonMap data) {
        final state = data['state']! as WidgetState;

        return ContextVariantLeaf(
          variant: ContextVariant.widgetState(state),
          canonicalKey: '${type.wireValue}:${state.name}',
        );
      }

      return VariantConditionDefinition(
        type: .widgetState,
        codec: _leafCodec(
          type: .widgetState,
          input: Ack.object({'state': widgetStateSchema}),
          decode: buildLeaf,
          encode: _encodeWidgetStateLeaf,
          matchesVariant: (variant) => variant is WidgetStateVariant,
        ),
        buildLeaf: buildLeaf,
        encodeLeaf: _encodeWidgetStateLeaf,
        matchesVariant: (variant) => variant is WidgetStateVariant,
      );
    case .enabled:
      ContextVariantLeaf buildLeaf(JsonMap _) {
        return ContextVariantLeaf(
          variant: ContextVariant.not(ContextVariant.widgetState(.disabled)),
          canonicalKey: type.wireValue,
        );
      }

      return VariantConditionDefinition(
        type: .enabled,
        codec: _leafCodec(
          type: .enabled,
          input: Ack.object(const {}),
          decode: buildLeaf,
          encode: (_) => const {},
          matchesVariant: _isEnabledVariant,
        ),
        buildLeaf: buildLeaf,
        encodeLeaf: (_) => const {},
        matchesVariant: _isEnabledVariant,
      );
    case .brightness:
      ContextVariantLeaf buildLeaf(JsonMap data) {
        final brightness = data['brightness']! as Brightness;

        return ContextVariantLeaf(
          variant: ContextVariant.brightness(brightness),
          canonicalKey: '${type.wireValue}:${brightness.name}',
        );
      }

      return VariantConditionDefinition(
        type: .brightness,
        codec: _leafCodec(
          type: .brightness,
          input: Ack.object({'brightness': brightnessSchema}),
          decode: buildLeaf,
          encode: _encodeBrightnessLeaf,
          matchesVariant: _isBrightnessVariant,
        ),
        buildLeaf: buildLeaf,
        encodeLeaf: _encodeBrightnessLeaf,
        matchesVariant: _isBrightnessVariant,
      );
    case .breakpoint:
      ContextVariantLeaf buildLeaf(JsonMap data) {
        return ContextVariantLeaf(
          variant: ContextVariant.breakpoint(
            Breakpoint(
              minWidth: data['minWidth'] as double?,
              maxWidth: data['maxWidth'] as double?,
            ),
          ),
          canonicalKey: _breakpointCanonicalKey(data),
        );
      }

      return VariantConditionDefinition(
        type: .breakpoint,
        codec: _leafCodec(
          type: .breakpoint,
          input:
              Ack.object({
                'minWidth': doubleFromNum().nullable().optional(),
                'maxWidth': doubleFromNum().nullable().optional(),
              }).refine(
                _hasAnyBreakpointDimension,
                message: 'At least one width constraint required.',
              ),
          decode: buildLeaf,
          encode: _encodeBreakpointLeaf,
          matchesVariant: _isBreakpointVariant,
        ),
        buildLeaf: buildLeaf,
        encodeLeaf: _encodeBreakpointLeaf,
        matchesVariant: _isBreakpointVariant,
      );
    case .notWidgetState:
      ContextVariantLeaf buildLeaf(JsonMap data) {
        final state = data['state']! as WidgetState;

        return ContextVariantLeaf(
          variant: ContextVariant.not(ContextVariant.widgetState(state)),
          canonicalKey: '${type.wireValue}:${state.name}',
        );
      }

      return VariantConditionDefinition(
        type: .notWidgetState,
        codec: _leafCodec(
          type: .notWidgetState,
          input: Ack.object({'state': widgetStateSchema}).refine(
            (data) => data['state'] != WidgetState.disabled,
            message: 'Use enabled for not(disabled).',
          ),
          decode: buildLeaf,
          encode: _encodeNotWidgetStateLeaf,
          matchesVariant: _isNotWidgetStateVariant,
        ),
        buildLeaf: buildLeaf,
        encodeLeaf: _encodeNotWidgetStateLeaf,
        matchesVariant: _isNotWidgetStateVariant,
      );
    case .named || .contextAllOf || .contextBuilder:
      throw StateError('Unsupported shared context leaf type: $type');
  }
}

VariantConditionDefinition variantConditionDefinition(SchemaVariant type) {
  final definition = variantConditionDefinitions[type];
  if (definition == null) {
    throw StateError('Unsupported shared context leaf type: $type');
  }

  return definition;
}

JsonMap _encodeWidgetStateLeaf(ContextVariantLeaf leaf) {
  final variant = leaf.variant;
  if (variant is! WidgetStateVariant) {
    throw ArgumentError('Expected WidgetStateVariant.');
  }

  return {'state': variant.state};
}

JsonMap _encodeBrightnessLeaf(ContextVariantLeaf leaf) {
  return {'brightness': _brightnessFromVariant(leaf.variant)};
}

JsonMap _encodeNotWidgetStateLeaf(ContextVariantLeaf leaf) {
  final state = _notWidgetStateFromVariant(leaf.variant);
  if (state == .disabled) {
    throw ArgumentError('Use enabled for not(disabled).');
  }

  return {'state': state};
}

JsonMap _encodeBreakpointLeaf(ContextVariantLeaf leaf) {
  final fromCanonical = _breakpointFieldsFromCanonicalKey(leaf.canonicalKey);
  if (fromCanonical != null) return fromCanonical;

  final fromVariant = _breakpointFieldsFromVariantKey(leaf.variant.key);
  if (fromVariant == null || fromVariant.isEmpty) {
    throw ArgumentError('Breakpoint variant cannot be encoded.');
  }

  return fromVariant;
}

bool _isEnabledVariant(Variant variant) {
  return variant is ContextVariant &&
      variant.key == 'not_widget_state_disabled';
}

bool _isBrightnessVariant(Variant variant) {
  return variant is ContextVariant &&
      Brightness.values.any(
        (value) =>
            variant.key == 'media_query_platform_brightness_${value.name}',
      );
}

bool _isBreakpointVariant(Variant variant) {
  return variant is ContextVariant && variant.key.startsWith('breakpoint_');
}

bool _isNotWidgetStateVariant(Variant variant) {
  return variant is ContextVariant &&
      variant.key.startsWith('not_widget_state_') &&
      variant.key != 'not_widget_state_disabled';
}

Brightness _brightnessFromVariant(Variant variant) {
  if (variant is ContextVariant) {
    for (final value in Brightness.values) {
      if (variant.key == 'media_query_platform_brightness_${value.name}') {
        return value;
      }
    }
  }

  throw ArgumentError('Expected brightness context variant.');
}

WidgetState _notWidgetStateFromVariant(Variant variant) {
  if (variant is ContextVariant &&
      variant.key.startsWith('not_widget_state_')) {
    final stateName = variant.key.substring('not_widget_state_'.length);

    return WidgetState.values.byName(stateName);
  }

  throw ArgumentError('Expected negated widget state variant.');
}

bool _hasAnyBreakpointDimension(JsonMap data) {
  return data['minWidth'] != null || data['maxWidth'] != null;
}

JsonMap _breakpointFieldsFromValues({double? minWidth, double? maxWidth}) {
  final fields = <String, Object?>{};

  if (minWidth != null) fields['minWidth'] = minWidth;
  if (maxWidth != null) fields['maxWidth'] = maxWidth;

  return fields;
}

JsonMap? _breakpointFieldsFromCanonicalKey(String canonicalKey) {
  final parts = canonicalKey.split(':');
  if (parts.length != 3 || parts.first != SchemaVariant.breakpoint.wireValue) {
    return null;
  }

  final values = <String, double?>{};
  for (final part in parts.skip(1)) {
    final separator = part.indexOf('=');
    if (separator == -1) return null;

    final key = part.substring(0, separator);
    final value = part.substring(separator + 1);
    values[key] = _parseNullableDouble(value);
  }

  return _breakpointFieldsFromValues(
    minWidth: values['minWidth'],
    maxWidth: values['maxWidth'],
  );
}

JsonMap? _breakpointFieldsFromVariantKey(String key) {
  if (!key.startsWith('breakpoint_')) return null;

  final parts = key.substring('breakpoint_'.length).split('_');
  if (parts.length != 2) return null;

  final minWidth = parts[0] == '0.0' ? null : _parseNullableDouble(parts[0]);
  final maxWidth = parts[1] == 'infinity'
      ? null
      : _parseNullableDouble(parts[1]);

  return _breakpointFieldsFromValues(minWidth: minWidth, maxWidth: maxWidth);
}

double? _parseNullableDouble(String value) {
  if (value == 'null' || value == 'infinity') return null;

  return double.parse(value);
}

String _breakpointCanonicalKey(JsonMap data) {
  return [
    SchemaVariant.breakpoint.wireValue,
    'minWidth=${data['minWidth']?.toString() ?? 'null'}',
    'maxWidth=${data['maxWidth']?.toString() ?? 'null'}',
  ].join(':');
}
