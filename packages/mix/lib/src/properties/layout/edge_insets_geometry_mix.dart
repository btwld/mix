import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart' hide Mixable;
import '../../core/prop.dart';

part 'edge_insets_geometry_mix.g.dart';

// Deprecated typedef moved to src/core/deprecated.dart

/// Base class for Mix edge insets types.
///
/// Provides factory methods for padding/margin operations.
@immutable
sealed class EdgeInsetsGeometryMix<T extends EdgeInsetsGeometry>
    extends Mix<T> {
  final Prop<double>? $top;
  final Prop<double>? $bottom;

  const EdgeInsetsGeometryMix.create({Prop<double>? top, Prop<double>? bottom})
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

  /// All offsets equal to [value].
  static EdgeInsetsMix all(double value) => EdgeInsetsMix.all(value);

  /// Creates insets with only specified values.
  static EdgeInsetsMix only({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return EdgeInsetsMix(top: top, bottom: bottom, left: left, right: right);
  }

  /// Creates directional insets with only specified values.
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

  /// Equal horizontal offsets.
  static EdgeInsetsMix horizontal(double value) =>
      EdgeInsetsMix.horizontal(value);

  /// Equal vertical offsets.
  static EdgeInsetsMix vertical(double value) => EdgeInsetsMix.vertical(value);

  /// Symmetric vertical and horizontal offsets.
  static EdgeInsetsMix symmetric({double? vertical, double? horizontal}) =>
      EdgeInsetsMix.symmetric(vertical: vertical, horizontal: horizontal);

  /// Creates from left, top, right, bottom.
  static EdgeInsetsMix fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsetsMix.fromLTRB(left, top, right, bottom);

  /// Creates from start, top, end, bottom.
  static EdgeInsetsDirectionalMix fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) => EdgeInsetsDirectionalMix.fromSTEB(start, top, end, bottom);

  /// Creates from nullable [EdgeInsetsGeometry].
  static EdgeInsetsGeometryMix<T>? maybeValue<T extends EdgeInsetsGeometry>(
    T? edgeInsetsGeometry,
  ) {
    return edgeInsetsGeometry == null
        ? null
        : EdgeInsetsGeometryMix.value(edgeInsetsGeometry);
  }

  /// Top offset only.
  static EdgeInsetsMix top(double value) => EdgeInsetsMix(top: value);

  /// Bottom offset only.
  static EdgeInsetsMix bottom(double value) => EdgeInsetsMix(bottom: value);

  /// Left offset only.
  static EdgeInsetsMix left(double value) => EdgeInsetsMix(left: value);

  /// Right offset only.
  static EdgeInsetsMix right(double value) => EdgeInsetsMix(right: value);

  /// Start offset only.
  static EdgeInsetsDirectionalMix start(double value) =>
      EdgeInsetsDirectionalMix(start: value);

  /// End offset only.
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

    return EdgeInsetsMix.create(top: $top, bottom: $bottom);
  }

  EdgeInsetsDirectionalMix _asEdgeInsetDirectional() {
    if (this is EdgeInsetsDirectionalMix) {
      return this as EdgeInsetsDirectionalMix;
    }

    return EdgeInsetsDirectionalMix.create(top: $top, bottom: $bottom);
  }

  @override
  EdgeInsetsGeometryMix<T> merge(covariant EdgeInsetsGeometryMix<T>? other);
}

