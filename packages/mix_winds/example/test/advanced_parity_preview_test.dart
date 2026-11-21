import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds_example/advanced_parity_preview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Map<String, Map<int, double>> previewHeights;

  setUpAll(() async {
    final fontLoader = FontLoader('TwParityRoboto')
      ..addFont(rootBundle.load('assets/fonts/roboto/Roboto[wdth,wght].ttf'));
    await fontLoader.load();

    final exampleRoot = _exampleRoot();
    final manifest =
        jsonDecode(
              File(
                '${exampleRoot.path}/web/showcase-manifest.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    previewHeights = {
      for (final example
          in (manifest['examples']! as List<Object?>)
              .cast<Map<String, Object?>>())
        example['id']! as String: {
          for (final entry
              in (example['previewHeights']! as Map<String, Object?>).entries)
            int.parse(entry.key): (entry.value! as num).toDouble(),
        },
    };
  });

  for (final width in [480.0, 768.0, 1024.0]) {
    for (final exampleId in ['01', '02', '03', '04', '05']) {
      testWidgets('advanced example $exampleId renders at ${width.toInt()}px', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 1400);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(_testApp(exampleId));
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(
          find.byKey(ValueKey('advanced-example-$exampleId')),
          findsOneWidget,
        );
        final exampleSize = tester.getSize(
          find.byKey(ValueKey('advanced-example-$exampleId')),
        );
        const wrapperVerticalPadding = 48.0;
        expect(
          previewHeights[exampleId]![width.toInt()]!,
          greaterThanOrEqualTo(exampleSize.height + wrapperVerticalPadding),
          reason:
              'The embedded Flutter host must not clip example $exampleId '
              'at ${width.toInt()}px.',
        );
      });
    }
  }

  testWidgets('signal mobile flex column stretches its cards', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(480, 1400);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_testApp('02'));
    await tester.pump();

    Finder divWithClasses(String classNames) => find.byWidgetPredicate(
      (widget) => widget is Div && widget.classNames == classNames,
    );

    Flex flexUnder(Finder ancestor) => tester.widget<Flex>(
      find.descendant(of: ancestor, matching: find.byType(Flex)).first,
    );

    RenderFlex renderFlexUnder(Finder ancestor) =>
        tester.renderObject<RenderFlex>(
          find.descendant(of: ancestor, matching: find.byType(Flex)).first,
        );

    final frame = find.byKey(const ValueKey('advanced-parity-frame'));
    final cardRoot = find.byKey(const ValueKey('advanced-example-02'));
    final contentColumn = divWithClasses('flex flex-col p-6 md:p-8');

    final responsiveColumn = divWithClasses(
      'mt-8 flex flex-col gap-6 md:flex-row md:items-start',
    );
    final responsiveFlex = flexUnder(responsiveColumn);
    final responsiveRenderFlex = renderFlexUnder(responsiveColumn);

    expect(renderFlexUnder(frame).size.width, 432);
    expect(
      renderFlexUnder(frame).crossAxisAlignment,
      CrossAxisAlignment.center,
    );
    expect(renderFlexUnder(cardRoot).size.width, 430);
    expect(renderFlexUnder(contentColumn).size.width, 382);
    expect(
      renderFlexUnder(contentColumn).crossAxisAlignment,
      CrossAxisAlignment.stretch,
    );
    expect(responsiveRenderFlex.constraints.minWidth, 382);
    expect(responsiveRenderFlex.constraints.maxWidth, 382);
    expect(responsiveRenderFlex.size.width, 382);
    expect(responsiveFlex.direction, Axis.vertical);
    expect(responsiveFlex.crossAxisAlignment, CrossAxisAlignment.stretch);

    for (final classNames in [
      'flex flex-col justify-between gap-6 rounded-2xl bg-blue-600 p-6 md:flex-1',
      'flex flex-1 flex-col gap-4 rounded-2xl border border-slate-200 bg-slate-50 p-5',
    ]) {
      final container = find
          .descendant(
            of: divWithClasses(classNames),
            matching: find.byType(Container),
          )
          .first;
      expect(tester.getSize(container).width, 382);
    }
  });

  testWidgets(
    'capacity mobile cards stretch their full-width progress tracks',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(480, 1400);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_testApp('05'));
      await tester.pump();

      Finder divWithClasses(String classNames) => find.byWidgetPredicate(
        (widget) => widget is Div && widget.classNames == classNames,
      );

      RenderFlex renderFlexUnder(Finder ancestor) =>
          tester.renderObject<RenderFlex>(
            find.descendant(of: ancestor, matching: find.byType(Flex)).first,
          );

      final responsiveColumn = divWithClasses(
        'mt-8 flex flex-col gap-6 md:flex-row md:items-start',
      );
      final cardColumn = divWithClasses('flex flex-1 flex-col gap-4');
      final cards = divWithClasses(
        'flex flex-col gap-4 rounded-2xl bg-slate-50 p-4',
      );
      final tracks = divWithClasses(
        'h-2 w-full overflow-hidden rounded-full bg-slate-200',
      );

      expect(cards, findsNWidgets(3));
      expect(tracks, findsNWidgets(3));

      final responsiveFlex = renderFlexUnder(responsiveColumn);
      expect(responsiveFlex.constraints.minWidth, 382);
      expect(responsiveFlex.constraints.maxWidth, 382);
      expect(responsiveFlex.crossAxisAlignment, CrossAxisAlignment.stretch);

      final cardColumnFlex = renderFlexUnder(cardColumn);
      expect(cardColumnFlex.constraints.minWidth, 382);
      expect(cardColumnFlex.constraints.maxWidth, 382);
      expect(cardColumnFlex.crossAxisAlignment, CrossAxisAlignment.stretch);

      for (var index = 0; index < 3; index++) {
        final cardFlex = renderFlexUnder(cards.at(index));
        final trackContainer = find
            .descendant(of: tracks.at(index), matching: find.byType(Container))
            .first;

        expect(cardFlex.constraints.minWidth, 350, reason: 'card $index');
        expect(cardFlex.constraints.maxWidth, 350, reason: 'card $index');
        expect(
          cardFlex.crossAxisAlignment,
          CrossAxisAlignment.stretch,
          reason: 'card $index',
        );
        expect(
          tester.getSize(trackContainer).width,
          cardFlex.size.width,
          reason: 'progress track $index must fill its card inner width',
        );
      }
    },
  );

  testWidgets('each HTML and Flutter fixture has the same element sequence', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 1400);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final exampleRoot = _exampleRoot();
    final htmlSource = File(
      '${exampleRoot.path}/real_tailwind/advanced-examples.html',
    ).readAsStringSync();
    const examples = {
      '01': 'launch-command',
      '02': 'signal-analytics',
      '03': 'incident-room',
      '04': 'release-timeline',
      '05': 'capacity-map',
    };
    const frameClasses = 'flex w-full flex-col items-center gap-8 p-6';

    for (final entry in examples.entries) {
      await tester.pumpWidget(_testApp(entry.key));
      await tester.pump();

      final flutterElements = tester.allWidgets
          .map(_showcaseElementOf)
          .whereType<String>()
          .toList();
      final region = _extractHtmlShowcaseRegion(htmlSource, entry.value);
      final htmlElements = [
        'Div|$frameClasses',
        ...RegExp(
          r'<(section|article|div|button|p|span|h1|h2|h3)\b[^>]*data-parity-class[^>]*class="([^"]+)"[^>]*>',
          multiLine: true,
        ).allMatches(region).map((match) {
          final widget = switch (match.group(1)) {
            'button' => 'Button',
            'p' => 'P',
            'span' => 'Span',
            'h1' => 'H1',
            'h2' => 'H2',
            'h3' => 'H3',
            _ => 'Div',
          };
          return '$widget|${_normalizeClasses(match.group(2)!)}';
        }),
      ];

      expect(
        flutterElements,
        htmlElements,
        reason:
            'Element or utility drift in advanced example '
            '${entry.key} (${entry.value})',
      );
    }
  });
}

