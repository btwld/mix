import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/border_mix.dart';
import 'decoration_style_mixin.dart';

/// Mixin that provides convenient border styling methods
mixin BorderStyleMixin<T extends Mix<Object?>>
    implements DecorationStyleMixin<T> {
  // Individual border side methods with full BorderSide property support
  /// Sets the top border.
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

  /// Sets the bottom border.
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

  /// Sets the left border.
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

  /// Sets the right border.
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

  /// Sets the start border (RTL-aware).
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

  /// Sets the end border (RTL-aware).
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

  /// Sets vertical borders (top & bottom).
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

  /// Sets horizontal borders (left & right).
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

  /// Sets all borders.
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
