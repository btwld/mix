import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_mix.dart';
import 'color_util.dart';

/// Mixin that provides convenient border methods
mixin BorderMixin<T extends Style<Object?>> {
  /// Must be implemented by the class using this mixin
  T border(BoxBorderMix value);

  /// Sets border width with priority-based application
  ///
  /// Priority order (lowest to highest):
  /// 1. all - applies to all sides
  /// 2. horizontal - applies to top and bottom sides
  /// 3. vertical - applies to left and right sides
  /// 4. top/bottom/left/right - applies to specific sides
  ///
  /// Cannot mix physical (left/right) with logical (start/end) properties
  T borderWidth({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
  }) {
    // Check for mixing logical and physical properties
    final hasPhysicalSides = left != null || right != null;
    final hasLogicalSides = start != null || end != null;

    if (hasPhysicalSides && hasLogicalSides) {
      throw ArgumentError(
        'Cannot mix physical (left/right) and logical (start/end) properties. Use one or the other.',
      );
    }

    // Determine if we're using logical properties
    final useLogical = hasLogicalSides;

    // Start with all as base
    double? topWidth = all;
    double? bottomWidth = all;
    double? leftWidth = all;
    double? rightWidth = all;

    // Apply horizontal/vertical
    if (horizontal != null) {
      topWidth = horizontal;
      bottomWidth = horizontal;
    }
    if (vertical != null) {
      leftWidth = vertical;
      rightWidth = vertical;
    }

    // Apply specific side values
    if (top != null) topWidth = top;
    if (bottom != null) bottomWidth = bottom;

    if (useLogical) {
      // Apply logical side values (treating start as left, end as right)
      if (start != null) leftWidth = start;
      if (end != null) rightWidth = end;
    } else {
      // Apply physical side values
      if (left != null) leftWidth = left;
      if (right != null) rightWidth = right;
    }

    return border(
      useLogical
          ? BorderDirectionalMix(
              top: topWidth != null ? BorderSideMix(width: topWidth) : null,
              bottom: bottomWidth != null
                  ? BorderSideMix(width: bottomWidth)
                  : null,
              start: leftWidth != null ? BorderSideMix(width: leftWidth) : null,
              end: rightWidth != null ? BorderSideMix(width: rightWidth) : null,
            )
          : BorderMix(
              top: topWidth != null ? BorderSideMix(width: topWidth) : null,
              bottom: bottomWidth != null
                  ? BorderSideMix(width: bottomWidth)
                  : null,
              left: leftWidth != null ? BorderSideMix(width: leftWidth) : null,
              right: rightWidth != null
                  ? BorderSideMix(width: rightWidth)
                  : null,
            ),
    );
  }

  /// Sets border color with priority-based application
  ///
  /// Priority order (lowest to highest):
  /// 1. all - applies to all sides
  /// 2. horizontal - applies to top and bottom sides
  /// 3. vertical - applies to left and right sides
  /// 4. top/bottom/left/right - applies to specific sides
  ///
  /// Cannot mix physical (left/right) with logical (start/end) properties
  T borderColor({
    Color? all,
    Color? horizontal,
    Color? vertical,
    Color? top,
    Color? bottom,
    Color? left,
    Color? right,
    Color? start,
    Color? end,
  }) {
    // Check for mixing logical and physical properties
    final hasPhysicalSides = left != null || right != null;
    final hasLogicalSides = start != null || end != null;

    if (hasPhysicalSides && hasLogicalSides) {
      throw ArgumentError(
        'Cannot mix physical (left/right) and logical (start/end) properties. Use one or the other.',
      );
    }

    // Determine if we're using logical properties
    final useLogical = hasLogicalSides;

    // Start with all as base
    Color? topColor = all;
    Color? bottomColor = all;
    Color? leftColor = all;
    Color? rightColor = all;

    // Apply horizontal/vertical
    if (horizontal != null) {
      topColor = horizontal;
      bottomColor = horizontal;
    }
    if (vertical != null) {
      leftColor = vertical;
      rightColor = vertical;
    }

    // Apply specific side values
    if (top != null) topColor = top;
    if (bottom != null) bottomColor = bottom;

    if (useLogical) {
      // Apply logical side values (treating start as left, end as right)
      if (start != null) leftColor = start;
      if (end != null) rightColor = end;
    } else {
      // Apply physical side values
      if (left != null) leftColor = left;
      if (right != null) rightColor = right;
    }

    return border(
      useLogical
          ? BorderDirectionalMix(
              top: topColor != null ? BorderSideMix(color: topColor) : null,
              bottom: bottomColor != null
                  ? BorderSideMix(color: bottomColor)
                  : null,
              start: leftColor != null ? BorderSideMix(color: leftColor) : null,
              end: rightColor != null ? BorderSideMix(color: rightColor) : null,
            )
          : BorderMix(
              top: topColor != null ? BorderSideMix(color: topColor) : null,
              bottom: bottomColor != null
                  ? BorderSideMix(color: bottomColor)
                  : null,
              left: leftColor != null ? BorderSideMix(color: leftColor) : null,
              right: rightColor != null
                  ? BorderSideMix(color: rightColor)
                  : null,
            ),
    );
  }

  /// Sets border style with priority-based application
  ///
  /// Priority order (lowest to highest):
  /// 1. all - applies to all sides
  /// 2. horizontal - applies to top and bottom sides
  /// 3. vertical - applies to left and right sides
  /// 4. top/bottom/left/right - applies to specific sides
  ///
  /// Cannot mix physical (left/right) with logical (start/end) properties
  T borderStyle({
    BorderStyle? all,
    BorderStyle? horizontal,
    BorderStyle? vertical,
    BorderStyle? top,
    BorderStyle? bottom,
    BorderStyle? left,
    BorderStyle? right,
    BorderStyle? start,
    BorderStyle? end,
  }) {
    // Check for mixing logical and physical properties
    final hasPhysicalSides = left != null || right != null;
    final hasLogicalSides = start != null || end != null;

    if (hasPhysicalSides && hasLogicalSides) {
      throw ArgumentError(
        'Cannot mix physical (left/right) and logical (start/end) properties. Use one or the other.',
      );
    }

    // Determine if we're using logical properties
    final useLogical = hasLogicalSides;

    // Start with all as base
    BorderStyle? topStyle = all;
    BorderStyle? bottomStyle = all;
    BorderStyle? leftStyle = all;
    BorderStyle? rightStyle = all;

    // Apply horizontal/vertical
    if (horizontal != null) {
      topStyle = horizontal;
      bottomStyle = horizontal;
    }
    if (vertical != null) {
      leftStyle = vertical;
      rightStyle = vertical;
    }

    // Apply specific side values
    if (top != null) topStyle = top;
    if (bottom != null) bottomStyle = bottom;

    if (useLogical) {
      // Apply logical side values (treating start as left, end as right)
      if (start != null) leftStyle = start;
      if (end != null) rightStyle = end;
    } else {
      // Apply physical side values
      if (left != null) leftStyle = left;
      if (right != null) rightStyle = right;
    }

    return border(
      useLogical
          ? BorderDirectionalMix(
              top: topStyle != null ? BorderSideMix(style: topStyle) : null,
              bottom: bottomStyle != null
                  ? BorderSideMix(style: bottomStyle)
                  : null,
              start: leftStyle != null ? BorderSideMix(style: leftStyle) : null,
              end: rightStyle != null ? BorderSideMix(style: rightStyle) : null,
            )
          : BorderMix(
              top: topStyle != null ? BorderSideMix(style: topStyle) : null,
              bottom: bottomStyle != null
                  ? BorderSideMix(style: bottomStyle)
                  : null,
              left: leftStyle != null ? BorderSideMix(style: leftStyle) : null,
              right: rightStyle != null
                  ? BorderSideMix(style: rightStyle)
                  : null,
            ),
    );
  }
}

