import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

// Deprecated typedef moved to src/core/deprecated.dart

/// Base class for Mix-compatible edge insets styling that wraps Flutter's [EdgeInsetsGeometry] types.
///
/// Provides common functionality for [EdgeInsetsMix] and [EdgeInsetsDirectionalMix] with
/// factory methods for common padding/margin operations and type conversion between variants.
@immutable
sealed class EdgeInsetsGeometryMix<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final Prop<double>? $top;
  final Prop<double>? $bottom;

  const EdgeInsetsGeometryMix.raw({Prop<double>? top, Prop<double>? bottom})
    : $top = top,
      $bottom = bottom;

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

  /// Creates insets where all the offsets are `value`.
  static EdgeInsetsMix all(double value) => EdgeInsetsMix.all(value);

  /// Creates [EdgeInsets] with only the given values non-zero.
  static EdgeInsetsMix only({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsetsMix(top: top, bottom: bottom, left: left, right: right);
  }

  /// Creates [EdgeInsetsDirectional] with only the given values non-zero.
  static EdgeInsetsDirectionalMix directional({
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) => EdgeInsetsDirectionalMix(
    top: top,
    bottom: bottom,
    start: start,
    end: end,
  );

  /// Creates edge insets with equal left and right offsets.
  static EdgeInsetsMix horizontal(double value) =>
      EdgeInsetsMix.horizontal(value);

  /// Creates edge insets with equal top and bottom offsets.
  static EdgeInsetsMix vertical(double value) => EdgeInsetsMix.vertical(value);

  /// Creates [EdgeInsets] with symmetrical vertical and horizontal offsets.
  static EdgeInsetsMix symmetric({double? vertical, double? horizontal}) =>
      EdgeInsetsMix.symmetric(vertical: vertical, horizontal: horizontal);

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

  /// Creates the appropriate edge insets mix type from a nullable Flutter [EdgeInsetsGeometry].
  ///
  /// Returns null if the input is null.
  static EdgeInsetsGeometryMix<T>? maybeValue<T extends EdgeInsetsGeometry>(
    T? edgeInsetsGeometry,
  ) {
    return edgeInsetsGeometry == null
        ? null
        : EdgeInsetsGeometryMix.value(edgeInsetsGeometry);
  }

  /// Creates edge insets with only the top offset specified.
  static EdgeInsetsMix top(double value) => EdgeInsetsMix(top: value);

  /// Creates edge insets with only the bottom offset specified.
  static EdgeInsetsMix bottom(double value) => EdgeInsetsMix(bottom: value);

  /// Creates edge insets with only the left offset specified.
  static EdgeInsetsMix left(double value) => EdgeInsetsMix(left: value);

  /// Creates edge insets with only the right offset specified.
  static EdgeInsetsMix right(double value) => EdgeInsetsMix(right: value);

  /// Creates directional edge insets with only the start offset specified.
  static EdgeInsetsDirectionalMix start(double value) =>
      EdgeInsetsDirectionalMix(start: value);

  /// Creates directional edge insets with only the end offset specified.
  static EdgeInsetsDirectionalMix end(double value) =>
      EdgeInsetsDirectionalMix(end: value);

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

    return EdgeInsetsMix.raw(top: $top, bottom: $bottom);
  }

  EdgeInsetsDirectionalMix _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalMix) {
      return this as EdgeInsetsDirectionalMix;
    }

    return EdgeInsetsDirectionalMix.raw(top: $top, bottom: $bottom);
  }

  @override
  EdgeInsetsGeometryMix<T> merge(covariant EdgeInsetsGeometryMix<T>? other);
}

/// Mix-compatible representation of Flutter's [EdgeInsets] with absolute positioning.
///
/// Provides methods for creating edge insets using left, top, right, and bottom offsets
/// with token support and merging capabilities.
final class EdgeInsetsMix extends EdgeInsetsGeometryMix<EdgeInsets> {
  final Prop<double>? $left;
  final Prop<double>? $right;

  const EdgeInsetsMix.raw({
    super.top,
    super.bottom,
    Prop<double>? left,
    Prop<double>? right,
  }) : $left = left,
       $right = right,
       super.raw();

  EdgeInsetsMix({double? top, double? bottom, double? left, double? right})
    : this.raw(
        top: Prop.maybe(top),
        bottom: Prop.maybe(bottom),
        left: Prop.maybe(left),
        right: Prop.maybe(right),
      );

  EdgeInsetsMix.all(double value)
    : this(top: value, bottom: value, left: value, right: value);

  EdgeInsetsMix.symmetric({double? vertical, double? horizontal})
    : this(
        top: vertical,
        bottom: vertical,
        left: horizontal,
        right: horizontal,
      );

  EdgeInsetsMix.horizontal(double value) : this.symmetric(horizontal: value);

  EdgeInsetsMix.vertical(double value) : this.symmetric(vertical: value);

  EdgeInsetsMix.fromLTRB(double left, double top, double right, double bottom)
    : this(top: top, bottom: bottom, left: left, right: right);

  /// Creates an [EdgeInsetsMix] from an existing [EdgeInsets].
  EdgeInsetsMix.value(EdgeInsets edgeInsets)
    : this(
        top: edgeInsets.top,
        bottom: edgeInsets.bottom,
        left: edgeInsets.left,
        right: edgeInsets.right,
      );

  EdgeInsetsMix.none() : this.all(0);

  /// Creates an [EdgeInsetsMix] from a nullable [EdgeInsets].
  ///
  /// Returns null if the input is null.
  static EdgeInsetsMix? maybeValue(EdgeInsets? edgeInsets) {
    return edgeInsets != null ? EdgeInsetsMix.value(edgeInsets) : null;
  }

