// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final MixProp<double, SpaceDto>? top;
  final MixProp<double, SpaceDto>? bottom;

  const EdgeInsetsGeometryDto._({this.top, this.bottom});

  factory EdgeInsetsGeometryDto.value(EdgeInsetsGeometry edgeInsetsGeometry) {
    return switch (edgeInsetsGeometry) {
          EdgeInsets() => EdgeInsetsDto.value(edgeInsetsGeometry),
          EdgeInsetsDirectional() => EdgeInsetsDirectionalDto.value(
            edgeInsetsGeometry,
          ),
          _ => throw ArgumentError(
            'Unsupported EdgeInsetsGeometry type: ${edgeInsetsGeometry.runtimeType}',
          ),
        }
        as EdgeInsetsGeometryDto<T>;
  }

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
      return EdgeInsetsDirectionalDto._(
        top: MixProp.maybeValue(SpaceDto.maybeValue(top)),
        bottom: MixProp.maybeValue(SpaceDto.maybeValue(bottom)),
        start: MixProp.maybeValue(SpaceDto.maybeValue(start)),
        end: MixProp.maybeValue(SpaceDto.maybeValue(end)),
      );
    }

    return EdgeInsetsDto._(
      top: MixProp.maybeValue(SpaceDto.maybeValue(top)),
      bottom: MixProp.maybeValue(SpaceDto.maybeValue(bottom)),
      left: MixProp.maybeValue(SpaceDto.maybeValue(left)),
      right: MixProp.maybeValue(SpaceDto.maybeValue(right)),
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

    return EdgeInsetsDto._(top: top, bottom: bottom);
  }

  EdgeInsetsDirectionalDto _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalDto) {
      return this as EdgeInsetsDirectionalDto;
    }

    return EdgeInsetsDirectionalDto._(top: top, bottom: bottom);
  }

  @override
  EdgeInsetsGeometryDto<T> merge(covariant EdgeInsetsGeometryDto<T>? other);
}

final class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets> {
  final MixProp<double, SpaceDto>? left;
  final MixProp<double, SpaceDto>? right;

  const EdgeInsetsDto._({super.top, super.bottom, this.left, this.right})
    : super._();

