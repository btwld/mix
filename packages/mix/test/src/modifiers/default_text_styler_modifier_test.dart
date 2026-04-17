import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('DefaultTextStylerModifier', () {
    test('can be created with a TextStyler', () {
      final style = TextStyler(style: TextStyleMix(fontSize: 16));
      final modifier = DefaultTextStylerModifier(style);

      expect(modifier.style, equals(style));
    });

    test('default constructor uses an empty TextStyler', () {
      const modifier = DefaultTextStylerModifier();

      expect(modifier.style, equals(const TextStyler.create()));
    });

    testWidgets('build() wraps child in StyleProvider<TextSpec>', (
      tester,
    ) async {
      final style = TextStyler(style: TextStyleMix(fontSize: 20));
      final modifier = DefaultTextStylerModifier(style);
      const child = SizedBox(key: Key('child'));

      await tester.pumpWidget(MaterialApp(home: modifier.build(child)));

      final provider = tester.widget<StyleProvider<TextSpec>>(
        find.byType(StyleProvider<TextSpec>),
      );
      expect(provider.style, equals(style));
      expect(find.byKey(const Key('child')), findsOneWidget);
    });

    test('copyWith creates new instance with updated style', () {
      final style1 = TextStyler(style: TextStyleMix(fontSize: 12));
      final style2 = TextStyler(style: TextStyleMix(fontSize: 24));
      final modifier1 = DefaultTextStylerModifier(style1);

      final modifier2 = modifier1.copyWith(style: style2);

      expect(modifier1.style, equals(style1));
      expect(modifier2.style, equals(style2));
    });

    test('lerp returns this when other is null', () {
      final modifier = DefaultTextStylerModifier(
        TextStyler(style: TextStyleMix(fontSize: 16)),
      );

      expect(modifier.lerp(null, 0.5), same(modifier));
    });

    test('lerp snaps to this when t < 0.5', () {
      final a = DefaultTextStylerModifier(
        TextStyler(style: TextStyleMix(fontSize: 12)),
      );
      final b = DefaultTextStylerModifier(
        TextStyler(style: TextStyleMix(fontSize: 24)),
      );

      expect(a.lerp(b, 0.49), same(a));
    });

    test('lerp snaps to other when t >= 0.5', () {
      final a = DefaultTextStylerModifier(
        TextStyler(style: TextStyleMix(fontSize: 12)),
      );
      final b = DefaultTextStylerModifier(
        TextStyler(style: TextStyleMix(fontSize: 24)),
      );

      expect(a.lerp(b, 0.5), same(b));
    });
  });

  group('DefaultTextStylerModifierMix', () {
    testWidgets('resolves to DefaultTextStylerModifier with same style', (
      tester,
    ) async {
      final style = TextStyler(style: TextStyleMix(fontSize: 18));
      final mix = DefaultTextStylerModifierMix(style);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final resolved = mix.resolve(context);
              expect(resolved, isA<DefaultTextStylerModifier>());
              expect(resolved.style, equals(style));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('merge combines two instances by merging their TextStylers', () {
      final mix1 = DefaultTextStylerModifierMix(
        TextStyler(style: TextStyleMix(fontSize: 12)),
      );
      final mix2 = DefaultTextStylerModifierMix(
        TextStyler(style: TextStyleMix(color: Colors.red)),
      );

      final merged = mix1.merge(mix2);

      expect(merged, isA<DefaultTextStylerModifierMix>());
      final expectedStyle = TextStyler(
        style: TextStyleMix(fontSize: 12),
      ).merge(TextStyler(style: TextStyleMix(color: Colors.red)));
      expect(merged.style, equals(expectedStyle));
    });

    test('merge with null returns original', () {
      final mix = DefaultTextStylerModifierMix(
        TextStyler(style: TextStyleMix(fontSize: 12)),
      );

      expect(mix.merge(null), equals(mix));
    });

    test('equality based on style field', () {
      final style = TextStyler(style: TextStyleMix(fontSize: 12));
      final mix1 = DefaultTextStylerModifierMix(style);
      final mix2 = DefaultTextStylerModifierMix(style);

      expect(mix1, equals(mix2));
    });
  });

  group('WidgetModifierConfig.defaultTextStyler', () {
    test('factory wraps a DefaultTextStylerModifierMix', () {
      final style = TextStyler(style: TextStyleMix(fontSize: 16));
      final config = WidgetModifierConfig.defaultTextStyler(style);

      expect(config.$modifiers, isNotNull);
      expect(config.$modifiers!.length, equals(1));
      expect(config.$modifiers!.first, isA<DefaultTextStylerModifierMix>());
    });
  });

  group('DefaultTextStylerModifier inheritance', () {
    testWidgets(
      'descendant StyledText inherits style propagated through the modifier',
      (tester) async {
        final inherited = TextStyler(
          style: TextStyleMix(
            fontSize: 24,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Box(
              style: BoxStyler().textStyle(inherited),
              child: const StyledText('hello'),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('hello'));
        expect(textWidget.style?.fontSize, equals(24));
        expect(textWidget.style?.color, equals(Colors.red));
        expect(textWidget.style?.fontWeight, equals(FontWeight.bold));
      },
    );

    testWidgets(
      'descendant StyledText merges its own style on top of the inherited one',
      (tester) async {
        final inherited = TextStyler(
          style: TextStyleMix(fontSize: 24, color: Colors.red),
        );
        final local = TextStyler(style: TextStyleMix(color: Colors.blue));

        await tester.pumpWidget(
          MaterialApp(
            home: Box(
              style: BoxStyler().textStyle(inherited),
              child: StyledText('hello', style: local),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('hello'));
        expect(textWidget.style?.fontSize, equals(24));
        expect(textWidget.style?.color, equals(Colors.blue));
      },
    );
  });
}
