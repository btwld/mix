// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
sealed class EdgeInsetsGeometryMix<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final Prop<double>? top;
  final Prop<double>? bottom;

  const EdgeInsetsGeometryMix({this.top, this.bottom});

  /// Creates insets where all the offsets are `value`.
  static EdgeInsetsGeometryMix all(double value) => EdgeInsetsMix.all(value);

  /// Creates [EdgeInsets] with only the given values non-zero.
  static EdgeInsetsGeometryMix only({
    double? left,
    double? right,
    double? top,
    double? bottom,
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
      return EdgeInsetsDirectionalMix.only(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      );
    }

    return EdgeInsetsMix.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  /// Creates [EdgeInsetsDirectional] with only the given values non-zero.
  static EdgeInsetsDirectionalMix directional({
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) => EdgeInsetsDirectionalMix.only(
    start: start,
    end: end,
    top: top,
    bottom: bottom,
  );

  /// Creates [EdgeInsets] with symmetrical vertical and horizontal offsets.
  static EdgeInsetsMix symmetric({
    double? vertical,
    double? horizontal,
  }) => EdgeInsetsMix.symmetric(
    vertical: vertical,
    horizontal: horizontal,
  );

  /// Creates [EdgeInsets] from offsets from the left, top, right, and bottom.
  static EdgeInsetsMix fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsetsMix.fromLTRB(left, top, right, bottom);

  /// Creates [EdgeInsetsDirectional] from offsets from the start, top, end, and
  /// bottom.
  static EdgeInsetsDirectionalMix fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) => EdgeInsetsDirectionalMix.fromSTEB(start, top, end, bottom);

  factory EdgeInsetsGeometryMix.value(T value) {
    return switch (value) {
          (EdgeInsets edgeInsets) => EdgeInsetsMix.value(edgeInsets),
          (EdgeInsetsDirectional edgeInsetsDirectional) =>
            EdgeInsetsDirectionalMix.value(edgeInsetsDirectional),
          _ => throw ArgumentError(
            'Unsupported EdgeInsetsGeometry type: ${value.runtimeType}',
          ),
        }
        as EdgeInsetsGeometryMix<T>;
  }

  static EdgeInsetsGeometryMix<T>? maybeValue<T extends EdgeInsetsGeometry>(
    T? edgeInsetsGeometry,
  ) {
    return edgeInsetsGeometry == null
        ? null
        : EdgeInsetsGeometryMix.value(edgeInsetsGeometry);
  }


  static EdgeInsetsGeometryMix? tryToMerge(
    EdgeInsetsGeometryMix? a,
    EdgeInsetsGeometryMix? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<
    A extends EdgeInsetsGeometryMix,
    B extends EdgeInsetsGeometryMix
  >(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (EdgeInsetsMix g) => a._asEdgeInset().merge(g) as B,
      (EdgeInsetsDirectionalMix g) => a._asEdgeInsetDirectional().merge(g) as B,
    };
  }

  EdgeInsetsMix _asEdgeInset() {
    if (this is EdgeInsetsMix) return this as EdgeInsetsMix;

    return EdgeInsetsMix(top: top, bottom: bottom);
  }

  EdgeInsetsDirectionalMix _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalMix) {
      return this as EdgeInsetsDirectionalMix;
    }

    return EdgeInsetsDirectionalMix(top: top, bottom: bottom);
  }

  @override
  EdgeInsetsGeometryMix<T> merge(covariant EdgeInsetsGeometryMix<T>? other);
}

final class EdgeInsetsMix extends EdgeInsetsGeometryMix<EdgeInsets> {
  final Prop<double>? left;
  final Prop<double>? right;

  const EdgeInsetsMix({super.top, super.bottom, this.left, this.right});

  EdgeInsetsMix.only({double? top, double? bottom, double? left, double? right})
    : this(
        top: top != null ? Prop(top) : null,
        bottom: bottom != null ? Prop(bottom) : null,
        left: left != null ? Prop(left) : null,
        right: right != null ? Prop(right) : null,
      );

  EdgeInsetsMix.all(double value)
    : this(
        top: Prop(value),
        bottom: Prop(value),
        left: Prop(value),
        right: Prop(value),
      );

  EdgeInsetsMix.symmetric({double? vertical, double? horizontal})
    : this(
        top: vertical != null ? Prop(vertical) : null,
        bottom: vertical != null ? Prop(vertical) : null,
        left: horizontal != null ? Prop(horizontal) : null,
        right: horizontal != null ? Prop(horizontal) : null,
      );

