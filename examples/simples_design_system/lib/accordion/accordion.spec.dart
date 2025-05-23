import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'accordion.spec.g.dart';

@MixableSpec()
base class AccordionSpec extends Spec<AccordionSpec> with _$AccordionSpec {
  final FlexBoxSpec container;
  final BoxSpec contentContainer;
  final BoxSpec headerContainer;

  /// {@macro accordion_spec_of}
  static const of = _$AccordionSpec.of;

  static const from = _$AccordionSpec.from;

  const AccordionSpec({
    FlexBoxSpec? container,
    BoxSpec? contentContainer,
    BoxSpec? headerContainer,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        headerContainer = headerContainer ?? const BoxSpec();
}
