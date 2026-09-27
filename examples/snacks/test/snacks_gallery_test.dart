import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:example_snacks/gallery/app.dart';
import 'package:example_snacks/gallery/examples.dart';
import 'package:example_snacks/gallery/gallery.dart';
import 'package:example_snacks/gallery/theme.dart';
import 'package:example_snacks/gallery/widgets/demo_card.dart';

import 'helpers/grid_example_test_fonts.dart';
import 'helpers/snacks_test_harness.dart' show pumpBit, keyed, loadSnacksFonts;
import 'helpers/tolerant_golden_file_comparator.dart';

void main() {
  setUpAll(() async {
    await loadGridExampleTestFonts();
    await loadSnacksFonts();
  });
  Future<void> pumpGallery(
    WidgetTester tester, {
    Size size = const Size(1100, 1600),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });
    await tester.pumpWidget(const SnacksGalleryApp());
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('catalog renders all 30 React Bits micro examples', (
    tester,
  ) async {
    await pumpGallery(tester);

    expect(find.byType(GridBox), findsOneWidget);
    expect(find.byType(DemoCard, skipOffstage: false), findsNWidgets(30));
    expect(find.text('Mix Snacks'), findsWidgets);
    expect(find.text('Squish Switch'), findsOneWidget);
    expect(find.text('Branched Menu', skipOffstage: false), findsOneWidget);
    expect(find.text('Slosh Gauge', skipOffstage: false), findsOneWidget);
  });

  testWidgets('all 30 gallery entries point to self-contained snippets', (
    tester,
  ) async {
    await pumpGallery(tester);

    expect(snackDemos, hasLength(30));
    expect(snackDemos.map((demo) => demo.sourceAsset).toSet(), hasLength(30));

    for (final demo in snackDemos) {
      final source = await rootBundle.loadString(demo.sourceAsset);
      expect(
        source,
        anyOf(
          contains("import 'package:flutter/material.dart';"),
          contains("import 'package:flutter/widgets.dart';"),
        ),
      );
      expect(source, contains("import 'package:mix/mix.dart';"));
      expect(source, contains('void main()'));
      expect(source, contains('class ${demo.componentName}'));
      expect(
        RegExp(
          r'''(?:import|export)\s+['"](?!dart:|package:)''',
        ).hasMatch(source),
        isFalse,
        reason: demo.title,
      );
    }
  });

  testWidgets('copy action writes the exact DartPad snippet to clipboard', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    await pumpGallery(tester);

    rootBundle.evict(snackDemos.first.sourceAsset);
    final expected = await rootBundle.loadString(snackDemos.first.sourceAsset);
    await tester.tap(find.byKey(const Key('copy-Squish Switch')));
    await tester.runAsync(() async {
      for (var i = 0; i < 20 && calls.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pump();
    await tester.pump();

    final copyCall = calls.singleWhere(
      (call) => call.method == 'Clipboard.setData',
    );
    final copied =
        (copyCall.arguments as Map<Object?, Object?>)['text']! as String;
    expect(copied, expected);
    expect(copied, contains('void main()'));
    expect(copied, contains('class SquishSwitch'));
    final copyButton = find.byKey(const Key('copy-Squish Switch'));
    expect(
      find.descendant(
        of: copyButton,
        matching: find.byIcon(Icons.check_rounded),
      ),
      findsOneWidget,
    );
    expect(find.text('Copied'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1600));
    expect(
      find.descendant(
        of: copyButton,
        matching: find.byIcon(Icons.content_copy_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('group filters shrink the Mix catalog', (tester) async {
    await pumpGallery(tester);

    await tester.tap(find.text('Actions'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(DemoCard, skipOffstage: false), findsNWidgets(6));
    expect(find.byType(PulseHeart, skipOffstage: false), findsOneWidget);
    expect(find.byType(SquishSwitch), findsNothing);

    await tester.tap(find.text('Controls'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(DemoCard, skipOffstage: false), findsNWidgets(10));
    expect(find.byType(SquishSwitch), findsOneWidget);
  });

  testWidgets('squish switch and pulse heart respond to presses', (
    tester,
  ) async {
    await pumpGallery(tester);

    await tester.tap(find.byKey(const Key('squish-switch')));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byType(SquishSwitch), findsOneWidget);

    await tester.tap(find.text('Actions'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('pulse-heart')));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('129'), findsOneWidget);
  });
  for (final width in [390.0, 1100.0]) {
    testWidgets('all 30 cards fit at width $width', (tester) async {
      await pumpGallery(tester, size: Size(width, 1000));
      for (final demo in snackDemos) {
        final card = find.byKey(Key('demo-${demo.title}'));
        await tester.ensureVisible(card);
        await tester.pump();
        expect(tester.getSize(card).width, lessThanOrEqualTo(width - 48));
        expect(tester.takeException(), isNull, reason: demo.title);
      }
    });
  }

  testWidgets('wide gallery matches golden', (tester) async {
    useTolerantGoldenFileComparator('snacks_gallery_test.dart');
    await tester.binding.setSurfaceSize(const Size(1100, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: snacksMaterialTheme().copyWith(
          textTheme: snacksMaterialTheme().textTheme.apply(
            fontFamily: gridExampleTestFontFamily,
          ),
        ),
        home: MixScope(
          colors: snacksColors(),
          radii: snacksRadii(),
          child: const Scaffold(
            body: RepaintBoundary(
              key: Key('gallery-golden'),
              child: SnacksGalleryScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(
      find.byKey(const Key('gallery-golden')),
      matchesGoldenFile('goldens/snacks_gallery_wide.png'),
    );
  });

  testWidgets('spring check unchecked and checked goldens', (tester) async {
    useTolerantGoldenFileComparator(
      'snacks_gallery_test.dart',
      precisionTolerance: 0.005,
    );
    await pumpBit(tester, const SpringCheck());
    await expectLater(
      keyed('snacks-test-boundary'),
      matchesGoldenFile('goldens/snacks_check_unchecked.png'),
    );
    await tester.tap(keyed('spring-check'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await expectLater(
      keyed('snacks-test-boundary'),
      matchesGoldenFile('goldens/snacks_check_checked.png'),
    );
  });
}
