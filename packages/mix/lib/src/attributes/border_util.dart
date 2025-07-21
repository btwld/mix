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
            Border() => BorderMix.value(v),
            BorderDirectional() => BorderDirectionalMix.value(v),
            _ => throw ArgumentError(
              'Unsupported BoxBorder type: ${v.runtimeType}',
            ),
          };
        },
      );

  T only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) {
    return call(
      BorderMix.only(top: top, bottom: bottom, left: left, right: right),
    );
  }

  @override
  T call(BoxBorderMix value) {
    return builder(MixProp(value));
  }
}

final class BorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, Border> {
  late final all = BorderSideUtility<T>(
    (v) => call(BorderMix(top: v, bottom: v, left: v, right: v)),
  );

  late final bottom = BorderSideUtility<T>((v) => call(BorderMix(bottom: v)));

  late final top = BorderSideUtility<T>((v) => call(BorderMix(top: v)));

  late final left = BorderSideUtility<T>((v) => call(BorderMix(left: v)));

  late final right = BorderSideUtility<T>((v) => call(BorderMix(right: v)));

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderMix(top: v, bottom: v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderMix(left: v, right: v)),
  );

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.builder) : super(convertToMix: BorderMix.value);

  T none() => call(BorderMix.none);

  T only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) {
    return call(
      BorderMix.only(top: top, bottom: bottom, left: left, right: right),
    );
  }

  @override
  T call(BorderMix value) {
    return builder(MixProp(value));
  }
}

final class BorderDirectionalUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderDirectional> {
  late final all = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(top: v, bottom: v, start: v, end: v)),
  );

  late final bottom = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(bottom: v)),
  );

  late final top = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(top: v)),
  );

  late final start = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(start: v)),
  );

  late final end = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(end: v)),
  );

  late final vertical = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(top: v, bottom: v)),
  );

  late final horizontal = BorderSideUtility<T>(
    (v) => call(BorderDirectionalMix(start: v, end: v)),
  );

  BorderDirectionalUtility(super.builder)
    : super(convertToMix: BorderDirectionalMix.value);

  T none() => call(BorderDirectionalMix.none);

  T only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? start,
    BorderSideMix? end,
  }) {
    return call(
      BorderDirectionalMix.only(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
      ),
    );
  }

  @override
  T call(BorderDirectionalMix value) {
    return builder(MixProp(value));
  }
}

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderSide> {
  /// Utility for defining [BorderSideMix.color]
  late final color = ColorUtility<T>(
    (prop) => call(BorderSideMix(color: prop)),
  );

  /// Utility for defining [BorderSideMix.strokeAlign]
  late final strokeAlign = StrokeAlignUtility<T>(
    (prop) => call(BorderSideMix(strokeAlign: prop)),
  );

  /// Utility for defining [BorderSideMix.style]
  late final style = BorderStyleUtility<T>(
    (prop) => call(BorderSideMix(style: prop)),
  );

  /// Utility for defining [BorderSideMix.width]
  late final width = DoubleUtility<T>(
    (prop) => call(BorderSideMix(width: prop)),
  );

  BorderSideUtility(super.builder) : super(convertToMix: BorderSideMix.value);

  /// Creates a [StyleElement] instance using the [BorderSideMix.none] constructor.
  T none() => call(BorderSideMix.none);

  /// Returns a new [BorderSideMix] with the specified properties.
  T only({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return call(
      BorderSideMix.only(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }

  @override
  T call(BorderSideMix value) {
    return builder(MixProp<BorderSide>(value));
  }
}