/// Utility class for creating box border styling with comprehensive border support.
///
/// Provides access to border and directional border utilities for flexible border styling.
final class BoxBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxBorderMix> {
  late final border = BorderUtility<T>(utilityBuilder);

  late final borderDirectional = BorderDirectionalUtility<T>(utilityBuilder);

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
  late final all = BorderSideUtility<T>(
    (v) => only(top: v, bottom: v, left: v, right: v),
  );

  late final bottom = BorderSideUtility<T>((v) => only(bottom: v));

  late final top = BorderSideUtility<T>((v) => only(top: v));

  late final left = BorderSideUtility<T>((v) => only(left: v));

  late final right = BorderSideUtility<T>((v) => only(right: v));

  late final vertical = BorderSideUtility<T>((v) => only(left: v, right: v));

  late final horizontal = BorderSideUtility<T>((v) => only(top: v, bottom: v));

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.utilityBuilder);

  T none() => only(
    top: BorderSideMix.none,
    bottom: BorderSideMix.none,
    left: BorderSideMix.none,
    right: BorderSideMix.none,
  );

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
  late final all = BorderSideUtility<T>(
    (v) => only(top: v, bottom: v, start: v, end: v),
  );

  late final bottom = BorderSideUtility<T>((v) => only(bottom: v));

  late final top = BorderSideUtility<T>((v) => only(top: v));

  late final start = BorderSideUtility<T>((v) => only(start: v));

  late final end = BorderSideUtility<T>((v) => only(end: v));

  late final vertical = BorderSideUtility<T>((v) => only(top: v, bottom: v));

  late final horizontal = BorderSideUtility<T>((v) => only(start: v, end: v));

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderDirectionalUtility(super.utilityBuilder);

  T none() => only(
    top: BorderSideMix.none,
    bottom: BorderSideMix.none,
    start: BorderSideMix.none,
    end: BorderSideMix.none,
  );

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
  late final color = ColorUtility<T>(
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
  T none() => utilityBuilder(BorderSideMix.none);

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
