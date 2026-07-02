library;

import 'package:ack/ack.dart' show JsonMap;
import 'package:flutter/widgets.dart';

import 'src/contract/mix_schema_contract.dart'
    show MixSchemaContract, MixSchemaContractBuilder;
import 'src/schema/primitive_wire.dart';
import 'src/schema/wire_discriminators.dart';

/// Shared default contract for registry-free built-in stylers.
///
/// Payload producers (e.g. `mix_tailwinds`) can decode/encode box, text, flex,
/// stack, flex_box, and stack_box payloads against this instead of freezing a
/// fresh contract per instance. Icon and image stylers use app-owned identity
/// registries, so producers that need those branches should freeze their own
/// [MixSchemaContractBuilder.builtIn] contract with the required registry data.
final MixSchemaContract builtInMixSchemaContract = MixSchemaContractBuilder()
    .builtIn(includeRegistryBacked: false)
    .freeze();

/// Styler discriminator wire values for the `type` field.
///
/// The enum lists the full wire vocabulary. The shared
/// [builtInMixSchemaContract] intentionally excludes [icon] and [image]
/// branches because their identity fields require an app-owned registry.
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
///
/// This is the schema-supported subset of Mix widget modifiers, not every
/// modifier factory exposed by Mix.
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

/// Builds a styler payload with the discriminator already filled in.
JsonMap payloadStyler(SchemaStyler type, [JsonMap? fields]) {
  return {'type': type.wireValue, ...?fields};
}

/// Builds a modifier payload with the discriminator already filled in.
JsonMap payloadModifier(SchemaModifier type, [JsonMap? fields]) {
  return {'type': type.wireValue, ...?fields};
}

/// Builds a variant payload with the discriminator already filled in.
JsonMap payloadVariant(SchemaVariant kind, [JsonMap? fields]) {
  return {'kind': kind.wireValue, ...?fields};
}

/// Wire value for any `enumName`-based field (e.g. [Axis], [Clip], [FlexFit]).
///
/// The built-in codecs encode these enums by their Dart [Enum.name], so this is
/// the canonical producer-side counterpart.
String payloadEnum(Enum value) => value.name;

/// Wire value for schema-supported [WidgetState] variant fields.
String payloadWidgetState(WidgetState value) => encodeWidgetStateWire(value);

String payloadColor(Color value) {
  return encodeColorWire(value);
}

Object payloadAlignment(Alignment value) {
  return encodeAlignmentWire(value);
}

JsonMap payloadOffset(Offset value) {
  return {'x': value.dx, 'y': value.dy};
}

Object payloadEdgeInsets({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) return all;

  return encodeEdgeInsetsWire(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

/// Sparse `BoxConstraints` payload; omits unset bounds.
///
/// Pass [double.infinity] for an explicit unbounded max constraint; it is
/// emitted as `null`, matching the runtime codec's canonical wire form.
JsonMap payloadConstraints({
  double? minWidth,
  double? maxWidth,
  double? minHeight,
  double? maxHeight,
}) {
  return {
    'minWidth': ?minWidth,
    if (maxWidth != null) 'maxWidth': _payloadMaxConstraintBound(maxWidth),
    'minHeight': ?minHeight,
    if (maxHeight != null) 'maxHeight': _payloadMaxConstraintBound(maxHeight),
  };
}

double? _payloadMaxConstraintBound(double value) {
  return value == double.infinity ? null : value;
}

/// Single `BorderSide` payload; omits unset fields.
JsonMap payloadBorderSide({Color? color, double? width, BorderStyle? style}) {
  return {
    if (color != null) 'color': payloadColor(color),
    'width': ?width,
    if (style != null) 'style': payloadEnum(style),
  };
}

/// Sparse `Border` payload; omits absent sides.
JsonMap payloadBorder({
  JsonMap? top,
  JsonMap? right,
  JsonMap? bottom,
  JsonMap? left,
}) {
  return {'top': ?top, 'right': ?right, 'bottom': ?bottom, 'left': ?left};
}

/// Sparse per-corner `BorderRadius` payload; omits unset corners.
JsonMap payloadBorderRadius({
  double? topLeft,
  double? topRight,
  double? bottomLeft,
  double? bottomRight,
}) {
  return {
    'topLeft': ?topLeft,
    'topRight': ?topRight,
    'bottomLeft': ?bottomLeft,
    'bottomRight': ?bottomRight,
  };
}

/// Sparse `TextStyle` payload covering the fields producers emit.
JsonMap payloadTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  TextDecoration? decoration,
  double? height,
  double? letterSpacing,
}) {
  return {
    if (color != null) 'color': payloadColor(color),
    'fontSize': ?fontSize,
    if (fontWeight != null) 'fontWeight': payloadFontWeight(fontWeight),
    if (decoration != null) 'decoration': payloadTextDecoration(decoration),
    'height': ?height,
    'letterSpacing': ?letterSpacing,
  };
}

/// Wire value for the schema's supported [FontWeight] values.
String payloadFontWeight(FontWeight value) => encodeFontWeightWire(value);

/// Wire value for the schema's supported [TextDecoration] values.
String payloadTextDecoration(TextDecoration value) =>
    encodeTextDecorationWire(value);

JsonMap payloadShadow(Shadow value) {
  return {
    'color': payloadColor(value.color),
    'offset': payloadOffset(value.offset),
    'blurRadius': value.blurRadius,
  };
}

JsonMap payloadBoxShadow(BoxShadow value) {
  return {
    'color': payloadColor(value.color),
    'offset': payloadOffset(value.offset),
    'blurRadius': value.blurRadius,
    'spreadRadius': value.spreadRadius,
  };
}

/// Sparse `TextHeightBehavior` payload; omits unset fields.
JsonMap payloadTextHeightBehavior({
  bool? applyHeightToFirstAscent,
  bool? applyHeightToLastDescent,
  TextLeadingDistribution? leadingDistribution,
}) {
  return {
    'applyHeightToFirstAscent': ?applyHeightToFirstAscent,
    'applyHeightToLastDescent': ?applyHeightToLastDescent,
    if (leadingDistribution != null)
      'leadingDistribution': payloadEnum(leadingDistribution),
  };
}

/// Sparse `BoxDecoration` payload covering the fields producers emit today.
JsonMap payloadDecoration({
  Color? color,
  JsonMap? border,
  Object? borderRadius,
  List<JsonMap>? boxShadow,
}) {
  return {
    if (color != null) 'color': payloadColor(color),
    'border': ?border,
    'borderRadius': ?borderRadius,
    'boxShadow': ?boxShadow,
  };
}
