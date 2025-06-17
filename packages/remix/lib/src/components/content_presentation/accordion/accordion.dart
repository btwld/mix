import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/component_builder.dart';
import '../../../helpers/spec_style.dart';

part 'accordion.g.dart';
part 'accordion_style.dart';
part 'accordion_widget.dart';
part 'header/accordion_header.dart';
part 'header/accordion_header_spec_widget.dart';

@MixableSpec()
base class AccordionSpec extends Spec<AccordionSpec> with _$AccordionSpec {
  final FlexBoxSpec container;

  @MixableField(dto: MixableFieldType(type: 'AccordionHeaderSpecAttribute'))
  final AccordionHeaderSpec header;

  final BoxSpec contentContainer;

  /// {@macro accordion_spec_of}
  static const of = _$AccordionSpec.of;

  static const from = _$AccordionSpec.from;

  const AccordionSpec({
    AccordionHeaderSpec? header,
    FlexBoxSpec? container,
    BoxSpec? contentContainer,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        header = header ?? const AccordionHeaderSpec(),
        contentContainer = contentContainer ?? const BoxSpec();
}
