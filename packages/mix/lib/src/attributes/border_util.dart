// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class BoxBorderUtility<T extends SpecAttribute<Object?>>
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
        convertToMix: (v) {
          return switch (v) {
            Border() => BorderDto.value(v),
            BorderDirectional() => BorderDirectionalDto.value(v),
            _ => throw ArgumentError(
              'Unsupported BoxBorder type: ${v.runtimeType}',
            ),
          };
        },
      );

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

  @override
  T call(BoxBorderDto value) {
    return builder(MixProp(value));
  }
}

final class BorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, Border> {
  late final all = BorderSideUtility<T>(
    (v) => call(BorderDto(top: v, bottom: v, left: v, right: v)),
  );

  late final bottom = BorderSideUtility<T>((v) => call(BorderDto(bottom: v)));

  late final top = BorderSideUtility<T>((v) => call(BorderDto(top: v)));

  late final left = BorderSideUtility<T>((v) => call(BorderDto(left: v)));

  late final right = BorderSideUtility<T>((v) => call(BorderDto(right: v)));

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderDto(top: v, bottom: v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderDto(left: v, right: v)),
  );

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.builder) : super(convertToMix: BorderDto.value);

  T none() => call(BorderDto.none);

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

  @override
  T call(BorderDto value) {
    return builder(MixProp(value));
  }
}

final class BorderDirectionalUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderDirectional> {
  late final all = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(top: v, bottom: v, start: v, end: v)),
  );

  late final bottom = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(bottom: v)),
  );

  late final top = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(top: v)),
  );

  late final start = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(start: v)),
  );

  late final end = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(end: v)),
  );

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(top: v, bottom: v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderDirectionalDto(start: v, end: v)),
  );

  BorderDirectionalUtility(super.builder)
    : super(convertToMix: BorderDirectionalDto.value);

  T none() => call(BorderDirectionalDto.none);

  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return call(
      BorderDirectionalDto.only(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      ),
    );
  }

  @override
  T call(BorderDirectionalDto value) {
    return builder(MixProp(value));
  }
}

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderSide> {
  /// Utility for defining [BorderSideDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(BorderSideDto(color: prop)),
  );

  /// Utility for defining [BorderSideDto.strokeAlign]
  late final strokeAlign = StrokeAlignUtility<T>(
    (prop) => call(BorderSideDto(strokeAlign: prop)),
  );

  /// Utility for defining [BorderSideDto.style]
  late final style = BorderStyleUtility<T>(
    (prop) => call(BorderSideDto(style: prop)),
  );

  /// Utility for defining [BorderSideDto.width]
  late final width = DoubleUtility<T>(
    (prop) => call(BorderSideDto(width: prop)),
  );

  BorderSideUtility(super.builder) : super(convertToMix: BorderSideDto.value);

  /// Creates a [Attribute] instance using the [BorderSideDto.none] constructor.
  T none() => call(BorderSideDto.none);

  /// Returns a new [BorderSideDto] with the specified properties.
  T only({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return call(
      BorderSideDto.only(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }

  @override
  T call(BorderSideDto value) {
    return builder(MixProp<BorderSide>(value));
  }
}
