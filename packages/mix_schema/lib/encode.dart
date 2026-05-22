// Low-level producer-facing APIs for building Mix schema payload fragments.
//
// This surface intentionally exposes only small primitive and condition
// helpers. Producer discovery and validation should go through
// MixSchemaContract.rootSchema, decode, encode, and exportJsonSchema().
export 'package:ack/ack.dart' show JsonMap;

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
export 'src/encoder/primitive_payload_helpers.dart'
    show payloadAlignment, payloadColor, payloadOffset, payloadRadius;
export 'src/encoder/variant_condition_encoder.dart'
    show
        payloadBreakpointCondition,
        payloadBrightnessCondition,
        payloadEnabledCondition,
        payloadNotWidgetStateCondition,
        payloadWidgetStateCondition;
