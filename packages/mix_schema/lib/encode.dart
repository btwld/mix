// Low-level producer-facing APIs for building Mix schema payload fragments.
//
// This surface intentionally exposes wire identifiers plus a small set of
// primitive and condition helpers. It does not try to be a full payload
// builder for the entire contract; richer producer discovery should go through
// MixSchemaContract.exportMetadata().
export 'src/core/json_map.dart' show JsonMap;
export 'src/core/schema_wire_types.dart'
    show
        SchemaBorder,
        SchemaBorderRadius,
        SchemaDecoration,
        SchemaGradient,
        SchemaGradientTransform,
        SchemaModifier,
        SchemaShapeBorder,
        SchemaStyler,
        SchemaTextScaler,
        SchemaVariant;
export 'src/encoder/payload_encoder.dart';
export 'src/encoder/variant_condition_encoder.dart'
    show
        payloadBreakpointCondition,
        payloadBrightnessCondition,
        payloadEnabledCondition,
        payloadNotWidgetStateCondition,
        payloadWidgetStateCondition;
