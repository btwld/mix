import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

extension TokenWidgetTester on WidgetTester {
  Future<void> pumpWithTokens(
    Map<MixToken, Object> tokens, {
    required Widget child,
  }) {
    return pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MixScope(tokens: tokens, child: child),
      ),
    );
  }
}

void main() {
  group('TokenStyleMixin', () {
    test('useToken registers a context variant builder', () {
      const colorToken = ColorToken('test.color');
      final style = BoxStyler().useToken(colorToken, BoxStyler().color);

      expect(style.$variants, isNotNull);
      expect(style.$variants, hasLength(1));
      expect(style.$variants!.first.variant, isA<ContextVariantBuilder>());
    });

    testWidgets('resolves token value in widget tree', (tester) async {
      const colorToken = ColorToken('test.primary');
      const tokenColor = Colors.blue;

      final style = BoxStyler().useToken(colorToken, BoxStyler().color);

      await tester.pumpWithTokens({
        colorToken: tokenColor,
      }, child: Box(style: style));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, tokenColor);
    });

    testWidgets('property after useToken takes precedence', (tester) async {
      const colorToken = ColorToken('test.after.token');

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .color(Colors.red);

      await tester.pumpWithTokens({
        colorToken: Colors.green,
      }, child: Box(style: style));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
    });

    testWidgets('property-token-property keeps last property winner', (
      tester,
    ) async {
      const colorToken = ColorToken('test.middle.token');

      final style = BoxStyler()
          .color(Colors.blue)
          .useToken(colorToken, BoxStyler().color)
          .color(Colors.red);

      await tester.pumpWithTokens({
        colorToken: Colors.green,
      }, child: Box(style: style));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
    });

    testWidgets('post-token non-overlapping properties are preserved', (
      tester,
    ) async {
      const colorToken = ColorToken('test.chain.token');
      const testWidth = 123.0;

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .width(testWidth)
          .color(Colors.red);

      await tester.pumpWithTokens({
        colorToken: Colors.green,
      }, child: Box(style: style));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
      expect(container.constraints?.minWidth, testWidth);
      expect(container.constraints?.maxWidth, testWidth);
    });

    testWidgets(
      'nested onBuilder output preserves post-token property precedence',
      (tester) async {
        const colorToken = ColorToken('test.nested.builder.token');

        final style = BoxStyler().onBuilder((context) {
          return BoxStyler()
              .useToken(colorToken, BoxStyler().color)
              .color(Colors.red);
        });

        await tester.pumpWithTokens({
          colorToken: Colors.green,
        }, child: Box(style: style));

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, Colors.red);
      },
    );
  });
}
