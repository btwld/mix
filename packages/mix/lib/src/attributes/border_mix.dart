// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

sealed class BoxBorderMix<T extends BoxBorder> extends Mix<T> {
  final Prop<Mix<BorderSide>>? top;
  final Prop<Mix<BorderSide>>? bottom;

  const BoxBorderMix({this.top, this.bottom});

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

    return BorderMix(
      top: top,
      bottom: bottom,
      left: directional.start, // start maps to left
      right: directional.end, // end maps to right
    );
  }

  @protected
  BorderDirectionalMix _asBorderDirectional() {
    if (this is BorderDirectionalMix) return this as BorderDirectionalMix;

    // Convert BorderMix to BorderDirectionalMix
    final border = this as BorderMix;

    return BorderDirectionalMix(
      top: top,
      bottom: bottom,
      start: border.left, // left maps to start
      end: border.right, // right maps to end
    );
  }

  bool get isUniform;

  bool get isDirectional => this is BorderDirectionalMix;
  @override
  BoxBorderMix<T> merge(covariant BoxBorderMix<T>? other);
}

final class BorderMix extends BoxBorderMix<Border> with DefaultValue<Border> {
  final Prop<Mix<BorderSide>>? left;
  final Prop<Mix<BorderSide>>? right;

  static BorderMix none = BorderMix.all(BorderSideMix.none);

