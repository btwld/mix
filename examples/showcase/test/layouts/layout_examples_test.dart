import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/catalog/catalog.dart';
import 'package:mix_showcase/examples/layouts/flex.dart';
import 'package:mix_showcase/examples/layouts/grid.dart';
import 'package:mix_showcase/examples/layouts/wrap.dart';
import 'package:mix_showcase/showcase/source_panel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('layout excerpts lead with the widget and keep the styler', () async {
    const markers = {
      'FlexBox': 'FlexBoxStyler actionRow',
      'WrapBox': 'WrapBoxStyler tagCloud',
      'GridBox': 'GridBoxStyler responsiveGrid',
    };
    for (final entry in examples.where(
      (example) => example.category == ExampleCategory.layouts,
    )) {
      final full = await rootBundle.loadString(entry.source);
      final visible = widgetExcerpt(full, focusClass: entry.codeFocus);
      final marker = markers[entry.title]!;
      expect(
        visible.indexOf('class ${entry.codeFocus}'),
        lessThan(visible.indexOf('// Supporting styles and values')),
        reason: entry.title,
      );
      expect(
        visible.indexOf('// Supporting styles and values'),
        lessThan(visible.indexOf(marker)),
        reason: entry.title,
      );
      expect(full, contains(marker));
      expect(full, contains('void main()'));
      expect(visible, isNot(contains('void main()')));
    }
  });

  testWidgets('GridBox width and content controls change the layout', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: GridExample())),
    );
    await tester.pump();

    expect(tester.getSize(find.byKey(const Key('grid-layout'))).width, 420);
    expect(_top(tester, 'grid-cell-0').dy, _top(tester, 'grid-cell-1').dy);
    expect(
      _top(tester, 'grid-cell-2').dy,
      greaterThan(_top(tester, 'grid-cell-0').dy),
    );

    await tester.tap(find.text('Wide'));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('grid-layout'))).width, 640);
    expect(_top(tester, 'grid-cell-0').dy, _top(tester, 'grid-cell-1').dy);
    expect(_top(tester, 'grid-cell-0').dy, _top(tester, 'grid-cell-3').dy);

    await tester.tap(find.text('Compact'));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('grid-layout'))).width, 240);
    expect(
      _top(tester, 'grid-cell-1').dy,
      greaterThan(_top(tester, 'grid-cell-0').dy),
    );

    await tester.tap(find.text('Notes'));
    await tester.pump();
    expect(
      find.text('Implicit rows grow with the taller note.'),
      findsOneWidget,
    );
    expect(find.text(r'$84.2k'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('FlexBox direction and content controls change the row', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FlexExample())),
    );
    await tester.pump();

    expect(find.text('Spacing 8'), findsOneWidget);
    expect(_top(tester, 'flex-child-0').dy, _top(tester, 'flex-child-1').dy);

    await tester.tap(find.text('Column'));
    await tester.pump();
    expect(
      _top(tester, 'flex-child-1').dy,
      greaterThan(_top(tester, 'flex-child-0').dy),
    );

    await tester.tap(find.text('Briefs'));
    await tester.pump();
    expect(find.text('Spacing 16'), findsOneWidget);
    expect(find.text('Keep draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [390.0, 800.0]) {
    testWidgets('FlexBox briefs fit at ${width.toInt()}px', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 720));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FlexExample())),
      );
      await tester.tap(find.text('Briefs'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('WrapBox width and content controls change the runs', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WrapExample())),
    );
    await tester.pump();

    expect(tester.getSize(find.byKey(const Key('wrap-layout'))).width, 220);
    expect(find.text('220px offered'), findsOneWidget);
    expect(
      _top(tester, 'wrap-child-5').dy,
      greaterThan(_top(tester, 'wrap-child-0').dy),
    );

    await tester.tap(find.text('Wide'));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('wrap-layout'))).width, 460);
    expect(find.text('460px offered'), findsOneWidget);

    await tester.tap(find.text('Phrases'));
    await tester.pump();
    expect(find.text('Fluent chaining'), findsOneWidget);
    expect(find.text('Flutter'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Offset _top(WidgetTester tester, String key) =>
    tester.getTopLeft(find.byKey(Key(key)));
