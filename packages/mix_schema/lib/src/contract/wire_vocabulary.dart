import 'package:flutter/widgets.dart';

import 'mix_schema_contract.dart';
import '../schema/primitive_wire.dart';
import '../schema/wire_discriminators.dart';

/// Shared default contract for built-in stylers.
final MixSchemaContract builtInMixSchemaContract = MixSchemaContractBuilder()
    .builtIn()
    .freeze();

/// Styler discriminator wire values for the `type` field.
enum SchemaStyler {
  box(schemaTypeBox),
  text(schemaTypeText),
  flex(schemaTypeFlex),
  stack(schemaTypeStack),
  icon(schemaTypeIcon),
  image(schemaTypeImage),
  flexBox(schemaTypeFlexBox),
  stackBox(schemaTypeStackBox);

  const SchemaStyler(this.wireValue);

  final String wireValue;
}

/// Modifier discriminator wire values currently supported by `mix_schema`.
enum SchemaModifier {
  opacity(modifierTypeOpacity),
  blur(modifierTypeBlur),
  flexible(modifierTypeFlexible),
  defaultTextStyle(modifierTypeDefaultTextStyle);

  const SchemaModifier(this.wireValue);

  final String wireValue;
}

/// Variant discriminator wire values currently supported by `mix_schema`.
enum SchemaVariant {
  named(variantKindNamed),
  widgetState(variantKindWidgetState),
  enabled(variantKindEnabled),
  contextBrightness(variantKindContextBrightness),
  contextBreakpoint(variantKindContextBreakpoint),
  contextNotWidgetState(variantKindContextNotWidgetState);

  const SchemaVariant(this.wireValue);

  final String wireValue;
}

/// Wire value for schema-supported [WidgetState] variant fields.
String payloadWidgetState(WidgetState value) => encodeWidgetStateWire(value);

/// Wire value for canonical color literals.
String payloadColor(Color value) => encodeColorWire(value);

/// Wire value for schema-supported alignments.
Object payloadAlignment(Alignment value) => encodeAlignmentWire(value);
