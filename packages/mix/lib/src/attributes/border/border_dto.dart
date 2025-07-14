// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

@immutable
sealed class BoxBorderDto<T extends BoxBorder> extends Mix<T> {
  final BorderSideDto? top;
  final BorderSideDto? bottom;

  const BoxBorderDto._({this.top, this.bottom});

  /// Will try to merge two borders, the type will resolve to type of
  /// `b` if its not null and `a` otherwise.
  static BoxBorderDto? tryToMerge(BoxBorderDto? a, BoxBorderDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<A extends BoxBorderDto, B extends BoxBorderDto>(
    A a,
    B b,
  ) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (BorderDto g) => a._asBorder().merge(g) as B,
      (BorderDirectionalDto g) => a._asBorderDirectional().merge(g) as B,
    };
  }

  BorderDto _asBorder() {
    if (this is BorderDto) return this as BorderDto;

    return BorderDto._(top: top, bottom: bottom);
  }

  BorderDirectionalDto _asBorderDirectional() {
    if (this is BorderDirectionalDto) return this as BorderDirectionalDto;

    return BorderDirectionalDto._(top: top, bottom: bottom);
  }

  bool get isUniform;

  bool get isDirectional => this is BorderDirectionalDto;
  @override
  BoxBorderDto<T> merge(covariant BoxBorderDto<T>? other);
}

final class BorderDto extends BoxBorderDto<Border> {
  final BorderSideDto? left;
  final BorderSideDto? right;

  static const BorderDto none = BorderDto.all(BorderSideDto.none);

  const BorderDto._({super.top, super.bottom, this.left, this.right})
    : super._();

  factory BorderDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return BorderDto._(top: top, bottom: bottom, left: left, right: right);
  }

  /// Constructor that accepts a [Border] value and extracts its properties.
  ///
  /// This is useful for converting existing [Border] instances to [BorderDto].
  ///
  /// ```dart
  /// const border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderDto.value(border);
  /// ```
  factory BorderDto.value(Border border) {
    return BorderDto._(
      top: BorderSideDto.maybeValue(border.top),
      bottom: BorderSideDto.maybeValue(border.bottom),
      left: BorderSideDto.maybeValue(border.left),
      right: BorderSideDto.maybeValue(border.right),
    );
  }

  const BorderDto.all(BorderSideDto side)
    : this._(top: side, bottom: side, left: side, right: side);

  const BorderDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) : this._(
         top: horizontal,
         bottom: horizontal,
         left: vertical,
         right: vertical,
       );

  const BorderDto.vertical(BorderSideDto side) : this.symmetric(vertical: side);

  const BorderDto.horizontal(BorderSideDto side)
    : this.symmetric(horizontal: side);

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
  Border resolve(MixContext context) {
    return Border(
      top: top?.resolve(context) ?? BorderSide.none,
      right: right?.resolve(context) ?? BorderSide.none,
      bottom: bottom?.resolve(context) ?? BorderSide.none,
      left: left?.resolve(context) ?? BorderSide.none,
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

    return BorderDto._(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      left: left?.merge(other.left) ?? other.left,
      right: right?.merge(other.right) ?? other.right,
    );
  }

  @override
  bool get isUniform => top == bottom && top == left && top == right;

  /// The list of properties that constitute the state of this [BorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderDto] instances for equality.
  @override
  List<Object?> get props => [top, bottom, left, right];
}

final class BorderDirectionalDto extends BoxBorderDto<BorderDirectional> {
  final BorderSideDto? start;
  final BorderSideDto? end;
  static const BorderDirectionalDto none = BorderDirectionalDto.all(
    BorderSideDto.none,
  );

  const BorderDirectionalDto._({super.top, super.bottom, this.start, this.end})
    : super._();

