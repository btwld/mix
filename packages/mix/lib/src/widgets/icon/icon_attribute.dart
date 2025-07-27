import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'icon_spec.dart';

class IconSpecAttribute extends StyleAttribute<IconSpec> with Diagnosticable {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final List<MixProp<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;

  late final color = ColorUtility(
    (prop) => merge(IconSpecAttribute(color: prop)),
  );
  late final size = PropUtility<IconSpecAttribute, double>(
    (prop) => merge(IconSpecAttribute(size: prop)),
  );
  late final weight = PropUtility<IconSpecAttribute, double>(
    (prop) => merge(IconSpecAttribute(weight: prop)),
  );
  late final grade = PropUtility<IconSpecAttribute, double>(
    (prop) => merge(IconSpecAttribute(grade: prop)),
  );
  late final opticalSize = PropUtility<IconSpecAttribute, double>(
    (prop) => merge(IconSpecAttribute(opticalSize: prop)),
  );
  late final shadow = ShadowUtility(
    (v) => merge(IconSpecAttribute(shadows: [v])),
  );
  late final textDirection = PropUtility<IconSpecAttribute, TextDirection>(
    (prop) => merge(IconSpecAttribute(textDirection: prop)),
  );
  late final applyTextScaling = PropUtility<IconSpecAttribute, bool>(
    (prop) => merge(IconSpecAttribute(applyTextScaling: prop)),
  );
  late final fill = PropUtility<IconSpecAttribute, double>(
    (prop) => merge(IconSpecAttribute(fill: prop)),
  );

  IconSpecAttribute({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<MixProp<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $color = color,
       $size = size,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $shadows = shadows,
       $textDirection = textDirection,
       $applyTextScaling = applyTextScaling,
       $fill = fill;

  IconSpecAttribute.only({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowMix>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<IconSpec>>? variants,
  }) : this(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(MixProp.new).toList(),
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  // Static factory to create from resolved Spec
  static IconSpecAttribute value(IconSpec spec) {
    return IconSpecAttribute.only(
      color: spec.color,
      size: spec.size,
      weight: spec.weight,
      grade: spec.grade,
      opticalSize: spec.opticalSize,
      shadows: spec.shadows?.map((shadow) => ShadowMix.value(shadow)).toList(),
      textDirection: spec.textDirection,
      applyTextScaling: spec.applyTextScaling,
      fill: spec.fill,
    );
  }

  /// Constructor that accepts a nullable [IconSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [IconSpecAttribute.value].
  ///
  /// ```dart
  /// const IconSpec? spec = IconSpec(color: Colors.blue, size: 24.0);
  /// final attr = IconSpecAttribute.maybeValue(spec); // Returns IconSpecAttribute or null
  /// ```
  static IconSpecAttribute? maybeValue(IconSpec? spec) {
    return spec != null ? IconSpecAttribute.value(spec) : null;
  }

  IconSpecAttribute shadows(List<ShadowMix> value) {
    return IconSpecAttribute.only(shadows: value);
  }

  @override
  IconSpec resolve(BuildContext context) {
    return IconSpec(
      color: MixHelpers.resolve(context, $color),
      size: MixHelpers.resolve(context, $size),
      weight: MixHelpers.resolve(context, $weight),
      grade: MixHelpers.resolve(context, $grade),
      opticalSize: MixHelpers.resolve(context, $opticalSize),
      shadows: MixHelpers.resolveList(context, $shadows),
      textDirection: MixHelpers.resolve(context, $textDirection),
      applyTextScaling: MixHelpers.resolve(context, $applyTextScaling),
      fill: MixHelpers.resolve(context, $fill),
    );
  }

  @override
  IconSpecAttribute merge(IconSpecAttribute? other) {
    if (other == null) return this;

    return IconSpecAttribute(
      color: MixHelpers.merge($color, other.$color),
      size: MixHelpers.merge($size, other.$size),
      weight: MixHelpers.merge($weight, other.$weight),
      grade: MixHelpers.merge($grade, other.$grade),
      opticalSize: MixHelpers.merge($opticalSize, other.$opticalSize),
      shadows: MixHelpers.mergeList($shadows, other.$shadows),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      applyTextScaling: MixHelpers.merge(
        $applyTextScaling,
        other.$applyTextScaling,
      ),
      fill: MixHelpers.merge($fill, other.$fill),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', $color, defaultValue: null));
    properties.add(DiagnosticsProperty('size', $size, defaultValue: null));
    properties.add(DiagnosticsProperty('weight', $weight, defaultValue: null));
    properties.add(DiagnosticsProperty('grade', $grade, defaultValue: null));
    properties.add(
      DiagnosticsProperty('opticalSize', $opticalSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('shadows', $shadows, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'applyTextScaling',
        $applyTextScaling,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('fill', $fill, defaultValue: null));
  }

  @override
  List<Object?> get props => [
    $color,
    $size,
    $weight,
    $grade,
    $opticalSize,
    $shadows,
    $textDirection,
    $applyTextScaling,
    $fill,
  ];
}
