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
        StyleModifierMixin<FlexBoxMix, FlexBoxSpec>,
        StyleVariantMixin<FlexBoxMix, FlexBoxSpec>,
        BorderRadiusMixin<FlexBoxMix>,
        DecorationMixin<FlexBoxMix>,
        SpacingMixin<FlexBoxMix>,
        TransformMixin<FlexBoxMix>,
        ConstraintsMixin<FlexBoxMix> {
  final Prop<ContainerSpec>? $container;
  final Prop<FlexProperties>? $flex;

  FlexBoxMix({
    ContainerSpecMix? container,
    FlexPropertiesMix? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $container = Prop.maybeMix(container),
       $flex = Prop.maybeMix(flex);

  const FlexBoxMix.create({
    Prop<ContainerSpec>? container,
    Prop<FlexProperties>? flex,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $container = container,
       $flex = flex;

  /// Factory for container properties
  factory FlexBoxMix.container(ContainerSpecMix value) {
    return FlexBoxMix(container: value);
  }

  /// Factory for flex properties
  factory FlexBoxMix.flex(FlexPropertiesMix value) {
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

  /// Factory for widget modifier
  factory FlexBoxMix.modifier(ModifierConfig modifier) {
    return FlexBoxMix(modifier: modifier);
  }

  /// Factory for widget modifier
  factory FlexBoxMix.wrap(ModifierConfig value) {
    return FlexBoxMix(modifier: value);
  }

  // ContainerSpecMix factory methods
  /// Color factory
  factory FlexBoxMix.color(Color value) {
    return FlexBoxMix(container: ContainerSpecMix.color(value));
  }

  factory FlexBoxMix.foregroundDecoration(DecorationMix value) {
    return FlexBoxMix(container: ContainerSpecMix.foregroundDecoration(value));
  }

  factory FlexBoxMix.decoration(DecorationMix value) {
    return FlexBoxMix(container: ContainerSpecMix.decoration(value));
  }

  factory FlexBoxMix.alignment(AlignmentGeometry value) {
    return FlexBoxMix(container: ContainerSpecMix.alignment(value));
  }

  factory FlexBoxMix.padding(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(container: ContainerSpecMix.padding(value));
  }

  factory FlexBoxMix.margin(EdgeInsetsGeometryMix value) {
    return FlexBoxMix(container: ContainerSpecMix.margin(value));
  }

  factory FlexBoxMix.transform(Matrix4 value) {
    return FlexBoxMix(container: ContainerSpecMix.transform(value));
  }

  factory FlexBoxMix.transformAlignment(AlignmentGeometry value) {
    return FlexBoxMix(container: ContainerSpecMix.transformAlignment(value));
  }

  factory FlexBoxMix.clipBehavior(Clip value) {
    return FlexBoxMix(container: ContainerSpecMix.clipBehavior(value));
  }

  /// constraints
  factory FlexBoxMix.constraints(BoxConstraintsMix value) {
    return FlexBoxMix(container: ContainerSpecMix.constraints(value));
  }

  // FlexPropertiesMix factory methods
  /// Factory for flex direction
  factory FlexBoxMix.direction(Axis value) {
    return FlexBoxMix(flex: FlexPropertiesMix(direction: value));
  }

  /// Factory for main axis alignment
  factory FlexBoxMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexBoxMix(flex: FlexPropertiesMix(mainAxisAlignment: value));
  }

  /// Factory for cross axis alignment
  factory FlexBoxMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexBoxMix(flex: FlexPropertiesMix(crossAxisAlignment: value));
  }

  /// Factory for main axis size
  factory FlexBoxMix.mainAxisSize(MainAxisSize value) {
    return FlexBoxMix(flex: FlexPropertiesMix(mainAxisSize: value));
  }

  /// Factory for vertical direction
  factory FlexBoxMix.verticalDirection(VerticalDirection value) {
    return FlexBoxMix(flex: FlexPropertiesMix(verticalDirection: value));
  }

  /// Factory for text direction
  factory FlexBoxMix.textDirection(TextDirection value) {
    return FlexBoxMix(flex: FlexPropertiesMix(textDirection: value));
  }

  /// Factory for text baseline
  factory FlexBoxMix.textBaseline(TextBaseline value) {
    return FlexBoxMix(flex: FlexPropertiesMix(textBaseline: value));
  }

  /// Factory for spacing
  factory FlexBoxMix.spacing(double value) {
    return FlexBoxMix(flex: FlexPropertiesMix(spacing: value));
  }

  /// Factory for gap
  @Deprecated(
    'Use FlexBoxMix.spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  factory FlexBoxMix.gap(double value) {
    return FlexBoxMix(flex: FlexPropertiesMix(spacing: value));
  }

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxMix].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(container: ContainerSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxMix.value(spec);
  /// ```
  static FlexBoxMix value(FlexBoxSpec spec) {
    return FlexBoxMix(
      container: ContainerSpecMix.maybeValue(spec.container),
      flex: FlexPropertiesMix.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxMix.value].
  ///
  /// ```dart
  /// const FlexBoxSpec? spec = FlexBoxSpec(container: ContainerSpec(...), flex: FlexProperties(...));
  /// final attr = FlexBoxMix.maybeValue(spec); // Returns FlexBoxMix or null
  /// ```
  static FlexBoxMix? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxMix.value(spec) : null;
  }

  /// Sets container properties
  FlexBoxMix container(ContainerSpecMix value) {
    return merge(FlexBoxMix.container(value));
  }

  /// Sets flex properties
  FlexBoxMix flex(FlexPropertiesMix value) {
    return merge(FlexBoxMix.flex(value));
  }

  /// Sets animation
  FlexBoxMix animate(AnimationConfig animation) {
    return merge(FlexBoxMix.animate(animation));
  }

  // ContainerSpecMix instance methods

  FlexBoxMix alignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.alignment(value));
  }

  /// Foreground decoration instance method
  FlexBoxMix foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxMix.foregroundDecoration(value));
  }

  FlexBoxMix transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxMix.transformAlignment(value));
  }

  FlexBoxMix clipBehavior(Clip value) {
    return merge(FlexBoxMix.clipBehavior(value));
  }

  // FlexPropertiesMix instance methods
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

  /// Sets spacing
  FlexBoxMix spacing(double value) {
    return merge(FlexBoxMix.spacing(value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxMix gap(double value) {
    return merge(FlexBoxMix.spacing(value));
  }

  FlexBoxMix modifier(ModifierConfig value) {
    return merge(FlexBoxMix(modifier: value));
  }

  /// Padding instance method
  @override
  FlexBoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.padding(value));
  }

  /// Margin instance method
  @override
  FlexBoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxMix.margin(value));
  }

  @override
  FlexBoxMix transform(Matrix4 value) {
    return merge(FlexBoxMix.transform(value));
  }

  /// Decoration instance method - delegates to container
  @override
  FlexBoxMix decoration(DecorationMix value) {
    return merge(FlexBoxMix.decoration(value));
  }

  /// Constraints instance method
  @override
  FlexBoxMix constraints(BoxConstraintsMix value) {
    return merge(FlexBoxMix.constraints(value));
  }

  /// Modifier instance method
  @override
  FlexBoxMix wrap(ModifierConfig value) {
    return modifier(value);
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
    return merge(
      FlexBoxMix(
        container: ContainerSpecMix(
          decoration: DecorationMix.borderRadius(value),
        ),
      ),
    );
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
    final containerSpec = MixOps.resolve(context, $container);
    final flexSpec = MixOps.resolve(context, $flex);

    return FlexBoxSpec(
      container: containerSpec,
      flex: flexSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
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

    return FlexBoxMix.create(
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

  /// The list of properties that constitute the state of this [FlexBoxMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxMix] instances for equality.
  @override
  List<Object?> get props => [$container, $flex];
}
