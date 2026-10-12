// Run explicitly with `flutter test tool/generate_layout_previews_test.dart`.
// These static home images use the same Mix stylers as their live examples.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_showcase/examples/layouts/flex.dart' as flex;
import 'package:mix_showcase/examples/layouts/grid.dart' as grid;
import 'package:mix_showcase/examples/layouts/wrap.dart' as wrap;

import '../test/layouts/helpers/grid_example_test_fonts.dart';

const _background = Color(0xFFF3F6FA);
const _boundaryKey = Key('preview-boundary');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(loadGridExampleTestFonts);

  final previews = <String, Widget>{
    'flexbox': Center(
      child: FlexBox(
        style: flex.actionRow(direction: Axis.horizontal, briefs: false),
        children: [
          for (final (icon, label) in [
            (Icons.save_outlined, 'Save'),
            (Icons.share_outlined, 'Share'),
            (Icons.archive_outlined, 'Archive'),
          ])
            Box(
              style: flex.actionChip(briefs: false),
              child: FlexBox(
                style: flex.actionBody(briefs: false),
                children: [
                  StyledIcon(icon: icon, style: flex.actionIcon()),
                  StyledText(
                    label,
                    style: flex.actionLabel().fontFamily(
                      gridExampleTestFontFamily,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
    'wrapbox': Center(
      child: SizedBox(
        width: 380,
        child: WrapBox(
          style: wrap.tagCloud(),
          children: [
            for (final label in [
              'Flutter',
              'Mix',
              'Tokens',
              'Variants',
              'Themes',
              'Motion',
            ])
              Box(
                style: wrap.tagChip(),
                child: StyledText(
                  label,
                  style: wrap.tagLabel().fontFamily(gridExampleTestFontFamily),
                ),
              ),
          ],
        ),
      ),
    ),
    'gridbox': Center(
      child: SizedBox(
        width: 420,
        child: GridBox(
          style: grid.responsiveGrid(),
          children: [
            for (final (value, label) in [
              (r'$84.2k', 'Revenue'),
              ('1,429', 'Orders'),
              ('4.86%', 'Conversion'),
              ('8,702', 'Active users'),
            ])
              Box(
                style: grid.gridCard(emphasis: label == 'Revenue'),
                child: FlexBox(
                  style: grid.gridCopy(),
                  children: [
                    StyledText(
                      value,
                      style: grid
                          .gridHeadline(detailed: false)
                          .fontFamily(gridExampleTestFontFamily),
                    ),
                    StyledText(
                      label,
                      style: grid.gridSupport().fontFamily(
                        gridExampleTestFontFamily,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  };

  for (final entry in previews.entries) {
    testWidgets('write ${entry.key} preview', (tester) async {
      await tester.binding.setSurfaceSize(const Size(698, 188));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: gridExampleTestFontFamily),
          home: Material(
            color: _background,
            child: RepaintBoundary(
              key: _boundaryKey,
              child: ColoredBox(color: _background, child: entry.value),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.runAsync(() async {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(_boundaryKey),
        );
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        await File(
          'assets/previews/layouts_${entry.key}.png',
        ).writeAsBytes(data!.buffer.asUint8List());
      });
    });
  }
}
