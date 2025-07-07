// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/mix_error.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mixable<T> {
  final SpaceDto? top;
  final SpaceDto? bottom;

  @protected
  const EdgeInsetsGeometryDto.raw({this.top, this.bottom});

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
      return EdgeInsetsDirectionalDto.raw(
        top: top != null ? SpaceDto.value(top) : null,
        bottom: bottom != null ? SpaceDto.value(bottom) : null,
        start: start != null ? SpaceDto.value(start) : null,
        end: end != null ? SpaceDto.value(end) : null,
      );
    }

    return EdgeInsetsDto.raw(
      top: top != null ? SpaceDto.value(top) : null,
      bottom: bottom != null ? SpaceDto.value(bottom) : null,
      left: left != null ? SpaceDto.value(left) : null,
      right: right != null ? SpaceDto.value(right) : null,
    );
  }

  static EdgeInsetsGeometryDto? tryToMerge(
    EdgeInsetsGeometryDto? a,
    EdgeInsetsGeometryDto? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<
    A extends EdgeInsetsGeometryDto,
    B extends EdgeInsetsGeometryDto
  >(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (EdgeInsetsDto g) => a._asEdgeInset().merge(g) as B,
      (EdgeInsetsDirectionalDto g) => a._asEdgeInsetDirectional().merge(g) as B,
    };
  }

  EdgeInsetsDto _asEdgeInset() {
    if (this is EdgeInsetsDto) return this as EdgeInsetsDto;

    return EdgeInsetsDto.raw(top: top, bottom: bottom);
  }

  EdgeInsetsDirectionalDto _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalDto) {
      return this as EdgeInsetsDirectionalDto;
    }

    return EdgeInsetsDirectionalDto.raw(top: top, bottom: bottom);
  }

  @override
  EdgeInsetsGeometryDto<T> merge(covariant EdgeInsetsGeometryDto<T>? other);
}

final class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets> {
  final SpaceDto? left;
  final SpaceDto? right;

  @protected
  const EdgeInsetsDto.raw({super.top, super.bottom, this.left, this.right})
    : super.raw();

  // Unnamed constructor for backward compatibility
  factory EdgeInsetsDto({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsetsDto.raw(
      top: top != null ? SpaceDto.value(top) : null,
      bottom: bottom != null ? SpaceDto.value(bottom) : null,
      left: left != null ? SpaceDto.value(left) : null,
      right: right != null ? SpaceDto.value(right) : null,
    );
  }

  EdgeInsetsDto.all(double value)
    : this.raw(
        top: SpaceDto.value(value),
        bottom: SpaceDto.value(value),
        left: SpaceDto.value(value),
        right: SpaceDto.value(value),
      );

  EdgeInsetsDto.none() : this.all(0);

  @override
  EdgeInsets resolve(MixContext mix) {
    return EdgeInsets.only(
      left: left?.resolve(mix) ?? 0,
      top: top?.resolve(mix) ?? 0,
      right: right?.resolve(mix) ?? 0,
      bottom: bottom?.resolve(mix) ?? 0,
    );
  }

  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;

    return EdgeInsetsDto.raw(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      left: other.left ?? left,
      right: other.right ?? right,
    );
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}

final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional> {
  final SpaceDto? start;
  final SpaceDto? end;

  EdgeInsetsDirectionalDto.all(double value)
    : this.raw(
        top: SpaceDto.value(value),
        bottom: SpaceDto.value(value),
        start: SpaceDto.value(value),
        end: SpaceDto.value(value),
      );

  EdgeInsetsDirectionalDto.none() : this.all(0);

  @protected
  const EdgeInsetsDirectionalDto.raw({
    super.top,
    super.bottom,
    this.start,
    this.end,
  }) : super.raw();

  // Unnamed constructor for backward compatibility
  factory EdgeInsetsDirectionalDto({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    return EdgeInsetsDirectionalDto.raw(
      top: top != null ? SpaceDto.value(top) : null,
      bottom: bottom != null ? SpaceDto.value(bottom) : null,
      start: start != null ? SpaceDto.value(start) : null,
      end: end != null ? SpaceDto.value(end) : null,
    );
  }

  @override
  EdgeInsetsDirectional resolve(MixContext mix) {
    return EdgeInsetsDirectional.only(
      start: start?.resolve(mix) ?? 0,
      top: top?.resolve(mix) ?? 0,
      end: end?.resolve(mix) ?? 0,
      bottom: bottom?.resolve(mix) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalDto.raw(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      start: start?.merge(other.start) ?? other.start,
      end: end?.merge(other.end) ?? other.end,
    );
  }

  @override
  List<Object?> get props => [top, bottom, start, end];
}

extension EdgeInsetsGeometryExt on EdgeInsetsGeometry {
  EdgeInsetsGeometryDto toDto() {
    final self = this;
    if (self is EdgeInsetsDirectional) {
      return EdgeInsetsDirectionalDto.raw(
        top: SpaceDto.value(self.top),
        bottom: SpaceDto.value(self.bottom),
        start: SpaceDto.value(self.start),
        end: SpaceDto.value(self.end),
      );
    }
    if (self is EdgeInsets) {
      return EdgeInsetsDto.raw(
        top: SpaceDto.value(self.top),
        bottom: SpaceDto.value(self.bottom),
        left: SpaceDto.value(self.left),
        right: SpaceDto.value(self.right),
      );
    }

    throw MixError.unsupportedTypeInDto(EdgeInsetsGeometry, [
      'EdgeInsetsDirectional',
      'EdgeInsets',
    ]);
  }
}
