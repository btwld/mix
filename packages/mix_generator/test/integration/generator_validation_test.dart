import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

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

    test(
      'MixWidgetGenerator rejects annotation on a class',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:mix_annotations/mix_annotations.dart';

@MixWidget()
class NotAFactory {
  const NotAFactory();
}
''';

        final result = await testBuilder(
          partBuilder(const MixWidgetGenerator()),
          {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix_generator|lib/widget_validation.dart': libSource,
          },
          generateFor: {'mix_generator|lib/widget_validation.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains(
            '@MixWidget can only be applied to top-level variables or '
            'top-level functions.',
          ),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects non-Style return type',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:mix_annotations/mix_annotations.dart';

@MixWidget()
int notAStyle() => 42;
''';

        final result = await testBuilder(
          partBuilder(const MixWidgetGenerator()),
          {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix_generator|lib/widget_validation.dart': libSource,
          },
          generateFor: {'mix_generator|lib/widget_validation.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains('does not extend Style<S>'),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects a styler with no call() method',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class CallLessStyler extends Style<BoxSpec> {
  const CallLessStyler();
}

@MixWidget()
final brokenStyle = const CallLessStyler();
''';

        final result = await testBuilder(
          partBuilder(const MixWidgetGenerator()),
          {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_validation.dart': libSource,
          },
          generateFor: {'mix_generator|lib/widget_validation.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains('requires CallLessStyler to declare a `call()` method'),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects optional positional call params',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BadStyler extends Style<BoxSpec> {
  const BadStyler();
  Widget call([Widget? child]) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BadStyler();
''';

        final result = await testBuilder(
          partBuilder(const MixWidgetGenerator()),
          {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_validation.dart': libSource,
          },
          generateFor: {'mix_generator|lib/widget_validation.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains('does not support optional positional `call()` parameters'),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects factory/call name collisions',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
BoxStyler collidingStyle({Widget? child}) => const BoxStyler();
''';

        final result = await testBuilder(
          partBuilder(const MixWidgetGenerator()),
          {
            ...mixAnnotationsSources,
            ...widgetStub,
            'mix|lib/src/core/style.dart': styleStub,
            'mix_generator|lib/widget_validation.dart': libSource,
          },
          generateFor: {'mix_generator|lib/widget_validation.dart'},
        );

        expect(result.succeeded, isFalse);
        expect(
          result.errors.join('\n'),
          contains('parameter name collision: `child`'),
        );
      },
    );

    test('MixableGenerator rejects direct Mixable subclasses', () async {
      const source = r'''
library mix_validation;

import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/mix_element.dart' as mix;

part 'mix_validation.g.dart';

class BoxConstraints {
  const BoxConstraints();
}

@Mixable()
class BoxConstraintsMix extends mix.Mixable<BoxConstraints> {
  const BoxConstraintsMix();
}
''';

      final result = await testBuilder(
        partBuilder(const MixableGenerator()),
        {
          ...mixAnnotationsSources,
          'mix_generator|lib/mix_validation.dart': source,
          'mix|lib/src/core/mix_element.dart': mixElementStub,
        },
        generateFor: {'mix_generator|lib/mix_validation.dart'},
      );

      expect(result.succeeded, isFalse);
      expect(
        result.errors.join('\n'),
        contains(
          '@Mixable can only be applied to classes extending Mix<T> or its subclasses.',
        ),
      );
    });
  });
}
