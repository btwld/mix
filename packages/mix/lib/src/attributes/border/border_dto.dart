// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/mix_error.dart';

part 'border_dto.g.dart';

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

@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderDto extends BoxBorderDto<Border> with _$BorderDto {
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

  @override
  bool get isUniform => top == bottom && top == left && top == right;
}

@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderDirectionalDto extends BoxBorderDto<BorderDirectional>
    with _$BorderDirectionalDto {
  final BorderSideDto? start;
  final BorderSideDto? end;
  const BorderDirectionalDto({
    super.top,
    super.bottom,
    this.start,
    this.end,
  });

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

  @override
  bool get isUniform => top == bottom && top == start && top == end;
}

@MixableType()
final class BorderSideDto extends Mixable<BorderSide>
    with HasDefaultValue<BorderSide>, _$BorderSideDto {
  final ColorDto? color;
  final double? width;

  final BorderStyle? style;
  @MixableField(utilities: [MixableFieldUtility(type: StrokeAlignUtility)])
  final double? strokeAlign;

  const BorderSideDto({
    this.color,
    this.strokeAlign,
    this.style,
    this.width,
  });

  const BorderSideDto.none() : this(style: BorderStyle.none, width: 0.0);

  @override
  BorderSide get defaultValue => const BorderSide();
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

    throw MixError.unsupportedTypeInDto(
      BoxBorder,
      ['Border', 'BorderDirectional'],
    );
  }
}