/// Mix representation of [EdgeInsets].
///
/// Uses absolute positioning (left, right) with token support.
@Mixable(methods: GeneratedMixMethods.skipResolve)
final class EdgeInsetsMix extends EdgeInsetsGeometryMix<EdgeInsets>
    with DefaultValue<EdgeInsets>, Diagnosticable, _$EdgeInsetsMixMixin {
  @override
  final Prop<double>? $left;
  @override
  final Prop<double>? $right;

  /// Zero padding.
  static EdgeInsetsMix zero = EdgeInsetsMix.all(0);

  const EdgeInsetsMix.create({
    super.top,
    super.bottom,
    Prop<double>? left,
    Prop<double>? right,
  }) : $left = left,
       $right = right,
       super.create();

  EdgeInsetsMix({double? top, double? bottom, double? left, double? right})
    : this.create(
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

  /// Creates from existing [EdgeInsets].
  EdgeInsetsMix.value(EdgeInsets edgeInsets)
    : this(
        top: edgeInsets.top,
        bottom: edgeInsets.bottom,
        left: edgeInsets.left,
        right: edgeInsets.right,
      );

  EdgeInsetsMix.none() : this.all(0);

  /// Creates from nullable [EdgeInsets].
  static EdgeInsetsMix? maybeValue(EdgeInsets? edgeInsets) {
    return edgeInsets != null ? EdgeInsetsMix.value(edgeInsets) : null;
  }

  /// Copy with top inset.
  EdgeInsetsMix top(double value) {
    return merge(EdgeInsetsGeometryMix.top(value));
  }

  /// Copy with bottom inset.
  EdgeInsetsMix bottom(double value) {
    return merge(EdgeInsetsGeometryMix.bottom(value));
  }

  /// Copy with left inset.
  EdgeInsetsMix left(double value) {
    return merge(EdgeInsetsGeometryMix.left(value));
  }

  /// Copy with right inset.
  EdgeInsetsMix right(double value) {
    return merge(EdgeInsetsGeometryMix.right(value));
  }

  /// Copy with vertical insets.
  EdgeInsetsMix vertical(double value) {
    return merge(EdgeInsetsGeometryMix.vertical(value));
  }

  /// Copy with horizontal insets.
  EdgeInsetsMix horizontal(double value) {
    return merge(EdgeInsetsGeometryMix.horizontal(value));
  }

  /// Copy with symmetric insets.
  EdgeInsetsMix symmetric({double? vertical, double? horizontal}) {
    return merge(
      EdgeInsetsGeometryMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Copy with only specified insets.
  EdgeInsetsMix only({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return merge(
      EdgeInsetsGeometryMix.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
    );
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
  EdgeInsets get defaultValue => EdgeInsets.zero;
}

/// Mix representation of [EdgeInsetsDirectional].
///
/// Uses directional positioning (start, end) with token support.
@Mixable(methods: GeneratedMixMethods.skipResolve)
final class EdgeInsetsDirectionalMix
    extends EdgeInsetsGeometryMix<EdgeInsetsDirectional>
    with Diagnosticable, _$EdgeInsetsDirectionalMixMixin {
  @override
  final Prop<double>? $start;
  @override
  final Prop<double>? $end;

  static EdgeInsetsDirectionalMix zero = EdgeInsetsDirectionalMix.all(0);

  const EdgeInsetsDirectionalMix.create({
    super.top,
    super.bottom,
    Prop<double>? start,
    Prop<double>? end,
  }) : $start = start,
       $end = end,
       super.create();

  EdgeInsetsDirectionalMix({
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) : this.create(
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

  /// Creates from existing [EdgeInsetsDirectional].
  factory EdgeInsetsDirectionalMix.value(EdgeInsetsDirectional edgeInsets) {
    return EdgeInsetsDirectionalMix(
      top: edgeInsets.top,
      bottom: edgeInsets.bottom,
      start: edgeInsets.start,
      end: edgeInsets.end,
    );
  }

  EdgeInsetsDirectionalMix.none() : this.all(0);

  /// Creates from nullable [EdgeInsetsDirectional].
  static EdgeInsetsDirectionalMix? maybeValue(
    EdgeInsetsDirectional? edgeInsets,
  ) {
    return edgeInsets != null
        ? EdgeInsetsDirectionalMix.value(edgeInsets)
        : null;
  }

  /// Copy with top inset.
  EdgeInsetsDirectionalMix top(double value) {
    return merge(EdgeInsetsDirectionalMix(top: value));
  }

  /// Copy with bottom inset.
  EdgeInsetsDirectionalMix bottom(double value) {
    return merge(EdgeInsetsDirectionalMix(bottom: value));
  }

  /// Copy with start inset.
  EdgeInsetsDirectionalMix start(double value) {
    return merge(EdgeInsetsGeometryMix.start(value));
  }

  /// Copy with end inset.
  EdgeInsetsDirectionalMix end(double value) {
    return merge(EdgeInsetsGeometryMix.end(value));
  }

  /// Copy with symmetric insets.
  EdgeInsetsDirectionalMix symmetric({double? vertical, double? horizontal}) {
    return merge(
      EdgeInsetsDirectionalMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Copy with directional insets.
  EdgeInsetsDirectionalMix directional({
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) {
    return merge(
      EdgeInsetsDirectionalMix(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      ),
    );
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
}
