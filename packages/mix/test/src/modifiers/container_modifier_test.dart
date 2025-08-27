import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('ContainerModifier', () {
    test('can be created with a BoxSpec', () {
      const spec = BoxSpec(padding: EdgeInsets.all(16));
      const modifier = ContainerModifier(spec);

      expect(modifier.spec, equals(spec));
    });

    test('build() creates Container with child', () {
      const spec = BoxSpec(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red),
      );
      const modifier = ContainerModifier(spec);
      const child = Text('Test');

      final result = modifier.build(child);

      expect(result, isA<Container>());
      final container = result as Container;
      expect(container.child, equals(child));
      expect(container.padding, equals(const EdgeInsets.all(16)));
      expect(
        container.decoration,
        equals(const BoxDecoration(color: Colors.red)),
      );
    });

    test('copyWith creates new instance with updated spec', () {
      const spec1 = BoxSpec(padding: EdgeInsets.all(8));
      const spec2 = BoxSpec(padding: EdgeInsets.all(16));
      const modifier1 = ContainerModifier(spec1);

      final modifier2 = modifier1.copyWith(spec: spec2);

      expect(modifier1.spec, equals(spec1));
      expect(modifier2.spec, equals(spec2));
    });
  });

  group('ContainerModifierMix', () {
    testWidgets('resolves to ContainerModifier correctly', (tester) async {
      final spec = BoxMix(
        padding: EdgeInsetsGeometryMix.all(16),
        decoration: DecorationMix.color(Colors.blue),
      );
      final mix = ContainerModifierMix(spec);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final resolved = mix.resolve(context);
              expect(resolved, isA<ContainerModifier>());
              expect(resolved.spec.padding, equals(const EdgeInsets.all(16)));
              return Container();
            },
          ),
        ),
      );
    });

    test('merge combines two ContainerModifierMix instances', () {
      final mix1 = ContainerModifierMix(
        BoxMix(padding: EdgeInsetsGeometryMix.all(8)),
      );
      final mix2 = ContainerModifierMix(
        BoxMix(margin: EdgeInsetsGeometryMix.all(16)),
      );

      final merged = mix1.merge(mix2);

      expect(merged, isA<ContainerModifierMix>());
    });

    test('merge with null returns original', () {
      final mix = ContainerModifierMix(
        BoxMix(padding: EdgeInsetsGeometryMix.all(8)),
      );

      final merged = mix.merge(null);

      expect(merged, equals(mix));
    });
  });
}
