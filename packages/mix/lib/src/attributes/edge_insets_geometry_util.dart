import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'edge_insets_geometry_mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<U extends SpecAttribute<Object?>>
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
final class EdgeInsetsDirectionalUtility<U extends SpecAttribute<Object?>>
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
class SpacingSideUtility<T extends SpecAttribute<Object?>>
    extends PropUtility<T, double> {
  const SpacingSideUtility(super.builder);
}

// Note: Due to Dart's type system limitations, we cannot create a generic extension
// that returns the same concrete type as the receiver.
//
// Instead, use one of these approaches:
//
// 1. Use the existing utility pattern (RECOMMENDED):
//    BoxSpecAttribute().padding.all(16.0)
//    BoxSpecAttribute().padding.only(top: 8.0)
//    BoxSpecAttribute().margin.horizontal(20.0)
//
// 2. Add methods directly to each SpecAttribute that needs them:
//    See BoxSpecAttribute.paddingOnly() and BoxSpecAttribute.paddingAll()
//
// The utility pattern is more flexible and already well-established in the codebase.
