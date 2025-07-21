// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

sealed class BoxBorderDto<T extends BoxBorder> extends Mix<T> {
  final MixProp<BorderSide>? top;
  final MixProp<BorderSide>? bottom;

  const BoxBorderDto({this.top, this.bottom});

  /// Merges two BoxBorderDto instances.
  ///
  /// If both are the same type, delegates to type-specific merge.
  /// If different types, converts to the type of [b] and merges.
  /// If [b] is null, returns [a]. If [a] is null, returns [b].
  static BoxBorderDto? tryToMerge(BoxBorderDto? a, BoxBorderDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    return switch ((a, b)) {
      (BorderDto first, BorderDto second) => first.merge(second),
      (BorderDirectionalDto first, BorderDirectionalDto second) => first.merge(
        second,
      ),
      (BorderDto first, BorderDirectionalDto second) =>
        first._asBorderDirectional().merge(second),
      (BorderDirectionalDto first, BorderDto second) => first._asBorder().merge(
        second,
      ),
    };
  }

  static BoxBorderDto<T> value<T extends BoxBorder>(T border) {
    return switch (border) {
      Border() => BorderDto.value(border) as BoxBorderDto<T>,
      BorderDirectional() =>
        BorderDirectionalDto.value(border) as BoxBorderDto<T>,
      _ => throw ArgumentError(
        'Unsupported BoxBorder type: ${border.runtimeType}',
      ),
    };
  }

  static BoxBorderDto<T>? maybeValue<T extends BoxBorder>(T? border) {
    if (border == null) return null;

    return value(border);
  }

  @protected
  BorderDto _asBorder() {
    if (this is BorderDto) return this as BorderDto;

    // Convert BorderDirectionalDto to BorderDto
    final directional = this as BorderDirectionalDto;

    return BorderDto(
      top: top,
      bottom: bottom,
      left: directional.start, // start maps to left
      right: directional.end, // end maps to right
    );
  }

  @protected
  BorderDirectionalDto _asBorderDirectional() {
    if (this is BorderDirectionalDto) return this as BorderDirectionalDto;

    // Convert BorderDto to BorderDirectionalDto
    final border = this as BorderDto;

    return BorderDirectionalDto(
      top: top,
      bottom: bottom,
      start: border.left, // left maps to start
      end: border.right, // right maps to end
    );
  }

  bool get isUniform;

  bool get isDirectional => this is BorderDirectionalDto;
  @override
  BoxBorderDto<T> merge(covariant BoxBorderDto<T>? other);
}

final class BorderDto extends BoxBorderDto<Border>
    with MixDefaultValue<Border> {
  final MixProp<BorderSide>? left;
  final MixProp<BorderSide>? right;

  static BorderDto none = BorderDto.all(BorderSideDto.none);

  BorderDto.only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) : this(
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
         left: MixProp.maybe(left),
         right: MixProp.maybe(right),
       );

  const BorderDto({super.top, super.bottom, this.left, this.right});

  /// Constructor that accepts a [Border] value and extracts its properties.
  ///
  /// This is useful for converting existing [Border] instances to [BorderDto].
  ///
  /// ```dart
  /// const border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderDto.value(border);
  /// ```
  BorderDto.value(Border border)
    : this.only(
        top: BorderSideDto.maybeValue(border.top),
        bottom: BorderSideDto.maybeValue(border.bottom),
        left: BorderSideDto.maybeValue(border.left),
        right: BorderSideDto.maybeValue(border.right),
      );

  BorderDto.all(BorderSideDto side)
    : this.only(top: side, bottom: side, left: side, right: side);

  BorderDto.symmetric({BorderSideDto? vertical, BorderSideDto? horizontal})
    : this.only(
        top: horizontal,
        bottom: horizontal,
        left: vertical,
        right: vertical,
      );

  factory BorderDto.vertical(BorderSideDto side) {
    return BorderDto.symmetric(vertical: side);
  }

  factory BorderDto.horizontal(BorderSideDto side) {
    return BorderDto.symmetric(horizontal: side);
  }

  /// Constructor that accepts a nullable [Border] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderDto.value].
  ///
  /// ```dart
  /// const Border? border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderDto.maybeValue(border); // Returns BorderDto or null
  /// ```
  static BorderDto? maybeValue(Border? border) {
    return border != null ? BorderDto.value(border) : null;
  }

  /// Resolves to [Border] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final border = BorderDto(...).resolve(mix);
  /// ```
  @override
  Border resolve(BuildContext context) {
    return Border(
      top: MixHelpers.resolve(context, top) ?? BorderSide.none,
      right: MixHelpers.resolve(context, right) ?? BorderSide.none,
      bottom: MixHelpers.resolve(context, bottom) ?? BorderSide.none,
      left: MixHelpers.resolve(context, left) ?? BorderSide.none,
    );
  }

  /// Merges the properties of this [BorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderDto merge(BorderDto? other) {
    if (other == null) return this;

    return BorderDto(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      left: MixHelpers.merge(left, other.left),
      right: MixHelpers.merge(right, other.right),
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderDto &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  bool get isUniform => top == bottom && top == left && top == right;

  @override
  int get hashCode =>
      top.hashCode ^ bottom.hashCode ^ left.hashCode ^ right.hashCode;

  @override
  Border get defaultValue => const Border();
}

