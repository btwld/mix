import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../gap/space_dto.dart';
import 'edge_insets_dto.dart';

// Deprecated typedef moved to src/core/deprecated.dart

@immutable
final class EdgeInsetsGeometryUtility<T extends Attribute>
    extends DtoUtility<T, EdgeInsetsGeometryDto, EdgeInsetsGeometry> {
  late final directional = SpacingDirectionalUtility(builder);

  late final horizontal = SpacingSideUtility((v) => onlyDto(left: v, right: v));

  late final vertical = SpacingSideUtility((v) => onlyDto(top: v, bottom: v));

  late final all = SpacingSideUtility(
    (v) => onlyDto(top: v, bottom: v, left: v, right: v),
  );

  late final top = SpacingSideUtility((v) => onlyDto(top: v));

  late final bottom = SpacingSideUtility((v) => onlyDto(bottom: v));

  late final left = SpacingSideUtility((v) => onlyDto(left: v));

  late final right = SpacingSideUtility((v) => onlyDto(right: v));

  EdgeInsetsGeometryUtility(super.builder)
    : super(valueToDto: (value) => _edgeInsetsGeometryToDto(value));

  T call(double p1, [double? p2, double? p3, double? p4]) {
    return only(
      top: p1,
      bottom: p3 ?? p1,
      left: p4 ?? p2 ?? p1,
      right: p2 ?? p1,
    );
  }

  T onlyDto({
    SpaceDto? top,
    SpaceDto? bottom,
    SpaceDto? left,
    SpaceDto? right,
    SpaceDto? start,
    SpaceDto? end,
  }) {
    final isDirectional = start != null || end != null;
    final isNotDirectional = left != null || right != null;

    assert(
      (!isDirectional && !isNotDirectional) ||
          isDirectional == !isNotDirectional,
      'Cannot provide both directional and non-directional values',
    );
    if (start != null || end != null) {
      return builder(
        EdgeInsetsDirectionalDto.valueSpaceDto(
          top: top,
          bottom: bottom,
          start: start,
          end: end,
        ),
      );
    }

    return builder(
      EdgeInsetsDto.valueSpaceDto(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
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
    (v) => onlyDto(top: v, bottom: v, start: v, end: v),
  );

  late final start = SpacingSideUtility((v) => onlyDto(start: v));

  late final end = SpacingSideUtility((v) => onlyDto(end: v));

  late final top = SpacingSideUtility((v) => onlyDto(top: v));

  late final bottom = SpacingSideUtility((v) => onlyDto(bottom: v));

  late final vertical = SpacingSideUtility((v) => onlyDto(top: v, bottom: v));

  late final horizontal = SpacingSideUtility((v) => onlyDto(start: v, end: v));

  SpacingDirectionalUtility(super.builder)
    : super(valueToDto: (value) => _edgeInsetsGeometryToDto(value));

  T onlyDto({SpaceDto? top, SpaceDto? bottom, SpaceDto? start, SpaceDto? end}) {
    return builder(
      EdgeInsetsDirectionalDto.valueSpaceDto(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      ),
    );
  }

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
class SpacingSideUtility<T extends Attribute> extends MixUtility<T, SpaceDto> {
  const SpacingSideUtility(super.builder);

  T call(double value) => builder(SpaceDto.value(value));

  /// @deprecated Use [token] instead
  @Deprecated('Use token() instead. Will be removed in a future version.')
  T ref(MixToken<double> token) => this.token(token);

  /// Creates a token-based spacing value
  T token(MixToken<double> token) {
    return builder(SpaceDto.token(token));
  }
}

// Helper function
EdgeInsetsGeometryDto _edgeInsetsGeometryToDto(EdgeInsetsGeometry geometry) {
  return switch (geometry) {
    EdgeInsets insets => EdgeInsetsDto(
      top: insets.top != 0 ? insets.top : null,
      bottom: insets.bottom != 0 ? insets.bottom : null,
      left: insets.left != 0 ? insets.left : null,
      right: insets.right != 0 ? insets.right : null,
    ),
    EdgeInsetsDirectional insets => EdgeInsetsDirectionalDto(
      top: insets.top != 0 ? insets.top : null,
      bottom: insets.bottom != 0 ? insets.bottom : null,
      start: insets.start != 0 ? insets.start : null,
      end: insets.end != 0 ? insets.end : null,
    ),
    _ => throw ArgumentError(
      'Unsupported EdgeInsetsGeometry type: ${geometry.runtimeType}',
    ),
  };
}
