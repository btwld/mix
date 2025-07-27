// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Utility class for creating box border styling with comprehensive border support.
///
/// Provides access to border and directional border utilities for flexible border styling.
final class BoxBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BoxBorder> {
  late final border = BorderUtility<T>(builder);

  late final borderDirectional = BorderDirectionalUtility<T>(builder);

  BoxBorderUtility(super.builder) : super(convertToMix: BoxBorderMix.value);

  @override
  T call(BoxBorderMix value) {
    return builder(MixProp(value));
  }
}

/// Utility class for creating border styling with individual side control.
///
/// Provides utilities for styling all sides together or individual border sides.
final class BorderUtility<T extends StyleAttribute<Object?>>
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

  T none() => call(BorderMix.all(BorderSideMix.none));

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

final class BorderDirectionalUtility<T extends StyleAttribute<Object?>>
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
class BorderSideUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BorderSide> {
  /// Utility for defining [BorderSideMix.color]
  late final color = ColorUtility<T>(
    (prop) => call(BorderSideMix(color: prop)),
  );

  /// Utility for defining [BorderSideMix.strokeAlign]
  late final strokeAlign = PropUtility<T, double>(
    (prop) => call(BorderSideMix(strokeAlign: prop)),
  );

  /// Utility for defining [BorderSideMix.style]
  late final style = PropUtility<T, BorderStyle>(
    (prop) => call(BorderSideMix(style: prop)),
  );

  /// Utility for defining [BorderSideMix.width]
  late final width = PropUtility<T, double>(
    (prop) => call(BorderSideMix(width: prop)),
  );

  BorderSideUtility(super.builder) : super(convertToMix: BorderSideMix.value);

  /// Creates a [StyleAttribute] instance using the [BorderSideMix.none] constructor.
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
