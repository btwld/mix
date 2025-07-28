import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/spec.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_util.dart';
import '../box/box_attribute.dart';
import '../box/box_spec.dart';
import '../flex/flex_attribute.dart';
import '../flex/flex_spec.dart';

final class FlexBoxSpec extends Spec<FlexBoxSpec> with Diagnosticable {
  final BoxSpec box;
  final FlexSpec flex;

  const FlexBoxSpec({BoxSpec? box, FlexSpec? flex})
    : box = box ?? const BoxSpec(),
      flex = flex ?? const FlexSpec();

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
  }

  /// Creates a copy of this [FlexBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexBoxSpec copyWith({BoxSpec? box, FlexSpec? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
  }

  /// Linearly interpolates between this [FlexBoxSpec] and another [FlexBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexBoxSpec] is returned. When [t] is 1.0, the [other] [FlexBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [FlexSpec.lerp] for [flex].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexBoxSpec] configurations.
  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    if (other == null) return this;

    return FlexBoxSpec(
      box: box.lerp(other.box, t),
      flex: flex.lerp(other.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [FlexBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, flex];
}

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxSpecAttribute extends StyleAttribute<FlexBoxSpec>
    with Diagnosticable, ModifierMixin<FlexBoxSpecAttribute, FlexBoxSpec> {
  final BoxMix? $box;
  final FlexSpecAttribute? $flex;

  const FlexBoxSpecAttribute({
    BoxMix? box,
    FlexSpecAttribute? flex,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $box = box,
       $flex = flex;

  /// Constructor that accepts a [FlexBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexBoxSpec] instances to [FlexBoxSpecAttribute].
  ///
  /// ```dart
  /// const spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxSpecAttribute.value(spec);
  /// ```
  static FlexBoxSpecAttribute value(FlexBoxSpec spec) {
    return FlexBoxSpecAttribute(
      box: BoxMix.maybeValue(spec.box),
      flex: FlexSpecAttribute.maybeValue(spec.flex),
    );
  }

  /// Constructor that accepts a nullable [FlexBoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexBoxSpecAttribute.value].
  ///
  /// ```dart
  /// const FlexBoxSpec? spec = FlexBoxSpec(box: BoxSpec(...), flex: FlexSpec(...));
  /// final attr = FlexBoxSpecAttribute.maybeValue(spec); // Returns FlexBoxSpecAttribute or null
  /// ```
  static FlexBoxSpecAttribute? maybeValue(FlexBoxSpec? spec) {
    return spec != null ? FlexBoxSpecAttribute.value(spec) : null;
  }

  // Backward compatibility getters
  BoxMix? get box => $box;
  FlexSpecAttribute? get flex => $flex;

  FlexBoxSpecAttribute variants(
    List<VariantStyleAttribute<FlexBoxSpec>> variants,
  ) {
    return merge(FlexBoxSpecAttribute(variants: variants));
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
  FlexBoxSpecAttribute modifiers(List<ModifierAttribute> modifiers) {
    return merge(FlexBoxSpecAttribute(modifiers: modifiers));
  }

  /// Merges the properties of this [FlexBoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxSpecAttribute merge(FlexBoxSpecAttribute? other) {
    if (other == null) return this;

    return FlexBoxSpecAttribute(
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

  /// The list of properties that constitute the state of this [FlexBoxSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}
