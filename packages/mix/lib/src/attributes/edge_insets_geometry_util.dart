import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import './edge_insets_mix.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, EdgeInsetsGeometry> {
  late final directional = EdgeInsetsDirectionalUtility(builder);

  late final horizontal = SpacingSideUtility(
    (v) => call(EdgeInsetsMix(left: v, right: v)),
  );

  late final vertical = SpacingSideUtility(
    (v) => call(EdgeInsetsMix(top: v, bottom: v)),
  );

  late final all = SpacingSideUtility(
    (v) => call(EdgeInsetsMix(top: v, bottom: v, left: v, right: v)),
  );

  late final top = SpacingSideUtility((v) => call(EdgeInsetsMix(top: v)));

  late final bottom = SpacingSideUtility((v) => call(EdgeInsetsMix(bottom: v)));

  late final left = SpacingSideUtility((v) => call(EdgeInsetsMix(left: v)));
  late final right = SpacingSideUtility((v) => call(EdgeInsetsMix(right: v)));

  EdgeInsetsGeometryUtility(super.builder)
    : super(convertToMix: EdgeInsetsGeometryMix.value);

  @override
  T call(EdgeInsetsGeometryMix value) {
    return builder(MixProp(value));
  }
}

@immutable
final class EdgeInsetsDirectionalUtility<U extends SpecAttribute<Object?>>
    extends MixPropUtility<U, EdgeInsetsDirectional> {
  late final all = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(top: v, bottom: v, start: v, end: v)),
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
    (v) => call(EdgeInsetsDirectionalMix(top: v, bottom: v)),
  );

  late final horizontal = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalMix(start: v, end: v)),
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
