/// Generator for `@MixableSpec` classes that emits a full Styler class.
///
/// Spike status (do not promote to a default builder yet):
/// - Builder is wired as a `SharedPartBuilder`, so its output is appended to
///   the spec's `*.g.dart` and shares that file's import scope. The generated
///   styler class references runtime symbols (`MixStyler`, `Prop`, `MixOps`,
///   `AnimationConfig`, `WidgetModifierConfig`, `StyleSpec`, `VariantStyle`)
///   and every owner mixin / mix type drawn from the curated `ownerMixins`
///   registry. **The host spec library must already import all of those
///   symbols** for the generated styler to compile — there is no import
///   injection pass.
/// - Until that import strategy lands, this generator is `auto_apply: none`
///   and only the BoxSpec spike fixture in `packages/mix` explicitly enables
///   it. Real specs continue to ship hand-written stylers via the existing
///   `StylerGenerator` path.
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

    return SpecStylerClassBuilder(
      specElement: classElement,
      specName: specName,
      annotation: annotation,
    ).build();
  }
}
