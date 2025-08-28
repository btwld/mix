import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/layout/stack_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_mixin.dart';
import '../../properties/transform_mixin.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import '../box/box_mix.dart';
import '../box/box_spec.dart';
import 'stack_box_spec.dart';
import 'stack_spec.dart';

typedef StackBoxMix = StackBoxStyle;

/// Represents the attributes of a [ZBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxSpec].
///
/// Use this class to configure the attributes of a [ZBoxSpec] and pass it to
/// the [ZBoxSpec] constructor.
class StackBoxStyle extends Style<ZBoxSpec>
    with
        Diagnosticable,
        StyleVariantMixin<StackBoxStyle, ZBoxSpec>,
        BorderRadiusMixin<StackBoxStyle>,
        DecorationMixin<StackBoxStyle>,
        SpacingMixin<StackBoxStyle>,
        TransformMixin<StackBoxStyle>,
        ConstraintsMixin<StackBoxStyle> {
  final Prop<BoxSpec>? $box;
  final Prop<StackSpec>? $stack;

  StackBoxStyle({
    BoxMix? box,
    StackMix? stack,
    super.modifier,
    super.animation,
    super.variants,
    super.inherit,
  }) : $box = Prop.maybeMix(box),
       $stack = Prop.maybeMix(stack);

  const StackBoxStyle.create({
    Prop<BoxSpec>? box,
    Prop<StackSpec>? stack,
    super.modifier,
    super.animation,
    super.variants,

    super.inherit,
  }) : $box = box,
       $stack = stack;

  /// Named constructor that accepts a [ZBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxSpec] instances to [StackBoxStyle].
  ///
  /// ```dart
  /// const spec = ZBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxStyle.value(spec);
  /// ```
  StackBoxStyle.value(ZBoxSpec spec)
    : this.create(box: Prop.maybe(spec.box), stack: Prop.value(spec.stack));

  /// Constructor that accepts a nullable [ZBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackBoxStyle.value].
  ///
  /// ```dart
  /// const ZBoxSpec? spec = ZBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxStyle.maybeValue(spec); // Returns StackBoxStyle or null
  /// ```
  static StackBoxStyle? maybeValue(ZBoxSpec? spec) {
    return spec != null ? StackBoxStyle.value(spec) : null;
  }

  /// Sets animation
  StackBoxStyle animate(AnimationConfig animation) {
    return merge(StackBoxStyle(animation: animation));
  }

  StackBoxStyle modifier(ModifierConfig value) {
    return merge(StackBoxStyle(modifier: value));
  }

  @override
  StackBoxStyle variants(List<VariantStyle<ZBoxSpec>> variants) {
    return merge(StackBoxStyle(variants: variants));
  }

  @override
  StackBoxStyle variant(Variant variant, StackBoxStyle style) {
    return merge(StackBoxStyle(variants: [VariantStyle(variant, style)]));
  }

  // Mixin implementations - delegate to BoxMix

  /// Padding instance method - delegates to box
  @override
  StackBoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyle(box: BoxMix(padding: value)));
  }

  /// Margin instance method - delegates to box
  @override
  StackBoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyle(box: BoxMix(margin: value)));
  }

  /// Transform instance method - delegates to box
  @override
  StackBoxStyle transform(Matrix4 value) {
    return merge(StackBoxStyle(box: BoxMix(transform: value)));
  }

  /// Decoration instance method - delegates to box
  @override
  StackBoxStyle decoration(DecorationMix value) {
    return merge(StackBoxStyle(box: BoxMix(decoration: value)));
  }

  /// Constraints instance method - delegates to box
  @override
  StackBoxStyle constraints(BoxConstraintsMix value) {
    return merge(StackBoxStyle(box: BoxMix(constraints: value)));
  }

  /// Border radius instance method - delegates to box
  @override
  StackBoxStyle borderRadius(BorderRadiusGeometryMix value) {
    return merge(
      StackBoxStyle(box: BoxMix(decoration: DecorationMix.borderRadius(value))),
    );
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final zBoxSpec = StackBoxStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<ZBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    final zBoxSpec = ZBoxSpec(box: boxSpec, stack: stackSpec);

    return WidgetSpec(
      spec: zBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [StackBoxStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxStyle merge(StackBoxStyle? other) {
    if (other == null) return this;

    return StackBoxStyle.create(
      box: MixOps.merge($box, other.$box),
      stack: MixOps.merge($stack, other.$stack),
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      animation: other.$animation ?? $animation,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('stack', $stack));
  }

  /// The list of properties that constitute the state of this [StackBoxStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxStyle] instances for equality.
  @override
  List<Object?> get props => [$box, $stack];
}

/// Utility class for configuring [ZBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxSpec].
class StackBoxSpecUtility {
  /// Utility for defining [StackBoxStyle.box] (BoxMix)
  final box = BoxMix();

  /// Utility for defining [StackBoxStyle.stack]
  final stack = StackMix();

  StackBoxSpecUtility();

  static StackBoxSpecUtility get self => StackBoxSpecUtility();

  /// Returns a new [StackBoxStyle] with the specified properties.
  StackBoxStyle only({
    BoxMix? box,
    StackMix? stack,
    ModifierConfig? modifier,
    AnimationConfig? animation,
    List<VariantStyle<ZBoxSpec>>? variants,
  }) {
    return StackBoxStyle(
      box: box,
      stack: stack,
      modifier: modifier,
      animation: animation,
      variants: variants,
    );
  }
}
