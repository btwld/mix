import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

part 'border_mix.g.dart';

/// Base class for Mix border types.
///
/// Common functionality with merging and type conversion.
sealed class BoxBorderMix<T extends BoxBorder> extends Mix<T> {
  final Prop<BorderSide>? $top;
  final Prop<BorderSide>? $bottom;

  static BorderMix none = BorderMix.all(.none);

  const BoxBorderMix.create({Prop<BorderSide>? top, Prop<BorderSide>? bottom})
    : $top = top,
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

  /// Creates symmetric border with vertical/horizontal sides.
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

  /// Merges border instances with type conversion.
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

    return BorderMix.create(
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

    return BorderDirectionalMix.create(
      top: $top,
      bottom: $bottom,
      start: border.$left, // left maps to start
      end: border.$right, // right maps to end
    );
  }

  bool get isUniform;

  /// Gets border side if uniform, null otherwise.
  Prop<BorderSide>? get uniformBorderSide;

  bool get isDirectional => this is BorderDirectionalMix;
  @override
  BoxBorderMix<T> merge(covariant BoxBorderMix<T>? other);
}

/// Mix representation of [Border].
///
/// Independent side control with tokens.
@mixable
final class BorderMix extends BoxBorderMix<Border>
    with DefaultValue<Border>, Diagnosticable, _$BorderMixMixin {
  @override
  final Prop<BorderSide>? $left;
  @override
  final Prop<BorderSide>? $right;

  BorderMix({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) : this.create(
         top: Prop.maybeMix(top),
         bottom: Prop.maybeMix(bottom),
         left: Prop.maybeMix(left),
         right: Prop.maybeMix(right),
       );

  const BorderMix.create({
    super.top,
    super.bottom,
    Prop<BorderSide>? left,
    Prop<BorderSide>? right,
  }) : $left = left,
       $right = right,
       super.create();

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

  @override
  bool get isUniform => $top == $bottom && $bottom == $left && $left == $right;

  @override
  Prop<BorderSide>? get uniformBorderSide {
    if (!isUniform) return null;

    return $top ?? $right ?? $bottom ?? $left;
  }

  @override
  Border get defaultValue => const .new();
}

/// Mix-compatible representation of Flutter's [BorderDirectional] with RTL support.
///
/// Allows styling of top, bottom, start, and end border sides with proper
/// right-to-left layout handling and token support.
@mixable
final class BorderDirectionalMix extends BoxBorderMix<BorderDirectional>
    with
        DefaultValue<BorderDirectional>,
        Diagnosticable,
        _$BorderDirectionalMixMixin {
  @override
  final Prop<BorderSide>? $start;
  @override
  final Prop<BorderSide>? $end;
  static final BorderDirectionalMix none = BorderDirectionalMix.all(.none);

  BorderDirectionalMix({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? start,
    BorderSideMix? end,
  }) : this.create(
         top: Prop.maybeMix(top),
         bottom: Prop.maybeMix(bottom),
         start: Prop.maybeMix(start),
         end: Prop.maybeMix(end),
       );

  const BorderDirectionalMix.create({
    super.top,
    super.bottom,
    Prop<BorderSide>? start,
    Prop<BorderSide>? end,
  }) : $start = start,
       $end = end,
       super.create();

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

  @override
  bool get isUniform => $top == $bottom && $bottom == $start && $start == $end;

  @override
  Prop<BorderSide>? get uniformBorderSide {
    if (!isUniform) return null;

    return $top ?? $bottom ?? $start ?? $end;
  }

  @override
  BorderDirectional get defaultValue => const .new();
}

/// Mix-compatible representation of Flutter's [BorderSide] for individual border styling.
///
/// Configures color, width, style, and stroke alignment for a single border edge
/// with token support and merging capabilities.
@mixable
final class BorderSideMix extends Mix<BorderSide>
    with DefaultValue<BorderSide>, Diagnosticable, _$BorderSideMixMixin {
  @override
  final Prop<Color>? $color;
  @override
  final Prop<double>? $width;
  @override
  final Prop<BorderStyle>? $style;
  @override
  final Prop<double>? $strokeAlign;

  static final BorderSideMix none = BorderSideMix.value(.none);

  BorderSideMix({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) : this.create(
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

  const BorderSideMix.create({
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
    return borderSide != null && borderSide != .none
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

  @override
  BorderSide get defaultValue => const .new();
}
