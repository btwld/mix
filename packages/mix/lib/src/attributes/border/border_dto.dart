// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

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

  // Factory from Border
  factory BorderDto.from(Border border) {
    return BorderDto(
      top: BorderSideDto.from(border.top),
      bottom: BorderSideDto.from(border.bottom),
      left: BorderSideDto.from(border.left),
      right: BorderSideDto.from(border.right),
    );
  }

  // Nullable factory from Border
  static BorderDto? maybeFrom(Border? border) {
    return border != null ? BorderDto.from(border) : null;
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

  // Factory from BorderDirectional
  factory BorderDirectionalDto.from(BorderDirectional border) {
    return BorderDirectionalDto(
      top: BorderSideDto.from(border.top),
      bottom: BorderSideDto.from(border.bottom),
      start: BorderSideDto.from(border.start),
      end: BorderSideDto.from(border.end),
    );
  }

  // Nullable factory from BorderDirectional
  static BorderDirectionalDto? maybeFrom(BorderDirectional? border) {
    return border != null ? BorderDirectionalDto.from(border) : null;
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
  // Properties use MixableProperty for cleaner merging - always nullable internally
  final MixableProperty<Color> color;
  final MixableProperty<double> width;
  final MixableProperty<BorderStyle> style;
  final MixableProperty<double> strokeAlign;

  // Main constructor accepts real values
  factory BorderSideDto({
    Color? color,
    double? strokeAlign,
    BorderStyle? style,
    double? width,
  }) {
    return BorderSideDto.raw(
      color: MixableProperty.prop(color),
      width: MixableProperty.prop(width),
      style: MixableProperty.prop(style),
      strokeAlign: MixableProperty.prop(strokeAlign),
    );
  }

  // Factory that accepts MixableProperty instances
  const BorderSideDto.raw({
    required this.color,
    required this.width,
    required this.style,
    required this.strokeAlign,
  });

  const BorderSideDto.none()
    : this.raw(
        color: const MixableProperty(null),
        width: const MixableProperty(Mixable.value(0.0)),
        style: const MixableProperty(Mixable.value(BorderStyle.none)),
        strokeAlign: const MixableProperty(null),
      );

  // Factory from BorderSide
  factory BorderSideDto.from(BorderSide side) {
    return BorderSideDto(
      color: side.color,
      strokeAlign: side.strokeAlign,
      style: side.style,
      width: side.width,
    );
  }

  // Nullable factory from BorderSide
  static BorderSideDto? maybeFrom(BorderSide? side) {
    return side != null ? BorderSideDto.from(side) : null;
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

    return BorderSideDto.raw(
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

/// Utility class for configuring [BorderSide] properties.
///
/// This class provides methods to set individual properties of a [BorderSide].
/// Use the methods of this class to configure specific properties of a [BorderSide].
class BorderSideUtility<T extends StyleElement>
    extends DtoUtility<T, BorderSideDto, BorderSide> {
  /// Utility for defining [BorderSideDto.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [BorderSideDto.strokeAlign]
  late final strokeAlign = StrokeAlignUtility(
    (v) => only(strokeAlign: Mixable.value(v)),
  );

  /// Utility for defining [BorderSideDto.style]
  late final style = BorderStyleUtility((v) => only(style: Mixable.value(v)));

  /// Utility for defining [BorderSideDto.width]
  late final width = DoubleUtility((v) => only(width: Mixable.value(v)));

  BorderSideUtility(super.builder)
    : super(
        valueToDto: (v) => BorderSideDto(
          color: v.color,
          strokeAlign: v.strokeAlign,
          style: v.style,
          width: v.width,
        ),
      );

  /// Creates a [StyleElement] instance using the [BorderSideDto.none] constructor.
  T none() => builder(const BorderSideDto.none());

  T call({
    Color? color,
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

  /// Returns a new [BorderSideDto] with the specified properties.
  @override
  T only({
    Mixable<Color>? color,
    Mixable<double>? strokeAlign,
    Mixable<BorderStyle>? style,
    Mixable<double>? width,
  }) {
    return builder(
      BorderSideDto.raw(
        color: MixableProperty(color),
        width: MixableProperty(width),
        style: MixableProperty(style),
        strokeAlign: MixableProperty(strokeAlign),
      ),
    );
  }
}
