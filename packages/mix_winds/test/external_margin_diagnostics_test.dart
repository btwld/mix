import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/translate/tw_translator.dart';

void main() {
  final config = TwConfig.standard();

  test('styler targets retain supported margin variants', () {
    for (final classes in ['hover:m-4', 'dark:mx-2', 'md:focus:mt-4']) {
      final parser = TwParser(config: config);
      expect(parser.compileBox(classes).diagnostics, isEmpty);
      expect(parser.compileFlex(classes).diagnostics, isEmpty);
    }
  });

  test('semantic widget targets diagnose unsupported margin variants', () {
    for (final mode in TwWidgetCompilationMode.values) {
      final classes = mode == .icon ? 'hover:me-4' : 'hover:m-4';
      final result = TwTranslator(
        config: config,
      ).compileForWidget(classes, mode);
      expect(result.diagnostics, hasLength(1), reason: mode.name);
      expect(result.diagnostics.single.token, classes);
      expect(
        result.diagnostics.single.code,
        TwDiagnosticCode.widgetLayerVariantUnsupported,
        reason: mode.name,
      );
      expect(result.diagnostics.single.reason, contains('margin'));
      expect(result.diagnostics.single.workaround, isNotEmpty);
    }
  });

  test('text and icon compilation expose the margin variant limitation', () {
    final parser = TwParser(config: config);
    for (final prefix in ['hover', 'dark', 'md:focus', 'not-hover']) {
      for (final compilation in [
        parser.compileText('$prefix:mb-4'),
        parser.compileIcon('$prefix:me-4'),
      ]) {
        expect(compilation.diagnostics, hasLength(1));
        expect(
          compilation.diagnostics.single.code,
          TwDiagnosticCode.widgetLayerVariantUnsupported,
        );
        expect(compilation.requiresWidgetRuntime, isFalse);
      }
    }
  });

  test('margin diagnostics preserve route and value errors', () {
    const cases = {
      'group-hover:m-4': TwDiagnosticCode.contextVariantIgnored,
      '@md:m-4': TwDiagnosticCode.containerVariantIgnored,
      '[&_p]:mt-4': TwDiagnosticCode.arbitraryVariantIgnored,
      'hover:!m-4': TwDiagnosticCode.importantModifierIgnored,
      'hover:m-999': TwDiagnosticCode.unsupportedUtility,
    };
    for (final entry in cases.entries) {
      final result = TwTranslator(
        config: config,
      ).compileForWidget(entry.key, .inline);
      expect(result.diagnostics, hasLength(1), reason: entry.key);
      expect(result.diagnostics.single.code, entry.value, reason: entry.key);
    }
  });

  test('viewport margins and supported padding remain quiet', () {
    final translator = TwTranslator(config: config);
    for (final mode in TwWidgetCompilationMode.values) {
      final classes = mode == .icon ? 'me-2 md:me-4' : 'm-2 md:m-4';
      final result = translator.compileForWidget(classes, mode);
      expect(result.diagnostics, isEmpty, reason: mode.name);
    }
    expect(
      translator.compileForWidget('hover:p-4 dark:p-2', .boxOrFlex).diagnostics,
      isEmpty,
    );
  });

  test('logical icon margins preserve blocking variant diagnostics', () {
    const cases = {
      'group-hover': TwDiagnosticCode.contextVariantIgnored,
      '@md': TwDiagnosticCode.containerVariantIgnored,
      '[&_p]': TwDiagnosticCode.arbitraryVariantIgnored,
      'unknown': TwDiagnosticCode.unsupportedVariant,
    };
    for (final entry in cases.entries) {
      final result = TwParser().compileIcon('${entry.key}:me-4');
      expect(result.diagnostics, hasLength(1), reason: entry.key);
      expect(result.diagnostics.single.code, entry.value, reason: entry.key);
      expect(result.requiresWidgetRuntime, isFalse);
    }
  });

  test('forced flex widgets diagnose external margin variants', () {
    final result = TwTranslator(
      config: config,
    ).compileForWidget('dark:mx-4', .boxOrFlex, forceFlex: true);
    expect(result.flexStyler, isNotNull);
    expect(result.diagnostics, hasLength(1));
    expect(
      result.diagnostics.single.code,
      TwDiagnosticCode.widgetLayerVariantUnsupported,
    );
  });

  testWidgets('prepared children report margin diagnostics once', (
    tester,
  ) async {
    final diagnostics = <TwDiagnostic>[];
    final legacy = <String>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Div(
          classNames: 'flex',
          children: [
            Div(
              classNames: 'hover:m-4 dark:m-2',
              onDiagnostic: diagnostics.add,
              onUnsupported: legacy.add,
              child: const SizedBox(width: 16, height: 16),
            ),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(diagnostics, hasLength(2));
    expect(
      diagnostics.map((diagnostic) => diagnostic.code),
      everyElement(TwDiagnosticCode.widgetLayerVariantUnsupported),
    );
    expect(legacy, diagnostics.map((diagnostic) => diagnostic.token).toList());
    expect(find.byType(Padding), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('negative arbitrary margins never become external padding', (
    tester,
  ) async {
    for (final prefix in ['', 'md:']) {
      for (final child in [
        Div(classNames: '${prefix}mb-[-4px]'),
        P(text: 'Paragraph', classNames: '${prefix}mb-[-4px]'),
        H1(text: 'Heading', classNames: '${prefix}mb-[-4px]'),
        Span(text: 'Inline', classNames: '${prefix}mb-[-4px]'),
        TwIcon(
          const IconData(0xe047, fontFamily: 'MaterialIcons'),
          classNames: '${prefix}me-[-4px]',
        ),
      ]) {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(800, 600)),
            child: Directionality(textDirection: .ltr, child: child),
          ),
        );
        expect(tester.takeException(), isNull, reason: '$child');
        expect(find.byType(Padding), findsNothing, reason: '$child');
      }
    }
  });

  testWidgets('nested margin breakpoints wait for every minimum width', (
    tester,
  ) async {
    for (final width in [800.0, 1024.0]) {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 600)),
          child: const Directionality(
            textDirection: .ltr,
            child: P(text: 'Nested', classNames: 'lg:md:mb-4'),
          ),
        ),
      );
      if (width < 1024) {
        expect(find.byType(Padding), findsNothing);
      } else {
        final padding = tester.widget<Padding>(find.byType(Padding));
        expect(padding.padding, const EdgeInsets.only(bottom: 16));
      }
      expect(tester.takeException(), isNull);
    }
  });
}
