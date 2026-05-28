import 'package:mix_generator/src/core/curated/styler_surface_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('styler surface metadata', () {
    test(
      'contains the complete handwritten TextStyler convenience surface',
      () {
        final surface = stylerSurfaceFor('TextStyler');

        expect(surface, isNotNull);
        expect(
          surface!.factoryNames,
          containsAll([
            'color',
            'fontSize',
            'fontFamilyFallback',
            'fontFeatures',
            'fontVariations',
            'foreground',
            'background',
            'shadow',
            'shadows',
          ]),
        );
      },
    );

    test('gates static animate factories to handwritten parity stylers', () {
      expect(stylerSurfaceFor('BoxStyler')!.generatesAnimateFactory, isTrue);
      expect(
        stylerSurfaceFor('FlexBoxStyler')!.generatesAnimateFactory,
        isTrue,
      );
      expect(
        stylerSurfaceFor('StackBoxStyler')!.generatesAnimateFactory,
        isTrue,
      );

      expect(stylerSurfaceFor('FlexStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('IconStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('ImageStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('StackStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('TextStyler')!.generatesAnimateFactory, isFalse);
    });

    test('documents generated-only direct factories that are suppressed', () {
      expect(
        suppressedFieldFactoryNamesFor('IconStyler'),
        contains('semanticsLabel'),
      );
      expect(
        suppressedFieldFactoryNamesFor('ImageStyler'),
        containsAll(['semanticLabel', 'excludeFromSemantics']),
      );
      expect(
        suppressedFieldFactoryNamesFor('TextStyler'),
        contains('semanticsLabel'),
      );
    });

    test('contains compound metadata for nested styler delegation', () {
      final flexBox = compoundStylerSurfaceFor('FlexBoxStyler');
      final stackBox = compoundStylerSurfaceFor('StackBoxStyler');

      expect(flexBox, isNotNull);
      expect(
        flexBox!.constructorParamNames,
        containsAll(['alignment', 'padding', 'direction', 'spacing']),
      );
      expect(
        flexBox.factoryNames,
        containsAll(['alignment', 'padding', 'direction']),
      );
      expect(
        stylerSurfaceFor('FlexBoxStyler')!.factoryNames,
        containsAll(['row', 'column']),
      );
      expect(flexBox.methodNames, contains('transformAlignment'));
      expect(flexBox.methodNames, isNot(contains('box')));
      expect(flexBox.methodNames, isNot(contains('flexClipBehavior')));

      expect(stackBox, isNotNull);
      expect(
        stackBox!.factoryNames,
        containsAll(['alignment', 'padding', 'stackAlignment', 'fit']),
      );
      expect(stackBox.methodNames, containsAll(['stack', 'stackClipBehavior']));
      expect(stackBox.methodNames, isNot(contains('box')));
    });
  });
}