Directory _exampleRoot() {
  return Directory.current.path.endsWith('/example')
      ? Directory.current
      : Directory('${Directory.current.path}/example');
}

Widget _testApp(String exampleId) {
  final baseConfig = TwConfig.standard();
  return WidgetsApp(
    color: const Color(0xFFF1F5F9),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        return builder(context);
      },
    ),
    home: TwScope(
      config: baseConfig.copyWith(
        textDefaults: baseConfig.textDefaults.copyWith(
          fontFamily: 'TwParityRoboto',
          fontFamilyFallback: const [],
        ),
      ),
      child: SingleChildScrollView(
        child: AdvancedParityPreview(exampleId: exampleId),
      ),
    ),
  );
}

String? _showcaseElementOf(Widget widget) {
  final element = switch (widget) {
    Div(:final classNames) => ('Div', classNames),
    Button(:final classNames) => ('Button', classNames),
    P(:final classNames) => ('P', classNames),
    Span(:final classNames) => ('Span', classNames),
    H1(:final classNames) => ('H1', classNames),
    H2(:final classNames) => ('H2', classNames),
    H3(:final classNames) => ('H3', classNames),
    H4(:final classNames) => ('H4', classNames),
    H5(:final classNames) => ('H5', classNames),
    H6(:final classNames) => ('H6', classNames),
    _ => null,
  };
  if (element == null) return null;
  final (name, classNames) = element;
  if (classNames.trim().isEmpty) return null;
  return '$name|${_normalizeClasses(classNames)}';
}

String _normalizeClasses(String value) {
  return value.trim().split(RegExp(r'\s+')).join(' ');
}

String _extractHtmlShowcaseRegion(String source, String region) {
  final startMarker = '<!-- showcase:start $region -->';
  final endMarker = '<!-- showcase:end $region -->';
  final start = source.indexOf(startMarker);
  final end = source.indexOf(endMarker, start + startMarker.length);
  if (start < 0 || end < 0) {
    throw StateError('Missing HTML showcase region $region.');
  }
  return source.substring(start + startMarker.length, end);
}
