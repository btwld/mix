// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class BoxBorderUtility<T extends Attribute>
    extends DtoUtility<T, BoxBorderDto, BoxBorder> {
  late final directional = BorderDirectionalUtility(builder);
  late final all = _border.all;
  late final bottom = _border.bottom;
  late final top = _border.top;
  late final left = _border.left;
  late final right = _border.right;
  late final horizontal = _border.horizontal;
  late final vertical = _border.vertical;
  late final start = directional.start;
  late final end = directional.end;

  late final color = _border.color;
  late final width = _border.width;
  late final style = _border.style;
  late final strokeAlign = _border.strokeAlign;

  late final none = _border.none;

  late final _border = BorderUtility(builder);

  BoxBorderUtility(super.builder)
    : super(
        valueToDto: (v) {
          return switch (v) {
            Border() => BorderDto.value(v),
            BorderDirectional() => BorderDirectionalDto.value(v),
            _ => throw ArgumentError(
              'Unsupported BoxBorder type: ${v.runtimeType}',
            ),
          };
        },
      );

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return builder(
      BorderDto(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderUtility<T extends Attribute>
    extends DtoUtility<T, BorderDto, Border> {
  late final all = BorderSideUtility((v) => builder(BorderDto.all(v)));

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final left = BorderSideUtility((v) => only(left: v));

  late final right = BorderSideUtility((v) => only(right: v));

  late final vertical = BorderSideUtility(
    (v) => builder(BorderDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility(
    (v) => builder(BorderDto.horizontal(v)),
  );

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.builder) : super(valueToDto: BorderDto.value);

  T none() => builder(BorderDto.none);

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return builder(
      BorderDto(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderDirectionalUtility<T extends Attribute>
    extends DtoUtility<T, BorderDirectionalDto, BorderDirectional> {
  late final all = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.all(v)),
  );

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final start = BorderSideUtility((v) => only(start: v));

  late final end = BorderSideUtility((v) => only(end: v));

  late final vertical = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.horizontal(v)),
  );

  BorderDirectionalUtility(super.builder)
    : super(valueToDto: BorderDirectionalDto.value);

  T none() => builder(BorderDirectionalDto.none);

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return builder(
      BorderDirectionalDto(top: top, bottom: bottom, start: start, end: end),
    );
  }
}

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends Attribute>
    extends DtoUtility<T, BorderSideDto, BorderSide> {
  /// Utility for defining [BorderSideDto.color]
  late final color = ColorUtility(
    (prop) => builder(BorderSideDto.props(color: prop)),
  );

  /// Utility for defining [BorderSideDto.strokeAlign]
  late final strokeAlign = StrokeAlignUtility(
    (prop) => builder(BorderSideDto.props(strokeAlign: prop)),
  );

  /// Utility for defining [BorderSideDto.style]
  late final style = BorderStyleUtility((v) => only(style: v));

  /// Utility for defining [BorderSideDto.width]
  late final width = DoubleUtility(
    (prop) => builder(BorderSideDto.props(width: prop)),
  );

  BorderSideUtility(super.builder) : super(valueToDto: BorderSideDto.value);

  /// Creates a [Attribute] instance using the [BorderSideDto.none] constructor.
  T none() => builder(BorderSideDto.none);

  T call({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return builder(
      BorderSideDto(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }

  /// Returns a new [BorderSideDto] with the specified properties.
  @override
  T only({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return builder(
      BorderSideDto(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }
}
