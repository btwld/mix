import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'edge_insets_geometry_mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<U extends Style<Object?>>
    extends MixPropUtility<U, EdgeInsetsGeometry> {
  late final directional = EdgeInsetsDirectionalUtility(builder);

  EdgeInsetsGeometryUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  U only({double? top, double? bottom, double? left, double? right}) {
    return call(
      EdgeInsetsMix(top: top, bottom: bottom, left: left, right: right),
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
final class EdgeInsetsDirectionalUtility<U extends Style<Object?>>
    extends MixPropUtility<U, EdgeInsetsDirectional> {
  late final all = SpacingSideUtility(
    (prop) => call(
      EdgeInsetsDirectionalMix.raw(
        top: prop,
        bottom: prop,
        start: prop,
        end: prop,
      ),
    ),
  );
  late final start = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix.raw(start: v)),
  );

  late final end = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix.raw(end: v)),
  );

  late final top = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix.raw(top: v)),
  );

  late final bottom = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix.raw(bottom: v)),
  );

  late final vertical = SpacingSideUtility(
    (prop) => call(EdgeInsetsDirectionalMix.raw(top: prop, bottom: prop)),
  );

  late final horizontal = SpacingSideUtility(
    (prop) => call(EdgeInsetsDirectionalMix.raw(start: prop, end: prop)),
  );

  EdgeInsetsDirectionalUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  @override
  U call(EdgeInsetsDirectionalMix value) {
    return builder(MixProp(value));
  }
}

@immutable
class SpacingSideUtility<T extends Style<Object?>>
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

  return EdgeInsetsMix(top: t, bottom: b, left: l, right: r);
}
