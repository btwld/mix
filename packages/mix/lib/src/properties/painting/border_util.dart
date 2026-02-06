import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_mix.dart';
import 'color_util.dart';
import '../../style/mixins/decoration_style_mixin.dart';

/// Mixin that provides convenient border methods
mixin BorderMixin<T extends Mix<Object?>> implements DecorationStyleMixin<T> {
  // Individual border side methods with full BorderSide property support
  T borderTop({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.top(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  T borderBottom({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.bottom(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  T borderLeft({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.left(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  T borderRight({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.right(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  // Logical directional borders (RTL-aware)
  T borderStart({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderDirectionalMix.start(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  T borderEnd({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderDirectionalMix.end(
        BorderSideMix(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  // Border groups
  T borderVertical({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.vertical(side));
  }

  T borderHorizontal({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.horizontal(side));
  }

  T borderAll({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.all(side));
  }
}

/// Utility class for creating box border styling with comprehensive border support.
///
/// Provides access to border and directional border utilities for flexible border styling.
final class BoxBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxBorderMix> {
  late final border = BorderUtility(utilityBuilder);

  late final borderDirectional = BorderDirectionalUtility(utilityBuilder);

  BoxBorderUtility(super.utilityBuilder);

  T call(BoxBorderMix value) {
    return utilityBuilder(value);
  }

  T as(BoxBorder value) {
    return utilityBuilder(BoxBorderMix.value(value));
  }
}

/// Utility class for creating border styling with individual side control.
///
/// Provides utilities for styling all sides together or individual border sides.
final class BorderUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderMix> {
  late final all = BorderSideUtility(
    (v) => only(top: v, bottom: v, left: v, right: v),
  );

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final left = BorderSideUtility((v) => only(left: v));

  late final right = BorderSideUtility((v) => only(right: v));

  late final vertical = BorderSideUtility((v) => only(left: v, right: v));

  late final horizontal = BorderSideUtility((v) => only(top: v, bottom: v));

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.utilityBuilder);

  T none() => only(top: .none, bottom: .none, left: .none, right: .none);

  T only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) {
    return utilityBuilder(
      BorderMix(top: top, bottom: bottom, left: left, right: right),
    );
  }

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return only(top: side, bottom: side, left: side, right: side);
  }

  T as(Border value) {
    return utilityBuilder(BorderMix.value(value));
  }
}

/// Utility class for creating border styling with individual side control.
///
/// Provides utilities for styling all sides together or individual border sides.
final class BorderDirectionalUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderDirectionalMix> {
  late final all = BorderSideUtility(
    (v) => only(top: v, bottom: v, start: v, end: v),
  );

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final start = BorderSideUtility((v) => only(start: v));

  late final end = BorderSideUtility((v) => only(end: v));

  late final vertical = BorderSideUtility((v) => only(top: v, bottom: v));

  late final horizontal = BorderSideUtility((v) => only(start: v, end: v));

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderDirectionalUtility(super.utilityBuilder);

  T none() => only(top: .none, bottom: .none, start: .none, end: .none);

  T only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? start,
    BorderSideMix? end,
  }) {
    return utilityBuilder(
      BorderDirectionalMix(top: top, bottom: bottom, start: start, end: end),
    );
  }

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return only(top: side, bottom: side, start: side, end: side);
  }

  T as(BorderDirectional value) {
    return utilityBuilder(BorderDirectionalMix.value(value));
  }
}

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
final class BorderSideUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderSideMix> {
  /// Utility for defining [BorderSideMix.color]
  late final color = ColorUtility(
    (prop) => utilityBuilder(BorderSideMix.create(color: prop)),
  );

  /// Utility for defining [BorderSideMix.style]
  late final style = MixUtility<T, BorderStyle>((prop) => call(style: prop));

  BorderSideUtility(super.utilityBuilder);

  /// Utility for defining [BorderSideMix.strokeAlign]
  T strokeAlign(double v) => call(strokeAlign: v);

  /// Utility for defining [BorderSideMix.width]
  T width(double v) => call(width: v);

  /// Creates a [Style] instance using the [BorderSideMix.none] constructor.
  T none() => utilityBuilder(.none);

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return utilityBuilder(
      BorderSideMix(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }

  T as(BorderSide value) {
    return utilityBuilder(BorderSideMix.value(value));
  }
}
