import 'package:build_test/build_test.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

Future<String> _expectMixWidgetValidationError(String libSource) async {
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

  return result.errors.join('\n');
}

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

    test('MixWidgetGenerator rejects annotation on a class', () async {
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
    });

    test('MixWidgetGenerator rejects non-Style return type', () async {
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
      expect(result.errors.join('\n'), contains('does not extend Style<S>'));
    });

    test('MixWidgetGenerator rejects a styler with no call() method', () async {
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
    });

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
      'MixWidgetGenerator rejects optional positional factory params',
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
BoxStyler badgeStyle([Color? color]) => const BoxStyler();
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
          contains('does not support optional positional factory parameters'),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects factory functions with a `key` parameter',
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
BoxStyler badgeStyle({String? key}) => const BoxStyler();
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
          contains('reserves the parameter name `key`'),
        );
      },
    );

    test(
      'MixWidgetGenerator rejects required Key key on styler call()',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({required Key key, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
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
        final errors = result.errors.join('\n');
        expect(errors, contains('only forwards a `key` parameter'));
        expect(errors, contains('must not be `required`'));
        expect(errors, contains('must be nullable'));
      },
    );

    test(
      'MixWidgetGenerator rejects LocalKey? key subtype on styler call()',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class LocalKey extends Key { const LocalKey() : super(); }

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({LocalKey? key, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
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
          contains('must use the exact `Key` type'),
        );
      },
    );

    test('MixWidgetGenerator rejects String? key on styler call()', () async {
      const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({String? key, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
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
        contains('must use the exact `Key` type'),
      );
    });

    test('MixWidgetGenerator rejects factory/call name collisions', () async {
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
    });

    test('MixWidgetGenerator rejects call params named build', () async {
      const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Widget? build}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

      final errors = await _expectMixWidgetValidationError(libSource);

      expect(errors, contains('reserves the parameter name `build`'));
    });

    test('MixWidgetGenerator rejects call params named hashCode', () async {
      const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({int? hashCode}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

      final errors = await _expectMixWidgetValidationError(libSource);

      expect(errors, contains('reserves the parameter name `hashCode`'));
    });

    test(
      'MixWidgetGenerator rejects call params named createElement',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Widget? createElement}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains('reserves the parameter name `createElement`'));
      },
    );

    test(
      'MixWidgetGenerator rejects factory params matching factory name',
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
BoxStyler badgeStyle({BoxStyler? badgeStyle}) => const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains("matches the factory's identifier"));
      },
    );

    test(
      'MixWidgetGenerator rejects call params matching variable factory name',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Widget? cardStyle}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final cardStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains("matches the factory's identifier"));
      },
    );

    test(
      'MixWidgetGenerator rejects required Key? key on styler call()',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({required Key? key, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains('must not be `required`'));
      },
    );

    test(
      'MixWidgetGenerator rejects non-nullable Key key on styler call()',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key key = const Key(), Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains('must be nullable'));
      },
    );

    test(
      'MixWidgetGenerator rejects Key? key with a default on styler call()',
      () async {
        const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  Widget call({Key? key = null, Widget? child}) => const _S();
}

class _S extends StatelessWidget {
  const _S();
  @override
  Widget build(BuildContext context) => const _S();
}

@MixWidget()
final brokenStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains('must not have a default value'));
      },
    );

    test('MixWidgetGenerator rejects prefixed Flutter imports', () async {
      const libSource = r'''
library widget_validation;

import 'package:flutter/widgets.dart' as fw;
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';

class BoxSpec { const BoxSpec(); }

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();
  fw.Widget call({fw.Key? key, fw.Widget? child}) => const _S();
}

class _S extends fw.StatelessWidget {
  const _S();
  @override
  fw.Widget build(fw.BuildContext context) => const _S();
}

@MixWidget()
final cardStyle = const BoxStyler();
''';

      final errors = await _expectMixWidgetValidationError(libSource);

      expect(errors, contains('visible unprefixed'));
    });

    test('MixWidgetGenerator rejects invalid name overrides', () async {
      const cases = {
        '2bad': '2bad',
        'Bad Name': 'Bad Name',
        'class': 'class',
        '_': '_',
      };

      for (final MapEntry(:key, :value) in cases.entries) {
        final libSource =
            '''
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

@MixWidget(name: '$value')
final cardStyle = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(
          errors,
          contains('not a valid Dart class identifier'),
          reason: key,
        );
      }
    });

    for (final testCase in [
      (name: 'snake_case derived names', elementName: 'primary_button_style'),
      (name: 'lowercase style suffixes', elementName: 'cardstyle'),
      (name: 'names without Style suffixes', elementName: 'someOther'),
    ]) {
      test('MixWidgetGenerator rejects ${testCase.name}', () async {
        final libSource =
            '''
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
final ${testCase.elementName} = const BoxStyler();
''';

        final errors = await _expectMixWidgetValidationError(libSource);

        expect(errors, contains('lowerCamelCase'));
        expect(errors, contains(testCase.elementName));
      });
    }

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
