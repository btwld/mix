enum SchemaStyler {
  box('box'),
  text('text'),
  flex('flex'),
  icon('icon'),
  image('image'),
  stack('stack'),
  flexBox('flex_box'),
  stackBox('stack_box');

  const SchemaStyler(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaDecoration {
  box('box_decoration'),
  shape('shape_decoration');

  const SchemaDecoration(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaGradient {
  linear('linear_gradient'),
  radial('radial_gradient'),
  sweep('sweep_gradient');

  const SchemaGradient(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaGradientTransform {
  rotation('gradient_rotation'),
  tailwindAngleRect('tailwind_css_angle_rect');

  const SchemaGradientTransform(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaBorder {
  border('border'),
  borderDirectional('border_directional');

  const SchemaBorder(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaBorderRadius {
  borderRadius('border_radius'),
  borderRadiusDirectional('border_radius_directional');

  const SchemaBorderRadius(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaShapeBorder {
  roundedRectangle('rounded_rectangle_border'),
  roundedSuperellipse('rounded_superellipse_border'),
  beveledRectangle('beveled_rectangle_border'),
  continuousRectangle('continuous_rectangle_border'),
  circle('circle_border'),
  star('star_border'),
  linear('linear_border'),
  stadium('stadium_border');

  const SchemaShapeBorder(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaTextScaler {
  linear('text_scaler_linear');

  const SchemaTextScaler(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaVariant {
  named('named'),
  widgetState('widget_state'),
  enabled('enabled'),
  brightness('context_brightness'),
  breakpoint('context_breakpoint'),
  notWidgetState('context_not_widget_state'),
  contextBuilder('context_variant_builder');

  const SchemaVariant(this.wireValue);

  final String wireValue;

  @override
  String toString() => wireValue;
}

enum SchemaModifier {
  reset('reset'),
  blur('blur'),
  opacity('opacity'),
  visibility('visibility'),
  align('align'),
  padding('padding'),
  scale('scale'),
  rotate('rotate'),
  defaultTextStyle('default_text_style');

  const SchemaModifier(this.wireValue);

  final String wireValue;

  static final Map<String, SchemaModifier> _byWireValue = {
    for (final value in values) value.wireValue: value,
  };

  static SchemaModifier? fromWireValue(String wireValue) {
    return _byWireValue[wireValue];
  }

  @override
  String toString() => wireValue;
}
