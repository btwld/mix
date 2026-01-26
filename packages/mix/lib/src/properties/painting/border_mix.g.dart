// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'border_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$BorderMixMixin on Mix<Border>, DefaultValue<Border>, Diagnosticable {
  Prop<BorderSide>? get $bottom;
  Prop<BorderSide>? get $left;
  Prop<BorderSide>? get $right;
  Prop<BorderSide>? get $top;

  @override
  BorderMix merge(BorderMix? other) {
    return BorderMix.create(
      bottom: MixOps.merge($bottom, other?.$bottom),
      left: MixOps.merge($left, other?.$left),
      right: MixOps.merge($right, other?.$right),
      top: MixOps.merge($top, other?.$top),
    );
  }

  @override
  Border resolve(BuildContext context) {
    return Border(
      bottom: MixOps.resolve(context, $bottom) ?? defaultValue.bottom,
      left: MixOps.resolve(context, $left) ?? defaultValue.left,
      right: MixOps.resolve(context, $right) ?? defaultValue.right,
      top: MixOps.resolve(context, $top) ?? defaultValue.top,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottom', $bottom))
      ..add(DiagnosticsProperty('left', $left))
      ..add(DiagnosticsProperty('right', $right))
      ..add(DiagnosticsProperty('top', $top));
  }

  @override
  List<Object?> get props => [$bottom, $left, $right, $top];
}

mixin _$BorderDirectionalMixMixin
    on Mix<BorderDirectional>, DefaultValue<BorderDirectional>, Diagnosticable {
  Prop<BorderSide>? get $bottom;
  Prop<BorderSide>? get $end;
  Prop<BorderSide>? get $start;
  Prop<BorderSide>? get $top;

  @override
  BorderDirectionalMix merge(BorderDirectionalMix? other) {
    return BorderDirectionalMix.create(
      bottom: MixOps.merge($bottom, other?.$bottom),
      end: MixOps.merge($end, other?.$end),
      start: MixOps.merge($start, other?.$start),
      top: MixOps.merge($top, other?.$top),
    );
  }

  @override
  BorderDirectional resolve(BuildContext context) {
    return BorderDirectional(
      bottom: MixOps.resolve(context, $bottom) ?? defaultValue.bottom,
      end: MixOps.resolve(context, $end) ?? defaultValue.end,
      start: MixOps.resolve(context, $start) ?? defaultValue.start,
      top: MixOps.resolve(context, $top) ?? defaultValue.top,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('bottom', $bottom))
      ..add(DiagnosticsProperty('end', $end))
      ..add(DiagnosticsProperty('start', $start))
      ..add(DiagnosticsProperty('top', $top));
  }

  @override
  List<Object?> get props => [$bottom, $end, $start, $top];
}

mixin _$BorderSideMixMixin
    on Mix<BorderSide>, DefaultValue<BorderSide>, Diagnosticable {
  Prop<Color>? get $color;
  Prop<double>? get $strokeAlign;
  Prop<BorderStyle>? get $style;
  Prop<double>? get $width;

  @override
  BorderSideMix merge(BorderSideMix? other) {
    return BorderSideMix.create(
      color: MixOps.merge($color, other?.$color),
      strokeAlign: MixOps.merge($strokeAlign, other?.$strokeAlign),
      style: MixOps.merge($style, other?.$style),
      width: MixOps.merge($width, other?.$width),
    );
  }

  @override
  BorderSide resolve(BuildContext context) {
    return BorderSide(
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      strokeAlign:
          MixOps.resolve(context, $strokeAlign) ?? defaultValue.strokeAlign,
      style: MixOps.resolve(context, $style) ?? defaultValue.style,
      width: MixOps.resolve(context, $width) ?? defaultValue.width,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('strokeAlign', $strokeAlign))
      ..add(DiagnosticsProperty('style', $style))
      ..add(DiagnosticsProperty('width', $width));
  }

  @override
  List<Object?> get props => [$color, $strokeAlign, $style, $width];
}
