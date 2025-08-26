import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/wrapped_widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../properties/container/container_mix.dart';
import '../../properties/container/container_spec.dart';
import '../../properties/layout/stack_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
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
    with Diagnosticable, StyleVariantMixin<StackBoxStyle, ZBoxSpec> {
  final Prop<ContainerSpec>? $box;
  final Prop<StackSpec>? $stack;

  StackBoxStyle({
    ContainerMix? box,
    StackMix? stack,
    super.modifier,
    super.animation,
    super.variants,
    super.inherit,
  }) : $box = Prop.maybeMix(box),
       $stack = Prop.maybeMix(stack);

  const StackBoxStyle.create({
    Prop<ContainerSpec>? box,
    Prop<StackSpec>? stack,
    super.modifier,
    super.animation,
    super.variants,

    super.inherit,
  }) : $box = box,
       $stack = stack;

  /// Factory for box properties (ContainerMix), parameter kept as `box` for API consistency
  factory StackBoxStyle.box(ContainerMix value) => StackBoxStyle(box: value);

  /// Factory for stack properties
  factory StackBoxStyle.stack(StackMix value) => StackBoxStyle(stack: value);

  /// Factory for animation
  factory StackBoxStyle.animate(AnimationConfig animation) {
    return StackBoxStyle(animation: animation);
  }

  /// Factory for variant
  factory StackBoxStyle.variant(Variant variant, StackBoxStyle value) {
    return StackBoxStyle(variants: [VariantStyle(variant, value)]);
  }

  /// Constructor that accepts a [ZBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxSpec] instances to [StackBoxStyle].
  ///
  /// ```dart
  /// const spec = ZBoxSpec(box: ContainerSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxStyle.value(spec);
  /// ```
  static StackBoxStyle value(ZBoxSpec spec) {
    return StackBoxStyle.create(
      box: Prop.maybe(spec.box),
      stack: Prop.value(spec.stack),
    );
  }

  /// Constructor that accepts a nullable [ZBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackBoxStyle.value].
  ///
  /// ```dart
  /// const ZBoxSpec? spec = ZBoxSpec(box: ContainerSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxStyle.maybeValue(spec); // Returns StackBoxStyle or null
  /// ```
  static StackBoxStyle? maybeValue(ZBoxSpec? spec) {
    return spec != null ? StackBoxStyle.value(spec) : null;
  }

  /// Sets box properties (ContainerMix)
  StackBoxStyle box(ContainerMix value) {
    return merge(StackBoxStyle.box(value));
  }

  /// Sets stack properties
  StackBoxStyle stack(StackMix value) {
    return merge(StackBoxStyle.stack(value));
  }

  /// Sets animation
  StackBoxStyle animate(AnimationConfig animation) {
    return merge(StackBoxStyle.animate(animation));
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

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final zBoxSpec = StackBoxStyle(...).resolve(context);
  /// ```
  @override
  WrappedWidgetSpec<ZBoxSpec> resolve(BuildContext context) {
    final containerSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    final zBoxSpec = ZBoxSpec(box: containerSpec, stack: stackSpec);

    return WrappedWidgetSpec(
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
  /// Utility for defining [StackBoxStyle.box] (ContainerMix)
  final box = ContainerMix();

  /// Utility for defining [StackBoxStyle.stack]
  final stack = StackMix();

  StackBoxSpecUtility();

  static StackBoxSpecUtility get self => StackBoxSpecUtility();

  /// Returns a new [StackBoxStyle] with the specified properties.
  StackBoxStyle only({
    ContainerMix? box,
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
