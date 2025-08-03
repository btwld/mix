import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/style.dart';
import '../../decorators/widget_decorator_config.dart';
import '../../decorators/widget_decorator_util.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_image_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import '../box/box_attribute.dart';
import '../flex/flex_attribute.dart';
import 'flexbox_spec.dart';

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxMix extends Style<FlexBoxSpec>
    with
        Diagnosticable,
        StyleWidgetDecoratorMixin<FlexBoxMix, FlexBoxSpec>,
        StyleVariantMixin<FlexBoxMix, FlexBoxSpec>,
        BorderRadiusMixin<FlexBoxMix> {
  final BoxMix? $box;
  final FlexMix? $flex;

  const FlexBoxMix({
    BoxMix? box,
    FlexMix? flex,
    super.animation,
    super.widgetDecoratorConfig,
    super.variants,

    super.inherit,
  }) : $box = box,
       $flex = flex;

  /// Factory for box properties
  factory FlexBoxMix.box(BoxMix value) {
    return FlexBoxMix(box: value);
  }

  /// Factory for flex properties
  factory FlexBoxMix.flex(FlexMix value) {
    return FlexBoxMix(flex: value);
  }

  /// Factory for animation
  factory FlexBoxMix.animate(AnimationConfig animation) {
    return FlexBoxMix(animation: animation);
  }

  /// Factory for variant
  factory FlexBoxMix.variant(Variant variant, FlexBoxMix value) {
    return FlexBoxMix(variants: [VariantStyle(variant, value)]);
  }

  // BoxMix factory methods
  /// Color factory
  factory FlexBoxMix.color(Color value) {
    return FlexBoxMix(box: BoxMix.color(value));
  }

  /// Gradient factory
  factory FlexBoxMix.gradient(GradientMix value) {
    return FlexBoxMix(box: BoxMix.gradient(value));
  }

  /// Shape factory
  factory FlexBoxMix.shape(BoxShape value) {
    return FlexBoxMix(box: BoxMix.shape(value));
  }

  factory FlexBoxMix.height(double value) {
    return FlexBoxMix(box: BoxMix.height(value));
  }

  factory FlexBoxMix.width(double value) {
    return FlexBoxMix(box: BoxMix.width(value));
  }

  /// constraints
  factory FlexBoxMix.constraints(BoxConstraintsMix value) {
    return FlexBoxMix(box: BoxMix.constraints(value));
  }

  /// minWidth
  factory FlexBoxMix.minWidth(double value) {
    return FlexBoxMix(box: BoxMix.minWidth(value));
  }

  /// maxWidth
  factory FlexBoxMix.maxWidth(double value) {
    return FlexBoxMix(box: BoxMix.maxWidth(value));
  }

  /// minHeight
  factory FlexBoxMix.minHeight(double value) {
    return FlexBoxMix(box: BoxMix.minHeight(value));
  }

  /// maxHeight
  factory FlexBoxMix.maxHeight(double value) {
    return FlexBoxMix(box: BoxMix.maxHeight(value));
  }

  factory FlexBoxMix.foregroundDecoration(DecorationMix value) {
    return FlexBoxMix(box: BoxMix.foregroundDecoration(value));
  }

  factory FlexBoxMix.decoration(DecorationMix value) {
    return FlexBoxMix(box: BoxMix.decoration(value));
  }

  factory FlexBoxMix.alignment(AlignmentGeometry value) {
    return FlexBoxMix(box: BoxMix.alignment(value));
  }

  factory FlexBoxMix.padding(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(box: BoxMix.padding(value));
  }

  factory FlexBoxMix.margin(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(box: BoxMix.margin(value));
  }

  factory FlexBoxMix.transform(Matrix4 value) {
    return FlexBoxMix(box: BoxMix.transform(value));
  }

  factory FlexBoxMix.transformAlignment(AlignmentGeometry value) {
    return FlexBoxMix(box: BoxMix.transformAlignment(value));
  }

  factory FlexBoxMix.clipBehavior(Clip value) {
    return FlexBoxMix(box: BoxMix.clipBehavior(value));
  }

  /// border
  factory FlexBoxMix.border(BoxBorderMix value) {
    return FlexBoxMix(box: BoxMix.border(value));
  }

  /// Border radius
  factory FlexBoxMix.borderRadius(BorderRadiusGeometryMix value) {
    return FlexBoxMix(box: BoxMix.borderRadius(value));
  }

  // FlexMix factory methods
  /// Factory for flex direction
  factory FlexBoxMix.direction(Axis value) {
    return FlexBoxMix(flex: FlexMix.direction(value));
  }

  /// Factory for main axis alignment
  factory FlexBoxMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexBoxMix(flex: FlexMix.mainAxisAlignment(value));
  }

  /// Factory for cross axis alignment
  factory FlexBoxMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexBoxMix(flex: FlexMix.crossAxisAlignment(value));
  }

  /// Factory for main axis size
  factory FlexBoxMix.mainAxisSize(MainAxisSize value) {
    return FlexBoxMix(flex: FlexMix.mainAxisSize(value));
  }

  /// Factory for vertical direction
  factory FlexBoxMix.verticalDirection(VerticalDirection value) {
    return FlexBoxMix(flex: FlexMix.verticalDirection(value));
  }

  /// Factory for text direction
  factory FlexBoxMix.textDirection(TextDirection value) {
    return FlexBoxMix(flex: FlexMix.textDirection(value));
  }

  /// Factory for text baseline
  factory FlexBoxMix.textBaseline(TextBaseline value) {
    return FlexBoxMix(flex: FlexMix.textBaseline(value));
  }

  /// Factory for gap
  factory FlexBoxMix.gap(double value) {
    return FlexBoxMix(flex: FlexMix.gap(value));
  }

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxMix].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxMix.value(spec);
  /// ```
  static FlexBoxMix value(FlexBoxSpec spec) {
    return FlexBoxMix(
      box: BoxMix.maybeValue(spec.box),
      flex: FlexMix.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxMix.value].
  ///
  /// ```dart
  /// const FlexBoxSpec? spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxMix.maybeValue(spec); // Returns FlexBoxMix or null
  /// ```
  static FlexBoxMix? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxMix.value(spec) : null;
  }

  /// Sets box properties
  FlexBoxMix box(BoxMix value) {
    return merge(FlexBoxMix.box(value));
  }

  /// Sets flex properties
  FlexBoxMix flex(FlexMix value) {
    return merge(FlexBoxMix.flex(value));
  }

  /// Sets animation
  FlexBoxMix animate(AnimationConfig animation) {
    return merge(FlexBoxMix.animate(animation));
  }

  // BoxMix instance methods
  /// Sets background color
  FlexBoxMix color(Color value) {
    return merge(FlexBoxMix.color(value));
  }

  /// Sets both min and max width to create a fixed width
  FlexBoxMix width(double value) {
    return merge(FlexBoxMix.width(value));
  }

  /// Sets both min and max height to create a fixed height
  FlexBoxMix height(double value) {
    return merge(FlexBoxMix.height(value));
  }

  /// Sets rotation transform
  FlexBoxMix rotate(double angle) {
    return merge(FlexBoxMix(box: BoxMix.transform(Matrix4.rotationZ(angle))));
  }

  /// Sets scale transform
  FlexBoxMix scale(double scale) {
    return merge(
      FlexBoxMix(
        box: BoxMix.transform(Matrix4.diagonal3Values(scale, scale, 1.0)),
      ),
    );
  }

  /// Sets translation transform
  FlexBoxMix translate(double x, double y, [double z = 0.0]) {
    return merge(
      FlexBoxMix(box: BoxMix.transform(Matrix4.translationValues(x, y, z))),
    );
  }

  /// Sets skew transform
  FlexBoxMix skew(double skewX, double skewY) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 1, skewX);
    matrix.setEntry(1, 0, skewY);

    return merge(FlexBoxMix(box: BoxMix.transform(matrix)));
  }

  /// Resets transform to identity (no effect)
  FlexBoxMix transformReset() {
    return merge(FlexBoxMix(box: BoxMix.transform(Matrix4.identity())));
  }

  /// Sets minimum width constraint
  FlexBoxMix minWidth(double value) {
    return merge(FlexBoxMix.minWidth(value));
  }

  /// Sets maximum width constraint
  FlexBoxMix maxWidth(double value) {
    return merge(FlexBoxMix.maxWidth(value));
  }

  /// Sets minimum height constraint
  FlexBoxMix minHeight(double value) {
    return merge(FlexBoxMix.minHeight(value));
  }

  /// Sets maximum height constraint
  FlexBoxMix maxHeight(double value) {
    return merge(FlexBoxMix.maxHeight(value));
  }

  /// Sets both width and height to specific values
  FlexBoxMix size(double width, double height) {
    return merge(FlexBoxMix(box: BoxMix().size(width, height)));
  }

  /// Sets box shape
  FlexBoxMix shape(BoxShape value) {
    return merge(FlexBoxMix(box: BoxMix.shape(value)));
  }

  FlexBoxMix alignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.alignment(value));
  }

  /// Sets single shadow
  FlexBoxMix shadow(BoxShadowMix value) {
    return merge(FlexBoxMix(box: BoxMix().shadow(value)));
  }

  /// Sets multiple shadows
  FlexBoxMix shadows(List<BoxShadowMix> value) {
    return merge(FlexBoxMix(box: BoxMix().shadows(value)));
  }

  /// Sets elevation shadow
  FlexBoxMix elevation(ElevationShadow value) {
    return merge(FlexBoxMix(box: BoxMix().elevation(value)));
  }

  /// Decorator instance method
  FlexBoxMix wrap(WidgetDecoratorConfig modifier) {
    return merge(FlexBoxMix(widgetDecoratorConfig: modifier));
  }

  /// Border instance method
  FlexBoxMix border(BoxBorderMix value) {
    return merge(FlexBoxMix.border(value));
  }

  /// Padding instance method
  FlexBoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.padding(value));
  }

  /// Margin instance method
  FlexBoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.margin(value));
  }

  FlexBoxMix transform(Matrix4 value) {
    return merge(FlexBoxMix.transform(value));
  }

  /// Decoration instance method
  FlexBoxMix decoration(DecorationMix value) {
    return merge(FlexBoxMix.decoration(value));
  }

  /// Foreground decoration instance method
  FlexBoxMix foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxMix.foregroundDecoration(value));
  }

  /// Constraints instance method
  FlexBoxMix constraints(BoxConstraintsMix value) {
    return merge(FlexBoxMix.constraints(value));
  }

  /// Sets gradient with any GradientMix type
  FlexBoxMix gradient(GradientMix value) {
    return merge(FlexBoxMix.gradient(value));
  }

  /// Sets image decoration
  FlexBoxMix image(DecorationImageMix value) {
    return merge(FlexBoxMix(box: BoxMix().image(value)));
  }

  FlexBoxMix transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.transformAlignment(value));
  }

  FlexBoxMix clipBehavior(Clip value) {
    return merge(FlexBoxMix.clipBehavior(value));
  }

  // FlexMix instance methods
  /// Sets flex direction
  FlexBoxMix direction(Axis value) {
    return merge(FlexBoxMix.direction(value));
  }

  /// Sets main axis alignment
  FlexBoxMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexBoxMix.mainAxisAlignment(value));
  }

  /// Sets cross axis alignment
  FlexBoxMix crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexBoxMix.crossAxisAlignment(value));
  }

  /// Sets main axis size
  FlexBoxMix mainAxisSize(MainAxisSize value) {
    return merge(FlexBoxMix.mainAxisSize(value));
  }

  /// Sets vertical direction
  FlexBoxMix verticalDirection(VerticalDirection value) {
    return merge(FlexBoxMix.verticalDirection(value));
  }

  /// Sets text direction
  FlexBoxMix textDirection(TextDirection value) {
    return merge(FlexBoxMix.textDirection(value));
  }

  /// Sets text baseline
  FlexBoxMix textBaseline(TextBaseline value) {
    return merge(FlexBoxMix.textBaseline(value));
  }

  /// Sets gap
  FlexBoxMix gap(double value) {
    return merge(FlexBoxMix.gap(value));
  }

  @override
  FlexBoxMix variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxMix(variants: variants));
  }

  @override
  FlexBoxMix variant(Variant variant, FlexBoxMix style) {
    return merge(FlexBoxMix(variants: [VariantStyle(variant, style)]));
  }

  /// Border radius instance method
  @override
  FlexBoxMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxMix.borderRadius(value));
  }

  /// Resolves to [FlexBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxMix(...).resolve(context);
  /// ```
  @override
  FlexBoxSpec resolve(BuildContext context) {
    return FlexBoxSpec(
      box: $box?.resolve(context),
      flex: $flex?.resolve(context),
    );
  }

  @override
  FlexBoxMix widgetDecorator(WidgetDecoratorConfig value) {
    return merge(FlexBoxMix(widgetDecoratorConfig: value));
  }

  /// Merges the properties of this [FlexBoxMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxMix merge(FlexBoxMix? other) {
    if (other == null) return this;

    return FlexBoxMix(
      box: $box?.merge(other.$box) ?? other.$box,
      flex: $flex?.merge(other.$flex) ?? other.$flex,
      animation: other.$animation ?? $animation,
      widgetDecoratorConfig: $widgetDecoratorConfig.tryMerge(
        other.$widgetDecoratorConfig,
      ),
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', $box, defaultValue: null));
    properties.add(DiagnosticsProperty('flex', $flex, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [FlexBoxMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxMix] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}
