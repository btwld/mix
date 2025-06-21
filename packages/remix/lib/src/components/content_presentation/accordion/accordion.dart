import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';
import '../label/label.dart';

part 'accordion.g.dart';
part 'accordion_style.dart';
part 'accordion_widget.dart';

@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
base class AccordionSpec extends Spec<AccordionSpec> with _$AccordionSpec {
  final BoxSpec itemContainer;
  final BoxSpec contentContainer;
  final FlexBoxSpec headerContainer;
  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData leadingIcon;
  final IconSpec trailingIcon;
  final TextStyle titleStyle;
  final TextStyle contentStyle;

  static const of = _$AccordionSpec.of;

  static const from = _$AccordionSpec.from;

  const AccordionSpec({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconThemeData? leadingIcon,
    IconSpec? trailingIcon,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    super.animated,
  })  : itemContainer = itemContainer ?? const BoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        headerContainer = headerContainer ?? const FlexBoxSpec(),
        leadingIcon = leadingIcon ?? const IconThemeData(),
        trailingIcon = trailingIcon ?? const IconSpec(),
        titleStyle = titleStyle ?? const TextStyle(),
        contentStyle = contentStyle ?? const TextStyle();

  /// Linearly interpolates between this [AccordionSpec] and another [AccordionSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AccordionSpec] is returned. When [t] is 1.0, the [other] [AccordionSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AccordionSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [AccordionSpec] instance.
  ///
  /// The interpolation is performed on each property of the [AccordionSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [itemContainer] and [contentContainer].
  /// - [FlexBoxSpec.lerp] for [headerContainer].
  /// - [IconThemeData.lerp] for [leadingIcon] and [trailingIcon].
  /// - [MixHelpers.lerpTextStyle] for [titleStyle] and [contentStyle].
  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [AccordionSpec] is used. Otherwise, the value
  /// from the [other] [AccordionSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [AccordionSpec] configurations.
  @override
  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return _$this;

    return AccordionSpec(
      itemContainer: _$this.itemContainer.lerp(other.itemContainer, t),
      contentContainer: _$this.contentContainer.lerp(other.contentContainer, t),
      headerContainer: _$this.headerContainer.lerp(other.headerContainer, t),
      leadingIcon: IconThemeData.lerp(_$this.leadingIcon, other.leadingIcon, t),
      // trailingIcon: IconData.lerp(_$this.trailingIcon, other.trailingIcon, t),
      titleStyle:
          MixHelpers.lerpTextStyle(_$this.titleStyle, other.titleStyle, t)!,
      contentStyle:
          MixHelpers.lerpTextStyle(_$this.contentStyle, other.contentStyle, t)!,
      animated: t < 0.5 ? _$this.animated : other.animated,
    );
  }
}
