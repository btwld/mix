import 'package:flutter/material.dart';
import 'package:mix/experimental.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/component_builder.dart';
import '../../../helpers/spec_style.dart';

part 'accordion.g.dart';
part 'accordion_style.dart';
part 'accordion_widget.dart';

@MixableSpec()
base class AccordionSpec extends Spec<AccordionSpec> with _$AccordionSpec {
  final BoxSpec itemContainer;
  final BoxSpec contentContainer;
  final FlexBoxSpec headerContainer;
  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData leadingIcon;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData trailingIcon;
  final TextStyle titleStyle;
  final TextStyle contentStyle;

  static const of = _$AccordionSpec.of;

  static const from = _$AccordionSpec.from;

  const AccordionSpec({
    BoxSpec? itemContainer,
    BoxSpec? contentContainer,
    FlexBoxSpec? headerContainer,
    IconThemeData? leadingIcon,
    IconThemeData? trailingIcon,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    super.animated,
  })  : itemContainer = itemContainer ?? const BoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        headerContainer = headerContainer ?? const FlexBoxSpec(),
        leadingIcon = leadingIcon ?? const IconThemeData(),
        trailingIcon = trailingIcon ?? const IconThemeData(),
        titleStyle = titleStyle ?? const TextStyle(),
        contentStyle = contentStyle ?? const TextStyle();
}
