import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/space_token.dart';
import '../../theme/tokens/token.dart';
import 'edge_insets_dto.dart';

@Deprecated('Use EdgeInsetsGeometryUtility instead')
typedef SpacingUtility<T extends Attribute> = EdgeInsetsGeometryUtility<T>;

@immutable
final class EdgeInsetsGeometryUtility<T extends Attribute>
    extends DtoUtility<T, EdgeInsetsGeometryDto, EdgeInsetsGeometry> {
  late final directional = SpacingDirectionalUtility(builder);

  late final horizontal = SpacingSideUtility((v) => only(left: v, right: v));

  late final vertical = SpacingSideUtility((v) => only(top: v, bottom: v));

  late final all = SpacingSideUtility(
    (v) => only(top: v, bottom: v, left: v, right: v),
  );

  late final top = SpacingSideUtility((v) => only(top: v));

  late final bottom = SpacingSideUtility((v) => only(bottom: v));

  late final left = SpacingSideUtility((v) => only(left: v));

  late final right = SpacingSideUtility((v) => only(right: v));

  EdgeInsetsGeometryUtility(super.builder)
      : super(valueToDto: (value) => value.toDto());

  T call(double p1, [double? p2, double? p3, double? p4]) {
    return only(
      top: p1,
      bottom: p3 ?? p1,
      left: p4 ?? p2 ?? p1,
      right: p2 ?? p1,
    );
  }

  @override
  T only({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    return builder(
      EdgeInsetsGeometryDto.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        start: start,
        end: end,
      ),
    );
  }
}

@immutable
final class SpacingDirectionalUtility<T extends Attribute>
    extends DtoUtility<T, EdgeInsetsGeometryDto, EdgeInsetsGeometry> {
  late final all = SpacingSideUtility(
    (v) => only(top: v, bottom: v, start: v, end: v),
  );

  late final start = SpacingSideUtility((v) => only(start: v));

  late final end = SpacingSideUtility((v) => only(end: v));

  late final top = SpacingSideUtility((v) => only(top: v));

  late final bottom = SpacingSideUtility((v) => only(bottom: v));

  late final vertical = SpacingSideUtility((v) => only(top: v, bottom: v));

  late final horizontal = SpacingSideUtility((v) => only(start: v, end: v));

  SpacingDirectionalUtility(super.builder)
      : super(valueToDto: (value) => value.toDto());

  T call(double p1, [double? p2, double? p3, double? p4]) {
    return only(
      top: p1,
      bottom: p3 ?? p1,
      start: p4 ?? p2 ?? p1,
      end: p2 ?? p1,
    );
  }

  @override
  T only({double? top, double? bottom, double? start, double? end}) {
    return builder(
      EdgeInsetsGeometryDto.only(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      ),
    );
  }
}

@immutable
class SpacingSideUtility<T extends Attribute> extends MixUtility<T, double> {
  const SpacingSideUtility(super.builder);

  T call(double value) => builder(value);

  T ref(SpaceToken ref) => builder(ref());
}

extension SpacingTokens<T extends Attribute> on SpacingSideUtility<T> {
  T token(Token<double> token) => ref(SpaceToken(token.name));
}
