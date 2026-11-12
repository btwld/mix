import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

const _primary = ColorToken('primary');
const _surface = ColorToken('surface');
const _red = Color(0xFFFF0000);
const _blue = Color(0xFF0000FF);
const _order = <Type>[OpacityModifier, PaddingModifier];

// The public-API recipe documented in doc/mix-scope-and-theming.md.
Widget _captureMixScope(BuildContext context, Widget child) {
  final scope = context.getInheritedWidgetOfExactType<MixScope>();
  return scope == null
      ? child
      : MixScope.combine(scopes: [scope], child: child);
}

void main() {
  testWidgets('InheritedTheme.captureAll alone does not capture MixScope', (
    tester,
  ) async {
    late BuildContext source;
    late MixScope? overlayScope;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => MixScope(
                colors: {_primary: _red},
                child: Builder(
                  builder: (context) {
                    source = context;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final content = InheritedTheme.captureAll(
      source,
      Builder(
        builder: (context) {
          overlayScope = MixScope.maybeOf(context);
          return const SizedBox();
        },
      ),
    );
    final entry = OverlayEntry(builder: (_) => content);
    Overlay.of(source).insert(entry);
    await tester.pump();

    expect(overlayScope, isNull);
    entry.remove();
    entry.dispose();
  });

  for (final inherit in [false, true]) {
    testWidgets('reapplies a nested scope with inherit=$inherit', (
      tester,
    ) async {
      late BuildContext source;
      late Color resolvedPrimary;
      Color? resolvedSurface;
      late List<Type>? resolvedOrder;
      final sourceChild = Builder(
        builder: (context) {
          source = context;
          return const SizedBox();
        },
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MixScope(
            colors: {_primary: _blue, _surface: _blue},
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => inherit
                      ? MixScope.inherit(
                          colors: {_primary: _red},
                          orderOfModifiers: _order,
                          child: sourceChild,
                        )
                      : MixScope(
                          colors: {_primary: _red},
                          orderOfModifiers: _order,
                          child: sourceChild,
                        ),
                ),
              ],
            ),
          ),
        ),
      );

      final content = _captureMixScope(
        source,
        Builder(
          builder: (context) {
            resolvedPrimary = _primary.resolve(context);
            resolvedOrder = MixScope.of(
              context,
              'modifierOrder',
            ).orderOfModifiers;
            if (inherit) {
              resolvedSurface = _surface.resolve(context);
            } else {
              expect(() => _surface.resolve(context), throwsStateError);
            }
            return const SizedBox();
          },
        ),
      );
      final entry = OverlayEntry(builder: (_) => content);
      Overlay.of(source).insert(entry);
      await tester.pump();

      expect(resolvedPrimary, _red);
      expect(resolvedSurface, inherit ? _blue : isNull);
      expect(resolvedOrder, _order);
      entry.remove();
      entry.dispose();
    });
  }

  testWidgets('no source scope leaves destination scope available', (
    tester,
  ) async {
    late BuildContext source;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          source = context;
          return const SizedBox();
        },
      ),
    );
    late Color resolved;
    final content = _captureMixScope(
      source,
      Builder(
        builder: (context) {
          resolved = _primary.resolve(context);
          return const SizedBox();
        },
      ),
    );
    await tester.pumpWidget(
      MixScope(colors: {_primary: _blue}, child: content),
    );

    expect(resolved, _blue);
  });

  testWidgets('resolver entries use the destination context', (tester) async {
    late BuildContext source;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MixScope(
          tokens: {
            _primary: (BuildContext context) =>
                Directionality.of(context) == TextDirection.ltr ? _red : _blue,
          },
          child: Builder(
            builder: (context) {
              source = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(_primary.resolve(source), _red);

    late Color resolved;
    final content = _captureMixScope(
      source,
      Builder(
        builder: (context) {
          resolved = _primary.resolve(context);
          return const SizedBox();
        },
      ),
    );
    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.rtl, child: content),
    );

    expect(resolved, _blue);
  });

  testWidgets('recapture retains aspect-dependent notifications', (
    tester,
  ) async {
    late BuildContext source;
    late StateSetter updateSource;
    var color = _red;
    var order = _order;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => StatefulBuilder(
                builder: (_, setState) {
                  updateSource = setState;
                  return MixScope(
                    colors: {_primary: color},
                    orderOfModifiers: order,
                    child: Builder(
                      builder: (context) {
                        source = context;
                        return const SizedBox();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    var tokenBuilds = 0;
    var orderBuilds = 0;
    late Color resolvedColor;
    late List<Type>? resolvedOrder;
    final child = Row(
      children: [
        Builder(
          builder: (context) {
            tokenBuilds++;
            resolvedColor = _primary.resolve(context);
            return const SizedBox();
          },
        ),
        Builder(
          builder: (context) {
            orderBuilds++;
            resolvedOrder = MixScope.of(
              context,
              'modifierOrder',
            ).orderOfModifiers;
            return const SizedBox();
          },
        ),
      ],
    );
    var content = _captureMixScope(source, child);
    final entry = OverlayEntry(builder: (_) => content);
    Overlay.of(source).insert(entry);
    await tester.pump();
    expect((tokenBuilds, orderBuilds), (1, 1));

    updateSource(() => color = _blue);
    await tester.pump();
    expect(
      resolvedColor,
      _red,
    ); // Capturing did not create a live subscription.
    content = _captureMixScope(source, child);
    entry.markNeedsBuild();
    await tester.pump();
    expect(resolvedColor, _blue);
    expect((tokenBuilds, orderBuilds), (2, 1));

    updateSource(() => order = const [PaddingModifier, OpacityModifier]);
    await tester.pump();
    content = _captureMixScope(source, child);
    entry.markNeedsBuild();
    await tester.pump();
    expect(resolvedOrder, order);
    expect((tokenBuilds, orderBuilds), (2, 2));
    entry.remove();
    entry.dispose();
  });
}
