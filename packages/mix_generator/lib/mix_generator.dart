// Mix Generator - Rewrite in Progress
//
// This package is being rewritten from scratch.
// See mix_generator_plan.md for the implementation plan.
//
// The generator will auto-generate:
// 1. Spec class bodies: copyWith(), lerp(), debugFillProperties(), props
// 2. Styler classes: Field declarations, constructors, resolve(), merge()

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Entry point for the mix_generator builder.
///
/// Triggers on @MixableSpec annotations and generates:
/// - _$XSpecMethods mixin (Spec method overrides)
/// - XStyler class (full Styler implementation)
Builder mixGenerator(BuilderOptions options) {
  return PartBuilder(
    [_PlaceholderGenerator()],
    '.g.dart',
    formatOutput: (code, version) {
      return DartFormatter(languageVersion: version).format(code);
    },
  );
}

/// Placeholder generator - to be replaced with full implementation.
class _PlaceholderGenerator extends GeneratorForAnnotation<MixableSpec> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // TODO: Implement generator following mix_generator_plan.md
    return '// Generator not yet implemented for ${element.name}';
  }
}
