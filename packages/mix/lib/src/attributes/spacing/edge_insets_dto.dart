// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryDto<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final Prop<double>? top;
  final Prop<double>? bottom;

  const EdgeInsetsGeometryDto({this.top, this.bottom});

  factory EdgeInsetsGeometryDto.value(T value) {
    return switch (value) {
          (EdgeInsets edgeInsets) => EdgeInsetsDto.value(edgeInsets),
          (EdgeInsetsDirectional edgeInsetsDirectional) =>
            EdgeInsetsDirectionalDto.value(edgeInsetsDirectional),
          _ => throw ArgumentError(
            'Unsupported EdgeInsetsGeometry type: ${value.runtimeType}',
          ),
        }
        as EdgeInsetsGeometryDto<T>;
  }

  static EdgeInsetsGeometryDto<T>? maybeValue<T extends EdgeInsetsGeometry>(
    T? edgeInsetsGeometry,
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
      return EdgeInsetsDirectionalDto(
        top: Prop.maybe(top),
        bottom: Prop.maybe(bottom),
        start: Prop.maybe(start),
        end: Prop.maybe(end),
      );
    }

    return EdgeInsetsDto(
      top: Prop.maybe(top),
      bottom: Prop.maybe(bottom),
      left: Prop.maybe(left),
      right: Prop.maybe(right),
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

final class EdgeInsetsDto extends EdgeInsetsGeometryDto<EdgeInsets> {
  final Prop<double>? left;
  final Prop<double>? right;

  const EdgeInsetsDto({super.top, super.bottom, this.left, this.right});

  EdgeInsetsDto.only({double? top, double? bottom, double? left, double? right})
    : this(
        top: Prop.maybe(top),
        bottom: Prop.maybe(bottom),
        left: Prop.maybe(left),
        right: Prop.maybe(right),
      );

  /// Constructor that accepts an [EdgeInsets] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsets] instances to [EdgeInsetsDto].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDto.value(edgeInsets);
  /// ```
  EdgeInsetsDto.value(EdgeInsets edgeInsets)
    : this.only(
        top: edgeInsets.top,
        bottom: edgeInsets.bottom,
        left: edgeInsets.left,
        right: edgeInsets.right,
      );

  EdgeInsetsDto.all(double value)
    : this.only(top: value, bottom: value, left: value, right: value);

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
  EdgeInsets resolve(BuildContext context) {
    return EdgeInsets.only(
      left: MixHelpers.resolve(context, left) ?? 0,
      top: MixHelpers.resolve(context, top) ?? 0,
      right: MixHelpers.resolve(context, right) ?? 0,
      bottom: MixHelpers.resolve(context, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDto merge(EdgeInsetsDto? other) {
    if (other == null) return this;

    return EdgeInsetsDto(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      left: MixHelpers.merge(left, other.left),
      right: MixHelpers.merge(right, other.right),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EdgeInsetsDto &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  int get hashCode {
    return top.hashCode ^ bottom.hashCode ^ left.hashCode ^ right.hashCode;
  }
}

final class EdgeInsetsDirectionalDto
    extends EdgeInsetsGeometryDto<EdgeInsetsDirectional> {
  final Prop<double>? start;
  final Prop<double>? end;

  const EdgeInsetsDirectionalDto({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

  EdgeInsetsDirectionalDto.only({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) : this(
         top: Prop.maybe(top),
         bottom: Prop.maybe(bottom),
         start: Prop.maybe(start),
         end: Prop.maybe(end),
       );

  /// Constructor that accepts an [EdgeInsetsDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsetsDirectional] instances to [EdgeInsetsDirectionalDto].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDirectionalDto.value(edgeInsets);
  /// ```
  factory EdgeInsetsDirectionalDto.value(EdgeInsetsDirectional edgeInsets) {
    return EdgeInsetsDirectionalDto.only(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      start: edgeInsets.start,
      end: edgeInsets.end,
    );
  }

  EdgeInsetsDirectionalDto.all(double value)
    : this.only(top: value, bottom: value, start: value, end: value);

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
  EdgeInsetsDirectional resolve(BuildContext context) {
    return EdgeInsetsDirectional.only(
      start: MixHelpers.resolve(context, start) ?? 0,
      top: MixHelpers.resolve(context, top) ?? 0,
      end: MixHelpers.resolve(context, end) ?? 0,
      bottom: MixHelpers.resolve(context, bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalDto merge(EdgeInsetsDirectionalDto? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalDto(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      start: MixHelpers.merge(start, other.start),
      end: MixHelpers.merge(end, other.end),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EdgeInsetsDirectionalDto &&
        other.top == top &&
        other.bottom == bottom &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    return top.hashCode ^ bottom.hashCode ^ start.hashCode ^ end.hashCode;
  }
}
