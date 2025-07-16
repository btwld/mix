import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../theme/tokens/mix_token.dart';
import 'edge_insets_dto.dart';

@immutable
abstract class EdgeInsetsGeometryProp<
  T extends EdgeInsetsGeometry,
  M extends EdgeInsetsGeometryDto<T>
>
    extends MixProp<T, M> {
  const EdgeInsetsGeometryProp._(super.dto) : super.fromValue();
  const EdgeInsetsGeometryProp._token(super.token, super.valueToDto)
    : super.fromToken();

  /// Creates insets with all sides equal - delegates to EdgeInsetsProp
  static EdgeInsetsProp all(double value) => EdgeInsetsProp.all(value);

  /// Creates insets from Flutter value - delegates to specific implementations
  static EdgeInsetsGeometryProp fromValue<T extends EdgeInsetsGeometry>(
    T value,
  ) {
    return switch (T) {
          const (EdgeInsets) => EdgeInsetsProp.fromValue(value as EdgeInsets),
          const (EdgeInsetsDirectional) => EdgeInsetsDirectionalProp.fromValue(
            value as EdgeInsetsDirectional,
          ),
          _ => throw ArgumentError(
            'Unsupported type for EdgeInsetsGeometryProp: $T',
          ),
        }
        as EdgeInsetsGeometryProp<T, EdgeInsetsGeometryDto<T>>;
  }

  /// Creates insets with specific sides - delegates to EdgeInsetsProp
  static EdgeInsetsProp only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => EdgeInsetsProp.only(left: left, top: top, right: right, bottom: bottom);

  /// Creates symmetric insets - delegates to EdgeInsetsProp
  static EdgeInsetsProp symmetric({double? vertical, double? horizontal}) =>
      EdgeInsetsProp.symmetric(vertical: vertical, horizontal: horizontal);

  /// Creates from left, top, right, bottom values - delegates to EdgeInsetsProp
  static EdgeInsetsProp fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsetsProp.fromLTRB(left, top, right, bottom);

  /// Creates directional insets from EdgeInsetsDirectionalProp
  static EdgeInsetsDirectionalProp directional(
    EdgeInsetsDirectionalProp prop,
  ) => prop;

  /// Zero insets - delegates to EdgeInsetsProp
  static EdgeInsetsProp zero() => all(0.0);

  /// Creates token-based prop - delegates to specific implementations
  static EdgeInsetsGeometryProp token<T extends EdgeInsetsGeometry>(
    MixToken<T> token,
  ) {
    return switch (T) {
          const (EdgeInsets) => EdgeInsetsProp.token(
            token as MixToken<EdgeInsets>,
          ),
          const (EdgeInsetsDirectional) => EdgeInsetsDirectionalProp.token(
            token as MixToken<EdgeInsetsDirectional>,
          ),
          _ => throw ArgumentError(
            'Unsupported token type for EdgeInsetsGeometryProp: $T',
          ),
        }
        as EdgeInsetsGeometryProp<T, EdgeInsetsGeometryDto<T>>;
  }
}

@immutable
final class EdgeInsetsProp
    extends EdgeInsetsGeometryProp<EdgeInsets, EdgeInsetsDto> {
  const EdgeInsetsProp._(super.dto) : super._();
  const EdgeInsetsProp._token(super.token, super.valueToDto) : super._token();

  /// Creates from Flutter EdgeInsets value
  static EdgeInsetsProp fromValue(EdgeInsets value) =>
      EdgeInsetsProp._(EdgeInsetsDto.value(value));

  /// Creates from token
  static EdgeInsetsProp token(MixToken<EdgeInsets> token) =>
      EdgeInsetsProp._token(token, EdgeInsetsDto.value);

  /// Creates insets with all sides equal
  static EdgeInsetsProp all(double value) =>
      EdgeInsetsProp._(EdgeInsetsDto.all(value));

  /// Creates insets with specific sides
  static EdgeInsetsProp only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => EdgeInsetsProp._(
    EdgeInsetsDto(top: top, bottom: bottom, left: left, right: right),
  );

  /// Creates symmetric insets
  static EdgeInsetsProp symmetric({double? vertical, double? horizontal}) =>
      EdgeInsetsProp._(
        EdgeInsetsDto(
          top: vertical,
          bottom: vertical,
          left: horizontal,
          right: horizontal,
        ),
      );

  /// Creates from left, top, right, bottom values
  static EdgeInsetsProp fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsetsProp._(
    EdgeInsetsDto(top: top, bottom: bottom, left: left, right: right),
  );

  /// Zero insets
  static EdgeInsetsProp zero() => EdgeInsetsProp._(EdgeInsetsDto.none());
}

@immutable
final class EdgeInsetsDirectionalProp
    extends
        EdgeInsetsGeometryProp<
          EdgeInsetsDirectional,
          EdgeInsetsDirectionalDto
        > {
  const EdgeInsetsDirectionalProp._(super.dto) : super._();
  const EdgeInsetsDirectionalProp._token(super.token, super.valueToDto)
    : super._token();

  /// Creates from Flutter EdgeInsetsDirectional value
  static EdgeInsetsDirectionalProp fromValue(EdgeInsetsDirectional value) =>
      EdgeInsetsDirectionalProp._(EdgeInsetsDirectionalDto.value(value));

  /// Creates from token
  static EdgeInsetsDirectionalProp token(
    MixToken<EdgeInsetsDirectional> token,
  ) => EdgeInsetsDirectionalProp._token(token, EdgeInsetsDirectionalDto.value);

  /// Creates insets with all sides equal
  static EdgeInsetsDirectionalProp all(double value) =>
      EdgeInsetsDirectionalProp._(EdgeInsetsDirectionalDto.all(value));

  /// Creates insets with specific sides
  static EdgeInsetsDirectionalProp only({
    double? start,
    double? top,
    double? end,
    double? bottom,
  }) => EdgeInsetsDirectionalProp._(
    EdgeInsetsDirectionalDto(top: top, bottom: bottom, start: start, end: end),
  );

  /// Creates symmetric insets
  static EdgeInsetsDirectionalProp symmetric({
    double? vertical,
    double? horizontal,
  }) => EdgeInsetsDirectionalProp._(
    EdgeInsetsDirectionalDto(
      top: vertical,
      bottom: vertical,
      start: horizontal,
      end: horizontal,
    ),
  );

  /// Creates from start, top, end, bottom values
  static EdgeInsetsDirectionalProp fromSTEB(
    double start,
    double top,
    double end,
    double bottom,
  ) => EdgeInsetsDirectionalProp._(
    EdgeInsetsDirectionalDto(top: top, bottom: bottom, start: start, end: end),
  );

  /// Zero insets
  static EdgeInsetsDirectionalProp zero() =>
      EdgeInsetsDirectionalProp._(EdgeInsetsDirectionalDto.none());
}