  BorderMix.only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? left,
    BorderSideMix? right,
  }) : this(
         top: Prop.maybe(top),
         bottom: Prop.maybe(bottom),
         left: Prop.maybe(left),
         right: Prop.maybe(right),
       );

  const BorderMix({super.top, super.bottom, this.left, this.right});

  /// Constructor that accepts a [Border] value and extracts its properties.
  ///
  /// This is useful for converting existing [Border] instances to [BorderMix].
  ///
  /// ```dart
  /// const border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderMix.value(border);
  /// ```
  BorderMix.value(Border border)
    : this.only(
        top: BorderSideMix.maybeValue(border.top),
        bottom: BorderSideMix.maybeValue(border.bottom),
        left: BorderSideMix.maybeValue(border.left),
        right: BorderSideMix.maybeValue(border.right),
      );

  BorderMix.all(BorderSideMix side)
    : this.only(top: side, bottom: side, left: side, right: side);

  BorderMix.symmetric({BorderSideMix? vertical, BorderSideMix? horizontal})
    : this.only(
        top: horizontal,
        bottom: horizontal,
        left: vertical,
        right: vertical,
      );

  factory BorderMix.vertical(BorderSideMix side) {
    return BorderMix.symmetric(vertical: side);
  }

  factory BorderMix.horizontal(BorderSideMix side) {
    return BorderMix.symmetric(horizontal: side);
  }

  /// Constructor that accepts a nullable [Border] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderMix.value].
  ///
  /// ```dart
  /// const Border? border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderMix.maybeValue(border); // Returns BorderMix or null
  /// ```
  static BorderMix? maybeValue(Border? border) {
    return border != null ? BorderMix.value(border) : null;
  }

  /// Resolves to [Border] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final border = BorderMix(...).resolve(mix);
  /// ```
  @override
  Border resolve(BuildContext context) {
    return Border(
      top: MixHelpers.resolveMix(context, top) ?? BorderSide.none,
      right: MixHelpers.resolveMix(context, right) ?? BorderSide.none,
      bottom: MixHelpers.resolveMix(context, bottom) ?? BorderSide.none,
      left: MixHelpers.resolveMix(context, left) ?? BorderSide.none,
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

    return BorderMix(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      left: MixHelpers.merge(left, other.left),
      right: MixHelpers.merge(right, other.right),
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderMix &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  bool get isUniform => top == bottom && bottom == left && left == right;

  @override
  int get hashCode => Object.hash(top, bottom, left, right);

  @override
  Border get defaultValue => const Border();
}

final class BorderDirectionalMix extends BoxBorderMix<BorderDirectional>
    with DefaultValue<BorderDirectional> {
  final Prop<Mix<BorderSide>>? start;
  final Prop<Mix<BorderSide>>? end;
  static final BorderDirectionalMix none = BorderDirectionalMix.all(
    BorderSideMix.none,
  );

  BorderDirectionalMix.only({
    BorderSideMix? top,
    BorderSideMix? bottom,
    BorderSideMix? start,
    BorderSideMix? end,
  }) : this(
         top: Prop.maybe(top),
         bottom: Prop.maybe(bottom),
         start: Prop.maybe(start),
         end: Prop.maybe(end),
       );

  const BorderDirectionalMix({super.top, super.bottom, this.start, this.end});

  /// Constructor that accepts a [BorderDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderDirectional] instances to [BorderDirectionalMix].
  ///
  /// ```dart
  /// const border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalMix.value(border);
  /// ```
  BorderDirectionalMix.value(BorderDirectional border)
    : this.only(
        top: BorderSideMix.maybeValue(border.top),
        bottom: BorderSideMix.maybeValue(border.bottom),
        start: BorderSideMix.maybeValue(border.start),
        end: BorderSideMix.maybeValue(border.end),
      );

  BorderDirectionalMix.all(BorderSideMix side)
    : this.only(top: side, bottom: side, start: side, end: side);

  BorderDirectionalMix.symmetric({
    BorderSideMix? vertical,
    BorderSideMix? horizontal,
  }) : this.only(
         top: horizontal,
         bottom: horizontal,
         start: vertical,
         end: vertical,
       );

  BorderDirectionalMix.vertical(BorderSideMix side)
    : this.symmetric(vertical: side);
  BorderDirectionalMix.horizontal(BorderSideMix side)
    : this.symmetric(horizontal: side);

  /// Constructor that accepts a nullable [BorderDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderDirectionalMix.value].
  ///
  /// ```dart
  /// const BorderDirectional? border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalMix.maybeValue(border); // Returns BorderDirectionalMix or null
  /// ```
  static BorderDirectionalMix? maybeValue(BorderDirectional? border) {
    return border != null ? BorderDirectionalMix.value(border) : null;
  }

  /// Resolves to [BorderDirectional] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderDirectional = BorderDirectionalMix(...).resolve(mix);
  /// ```
  @override
  BorderDirectional resolve(BuildContext context) {
    return BorderDirectional(
      top: MixHelpers.resolveMix(context, top) ?? defaultValue.top,
      start: MixHelpers.resolveMix(context, start) ?? defaultValue.start,
      end: MixHelpers.resolveMix(context, end) ?? defaultValue.end,
      bottom: MixHelpers.resolveMix(context, bottom) ?? defaultValue.bottom,
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

    return BorderDirectionalMix(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      start: MixHelpers.merge(start, other.start),
      end: MixHelpers.merge(end, other.end),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderDirectionalMix &&
        other.top == top &&
        other.bottom == bottom &&
        other.start == start &&
        other.end == end;
  }

  @override
  bool get isUniform => top == bottom && bottom == start && start == end;

  /// The list of properties that constitute the state of this [BorderDirectionalMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderDirectionalMix] instances for equality.
  @override
  BorderDirectional get defaultValue => const BorderDirectional();

  @override
  @override
  int get hashCode => Object.hash(top, bottom, start, end);
}

final class BorderSideMix extends Mix<BorderSide>
    with DefaultValue<BorderSide> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? color;
  final Prop<double>? width;
  final Prop<BorderStyle>? style;
  final Prop<double>? strokeAlign;

  static final BorderSideMix none = BorderSideMix();

  BorderSideMix.only({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) : this(
         color: Prop.maybe(color),
         width: Prop.maybe(width),
         style: Prop.maybe(style),
         strokeAlign: Prop.maybe(strokeAlign),
       );

  /// Constructor that accepts a [BorderSide] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderSide] instances to [BorderSideMix].
  ///
  /// ```dart
  /// const borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideMix.value(borderSide);
  /// ```
  BorderSideMix.value(BorderSide borderSide)
    : this.only(
        color: borderSide.color,
        strokeAlign: borderSide.strokeAlign,
        style: borderSide.style,
        width: borderSide.width,
      );

  const BorderSideMix({this.color, this.width, this.style, this.strokeAlign});

  /// Constructor that accepts a nullable [BorderSide] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderSideMix.value].
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

  /// Resolves to [BorderSide] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderSide = BorderSideMix(...).resolve(mix);
  /// ```
  @override
  BorderSide resolve(BuildContext context) {
    return BorderSide(
      color: MixHelpers.resolve(context, color) ?? defaultValue.color,
      width: MixHelpers.resolve(context, width) ?? defaultValue.width,
      style: MixHelpers.resolve(context, style) ?? defaultValue.style,
      strokeAlign:
          MixHelpers.resolve(context, strokeAlign) ?? defaultValue.strokeAlign,
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

    return BorderSideMix(
      color: MixHelpers.merge(color, other.color),
      width: MixHelpers.merge(width, other.width),
      style: MixHelpers.merge(style, other.style),
      strokeAlign: MixHelpers.merge(strokeAlign, other.strokeAlign),
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderSideMix &&
        other.color == color &&
        other.width == width &&
        other.style == style &&
        other.strokeAlign == strokeAlign;
  }

  @override
  BorderSide get defaultValue => const BorderSide();

  @override
  int get hashCode => Object.hash(color, width, style, strokeAlign);
}
