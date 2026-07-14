import 'package:flutter/widgets.dart';

import '../schema/primitive_wire.dart';
import '../schema/wire_discriminators.dart';

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

/// Modifier discriminator wire values currently supported by `mix_protocol`.
enum SchemaModifier {
  align(modifierTypeAlign),
  aspectRatio(modifierTypeAspectRatio),
  opacity(modifierTypeOpacity),
  blur(modifierTypeBlur),
  box(modifierTypeBox),
  clipOval(modifierTypeClipOval),
  clipRect(modifierTypeClipRect),
  clipRRect(modifierTypeClipRRect),
  clipTriangle(modifierTypeClipTriangle),
  flexible(modifierTypeFlexible),
  defaultTextStyle(modifierTypeDefaultTextStyle),
  defaultTextStyler(modifierTypeDefaultTextStyler),
  fractionallySizedBox(modifierTypeFractionallySizedBox),
  iconTheme(modifierTypeIconTheme),
  intrinsicHeight(modifierTypeIntrinsicHeight),
  intrinsicWidth(modifierTypeIntrinsicWidth),
  padding(modifierTypePadding),
  rotate(modifierTypeRotate),
  rotatedBox(modifierTypeRotatedBox),
  scale(modifierTypeScale),
  scrollView(modifierTypeScrollView),
  sizedBox(modifierTypeSizedBox),
  skew(modifierTypeSkew),
  transform(modifierTypeTransform),
  translate(modifierTypeTranslate),
  visibility(modifierTypeVisibility);

  const SchemaModifier(this.wireValue);

  final String wireValue;
}

/// Variant discriminator wire values currently supported by `mix_protocol`.
enum SchemaVariant {
  named(variantKindNamed),
  widgetState(variantKindWidgetState),
  enabled(variantKindEnabled),
  contextBrightness(variantKindContextBrightness),
  contextBreakpoint(variantKindContextBreakpoint),
  contextDirectionality(variantKindContextDirectionality),
  contextNot(variantKindContextNot),
  contextNotWidgetState(variantKindContextNotWidgetState),
  contextOrientation(variantKindContextOrientation),
  contextPlatform(variantKindContextPlatform),
  contextWeb(variantKindContextWeb);

  const SchemaVariant(this.wireValue);

  final String wireValue;
}

/// Wire value for schema-supported [WidgetState] variant fields.
String payloadWidgetState(WidgetState value) => encodeWidgetStateWire(value);

/// Wire value for canonical color literals.
String payloadColor(Color value) => encodeColorWire(value);

/// Wire value for schema-supported alignments.
Object payloadAlignment(Alignment value) => encodeAlignmentWire(value);
