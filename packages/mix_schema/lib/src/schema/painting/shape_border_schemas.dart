import 'package:ack/ack.dart';
import 'package:mix/mix.dart';

import '../../core/schema_wire_types.dart';
import '../discriminated_branch_registry.dart';

final AckSchema<LinearBorderEdgeMix> linearBorderEdgeSchema =
    Ack.object({
      'size': Ack.double().optional(),
      'alignment': Ack.double().optional(),
    }).transform<LinearBorderEdgeMix>((data) {
      final map = data!;

      return LinearBorderEdgeMix(
        size: map['size'] as double?,
        alignment: map['alignment'] as double?,
      );
    });

AckSchema<ShapeBorderMix> buildShapeBorderSchema({
  required AckSchema<BorderSideMix> borderSideSchema,
  required AckSchema<BorderRadiusGeometryMix> borderRadiusSchema,
}) {
  final registry = DiscriminatedBranchRegistry<ShapeBorderMix>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaShapeBorder.values) {
    registry.register(
      type.wireValue,
      _buildShapeBorderBranch(
        type: type,
        borderSideSchema: borderSideSchema,
        borderRadiusSchema: borderRadiusSchema,
      ),
    );
  }

  return registry.freeze();
}

AckSchema<ShapeBorderMix> _buildShapeBorderBranch({
  required SchemaShapeBorder type,
  required AckSchema<BorderSideMix> borderSideSchema,
  required AckSchema<BorderRadiusGeometryMix> borderRadiusSchema,
}) {
  switch (type) {
    case .roundedRectangle:
      return Ack.object({
        'borderRadius': borderRadiusSchema.optional(),
        'side': borderSideSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return RoundedRectangleBorderMix(
          borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
          side: map['side'] as BorderSideMix?,
        );
      });
    case .roundedSuperellipse:
      return Ack.object({
        'borderRadius': borderRadiusSchema.optional(),
        'side': borderSideSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return RoundedSuperellipseBorderMix(
          borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
          side: map['side'] as BorderSideMix?,
        );
      });
    case .beveledRectangle:
      return Ack.object({
        'borderRadius': borderRadiusSchema.optional(),
        'side': borderSideSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return BeveledRectangleBorderMix(
          borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
          side: map['side'] as BorderSideMix?,
        );
      });
    case .continuousRectangle:
      return Ack.object({
        'borderRadius': borderRadiusSchema.optional(),
        'side': borderSideSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return ContinuousRectangleBorderMix(
          borderRadius: map['borderRadius'] as BorderRadiusGeometryMix?,
          side: map['side'] as BorderSideMix?,
        );
      });
    case .circle:
      return Ack.object({
        'side': borderSideSchema.optional(),
        'eccentricity': Ack.double().optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return CircleBorderMix(
          side: map['side'] as BorderSideMix?,
          eccentricity: map['eccentricity'] as double?,
        );
      });
    case .star:
      return Ack.object({
        'side': borderSideSchema.optional(),
        'points': Ack.double().optional(),
        'innerRadiusRatio': Ack.double().optional(),
        'pointRounding': Ack.double().optional(),
        'valleyRounding': Ack.double().optional(),
        'rotation': Ack.double().optional(),
        'squash': Ack.double().optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return StarBorderMix(
          side: map['side'] as BorderSideMix?,
          points: map['points'] as double?,
          innerRadiusRatio: map['innerRadiusRatio'] as double?,
          pointRounding: map['pointRounding'] as double?,
          valleyRounding: map['valleyRounding'] as double?,
          rotation: map['rotation'] as double?,
          squash: map['squash'] as double?,
        );
      });
    case .linear:
      return Ack.object({
        'side': borderSideSchema.optional(),
        'start': linearBorderEdgeSchema.optional(),
        'end': linearBorderEdgeSchema.optional(),
        'top': linearBorderEdgeSchema.optional(),
        'bottom': linearBorderEdgeSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return LinearBorderMix(
          side: map['side'] as BorderSideMix?,
          start: map['start'] as LinearBorderEdgeMix?,
          end: map['end'] as LinearBorderEdgeMix?,
          top: map['top'] as LinearBorderEdgeMix?,
          bottom: map['bottom'] as LinearBorderEdgeMix?,
        );
      });
    case .stadium:
      return Ack.object({
        'side': borderSideSchema.optional(),
      }).transform<ShapeBorderMix>((data) {
        final map = data!;

        return StadiumBorderMix(side: map['side'] as BorderSideMix?);
      });
  }
}
