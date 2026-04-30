import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../../core/schema_wire_types.dart';
import '../shared/shared_schemas.dart';

const List<SchemaVariant> sharedContextVariantLeafTypes = [
  .widgetState,
  .enabled,
  .brightness,
  .breakpoint,
  .notWidgetState,
];

final class ContextVariantLeaf {
  final ContextVariant variant;
  final String canonicalKey;

  const ContextVariantLeaf({required this.variant, required this.canonicalKey});

  int get sortPriority => switch (variant) {
    WidgetStateVariant priority => priority.sortPriority,
    _ => 0,
  };
}

typedef VariantConditionRefinement = bool Function(Map<String, Object?> data);
typedef VariantConditionLeafBuilder =
    ContextVariantLeaf Function(Map<String, Object?> data);
typedef VariantConditionFieldsEncoder = JsonMap Function(JsonMap fields);

final class VariantConditionDefinition {
  final SchemaVariant type;
  final Map<String, AckSchema> fields;
  final VariantConditionRefinement? refine;
  final String? refineMessage;
  final VariantConditionLeafBuilder buildLeaf;
  final JsonMap sampleFields;
  final VariantConditionFieldsEncoder _encodeFields;

  const VariantConditionDefinition({
    required this.type,
    required this.fields,
    this.refine,
    this.refineMessage,
    required this.buildLeaf,
    required this.sampleFields,
    required VariantConditionFieldsEncoder encodeFields,
  }) : _encodeFields = encodeFields;

  AckSchema<Map<String, Object?>> _buildDataSchema([
    Map<String, AckSchema> extraFields = const {},
  ]) {
    final allFields = {...fields, ...extraFields};

    if (refine case final refinement?) {
      return Ack.object(allFields).refine(refinement, message: refineMessage!);
    }

    return Ack.object(allFields);
  }

  AckSchema<ContextVariantLeaf> buildLeafSchema() {
    return _buildDataSchema().transform<ContextVariantLeaf>((data) {
      return buildLeaf(data);
    });
  }

  AckSchema<VariantStyle<S>> buildVariantSchema<
    S extends Spec<S>,
    T extends Style<S>
  >(AckSchema<T> styleSchema) {
    return _buildDataSchema({'style': styleSchema}).transform<VariantStyle<S>>((
      data,
    ) {
      final map = data;

      return VariantStyle<S>(buildLeaf(map).variant, map['style'] as T);
    });
  }

  JsonMap encode(JsonMap fields) {
    return {'type': type.wireValue, ..._encodeFields(fields)};
  }
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
      return VariantConditionDefinition(
        type: .widgetState,
        fields: {'state': widgetStateSchema},
        buildLeaf: (data) {
          final state = data['state'] as WidgetState;

          return ContextVariantLeaf(
            variant: ContextVariant.widgetState(state),
            canonicalKey: '${type.wireValue}:${state.name}',
          );
        },
        sampleFields: {'state': WidgetState.hovered},
        encodeFields: (fields) => {
          'state': (fields['state'] as WidgetState).name,
        },
      );
    case .enabled:
      return VariantConditionDefinition(
        type: .enabled,
        fields: const {},
        buildLeaf: (_) {
          return ContextVariantLeaf(
            variant: ContextVariant.not(ContextVariant.widgetState(.disabled)),
            canonicalKey: type.wireValue,
          );
        },
        sampleFields: const {},
        encodeFields: (_) => const {},
      );
    case .brightness:
      return VariantConditionDefinition(
        type: .brightness,
        fields: {'brightness': brightnessSchema},
        buildLeaf: (data) {
          final brightness = data['brightness'] as Brightness;

          return ContextVariantLeaf(
            variant: ContextVariant.brightness(brightness),
            canonicalKey: '${type.wireValue}:${brightness.name}',
          );
        },
        sampleFields: {'brightness': Brightness.dark},
        encodeFields: (fields) {
          return {'brightness': (fields['brightness'] as Brightness).name};
        },
      );
    case .breakpoint:
      return VariantConditionDefinition(
        type: .breakpoint,
        fields: {
          'minWidth': Ack.double().nullable().optional(),
          'maxWidth': Ack.double().nullable().optional(),
          'minHeight': Ack.double().nullable().optional(),
          'maxHeight': Ack.double().nullable().optional(),
        },
        refine: _hasAnyBreakpointDimension,
        refineMessage: 'At least one dimension constraint required.',
        buildLeaf: (data) {
          return ContextVariantLeaf(
            variant: ContextVariant.breakpoint(
              Breakpoint(
                minWidth: data['minWidth'] as double?,
                maxWidth: data['maxWidth'] as double?,
                minHeight: data['minHeight'] as double?,
                maxHeight: data['maxHeight'] as double?,
              ),
            ),
            canonicalKey: _breakpointCanonicalKey(data),
          );
        },
        sampleFields: const {'minWidth': 768.0},
        encodeFields: _encodeBreakpointFields,
      );
    case .notWidgetState:
      return VariantConditionDefinition(
        type: .notWidgetState,
        fields: {'state': widgetStateSchema},
        refine: (data) => data['state'] != WidgetState.disabled,
        refineMessage: 'Use enabled for not(disabled).',
        buildLeaf: (data) {
          final state = data['state'] as WidgetState;

          return ContextVariantLeaf(
            variant: ContextVariant.not(ContextVariant.widgetState(state)),
            canonicalKey: '${type.wireValue}:${state.name}',
          );
        },
        sampleFields: {'state': WidgetState.focused},
        encodeFields: (fields) => {
          'state': (fields['state'] as WidgetState).name,
        },
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

bool _hasAnyBreakpointDimension(Map<String, Object?> data) {
  return data['minWidth'] != null ||
      data['maxWidth'] != null ||
      data['minHeight'] != null ||
      data['maxHeight'] != null;
}

JsonMap _encodeBreakpointFields(JsonMap fields) {
  const fieldNames = ['minWidth', 'maxWidth', 'minHeight', 'maxHeight'];
  final payload = <String, Object?>{};

  for (final fieldName in fieldNames) {
    final value = fields[fieldName];
    if (value != null) {
      payload[fieldName] = value;
    }
  }

  return payload;
}

String _breakpointCanonicalKey(Map<String, Object?> data) {
  return [
    SchemaVariant.breakpoint.wireValue,
    'minWidth=${data['minWidth']?.toString() ?? 'null'}',
    'maxWidth=${data['maxWidth']?.toString() ?? 'null'}',
    'minHeight=${data['minHeight']?.toString() ?? 'null'}',
    'maxHeight=${data['maxHeight']?.toString() ?? 'null'}',
  ].join(':');
}
