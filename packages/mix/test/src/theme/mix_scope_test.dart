import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// Tests for [MixScope.inherit], which inherits the nearest ancestor [MixScope]
/// and merges the provided values on top of it (the `DefaultTextStyle.merge`
/// pattern).
void main() {
  group('MixScope.inherit', () {
    const primary = ColorToken('brand.primary');
    const surface = ColorToken('brand.surface');

    testWidgets('inherits ancestor tokens that are not overridden', (
      tester,
    ) async {
      late Color resolvedPrimary;
      late Color resolvedSurface;

      await tester.pumpWidget(
        MixScope(
          colors: {primary: Colors.blue, surface: Colors.white},
          child: MixScope.inherit(
            colors: {primary: Colors.green},
            child: Builder(
              builder: (context) {
                resolvedPrimary = MixScope.tokenOf(primary, context);
                resolvedSurface = MixScope.tokenOf(surface, context);

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedPrimary, Colors.green); // overridden by merge
      expect(resolvedSurface, Colors.white); // inherited from ancestor
    });

    testWidgets('behaves like a plain MixScope when no ancestor exists', (
      tester,
    ) async {
      late Color resolvedPrimary;

      await tester.pumpWidget(
        MixScope.inherit(
          colors: {primary: Colors.green},
          child: Builder(
            builder: (context) {
              resolvedPrimary = MixScope.tokenOf(primary, context);

              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedPrimary, Colors.green);
    });

    testWidgets('orderOfModifiers falls back to the ancestor when omitted', (
      tester,
    ) async {
      const ancestorOrder = <Type>[OpacityModifier, PaddingModifier];
      late List<Type>? resolvedOrder;

      await tester.pumpWidget(
        MixScope(
          orderOfModifiers: ancestorOrder,
          child: MixScope.inherit(
            colors: {primary: Colors.green},
            child: Builder(
              builder: (context) {
                resolvedOrder = MixScope.of(context).orderOfModifiers;

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedOrder, ancestorOrder);
    });

    testWidgets('orderOfModifiers overrides the ancestor when provided', (
      tester,
    ) async {
      const mergeOrder = <Type>[PaddingModifier, OpacityModifier];
      late List<Type>? resolvedOrder;

      await tester.pumpWidget(
        MixScope(
          orderOfModifiers: const [OpacityModifier, PaddingModifier],
          child: MixScope.inherit(
            orderOfModifiers: mergeOrder,
            child: Builder(
              builder: (context) {
                resolvedOrder = MixScope.of(context).orderOfModifiers;

                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(resolvedOrder, mergeOrder);
    });

    testWidgets('renders a token-driven Box using merged + inherited tokens', (
      tester,
    ) async {
      await tester.pumpWidget(
        MixScope(
          colors: {primary: Colors.blue, surface: Colors.white},
          child: MixScope.inherit(
            colors: {primary: Colors.green},
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Box(style: BoxStyler().color(primary())),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, Colors.green);
    });
  });
}