  /// Returns a copy with the specified top inset.
  EdgeInsetsMix top(double value) {
    return merge(EdgeInsetsGeometryMix.top(value));
  }

  /// Returns a copy with the specified bottom inset.
  EdgeInsetsMix bottom(double value) {
    return merge(EdgeInsetsGeometryMix.bottom(value));
  }

  /// Returns a copy with the specified left inset.
  EdgeInsetsMix left(double value) {
    return merge(EdgeInsetsGeometryMix.left(value));
  }

  /// Returns a copy with the specified right inset.
  EdgeInsetsMix right(double value) {
    return merge(EdgeInsetsGeometryMix.right(value));
  }

  /// Returns a copy with the specified vertical insets.
  EdgeInsetsMix vertical(double value) {
    return merge(EdgeInsetsGeometryMix.vertical(value));
  }

  /// Returns a copy with the specified horizontal insets.
  EdgeInsetsMix horizontal(double value) {
    return merge(EdgeInsetsGeometryMix.horizontal(value));
  }

  @override
  EdgeInsets resolve(BuildContext context) {
    return EdgeInsets.fromLTRB(
      MixOps.resolve(context, $left) ?? 0,
      MixOps.resolve(context, $top) ?? 0,
      MixOps.resolve(context, $right) ?? 0,
      MixOps.resolve(context, $bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsMix merge(EdgeInsetsMix? other) {
    if (other == null) return this;

    return EdgeInsetsMix.raw(
      top: $top.tryMerge(other.$top),
      bottom: $bottom.tryMerge(other.$bottom),
      left: $left.tryMerge(other.$left),
      right: $right.tryMerge(other.$right),
    );
  }

  @override
  List<Object?> get props => [$top, $bottom, $left, $right];
}

/// Mix-compatible representation of Flutter's [EdgeInsetsDirectional] with directional positioning.
///
/// Provides methods for creating edge insets using start, top, end, and bottom offsets
/// that respect text direction with token support and merging capabilities.
final class EdgeInsetsDirectionalMix
    extends EdgeInsetsGeometryMix<EdgeInsetsDirectional> {
  final Prop<double>? $start;
  final Prop<double>? $end;

  const EdgeInsetsDirectionalMix.raw({
    super.top,
    super.bottom,
    Prop<double>? start,
    Prop<double>? end,
  }) : $start = start,
       $end = end,
       super.raw();

  EdgeInsetsDirectionalMix({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) : this.raw(
         top: Prop.maybe(top),
         bottom: Prop.maybe(bottom),
         start: Prop.maybe(start),
         end: Prop.maybe(end),
       );

  EdgeInsetsDirectionalMix.all(double value)
    : this(top: value, bottom: value, start: value, end: value);

  EdgeInsetsDirectionalMix.symmetric({double? vertical, double? horizontal})
    : this(top: vertical, bottom: vertical, start: horizontal, end: horizontal);

  EdgeInsetsDirectionalMix.fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) : this(top: top, bottom: bottom, start: start, end: end);

  EdgeInsetsDirectionalMix.horizontal(double value)
    : this.symmetric(horizontal: value);

  EdgeInsetsDirectionalMix.vertical(double value)
    : this.symmetric(vertical: value);

  /// Creates an [EdgeInsetsDirectionalMix] from an existing [EdgeInsetsDirectional].
  factory EdgeInsetsDirectionalMix.value(EdgeInsetsDirectional edgeInsets) {
    return EdgeInsetsDirectionalMix(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      start: edgeInsets.start,
      end: edgeInsets.end,
    );
  }

  EdgeInsetsDirectionalMix.none() : this.all(0);

  /// Creates an [EdgeInsetsDirectionalMix] from a nullable [EdgeInsetsDirectional].
  ///
  /// Returns null if the input is null.
  static EdgeInsetsDirectionalMix? maybeValue(
    EdgeInsetsDirectional? edgeInsets,
  ) {
    return edgeInsets != null
        ? EdgeInsetsDirectionalMix.value(edgeInsets)
        : null;
  }

  /// Returns a copy with the specified top inset.
  EdgeInsetsDirectionalMix top(double value) {
    return merge(EdgeInsetsDirectionalMix(top: value));
  }

  /// Returns a copy with the specified bottom inset.
  EdgeInsetsDirectionalMix bottom(double value) {
    return merge(EdgeInsetsDirectionalMix(bottom: value));
  }

  /// Returns a copy with the specified start inset.
  EdgeInsetsDirectionalMix start(double value) {
    return merge(EdgeInsetsGeometryMix.start(value));
  }

  /// Returns a copy with the specified end inset.
  EdgeInsetsDirectionalMix end(double value) {
    return merge(EdgeInsetsGeometryMix.end(value));
  }

  @override
  EdgeInsetsDirectional resolve(BuildContext context) {
    return EdgeInsetsDirectional.fromSTEB(
      MixOps.resolve(context, $start) ?? 0,
      MixOps.resolve(context, $top) ?? 0,
      MixOps.resolve(context, $end) ?? 0,
      MixOps.resolve(context, $bottom) ?? 0,
    );
  }

  @override
  EdgeInsetsDirectionalMix merge(EdgeInsetsDirectionalMix? other) {
    if (other == null) return this;

    return EdgeInsetsDirectionalMix.raw(
      top: $top.tryMerge(other.$top),
      bottom: $bottom.tryMerge(other.$bottom),
      start: $start.tryMerge(other.$start),
      end: $end.tryMerge(other.$end),
    );
  }

  @override
  List<Object?> get props => [$top, $bottom, $start, $end];
}
