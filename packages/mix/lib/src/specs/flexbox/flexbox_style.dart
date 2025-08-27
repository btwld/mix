import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_mixin.dart';
import '../../properties/transform_mixin.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import '../box/box_mix.dart';
import '../box/box_spec.dart';
import '../flex/flex_mix.dart';
import '../flex/flex_spec.dart';
import 'flexbox_mix.dart';
import 'flexbox_spec.dart';

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxStyle extends Style<FlexBoxSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexBoxStyle, FlexBoxSpec>,
        StyleVariantMixin<FlexBoxStyle, FlexBoxSpec>,
        BorderRadiusMixin<FlexBoxStyle>,
        DecorationMixin<FlexBoxStyle>,
        SpacingMixin<FlexBoxStyle>,
        TransformMixin<FlexBoxStyle>,
        ConstraintsMixin<FlexBoxStyle> {
  final Prop<BoxSpec>? $box;
  final Prop<FlexSpec>? $flex;

  FlexBoxStyle({
    BoxMix? box,
    FlexMix? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $box = Prop.maybeMix(box),
       $flex = Prop.maybeMix(flex);

  const FlexBoxStyle.create({
    Prop<BoxSpec>? box,
    Prop<FlexSpec>? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $box = box,
       $flex = flex;

  /// Factory for box properties
  factory FlexBoxStyle.box(BoxMix value) {
    return FlexBoxStyle(box: value);
  }

  /// Factory for flex properties
  factory FlexBoxStyle.flex(FlexMix value) {
    return FlexBoxStyle(flex: value);
  }

  /// Factory for animation
  factory FlexBoxStyle.animate(AnimationConfig animation) {
    return FlexBoxStyle(animation: animation);
  }

  /// Factory for variant
  factory FlexBoxStyle.variant(Variant variant, FlexBoxStyle value) {
    return FlexBoxStyle(variants: [VariantStyle(variant, value)]);
  }

  /// Factory for widget modifier
  factory FlexBoxStyle.modifier(ModifierConfig modifier) {
    return FlexBoxStyle(modifier: modifier);
  }

  /// Factory for widget modifier
  factory FlexBoxStyle.wrap(ModifierConfig value) {
    return FlexBoxStyle(modifier: value);
  }

  // BoxMix factory methods
  /// Color factory
  factory FlexBoxStyle.color(Color value) {
    return FlexBoxStyle(box: BoxMix.color(value));
  }

  factory FlexBoxStyle.foregroundDecoration(DecorationMix value) {
    return FlexBoxStyle(box: BoxMix.foregroundDecoration(value));
  }

  factory FlexBoxStyle.decoration(DecorationMix value) {
    return FlexBoxStyle(box: BoxMix.decoration(value));
  }

  factory FlexBoxStyle.alignment(AlignmentGeometry value) {
    return FlexBoxStyle(box: BoxMix.alignment(value));
  }

  factory FlexBoxStyle.padding(EdgeInsetsGeometryMix value) {
    return FlexBoxStyle(box: BoxMix.padding(value));
  }

  factory FlexBoxStyle.margin(EdgeInsetsGeometryMix value) {
    return FlexBoxStyle(box: BoxMix.margin(value));
  }

  factory FlexBoxStyle.transform(Matrix4 value) {
    return FlexBoxStyle(box: BoxMix.transform(value));
  }

  factory FlexBoxStyle.transformAlignment(AlignmentGeometry value) {
    return FlexBoxStyle(box: BoxMix.transformAlignment(value));
  }

  factory FlexBoxStyle.clipBehavior(Clip value) {
    return FlexBoxStyle(box: BoxMix.clipBehavior(value));
  }

  /// constraints
  factory FlexBoxStyle.constraints(BoxConstraintsMix value) {
    return FlexBoxStyle(box: BoxMix.constraints(value));
  }

  // FlexMix factory methods
  /// Factory for flex direction
  factory FlexBoxStyle.direction(Axis value) {
    return FlexBoxStyle(flex: FlexMix(direction: value));
  }

  /// Factory for main axis alignment
  factory FlexBoxStyle.mainAxisAlignment(MainAxisAlignment value) {
    return FlexBoxStyle(flex: FlexMix(mainAxisAlignment: value));
  }

  /// Factory for cross axis alignment
  factory FlexBoxStyle.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexBoxStyle(flex: FlexMix(crossAxisAlignment: value));
  }

  /// Factory for main axis size
  factory FlexBoxStyle.mainAxisSize(MainAxisSize value) {
    return FlexBoxStyle(flex: FlexMix(mainAxisSize: value));
  }

  /// Factory for vertical direction
  factory FlexBoxStyle.verticalDirection(VerticalDirection value) {
    return FlexBoxStyle(flex: FlexMix(verticalDirection: value));
  }

  /// Factory for text direction
  factory FlexBoxStyle.textDirection(TextDirection value) {
    return FlexBoxStyle(flex: FlexMix(textDirection: value));
  }

  /// Factory for text baseline
  factory FlexBoxStyle.textBaseline(TextBaseline value) {
    return FlexBoxStyle(flex: FlexMix(textBaseline: value));
  }

  /// Factory for spacing
  factory FlexBoxStyle.spacing(double value) {
    return FlexBoxStyle(flex: FlexMix(spacing: value));
  }

  /// Factory for gap
  @Deprecated(
    'Use FlexBoxMix.spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  factory FlexBoxStyle.gap(double value) {
    return FlexBoxStyle(flex: FlexMix(spacing: value));
  }

  /// Factory constructor to create FlexBoxStyle from FlexBoxMix.
  static FlexBoxStyle from(FlexBoxMix mix) {
    return FlexBoxStyle(box: mix.box, flex: mix.flex);
  }

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxStyle].
  ///
  /// ```dart
  /// const spec = FlexBoxWidgetSpec(box: BoxSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxStyle.value(spec);
  /// ```
  static FlexBoxStyle value(FlexBoxSpec spec) {
    return FlexBoxStyle(
      box: BoxMix.maybeValue(spec.box),
      flex: FlexMix.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxStyle.value].
  ///
  /// ```dart
  /// const FlexBoxWidgetSpec? spec = FlexBoxWidgetSpec(box: BoxSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxStyle.maybeValue(spec); // Returns FlexBoxStyle or null
  /// ```
  static FlexBoxStyle? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxStyle.value(spec) : null;
  }

  /// Sets box properties
  FlexBoxStyle box(BoxMix value) {
    return merge(FlexBoxStyle.box(value));
  }

  /// Sets flex properties
  FlexBoxStyle flex(FlexMix value) {
    return merge(FlexBoxStyle.flex(value));
  }

  /// Sets animation
  FlexBoxStyle animate(AnimationConfig animation) {
    return merge(FlexBoxStyle.animate(animation));
  }

  // BoxMix instance methods

  FlexBoxStyle alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle.alignment(value));
  }

  /// Foreground decoration instance method
  FlexBoxStyle foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyle.foregroundDecoration(value));
  }

  FlexBoxStyle transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle.transformAlignment(value));
  }

  FlexBoxStyle clipBehavior(Clip value) {
    return merge(FlexBoxStyle.clipBehavior(value));
  }

  // FlexMix instance methods
  /// Sets flex direction
  FlexBoxStyle direction(Axis value) {
    return merge(FlexBoxStyle.direction(value));
  }

  /// Sets main axis alignment
  FlexBoxStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexBoxStyle.mainAxisAlignment(value));
  }

  /// Sets cross axis alignment
  FlexBoxStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexBoxStyle.crossAxisAlignment(value));
  }

  /// Sets main axis size
  FlexBoxStyle mainAxisSize(MainAxisSize value) {
    return merge(FlexBoxStyle.mainAxisSize(value));
  }

  /// Sets vertical direction
  FlexBoxStyle verticalDirection(VerticalDirection value) {
    return merge(FlexBoxStyle.verticalDirection(value));
  }

  /// Sets text direction
  FlexBoxStyle textDirection(TextDirection value) {
    return merge(FlexBoxStyle.textDirection(value));
  }

  /// Sets text baseline
  FlexBoxStyle textBaseline(TextBaseline value) {
    return merge(FlexBoxStyle.textBaseline(value));
  }

  /// Sets spacing
  FlexBoxStyle spacing(double value) {
    return merge(FlexBoxStyle.spacing(value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyle gap(double value) {
    return merge(FlexBoxStyle.spacing(value));
  }

  FlexBoxStyle modifier(ModifierConfig value) {
    return merge(FlexBoxStyle(modifier: value));
  }

  /// Padding instance method
  @override
  FlexBoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle.padding(value));
  }

  /// Margin instance method
  @override
  FlexBoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle.margin(value));
  }

  @override
  FlexBoxStyle transform(Matrix4 value) {
    return merge(FlexBoxStyle.transform(value));
  }

  /// Decoration instance method - delegates to box
  @override
  FlexBoxStyle decoration(DecorationMix value) {
    return merge(FlexBoxStyle.decoration(value));
  }

  /// Constraints instance method
  @override
  FlexBoxStyle constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyle.constraints(value));
  }

  /// Modifier instance method
  @override
  FlexBoxStyle wrap(ModifierConfig value) {
    return modifier(value);
  }

  @override
  FlexBoxStyle variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxStyle(variants: variants));
  }

  @override
  FlexBoxStyle variant(Variant variant, FlexBoxStyle style) {
    return merge(FlexBoxStyle(variants: [VariantStyle(variant, style)]));
  }

  /// Border radius instance method
  @override
  FlexBoxStyle borderRadius(BorderRadiusGeometryMix value) {
    return merge(
      FlexBoxStyle(box: BoxMix(decoration: DecorationMix.borderRadius(value))),
    );
  }

  /// Resolves to [FlexBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexBoxWidgetSpec = FlexBoxStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<FlexBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final flexSpec = MixOps.resolve(context, $flex);

    final flexBoxSpec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

    return WidgetSpec(
      spec: flexBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [FlexBoxStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxStyle merge(FlexBoxStyle? other) {
    if (other == null) return this;

    return FlexBoxStyle.create(
      box: MixOps.merge($box, other.$box),
      flex: MixOps.merge($flex, other.$flex),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('flex', $flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxStyle] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}
