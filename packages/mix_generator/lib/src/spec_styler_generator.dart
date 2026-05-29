/// Generator for `@MixableSpec` classes that emits generated Styler classes.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'core/builders/spec_styler_class_builder.dart';
import 'core/errors.dart';
import 'core/resolvers/known_mix_symbol_resolver.dart';

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
    final symbolResolver = await KnownMixSymbolResolver.load(
      buildStep,
      classElement,
    );

    return SpecStylerClassBuilder(
      specElement: classElement,
      specName: specName,
      annotation: annotation,
      symbolResolver: symbolResolver,
    ).build();
  }
}
