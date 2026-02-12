import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  group('TwConfig.copyWith', () {
    test('preserves unmodified values', () {
      final base = TwConfig.standard();
      final modified = base.copyWith(colors: {'custom': Colors.red});

      expect(modified.space, equals(base.space));
      expect(modified.radii, equals(base.radii));
      expect(modified.borderWidths, equals(base.borderWidths));
      expect(modified.breakpoints, equals(base.breakpoints));
      expect(modified.fontSizes, equals(base.fontSizes));
      expect(modified.durations, equals(base.durations));
      expect(modified.delays, equals(base.delays));
      expect(modified.scales, equals(base.scales));
      expect(modified.rotations, equals(base.rotations));
      expect(modified.blurs, equals(base.blurs));
      expect(modified.textDefaults, equals(base.textDefaults));
    });

    test('overrides specified values', () {
      final modified = TwConfig.standard().copyWith(
        colors: {'brand-500': Colors.purple},
      );

      expect(modified.colorOf('brand-500'), equals(Colors.purple));
    });

    test('allows extending colors with spread operator', () {
      final modified = TwConfig.standard().copyWith(
        colors: {...TwConfig.standard().colors, 'custom-500': Colors.orange},
      );

      // Original color should still exist
      expect(modified.colorOf('blue-500'), isNotNull);
      // New color should also exist
      expect(modified.colorOf('custom-500'), equals(Colors.orange));
    });

    test('overrides multiple values at once', () {
      final modified = TwConfig.standard().copyWith(
        space: {'custom': 999.0},
        radii: {'custom': 50.0},
      );

      expect(modified.spaceOf('custom'), equals(999.0));
      expect(modified.radiusOf('custom'), equals(50.0));
    });

    test('allows overriding text defaults', () {
      final modified = TwConfig.standard().copyWith(
        textDefaults: TwConfig.standard().textDefaults.copyWith(
          fontFamily: 'Inter',
          letterSpacing: 0.02,
          fontSize: 15,
        ),
      );

      expect(modified.textDefaults.fontFamily, equals('Inter'));
      expect(modified.textDefaults.letterSpacing, equals(0.02));
      expect(modified.textDefaults.fontSize, equals(15));
    });

    test('allows clearing font family to platform default', () {
      final defaults = TwConfig.standard().textDefaults;
      final modified = defaults.copyWith(
        fontFamily: null,
        fontFamilyFallback: const [],
      );

      expect(modified.fontFamily, isNull);
      expect(modified.fontFamilyFallback, isEmpty);
    });
  });

  group('TwConfigProvider', () {
    testWidgets('provides config to descendants', (tester) async {
      final customConfig = TwConfig.standard().copyWith(
        colors: {'custom-500': Colors.orange},
      );

      TwConfig? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: TwConfigProvider(
            config: customConfig,
            child: Builder(
              builder: (context) {
                captured = TwConfigProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(captured?.colorOf('custom-500'), equals(Colors.orange));
    });

    testWidgets('falls back to standard when no provider', (tester) async {
      TwConfig? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              captured = TwConfigProvider.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(
        captured!.colorOf('blue-500'),
        equals(TwConfig.standard().colorOf('blue-500')),
      );
    });

    testWidgets('maybeOf returns null when no provider', (tester) async {
      TwConfig? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              captured = TwConfigProvider.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured, isNull);
    });

    testWidgets('maybeOf returns config when provider exists', (tester) async {
      final customConfig = TwConfig.standard().copyWith(
        colors: {'test-color': Colors.green},
      );

      TwConfig? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: TwConfigProvider(
            config: customConfig,
            child: Builder(
              builder: (context) {
                captured = TwConfigProvider.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(captured!.colorOf('test-color'), equals(Colors.green));
    });

    testWidgets('Div uses provider config when no explicit config', (
      tester,
    ) async {
      final customConfig = TwConfig.standard().copyWith(
        colors: {'brand-500': Colors.purple},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TwConfigProvider(
            config: customConfig,
            child: const Div(classNames: 'bg-brand-500', child: Text('Test')),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, equals(Colors.purple));
    });

    testWidgets('Div explicit config overrides provider', (tester) async {
      final providerConfig = TwConfig.standard().copyWith(
        colors: {'brand-500': Colors.purple},
      );
      final explicitConfig = TwConfig.standard().copyWith(
        colors: {'brand-500': Colors.red},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TwConfigProvider(
            config: providerConfig,
            child: Div(
              classNames: 'bg-brand-500',
              config: explicitConfig,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, equals(Colors.red));
    });
  });

  group('TwScope', () {
    testWidgets('applies TwConfig defaults through TextScope', (tester) async {
      final customConfig = TwConfig.standard().copyWith(
        textDefaults: TwConfig.standard().textDefaults.copyWith(
          fontFamily: 'Inter',
          letterSpacing: 0.05,
          lineHeight: 1.7,
          fontSize: 15,
        ),
      );

      late TextStyle resolvedDefaultTextStyle;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TwScope(
            config: customConfig,
            child: Builder(
              builder: (context) {
                expect(TwConfigProvider.of(context), same(customConfig));
                resolvedDefaultTextStyle = DefaultTextStyle.of(context).style;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedDefaultTextStyle.fontFamily, equals('Inter'));
      expect(resolvedDefaultTextStyle.letterSpacing, equals(0.05));
      expect(resolvedDefaultTextStyle.height, equals(1.7));
      expect(resolvedDefaultTextStyle.fontSize, equals(15));
    });

    testWidgets('parser base line-height follows config defaults', (
      tester,
    ) async {
      final customConfig = TwConfig.standard().copyWith(
        textDefaults: TwConfig.standard().textDefaults.copyWith(
          lineHeight: 1.8,
        ),
      );

      late TextStyle parsedTextStyle;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TwScope(
            config: customConfig,
            child: Builder(
              builder: (context) {
                parsedTextStyle = TwParser(
                  config: customConfig,
                ).parseText('').resolve(context).spec.style!;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(parsedTextStyle.height, equals(1.8));
    });
  });

  group('TwConfig.colorOf', () {
    test('applies opacity modifier to known colors', () {
      final config = TwConfig.standard();

      expect(config.colorOf('white/0'), equals(const Color(0x00FFFFFF)));
      expect(config.colorOf('white/50'), equals(const Color(0x80FFFFFF)));
      expect(config.colorOf('white/100'), equals(const Color(0xFFFFFFFF)));
      expect(config.colorOf('blue-500/30'), equals(const Color(0x4D3B82F6)));
    });

    test('returns null for unknown base color with opacity modifier', () {
      final config = TwConfig.standard();

      expect(config.colorOf('missing/50'), isNull);
    });

    test('rejects invalid opacity values', () {
      final config = TwConfig.standard();

      expect(config.colorOf('white/-1'), isNull);
      expect(config.colorOf('white/101'), isNull);
      expect(config.colorOf('white/abc'), isNull);
      expect(config.colorOf('white/'), isNull);
    });
  });
}
