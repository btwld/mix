import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for Mix-compatible border styling that wraps Flutter's [BoxBorder] types.
///
/// Provides common functionality for [BorderMix] and [BorderDirectionalMix] with
/// merging support and type conversion between border variants.
sealed class BoxBorderMix<T extends BoxBorder> extends Mix<T> {
  final MixProp<BorderSide>? $top;
  final MixProp<BorderSide>? $bottom;

  static BorderMix none = BorderMix.all(BorderSideMix.none);

  const BoxBorderMix.raw({
    MixProp<BorderSide>? top,
    MixProp<BorderSide>? bottom,
  }) : $top = top,
       $bottom = bottom;

  static BorderMix all(BorderSideMix side) {
    return BorderMix(top: side, bottom: side, left: side, right: side);
  }

  static BorderMix left(BorderSideMix side) {
    return BorderMix(left: side);
  }

  static BorderMix right(BorderSideMix side) {
    return BorderMix(right: side);
  }

  static BorderMix top(BorderSideMix side) {
    return BorderMix(top: side);
  }

  static BorderMix bottom(BorderSideMix side) {
    return BorderMix(bottom: side);
  }

  /// Creates a border with symmetric sides using vertical and horizontal borders.
  ///
  /// The [vertical] border is applied to left and right sides,
  /// while [horizontal] border is applied to top and bottom sides.
  static BorderMix symmetric({
    BorderSideMix? vertical,
    BorderSideMix? horizontal,
  }) {
    return BorderMix(
      top: horizontal,
      bottom: horizontal,
      left: vertical,
      right: vertical,
    );
  }

  static BorderMix vertical(BorderSideMix side) {
    return BorderMix.symmetric(vertical: side);
  }

  static BorderMix horizontal(BorderSideMix side) {
    return BorderMix.symmetric(horizontal: side);
  }

  static BorderDirectionalMix directional(BorderDirectionalMix mix) {
    return mix;
  }

  static BorderDirectionalMix start(BorderSideMix side) {
    return BorderDirectionalMix(start: side);
  }

  static BorderDirectionalMix end(BorderSideMix side) {
    return BorderDirectionalMix(end: side);
  }

  /// Merges two BoxBorderMix instances.
  ///
  /// If both are the same type, delegates to type-specific merge.
  /// If different types, converts to the type of [b] and merges.
  /// If [b] is null, returns [a]. If [a] is null, returns [b].
  static BoxBorderMix? tryToMerge(BoxBorderMix? a, BoxBorderMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    return switch ((a, b)) {
      (BorderMix first, BorderMix second) => first.merge(second),
      (BorderDirectionalMix first, BorderDirectionalMix second) => first.merge(
        second,
      ),
      (BorderMix first, BorderDirectionalMix second) =>
        first._asBorderDirectional().merge(second),
      (BorderDirectionalMix first, BorderMix second) => first._asBorder().merge(
        second,
      ),
    };
  }

  static BoxBorderMix<T> value<T extends BoxBorder>(T border) {
    return switch (border) {
      Border() => BorderMix.value(border) as BoxBorderMix<T>,
      BorderDirectional() =>
        BorderDirectionalMix.value(border) as BoxBorderMix<T>,
      _ => throw ArgumentError(
        'Unsupported BoxBorder type: ${border.runtimeType}',
      ),
    };
  }

  static BoxBorderMix<T>? maybeValue<T extends BoxBorder>(T? border) {
    if (border == null) return null;

    return value(border);
  }

  @protected
  BorderMix _asBorder() {
    if (this is BorderMix) return this as BorderMix;

    // Convert BorderDirectionalMix to BorderMix
    final directional = this as BorderDirectionalMix;

    return BorderMix.raw(
      top: $top,
      bottom: $bottom,
      left: directional.$start, // start maps to left
      right: directional.$end, // end maps to right
    );
  }

  @protected
  BorderDirectionalMix _asBorderDirectional() {
    if (this is BorderDirectionalMix) return this as BorderDirectionalMix;

    // Convert BorderMix to BorderDirectionalMix
    final border = this as BorderMix;

    return BorderDirectionalMix.raw(
      top: $top,
      bottom: $bottom,
      start: border.$left, // left maps to start
      end: border.$right, // right maps to end
    );
  }

  bool get isUniform;

  /// Gets any border side from a uniform border (since all sides are identical)
  /// Returns null if borders are not uniform
  MixProp<BorderSide>? get uniformBorderSide;

