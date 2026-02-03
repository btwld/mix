import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../style/abstracts/styler.dart';
import 'icon_mutable_style.dart';
import 'icon_spec.dart';
import 'icon_widget.dart';

part 'icon_style.g.dart';

@Deprecated('Use IconStyler instead')
typedef IconMix = IconStyler;

@mixableStyler
class IconStyler extends MixStyler<IconStyler, IconSpec>
    with _$IconStylerMixin {
  @override
  final Prop<Color>? $color;
  @override
  final Prop<double>? $size;
  @override
  final Prop<double>? $weight;
  @override
  final Prop<double>? $grade;
  @override
  final Prop<double>? $opticalSize;

  @override
  @MixableField(ignoreSetter: true)
  final Prop<List<Shadow>>? $shadows;

  @override
  final Prop<TextDirection>? $textDirection;
  @override
  final Prop<bool>? $applyTextScaling;
  @override
  final Prop<double>? $fill;
  @override
  final Prop<String>? $semanticsLabel;
  @override
  final Prop<double>? $opacity;
  @override
  final Prop<BlendMode>? $blendMode;
  @override
  final Prop<IconData>? $icon;

  const IconStyler.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    Prop<List<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    Prop<String>? semanticsLabel,
    Prop<double>? opacity,
    Prop<BlendMode>? blendMode,
    Prop<IconData>? icon,
    super.animation,
    super.modifier,
    super.variants,
  }) : $color = color,
       $size = size,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $shadows = shadows,
       $textDirection = textDirection,
       $applyTextScaling = applyTextScaling,
       $fill = fill,
       $semanticsLabel = semanticsLabel,
       $opacity = opacity,
       $blendMode = blendMode,
       $icon = icon;

  IconStyler({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowMix>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<IconSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows != null ? Prop.mix(ShadowListMix(shadows)) : null,
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         semanticsLabel: Prop.maybe(semanticsLabel),
         opacity: Prop.maybe(opacity),
         blendMode: Prop.maybe(blendMode),
         icon: Prop.maybe(icon),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  static IconMutableStyler get chain => .new(IconStyler());

  /// Sets single icon shadow
  IconStyler shadow(ShadowMix value) {
    return merge(IconStyler(shadows: [value]));
  }

  /// Sets icon shadows
  IconStyler shadows(List<ShadowMix> value) {
    return merge(IconStyler(shadows: value));
  }

  StyledIcon call({Key? key, IconData? icon, String? semanticLabel}) {
    return StyledIcon(
      key: key,
      icon: icon,
      semanticLabel: semanticLabel,
      style: this,
    );
  }

  /// Sets the widget modifier.
  IconStyler modifier(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }
}
