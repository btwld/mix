import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';

void main() {
  group('generator validation', () {
    // NOTE: The SpecGenerator no longer rejects classes that don't
    // `extends Spec<X>` — the generated mixin's
    // `implements Spec<X>, Diagnosticable` header enforces the shape at
    // the type level, and the Dart analyzer reports any violation at
    // compile time. We instead verify the one remaining runtime guard:
    // the class must have an unnamed constructor.
    test(
      'SpecGenerator throws InvalidGenerationSource when no unnamed constructor',
      () async {
        final libraryReader = await initializeLibraryReader({
          'spec_validation.dart': r'''
library spec_validation;

import 'package:mix_annotations/mix_annotations.dart';

@MixableSpec()
class BoxSpec {
  BoxSpec.named();
}
''',
        }, 'spec_validation.dart');

        await expectLater(
          () => generateForElement(
            const SpecGenerator(),
            libraryReader,
            'BoxSpec',
          ),
          throwsInvalidGenerationSourceError(
            'BoxSpec must have an unnamed constructor.',
            elementMatcher: isNotNull,
          ),
        );
      },
    );

    test(
      'StylerGenerator throws InvalidGenerationSource for non-Style classes',
      () async {
        final libraryReader = await initializeLibraryReader({
          'styler_validation.dart': r'''
library styler_validation;

import 'package:mix_annotations/mix_annotations.dart';

@MixableStyler()
class BoxStyler {
  const BoxStyler();
}
''',
        }, 'styler_validation.dart');

        await expectLater(
          () => generateForElement(
            const StylerGenerator(),
            libraryReader,
            'BoxStyler',
          ),
          throwsInvalidGenerationSourceError(
            '@MixableStyler can only be applied to classes extending Style<T>.',
            elementMatcher: isNotNull,
          ),
        );
      },
    );

    test(
      'MixableGenerator throws InvalidGenerationSource for non-Mix classes',
      () async {
        final libraryReader = await initializeLibraryReader({
          'mix_validation.dart': r'''
library mix_validation;

import 'package:mix_annotations/mix_annotations.dart';

@Mixable()
class BoxConstraintsMix {
  const BoxConstraintsMix();
}
''',
        }, 'mix_validation.dart');

        await expectLater(
          () => generateForElement(
            const MixableGenerator(),
            libraryReader,
            'BoxConstraintsMix',
          ),
          throwsInvalidGenerationSourceError(
            '@Mixable can only be applied to classes extending Mix<T> or its subclasses.',
            elementMatcher: isNotNull,
          ),
        );
      },
    );
  });
}
