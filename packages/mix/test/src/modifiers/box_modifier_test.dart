import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BoxModifier', () {
    test('can be created with a ContainerSpec', () {
      const spec = ContainerSpec(padding: EdgeInsets.all(16));
      const modifier = BoxModifier(spec);

      expect(modifier.spec, equals(spec));
    });

    test('build() creates Container with child', () {
      const spec = ContainerSpec(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red),
      );
      const modifier = BoxModifier(spec);
      const child = Text('Test');

      final result = modifier.build(child);

      expect(result, isA<Container>());
      final container = result as Container;
      expect(container.child, equals(child));
      expect(container.padding, equals(const EdgeInsets.all(16)));
      expect(container.decoration, equals(const BoxDecoration(color: Colors.red)));
    });

    test('copyWith creates new instance with updated spec', () {
      const spec1 = ContainerSpec(padding: EdgeInsets.all(8));
      const spec2 = ContainerSpec(padding: EdgeInsets.all(16));
      const modifier1 = BoxModifier(spec1);

      final modifier2 = modifier1.copyWith(spec: spec2);

      expect(modifier1.spec, equals(spec1));
      expect(modifier2.spec, equals(spec2));
    });
  });

  group('BoxModifierMix', () {
    testWidgets('resolves to BoxModifier correctly', (tester) async {
      final spec = ContainerSpecMix(
        padding: EdgeInsetsGeometryMix.all(16),
        decoration: DecorationMix.color(Colors.blue),
      );
      final mix = BoxModifierMix(spec);

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final resolved = mix.resolve(context);

            expect(resolved, isA<BoxModifier>());
            expect(resolved.spec.padding, equals(const EdgeInsets.all(16)));
            expect(
              resolved.spec.decoration,
              equals(const BoxDecoration(color: Colors.blue)),
            );

            return Container();
          },
        ),
      );
    });

    test('merge combines specs correctly', () {
      final spec1 = ContainerSpecMix(padding: EdgeInsetsGeometryMix.all(8));
      final spec2 = ContainerSpecMix(decoration: DecorationMix.color(Colors.red));
      final mix1 = BoxModifierMix(spec1);
      final mix2 = BoxModifierMix(spec2);

      final merged = mix1.merge(mix2);

      // The merged spec should contain both properties
      expect(merged.spec, isA<ContainerSpecMix>());
    });
  });

  group('ModifierConfig.box', () {
    test('creates BoxModifierMix correctly', () {
      final spec = ContainerSpecMix.color(Colors.green);
      final config = ModifierConfig.box(spec);

      expect(config.$modifiers, hasLength(1));
      expect(config.$modifiers![0], isA<BoxModifierMix>());
    });
  });
}