final class BorderDirectionalDto extends BoxBorderDto<BorderDirectional>
    with MixDefaultValue<BorderDirectional> {
  final MixProp<BorderSide>? start;
  final MixProp<BorderSide>? end;
  static final BorderDirectionalDto none = BorderDirectionalDto.all(
    BorderSideDto.none,
  );

  BorderDirectionalDto.only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) : this(
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
         start: MixProp.maybe(start),
         end: MixProp.maybe(end),
       );

  const BorderDirectionalDto({super.top, super.bottom, this.start, this.end});

  /// Constructor that accepts a [BorderDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderDirectional] instances to [BorderDirectionalDto].
  ///
  /// ```dart
  /// const border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalDto.value(border);
  /// ```
  BorderDirectionalDto.value(BorderDirectional border)
    : this.only(
        top: BorderSideDto.maybeValue(border.top),
        bottom: BorderSideDto.maybeValue(border.bottom),
        start: BorderSideDto.maybeValue(border.start),
        end: BorderSideDto.maybeValue(border.end),
      );

  BorderDirectionalDto.all(BorderSideDto side)
    : this.only(top: side, bottom: side, start: side, end: side);

  BorderDirectionalDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) : this.only(
         top: horizontal,
         bottom: horizontal,
         start: vertical,
         end: vertical,
       );

  BorderDirectionalDto.vertical(BorderSideDto side)
    : this.symmetric(vertical: side);
  BorderDirectionalDto.horizontal(BorderSideDto side)
    : this.symmetric(horizontal: side);

  /// Constructor that accepts a nullable [BorderDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderDirectionalDto.value].
  ///
  /// ```dart
  /// const BorderDirectional? border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalDto.maybeValue(border); // Returns BorderDirectionalDto or null
  /// ```
  static BorderDirectionalDto? maybeValue(BorderDirectional? border) {
    return border != null ? BorderDirectionalDto.value(border) : null;
  }

  /// Resolves to [BorderDirectional] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderDirectional = BorderDirectionalDto(...).resolve(mix);
  /// ```
  @override
  BorderDirectional resolve(BuildContext context) {
    return BorderDirectional(
      top: MixHelpers.resolve(context, top) ?? defaultValue.top,
      start: MixHelpers.resolve(context, start) ?? defaultValue.start,
      end: MixHelpers.resolve(context, end) ?? defaultValue.end,
      bottom: MixHelpers.resolve(context, bottom) ?? defaultValue.bottom,
    );
  }

  /// Merges the properties of this [BorderDirectionalDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderDirectionalDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderDirectionalDto merge(BorderDirectionalDto? other) {
    if (other == null) return this;

    return BorderDirectionalDto(
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
      start: MixHelpers.merge(start, other.start),
      end: MixHelpers.merge(end, other.end),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderDirectionalDto &&
        other.top == top &&
        other.bottom == bottom &&
        other.start == start &&
        other.end == end;
  }

  @override
  bool get isUniform => top == bottom && top == start && top == end;

  /// The list of properties that constitute the state of this [BorderDirectionalDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderDirectionalDto] instances for equality.
  @override
  BorderDirectional get defaultValue => const BorderDirectional();

  @override
  int get hashCode {
    return top.hashCode ^ bottom.hashCode ^ start.hashCode ^ end.hashCode;
  }
}

final class BorderSideDto extends Mix<BorderSide>
    with MixDefaultValue<BorderSide> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? color;
  final Prop<double>? width;
  final Prop<BorderStyle>? style;
  final Prop<double>? strokeAlign;

  static final BorderSideDto none = BorderSideDto();

  BorderSideDto.only({
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
  /// This is useful for converting existing [BorderSide] instances to [BorderSideDto].
  ///
  /// ```dart
  /// const borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideDto.value(borderSide);
  /// ```
  BorderSideDto.value(BorderSide borderSide)
    : this.only(
        color: borderSide.color,
        strokeAlign: borderSide.strokeAlign,
        style: borderSide.style,
        width: borderSide.width,
      );

  const BorderSideDto({this.color, this.width, this.style, this.strokeAlign});

  /// Constructor that accepts a nullable [BorderSide] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderSideDto.value].
  ///
  /// ```dart
  /// const BorderSide? borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideDto.maybeValue(borderSide); // Returns BorderSideDto or null
  /// ```
  static BorderSideDto? maybeValue(BorderSide? borderSide) {
    return borderSide != null && borderSide != BorderSide.none
        ? BorderSideDto.value(borderSide)
        : null;
  }

  /// Resolves to [BorderSide] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderSide = BorderSideDto(...).resolve(mix);
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

  /// Merges the properties of this [BorderSideDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BorderSideDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BorderSideDto merge(BorderSideDto? other) {
    if (other == null) return this;

    return BorderSideDto(
      color: MixHelpers.merge(color, other.color),
      width: MixHelpers.merge(width, other.width),
      style: MixHelpers.merge(style, other.style),
      strokeAlign: MixHelpers.merge(strokeAlign, other.strokeAlign),
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderSideDto &&
        other.color == color &&
        other.width == width &&
        other.style == style &&
        other.strokeAlign == strokeAlign;
  }

  @override
  BorderSide get defaultValue => const BorderSide();

  @override
  int get hashCode =>
      color.hashCode ^ width.hashCode ^ style.hashCode ^ strokeAlign.hashCode;
}
