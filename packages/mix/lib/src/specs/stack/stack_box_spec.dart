import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/spec.dart';
import '../../core/style.dart';
import '../box/box_attribute.dart';
import '../box/box_spec.dart';
import 'stack_attribute.dart';
import 'stack_spec.dart';

final class ZBoxSpec extends Spec<ZBoxSpec> with Diagnosticable {
  final BoxSpec box;
  final StackSpec stack;

  const ZBoxSpec({BoxSpec? box, StackSpec? stack})
    : box = box ?? const BoxSpec(),
      stack = stack ?? const StackSpec();

  /// Creates a copy of this [ZBoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  ZBoxSpec copyWith({BoxSpec? box, StackSpec? stack}) {
    return ZBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  /// Linearly interpolates between this [ZBoxSpec] and another [ZBoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ZBoxSpec] is returned. When [t] is 1.0, the [other] [ZBoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ZBoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ZBoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ZBoxSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [box].
  /// - [StackSpec.lerp] for [stack].
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ZBoxSpec] configurations.
  @override
  ZBoxSpec lerp(ZBoxSpec? other, double t) {
    if (other == null) return this;

    return ZBoxSpec(
      box: box.lerp(other.box, t),
      stack: stack.lerp(other.stack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('box', box, defaultValue: null));
    properties.add(DiagnosticsProperty('stack', stack, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [ZBoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ZBoxSpec] instances for equality.
  @override
  List<Object?> get props => [box, stack];
}

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
    super.modifiers,
    super.animation,
    super.variants,
  });

  /// Constructor that accepts a [ZBoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ZBoxSpec] instances to [StackBoxMix].
  ///
  /// ```dart
  /// const spec = StackBoxSpec(box: BoxSpec(...), stack: StackSpec(...));
  /// final attr = StackBoxSpecAttribute.value(spec);
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
  /// final attr = StackBoxSpecAttribute.maybeValue(spec); // Returns StackBoxSpecAttribute or null
  /// ```
  static StackBoxMix? maybeValue(ZBoxSpec? spec) {
    return spec != null ? StackBoxMix.value(spec) : null;
  }

  StackBoxMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(StackBoxMix(modifiers: modifiers));
  }

  StackBoxMix variants(List<VariantStyleAttribute<ZBoxSpec>> variants) {
    return merge(StackBoxMix(variants: variants));
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final stackBoxSpec = StackBoxSpecAttribute(...).resolve(context);
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
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      animation: other.$animation ?? $animation,
      variants: mergeVariantLists($variants, other.$variants),
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
    List<ModifierAttribute>? modifiers,
    AnimationConfig? animation,
    List<VariantStyleAttribute<ZBoxSpec>>? variants,
  }) {
    return StackBoxMix(
      box: box,
      stack: stack,
      modifiers: modifiers,
      animation: animation,
      variants: variants,
    );
  }
}
