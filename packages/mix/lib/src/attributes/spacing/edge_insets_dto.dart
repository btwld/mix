// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final Prop<double>? top;
  final Prop<double>? bottom;

  const EdgeInsetsGeometryDto._({this.top, this.bottom});

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
        top: Prop.maybeValue(top),
        bottom: Prop.maybeValue(bottom),
        start: Prop.maybeValue(start),
        end: Prop.maybeValue(end),
      );
    }

    return EdgeInsetsDto._(
      top: Prop.maybeValue(top),
      bottom: Prop.maybeValue(bottom),
      left: Prop.maybeValue(left),
      right: Prop.maybeValue(right),
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
  final Prop<double>? left;
  final Prop<double>? right;

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
      top: Prop.maybeValue(top),
      bottom: Prop.maybeValue(bottom),
      left: Prop.maybeValue(left),
      right: Prop.maybeValue(right),
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
      top: Prop.value(edgeInsets.top),
      bottom: Prop.value(edgeInsets.bottom),
      left: Prop.value(edgeInsets.left),
      right: Prop.value(edgeInsets.right),
    );
  }

  EdgeInsetsDto.all(double value)
    : this._(
        top: Prop.value(value),
        bottom: Prop.value(value),
        left: Prop.value(value),
        right: Prop.value(value),
      );

  EdgeInsetsDto.none() : this.all(0);

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
  EdgeInsets resolve(MixContext mix) {
    return EdgeInsets.only(
      left: resolveProp(mix, left) ?? 0,
      top: resolveProp(mix, top) ?? 0,
      right: resolveProp(mix, right) ?? 0,
      bottom: resolveProp(mix, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;

    return EdgeInsetsDto._(
      top: mergeProp(top, other.top),
      bottom: mergeProp(bottom, other.bottom),
      left: mergeProp(left, other.left),
      right: mergeProp(right, other.right),
    );
  }

  @override
  List<Object?> get props => [top, bottom, left, right];
}

final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional> {
  final Prop<double>? start;
  final Prop<double>? end;

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
      top: Prop.maybeValue(top),
      bottom: Prop.maybeValue(bottom),
      start: Prop.maybeValue(start),
      end: Prop.maybeValue(end),
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
      top: Prop.value(edgeInsets.top),
      bottom: Prop.value(edgeInsets.bottom),
      start: Prop.value(edgeInsets.start),
      end: Prop.value(edgeInsets.end),
    );
  }

  EdgeInsetsDirectionalDto.all(double value)
    : this._(
        top: Prop.value(value),
        bottom: Prop.value(value),
        start: Prop.value(value),
        end: Prop.value(value),
      );

  EdgeInsetsDirectionalDto.none() : this.all(0);

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
  EdgeInsetsDirectional resolve(MixContext mix) {
    return EdgeInsetsDirectional.only(
      start: resolveProp(mix, start) ?? 0,
      top: resolveProp(mix, top) ?? 0,
      end: resolveProp(mix, end) ?? 0,
      bottom: resolveProp(mix, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalDto._(
      top: mergeProp(top, other.top),
      bottom: mergeProp(bottom, other.bottom),
      start: mergeProp(start, other.start),
      end: mergeProp(end, other.end),
    );
  }

  @override
  List<Object?> get props => [top, bottom, start, end];
}
