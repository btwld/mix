import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('IdentityStyle', () {
    test('resolves to the provided spec without metadata', () {
      const spec = BoxSpec();
      const style = IdentityStyle<BoxSpec>(spec);

      final resolved = style.resolve(MockBuildContext());

      expect(resolved, const StyleSpec<BoxSpec>(spec: spec));
      expect(resolved.animation, isNull);
      expect(resolved.widgetModifiers, isNull);
    });

    test('merge returns itself when other style is null', () {
      const style = IdentityStyle<BoxSpec>(BoxSpec());

      expect(style.merge(null), same(style));
    });

    test('merge returns other style when provided', () {
      const style = IdentityStyle<BoxSpec>(BoxSpec());
      final other = BoxStyler().color(Colors.red);

      expect(style.merge(other), same(other));
    });

    testWidgets('preserves inherited style when used as a child style', (
      tester,
    ) async {
      final parentStyle = BoxStyler().color(Colors.red);
      const childStyle = IdentityStyle<BoxSpec>(BoxSpec());

      late BoxSpec childSpec;

      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: parentStyle,
            inheritable: true,
            builder: (context, spec) {
              return StyleBuilder<BoxSpec>(
                style: childStyle,
                builder: (context, spec) {
                  childSpec = spec;

                  return const SizedBox();
                },
              );
            },
          ),
        ),
      );

      expect((childSpec.decoration as BoxDecoration?)?.color, Colors.red);
    });

    test('is ignored when merged into an existing VariantStyle', () {
      final style = BoxStyler().color(Colors.red);
      final variant = VariantStyle<BoxSpec>(const NamedVariant('test'), style);
      const identityVariant = VariantStyle<BoxSpec>(
        NamedVariant('test'),
        IdentityStyle<BoxSpec>(BoxSpec()),
      );

      final merged = variant.merge(identityVariant);

      expect(merged.value, same(style));
    });

    test('is ignored when active as a variant style', () {
      final style = BoxStyler(
        decoration: DecorationMix.color(Colors.red),
        variants: const [
          VariantStyle<BoxSpec>(
            NamedVariant('test'),
            IdentityStyle<BoxSpec>(BoxSpec()),
          ),
        ],
      );

      final resolved = style.build(
        MockBuildContext(),
        namedVariants: {const NamedVariant('test')},
      );

      expect((resolved.spec.decoration as BoxDecoration?)?.color, Colors.red);
    });

    test('supports value equality by spec', () {
      const first = IdentityStyle<BoxSpec>(BoxSpec());
      const second = IdentityStyle<BoxSpec>(BoxSpec());

      expect(first, second);
    });
  });
}
