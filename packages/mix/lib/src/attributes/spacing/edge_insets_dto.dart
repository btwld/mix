// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';
import '../../internal/mix_error.dart';

part 'edge_insets_dto.g.dart';

@Deprecated('Use EdgeInsetsGeometryDto instead')
typedef SpacingDto = EdgeInsetsGeometryDto<EdgeInsetsGeometry>;

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mixable<T> {
  final double? top;
  final double? bottom;

  const EdgeInsetsGeometryDto({this.top, this.bottom});

  static EdgeInsetsGeometryDto only({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    final isDirectional = start != null || end != null;
    final isNotDirectional = left != null || right != null;

    assert(
      (!isDirectional && !isNotDirectional) ||
          isDirectional == !isNotDirectional,
      'Cannot provide both directional and non-directional values',
    );
    if (start != null || end != null) {
      return EdgeInsetsDirectionalDto(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      );
    }

    return EdgeInsetsDto(top: top, bottom: bottom, left: left, right: right);
  }

  static EdgeInsetsGeometryDto? tryToMerge(
    EdgeInsetsGeometryDto? a,
    EdgeInsetsGeometryDto? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<A extends EdgeInsetsGeometryDto,
      B extends EdgeInsetsGeometryDto>(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (EdgeInsetsDto g) => a._asEdgeInset().merge(g) as B,
      (EdgeInsetsDirectionalDto g) => a._asEdgeInsetDirectional().merge(g) as B,
    };
  }

  EdgeInsetsDto _asEdgeInset() {
    if (this is EdgeInsetsDto) return this as EdgeInsetsDto;

    return EdgeInsetsDto(top: top, bottom: bottom);
  }

  EdgeInsetsDirectionalDto _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalDto) {
      return this as EdgeInsetsDirectionalDto;
    }

    return EdgeInsetsDirectionalDto(top: top, bottom: bottom);
  }

  @override
  EdgeInsetsGeometryDto<T> merge(covariant EdgeInsetsGeometryDto<T>? other);
}

@MixableType()
final class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets>
    with _$EdgeInsetsDto, Diagnosticable {
  final double? left;
  final double? right;

  const EdgeInsetsDto({super.top, super.bottom, this.left, this.right});

  const EdgeInsetsDto.all(double value)
      : this(top: value, bottom: value, left: value, right: value);

  const EdgeInsetsDto.none() : this.all(0);

  @override
  EdgeInsets resolve(MixContext mix) {
    return EdgeInsets.only(
      left: mix.tokens.spaceTokenRef(left ?? 0),
      top: mix.tokens.spaceTokenRef(top ?? 0),
      right: mix.tokens.spaceTokenRef(right ?? 0),
      bottom: mix.tokens.spaceTokenRef(bottom ?? 0),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.addUsingDefault('top', top);
    properties.addUsingDefault('bottom', bottom);
    properties.addUsingDefault('left', left);
    properties.addUsingDefault('right', right);
  }
}

@MixableType()
final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional>
    with _$EdgeInsetsDirectionalDto {
  final double? start;
  final double? end;

  const EdgeInsetsDirectionalDto.all(double value)
      : this(top: value, bottom: value, start: value, end: value);

  const EdgeInsetsDirectionalDto.none() : this.all(0);

  const EdgeInsetsDirectionalDto({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

  @override
  EdgeInsetsDirectional resolve(MixContext mix) {
    return EdgeInsetsDirectional.only(
      start: mix.tokens.spaceTokenRef(start ?? 0),
      top: mix.tokens.spaceTokenRef(top ?? 0),
      end: mix.tokens.spaceTokenRef(end ?? 0),
      bottom: mix.tokens.spaceTokenRef(bottom ?? 0),
    );
  }
}

extension EdgeInsetsGeometryExt on EdgeInsetsGeometry {
  EdgeInsetsGeometryDto toDto() {
    final self = this;
    if (self is EdgeInsetsDirectional) return self.toDto();
    if (self is EdgeInsets) return self.toDto();

    throw MixError.unsupportedTypeInDto(
      EdgeInsetsGeometry,
      ['EdgeInsetsDirectional', 'EdgeInsets'],
    );
  }
}
