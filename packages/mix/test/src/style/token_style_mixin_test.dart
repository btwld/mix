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

    testWidgets('explicit merge after useToken preserves declaration order', (
      tester,
    ) async {
      const colorToken = ColorToken('test.explicit.merge.token');

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .merge(BoxStyler().color(Colors.red));

      await tester.pumpWithTokens({
        colorToken: Colors.green,
      }, child: Box(style: style));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
    });

    testWidgets('post-token animation and modifiers are preserved', (
      tester,
    ) async {
      const colorToken = ColorToken('test.animation.modifier.token');
      const animation = CurveAnimationConfig(
        duration: Duration(milliseconds: 120),
        curve: Curves.linear,
      );

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .animate(animation)
          .wrap(WidgetModifierConfig.opacity(0.5));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MixScope(
            tokens: {colorToken: Colors.green},
            child: Builder(
              builder: (context) {
                final built = style.build(context);
                expect(built.animation, animation);
                expect(built.widgetModifiers, isNotNull);
                expect(built.widgetModifiers, isNotEmpty);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('useToken chain composes with onHovered priority', (
      tester,
    ) async {
      const colorToken = ColorToken('test.hovered.token');

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .color(Colors.red)
          .onHovered(BoxStyler().color(Colors.blue));

      Future<void> pumpWithStates(Set<WidgetState> states) {
        return tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MixScope(
              tokens: {colorToken: Colors.green},
              child: WidgetStateProvider(
                states: states,
                child: Box(style: style),
              ),
            ),
          ),
        );
      }

      await pumpWithStates({WidgetState.hovered});

      var container = tester.widget<Container>(find.byType(Container));
      var decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.blue);

      await pumpWithStates(<WidgetState>{});

      container = tester.widget<Container>(find.byType(Container));
      decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
    });

    testWidgets('useToken chain composes with onDark priority', (tester) async {
      const colorToken = ColorToken('test.dark.token');

      final style = BoxStyler()
          .useToken(colorToken, BoxStyler().color)
          .color(Colors.red)
          .onDark(BoxStyler().color(Colors.black));

      Future<void> pumpWithBrightness(Brightness brightness) {
        return tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MixScope(
                tokens: {colorToken: Colors.green},
                child: Box(style: style),
              ),
            ),
          ),
        );
      }

      await pumpWithBrightness(Brightness.dark);

      var container = tester.widget<Container>(find.byType(Container));
      var decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.black);

      await pumpWithBrightness(Brightness.light);

      container = tester.widget<Container>(find.byType(Container));
      decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.red);
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
