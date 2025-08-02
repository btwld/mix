import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('IconThemeModifier', () {
    group('Constructor', () {
      test('assigns data correctly', () {
        const data = IconThemeData(color: Color(0xFF000000), size: 24.0);
        const modifier = IconThemeModifier(data: data);

        expect(modifier.data, data);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated data', () {
        const originalData = IconThemeData(
          color: Color(0xFF000000),
          size: 24.0,
        );
        const updatedData = IconThemeData(color: Color(0xFF0000FF), size: 32.0);
        final original = IconThemeModifier(data: originalData);
        final updated = original.copyWith(data: updatedData);

        expect(updated.data, updatedData);
        expect(updated, isNot(same(original)));
      });

      test('preserves original data when parameter is null', () {
        const originalData = IconThemeData(
          color: Color(0xFF000000),
          size: 24.0,
        );
        const original = IconThemeModifier(data: originalData);
        final updated = original.copyWith();

        expect(updated.data, originalData);
        expect(updated, isNot(same(original)));
      });
    });

    group('lerp', () {
      test('interpolates data correctly', () {
        const startData = IconThemeData(color: Color(0xFF000000), size: 20.0);
        const endData = IconThemeData(color: Color(0xFFFFFFFF), size: 40.0);
        const start = IconThemeModifier(data: startData);
        const end = IconThemeModifier(data: endData);
        final result = start.lerp(end, 0.5);

        expect(result.data.size, 30.0);
        // Use Color.lerp to get the exact expected result
        expect(
          result.data.color,
          Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5),
        );
      });

      test('handles null other parameter', () {
        const data = IconThemeData(color: Color(0xFF000000), size: 24.0);
        const start = IconThemeModifier(data: data);
        final result = start.lerp(null, 0.5);

        expect(result, same(start));
      });
    });

    group('build', () {
      test('wraps child with IconTheme', () {
        const data = IconThemeData(color: Color(0xFF000000), size: 24.0);
        const modifier = IconThemeModifier(data: data);
        const child = SizedBox();

        final result = modifier.build(child);

        expect(result, isA<IconTheme>());
        final iconTheme = result as IconTheme;
        expect(iconTheme.data, data);
        expect(iconTheme.child, child);
      });
    });
  });

  group('IconThemeModifierAttribute', () {
    group('Constructor', () {
      test('assigns properties correctly', () {
        const color = Color(0xFF000000);
        const size = 24.0;
        const opacity = 0.8;
        final attribute = IconThemeModifierAttribute(
          color: color,
          size: size,
          opacity: opacity,
        );

        expect(attribute.color?.$value, color);
        expect(attribute.size?.$value, size);
        expect(attribute.opacity?.$value, opacity);
      });
    });

    group('resolve', () {
      test('creates IconThemeModifier with resolved values', () {
        const color = Color(0xFF000000);
        const size = 24.0;
        const opacity = 0.8;
        final attribute = IconThemeModifierAttribute(
          color: color,
          size: size,
          opacity: opacity,
        );

        final modifier = attribute.resolve(MockBuildContext());

        expect(modifier.data.color, color);
        expect(modifier.data.size, size);
        expect(modifier.data.opacity, opacity);
      });
    });

    group('merge', () {
      test('merges properties correctly', () {
        final first = IconThemeModifierAttribute(
          color: const Color(0xFF000000),
          size: 24.0,
        );
        final second = IconThemeModifierAttribute(
          color: const Color(0xFF0000FF),
          opacity: 0.8,
        );

        final merged = first.merge(second);

        expect(merged.color?.$value, const Color(0xFF0000FF));
        expect(merged.size?.$value, 24.0);
        expect(merged.opacity?.$value, 0.8);
      });

      test('handles null other parameter', () {
        final attribute = IconThemeModifierAttribute(
          color: const Color(0xFF000000),
          size: 24.0,
        );

        final result = attribute.merge(null);

        expect(result, same(attribute));
      });
    });
  });

  group('IconThemeModifierUtility', () {
    late IconThemeModifierUtility<BoxMix> utility;

    setUp(() {
      utility = IconThemeModifierUtility(
        (attr) => BoxMix(modifierConfig: WidgetDecoratorConfig.decorator(attr)),
      );
    });

    test('call creates attribute with all properties', () {
      const color = Color(0xFF000000);
      const size = 24.0;
      const opacity = 0.8;

      final result = utility.call(color: color, size: size, opacity: opacity);

      expect(
        result.$widgetDecoratorConfig?.$decorators?.first,
        isA<IconThemeModifierAttribute>(),
      );
      final attr =
          result.$widgetDecoratorConfig!.$decorators!.first
              as IconThemeModifierAttribute;
      expect(attr.color?.$value, color);
      expect(attr.size?.$value, size);
      expect(attr.opacity?.$value, opacity);
    });

    test('color convenience method works', () {
      const color = Color(0xFF000000);
      final result = utility.color(color);

      expect(
        result.$widgetDecoratorConfig?.$decorators?.first,
        isA<IconThemeModifierAttribute>(),
      );
      final attr =
          result.$widgetDecoratorConfig!.$decorators!.first
              as IconThemeModifierAttribute;
      expect(attr.color?.$value, color);
    });

    test('size convenience method works', () {
      const size = 24.0;
      final result = utility.size(size);

      expect(
        result.$widgetDecoratorConfig?.$decorators?.first,
        isA<IconThemeModifierAttribute>(),
      );
      final attr =
          result.$widgetDecoratorConfig!.$decorators!.first
              as IconThemeModifierAttribute;
      expect(attr.size?.$value, size);
    });

    test('opacity convenience method works', () {
      const opacity = 0.8;
      final result = utility.opacity(opacity);

      expect(
        result.$widgetDecoratorConfig?.$decorators?.first,
        isA<IconThemeModifierAttribute>(),
      );
      final attr =
          result.$widgetDecoratorConfig!.$decorators!.first
              as IconThemeModifierAttribute;
      expect(attr.opacity?.$value, opacity);
    });
  });

  group('Integration', () {
    testWidgets('attribute resolves and builds correctly', (tester) async {
      final attribute = IconThemeModifierAttribute(
        color: const Color(0xFF0000FF),
        size: 32.0,
        opacity: 0.7,
      );
      expect(
        attribute,
        resolvesTo(
          IconThemeModifier(
            data: const IconThemeData(
              color: Color(0xFF0000FF),
              size: 32.0,
              opacity: 0.7,
            ),
          ),
        ),
      );

      final modifier = attribute.resolve(MockBuildContext());
      const child = SizedBox();
      await tester.pumpWithMixScope(modifier.build(child));
      // Find the IconTheme that wraps our SizedBox (the last one in the tree)
      final iconTheme = tester.widget<IconTheme>(find.byType(IconTheme).last);
      expect(iconTheme.data.color, const Color(0xFF0000FF));
      expect(iconTheme.data.size, 32.0);
      expect(iconTheme.data.opacity, 0.7);
      expect(iconTheme.child, isA<SizedBox>());
    });
  });
}
