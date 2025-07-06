import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/animation/animated_config_dto.dart';
import '../../attributes/animation/animated_util.dart';
import '../../attributes/animation/animation_config.dart';
import '../../attributes/color/color_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/modifiers/widget_modifiers_config.dart';
import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
import '../../attributes/modifiers/widget_modifiers_util.dart';
import '../../attributes/shadow/shadow_dto.dart';
import '../../attributes/shadow/shadow_util.dart';
import '../../core/computed_style/computed_style.dart';
import '../../core/element.dart';
import '../../core/factory/mix_context.dart';
import '../../core/factory/style_mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';
import 'icon_widget.dart';

final class IconSpec extends Spec<IconSpec> with Diagnosticable {
  final Color? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final TextDirection? textDirection;
  final bool? applyTextScaling;

  // TODO: add shadow utility
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
    super.animated,
    super.modifiers,
  });

  static IconSpec from(MixContext mix) {
    return mix.attributeOf<IconSpecAttribute>()?.resolve(mix) ??
        const IconSpec();
  }

  static IconSpec of(BuildContext context) {
    return ComputedStyle.specOf(context) ?? const IconSpec();
  }

  Widget call(
    IconData? icon, {
    String? semanticLabel,
    List<Type> orderOfModifiers = const [],
    TextDirection? textDirection,
  }) {
    return isAnimated
        ? AnimatedIconSpecWidget(
            icon,
            spec: this,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
            curve: animated!.curve,
            duration: animated!.duration,
            orderOfModifiers: orderOfModifiers,
          )
        : IconSpecWidget(
            icon,
            spec: this,
            semanticLabel: semanticLabel,
            textDirection: textDirection,
            orderOfModifiers: orderOfModifiers,
          );
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
    AnimationConfig? animated,
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
      animated: animated ?? this.animated,
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
      animated: animated ?? other.animated,
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
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
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
    animated,
    modifiers,
  ];
}

class IconSpecAttribute extends SpecAttribute<IconSpec> with Diagnosticable {
  final Mixable<Color>? color;
  final double? size;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final List<ShadowDto>? shadows;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final double? fill;

  const IconSpecAttribute({
    this.color,
    this.size,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.textDirection,
    this.applyTextScaling,
    this.fill,
    super.animated,
    super.modifiers,
  });

  @override
  IconSpec resolve(MixContext mix) {
    return IconSpec(
      color: color?.resolve(mix),
      size: size,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows?.map((e) => e.resolve(mix)).toList(),
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      fill: fill,
      animated: animated?.resolve(mix),
      modifiers: modifiers?.resolve(mix),
    );
  }

  @override
  IconSpecAttribute merge(IconSpecAttribute? other) {
    if (other == null) return this;

    return IconSpecAttribute(
      color: color?.merge(other.color) ?? other.color,
      size: other.size ?? size,
      weight: other.weight ?? weight,
      grade: other.grade ?? grade,
      opticalSize: other.opticalSize ?? opticalSize,
      shadows: MixHelpers.mergeList(shadows, other.shadows),
      textDirection: other.textDirection ?? textDirection,
      applyTextScaling: other.applyTextScaling ?? applyTextScaling,
      fill: other.fill ?? fill,
      animated: animated?.merge(other.animated) ?? other.animated,
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
      DiagnosticsProperty('animated', animated, defaultValue: null),
    );
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
    animated,
    modifiers,
  ];
}

class IconSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, IconSpecAttribute> {
  late final color = ColorUtility((v) => only(color: v));
  late final size = DoubleUtility((v) => only(size: v));
  late final weight = DoubleUtility((v) => only(weight: v));
  late final grade = DoubleUtility((v) => only(grade: v));
  late final opticalSize = DoubleUtility((v) => only(opticalSize: v));
  late final shadows = ShadowListUtility((v) => only(shadows: v));
  late final textDirection = TextDirectionUtility(
    (v) => only(textDirection: v),
  );
  late final applyTextScaling = BoolUtility((v) => only(applyTextScaling: v));
  late final fill = DoubleUtility((v) => only(fill: v));
  late final animated = AnimatedUtility((v) => only(animated: v));
  late final wrap = SpecModifierUtility((v) => only(modifiers: v));

  IconSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  IconSpecUtility<T> get chain => IconSpecUtility(attributeBuilder);

  static IconSpecUtility<IconSpecAttribute> get self =>
      IconSpecUtility((v) => v);

  @override
  T only({
    Mixable<Color>? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowDto>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    AnimationConfigDto? animated,
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
        animated: animated,
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
