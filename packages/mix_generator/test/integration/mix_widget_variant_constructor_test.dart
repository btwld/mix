import 'package:mix_generator/mix_generator.dart';
import 'package:test/test.dart';

import '../core/test_helpers.dart';

const _variantLibrary = r'''
library button_variants;

const _legacyMessage = r'Use $solid instead.';

enum ButtonVariant {
  /// High-emphasis filled button.
  solid,

  /// Shares its name with an instance field on the generated widget.
  label,

  /// Shares its name with the generated widget class.
  Button,

  /// Kept for backwards compatibility.
  @Deprecated(_legacyMessage)
  legacy,
}
''';

const _stylerTypes = r'''
class ButtonSpec {
  const ButtonSpec();
}

class ButtonStyler extends Style<ButtonSpec> {
  const ButtonStyler();

  Widget call({
    Key? key,
    required String label,
    Widget? child,
  }) => const _Stub();
}

class _Stub extends StatelessWidget {
  const _Stub();

  @override
  Widget build(BuildContext context) => const _Stub();
}
''';

Map<String, String> _sources(
  String factory, {
  Map<String, String> extraSources = const {},
  String extraImports = '',
}) => {
  ...mixAnnotationsSources,
  ...widgetStub,
  'mix|lib/src/core/style.dart': styleStub,
  ...extraSources,
  'mix_generator|lib/widget_case.dart':
      '''
library widget_case;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix/src/core/style.dart';
$extraImports
part 'widget_case.g.dart';

$_stylerTypes

$factory
''',
};

