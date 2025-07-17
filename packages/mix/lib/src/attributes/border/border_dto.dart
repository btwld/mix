// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

sealed class BoxBorderDto<T extends BoxBorder> extends Mix<T> {
  final MixProp<BorderSide, BorderSideDto>? top;
  final MixProp<BorderSide, BorderSideDto>? bottom;

  const BoxBorderDto({this.top, this.bottom});

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

    return BorderDto.props(top: top, bottom: bottom);
  }

  @protected
  BorderDirectionalDto _asBorderDirectional() {
    if (this is BorderDirectionalDto) return this as BorderDirectionalDto;

    return BorderDirectionalDto.props(top: top, bottom: bottom);
  }

  bool get isUniform;

  bool get isDirectional => this is BorderDirectionalDto;
  @override
  BoxBorderDto<T> merge(covariant BoxBorderDto<T>? other);
}

final class BorderDto extends BoxBorderDto<Border>
    with HasDefaultValue<Border> {
  final MixProp<BorderSide, BorderSideDto>? left;
  final MixProp<BorderSide, BorderSideDto>? right;

  static BorderDto none = BorderDto.all(BorderSideDto.none);

  factory BorderDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return BorderDto.props(
      top: MixProp.maybeValue(top),
      bottom: MixProp.maybeValue(bottom),
      left: MixProp.maybeValue(left),
      right: MixProp.maybeValue(right),
    );
  }

  // Private constructor that accepts Prop instances
  const BorderDto.props({super.top, super.bottom, this.left, this.right});

  /// Constructor that accepts a [Border] value and extracts its properties.
  ///
  /// This is useful for converting existing [Border] instances to [BorderDto].
  ///
  /// ```dart
  /// const border = Border.all(color: Colors.red, width: 2.0);
  /// final dto = BorderDto.value(border);
  /// ```
  factory BorderDto.value(Border border) {
    return BorderDto(
      top: BorderSideDto.maybeValue(border.top),
      bottom: BorderSideDto.maybeValue(border.bottom),
      left: BorderSideDto.maybeValue(border.left),
      right: BorderSideDto.maybeValue(border.right),
    );
  }

  factory BorderDto.all(BorderSideDto side) {
    return BorderDto.props(
      top: MixProp.fromValue(side),
      bottom: MixProp.fromValue(side),
      left: MixProp.fromValue(side),
      right: MixProp.fromValue(side),
    );
  }

  factory BorderDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) {
    return BorderDto.props(
      top: MixProp.maybeValue(horizontal),
      bottom: MixProp.maybeValue(horizontal),
      left: MixProp.maybeValue(vertical),
      right: MixProp.maybeValue(vertical),
    );
  }

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
      top: resolveMixProp(context, top) ?? BorderSide.none,
      right: resolveMixProp(context, right) ?? BorderSide.none,
      bottom: resolveMixProp(context, bottom) ?? BorderSide.none,
      left: resolveMixProp(context, left) ?? BorderSide.none,
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

    return BorderDto.props(
      top: mergeMixProp(top, other.top),
      bottom: mergeMixProp(bottom, other.bottom),
      left: mergeMixProp(left, other.left),
      right: mergeMixProp(right, other.right),
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

  @override
  Border get defaultValue => const Border();
}

final class BorderDirectionalDto extends BoxBorderDto<BorderDirectional>
    with HasDefaultValue<BorderDirectional> {
  final MixProp<BorderSide, BorderSideDto>? start;
  final MixProp<BorderSide, BorderSideDto>? end;
  static final BorderDirectionalDto none = BorderDirectionalDto.all(
    BorderSideDto.none,
  );

  // Main constructor accepts DTOs
  factory BorderDirectionalDto({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return BorderDirectionalDto.props(
      top: MixProp.maybeValue(top),
      bottom: MixProp.maybeValue(bottom),
      start: MixProp.maybeValue(start),
      end: MixProp.maybeValue(end),
    );
  }

  // Private constructor that accepts Prop instances
  const BorderDirectionalDto.props({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

  /// Constructor that accepts a [BorderDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderDirectional] instances to [BorderDirectionalDto].
  ///
  /// ```dart
  /// const border = BorderDirectional.all(BorderSide(color: Colors.red, width: 2.0));
  /// final dto = BorderDirectionalDto.value(border);
  /// ```
  factory BorderDirectionalDto.value(BorderDirectional border) {
    return BorderDirectionalDto(
      top: BorderSideDto.maybeValue(border.top),
      bottom: BorderSideDto.maybeValue(border.bottom),
      start: BorderSideDto.maybeValue(border.start),
      end: BorderSideDto.maybeValue(border.end),
    );
  }

  factory BorderDirectionalDto.all(BorderSideDto side) {
    return BorderDirectionalDto.props(
      top: MixProp.fromValue(side),
      bottom: MixProp.fromValue(side),
      start: MixProp.fromValue(side),
      end: MixProp.fromValue(side),
    );
  }

  factory BorderDirectionalDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) {
    return BorderDirectionalDto.props(
      top: MixProp.maybeValue(horizontal),
      bottom: MixProp.maybeValue(horizontal),
      start: MixProp.maybeValue(vertical),
      end: MixProp.maybeValue(vertical),
    );
  }

  factory BorderDirectionalDto.vertical(BorderSideDto side) {
    return BorderDirectionalDto.symmetric(vertical: side);
  }

  factory BorderDirectionalDto.horizontal(BorderSideDto side) {
    return BorderDirectionalDto.symmetric(horizontal: side);
  }

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
      top: resolveMixProp(context, top) ?? defaultValue.top,
      start: resolveMixProp(context, start) ?? defaultValue.start,
      end: resolveMixProp(context, end) ?? defaultValue.end,
      bottom: resolveMixProp(context, bottom) ?? defaultValue.bottom,
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

    return BorderDirectionalDto.props(
      top: mergeMixProp(top, other.top),
      bottom: mergeMixProp(bottom, other.bottom),
      start: mergeMixProp(start, other.start),
      end: mergeMixProp(end, other.end),
    );
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
  List<Object?> get props => [top, bottom, start, end];
}

final class BorderSideDto extends Mix<BorderSide>
    with HasDefaultValue<BorderSide> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? color;
  final Prop<double>? width;
  final Prop<BorderStyle>? style;
  final Prop<double>? strokeAlign;

  static final BorderSideDto none = BorderSideDto();

  // Main constructor accepts raw values
  factory BorderSideDto({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return BorderSideDto.props(
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
    return BorderSideDto(
      color: borderSide.color,
      strokeAlign: borderSide.strokeAlign,
      style: borderSide.style,
      width: borderSide.width,
    );
  }

  /// Constructor that accepts Prop values directly
  const BorderSideDto.props({
    this.color,
    this.width,
    this.style,
    this.strokeAlign,
  });

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
      color: resolveProp(context, color) ?? defaultValue.color,
      width: resolveProp(context, width) ?? defaultValue.width,
      style: resolveProp(context, style) ?? defaultValue.style,
      strokeAlign:
          resolveProp(context, strokeAlign) ?? defaultValue.strokeAlign,
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

    return BorderSideDto.props(
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
