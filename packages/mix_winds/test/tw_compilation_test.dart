import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/translate/tw_translator.dart';

void main() {
  group('TwParser compilation', () {
    testWidgets('parse methods delegate to equivalent compiled stylers', (
      tester,
    ) async {
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;

              return const SizedBox();
            },
          ),
        ),
      );

      final parser = TwParser();
      final box = parser.compileBox('p-4 bg-blue-500');
      final flex = parser.compileFlex('flex gap-4 items-center');
      final text = parser.compileText('text-lg font-bold');
      final icon = parser.compileIcon('w-6 text-blue-500');

      expect(
        parser.parseBox('p-4 bg-blue-500').resolve(context).spec,
        box.styler.resolve(context).spec,
      );
      expect(
        parser.parseFlex('flex gap-4 items-center').resolve(context).spec,
        flex.styler.resolve(context).spec,
      );
      expect(
        parser.parseText('text-lg font-bold').resolve(context).spec,
        text.styler.resolve(context).spec,
      );
      expect(
        parser.parseIcon('w-6 text-blue-500').resolve(context).spec,
        icon.styler.resolve(context).spec,
      );
    });

    test('collects diagnostics once and replays both callbacks once', () {
      final structured = <TwDiagnostic>[];
      final legacy = <String>[];
      // ignore: deprecated_member_use_from_same_package
      final compilation = TwParser(
        onDiagnostic: structured.add,
        onUnsupported: legacy.add,
      ).compileBox('z-10 bg-[color:red z-10');

      expect(compilation.diagnostics.map((diagnostic) => diagnostic.token), [
        'bg-[color:red',
        'z-10',
      ]);
      expect(compilation.diagnostics.map((diagnostic) => diagnostic.code), [
        TwDiagnosticCode.invalidCandidate,
        TwDiagnosticCode.unsupportedUtility,
      ]);
      expect(structured.map((diagnostic) => diagnostic.token), [
        'bg-[color:red',
        'z-10',
      ]);
      expect(legacy, ['bg-[color:red', 'z-10']);
    });

    test('compilation deduplicates shared animation diagnostics', () {
      final diagnostics = <TwDiagnostic>[];
      TwParser(
        onDiagnostic: diagnostics.add,
      ).compileBox('bg-[color:red bg-[color:red');

      expect(diagnostics, hasLength(1));
      expect(diagnostics.single.token, 'bg-[color:red');
      expect(diagnostics.single.code, TwDiagnosticCode.invalidCandidate);
    });

    test('attaches animation to every compiled target', () {
      const classes = 'transition duration-300 ease-in-out delay-100';
      final parser = TwParser();
      final expected = CurveAnimationConfig(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        delay: Duration(milliseconds: 100),
      );

      expect(parser.compileBox(classes).styler.$animation, expected);
      expect(parser.compileFlex(classes).styler.$animation, expected);
      expect(parser.compileText(classes).styler.$animation, expected);
      expect(parser.compileIcon(classes).styler.$animation, expected);
      expect(parser.compileIcon(classes).diagnostics, isEmpty);
    });

    test('exposes immutable diagnostics and a read-only plan seam', () {
      final TwCompilation<BoxStyler> compilation = TwParser().compileBox(
        'bg-blue-500',
      );
      const TwLayoutPlan emptyPlan = TwLayoutPlan.empty();

      expect(compilation.layoutPlan.isEmpty, isTrue);
      expect(emptyPlan.isEmpty, isTrue);
      expect(compilation.requiresWidgetRuntime, isFalse);
      expect(
        () => compilation.diagnostics.add(
          const TwDiagnostic(
            token: 'another',
            code: .unsupportedUtility,
            reason: 'Not part of the compilation.',
          ),
        ),
        throwsUnsupportedError,
      );
    });

    test('runtime-only output is detected by the compiled layout plan', () {
      final parser = TwParser();
      final box = parser.compileBox('w-full');
      final flex = parser.compileFlex('flex gap-x-4');
      final implicitFlexAlignment = parser.compileFlex('flex flex-col gap-4');
      final semanticBoxMargin = parser.compileBox('m-8 hover:scale-110');
      final text = parser.compileText('mb-4');
      final icon = parser.compileIcon('me-1');

      expect(box.layoutPlan.isEmpty, isFalse);
      expect(flex.layoutPlan.isEmpty, isFalse);
      expect(implicitFlexAlignment.layoutPlan.isEmpty, isFalse);
      expect(semanticBoxMargin.layoutPlan.isEmpty, isFalse);
      expect(text.layoutPlan.isEmpty, isFalse);
      expect(icon.layoutPlan.isEmpty, isFalse);
      expect([
        ...box.diagnostics,
        ...flex.diagnostics,
        ...implicitFlexAlignment.diagnostics,
        ...semanticBoxMargin.diagnostics,
        ...text.diagnostics,
        ...icon.diagnostics,
      ], isEmpty);
    });

    test('reports widget-layer utilities rejected by the selected target', () {
      final text = TwParser().compileText('w-full');
      final box = TwParser().compileBox('gap-x-4');

      expect(text.diagnostics, hasLength(1));
      expect(text.diagnostics.single.token, 'w-full');
      expect(
        text.diagnostics.single.code,
        TwDiagnosticCode.unsupportedForTarget,
      );
      expect(text.requiresWidgetRuntime, isFalse);

      expect(box.diagnostics, hasLength(1));
      expect(box.diagnostics.single.token, 'gap-x-4');
      expect(
        box.diagnostics.single.code,
        TwDiagnosticCode.unsupportedForTarget,
      );
      expect(box.requiresWidgetRuntime, isFalse);
    });

    test('portable and no-op plan data does not require widget runtime', () {
      final parser = TwParser();
      final compilations = [
        parser.compileBox('h-4'),
        parser.compileBox('max-w-sm'),
        parser.compileFlex('flex flex-col items-center gap-4'),
        parser.compileBox('basis-auto'),
        parser.compileBox('m-0'),
        parser.compileText('m-0'),
        parser.compileIcon('me-0'),
      ];

      for (final compilation in compilations) {
        expect(compilation.diagnostics, isEmpty);
        expect(compilation.requiresWidgetRuntime, isFalse);
      }
    });

    test('rejects widget-layer sizing values without a runtime adaptation', () {
      final compilation = TwParser().compileBox('max-w-full');

      expect(compilation.diagnostics, hasLength(1));
      expect(compilation.diagnostics.single.token, 'max-w-full');
      expect(
        compilation.diagnostics.single.code,
        TwDiagnosticCode.unsupportedValue,
      );
      expect(compilation.requiresWidgetRuntime, isFalse);
    });

    test('unsupported static dimensions do not enter the runtime plan', () {
      for (final token in ['min-h-auto', 'max-w-screen', 'max-h-screen']) {
        final compilation = TwParser().compileBox(token);

        expect(compilation.diagnostics, hasLength(1), reason: token);
        expect(
          compilation.diagnostics.single.code,
          TwDiagnosticCode.unsupportedUtility,
          reason: token,
        );
        expect(compilation.requiresWidgetRuntime, isFalse, reason: token);
      }
    });

    test('reports icon margins missing from the configured spacing scale', () {
      final compilation = TwParser().compileIcon('me-999');

      expect(compilation.diagnostics, hasLength(1));
      expect(compilation.diagnostics.single.token, 'me-999');
      expect(
        compilation.diagnostics.single.code,
        TwDiagnosticCode.unsupportedUtility,
      );
      expect(compilation.requiresWidgetRuntime, isFalse);
    });

    test('ignored important logical margins do not enter the runtime plan', () {
      final compilation = TwParser().compileIcon('!me-1');

      expect(compilation.diagnostics, hasLength(1));
      expect(
        compilation.diagnostics.single.code,
        TwDiagnosticCode.importantModifierIgnored,
      );
      expect(compilation.requiresWidgetRuntime, isFalse);
    });

    testWidgets('widget stylers leave margin to the layout plan', (
      tester,
    ) async {
      final translator = TwTranslator(config: TwConfig.standard());
      final box = translator.compileForWidget('m-4 md:m-8 p-2', .boxOrFlex);
      final flex = translator.compileForWidget(
        'flex m-4 md:m-8 p-2',
        .boxOrFlex,
      );
      final portable = TwParser().compileBox('m-4 md:m-8 p-2');

      expect(box.diagnostics, isEmpty);
      expect(flex.diagnostics, isEmpty);
      expect(box.layoutPlan.isEmpty, isFalse);
      expect(flex.layoutPlan.isEmpty, isFalse);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1024, 768)),
          child: Builder(
            builder: (context) {
              final boxSpec = box.boxStyler!.build(context).spec;
              final flexSpec = flex.flexStyler!.build(context).spec;
              final portableSpec = portable.styler.build(context).spec;

              expect(boxSpec.margin, isNull);
              expect(boxSpec.padding, const EdgeInsets.all(8));
              expect(flexSpec.box?.spec.margin, isNull);
              expect(flexSpec.box?.spec.padding, const EdgeInsets.all(8));
              expect(portableSpec.margin, const EdgeInsets.all(32));

              return const SizedBox();
            },
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    test('internal widget seam infers targets without exposing candidates', () {
      final translator = TwTranslator(config: TwConfig.standard());
      final element = translator.compileForWidget(
        'flex gap-x-4 transition duration-300',
        .boxOrFlex,
      );
      final inline = translator.compileForWidget('p-4 uppercase', .inline);

      expect(element.wantsFlex, isTrue);
      expect(element.flexStyler, isNotNull);
      expect(element.boxStyler, isNull);
      expect(element.flexStyler!.$animation, isNotNull);
      expect(inline.hasBoxUtilities, isTrue);
      expect(inline.boxStyler, isNotNull);
      expect(inline.textStyler, isNotNull);
      expect(element.layoutPlan.isEmpty, isFalse);
      expect(inline.diagnostics, isEmpty);
    });
  });
}