  EdgeInsetsMix.fromLTRB(double left, double top, double right, double bottom)
    : this(
        top: Prop(top),
        bottom: Prop(bottom),
        left: Prop(left),
        right: Prop(right),
      );

  /// Constructor that accepts an [EdgeInsets] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsets] instances to [EdgeInsetsMix].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsMix.value(edgeInsets);
  /// ```
  EdgeInsetsMix.value(EdgeInsets edgeInsets)
    : this.only(
        top: edgeInsets.top,
        bottom: edgeInsets.bottom,
        left: edgeInsets.left,
        right: edgeInsets.right,
      );

  EdgeInsetsMix.none() : this.all(0);

  /// Constructor that accepts a nullable [EdgeInsets] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [EdgeInsetsMix.value].
  ///
  /// ```dart
  /// const EdgeInsets? edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsMix.maybeValue(edgeInsets); // Returns EdgeInsetsMix or null
  /// ```
  static EdgeInsetsMix? maybeValue(EdgeInsets? edgeInsets) {
    return edgeInsets != null ? EdgeInsetsMix.value(edgeInsets) : null;
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
  EdgeInsetsMix merge(EdgeInsetsMix? other) {
    if (other == null) return this;

    return EdgeInsetsMix(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      left: MixHelpers.merge(left, other.left),
      right: MixHelpers.merge(right, other.right),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EdgeInsetsMix &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  int get hashCode {
    return Object.hash(top, bottom, left, right);
  }
}

final class EdgeInsetsDirectionalMix
    extends EdgeInsetsGeometryMix<EdgeInsetsDirectional> {
  final Prop<double>? start;
  final Prop<double>? end;

  const EdgeInsetsDirectionalMix({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

  EdgeInsetsDirectionalMix.only({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) : this(
         top: top != null ? Prop(top) : null,
         bottom: bottom != null ? Prop(bottom) : null,
         start: start != null ? Prop(start) : null,
         end: end != null ? Prop(end) : null,
       );

  EdgeInsetsDirectionalMix.all(double value)
    : this(
        top: Prop(value),
        bottom: Prop(value),
        start: Prop(value),
        end: Prop(value),
      );

  EdgeInsetsDirectionalMix.symmetric({double? vertical, double? horizontal})
    : this(
        top: vertical != null ? Prop(vertical) : null,
        bottom: vertical != null ? Prop(vertical) : null,
        start: horizontal != null ? Prop(horizontal) : null,
        end: horizontal != null ? Prop(horizontal) : null,
      );

  EdgeInsetsDirectionalMix.fromSTEB(double start, double top, double end, double bottom)
    : this(
        top: Prop(top),
        bottom: Prop(bottom),
        start: Prop(start),
        end: Prop(end),
      );

  /// Constructor that accepts an [EdgeInsetsDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [EdgeInsetsDirectional] instances to [EdgeInsetsDirectionalMix].
  ///
  /// ```dart
  /// const edgeInsets = EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDirectionalMix.value(edgeInsets);
  /// ```
  factory EdgeInsetsDirectionalMix.value(EdgeInsetsDirectional edgeInsets) {
    return EdgeInsetsDirectionalMix.only(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      start: edgeInsets.start,
      end: edgeInsets.end,
    );
  }

  EdgeInsetsDirectionalMix.none() : this.all(0);

  /// Constructor that accepts a nullable [EdgeInsetsDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [EdgeInsetsDirectionalMix.value].
  ///
  /// ```dart
  /// const EdgeInsetsDirectional? edgeInsets = EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 8.0);
  /// final dto = EdgeInsetsDirectionalMix.maybeValue(edgeInsets); // Returns EdgeInsetsDirectionalMix or null
  /// ```
  static EdgeInsetsDirectionalMix? maybeValue(
    EdgeInsetsDirectional? edgeInsets,
  ) {
    return edgeInsets != null
        ? EdgeInsetsDirectionalMix.value(edgeInsets)
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
  EdgeInsetsDirectionalMix merge(EdgeInsetsDirectionalMix? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalMix(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      start: MixHelpers.merge(start, other.start),
      end: MixHelpers.merge(end, other.end),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EdgeInsetsDirectionalMix &&
        other.top == top &&
        other.bottom == bottom &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    return Object.hash(top, bottom, start, end);
  }
}
