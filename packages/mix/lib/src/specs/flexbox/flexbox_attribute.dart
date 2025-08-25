import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/flex_properties.dart';
import '../../properties/flex_properties_mix.dart';
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
import '../container/container_attribute.dart';
import '../container/container_spec.dart';
import 'flexbox_spec.dart';

typedef FlexBoxMix = FlexBoxStyle;

/// Represents the attributes of a [FlexBoxWidgetSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxWidgetSpec].
///
/// Use this class to configure the attributes of a [FlexBoxWidgetSpec] and pass it to
/// the [FlexBoxWidgetSpec] constructor.
class FlexBoxStyle extends Style<FlexBoxWidgetSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexBoxStyle, FlexBoxWidgetSpec>,
        StyleVariantMixin<FlexBoxStyle, FlexBoxWidgetSpec>,
        BorderRadiusMixin<FlexBoxStyle>,
        DecorationMixin<FlexBoxStyle>,
        SpacingMixin<FlexBoxStyle>,
        TransformMixin<FlexBoxStyle>,
        ConstraintsMixin<FlexBoxStyle> {
  final Prop<ContainerSpec>? $container;
  final Prop<FlexProperties>? $flex;

  FlexBoxStyle({
    ContainerSpecMix? container,
    FlexPropertiesMix? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $container = Prop.maybeMix(container),
       $flex = Prop.maybeMix(flex);

  const FlexBoxStyle.create({
    Prop<ContainerSpec>? container,
    Prop<FlexProperties>? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $container = container,
       $flex = flex;

  /// Factory for container properties
  factory FlexBoxStyle.container(ContainerSpecMix value) {
    return FlexBoxStyle(container: value);
  }

  /// Factory for flex properties
  factory FlexBoxStyle.flex(FlexPropertiesMix value) {
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

  // ContainerSpecMix factory methods
  /// Color factory
  factory FlexBoxStyle.color(Color value) {
    return FlexBoxStyle(container: ContainerSpecMix.color(value));
  }

  factory FlexBoxStyle.foregroundDecoration(DecorationMix value) {
    return FlexBoxStyle(
      container: ContainerSpecMix.foregroundDecoration(value),
    );
  }

  factory FlexBoxStyle.decoration(DecorationMix value) {
    return FlexBoxStyle(container: ContainerSpecMix.decoration(value));
  }

  factory FlexBoxStyle.alignment(AlignmentGeometry value) {
    return FlexBoxStyle(container: ContainerSpecMix.alignment(value));
  }

  factory FlexBoxStyle.padding(EdgeInsetsGeometryMix value) {
    return FlexBoxStyle(container: ContainerSpecMix.padding(value));
  }

  factory FlexBoxStyle.margin(EdgeInsetsGeometryMix value) {
    return FlexBoxStyle(container: ContainerSpecMix.margin(value));
  }

  factory FlexBoxStyle.transform(Matrix4 value) {
    return FlexBoxStyle(container: ContainerSpecMix.transform(value));
  }

  factory FlexBoxStyle.transformAlignment(AlignmentGeometry value) {
    return FlexBoxStyle(container: ContainerSpecMix.transformAlignment(value));
  }

  factory FlexBoxStyle.clipBehavior(Clip value) {
    return FlexBoxStyle(container: ContainerSpecMix.clipBehavior(value));
  }

  /// constraints
  factory FlexBoxStyle.constraints(BoxConstraintsMix value) {
    return FlexBoxStyle(container: ContainerSpecMix.constraints(value));
  }

  // FlexPropertiesMix factory methods
  /// Factory for flex direction
  factory FlexBoxStyle.direction(Axis value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(direction: value));
  }

  /// Factory for main axis alignment
  factory FlexBoxStyle.mainAxisAlignment(MainAxisAlignment value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(mainAxisAlignment: value));
  }

  /// Factory for cross axis alignment
  factory FlexBoxStyle.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(crossAxisAlignment: value));
  }

  /// Factory for main axis size
  factory FlexBoxStyle.mainAxisSize(MainAxisSize value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(mainAxisSize: value));
  }

  /// Factory for vertical direction
  factory FlexBoxStyle.verticalDirection(VerticalDirection value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(verticalDirection: value));
  }

  /// Factory for text direction
  factory FlexBoxStyle.textDirection(TextDirection value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(textDirection: value));
  }

  /// Factory for text baseline
  factory FlexBoxStyle.textBaseline(TextBaseline value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(textBaseline: value));
  }

  /// Factory for spacing
  factory FlexBoxStyle.spacing(double value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(spacing: value));
  }

  /// Factory for gap
  @Deprecated(
    'Use FlexBoxMix.spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  factory FlexBoxStyle.gap(double value) {
    return FlexBoxStyle(flex: FlexPropertiesMix(spacing: value));
  }

  /// Constructor that accepts a [FlexBoxWidgetSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxWidgetSpec] instances to [FlexBoxStyle].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(container: ContainerSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxMix.value(spec);
  /// ```
  static FlexBoxStyle value(FlexBoxWidgetSpec spec) {
    return FlexBoxStyle(
      container: ContainerSpecMix.maybeValue(spec.container),
      flex: FlexPropertiesMix.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxWidgetSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxStyle.value].
  ///
  /// ```dart
  /// const FlexBoxSpec? spec = FlexBoxSpec(container: ContainerSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxMix.maybeValue(spec); // Returns FlexBoxMix or null
  /// ```
  static FlexBoxStyle? maybeValue(FlexBoxWidgetSpec? spec) {
    return spec != null ? FlexBoxStyle.value(spec) : null;
  }

  /// Sets container properties
  FlexBoxStyle container(ContainerSpecMix value) {
    return merge(FlexBoxStyle.container(value));
  }

  /// Sets flex properties
  FlexBoxStyle flex(FlexPropertiesMix value) {
    return merge(FlexBoxStyle.flex(value));
  }

  /// Sets animation
  FlexBoxStyle animate(AnimationConfig animation) {
    return merge(FlexBoxStyle.animate(animation));
  }

  // ContainerSpecMix instance methods

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

  // FlexPropertiesMix instance methods
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

  /// Decoration instance method - delegates to container
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
  FlexBoxStyle variants(List<VariantStyle<FlexBoxWidgetSpec>> variants) {
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
      FlexBoxStyle(
        container: ContainerSpecMix(
          decoration: DecorationMix.borderRadius(value),
        ),
      ),
    );
  }

  /// Resolves to [FlexBoxWidgetSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxMix(...).resolve(context);
  /// ```
  @override
  FlexBoxWidgetSpec resolve(BuildContext context) {
    final containerSpec = MixOps.resolve(context, $container);
    final flexSpec = MixOps.resolve(context, $flex);

    return FlexBoxWidgetSpec(
      container: containerSpec,
      flex: flexSpec,
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
      container: MixOps.merge($container, other.$container),
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
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('flex', $flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxStyle] instances for equality.
  @override
  List<Object?> get props => [$container, $flex];
}
