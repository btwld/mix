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

  late final horizontal = SpacingSideUtility<U>(
    (v) => onlyProps(left: v, right: v),
  );
  late final vertical = SpacingSideUtility<U>(
    (v) => onlyProps(top: v, bottom: v),
  );
  late final all = SpacingSideUtility<U>(
    (v) => onlyProps(top: v, bottom: v, left: v, right: v),
  );
  late final top = SpacingSideUtility<U>((v) => onlyProps(top: v));
  late final bottom = SpacingSideUtility<U>((v) => onlyProps(bottom: v));
  late final left = SpacingSideUtility<U>((v) => onlyProps(left: v));
  late final right = SpacingSideUtility<U>((v) => onlyProps(right: v));

  EdgeInsetsGeometryUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  @protected
  U onlyProps({
    Prop<double>? top,
    Prop<double>? bottom,
    Prop<double>? left,
    Prop<double>? right,
    Prop<double>? start,
    Prop<double>? end,
  }) {
    EdgeInsetsGeometryMix edgeInsets;
    if (start != null || left != null) {
      edgeInsets = EdgeInsetsDirectionalMix.raw(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      );
    } else {
      edgeInsets = EdgeInsetsMix.raw(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      );
    }

    return builder(MixProp(edgeInsets));
  }

  U only({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    return onlyProps(
      top: Prop.maybe(top),
      bottom: Prop.maybe(bottom),
      left: Prop.maybe(left),
      right: Prop.maybe(right),
      start: Prop.maybe(start),
      end: Prop.maybe(end),
    );
  }

  U call(double p1, [double? p2, double? p3, double? p4]) {
    return only(
      top: p1,
      bottom: p3 ?? p1,
      left: p4 ?? p2 ?? p1,
      right: p2 ?? p1,
    );
  }
}

@immutable
final class EdgeInsetsDirectionalUtility<U extends Style<Object?>>
    extends MixPropUtility<U, EdgeInsetsDirectional> {
  late final all = SpacingSideUtility<U>(
    (v) => onlyProps(top: v, bottom: v, start: v, end: v),
  );
  late final start = SpacingSideUtility<U>((v) => onlyProps(start: v));
  late final end = SpacingSideUtility<U>((v) => onlyProps(end: v));
  late final top = SpacingSideUtility<U>((v) => onlyProps(top: v));
  late final bottom = SpacingSideUtility<U>((v) => onlyProps(bottom: v));
  late final vertical = SpacingSideUtility<U>(
    (v) => onlyProps(top: v, bottom: v),
  );
  late final horizontal = SpacingSideUtility<U>(
    (v) => onlyProps(start: v, end: v),
  );

  EdgeInsetsDirectionalUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  @protected
  U onlyProps({
    Prop<double>? top,
    Prop<double>? bottom,
    Prop<double>? start,
    Prop<double>? end,
  }) {
    return builder(
      MixProp(
        EdgeInsetsDirectionalMix.raw(
          top: top,
          bottom: bottom,
          start: start,
          end: end,
        ),
      ),
    );
  }

  U only({double? top, double? bottom, double? start, double? end}) {
    return onlyProps(
      top: Prop.maybe(top),
      bottom: Prop.maybe(bottom),
      start: Prop.maybe(start),
      end: Prop.maybe(end),
    );
  }

  U call(double p1, [double? p2, double? p3, double? p4]) {
    return only(
      top: p1,
      bottom: p3 ?? p1,
      start: p4 ?? p2 ?? p1,
      end: p2 ?? p1,
    );
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
