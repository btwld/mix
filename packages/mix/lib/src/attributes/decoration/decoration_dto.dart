// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';
import '../../internal/mix_error.dart';

part 'decoration_dto.g.dart';

typedef _BaseDecorProperties = ({
  ColorDto? color,
  GradientDto? gradient,
  List<BoxShadowDto>? boxShadow,
  DecorationImageDto? image,
});

/// A Data transfer object that represents a [Decoration] value.
///
/// This DTO is used to resolve a [Decoration] value from a [MixContext] instance.
///
/// This class needs to have the different properties that are not found in the [Modifiers] class.
/// In order to support merging of [Decoration] values, and reusable of common properties.
@immutable
sealed class DecorationDto<T extends Decoration> extends Mixable<T> {
  final ColorDto? color;
  final GradientDto? gradient;
  final DecorationImageDto? image;
  @MixableField(
    utilities: [
      MixableFieldUtility(
        alias: 'boxShadows',
        properties: [(path: 'add', alias: 'boxShadow')],
      ),
      MixableFieldUtility(alias: 'elevation', type: 'ElevationUtility'),
    ],
  )
  final List<BoxShadowDto>? boxShadow;

  const DecorationDto({
    required this.color,
    required this.gradient,
    required this.boxShadow,
    required this.image,
  });

  static DecorationDto? tryToMerge(DecorationDto? a, DecorationDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    if (a.runtimeType == b.runtimeType) {
      return a.merge(b);
    }

    if (b.isMergeable) {
      return a.mergeableDecor(b);
    }

    if (b is BoxDecorationDto) {
      return _toBoxDecorationDto(a as ShapeDecorationDto).merge(b);
    }

    if (b is ShapeDecorationDto) {
      return _toShapeDecorationDto(a as BoxDecorationDto).merge(b);
    }

    throw UnimplementedError('Merging of $a and $b is not supported.');
  }

  _BaseDecorProperties _getBaseDecor() {
    return (
      color: color,
      gradient: gradient,
      boxShadow: boxShadow,
      image: image,
    );
  }

  bool get isMergeable;

  DecorationDto? mergeableDecor(covariant DecorationDto? other);

  @override
  DecorationDto<T> merge(covariant DecorationDto<T>? other);
}

