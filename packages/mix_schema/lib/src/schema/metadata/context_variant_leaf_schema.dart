import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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

AckSchema<ContextVariantLeaf> buildContextVariantLeafSchema({
  required SchemaVariant type,
}) {
  return _contextVariantLeafDefinition(type).buildLeafSchema();
}

AckSchema<VariantStyle<S>> buildContextVariantStyleBranch<
  S extends Spec<S>,
  T extends Style<S>
>({required SchemaVariant type, required AckSchema<T> styleSchema}) {
  return _contextVariantLeafDefinition(type).buildVariantSchema(styleSchema);
}

typedef _ContextVariantRefinement = bool Function(Map<String, Object?> data);

final class _ContextVariantLeafDefinition {
  final Map<String, AckSchema> fields;
  final _ContextVariantRefinement? refine;
  final String? refineMessage;
  final ContextVariantLeaf Function(Map<String, Object?> data) buildLeaf;

  const _ContextVariantLeafDefinition({
    required this.fields,
    this.refine,
    this.refineMessage,
    required this.buildLeaf,
  });

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

_ContextVariantLeafDefinition _contextVariantLeafDefinition(
  SchemaVariant type,
) {
  switch (type) {
    case .widgetState:
      return _ContextVariantLeafDefinition(
        fields: {'state': widgetStateSchema},
        buildLeaf: (data) {
          final state = data['state'] as WidgetState;

          return ContextVariantLeaf(
            variant: ContextVariant.widgetState(state),
            canonicalKey:
                '${SchemaVariant.widgetState.wireValue}:${state.name}',
          );
        },
      );
    case .enabled:
      return _ContextVariantLeafDefinition(
        fields: const {},
        buildLeaf: (_) {
          return ContextVariantLeaf(
            variant: ContextVariant.not(ContextVariant.widgetState(.disabled)),
            canonicalKey: SchemaVariant.enabled.wireValue,
          );
        },
      );
    case .brightness:
      return _ContextVariantLeafDefinition(
        fields: {'brightness': brightnessSchema},
        buildLeaf: (data) {
          final brightness = data['brightness'] as Brightness;

          return ContextVariantLeaf(
            variant: ContextVariant.brightness(brightness),
            canonicalKey:
                '${SchemaVariant.brightness.wireValue}:${brightness.name}',
          );
        },
      );
    case .breakpoint:
      return _ContextVariantLeafDefinition(
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
      );
    case .notWidgetState:
      return _ContextVariantLeafDefinition(
        fields: {'state': widgetStateSchema},
        refine: (data) => data['state'] != WidgetState.disabled,
        refineMessage: 'Use enabled for not(disabled).',
        buildLeaf: (data) {
          final state = data['state'] as WidgetState;

          return ContextVariantLeaf(
            variant: ContextVariant.not(ContextVariant.widgetState(state)),
            canonicalKey:
                '${SchemaVariant.notWidgetState.wireValue}:${state.name}',
          );
        },
      );
    case .named || .contextAllOf || .contextBuilder:
      throw StateError('Unsupported shared context leaf type: $type');
  }
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
