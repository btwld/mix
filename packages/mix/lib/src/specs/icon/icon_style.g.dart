// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$IconStylerMixin on Style<IconSpec>, Diagnosticable {
  Prop<bool>? get $applyTextScaling;
  Prop<BlendMode>? get $blendMode;
  Prop<Color>? get $color;
  Prop<double>? get $fill;
  Prop<double>? get $grade;
  Prop<IconData>? get $icon;
  Prop<double>? get $opacity;
  Prop<double>? get $opticalSize;
  Prop<String>? get $semanticsLabel;
  Prop<List<Shadow>>? get $shadows;
  Prop<double>? get $size;
  Prop<TextDirection>? get $textDirection;
  Prop<double>? get $weight;

  /// Sets the applyTextScaling.
  IconStyler applyTextScaling(bool value) {
    return merge(IconStyler(applyTextScaling: value));
  }

  /// Sets the blendMode.
  IconStyler blendMode(BlendMode value) {
    return merge(IconStyler(blendMode: value));
  }

  /// Sets the color.
  IconStyler color(Color value) {
    return merge(IconStyler(color: value));
  }

  /// Sets the fill.
  IconStyler fill(double value) {
    return merge(IconStyler(fill: value));
  }

  /// Sets the grade.
  IconStyler grade(double value) {
    return merge(IconStyler(grade: value));
  }

  /// Sets the icon.
  IconStyler icon(IconData value) {
    return merge(IconStyler(icon: value));
  }

  /// Sets the opacity.
  IconStyler opacity(double value) {
    return merge(IconStyler(opacity: value));
  }

  /// Sets the opticalSize.
  IconStyler opticalSize(double value) {
    return merge(IconStyler(opticalSize: value));
  }

  /// Sets the semanticsLabel.
  IconStyler semanticsLabel(String value) {
    return merge(IconStyler(semanticsLabel: value));
  }

  /// Sets the shadows.
  IconStyler shadows(List<ShadowMix> value) {
    return merge(IconStyler(shadows: value));
  }

  /// Sets the size.
  IconStyler size(double value) {
    return merge(IconStyler(size: value));
  }

  /// Sets the textDirection.
  IconStyler textDirection(TextDirection value) {
    return merge(IconStyler(textDirection: value));
  }

  /// Sets the weight.
  IconStyler weight(double value) {
    return merge(IconStyler(weight: value));
  }

  /// Sets the animation configuration.
  IconStyler animate(AnimationConfig value) {
    return merge(IconStyler(animation: value));
  }

  /// Sets the style variants.
  IconStyler variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  IconStyler wrap(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  /// Merges with another [IconStyler].
  @override
  IconStyler merge(IconStyler? other) {
    return IconStyler.create(
      applyTextScaling: MixOps.merge(
        $applyTextScaling,
        other?.$applyTextScaling,
      ),
      blendMode: MixOps.merge($blendMode, other?.$blendMode),
      color: MixOps.merge($color, other?.$color),
      fill: MixOps.merge($fill, other?.$fill),
      grade: MixOps.merge($grade, other?.$grade),
      icon: MixOps.merge($icon, other?.$icon),
      opacity: MixOps.merge($opacity, other?.$opacity),
      opticalSize: MixOps.merge($opticalSize, other?.$opticalSize),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      shadows: MixOps.merge($shadows, other?.$shadows),
      size: MixOps.merge($size, other?.$size),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      weight: MixOps.merge($weight, other?.$weight),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<IconSpec>] using context.
  @override
  StyleSpec<IconSpec> resolve(BuildContext context) {
    final spec = IconSpec(
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
      blendMode: MixOps.resolve(context, $blendMode),
      color: MixOps.resolve(context, $color),
      fill: MixOps.resolve(context, $fill),
      grade: MixOps.resolve(context, $grade),
      icon: MixOps.resolve(context, $icon),
      opacity: MixOps.resolve(context, $opacity),
      opticalSize: MixOps.resolve(context, $opticalSize),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      shadows: MixOps.resolve(context, $shadows),
      size: MixOps.resolve(context, $size),
      textDirection: MixOps.resolve(context, $textDirection),
      weight: MixOps.resolve(context, $weight),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('applyTextScaling', $applyTextScaling))
      ..add(DiagnosticsProperty('blendMode', $blendMode))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('fill', $fill))
      ..add(DiagnosticsProperty('grade', $grade))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('opacity', $opacity))
      ..add(DiagnosticsProperty('opticalSize', $opticalSize))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('weight', $weight));
  }

  @override
  List<Object?> get props => [
    $applyTextScaling,
    $blendMode,
    $color,
    $fill,
    $grade,
    $icon,
    $opacity,
    $opticalSize,
    $semanticsLabel,
    $shadows,
    $size,
    $textDirection,
    $weight,
    $animation,
    $modifier,
    $variants,
  ];
}
