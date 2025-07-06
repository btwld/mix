// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/mix_error.dart';

@immutable
sealed class BoxBorderDto<T extends BoxBorder> extends Mixable<T> {
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

  const BorderDto({super.top, super.bottom, this.left, this.right});

  const BorderDto.all(BorderSideDto side)
    : this(top: side, bottom: side, left: side, right: side);

  const BorderDto.none() : this.all(const BorderSideDto.none());

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

  const BorderDirectionalDto.none() : this.all(const BorderSideDto.none());
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

final class BorderSideDto extends Mixable<BorderSide>
    with HasDefaultValue<BorderSide> {
  final Mixable<Color>? color;
  final double? width;

  final BorderStyle? style;
  final double? strokeAlign;

  const BorderSideDto({this.color, this.strokeAlign, this.style, this.width});

  const BorderSideDto.none() : this(style: BorderStyle.none, width: 0.0);

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
      color: color?.resolve(mix) ?? defaultValue.color,
      width: width ?? defaultValue.width,
      style: style ?? defaultValue.style,
      strokeAlign: strokeAlign ?? defaultValue.strokeAlign,
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
      color: other.color ?? color,
      strokeAlign: other.strokeAlign ?? strokeAlign,
      style: other.style ?? style,
      width: other.width ?? width,
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

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends StyleElement>
    extends DtoUtility<T, BorderSideDto, BorderSide> {
  /// Utility for defining [BorderSideDto.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [BorderSideDto.strokeAlign]
  late final strokeAlign = StrokeAlignUtility((v) => only(strokeAlign: v));

  /// Utility for defining [BorderSideDto.style]
  late final style = BorderStyleUtility((v) => only(style: v));

  /// Utility for defining [BorderSideDto.width]
  late final width = DoubleUtility((v) => only(width: v));

  BorderSideUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Creates a [StyleElement] instance using the [BorderSideDto.none] constructor.
  T none() => builder(const BorderSideDto.none());

  T call({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return only(
      color: Mixable.maybeValue(color),
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  /// Returns a new [BorderSideDto] with the specified properties.
  @override
  T only({
    Mixable<Color>? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return builder(
      BorderSideDto(
        color: color,
        strokeAlign: strokeAlign,
        style: style,
        width: width,
      ),
    );
  }
}

/// Extension methods to convert [Border] to [BorderDto].
extension BorderMixExt on Border {
  /// Converts this [Border] to a [BorderDto].
  BorderDto toDto() {
    return BorderDto(
      top: top.toDto(),
      bottom: bottom.toDto(),
      left: left.toDto(),
      right: right.toDto(),
    );
  }
}

/// Extension methods to convert List<[Border]> to List<[BorderDto]>.
extension ListBorderMixExt on List<Border> {
  /// Converts this List<[Border]> to a List<[BorderDto]>.
  List<BorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Extension methods to convert [BorderDirectional] to [BorderDirectionalDto].
extension BorderDirectionalMixExt on BorderDirectional {
  /// Converts this [BorderDirectional] to a [BorderDirectionalDto].
  BorderDirectionalDto toDto() {
    return BorderDirectionalDto(
      top: top.toDto(),
      bottom: bottom.toDto(),
      start: start.toDto(),
      end: end.toDto(),
    );
  }
}

/// Extension methods to convert List<[BorderDirectional]> to List<[BorderDirectionalDto]>.
extension ListBorderDirectionalMixExt on List<BorderDirectional> {
  /// Converts this List<[BorderDirectional]> to a List<[BorderDirectionalDto]>.
  List<BorderDirectionalDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Extension methods to convert [BorderSide] to [BorderSideDto].
extension BorderSideMixExt on BorderSide {
  /// Converts this [BorderSide] to a [BorderSideDto].
  BorderSideDto toDto() {
    return BorderSideDto(
      color: color.toDto(),
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }
}

/// Extension methods to convert List<[BorderSide]> to List<[BorderSideDto]>.
extension ListBorderSideMixExt on List<BorderSide> {
  /// Converts this List<[BorderSide]> to a List<[BorderSideDto]>.
  List<BorderSideDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

extension BoxBorderExt on BoxBorder {
  BoxBorderDto toDto() {
    final self = this;
    if (self is Border) {
      return BorderDto(
        top: self.top.toDto(),
        bottom: self.bottom.toDto(),
        left: self.left.toDto(),
        right: self.right.toDto(),
      );
    }
    if (self is BorderDirectional) {
      return BorderDirectionalDto(
        top: self.top.toDto(),
        bottom: self.bottom.toDto(),
        start: self.start.toDto(),
        end: self.end.toDto(),
      );
    }

    throw MixError.unsupportedTypeInDto(BoxBorder, [
      'Border',
      'BorderDirectional',
    ]);
  }
}
