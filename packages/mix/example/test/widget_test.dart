import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_example/main.dart';

void main() {
  testWidgets('shadow gallery renders and resolves token shadows', (
    tester,
  ) async {
    await tester.pumpWidget(const ShadowExampleApp());
    await tester.pumpAndSettle();

    // Section labels are present.
    expect(find.textContaining('Literal box shadows'), findsOneWidget);
    expect(find.textContaining('cardShadow.mix()'), findsWidgets);

    // The token-backed box resolves to a real BoxDecoration with the shadows
    // registered in MixScope (2 box shadows for cardShadow).
    final decorated = tester.widget<Container>(
      find.descendant(
        of: find.byType(Box),
        matching: find.byType(Container),
      ).first,
    );
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow!.isNotEmpty, isTrue);
  });
}
