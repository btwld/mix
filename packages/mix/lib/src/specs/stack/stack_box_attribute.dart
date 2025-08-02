import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/style.dart';
import '../../modifiers/widget_decorator_config.dart';
import '../../variants/variant.dart';
import '../box/box_attribute.dart';
import 'stack_attribute.dart';
import 'stack_box_spec.dart';

/// Represents the attributes of a [ZBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxSpec].
///
/// Use this class to configure the attributes of a [ZBoxSpec] and pass it to
/// the [ZBoxSpec] constructor.
class StackBoxMix extends Style<ZBoxSpec> with Diagnosticable {
  final BoxMix? box;
  final StackMix? stack;

  const StackBoxMix({
    this.box,
    this.stack,
    super.modifierConfig,
    super.animation,
    super.variants,

    super.inherit,
  });

  /// Factory for box properties
  factory StackBoxMix.box(BoxMix value) {
    return StackBoxMix(box: value);
  }

  /// Factory for stack properties
  factory StackBoxMix.stack(StackMix value) {
    return StackBoxMix(stack: value);
  }

  /// Factory for animation
  factory StackBoxMix.animate(AnimationConfig animation) {
    return StackBoxMix(animation: animation);
  }

  /// Factory for variant
  factory StackBoxMix.variant(Variant variant, StackBoxMix value) {
    return StackBoxMix(variants: [VariantStyle(variant, value)]);
  }

  /// Constructor that accepts a [ZBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxSpec] instances to [StackBoxMix].
  ///
  /// ```dart
  /// const spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxMix.value(spec);
  /// ```
  static StackBoxMix value(ZBoxSpec spec) {
    return StackBoxMix(
      box: BoxMix.maybeValue(spec.box),
      stack: StackMix.maybeValue(spec.stack),
    );
  }

  /// Constructor that accepts a nullable [ZBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackBoxMix.value].
  ///
  /// ```dart
  /// const StackBoxSpec? spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxMix.maybeValue(spec); // Returns StackBoxMix or null
  /// ```
  static StackBoxMix? maybeValue(ZBoxSpec? spec) {
    return spec != null ? StackBoxMix.value(spec) : null;
  }

  /// Sets box properties
  StackBoxMix withBox(BoxMix value) {
    return merge(StackBoxMix.box(value));
  }

  /// Sets stack properties
  StackBoxMix withStack(StackMix value) {
    return merge(StackBoxMix.stack(value));
  }

  /// Sets animation
  StackBoxMix animate(AnimationConfig animation) {
    return merge(StackBoxMix.animate(animation));
  }

  StackBoxMix modifier(WidgetDecoratorConfig value) {
    return merge(StackBoxMix(modifierConfig: value));
  }

  StackBoxMix variants(List<VariantStyle<ZBoxSpec>> variants) {
    return merge(StackBoxMix(variants: variants));
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final stackBoxSpec = StackBoxMix(...).resolve(context);
  /// ```
  @override
  ZBoxSpec resolve(BuildContext context) {
    return ZBoxSpec(box: box?.resolve(context), stack: stack?.resolve(context));
  }

  /// Merges the properties of this [StackBoxMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxMix merge(StackBoxMix? other) {
    if (other == null) return this;

    return StackBoxMix(
      box: box?.merge(other.box) ?? other.box,
      stack: stack?.merge(other.stack) ?? other.stack,
      modifierConfig: $widgetDecoratorConfig.tryMerge(
        other.$widgetDecoratorConfig,
      ),
      animation: other.$animation ?? $animation,
      variants: mergeVariantLists($variants, other.$variants),

      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('stack', stack, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [StackBoxMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxMix] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}

/// Utility class for configuring [ZBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxSpec].
class StackBoxSpecUtility {
  /// Utility for defining [StackBoxMix.box]
  final box = BoxMix();

  /// Utility for defining [StackBoxMix.stack]
  final stack = StackMix();

  StackBoxSpecUtility();

  static StackBoxSpecUtility get self => StackBoxSpecUtility();

  /// Returns a new [StackBoxMix] with the specified properties.
  StackBoxMix only({
    BoxMix? box,
    StackMix? stack,
    WidgetDecoratorConfig? modifierConfig,
    AnimationConfig? animation,
    List<VariantStyle<ZBoxSpec>>? variants,
  }) {
    return StackBoxMix(
      box: box,
      stack: stack,
      modifierConfig: modifierConfig,
      animation: animation,
      variants: variants,
    );
  }
}
