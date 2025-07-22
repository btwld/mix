import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/color_util.dart';
import '../../attributes/scalar_util.dart';
import '../../attributes/shadow_mix.dart';
import '../../attributes/shadow_util.dart';
import '../../core/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../core/spec.dart';
import '../../core/style.dart';

final class IconSpec extends Spec<IconSpec> with Diagnosticable {
  final Color? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final List<Shadow>? shadows;
  final double? fill;

  const IconSpec({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
  });

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('size', size, defaultValue: null));
    properties.add(DiagnosticsProperty('weight', weight, defaultValue: null));
    properties.add(DiagnosticsProperty('grade', grade, defaultValue: null));
    properties.add(
      DiagnosticsProperty('opticalSize', opticalSize, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('shadows', shadows, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'applyTextScaling',
        applyTextScaling,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('fill', fill, defaultValue: null));
  }

  @override
  IconSpec copyWith({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<Shadow>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
  }) {
    return IconSpec(
      color: color ?? this.color,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      shadows: shadows ?? this.shadows,
      textDirection: textDirection ?? this.textDirection,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
      fill: fill ?? this.fill,
    );
  }

  @override
  IconSpec lerp(IconSpec? other, double t) {
    if (other == null) return this;

    return IconSpec(
      color: Color.lerp(color, other.color, t),
      size: MixHelpers.lerpDouble(size, other.size, t),
      weight: MixHelpers.lerpDouble(weight, other.weight, t),
      grade: MixHelpers.lerpDouble(grade, other.grade, t),
      opticalSize: MixHelpers.lerpDouble(opticalSize, other.opticalSize, t),
      shadows: MixHelpers.lerpShadowList(shadows, other.shadows, t),
      textDirection: t < 0.5 ? textDirection : other.textDirection,
      applyTextScaling: t < 0.5 ? applyTextScaling : other.applyTextScaling,
      fill: MixHelpers.lerpDouble(fill, other.fill, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  @override
  List<Object?> get props => [
    color,
    size,
    weight,
    grade,
    opticalSize,
    shadows,
    textDirection,
    applyTextScaling,
    fill,
  ];
}

class IconSpecAttribute extends SpecStyle<IconSpec> with Diagnosticable {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final List<Prop<Mix<Shadow>>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;

  late final color = ColorUtility((prop) => IconSpecAttribute(color: prop));
  late final size = DoubleUtility((prop) => IconSpecAttribute(size: prop));
  late final weight = DoubleUtility((prop) => IconSpecAttribute(weight: prop));
  late final grade = DoubleUtility((prop) => IconSpecAttribute(grade: prop));
  late final opticalSize = DoubleUtility(
    (prop) => IconSpecAttribute(opticalSize: prop),
  );
  late final shadow = ShadowUtility((v) => IconSpecAttribute(shadows: [v]));
  late final textDirection = TextDirectionUtility(
    (v) => IconSpecAttribute(textDirection: v),
  );
  late final applyTextScaling = BoolUtility(
    (prop) => IconSpecAttribute(applyTextScaling: prop),
  );
  late final fill = DoubleUtility((prop) => IconSpecAttribute(fill: prop));

  IconSpecAttribute({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    List<Prop<Mix<Shadow>>>? shadows,
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
    List<VariantSpecAttribute<IconSpec>>? variants,
  }) : this(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows?.map(Prop.new).toList(),
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
      shadows: MixHelpers.resolveListMix(context, $shadows),
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
