import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('VariantStyleMixin.applyVariants', () {
    const small = NamedVariant('small');
    const large = NamedVariant('large');
    const primary = NamedVariant('primary');

    test('applies single named variant', () {
      final style = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50))
          .variant(large, BoxStyler().width(200));

      final appliedStyle = style.applyVariants([small]);

      final context = MockBuildContext();
      final result = appliedStyle.build(context);

      expect(result.spec.constraints?.maxWidth, 50);
    });

    test('applies multiple named variants', () {
      final style = BoxStyler()
          .color(Colors.grey)
          .variant(small, BoxStyler().width(50))
          .variant(primary, BoxStyler().color(Colors.blue));

      final appliedStyle = style.applyVariants([small, primary]);

      final context = MockBuildContext();
      final result = appliedStyle.build(context);

      expect(result.spec.constraints?.maxWidth, 50);
      final boxDecoration = result.spec.decoration as BoxDecoration?;
      expect(boxDecoration?.color, Colors.blue);
    });

    test('non-applied variants remain inactive', () {
      final style = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50))
          .variant(large, BoxStyler().width(200));

      final appliedStyle = style.applyVariants([small]);

      final context = MockBuildContext();
      final result = appliedStyle.build(context);

      // Should apply small (50), not large (200)
      expect(result.spec.constraints?.maxWidth, 50);
    });

    test('empty variants list has no effect', () {
      final style = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50));

      final appliedStyle = style.applyVariants([]);

      final context = MockBuildContext();
      final result = appliedStyle.build(context);

      expect(result.spec.constraints?.maxWidth, 100);
    });

    test('merging styles with applied variants preserves variants', () {
      final style1 = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50));

      final style2 = BoxStyler()
          .height(200)
          .variant(primary, BoxStyler().color(Colors.blue));

      final applied1 = style1.applyVariants([small]);
      final applied2 = style2.applyVariants([primary]);
      final merged = applied1.merge(applied2);

      final context = MockBuildContext();
      final result = merged.build(context);

      expect(result.spec.constraints?.maxWidth, 50);
      expect(result.spec.constraints?.maxHeight, 200);
      final boxDecoration = result.spec.decoration as BoxDecoration?;
      expect(boxDecoration?.color, Colors.blue);
    });

    test('applied variants combine with directly passed namedVariants', () {
      final style = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50))
          .variant(large, BoxStyler().height(300));

      // Apply small via applyVariants
      final appliedStyle = style.applyVariants([small]);

      final context = MockBuildContext();
      // Also pass large directly to build
      final result = appliedStyle.build(context, namedVariants: {large});

      // Both should be applied
      expect(result.spec.constraints?.maxWidth, 50);
      expect(result.spec.constraints?.maxHeight, 300);
    });

    testWidgets('works with widget tree', (tester) async {
      final style = BoxStyler()
          .width(100)
          .variant(small, BoxStyler().width(50));

      await tester.pumpWidget(
        MaterialApp(
          home: Box(style: style.applyVariants([small])),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final constraints = container.constraints;

      expect(constraints?.maxWidth, 50);
    });
  });
}
