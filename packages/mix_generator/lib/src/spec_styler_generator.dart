/// Generator for `@MixableSpec` classes that emits a standalone Styler library.
library;

import 'package:analyzer/dart/ast/ast.dart';
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

    final body = SpecStylerClassBuilder(
      specElement: classElement,
      specName: specName,
      annotation: annotation,
      symbolResolver: symbolResolver,
    ).build();
    final sourceImport = _sourceImportFor(buildStep);
    final sourceImports = await _sourceImportsFor(buildStep);

    return '''
// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '$mixPublicImport';
${sourceImports.join('\n')}

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

Future<List<String>> _sourceImportsFor(BuildStep buildStep) async {
  final unit = await buildStep.resolver.compilationUnitFor(buildStep.inputId);
  final imports = <String>{};

  for (final directive in unit.directives.whereType<ImportDirective>()) {
    final uri = directive.uri.stringValue;
    if (uri == null) continue;
    if (_isRedundantGeneratedImport(uri)) continue;

    imports.add(directive.toSource());
  }

  return imports.toList();
}

bool _isRedundantGeneratedImport(String uri) {
  return uri == 'package:flutter/foundation.dart' ||
      uri == 'package:flutter/widgets.dart' ||
      uri == 'package:mix/mix.dart' ||
      uri == 'package:mix_annotations/mix_annotations.dart';
}
