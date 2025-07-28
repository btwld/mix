import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'stack_spec.dart';

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackSpecAttribute extends StyleAttribute<StackSpec>
    with
        Diagnosticable,
        ModifierMixin<StackSpecAttribute, StackSpec>,
        VariantMixin<StackSpecAttribute, StackSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;

  /// Utility for defining [StackSpecAttribute.alignment]
  late final alignment = PropUtility<StackSpecAttribute, AlignmentGeometry>(
    (prop) => merge(StackSpecAttribute.raw(alignment: prop)),
  );

  /// Utility for defining [StackSpecAttribute.fit]
  late final fit = PropUtility<StackSpecAttribute, StackFit>(
    (prop) => merge(StackSpecAttribute.raw(fit: prop)),
  );

  /// Utility for defining [StackSpecAttribute.textDirection]
  late final textDirection = PropUtility<StackSpecAttribute, TextDirection>(
    (prop) => merge(StackSpecAttribute.raw(textDirection: prop)),
  );

  /// Utility for defining [StackSpecAttribute.clipBehavior]
  late final clipBehavior = PropUtility<StackSpecAttribute, Clip>(
    (prop) => merge(StackSpecAttribute.raw(clipBehavior: prop)),
  );

  StackSpecAttribute.raw({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  StackSpecAttribute({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<StackSpec>>? variants,
  }) : this.raw(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts a [StackSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [StackSpec] instances to [StackSpecAttribute].
  ///
  /// ```dart
  /// const spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackSpecAttribute.value(spec);
  /// ```
  StackSpecAttribute.value(StackSpec spec)
    : this(
        alignment: spec.alignment,
        fit: spec.fit,
        textDirection: spec.textDirection,
        clipBehavior: spec.clipBehavior,
      );

  /// Constructor that accepts a nullable [StackSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackSpecAttribute.value].
  ///
  /// ```dart
  /// const StackSpec? spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackSpecAttribute.maybeValue(spec); // Returns StackSpecAttribute or null
  /// ```
  static StackSpecAttribute? maybeValue(StackSpec? spec) {
    return spec != null ? StackSpecAttribute.value(spec) : null;
  }

  /// Convenience method for animating the StackSpec
  StackSpecAttribute animate(AnimationConfig animation) {
    return StackSpecAttribute(animation: animation);
  }

  StackSpecAttribute variants(List<VariantStyleAttribute<StackSpec>> variants) {
    return merge(StackSpecAttribute(variants: variants));
  }

  @override
  StackSpecAttribute modifiers(List<ModifierAttribute> modifiers) {
    return merge(StackSpecAttribute(modifiers: modifiers));
  }

  /// Resolves to [StackSpec] using the provided [MixContext].
  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixHelpers.resolve(context, $alignment),
      fit: MixHelpers.resolve(context, $fit),
      textDirection: MixHelpers.resolve(context, $textDirection),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [StackSpecAttribute] with the properties of [other].
  @override
  StackSpecAttribute merge(StackSpecAttribute? other) {
    if (other == null) return this;

    return StackSpecAttribute.raw(
      alignment: MixHelpers.merge($alignment, other.$alignment),
      fit: MixHelpers.merge($fit, other.$fit),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('fit', $fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', $clipBehavior, defaultValue: null),
    );
  }

  @override
  StackSpecAttribute variant(Variant variant, StackSpecAttribute style) {
    return merge(
      StackSpecAttribute(variants: [VariantStyleAttribute(variant, style)]),
    );
  }

  @override
  List<Object?> get props => [
    $alignment,
    $fit,
    $textDirection,
    $clipBehavior,
    $animation,
    $modifiers,
    $variants,
  ];
}
