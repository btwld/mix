import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

/// Two built-ins whose package default order is Padding-outside-Opacity, so a
/// scope or style-local order of `[Opacity, Padding]` is observably different
/// from the default.
WidgetModifierConfig _opacityThenPadding() => WidgetModifierConfig.modifiers([
  OpacityModifierMix(opacity: 0.5),
  PaddingModifierMix(padding: EdgeInsetsGeometryMix.all(10)),
]);

void main() {
  group('Modifier order precedence (resolved list)', () {
    test('package default places Padding outside Opacity', () {
      final types = _opacityThenPadding()
          .resolve(MockBuildContext())
          .map((m) => m.runtimeType)
          .toList();

      expect(types, [PaddingModifier, OpacityModifier]);
    });

    test('nearest MixScope order overrides the package default', () {
      final types = _opacityThenPadding()
          .resolve(
            MockBuildContext(
              orderOfModifiers: const [OpacityModifier, PaddingModifier],
            ),
          )
          .map((m) => m.runtimeType)
          .toList();

      expect(types, [OpacityModifier, PaddingModifier]);
    });

    test('style-local order wins over MixScope order', () {
      final config = _opacityThenPadding().orderOfModifiers(const [
        PaddingModifier,
        OpacityModifier,
      ]);

      final types = config
          .resolve(
            MockBuildContext(
              // Scope asks for the opposite order; local must win.
              orderOfModifiers: const [OpacityModifier, PaddingModifier],
            ),
          )
          .map((m) => m.runtimeType)
          .toList();

      expect(types, [PaddingModifier, OpacityModifier]);
    });

    test('types absent from every order stay stable and appear once', () {
      final config = WidgetModifierConfig.modifiers([
        MouseCursorModifierMix(mouseCursor: SystemMouseCursors.click),
        ScrollViewModifierMix(),
        OpacityModifierMix(opacity: 0.5),
      ]);

      final types = config
          .resolve(MockBuildContext())
          .map((m) => m.runtimeType)
          .toList();

      // Each unlisted type appears exactly once.
      expect(types.where((t) => t == MouseCursorModifier).length, 1);
      expect(types.where((t) => t == ScrollViewModifier).length, 1);
      // A known type is placed by the default order, ahead of unlisted types.
      expect(
        types.indexOf(OpacityModifier),
        lessThan(types.indexOf(MouseCursorModifier)),
      );
      // Unlisted types keep their configured (first-seen) order.
      expect(
        types.indexOf(MouseCursorModifier),
        lessThan(types.indexOf(ScrollViewModifier)),
      );
    });
  });

  group('Modifier order precedence (rendered wrapper tree)', () {
    // list[0] is the outermost wrapper, so it is the ancestor in the tree.
    final opacity = find.byWidgetPredicate(
      (w) => w is Opacity && w.opacity == 0.5,
    );
    final padding = find.byWidgetPredicate(
      (w) => w is Padding && w.padding == const EdgeInsets.all(10),
    );

    Widget build({List<Type>? scopeOrder, List<Type>? localOrder}) {
      var config = _opacityThenPadding();
      if (localOrder != null) config = config.orderOfModifiers(localOrder);

      final consumer = StyleBuilder<BoxSpec>(
        style: BoxStyler()
            .width(100)
            .height(100)
            .color(Colors.blue)
            .wrap(config),
        builder: (context, spec) => Container(
          decoration: spec.decoration,
          constraints: spec.constraints,
        ),
      );

      return MaterialApp(
        home: scopeOrder == null
            ? MixScope.empty(child: consumer)
            : MixScope(orderOfModifiers: scopeOrder, child: consumer),
      );
    }

    testWidgets('default order nests Padding outside Opacity', (tester) async {
      await tester.pumpWidget(build());

      expect(find.descendant(of: padding, matching: opacity), findsOneWidget);
      expect(find.descendant(of: opacity, matching: padding), findsNothing);
    });

    testWidgets('MixScope order changes the actual widget nesting', (
      tester,
    ) async {
      await tester.pumpWidget(
        build(scopeOrder: const [OpacityModifier, PaddingModifier]),
      );

      expect(find.descendant(of: opacity, matching: padding), findsOneWidget);
      expect(find.descendant(of: padding, matching: opacity), findsNothing);
    });

    testWidgets('style-local order overrides scope order in the tree', (
      tester,
    ) async {
      await tester.pumpWidget(
        build(
          scopeOrder: const [OpacityModifier, PaddingModifier],
          localOrder: const [PaddingModifier, OpacityModifier],
        ),
      );

      expect(find.descendant(of: padding, matching: opacity), findsOneWidget);
      expect(find.descendant(of: opacity, matching: padding), findsNothing);
    });
  });

  group('Modifier order aspect precision', () {
    testWidgets(
      'token-only change does not re-resolve; scope order change does',
      (tester) async {
        var buildCount = 0;

        // A modifier-order-only consumer: has modifiers, no style-local order,
        // and uses no tokens — so its only scope dependency is `modifierOrder`.
        final consumer = StyleBuilder<BoxSpec>(
          style: BoxStyler()
              .width(100)
              .height(100)
              .color(Colors.blue)
              .wrap(_opacityThenPadding()),
          builder: (context, spec) {
            buildCount++;

            return Container(
              decoration: spec.decoration,
              constraints: spec.constraints,
            );
          },
        );

        final host = GlobalKey<_ScopeHostState>();
        await tester.pumpWidget(
          MaterialApp(
            home: _ScopeHost(key: host, child: consumer),
          ),
        );
        await tester.pump();

        final afterMount = buildCount;
        expect(afterMount, greaterThan(0));

        // Token-only change must not invalidate a modifier-order-only consumer.
        host.currentState!.update(
          colors: {const ColorToken('brand'): Colors.red},
        );
        await tester.pump();
        expect(
          buildCount,
          afterMount,
          reason: 'token-only change must not re-resolve the consumer',
        );

        // Scope modifier-order change must re-resolve the consumer.
        host.currentState!.update(
          order: const [OpacityModifier, PaddingModifier],
        );
        await tester.pump();
        expect(
          buildCount,
          greaterThan(afterMount),
          reason: 'scope order change must re-resolve the consumer',
        );
      },
    );
  });
}

/// Test host that keeps its [child] instance stable across rebuilds so that
/// changing only the [MixScope]'s tokens/order exercises the inherited-model
/// aspect filter instead of structurally rebuilding the subtree.
class _ScopeHost extends StatefulWidget {
  const _ScopeHost({super.key, required this.child});

  final Widget child;

  @override
  State<_ScopeHost> createState() => _ScopeHostState();
}

class _ScopeHostState extends State<_ScopeHost> {
  Map<ColorToken, Color>? _colors;
  List<Type>? _order;

  void update({Map<ColorToken, Color>? colors, List<Type>? order}) {
    setState(() {
      if (colors != null) _colors = colors;
      if (order != null) _order = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MixScope(
      colors: _colors,
      orderOfModifiers: _order,
      child: widget.child,
    );
  }
}
