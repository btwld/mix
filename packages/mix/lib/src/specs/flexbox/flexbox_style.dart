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
import '../../core/prop_source.dart';
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


  /// Factory constructor to create FlexBoxStyle from FlexBoxMix.
  static FlexBoxStyle from(FlexBoxMix mix) {
    final boxMixSource = mix.$box?.sources.whereType<MixSource<BoxSpec>>().firstOrNull;
    final flexMixSource = mix.$flex?.sources.whereType<MixSource<FlexSpec>>().firstOrNull;
    
    return FlexBoxStyle(
      box: boxMixSource?.mix as BoxMix?,
      flex: flexMixSource?.mix as FlexMix?,
    );
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
    return merge(FlexBoxStyle(box: value));
  }

  /// Sets flex properties
  FlexBoxStyle flex(FlexMix value) {
    return merge(FlexBoxStyle(flex: value));
  }

  /// Sets animation
  FlexBoxStyle animate(AnimationConfig animation) {
    return merge(FlexBoxStyle(animation: animation));
  }

  // BoxMix instance methods

  FlexBoxStyle alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle(box: BoxMix(alignment: value)));
  }

  /// Foreground decoration instance method
  FlexBoxStyle foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyle(box: BoxMix(foregroundDecoration: value)));
  }

  FlexBoxStyle transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle(box: BoxMix(transformAlignment: value)));
  }

  FlexBoxStyle clipBehavior(Clip value) {
    return merge(FlexBoxStyle(box: BoxMix(clipBehavior: value)));
  }

  // FlexMix instance methods
  /// Sets flex direction
  FlexBoxStyle direction(Axis value) {
    return merge(FlexBoxStyle(flex: FlexMix(direction: value)));
  }

  /// Sets main axis alignment
  FlexBoxStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexBoxStyle(flex: FlexMix(mainAxisAlignment: value)));
  }

  /// Sets cross axis alignment
  FlexBoxStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexBoxStyle(flex: FlexMix(crossAxisAlignment: value)));
  }

  /// Sets main axis size
  FlexBoxStyle mainAxisSize(MainAxisSize value) {
    return merge(FlexBoxStyle(flex: FlexMix(mainAxisSize: value)));
  }

  /// Sets vertical direction
  FlexBoxStyle verticalDirection(VerticalDirection value) {
    return merge(FlexBoxStyle(flex: FlexMix(verticalDirection: value)));
  }

  /// Sets text direction
  FlexBoxStyle textDirection(TextDirection value) {
    return merge(FlexBoxStyle(flex: FlexMix(textDirection: value)));
  }

  /// Sets text baseline
  FlexBoxStyle textBaseline(TextBaseline value) {
    return merge(FlexBoxStyle(flex: FlexMix(textBaseline: value)));
  }

  /// Sets spacing
  FlexBoxStyle spacing(double value) {
    return merge(FlexBoxStyle(flex: FlexMix(spacing: value)));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyle gap(double value) {
    return merge(FlexBoxStyle(flex: FlexMix(spacing: value)));
  }

  FlexBoxStyle modifier(ModifierConfig value) {
    return merge(FlexBoxStyle(modifier: value));
  }

  /// Padding instance method
  @override
  FlexBoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle(box: BoxMix(padding: value)));
  }

  /// Margin instance method
  @override
  FlexBoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle(box: BoxMix(margin: value)));
  }

  @override
  FlexBoxStyle transform(Matrix4 value) {
    return merge(FlexBoxStyle(box: BoxMix(transform: value)));
  }

  /// Decoration instance method - delegates to box
  @override
  FlexBoxStyle decoration(DecorationMix value) {
    return merge(FlexBoxStyle(box: BoxMix(decoration: value)));
  }

  /// Constraints instance method
  @override
  FlexBoxStyle constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyle(box: BoxMix(constraints: value)));
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
