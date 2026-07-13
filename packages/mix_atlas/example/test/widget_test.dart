import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:mix_atlas_example/main.dart';
import 'package:mix_atlas_example/window_config.dart';

void main() {
  test('desktop window configuration has the intended bounds', () {
    expect(atlasWindowOptions.size, atlasInitialWindowSize);
    expect(atlasWindowOptions.minimumSize, atlasMinimumWindowSize);
    expect(atlasMinimumWindowSize, const Size(1040, 700));
    expect(atlasInitialWindowSize, const Size(1280, 800));
  });

  testWidgets('example opens the Atlas catalog viewer', (tester) async {
    await tester.pumpWidget(const AtlasExampleApp());

    expect(find.byType(AtlasCatalogViewer), findsOneWidget);
    expect(find.text('Mix Atlas example'), findsOneWidget);
    expect(find.text('Button'), findsWidgets);
  });
}
