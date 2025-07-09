// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

@immutable
sealed class BoxBorderDto<T extends BoxBorder> extends Mix<T> {
  final BorderSideDto? top;
  final BorderSideDto? bottom;

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

  BorderDto _asBorder() {
    if (this is BorderDto) return this as BorderDto;

    return BorderDto(top: top, bottom: bottom);
  }

  BorderDirectionalDto _asBorderDirectional() {
    if (this is BorderDirectionalDto) return this as BorderDirectionalDto;

    return BorderDirectionalDto(top: top, bottom: bottom);
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

  const BorderDto({super.top, super.bottom, this.left, this.right});

  const BorderDto.all(BorderSideDto side)
    : this(top: side, bottom: side, left: side, right: side);

  const BorderDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) : this(
         top: horizontal,
         bottom: horizontal,
         left: vertical,
         right: vertical,
       );

  const BorderDto.vertical(BorderSideDto side) : this.symmetric(vertical: side);

  const BorderDto.horizontal(BorderSideDto side)
    : this.symmetric(horizontal: side);

  /// Resolves to [Border] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final border = BorderDto(...).resolve(mix);
  /// ```
  @override
  Border resolve(MixContext mix) {
    return Border(
      top: top?.resolve(mix) ?? BorderSide.none,
      right: right?.resolve(mix) ?? BorderSide.none,
      bottom: bottom?.resolve(mix) ?? BorderSide.none,
      left: left?.resolve(mix) ?? BorderSide.none,
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

  const BorderDirectionalDto({super.top, super.bottom, this.start, this.end});

  const BorderDirectionalDto.all(BorderSideDto side)
    : this(top: side, bottom: side, start: side, end: side);

  const BorderDirectionalDto.symmetric({
    BorderSideDto? vertical,
    BorderSideDto? horizontal,
  }) : this(
         top: horizontal,
         bottom: horizontal,
         start: vertical,
         end: vertical,
       );

  const BorderDirectionalDto.vertical(BorderSideDto side)
    : this.symmetric(vertical: side);

  const BorderDirectionalDto.horizontal(BorderSideDto side)
    : this.symmetric(horizontal: side);

  /// Resolves to [BorderDirectional] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderDirectional = BorderDirectionalDto(...).resolve(mix);
  /// ```
  @override
  BorderDirectional resolve(MixContext mix) {
    return BorderDirectional(
      top: top?.resolve(mix) ?? BorderSide.none,
      start: start?.resolve(mix) ?? BorderSide.none,
      end: end?.resolve(mix) ?? BorderSide.none,
      bottom: bottom?.resolve(mix) ?? BorderSide.none,
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
  // Properties use MixProp for cleaner merging - nullable as per user requirement
  final MixValue<Color> color;
  final MixValue<double> width;
  final MixValue<BorderStyle> style;
  final MixValue<double> strokeAlign;

  static const BorderSideDto none = BorderSideDto._(
    color: MixValue.empty(),
    width: MixValue.empty(),
    style: MixValue.empty(),
    strokeAlign: MixValue.empty(),
  );

  // Main constructor accepts Mix values
  factory BorderSideDto({
    Mix<Color>? color,
    Mix<double>? strokeAlign,
    Mix<BorderStyle>? style,
    Mix<double>? width,
  }) {
    return BorderSideDto._(
      color: MixValue(color),
      width: MixValue(width),
      style: MixValue(style),
      strokeAlign: MixValue(strokeAlign),
    );
  }

  // Private constructor that accepts MixProp instances
  const BorderSideDto._({
    required this.color,
    required this.width,
    required this.style,
    required this.strokeAlign,
  });

  /// Resolves to [BorderSide] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final borderSide = BorderSideDto(...).resolve(mix);
  /// ```
  @override
  BorderSide resolve(MixContext mix) {
    return BorderSide(
      color: color.resolve(mix) ?? defaultValue.color,
      width: width.resolve(mix) ?? defaultValue.width,
      style: style.resolve(mix) ?? defaultValue.style,
      strokeAlign: strokeAlign.resolve(mix) ?? defaultValue.strokeAlign,
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
      color: color.merge(other.color),
      width: width.merge(other.width),
      style: style.merge(other.style),
      strokeAlign: strokeAlign.merge(other.strokeAlign),
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