  // Main constructor accepts raw double values
  factory EdgeInsetsDto({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsetsDto._(
      top: MixProp.maybeValue(SpaceDto.maybeValue(top)),
      bottom: MixProp.maybeValue(SpaceDto.maybeValue(bottom)),
      left: MixProp.maybeValue(SpaceDto.maybeValue(left)),
      right: MixProp.maybeValue(SpaceDto.maybeValue(right)),
    );
  }

  /// Constructor that accepts an [EdgeInsets] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsets] instances to [EdgeInsetsDto].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDto.value(edgeInsets);
  /// ```
  factory EdgeInsetsDto.value(EdgeInsets edgeInsets) {
    return EdgeInsetsDto._(
      top: MixProp.value(SpaceDto.value(edgeInsets.top)),
      bottom: MixProp.value(SpaceDto.value(edgeInsets.bottom)),
      left: MixProp.value(SpaceDto.value(edgeInsets.left)),
      right: MixProp.value(SpaceDto.value(edgeInsets.right)),
    );
  }

  EdgeInsetsDto.all(double value)
    : this._(
        top: MixProp.value(SpaceDto.value(value)),
        bottom: MixProp.value(SpaceDto.value(value)),
        left: MixProp.value(SpaceDto.value(value)),
        right: MixProp.value(SpaceDto.value(value)),
      );

  EdgeInsetsDto.none() : this.all(0);

  /// Factory constructor that accepts SpaceDto parameters.
  ///
  /// This is useful for utilities that work with SpaceDto objects.
  ///
  /// ```dart
  /// final dto = EdgeInsetsDto.valueSpaceDto(
  ///   top: SpaceDto.value(8.0),
  ///   left: SpaceDto.token(someToken),
  /// );
  /// ```
  factory EdgeInsetsDto.valueSpaceDto({
    SpaceDto? top,
    SpaceDto? bottom,
    SpaceDto? left,
    SpaceDto? right,
  }) {
    return EdgeInsetsDto._(
      top: MixProp.maybeValue(top),
      bottom: MixProp.maybeValue(bottom),
      left: MixProp.maybeValue(left),
      right: MixProp.maybeValue(right),
    );
  }

  /// Constructor that accepts a nullable [EdgeInsets] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [EdgeInsetsDto.value].
  ///
  /// ```dart
  /// const EdgeInsets? edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDto.maybeValue(edgeInsets); // Returns EdgeInsetsDto or null
  /// ```
  static EdgeInsetsDto? maybeValue(EdgeInsets? edgeInsets) {
    return edgeInsets != null ? EdgeInsetsDto.value(edgeInsets) : null;
  }

  @override
  EdgeInsets resolve(MixContext context) {
    return EdgeInsets.only(
      left: left?.resolve(context) ?? 0,
      top: top?.resolve(context) ?? 0,
      right: right?.resolve(context) ?? 0,
      bottom: bottom?.resolve(context) ?? 0,
    );
  }

  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;

    return EdgeInsetsDto._(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      left: left?.merge(other.left) ?? other.left,
      right: right?.merge(other.right) ?? other.right,
    );
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}

final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional> {
  final MixProp<double, SpaceDto>? start;
  final MixProp<double, SpaceDto>? end;

  const EdgeInsetsDirectionalDto._({
    super.top,
    super.bottom,
    this.start,
    this.end,
  }) : super._();

  // Main constructor accepts raw double values
  factory EdgeInsetsDirectionalDto({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    return EdgeInsetsDirectionalDto._(
      top: MixProp.maybeValue(SpaceDto.maybeValue(top)),
      bottom: MixProp.maybeValue(SpaceDto.maybeValue(bottom)),
      start: MixProp.maybeValue(SpaceDto.maybeValue(start)),
      end: MixProp.maybeValue(SpaceDto.maybeValue(end)),
    );
  }

  /// Constructor that accepts an [EdgeInsetsDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsetsDirectional] instances to [EdgeInsetsDirectionalDto].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDirectionalDto.value(edgeInsets);
  /// ```
  factory EdgeInsetsDirectionalDto.value(EdgeInsetsDirectional edgeInsets) {
    return EdgeInsetsDirectionalDto._(
      top: MixProp.value(SpaceDto.value(edgeInsets.top)),
      bottom: MixProp.value(SpaceDto.value(edgeInsets.bottom)),
      start: MixProp.value(SpaceDto.value(edgeInsets.start)),
      end: MixProp.value(SpaceDto.value(edgeInsets.end)),
    );
  }

  EdgeInsetsDirectionalDto.all(double value)
    : this._(
        top: MixProp.value(SpaceDto.value(value)),
        bottom: MixProp.value(SpaceDto.value(value)),
        start: MixProp.value(SpaceDto.value(value)),
        end: MixProp.value(SpaceDto.value(value)),
      );

  EdgeInsetsDirectionalDto.none() : this.all(0);

  /// Factory constructor that accepts SpaceDto parameters.
  ///
  /// This is useful for utilities that work with SpaceDto objects.
  ///
  /// ```dart
  /// final dto = EdgeInsetsDirectionalDto.valueSpaceDto(
  ///   top: SpaceDto.value(8.0),
  ///   start: SpaceDto.token(someToken),
  /// );
  /// ```
  factory EdgeInsetsDirectionalDto.valueSpaceDto({
    SpaceDto? top,
    SpaceDto? bottom,
    SpaceDto? start,
    SpaceDto? end,
  }) {
    return EdgeInsetsDirectionalDto._(
      top: MixProp.maybeValue(top),
      bottom: MixProp.maybeValue(bottom),
      start: MixProp.maybeValue(start),
      end: MixProp.maybeValue(end),
    );
  }

  /// Constructor that accepts a nullable [EdgeInsetsDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [EdgeInsetsDirectionalDto.value].
  ///
  /// ```dart
  /// const EdgeInsetsDirectional? edgeInsets = EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDirectionalDto.maybeValue(edgeInsets); // Returns EdgeInsetsDirectionalDto or null
  /// ```
  static EdgeInsetsDirectionalDto? maybeValue(
    EdgeInsetsDirectional? edgeInsets,
  ) {
    return edgeInsets != null
        ? EdgeInsetsDirectionalDto.value(edgeInsets)
        : null;
  }

  @override
  EdgeInsetsDirectional resolve(MixContext context) {
    return EdgeInsetsDirectional.only(
      start: start?.resolve(context) ?? 0,
      top: top?.resolve(context) ?? 0,
      end: end?.resolve(context) ?? 0,
      bottom: bottom?.resolve(context) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalDto._(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      start: start?.merge(other.start) ?? other.start,
      end: end?.merge(other.end) ?? other.end,
    );
  }

  @override
  List<Object?> get props => [top, bottom, start, end];
}
