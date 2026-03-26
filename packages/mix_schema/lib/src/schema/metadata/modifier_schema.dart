import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';
import '../shared/edge_insets_schema.dart';
import '../shared/enum_schemas.dart';
import '../shared/primitive_schemas.dart';
import '../shared/typography_schemas.dart';

AckSchema<ModifierMix> buildModifierSchema() {
  final registry = DiscriminatedBranchRegistry<ModifierMix>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaModifier.values) {
    registry.register(type.wireValue, _buildModifierBranch(type));
  }

  return registry.freeze();
}

WidgetModifierConfig? buildWidgetModifierConfigFromFields(
  Map<String, Object?> data,
) {
  final List<ModifierMix>? modifiers = castListOrNull(data['modifiers']);
  final List<String>? wireOrder = castListOrNull(data['modifierOrder']);

  if (modifiers == null && wireOrder == null) {
    return null;
  }

  final orderOfModifiers = wireOrder
      ?.map(SchemaModifier.fromWireValue)
      .whereType<SchemaModifier>()
      .map(_modifierRuntimeType)
      .toList(growable: false);

  return WidgetModifierConfig(
    modifiers: modifiers ?? const [],
    orderOfModifiers: orderOfModifiers == null || orderOfModifiers.isEmpty
        ? null
        : orderOfModifiers,
  );
}

AckSchema<ModifierMix> _buildModifierBranch(SchemaModifier type) {
  switch (type) {
    case .reset:
      return Ack.object(
        const {},
      ).transform<ModifierMix>((_) => const ResetModifierMix());
    case .blur:
      return Ack.object({
        'sigma': Ack.double().min(0).optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return BlurModifierMix(sigma: map['sigma'] as double?);
      });
    case .opacity:
      return Ack.object({
        'value': Ack.double().min(0).max(1),
      }).transform<ModifierMix>((data) {
        final map = data;

        return OpacityModifierMix(opacity: map['value'] as double);
      });
    case .visibility:
      return Ack.object({'visible': Ack.boolean()}).transform<ModifierMix>((
        data,
      ) {
        final map = data;

        return VisibilityModifierMix(visible: map['visible'] as bool);
      });
    case .align:
      return Ack.object({
        'alignment': alignmentSchema.optional(),
        'widthFactor': Ack.double().optional(),
        'heightFactor': Ack.double().optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return AlignModifierMix(
          alignment: map['alignment'] as AlignmentGeometry?,
          widthFactor: map['widthFactor'] as double?,
          heightFactor: map['heightFactor'] as double?,
        );
      });
    case .padding:
      return Ack.object({
        'padding': edgeInsetsGeometrySchema.optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return PaddingModifierMix(
          padding: map['padding'] as EdgeInsetsGeometryMix?,
        );
      });
    case .scale:
      return Ack.object({
        'x': Ack.double(),
        'y': Ack.double(),
        'alignment': alignmentSchema.optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return ScaleModifierMix(
          x: map['x'] as double,
          y: map['y'] as double,
          alignment: map['alignment'] as Alignment?,
        );
      });
    case .rotate:
      return Ack.object({
        'radians': Ack.double(),
        'alignment': alignmentSchema.optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return RotateModifierMix(
          radians: map['radians'] as double,
          alignment: map['alignment'] as Alignment?,
        );
      });
    case .defaultTextStyle:
      return Ack.object({
        'style': textStyleSchema.optional(),
        'textAlign': textAlignSchema.optional(),
        'softWrap': Ack.boolean().optional(),
        'overflow': textOverflowSchema.optional(),
        'maxLines': Ack.integer().min(1).optional(),
        'textWidthBasis': textWidthBasisSchema.optional(),
        'textHeightBehavior': textHeightBehaviorSchema.optional(),
      }).transform<ModifierMix>((data) {
        final map = data;

        return DefaultTextStyleModifierMix(
          style: map['style'] as TextStyleMix?,
          textAlign: map['textAlign'] as TextAlign?,
          softWrap: map['softWrap'] as bool?,
          overflow: map['overflow'] as TextOverflow?,
          maxLines: map['maxLines'] as int?,
          textWidthBasis: map['textWidthBasis'] as TextWidthBasis?,
          textHeightBehavior:
              map['textHeightBehavior'] as TextHeightBehaviorMix?,
        );
      });
  }
}

Type _modifierRuntimeType(SchemaModifier type) {
  return switch (type) {
    .reset => ResetModifier,
    .blur => BlurModifier,
    .opacity => OpacityModifier,
    .visibility => VisibilityModifier,
    .align => AlignModifier,
    .padding => PaddingModifier,
    .scale => ScaleModifier,
    .rotate => RotateModifier,
    .defaultTextStyle => DefaultTextStyleModifier,
  };
}
