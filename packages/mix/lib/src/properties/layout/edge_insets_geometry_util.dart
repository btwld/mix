import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../core/prop.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'edge_insets_geometry_mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<U extends StyleAttribute<Object?>>
    extends MixPropUtility<U, EdgeInsetsGeometry> {
  late final directional = EdgeInsetsDirectionalUtility(builder);


  EdgeInsetsGeometryUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  U only({double? top, double? bottom, double? left, double? right}) {
    return call(
      EdgeInsetsMix.only(top: top, bottom: bottom, left: left, right: right),
    );
  }

  U all(double value) {
    return call(EdgeInsetsMix.all(value));
  }

  U symmetric({double? vertical, double? horizontal}) {
    return call(
      EdgeInsetsMix.symmetric(vertical: vertical, horizontal: horizontal),
    );
  }

  U horizontal(double value) {
    return symmetric(horizontal: value);
  }

  U vertical(double value) {
    return symmetric(vertical: value);
  }

  U top(double value) {
    return only(top: value);
  }

  U bottom(double value) {
    return only(bottom: value);
  }

  U left(double value) {
    return only(left: value);
  }

  U right(double value) {
    return only(right: value);
  }

  @override
  U call(EdgeInsetsGeometryMix value) {
    return builder(MixProp(value));
  }
}

@immutable
final class EdgeInsetsDirectionalUtility<U extends StyleAttribute<Object?>>
    extends MixPropUtility<U, EdgeInsetsDirectional> {
  late final all = SpacingSideUtility(
    (prop) => call(
      EdgeInsetsDirectionalMix(top: prop, bottom: prop, start: prop, end: prop),
    ),
  );
  late final start = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(start: v)),
  );

  late final end = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(end: v)),
  );

  late final top = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(top: v)),
  );

  late final bottom = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(bottom: v)),
  );

  late final vertical = SpacingSideUtility(
    (prop) => call(EdgeInsetsDirectionalMix(top: prop, bottom: prop)),
  );

  late final horizontal = SpacingSideUtility(
    (prop) => call(EdgeInsetsDirectionalMix(start: prop, end: prop)),
  );

  EdgeInsetsDirectionalUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  @override
  U call(EdgeInsetsDirectionalMix value) {
    return builder(MixProp(value));
  }
}

@immutable
class SpacingSideUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, double> {
  const SpacingSideUtility(super.builder);
}

/// Converts edge parameters into EdgeInsetsMix with priority system
///
/// Priority order (lowest to highest):
/// 1. all - applies to all edges
/// 2. horizontal - applies to left and right
/// 3. vertical - applies to top and bottom
/// 4. top/bottom/left/right OR start/end - specific edges
///
/// Cannot mix physical (left/right) with logical (start/end) properties
@internal
EdgeInsetsMix createEdgeInsetsMix({
  double? all,
  double? horizontal,
  double? vertical,
  double? top,
  double? bottom,
  double? left,
  double? right,
  double? start,
  double? end,
}) {
  // Validation
  final hasPhysical = left != null || right != null;
  final hasLogical = start != null || end != null;

  if (hasPhysical && hasLogical) {
    throw ArgumentError(
      'Cannot mix physical (left/right) and logical (start/end) properties.',
    );
  }

  // Start with all as base
  double? t = all;
  double? b = all;
  double? l = all;
  double? r = all;

  // Apply horizontal/vertical
  if (horizontal != null) {
    l = horizontal;
    r = horizontal;
  }
  if (vertical != null) {
    t = vertical;
    b = vertical;
  }

  // Apply specific edges
  if (top != null) t = top;
  if (bottom != null) b = bottom;

  if (hasLogical) {
    if (start != null) l = start;
    if (end != null) r = end;
  } else {
    if (left != null) l = left;
    if (right != null) r = right;
  }

  return EdgeInsetsMix.only(top: t, bottom: b, left: l, right: r);
}

/// Mixin that provides convenient padding methods
mixin PaddingMixin<T extends StyleAttribute<S>, S extends Spec<S>> on StyleAttribute<S> {
  T padding(EdgeInsetsGeometryMix value);

  /// Sets padding for all edges
  T paddingAll(double value) {
    return padding(EdgeInsetsMix.all(value));
  }

  /// Sets horizontal padding (left and right)
  T paddingHorizontal(double value) {
    return padding(EdgeInsetsMix.symmetric(horizontal: value));
  }

  /// Sets vertical padding (top and bottom)
  T paddingVertical(double value) {
    return padding(EdgeInsetsMix.symmetric(vertical: value));
  }

  /// Sets padding for top edge
  T paddingTop(double value) {
    return padding(EdgeInsetsMix.only(top: value));
  }

  /// Sets padding for bottom edge
  T paddingBottom(double value) {
    return padding(EdgeInsetsMix.only(bottom: value));
  }

  /// Sets padding for left edge
  T paddingLeft(double value) {
    return padding(EdgeInsetsMix.only(left: value));
  }

  /// Sets padding for right edge
  T paddingRight(double value) {
    return padding(EdgeInsetsMix.only(right: value));
  }

  /// Sets padding for start edge (directional)
  T paddingStart(double value) {
    return padding(EdgeInsetsDirectionalMix.only(start: value));
  }

  /// Sets padding for end edge (directional)
  T paddingEnd(double value) {
    return padding(EdgeInsetsDirectionalMix.only(end: value));
  }

  /// Advanced padding with priority system
  T insets({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    return padding(createEdgeInsetsMix(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      start: start,
      end: end,
    ));
  }
}

/// Mixin that provides convenient margin methods
mixin MarginMixin<T extends StyleAttribute<S>, S extends Spec<S>> on StyleAttribute<S> {
  T margin(EdgeInsetsGeometryMix value);

  /// Sets margin for all edges
  T marginAll(double value) {
    return margin(EdgeInsetsMix.all(value));
  }

  /// Sets horizontal margin (left and right)
  T marginHorizontal(double value) {
    return margin(EdgeInsetsMix.symmetric(horizontal: value));
  }

  /// Sets vertical margin (top and bottom)
  T marginVertical(double value) {
    return margin(EdgeInsetsMix.symmetric(vertical: value));
  }

  /// Sets margin for top edge
  T marginTop(double value) {
    return margin(EdgeInsetsMix.only(top: value));
  }

  /// Sets margin for bottom edge
  T marginBottom(double value) {
    return margin(EdgeInsetsMix.only(bottom: value));
  }

  /// Sets margin for left edge
  T marginLeft(double value) {
    return margin(EdgeInsetsMix.only(left: value));
  }

  /// Sets margin for right edge
  T marginRight(double value) {
    return margin(EdgeInsetsMix.only(right: value));
  }

  /// Sets margin for start edge (directional)
  T marginStart(double value) {
    return margin(EdgeInsetsDirectionalMix.only(start: value));
  }

  /// Sets margin for end edge (directional)
  T marginEnd(double value) {
    return margin(EdgeInsetsDirectionalMix.only(end: value));
  }

  /// Advanced margin with priority system
  T outsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    return margin(createEdgeInsetsMix(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      start: start,
      end: end,
    ));
  }
}