  bool get isDirectional => this is BorderDirectionalMix;
  @override
  BoxBorderMix<T> merge(covariant BoxBorderMix<T>? other);
}

/// Mix-compatible representation of Flutter's [Border] with individual side control.
///
/// Allows styling of top, bottom, left, and right border sides independently
/// with token support and merging capabilities.
final class BorderMix extends BoxBorderMix<Border> with DefaultValue<Border> {
  final MixProp<BorderSide>? $left;
  final MixProp<BorderSide>? $right;

  BorderMix({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) : this.raw(
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
         left: MixProp.maybe(left),
         right: MixProp.maybe(right),
       );

  const BorderMix.raw({
    super.top,
    super.bottom,
    MixProp<BorderSide>? left,
    MixProp<BorderSide>? right,
  }) : $left = left,
       $right = right,
       super.raw();

  /// Creates a [BorderMix] from an existing [Border].
  ///
  /// ```dart
  /// const border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderMix.value(border);
  /// ```
  BorderMix.value(Border border)
    : this(
        top: BorderSideMix.maybeValue(border.top),
        bottom: BorderSideMix.maybeValue(border.bottom),
        left: BorderSideMix.maybeValue(border.left),
        right: BorderSideMix.maybeValue(border.right),
      );

  BorderMix.all(BorderSideMix side)
    : this(top: side, bottom: side, left: side, right: side);

  BorderMix.symmetric({BorderSideMix? vertical, BorderSideMix? horizontal})
    : this(
        top: horizontal,
        bottom: horizontal,
        left: vertical,
        right: vertical,
      );

  /// Creates a border with the same side on vertical edges.

  factory BorderMix.vertical(BorderSideMix side) {
    return BorderMix.symmetric(vertical: side);
  }

  factory BorderMix.horizontal(BorderSideMix side) {
    return BorderMix.symmetric(horizontal: side);
  }

  factory BorderMix.top(BorderSideMix side) {
    return BorderMix(top: side);
  }

  factory BorderMix.bottom(BorderSideMix side) {
    return BorderMix(bottom: side);
  }

  factory BorderMix.left(BorderSideMix side) {
    return BorderMix(left: side);
  }

  factory BorderMix.right(BorderSideMix side) {
    return BorderMix(right: side);
  }

  /// Creates a [BorderMix] from a nullable [Border].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const Border? border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderMix.maybeValue(border); // Returns BorderMix or null
  /// ```
  static BorderMix? maybeValue(Border? border) {
    return border != null ? BorderMix.value(border) : null;
  }

  /// Returns a copy with the specified top border side.
  BorderMix top(BorderSideMix side) {
    return merge(BorderMix.top(side));
  }

  /// Returns a copy with the specified bottom border side.
  BorderMix bottom(BorderSideMix side) {
    return merge(BorderMix.bottom(side));
  }

  /// Returns a copy with the specified left border side.
  BorderMix left(BorderSideMix side) {
    return merge(BorderMix.left(side));
  }

  /// Returns a copy with the specified right border side.
  BorderMix right(BorderSideMix side) {
    return merge(BorderMix.right(side));
  }

  /// Resolves to [Border] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final border = BorderMix(...).resolve(mix);
  /// ```
  @override
  Border resolve(BuildContext context) {
    return Border(
      top: MixHelpers.resolve(context, $top) ?? BorderSide.none,
      right: MixHelpers.resolve(context, $right) ?? BorderSide.none,
      bottom: MixHelpers.resolve(context, $bottom) ?? BorderSide.none,
      left: MixHelpers.resolve(context, $left) ?? BorderSide.none,
    );
  }

  /// Merges the properties of this [BorderMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderMix merge(BorderMix? other) {
    if (other == null) return this;

    return BorderMix.raw(
      top: MixHelpers.merge($top, other.$top),
      bottom: MixHelpers.merge($bottom, other.$bottom),
      left: MixHelpers.merge($left, other.$left),
      right: MixHelpers.merge($right, other.$right),
    );
  }

  @override
  List<Object?> get props => [$top, $bottom, $left, $right];

  @override
  bool get isUniform => $top == $bottom && $bottom == $left && $left == $right;

  @override
  MixProp<BorderSide>? get uniformBorderSide {
    if (!isUniform) return null;
    return $top ?? $right ?? $bottom ?? $left;
  }