void main() {
  group('MixWidget enum variant constructors', () {
    test(
      'emit documented, prefix-safe constructors with preserved parameters',
      () async {
        const factory = r'''
@MixWidget()
ButtonStyler buttonStyle({
  variants.ButtonVariant variant = variants.ButtonVariant.solid,
  int size = 2,
}) => const ButtonStyler();
''';

        final namedConstructorWithoutVariant = predicate<String>((source) {
          final match = RegExp(
            r'const Button\.solid\(([\s\S]*?)\)\s*:\s*variant\s*=\s*'
            r'variants\.ButtonVariant\.solid;',
          ).firstMatch(source);

          return match != null &&
              !match.group(1)!.contains('this.variant') &&
              match.group(1)!.contains('this.size = 2') &&
              match.group(1)!.contains('required this.label') &&
              match.group(1)!.contains('this.child');
        }, 'a Button.solid constructor that omits the variant parameter');
        final constructorsFollowEnumOrder = predicate<String>((source) {
          final indexes = [
            source.indexOf('const Button.solid('),
            source.indexOf('const Button.label('),
            source.indexOf('const Button.Button('),
            source.indexOf('const Button.legacy('),
          ];

          return indexes.every((index) => index >= 0) &&
              indexes[0] < indexes[1] &&
              indexes[1] < indexes[2] &&
              indexes[2] < indexes[3];
        }, 'variant constructors in enum declaration order');

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: _sources(
            factory,
            extraImports: "import 'button_variants.dart' as variants;",
            extraSources: {
              'mix_generator|lib/button_variants.dart': _variantLibrary,
            },
          ),
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            // The existing unnamed constructor remains available.
            contains('const Button({'),
            contains('this.variant = variants.ButtonVariant.solid'),
            contains('this.size = 2'),
            contains('/// High-emphasis filled button.'),
            namedConstructorWithoutVariant,
            // Constructor names occupy a different namespace from instance
            // fields and may also match the enclosing class name in Dart.
            contains('const Button.label('),
            contains('const Button.Button('),
            constructorsFollowEnumOrder,
            contains(r'@Deprecated("Use \$solid instead.")'),
            contains('const Button.legacy('),
            contains(': variant = variants.ButtonVariant.legacy;'),
          ]),
        );
      },
    );

    test(
      'curates call parameters in unnamed and variant constructors',
      () async {
        const factory = r'''
enum ButtonVariant { solid, ghost }

@MixWidget(widgetParameters: .only({'label'}))
ButtonStyler buttonStyle({
  ButtonVariant variant = ButtonVariant.solid,
  int size = 2,
}) => const ButtonStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: _sources(factory),
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('this.variant = ButtonVariant.solid'),
            contains('this.size = 2'),
            contains('required this.label'),
            contains('const Button.solid('),
            contains('const Button.ghost('),
            isNot(contains('final Widget? child;')),
            isNot(contains('child: this.child')),
            contains('label: this.label'),
          ]),
        );
      },
    );

    test('required named enum variants also trigger', () async {
      const factory = r'''
enum ButtonVariant { solid }

@MixWidget()
ButtonStyler buttonStyle({required ButtonVariant variant}) =>
    const ButtonStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: _sources(factory),
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('required this.variant'),
          contains('const Button.solid('),
          contains(': variant = ButtonVariant.solid;'),
        ]),
      );
    });

    test(
      'type parameter conflicts suppress all variant constructors',
      () async {
        const factory = r'''
enum GenericButtonVariant { T, solid }

class GenericButtonStyler extends Style<ButtonSpec> {
  const GenericButtonStyler();

  T call<T extends Widget>({Key? key, required T child}) => child;
}

@MixWidget(name: 'GenericButton')
GenericButtonStyler genericButtonStyle({
  GenericButtonVariant variant = GenericButtonVariant.solid,
}) => const GenericButtonStyler();
''';

        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: _sources(factory),
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: allOf([
            contains('class GenericButton<T extends Widget>'),
            contains('this.variant = GenericButtonVariant.solid'),
            isNot(contains('const GenericButton.T(')),
            isNot(contains('const GenericButton.solid(')),
          ]),
        );
      },
    );

    test('skips private constants from an imported enum', () async {
      const variants = r'''
library button_variants;

enum ButtonVariant { solid, _internal }
''';
      const factory = r'''
@MixWidget()
ButtonStyler buttonStyle({
  variants.ButtonVariant variant = variants.ButtonVariant.solid,
}) => const ButtonStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: _sources(
          factory,
          extraImports: "import 'button_variants.dart' as variants;",
          extraSources: {'mix_generator|lib/button_variants.dart': variants},
        ),
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('const Button.solid('),
          isNot(contains('const Button._internal(')),
          isNot(contains('variants.ButtonVariant._internal')),
        ]),
      );
    });

    test('keeps private constants declared in the annotated library', () async {
      const factory = r'''
enum ButtonVariant { solid, _internal }

@MixWidget()
ButtonStyler buttonStyle({
  ButtonVariant variant = ButtonVariant.solid,
}) => const ButtonStyler();
''';

      await expectGeneratorOutputResolves(
        builder: partBuilder(const MixWidgetGenerator()),
        sources: _sources(factory),
        inputAsset: 'mix_generator|lib/widget_case.dart',
        outputAsset: 'mix_generator|lib/widget_case.g.dart',
        outputMatcher: allOf([
          contains('const Button.solid('),
          contains('const Button._internal('),
          contains(': variant = ButtonVariant._internal;'),
        ]),
      );
    });

    final negativeCases = <({String description, String factory})>[
      (
        description: 'nullable variant parameters do not trigger',
        factory: r'''
enum ButtonVariant { solid }

@MixWidget()
ButtonStyler buttonStyle({ButtonVariant? variant}) => const ButtonStyler();
''',
      ),
      (
        description: 'non-enum variant parameters do not trigger',
        factory: r'''
@MixWidget()
ButtonStyler buttonStyle({String variant = 'solid'}) => const ButtonStyler();
''',
      ),
      (
        description: 'positional variant parameters do not trigger',
        factory: r'''
enum ButtonVariant { solid }

@MixWidget()
ButtonStyler buttonStyle(ButtonVariant variant) => const ButtonStyler();
''',
      ),
      (
        description: 'variable-backed stylers do not trigger',
        factory: r'''
@MixWidget()
final buttonStyle = const ButtonStyler();
''',
      ),
    ];

    for (final testCase in negativeCases) {
      test(testCase.description, () async {
        await expectGeneratorOutputResolves(
          builder: partBuilder(const MixWidgetGenerator()),
          sources: _sources(testCase.factory),
          inputAsset: 'mix_generator|lib/widget_case.dart',
          outputAsset: 'mix_generator|lib/widget_case.g.dart',
          outputMatcher: isNot(contains('const Button.solid(')),
        );
      });
    }
  });
}
