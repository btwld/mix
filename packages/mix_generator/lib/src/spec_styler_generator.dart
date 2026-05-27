/// Generator for `@MixableSpec` classes that emits a full Styler class.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/spec_styler_class_builder.dart';
import 'core/errors.dart';

class SpecStylerGenerator extends GeneratorForAnnotation<MixableSpec> {
  const SpecStylerGenerator();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final classElement = requireClassElement(element, '@MixableSpec');
    final specName = requireName(
      classElement,
      orFailWith: '@MixableSpec class must have a name.',
    );

    final builder = SpecStylerClassBuilder(
      specElement: classElement,
      specName: specName,
      annotation: annotation,
      buildStep: buildStep,
    );

    return builder.build();
  }
}