/// Represents a Data transfer object of [BoxDecoration]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxDecoration]
@MixableType()
final class BoxDecorationDto extends DecorationDto<BoxDecoration>
    with _$BoxDecorationDto {
  @MixableField(
    utilities: [
      MixableFieldUtility(
        properties: [(path: 'directional', alias: 'borderDirectional')],
      ),
    ],
  )
  final BoxBorderDto? border;

  @MixableField(
    utilities: [
      MixableFieldUtility(
        properties: [(path: 'directional', alias: 'borderRadiusDirectional')],
      ),
    ],
  )
  final BorderRadiusGeometryDto? borderRadius;
  final BoxShape? shape;
  final BlendMode? backgroundBlendMode;

  const BoxDecorationDto({
    this.border,
    this.borderRadius,
    this.shape,
    this.backgroundBlendMode,
    super.color,
    super.image,
    super.gradient,
    super.boxShadow,
  });
  @override
  BoxDecorationDto mergeableDecor(ShapeDecorationDto? other) {
    if (other == null) return this;

    final (:boxShadow, :color, :gradient, :image) = other._getBaseDecor();

    final (:borderRadius, :boxShape, :side) =
        ShapeBorderDto.extract(other.shape);

    return merge(
      BoxDecorationDto(
        border: side != null ? BorderDto.all(side) : null,
        borderRadius: borderRadius,
        shape: boxShape,
        color: color,
        image: image,
        gradient: gradient,
        boxShadow: boxShadow,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties.addUsingDefault('image', image);
    properties.addUsingDefault('color', color);
    properties.addUsingDefault('border', border);
    properties.addUsingDefault('borderRadius', borderRadius);
    properties.addUsingDefault('gradient', gradient);
    properties.add(IterableProperty<BoxShadowDto>(
      'boxShadow',
      boxShadow,
      defaultValue: null,
    ));
    properties.add(EnumProperty<BoxShape>(
      'shape',
      shape,
      defaultValue: null,
    ));
  }

  @override
  bool get isMergeable => backgroundBlendMode == null;
}

@MixableType()
final class ShapeDecorationDto extends DecorationDto<ShapeDecoration>
    with HasDefaultValue<ShapeDecoration>, _$ShapeDecorationDto {
  final ShapeBorderDto? shape;

  const ShapeDecorationDto({
    this.shape,
    super.color,
    super.image,
    super.gradient,
    List<BoxShadowDto>? shadows,
  }) : super(boxShadow: shadows);

  List<BoxShadowDto>? get shadows => boxShadow;
  @override
  ShapeDecorationDto mergeableDecor(BoxDecorationDto? other) {
    if (other == null) return this;

    assert(
      other.border == null || other.border!.isUniform,
      'Border to use with ShapeDecoration must be uniform.',
    );

    final (:boxShadow, :color, :gradient, :image) = other._getBaseDecor();

    final shapeBorder = _fromBoxShape(
      shape: other.shape,
      side: other.border?.top,
      borderRadius: other.borderRadius,
    );

    return merge(
      ShapeDecorationDto(
        shape: shapeBorder,
        color: color,
        image: image,
        gradient: gradient,
        shadows: boxShadow,
      ),
    );
  }

  @override
  bool get isMergeable => (shape == null ||
      (shape is CircleBorderDto &&
          ((shape as CircleBorderDto).eccentricity == null)) ||
      shape is RoundedRectangleBorderDto);

  @override
  ShapeDecoration get defaultValue =>
      const ShapeDecoration(shape: RoundedRectangleBorder());
}

/// Converts a [ShapeDecorationDto] to a [BoxDecorationDto].
BoxDecorationDto _toBoxDecorationDto(ShapeDecorationDto dto) {
  final (:boxShadow, :color, :gradient, :image) = dto._getBaseDecor();
  final (:borderRadius, :boxShape, :side) = ShapeBorderDto.extract(dto.shape);

  return BoxDecorationDto(
    border: side != null ? BorderDto.all(side) : null,
    borderRadius: borderRadius,
    shape: boxShape,
    color: color,
    image: image,
    gradient: gradient,
    boxShadow: boxShadow,
  );
}

ShapeDecorationDto _toShapeDecorationDto(BoxDecorationDto dto) {
  final (:boxShadow, :color, :gradient, :image) = dto._getBaseDecor();
  final shapeBorder = _fromBoxShape(
    shape: dto.shape,
    side: dto.border?.top,
    borderRadius: dto.borderRadius,
  );

  return ShapeDecorationDto(
    shape: shapeBorder,
    color: color,
    image: image,
    gradient: gradient,
    shadows: boxShadow,
  );
}

extension DecorationMixExt on Decoration {
  DecorationDto toDto() {
    final self = this;
    if (self is BoxDecoration) return self.toDto();
    if (self is ShapeDecoration) return self.toDto();

    throw MixError.unsupportedTypeInDto(
      Decoration,
      ['BoxDecoration', 'ShapeDecoration'],
    );
  }
}

ShapeBorderDto? _fromBoxShape({
  required BoxShape? shape,
  required BorderSideDto? side,
  required BorderRadiusGeometryDto? borderRadius,
}) {
  switch (shape) {
    case BoxShape.circle:
      return CircleBorderDto(side: side);
    case BoxShape.rectangle:
      return RoundedRectangleBorderDto(borderRadius: borderRadius, side: side);
    default:
      if (side != null || borderRadius != null) {
        return RoundedRectangleBorderDto(
          borderRadius: borderRadius,
          side: side,
        );
      }

      return null;
  }
}

class DecorationUtility<T extends StyleElement>
    extends MixUtility<T, DecorationDto> {
  const DecorationUtility(super.builder);

  BoxDecorationUtility<T> get box => BoxDecorationUtility(builder);

  ShapeDecorationUtility<T> get shape => ShapeDecorationUtility(builder);
}
