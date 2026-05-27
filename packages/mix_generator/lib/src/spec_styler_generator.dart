/// Generator for `@MixableSpec` classes that emits a standalone Styler library.
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
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final classElement = requireClassElement(element, '@MixableSpec');
    final specName = requireName(
      classElement,
      orFailWith: '@MixableSpec class must have a name.',
    );

    final body = SpecStylerClassBuilder(
      specElement: classElement,
      specName: specName,
      annotation: annotation,
    ).build();
    final sourceImport = _sourceImportFor(buildStep);

    return '''
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '$sourceImport';

$body
''';
  }
}

String _sourceImportFor(BuildStep buildStep) {
  final path = buildStep.inputId.path;
  final lastSlash = path.lastIndexOf('/');

  return lastSlash == -1 ? path : path.substring(lastSlash + 1);
}
