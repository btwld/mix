import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
import '../../variants/variant.dart';
import '../box/box_attribute.dart';
import '../box/box_spec.dart';
import 'stack_attribute.dart';
import 'stack_box_spec.dart';
import 'stack_spec.dart';

typedef StackBoxMix = StackBoxStyle;

/// Represents the attributes of a [ZBoxWidgetSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxWidgetSpec].
///
/// Use this class to configure the attributes of a [ZBoxWidgetSpec] and pass it to
/// the [ZBoxWidgetSpec] constructor.
class StackBoxStyle extends Style<ZBoxWidgetSpec> with Diagnosticable {
  final Prop<BoxWidgetSpec>? $box;
  final Prop<StackWidgetSpec>? $stack;

  StackBoxStyle({
    BoxStyle? box,
    StackStyle? stack,
    super.modifier,
    super.animation,
    super.variants,

    super.inherit,
  }) : $box = Prop.maybeMix(box),
       $stack = Prop.maybeMix(stack);

  const StackBoxStyle.create({
    Prop<BoxWidgetSpec>? box,
    Prop<StackWidgetSpec>? stack,
    super.modifier,
    super.animation,
    super.variants,

    super.inherit,
  }) : $box = box,
       $stack = stack;

  /// Factory for box properties
  factory StackBoxStyle.box(BoxStyle value) {
    return StackBoxStyle(box: value);
  }

  /// Factory for stack properties
  factory StackBoxStyle.stack(StackStyle value) {
    return StackBoxStyle(stack: value);
  }

  /// Factory for animation
  factory StackBoxStyle.animate(AnimationConfig animation) {
    return StackBoxStyle(animation: animation);
  }

  /// Factory for variant
  factory StackBoxStyle.variant(Variant variant, StackBoxStyle value) {
    return StackBoxStyle(variants: [VariantStyle(variant, value)]);
  }

  /// Constructor that accepts a [ZBoxWidgetSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxWidgetSpec] instances to [StackBoxStyle].
  ///
  /// ```dart
  /// const spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxMix.value(spec);
  /// ```
  static StackBoxStyle value(ZBoxWidgetSpec spec) {
    return StackBoxStyle(
      box: BoxStyle.maybeValue(spec.box),
      stack: StackStyle.maybeValue(spec.stack),
    );
  }

  /// Constructor that accepts a nullable [ZBoxWidgetSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackBoxStyle.value].
  ///
  /// ```dart
  /// const StackBoxSpec? spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxMix.maybeValue(spec); // Returns StackBoxMix or null
  /// ```
  static StackBoxStyle? maybeValue(ZBoxWidgetSpec? spec) {
    return spec != null ? StackBoxStyle.value(spec) : null;
  }

  /// Sets box properties
  StackBoxStyle box(BoxStyle value) {
    return merge(StackBoxStyle.box(value));
  }

  /// Sets stack properties
  StackBoxStyle stack(StackStyle value) {
    return merge(StackBoxStyle.stack(value));
  }

  /// Sets animation
  StackBoxStyle animate(AnimationConfig animation) {
    return merge(StackBoxStyle.animate(animation));
  }

  StackBoxStyle modifier(ModifierConfig value) {
    return merge(StackBoxStyle(modifier: value));
  }

  StackBoxStyle variants(List<VariantStyle<ZBoxWidgetSpec>> variants) {
    return merge(StackBoxStyle(variants: variants));
  }

  /// Resolves to [ZBoxWidgetSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final ZBoxSpec = StackBoxMix(...).resolve(context);
  /// ```
  @override
  ZBoxWidgetSpec resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    return ZBoxWidgetSpec(
      box: boxSpec,
      stack: stackSpec,
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

/// Utility class for configuring [ZBoxWidgetSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxWidgetSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxWidgetSpec].
class StackBoxSpecUtility {
  /// Utility for defining [StackBoxStyle.box]
  final box = BoxStyle();

  /// Utility for defining [StackBoxStyle.stack]
  final stack = StackStyle();

  StackBoxSpecUtility();

  static StackBoxSpecUtility get self => StackBoxSpecUtility();

  /// Returns a new [StackBoxStyle] with the specified properties.
  StackBoxStyle only({
    BoxStyle? box,
    StackStyle? stack,
    ModifierConfig? modifier,
    AnimationConfig? animation,
    List<VariantStyle<ZBoxWidgetSpec>>? variants,
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
