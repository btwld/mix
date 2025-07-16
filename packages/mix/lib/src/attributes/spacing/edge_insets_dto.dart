// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final MixProp<double, SpaceDto>? top;
  final MixProp<double, SpaceDto>? bottom;

  const EdgeInsetsGeometryDto({this.top, this.bottom});

  factory EdgeInsetsGeometryDto.value(EdgeInsetsGeometry edgeInsetsGeometry) {
    return switch (edgeInsetsGeometry) {
      EdgeInsets() =>
        EdgeInsetsDto.value(edgeInsetsGeometry) as EdgeInsetsGeometryDto<T>,
      EdgeInsetsDirectional() =>
        EdgeInsetsDirectionalDto.value(edgeInsetsGeometry)
            as EdgeInsetsGeometryDto<T>,
      _ => throw ArgumentError(
        'Unsupported EdgeInsetsGeometry type: ${edgeInsetsGeometry.runtimeType}',
      ),
    };
  }

  static EdgeInsetsGeometryDto<T>? maybeValue<T extends EdgeInsetsGeometry>(
    EdgeInsetsGeometry? edgeInsetsGeometry,
  ) {
    return edgeInsetsGeometry == null
        ? null
        : EdgeInsetsGeometryDto.value(edgeInsetsGeometry);
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
      return EdgeInsetsDirectionalDto.props(
        top: MixProp.maybeValue(SpaceDto.maybeValue(top)),
        bottom: MixProp.maybeValue(SpaceDto.maybeValue(bottom)),
        start: MixProp.maybeValue(SpaceDto.maybeValue(start)),
        end: MixProp.maybeValue(SpaceDto.maybeValue(end)),
      );
    }

    return EdgeInsetsDto.props(
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

    return EdgeInsetsDto.props(top: top, bottom: bottom);
  }

  EdgeInsetsDirectionalDto _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalDto) {
      return this as EdgeInsetsDirectionalDto;
    }

    return EdgeInsetsDirectionalDto.props(top: top, bottom: bottom);
  }

  @override
  EdgeInsetsGeometryDto<T> merge(covariant EdgeInsetsGeometryDto<T>? other);
}

final class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets> {
  final MixProp<double, SpaceDto>? left;
  final MixProp<double, SpaceDto>? right;

  const EdgeInsetsDto.props({super.top, super.bottom, this.left, this.right});

  // Main constructor accepts raw double values
  factory EdgeInsetsDto({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsetsDto.props(
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
    return EdgeInsetsDto(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      left: edgeInsets.left,
      right: edgeInsets.right,
    );
  }

  EdgeInsetsDto.all(double value)
    : this.props(
        top: MixProp.fromValue(SpaceDto.value(value)),
        bottom: MixProp.fromValue(SpaceDto.value(value)),
        left: MixProp.fromValue(SpaceDto.value(value)),
        right: MixProp.fromValue(SpaceDto.value(value)),
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
    return EdgeInsetsDto.props(
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
      left: resolveMixProp(context, left) ?? 0,
      top: resolveMixProp(context, top) ?? 0,
      right: resolveMixProp(context, right) ?? 0,
      bottom: resolveMixProp(context, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;

    return EdgeInsetsDto.props(
      top: mergeMixProp(top, other.top),
      bottom: mergeMixProp(bottom, other.bottom),
      left: mergeMixProp(left, other.left),
      right: mergeMixProp(right, other.right),
    );
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}

final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional> {
  final MixProp<double, SpaceDto>? start;
  final MixProp<double, SpaceDto>? end;

  const EdgeInsetsDirectionalDto.props({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

  // Main constructor accepts raw double values
  factory EdgeInsetsDirectionalDto({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    return EdgeInsetsDirectionalDto.props(
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
    return EdgeInsetsDirectionalDto(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      start: edgeInsets.start,
      end: edgeInsets.end,
    );
  }

  EdgeInsetsDirectionalDto.all(double value)
    : this.props(
        top: MixProp.fromValue(SpaceDto.value(value)),
        bottom: MixProp.fromValue(SpaceDto.value(value)),
        start: MixProp.fromValue(SpaceDto.value(value)),
        end: MixProp.fromValue(SpaceDto.value(value)),
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
    return EdgeInsetsDirectionalDto.props(
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
      start: resolveMixProp(context, start) ?? 0,
      top: resolveMixProp(context, top) ?? 0,
      end: resolveMixProp(context, end) ?? 0,
      bottom: resolveMixProp(context, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalDto.props(
      top: mergeMixProp(top, other.top),
      bottom: mergeMixProp(bottom, other.bottom),
      start: mergeMixProp(start, other.start),
      end: mergeMixProp(end, other.end),
    );
  }

  @override
  List<Object?> get props => [top, bottom, start, end];
}
