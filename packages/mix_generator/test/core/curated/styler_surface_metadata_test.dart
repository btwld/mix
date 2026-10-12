import 'package:mix_generator/src/core/curated/styler_surface_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('styler surface metadata', () {
    test('retargets aliased factory invocations for forwarding anchors', () {
      const descriptor = StylerFactoryDescriptor(
        name: 'visibility',
        signature: 'visibility(bool value)',
        invocation: 'visible(value)',
      );

      expect(descriptor.invocationName, 'visible');
      expect(descriptor.forwardingInvocation, 'visibility(value)');
    });

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
      expect(
        stylerSurfaceFor('WrapBoxStyler')!.generatesAnimateFactory,
        isTrue,
      );

      expect(stylerSurfaceFor('FlexStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('IconStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('ImageStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('StackStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('TextStyler')!.generatesAnimateFactory, isFalse);
      expect(stylerSurfaceFor('WrapStyler')!.generatesAnimateFactory, isFalse);
    });

    test('gates icon single-shadow convenience to IconStyler only', () {
      expect(
        stylerSurfaceFor('IconStyler')!.generatesSingleShadowConvenience,
        isTrue,
      );

      for (final stylerName in [
        'BoxStyler',
        'FlexStyler',
        'ImageStyler',
        'StackStyler',
        'TextStyler',
        'FlexBoxStyler',
        'StackBoxStyler',
        'WrapStyler',
        'WrapBoxStyler',
      ]) {
        expect(
          stylerSurfaceFor(stylerName)!.generatesSingleShadowConvenience,
          isFalse,
          reason: stylerName,
        );
      }
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
      final wrapBox = compoundStylerSurfaceFor('WrapBoxStyler');

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

      expect(wrapBox, isNotNull);
      expect(
        wrapBox!.constructorParamNames,
        orderedEquals([
          'decoration',
          'foregroundDecoration',
          'padding',
          'margin',
          'alignment',
          'constraints',
          'transform',
          'transformAlignment',
          'clipBehavior',
          'direction',
          'wrapAlignment',
          'spacing',
          'runAlignment',
          'runSpacing',
          'crossAxisAlignment',
          'textDirection',
          'verticalDirection',
          'wrapClipBehavior',
        ]),
      );
      expect(
        wrapBox.factoryNames,
        containsAll([
          'alignment',
          'clipBehavior',
          'direction',
          'wrapAlignment',
          'spacing',
          'runAlignment',
          'runSpacing',
          'crossAxisAlignment',
          'textDirection',
          'verticalDirection',
          'wrapClipBehavior',
        ]),
      );
      expect(wrapBox.ownerMixinNames, contains('WrapStyleMixin'));
      expect(wrapBox.methodNames, contains('flow'));
      expect(wrapBox.methodNames, isNot(contains('box')));
    });

    test('contains WrapStyler mixin and alias metadata', () {
      final wrap = stylerSurfaceFor('WrapStyler');

      expect(wrap, isNotNull);
      expect(wrap!.ownerMixinNames, contains('WrapStyleMixin'));
      expect(
        wrap.factoryNames,
        containsAll(['wrapAlignment', 'wrapClipBehavior']),
      );
      expect(wrap.methodNames, contains('flow'));
    });
  });
}
