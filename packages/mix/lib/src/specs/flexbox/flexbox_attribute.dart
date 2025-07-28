import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
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
    with Diagnosticable, StyleModifierMixin<FlexBoxMix, FlexBoxSpec> {
  final BoxMix? $box;
  final FlexMix? $flex;

  const FlexBoxMix({
    BoxMix? box,
    FlexMix? flex,
    super.animation,
    super.modifiers,
    super.variants,
    super.orderOfModifiers,
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
    return FlexBoxMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxMix].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxSpecAttribute.value(spec);
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
  /// final attr = FlexBoxSpecAttribute.maybeValue(spec); // Returns FlexBoxSpecAttribute or null
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

  FlexBoxMix variants(List<VariantStyleAttribute<FlexBoxSpec>> variants) {
    return merge(FlexBoxMix(variants: variants));
  }

  /// Resolves to [FlexBoxSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexBoxSpec = FlexBoxSpecAttribute(...).resolveSpec(context);
  /// ```
  @override
  FlexBoxSpec resolve(BuildContext context) {
    return FlexBoxSpec(
      box: $box?.resolve(context),
      flex: $flex?.resolve(context),
    );
  }

  @override
  FlexBoxMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(FlexBoxMix(modifiers: modifiers));
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
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
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
