import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_map.dart';
import '../../core/schema_wire_types.dart';
import '../shared/enum_schemas.dart';

const sharedContextVariantLeafTypes = <SchemaVariant>{
  SchemaVariant.widgetState,
  SchemaVariant.enabled,
  SchemaVariant.brightness,
  SchemaVariant.breakpoint,
  SchemaVariant.notWidgetState,
};

final class ContextVariantLeaf {
  final ContextVariant variant;
  final String canonicalKey;

  const ContextVariantLeaf({required this.variant, required this.canonicalKey});

  int get sortPriority => switch (variant) {
    VariantPriority priority => priority.sortPriority,
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

  AckSchema<Map<String, Object?>> _buildDataSchema([
    Map<String, AckSchema> extraFields = const {},
  ]) {
    final allFields = {...fields, ...extraFields};

    if (refine case final refinement?) {
      return Ack.object(allFields).refine(refinement, message: refineMessage!);
    }

    return Ack.object(allFields);
  }
}

final Map<SchemaVariant, VariantConditionDefinition>
variantConditionDefinitions = _buildVariantConditionDefinitions();

Map<SchemaVariant, VariantConditionDefinition>
_buildVariantConditionDefinitions() {
  final definitions = <SchemaVariant, VariantConditionDefinition>{
    SchemaVariant.widgetState: VariantConditionDefinition(
      type: SchemaVariant.widgetState,
      fields: {'state': widgetStateSchema},
      sampleFields: {'state': WidgetState.hovered},
      encodeFields: (fields) => {
        'state': (fields['state'] as WidgetState).name,
      },
      buildLeaf: (data) {
        final state = data['state'] as WidgetState;

        return ContextVariantLeaf(
          variant: ContextVariant.widgetState(state),
          canonicalKey: '${SchemaVariant.widgetState.wireValue}:${state.name}',
        );
      },
    ),
    SchemaVariant.enabled: VariantConditionDefinition(
      type: SchemaVariant.enabled,
      fields: const {},
      sampleFields: const {},
      encodeFields: (_) => const {},
      buildLeaf: (_) {
        return ContextVariantLeaf(
          variant: ContextVariant.not(ContextVariant.widgetState(.disabled)),
          canonicalKey: SchemaVariant.enabled.wireValue,
        );
      },
    ),
    SchemaVariant.brightness: VariantConditionDefinition(
      type: SchemaVariant.brightness,
      fields: {'brightness': brightnessSchema},
      sampleFields: {'brightness': Brightness.dark},
      encodeFields: (fields) {
        return {'brightness': (fields['brightness'] as Brightness).name};
      },
      buildLeaf: (data) {
        final brightness = data['brightness'] as Brightness;

        return ContextVariantLeaf(
          variant: ContextVariant.brightness(brightness),
          canonicalKey:
              '${SchemaVariant.brightness.wireValue}:${brightness.name}',
        );
      },
    ),
    SchemaVariant.breakpoint: VariantConditionDefinition(
      type: SchemaVariant.breakpoint,
      fields: {
        'minWidth': Ack.double().nullable().optional(),
        'maxWidth': Ack.double().nullable().optional(),
        'minHeight': Ack.double().nullable().optional(),
        'maxHeight': Ack.double().nullable().optional(),
      },
      refine: _hasAnyBreakpointDimension,
      refineMessage: 'At least one dimension constraint required.',
      sampleFields: const {'minWidth': 768.0},
      encodeFields: (fields) {
        return {
          if (fields['minWidth'] case final minWidth?) 'minWidth': minWidth,
          if (fields['maxWidth'] case final maxWidth?) 'maxWidth': maxWidth,
          if (fields['minHeight'] case final minHeight?) 'minHeight': minHeight,
          if (fields['maxHeight'] case final maxHeight?) 'maxHeight': maxHeight,
        };
      },
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
    ),
    SchemaVariant.notWidgetState: VariantConditionDefinition(
      type: SchemaVariant.notWidgetState,
      fields: {'state': widgetStateSchema},
      refine: (data) => data['state'] != WidgetState.disabled,
      refineMessage: 'Use enabled for not(disabled).',
      sampleFields: {'state': WidgetState.focused},
      encodeFields: (fields) => {
        'state': (fields['state'] as WidgetState).name,
      },
      buildLeaf: (data) {
        final state = data['state'] as WidgetState;

        return ContextVariantLeaf(
          variant: ContextVariant.not(ContextVariant.widgetState(state)),
          canonicalKey:
              '${SchemaVariant.notWidgetState.wireValue}:${state.name}',
        );
      },
    ),
  };

  assert(
    definitions.length == sharedContextVariantLeafTypes.length &&
        sharedContextVariantLeafTypes.every(definitions.containsKey),
    'variantConditionDefinitions must cover every shared context leaf type.',
  );

  return Map.unmodifiable(definitions);
}

VariantConditionDefinition variantConditionDefinition(SchemaVariant type) {
  final definition = variantConditionDefinitions[type];
  if (definition == null) {
    throw StateError('Unsupported shared context leaf type: $type');
  }

  return definition;
}

JsonMap payloadWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(
    SchemaVariant.widgetState,
  ).encode({'state': state});
}

JsonMap payloadEnabledCondition() {
  return variantConditionDefinition(SchemaVariant.enabled).encode(const {});
}

JsonMap payloadBrightnessCondition(Brightness brightness) {
  return variantConditionDefinition(
    SchemaVariant.brightness,
  ).encode({'brightness': brightness});
}

JsonMap payloadBreakpointCondition({
  double? minWidth,
  double? maxWidth,
  double? minHeight,
  double? maxHeight,
}) {
  return variantConditionDefinition(SchemaVariant.breakpoint).encode({
    'minWidth': minWidth,
    'maxWidth': maxWidth,
    'minHeight': minHeight,
    'maxHeight': maxHeight,
  });
}

JsonMap payloadNotWidgetStateCondition(WidgetState state) {
  return variantConditionDefinition(
    SchemaVariant.notWidgetState,
  ).encode({'state': state});
}

bool _hasAnyBreakpointDimension(Map<String, Object?> data) {
  return data['minWidth'] != null ||
      data['maxWidth'] != null ||
      data['minHeight'] != null ||
      data['maxHeight'] != null;
}

String _breakpointCanonicalKey(Map<String, Object?> data) {
  return [
    SchemaVariant.breakpoint.wireValue,
    'minWidth=${data['minWidth']}',
    'maxWidth=${data['maxWidth']}',
    'minHeight=${data['minHeight']}',
    'maxHeight=${data['maxHeight']}',
  ].join(':');
}
