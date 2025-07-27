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

  late final horizontal = SpacingSideUtility(
    (prop) => call(EdgeInsetsMix(left: prop, right: prop)),
  );

  late final vertical = SpacingSideUtility(
    (prop) => call(EdgeInsetsMix(top: prop, bottom: prop)),
  );

  late final all = SpacingSideUtility(
    (prop) =>
        call(EdgeInsetsMix(top: prop, bottom: prop, left: prop, right: prop)),
  );

  late final top = SpacingSideUtility((prop) => call(EdgeInsetsMix(top: prop)));

  late final bottom = SpacingSideUtility(
    (prop) => call(EdgeInsetsMix(bottom: prop)),
  );

  late final left = SpacingSideUtility(
    (prop) => call(EdgeInsetsMix(left: prop)),
  );
  late final right = SpacingSideUtility(
    (prop) => call(EdgeInsetsMix(right: prop)),
  );

  EdgeInsetsGeometryUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  U only({double? top, double? bottom, double? left, double? right}) {
    return call(
      EdgeInsetsMix.only(top: top, bottom: bottom, left: left, right: right),
    );
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

/// Mixin that provides padding convenience methods
mixin PaddingMixin<T extends StyleAttribute<S>, S extends Spec<S>>
    on StyleAttribute<S> {
  /// Must be implemented by the class using this mixin
  T padding(EdgeInsetsMix value);

  /// Sets padding with flexible edge control
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
    return padding(
      createEdgeInsetsMix(
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        start: start,
        end: end,
      ),
    );
  }

  /// Sets padding on all edges
  T paddingAll(double value) {
    return insets(all: value);
  }

  /// Sets horizontal padding (left and right)
  T paddingHorizontal(double value) {
    return insets(horizontal: value);
  }

  /// Sets vertical padding (top and bottom)
  T paddingVertical(double value) {
    return insets(vertical: value);
  }

  /// Sets top padding
  T paddingTop(double value) {
    return insets(top: value);
  }

  /// Sets bottom padding
  T paddingBottom(double value) {
    return insets(bottom: value);
  }

  /// Sets left padding
  T paddingLeft(double value) {
    return insets(left: value);
  }

  /// Sets right padding
  T paddingRight(double value) {
    return insets(right: value);
  }

  /// Sets start padding (logical)
  T paddingStart(double value) {
    return insets(start: value);
  }

  /// Sets end padding (logical)
  T paddingEnd(double value) {
    return insets(end: value);
  }
}

/// Mixin that provides margin convenience methods
mixin MarginMixin<T extends StyleAttribute<S>, S extends Spec<S>>
    on StyleAttribute<S> {
  /// Must be implemented by the class using this mixin
  T margin(EdgeInsetsMix value);

  /// Sets margin with flexible edge control
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
    return margin(
      createEdgeInsetsMix(
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        start: start,
        end: end,
      ),
    );
  }

  /// Sets margin on all edges
  T marginAll(double value) {
    return outsets(all: value);
  }

  /// Sets horizontal margin (left and right)
  T marginHorizontal(double value) {
    return outsets(horizontal: value);
  }

  /// Sets vertical margin (top and bottom)
  T marginVertical(double value) {
    return outsets(vertical: value);
  }

  /// Sets top margin
  T marginTop(double value) {
    return outsets(top: value);
  }

  /// Sets bottom margin
  T marginBottom(double value) {
    return outsets(bottom: value);
  }

  /// Sets left margin
  T marginLeft(double value) {
    return outsets(left: value);
  }

  /// Sets right margin
  T marginRight(double value) {
    return outsets(right: value);
  }

  /// Sets start margin (logical)
  T marginStart(double value) {
    return outsets(start: value);
  }

  /// Sets end margin (logical)
  T marginEnd(double value) {
    return outsets(end: value);
  }
}
