import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/utility.dart';
import 'edge_insets_dto.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, EdgeInsetsGeometry> {
  late final directional = EdgeInsetsDirectionalUtility(builder);

  late final horizontal = SpacingSideUtility(
    (v) => call(EdgeInsetsDto(left: v, right: v)),
  );

  late final vertical = SpacingSideUtility(
    (v) => call(EdgeInsetsDto(top: v, bottom: v)),
  );

  late final all = SpacingSideUtility(
    (v) => call(EdgeInsetsDto(top: v, bottom: v, left: v, right: v)),
  );

  late final top = SpacingSideUtility((v) => call(EdgeInsetsDto(top: v)));

  late final bottom = SpacingSideUtility((v) => call(EdgeInsetsDto(bottom: v)));

  late final left = SpacingSideUtility((v) => call(EdgeInsetsDto(left: v)));
  late final right = SpacingSideUtility((v) => call(EdgeInsetsDto(right: v)));

  EdgeInsetsGeometryUtility(super.builder)
    : super(valueToDto: EdgeInsetsGeometryDto.value);

  @override
  T call(EdgeInsetsGeometryDto value) {
    return builder(MixProp(value));
  }
}

@immutable
final class EdgeInsetsDirectionalUtility<U extends SpecUtility<Object?>>
    extends MixPropUtility<U, EdgeInsetsDirectional> {
  late final all = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(top: v, bottom: v, start: v, end: v)),
  );
  late final start = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(start: v)),
  );

  late final end = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(end: v)),
  );

  late final top = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(top: v)),
  );

  late final bottom = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(bottom: v)),
  );

  late final vertical = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(top: v, bottom: v)),
  );

  late final horizontal = SpacingSideUtility(
    (v) => call(EdgeInsetsDirectionalDto(start: v, end: v)),
  );

  EdgeInsetsDirectionalUtility(super.builder)
    : super(valueToDto: EdgeInsetsGeometryDto.value);

  @override
  U call(EdgeInsetsDirectionalDto value) {
    return builder(MixProp(value));
  }
}

@immutable
class SpacingSideUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, double> {
  const SpacingSideUtility(super.builder);
}
