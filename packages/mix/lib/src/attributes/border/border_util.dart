// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class BoxBorderUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BoxBorder> {
  late final directional = BorderDirectionalUtility<T>(builder);
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

  late final _border = BorderUtility<T>(builder);

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

  @override
  T call(BoxBorderDto value) {
    return builder(MixProp(value));
  }

  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return call(
      BorderDto.only(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, Border> {
  late final all = BorderSideUtility<T>((v) => call(BorderDto.all(v)));

  late final bottom = BorderSideUtility<T>((v) => only(bottom: v));

  late final top = BorderSideUtility<T>((v) => only(top: v));

  late final left = BorderSideUtility<T>((v) => only(left: v));

  late final right = BorderSideUtility<T>((v) => only(right: v));

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderDto.horizontal(v)),
  );

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.builder) : super(valueToDto: BorderDto.value);

  T none() => call(BorderDto.none);

  @override
  T call(BorderDto value) {
    return builder(MixProp(value));
  }

  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return call(
      BorderDto.only(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderDirectionalUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BorderDirectional> {
  late final all = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto.all(v)),
  );

  late final bottom = BorderSideUtility<T>((v) => only(bottom: v));

  late final top = BorderSideUtility<T>((v) => only(top: v));

  late final start = BorderSideUtility<T>((v) => only(start: v));

  late final end = BorderSideUtility<T>((v) => only(end: v));

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto.horizontal(v)),
  );

  BorderDirectionalUtility(super.builder)
    : super(valueToDto: BorderDirectionalDto.value);

  T none() => call(BorderDirectionalDto.none);

  @override
  T call(BorderDirectionalDto value) {
    return builder(MixProp(value));
  }

  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return call(
      BorderDirectionalDto.only(top: top, bottom: bottom, start: start, end: end),
    );
  }
}

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BorderSide> {
  /// Utility for defining [BorderSideDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(BorderSideDto.props(color: prop)),
  );

  /// Utility for defining [BorderSideDto.strokeAlign]
  late final strokeAlign = StrokeAlignUtility<T>(
    (prop) => call(BorderSideDto.props(strokeAlign: prop)),
  );

  /// Utility for defining [BorderSideDto.style]
  late final style = BorderStyleUtility<T>((v) => only(style: v));

  /// Utility for defining [BorderSideDto.width]
  late final width = DoubleUtility<T>(
    (prop) => call(BorderSideDto.props(width: prop)),
  );

  BorderSideUtility(super.builder) : super(valueToDto: BorderSideDto.value);

  /// Creates a [Attribute] instance using the [BorderSideDto.none] constructor.
  T none() => call(BorderSideDto.none);

  @override
  T call(BorderSideDto value) {
    return builder(MixProp(value));
  }

  /// Returns a new [BorderSideDto] with the specified properties.
  T only({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return call(
      BorderSideDto(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }
}