  @override
  Border get defaultValue => const Border();
}

/// Mix-compatible representation of Flutter's [BorderDirectional] with RTL support.
///
/// Allows styling of top, bottom, start, and end border sides with proper
/// right-to-left layout handling and token support.
final class BorderDirectionalMix extends BoxBorderMix<BorderDirectional>
    with DefaultValue<BorderDirectional> {
  final MixProp<BorderSide>? $start;
  final MixProp<BorderSide>? $end;
  static final BorderDirectionalMix none = BorderDirectionalMix.all(
    BorderSideMix.none,
  );

  BorderDirectionalMix({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? start,
    BorderSideMix? end,
  }) : this.raw(
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
         start: MixProp.maybe(start),
         end: MixProp.maybe(end),
       );

  const BorderDirectionalMix.raw({
    super.top,
    super.bottom,
    MixProp<BorderSide>? start,
    MixProp<BorderSide>? end,
  }) : $start = start,
       $end = end,
       super.raw();

  /// Creates a [BorderDirectionalMix] from an existing [BorderDirectional].
  ///
  /// ```dart
  /// const border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalMix.value(border);
  /// ```
  BorderDirectionalMix.value(BorderDirectional border)
    : this(
        top: BorderSideMix.maybeValue(border.top),
        bottom: BorderSideMix.maybeValue(border.bottom),
        start: BorderSideMix.maybeValue(border.start),
        end: BorderSideMix.maybeValue(border.end),
      );

  BorderDirectionalMix.all(BorderSideMix side)
    : this(top: side, bottom: side, start: side, end: side);

  BorderDirectionalMix.symmetric({
    BorderSideMix? vertical,
    BorderSideMix? horizontal,
  }) : this(
         top: horizontal,
         bottom: horizontal,
         start: vertical,
         end: vertical,
       );

  BorderDirectionalMix.vertical(BorderSideMix side)
    : this.symmetric(vertical: side);
  BorderDirectionalMix.horizontal(BorderSideMix side)
    : this.symmetric(horizontal: side);

  factory BorderDirectionalMix.top(BorderSideMix side) {
    return BorderDirectionalMix(top: side);
  }

  factory BorderDirectionalMix.bottom(BorderSideMix side) {
    return BorderDirectionalMix(bottom: side);
  }

  factory BorderDirectionalMix.start(BorderSideMix side) {
    return BorderDirectionalMix(start: side);
  }

  factory BorderDirectionalMix.end(BorderSideMix side) {
    return BorderDirectionalMix(end: side);
  }

  /// Creates a [BorderDirectionalMix] from a nullable [BorderDirectional].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const BorderDirectional? border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalMix.maybeValue(border); // Returns BorderDirectionalMix or null
  /// ```
  static BorderDirectionalMix? maybeValue(BorderDirectional? border) {
    return border != null ? BorderDirectionalMix.value(border) : null;
  }

  /// Returns a copy with the specified top border side.
  BorderDirectionalMix top(BorderSideMix side) {
    return merge(BorderDirectionalMix.top(side));
  }

  /// Returns a copy with the specified bottom border side.
  BorderDirectionalMix bottom(BorderSideMix side) {
    return merge(BorderDirectionalMix.bottom(side));
  }

  /// Returns a copy with the specified start border side.
  BorderDirectionalMix start(BorderSideMix side) {
    return merge(BorderDirectionalMix.start(side));
  }

  /// Returns a copy with the specified end border side.
  BorderDirectionalMix end(BorderSideMix side) {
    return merge(BorderDirectionalMix.end(side));
  }

  /// Resolves to [BorderDirectional] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderDirectional = BorderDirectionalMix(...).resolve(mix);
  /// ```
  @override
  BorderDirectional resolve(BuildContext context) {
    return BorderDirectional(
      top: MixHelpers.resolve(context, $top) ?? defaultValue.top,
      start: MixHelpers.resolve(context, $start) ?? defaultValue.start,
      end: MixHelpers.resolve(context, $end) ?? defaultValue.end,
      bottom: MixHelpers.resolve(context, $bottom) ?? defaultValue.bottom,
    );
  }

  /// Merges the properties of this [BorderDirectionalMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderDirectionalMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderDirectionalMix merge(BorderDirectionalMix? other) {
    if (other == null) return this;

    return BorderDirectionalMix.raw(
      top: MixHelpers.merge($top, other.$top),
      bottom: MixHelpers.merge($bottom, other.$bottom),
      start: MixHelpers.merge($start, other.$start),
      end: MixHelpers.merge($end, other.$end),
    );
  }

  @override
  List<Object?> get props => [$top, $bottom, $start, $end];

  @override
  bool get isUniform => $top == $bottom && $bottom == $start && $start == $end;

  @override
  MixProp<BorderSide>? get uniformBorderSide {
    if (!isUniform) return null;
    return $top ?? $bottom ?? $start ?? $end;
  }

  @override
  BorderDirectional get defaultValue => const BorderDirectional();
}

