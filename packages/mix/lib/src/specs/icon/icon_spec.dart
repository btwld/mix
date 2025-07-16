import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/shadow/shadow_dto.dart';
import '../../attributes/shadow/shadow_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

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
    super.modifiers,
  });

  static IconSpec from(MixContext mix) {
    return mix.attributeOf<IconSpecAttribute>()?.resolve(mix) ??
        const IconSpec();
  }

  static IconSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const IconSpec();
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
    WidgetModifiersConfig? modifiers,
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
      modifiers: modifiers ?? this.modifiers,
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
      modifiers: other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
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
    modifiers,
  ];
}

class IconSpecAttribute extends SpecAttribute<IconSpec> with Diagnosticable {
  final Prop<Color>? color;
  final Prop<double>? size;
  final Prop<double>? weight;
  final Prop<double>? grade;
  final Prop<double>? opticalSize;
  final List<MixProp<Shadow, ShadowDto>>? shadows;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final Prop<double>? fill;

  // Factory constructor accepts raw values
  factory IconSpecAttribute({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowDto>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return IconSpecAttribute.props(
      color: Prop.maybeValue(color),
      size: Prop.maybeValue(size),
      weight: Prop.maybeValue(weight),
      grade: Prop.maybeValue(grade),
      opticalSize: Prop.maybeValue(opticalSize),
      shadows: shadows
          ?.map((shadow) => MixProp<Shadow, ShadowDto>.fromValue(shadow))
          .toList(),
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: Prop.maybeValue(fill),
      modifiers: modifiers,
    );
  }

  /// Constructor that accepts Prop values directly
  const IconSpecAttribute.props({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    super.modifiers,
  });

  // Static factory to create from resolved Spec
  static IconSpecAttribute value(IconSpec spec) {
    return IconSpecAttribute.props(
      color: Prop.maybeValue(spec.color),
      size: Prop.maybeValue(spec.size),
      weight: Prop.maybeValue(spec.weight),
      grade: Prop.maybeValue(spec.grade),
      opticalSize: Prop.maybeValue(spec.opticalSize),
      shadows: spec.shadows
          ?.map(
            (shadow) =>
                MixProp<Shadow, ShadowDto>.fromValue(ShadowDto.value(shadow)),
          )
          .toList(),
      textDirection: spec.textDirection,
      applyTextScaling: spec.applyTextScaling,
      fill: Prop.maybeValue(spec.fill),
      modifiers: WidgetModifiersConfigDto.maybeValue(spec.modifiers),
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

  @override
  IconSpec resolve(MixContext context) {
    return IconSpec(
      color: resolveProp(context, color),
      size: resolveProp(context, size),
      weight: resolveProp(context, weight),
      grade: resolveProp(context, grade),
      opticalSize: resolveProp(context, opticalSize),
      shadows: resolveMixPropList(context, shadows),
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: resolveProp(context, fill),
      modifiers: modifiers?.resolve(context),
    );
  }

  @override
  IconSpecAttribute merge(IconSpecAttribute? other) {
    if (other == null) return this;

    return IconSpecAttribute.props(
      color: mergeProp(color, other.color),
      size: mergeProp(size, other.size),
      weight: mergeProp(weight, other.weight),
      grade: mergeProp(grade, other.grade),
      opticalSize: mergeProp(opticalSize, other.opticalSize),
      shadows: mergeMixPropList(
        shadows,
        other.shadows,
        strategy: ListMergeStrategy.override,
      ),
      textDirection: other.textDirection ?? textDirection,
      applyTextScaling: other.applyTextScaling ?? applyTextScaling,
      fill: mergeProp(fill, other.fill),
      modifiers: modifiers?.merge(other.modifiers) ?? other.modifiers,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
    properties.add(
      DiagnosticsProperty('modifiers', modifiers, defaultValue: null),
    );
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
    modifiers,
  ];
}

class IconSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, IconSpecAttribute> {
  late final color = ColorUtility(
    (prop) => builder(IconSpecAttribute.props(color: prop)),
  );
  late final size = DoubleUtility(
    (prop) => builder(IconSpecAttribute.props(size: prop)),
  );
  late final weight = DoubleUtility(
    (prop) => builder(IconSpecAttribute.props(weight: prop)),
  );
  late final grade = DoubleUtility(
    (prop) => builder(IconSpecAttribute.props(grade: prop)),
  );
  late final opticalSize = DoubleUtility(
    (prop) => builder(IconSpecAttribute.props(opticalSize: prop)),
  );
  late final shadows = ShadowListUtility((v) => only(shadows: v));
  late final textDirection = TextDirectionUtility(
    (v) => only(textDirection: v),
  );
  late final applyTextScaling = BoolUtility(
    (prop) => builder(IconSpecAttribute.props(applyTextScaling: prop.value)),
  );
  late final fill = DoubleUtility(
    (prop) => builder(IconSpecAttribute.props(fill: prop)),
  );
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  IconSpecUtility(super.builder);

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  IconSpecUtility<T> get chain => IconSpecUtility(attributeBuilder);

  static IconSpecUtility<IconSpecAttribute> get self =>
      IconSpecUtility((v) => v);

  @override
  T only({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowDto>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    WidgetModifiersConfigDto? modifiers,
  }) {
    return builder(
      IconSpecAttribute(
        color: color,
        size: size,
        weight: weight,
        grade: grade,
        opticalSize: opticalSize,
        shadows: shadows,
        textDirection: textDirection,
        applyTextScaling: applyTextScaling,
        fill: fill,
        modifiers: modifiers,
      ),
    );
  }
}

extension IconSpecUtilityExt<T extends SpecAttribute> on IconSpecUtility<T> {
  ShadowUtility get shadow => ShadowUtility((v) => only(shadows: [v]));
}

/// A tween that interpolates between two [IconSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IconSpec] specifications.
class IconSpecTween extends Tween<IconSpec?> {
  IconSpecTween({super.begin, super.end});

  @override
  IconSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IconSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