  factory BorderDirectionalDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return BorderDirectionalDto._(
      top: top,
      bottom: bottom,
      start: start,
      end: end,
    );
  }

  /// Constructor that accepts a [BorderDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderDirectional] instances to [BorderDirectionalDto].
  ///
  /// ```dart
  /// const border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalDto.value(border);
  /// ```
  factory BorderDirectionalDto.value(BorderDirectional border) {
    return BorderDirectionalDto._(
      top: BorderSideDto.maybeValue(border.top),
      bottom: BorderSideDto.maybeValue(border.bottom),
      start: BorderSideDto.maybeValue(border.start),
      end: BorderSideDto.maybeValue(border.end),
    );
  }

  const BorderDirectionalDto.all(BorderSideDto side)
    : this._(top: side, bottom: side, start: side, end: side);

  const BorderDirectionalDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) : this._(
         top: horizontal,
         bottom: horizontal,
         start: vertical,
         end: vertical,
       );

  const BorderDirectionalDto.vertical(BorderSideDto side)
    : this.symmetric(vertical: side);

  const BorderDirectionalDto.horizontal(BorderSideDto side)
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
  BorderDirectional resolve(MixContext context) {
    return BorderDirectional(
      top: top?.resolve(context) ?? BorderSide.none,
      start: start?.resolve(context) ?? BorderSide.none,
      end: end?.resolve(context) ?? BorderSide.none,
      bottom: bottom?.resolve(context) ?? BorderSide.none,
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

    return BorderDirectionalDto._(
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
      start: start?.merge(other.start) ?? other.start,
      end: end?.merge(other.end) ?? other.end,
    );
  }

  @override
  bool get isUniform => top == bottom && top == start && top == end;

  /// The list of properties that constitute the state of this [BorderDirectionalDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderDirectionalDto] instances for equality.
  @override
  List<Object?> get props => [top, bottom, start, end];
}

final class BorderSideDto extends Mix<BorderSide>
    with HasDefaultValue<BorderSide> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? color;
  final Prop<double>? width;
  final Prop<BorderStyle>? style;
  final Prop<double>? strokeAlign;

  static const BorderSideDto none = BorderSideDto._(
    color: null,
    width: null,
    style: null,
    strokeAlign: null,
  );

  // Main constructor accepts raw values
  factory BorderSideDto({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return BorderSideDto._(
      color: Prop.maybeValue(color),
      width: Prop.maybeValue(width),
      style: Prop.maybeValue(style),
      strokeAlign: Prop.maybeValue(strokeAlign),
    );
  }

  /// Constructor that accepts a [BorderSide] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderSide] instances to [BorderSideDto].
  ///
  /// ```dart
  /// const borderSide = BorderSide(color: Colors.blue, width: 3.0);
  /// final dto = BorderSideDto.value(borderSide);
  /// ```
  factory BorderSideDto.value(BorderSide borderSide) {
    return BorderSideDto._(
      color: Prop.value(borderSide.color),
      width: Prop.value(borderSide.width),
      style: Prop.value(borderSide.style),
      strokeAlign: Prop.value(borderSide.strokeAlign),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BorderSideDto._({this.color, this.width, this.style, this.strokeAlign});

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
  BorderSide resolve(MixContext context) {
    return BorderSide(
      color: resolveProp(context, color) ?? defaultValue.color,
      width: resolveProp(context, width) ?? defaultValue.width,
      style: resolveProp(context, style) ?? defaultValue.style,
      strokeAlign: resolveProp(context, strokeAlign) ?? defaultValue.strokeAlign,
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

    return BorderSideDto._(
      color: mergeProp(color, other.color),
      width: mergeProp(width, other.width),
      style: mergeProp(style, other.style),
      strokeAlign: mergeProp(strokeAlign, other.strokeAlign),
    );
  }

  @override
  BorderSide get defaultValue => const BorderSide();

  /// The list of properties that constitute the state of this [BorderSideDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BorderSideDto] instances for equality.
  @override
  List<Object?> get props => [color, strokeAlign, style, width];
}