/// Mix-compatible representation of Flutter's [BorderSide] for individual border styling.
///
/// Configures color, width, style, and stroke alignment for a single border edge
/// with token support and merging capabilities.
final class BorderSideMix extends Mix<BorderSide>
    with DefaultValue<BorderSide> {
  final Prop<Color>? $color;
  final Prop<double>? $width;
  final Prop<BorderStyle>? $style;
  final Prop<double>? $strokeAlign;

  static final BorderSideMix none = BorderSideMix.value(BorderSide.none);

  BorderSideMix({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) : this.raw(
         color: Prop.maybe(color),
         width: Prop.maybe(width),
         style: Prop.maybe(style),
         strokeAlign: Prop.maybe(strokeAlign),
       );

  /// Creates a [BorderSideMix] from an existing [BorderSide].
  ///
  /// ```dart
  /// const borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideMix.value(borderSide);
  /// ```
  BorderSideMix.value(BorderSide borderSide)
    : this(
        color: borderSide.color,
        strokeAlign: borderSide.strokeAlign,
        style: borderSide.style,
        width: borderSide.width,
      );

  const BorderSideMix.raw({
    Prop<Color>? color,
    Prop<double>? width,
    Prop<BorderStyle>? style,
    Prop<double>? strokeAlign,
  }) : $color = color,
       $width = width,
       $style = style,
       $strokeAlign = strokeAlign;

  factory BorderSideMix.color(Color value) {
    return BorderSideMix(color: value);
  }

  factory BorderSideMix.width(double value) {
    return BorderSideMix(width: value);
  }

  factory BorderSideMix.style(BorderStyle value) {
    return BorderSideMix(style: value);
  }

  factory BorderSideMix.strokeAlign(double value) {
    return BorderSideMix(strokeAlign: value);
  }

  /// Creates a [BorderSideMix] from a nullable [BorderSide].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const BorderSide? borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideMix.maybeValue(borderSide); // Returns BorderSideMix or null
  /// ```
  static BorderSideMix? maybeValue(BorderSide? borderSide) {
    return borderSide != null && borderSide != BorderSide.none
        ? BorderSideMix.value(borderSide)
        : null;
  }

  /// Returns a copy with the specified color.
  BorderSideMix color(Color value) {
    return merge(BorderSideMix.color(value));
  }

  /// Returns a copy with the specified width.
  BorderSideMix width(double value) {
    return merge(BorderSideMix.width(value));
  }

  /// Returns a copy with the specified border style.
  BorderSideMix style(BorderStyle value) {
    return merge(BorderSideMix.style(value));
  }

  /// Returns a copy with the specified stroke alignment.
  BorderSideMix strokeAlign(double value) {
    return merge(BorderSideMix.strokeAlign(value));
  }

  /// Resolves to [BorderSide] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderSide = BorderSideMix(...).resolve(mix);
  /// ```
  @override
  BorderSide resolve(BuildContext context) {
    return BorderSide(
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      width: MixHelpers.resolve(context, $width) ?? defaultValue.width,
      style: MixHelpers.resolve(context, $style) ?? defaultValue.style,
      strokeAlign:
          MixHelpers.resolve(context, $strokeAlign) ?? defaultValue.strokeAlign,
    );
  }

  /// Merges the properties of this [BorderSideMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderSideMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderSideMix merge(BorderSideMix? other) {
    if (other == null) return this;

    return BorderSideMix.raw(
      color: MixHelpers.merge($color, other.$color),
      width: MixHelpers.merge($width, other.$width),
      style: MixHelpers.merge($style, other.$style),
      strokeAlign: MixHelpers.merge($strokeAlign, other.$strokeAlign),
    );
  }

  @override
  List<Object?> get props => [$color, $width, $style, $strokeAlign];

  @override
  BorderSide get defaultValue => const BorderSide();
}
