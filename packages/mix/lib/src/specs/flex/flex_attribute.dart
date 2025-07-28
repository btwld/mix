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
import 'flex_spec.dart';

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
class FlexMix extends Style<FlexSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexMix, FlexSpec>,
        StyleVariantMixin<FlexMix, FlexSpec> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $gap;

  /// Utility for defining [FlexMix.direction]
  late final direction = PropUtility<FlexMix, Axis>(
    (prop) => merge(FlexMix.raw(direction: prop)),
  );

  /// Utility for defining [FlexMix.mainAxisAlignment]
  late final mainAxisAlignment = PropUtility<FlexMix, MainAxisAlignment>(
    (prop) => merge(FlexMix.raw(mainAxisAlignment: prop)),
  );

  /// Utility for defining [FlexMix.crossAxisAlignment]
  late final crossAxisAlignment = PropUtility<FlexMix, CrossAxisAlignment>(
    (prop) => merge(FlexMix.raw(crossAxisAlignment: prop)),
  );

  /// Utility for defining [FlexMix.mainAxisSize]
  late final mainAxisSize = PropUtility<FlexMix, MainAxisSize>(
    (prop) => merge(FlexMix.raw(mainAxisSize: prop)),
  );

  /// Utility for defining [FlexMix.verticalDirection]
  late final verticalDirection = PropUtility<FlexMix, VerticalDirection>(
    (prop) => merge(FlexMix.raw(verticalDirection: prop)),
  );

  /// Utility for defining [FlexMix.textDirection]
  late final textDirection = PropUtility<FlexMix, TextDirection>(
    (prop) => merge(FlexMix.raw(textDirection: prop)),
  );

  /// Utility for defining [FlexMix.textBaseline]
  late final textBaseline = PropUtility<FlexMix, TextBaseline>(
    (prop) => merge(FlexMix.raw(textBaseline: prop)),
  );

  /// Utility for defining [FlexMix.clipBehavior]
  late final clipBehavior = PropUtility<FlexMix, Clip>(
    (prop) => merge(FlexMix.raw(clipBehavior: prop)),
  );

  /// Utility for defining [FlexMix.gap]
  late final gap = PropUtility<FlexMix, double>(
    (prop) => merge(FlexMix.raw(gap: prop)),
  );

  FlexMix.raw({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? gap,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $clipBehavior = clipBehavior,
       $gap = gap;

  FlexMix({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? gap,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<FlexSpec>>? variants,
  }) : this.raw(
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         clipBehavior: Prop.maybe(clipBehavior),
         gap: Prop.maybe(gap),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts a [FlexSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexSpec] instances to [FlexMix].
  ///
  /// ```dart
  /// const spec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
  /// final attr = FlexSpecAttribute.value(spec);
  /// ```
  FlexMix.value(FlexSpec spec)
    : this(
        direction: spec.direction,
        mainAxisAlignment: spec.mainAxisAlignment,
        crossAxisAlignment: spec.crossAxisAlignment,
        mainAxisSize: spec.mainAxisSize,
        verticalDirection: spec.verticalDirection,
        textDirection: spec.textDirection,
        textBaseline: spec.textBaseline,
        clipBehavior: spec.clipBehavior,
        gap: spec.gap,
      );

  /// Constructor that accepts a nullable [FlexSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexSpecAttribute.value].
  ///
  /// ```dart
  /// const FlexSpec? spec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
  /// final attr = FlexSpecAttribute.maybeValue(spec); // Returns FlexSpecAttribute or null
  /// ```
  static FlexMix? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexMix.value(spec) : null;
  }

  /// Convenience method for setting direction to horizontal (row)
  FlexMix row() => FlexMix(direction: Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  FlexMix column() => FlexMix(direction: Axis.vertical);

  /// Convenience method for animating the FlexSpec
  FlexMix animate(AnimationConfig animation) {
    return FlexMix(animation: animation);
  }

  @override
  FlexMix variants(List<VariantStyleAttribute<FlexSpec>> variants) {
    return merge(FlexMix(variants: variants));
  }

  @override
  FlexMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(FlexMix(modifiers: modifiers));
  }

  /// Resolves to [FlexSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexSpec = FlexSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexSpec resolve(BuildContext context) {
    return FlexSpec(
      direction: MixHelpers.resolve(context, $direction),
      mainAxisAlignment: MixHelpers.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixHelpers.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixHelpers.resolve(context, $mainAxisSize),
      verticalDirection: MixHelpers.resolve(context, $verticalDirection),
      textDirection: MixHelpers.resolve(context, $textDirection),
      textBaseline: MixHelpers.resolve(context, $textBaseline),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
      gap: MixHelpers.resolve(context, $gap),
    );
  }

  /// Merges the properties of this [FlexMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexMix merge(FlexMix? other) {
    if (other == null) return this;

    return FlexMix.raw(
      direction: MixHelpers.merge($direction, other.$direction),
      mainAxisAlignment: MixHelpers.merge(
        $mainAxisAlignment,
        other.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixHelpers.merge(
        $crossAxisAlignment,
        other.$crossAxisAlignment,
      ),
      mainAxisSize: MixHelpers.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixHelpers.merge(
        $verticalDirection,
        other.$verticalDirection,
      ),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      textBaseline: MixHelpers.merge($textBaseline, other.$textBaseline),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
      gap: MixHelpers.merge($gap, other.$gap),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('direction', $direction));
    properties.add(
      DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment),
    );
    properties.add(
      DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment),
    );
    properties.add(DiagnosticsProperty('mainAxisSize', $mainAxisSize));
    properties.add(
      DiagnosticsProperty('verticalDirection', $verticalDirection),
    );
    properties.add(DiagnosticsProperty('textDirection', $textDirection));
    properties.add(DiagnosticsProperty('textBaseline', $textBaseline));
    properties.add(DiagnosticsProperty('clipBehavior', $clipBehavior));
    properties.add(DiagnosticsProperty('gap', $gap));
  }

  @override
  FlexMix variant(Variant variant, FlexMix style) {
    return merge(FlexMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  @override
  List<Object?> get props => [
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $clipBehavior,
    $gap,
    $animation,
    $modifiers,
    $variants,
  ];
}
