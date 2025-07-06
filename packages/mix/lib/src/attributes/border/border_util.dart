// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class BoxBorderUtility<T extends StyleElement>
    extends DtoUtility<T, BoxBorderDto, BoxBorder> {
  late final directional = BorderDirectionalUtility(builder);
  late final all = _border.all;
  late final bottom = _border.bottom;
  late final top = _border.top;
  late final left = _border.left;
  late final right = _border.right;
  late final horizontal = _border.horizontal;
  late final vertical = _border.vertical;
  late final start = directional.start;
  late final end = directional.end;

  late final color = _border.color;
  late final width = _border.width;
  late final style = _border.style;
  late final strokeAlign = _border.strokeAlign;

  late final none = _border.none;

  late final _border = BorderUtility(builder);

  BoxBorderUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: color != null ? Mixable.value(color) : null,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return builder(
      BorderDto(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderUtility<T extends StyleElement>
    extends DtoUtility<T, BorderDto, Border> {
  late final all = BorderSideUtility((v) => builder(BorderDto.all(v)));

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final left = BorderSideUtility((v) => only(left: v));

  late final right = BorderSideUtility((v) => only(right: v));

  late final vertical = BorderSideUtility(
    (v) => builder(BorderDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility(
    (v) => builder(BorderDto.horizontal(v)),
  );

  late final color = all.color;

  late final style = all.style;

  late final width = all.width;

  late final strokeAlign = all.strokeAlign;

  BorderUtility(super.builder) : super(valueToDto: (value) => value.toDto());

  T none() => builder(const BorderDto.none());

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: Mixable.maybeValue(color),
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? left,
    BorderSideDto? right,
  }) {
    return builder(
      BorderDto(top: top, bottom: bottom, left: left, right: right),
    );
  }
}

final class BorderDirectionalUtility<T extends StyleElement>
    extends DtoUtility<T, BorderDirectionalDto, BorderDirectional> {
  late final all = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.all(v)),
  );

  late final bottom = BorderSideUtility((v) => only(bottom: v));

  late final top = BorderSideUtility((v) => only(top: v));

  late final start = BorderSideUtility((v) => only(start: v));

  late final end = BorderSideUtility((v) => only(end: v));

  late final vertical = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.vertical(v)),
  );

  late final horizontal = BorderSideUtility(
    (v) => builder(BorderDirectionalDto.horizontal(v)),
  );

  BorderDirectionalUtility(super.builder)
    : super(valueToDto: (value) => value.toDto());

  T none() => builder(const BorderDirectionalDto.none());

  T call({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return all(
      color: Mixable.maybeValue(color),
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );
  }

  @override
  T only({
    BorderSideDto? top,
    BorderSideDto? bottom,
    BorderSideDto? start,
    BorderSideDto? end,
  }) {
    return builder(
      BorderDirectionalDto(top: top, bottom: bottom, start: start, end: end),
    );
  }
}
