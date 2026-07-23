import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/core/providers/constraint_scope.dart';
// ConstraintVariant is @internal and hidden from mix.dart.
import 'package:mix/src/variants/variant.dart' show ConstraintVariant;

void main() {
  group('ConstraintVariant', () {
    test('factory retains concrete breakpoint and key prefix', () {
      const breakpoint = Breakpoint(minWidth: 100, maxWidth: 560);
      final variant = ContextVariant.constraints(breakpoint);
      final same = ContextVariant.constraints(breakpoint);

      expect(variant, isA<ConstraintVariant>());
      expect((variant as ConstraintVariant).breakpoint, breakpoint);
      expect(variant.key, startsWith('constraints_'));
      expect(variant, same);
      expect(variant.hashCode, same.hashCode);
    });

    test('factory retains token-backed breakpoint', () {
      const token = BreakpointToken('breakpoint.custom');
      final ref = token();
      final variant = ContextVariant.constraints(ref);

      expect(variant, isA<ConstraintVariant>());
      expect((variant as ConstraintVariant).breakpoint, ref);
      expect(variant.key, 'constraints_breakpoint.custom');
    });

    test('differs from BreakpointVariant with same breakpoint', () {
      const breakpoint = Breakpoint(maxWidth: 560);
      final media = ContextVariant.breakpoint(breakpoint);
      final constraints = ContextVariant.constraints(breakpoint);

      expect(media, isNot(constraints));
      expect(media.key, isNot(constraints.key));
    });
  });

  group('ConstraintVariant matching semantics', () {
    testWidgets('matches inclusive maxWidth bounds against offered size', (
      tester,
    ) async {
      const breakpoint = Breakpoint(maxWidth: 560);
      final variant = ContextVariant.constraints(breakpoint);

      // Exactly at bound — inclusive
      await tester.pumpWidget(
        _scopeHarness(
          constraints: const BoxConstraints.tightFor(width: 560, height: 200),
          child: Builder(
            builder: (context) {
              expect(variant.when(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );

      // Just over bound
      await tester.pumpWidget(
        _scopeHarness(
          constraints: const BoxConstraints.tightFor(width: 561, height: 200),
          child: Builder(
            builder: (context) {
              expect(variant.when(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('finite maxWidth does not match unbounded width', (
      tester,
    ) async {
      const breakpoint = Breakpoint(maxWidth: 560);
      final variant = ContextVariant.constraints(breakpoint);

      await tester.pumpWidget(
        _scopeHarness(
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
            maxHeight: 400,
          ),
          child: Builder(
            builder: (context) {
              // biggest.width is infinity → finite maxWidth rule fails
              expect(ConstraintScope.sizeOf(context).width, double.infinity);
              expect(variant.when(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('minWidth matches unbounded width (infinity >= min)', (
      tester,
    ) async {
      const breakpoint = Breakpoint(minWidth: 400);
      final variant = ContextVariant.constraints(breakpoint);

      await tester.pumpWidget(
        _scopeHarness(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Builder(
            builder: (context) {
              expect(variant.when(context), isTrue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('minWidth does not match when offered width is too small', (
      tester,
    ) async {
      const breakpoint = Breakpoint(minWidth: 400);
      final variant = ContextVariant.constraints(breakpoint);

      await tester.pumpWidget(
        _scopeHarness(
          constraints: const BoxConstraints.tightFor(width: 200, height: 100),
          child: Builder(
            builder: (context) {
              expect(variant.when(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('token-backed breakpoint resolves like BreakpointVariant', (
      tester,
    ) async {
      const token = BreakpointToken('test.compact');
      final ref = token();
      final variant = ContextVariant.constraints(ref);

      await tester.pumpWidget(
        MixScope(
          breakpoints: {token: const Breakpoint(maxWidth: 300)},
          child: _scopeHarness(
            constraints: const BoxConstraints.tightFor(
              width: 250,
              height: 100,
            ),
            child: Builder(
              builder: (context) {
                expect(variant.when(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MixScope(
          breakpoints: {token: const Breakpoint(maxWidth: 300)},
          child: _scopeHarness(
            constraints: const BoxConstraints.tightFor(
              width: 350,
              height: 100,
            ),
            child: Builder(
              builder: (context) {
                expect(variant.when(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('onConstraints mixin API', () {
    test('onConstraints attaches ConstraintVariant', () {
      final style = BoxStyler()
          .color(Colors.white)
          .onConstraints(
            const Breakpoint(maxWidth: 560),
            BoxStyler().color(Colors.black),
          );

      expect(style.$variants, isNotNull);
      expect(style.$variants!.length, 1);
      expect(style.$variants!.first.variant, isA<ConstraintVariant>());
      expect(style.hasConstraintVariants, isTrue);
    });

    test('styles without constraint variants report false', () {
      final style = BoxStyler()
          .color(Colors.white)
          .onMobile(BoxStyler().color(Colors.grey));

      expect(style.hasConstraintVariants, isFalse);
    });

    test('nested constraint variants are detected recursively', () {
      // Constraint variant buried under onDark must still be detected.
      final style = BoxStyler().onDark(
        BoxStyler().onConstraints(
          const Breakpoint(maxWidth: 400),
          BoxStyler().width(100),
        ),
      );

      expect(style.hasConstraintVariants, isTrue);
    });

    test('NotVariant wrapping ConstraintVariant is detected', () {
      final constraint = ContextVariant.constraints(
        const Breakpoint(maxWidth: 400),
      );
      final style = BoxStyler().onNot(constraint, BoxStyler().width(50));

      expect(style.hasConstraintVariants, isTrue);
    });
  });

  group('StyleBuilder ConstraintScope insertion', () {
    testWidgets('inserts LayoutBuilder only when constraint variants present', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StyleBuilder<BoxSpec>(
            style: BoxStyler().color(Colors.red),
            builder: (context, spec) => const SizedBox(),
          ),
        ),
      );

      expect(find.byType(LayoutBuilder), findsNothing);
      expect(find.byType(ConstraintScope), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 400),
                      BoxStyler().color(Colors.blue),
                    ),
                builder: (context, spec) => const SizedBox(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(ConstraintScope), findsOneWidget);
    });

    testWidgets('nested detection triggers wrap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler().onDark(
                  BoxStyler().onConstraints(
                    const Breakpoint(maxWidth: 400),
                    BoxStyler().width(10),
                  ),
                ),
                builder: (context, spec) => const SizedBox(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ConstraintScope), findsOneWidget);
    });
  });

  group('precedence and merge with onBreakpoint', () {
    testWidgets('matching constraint branch merges over base', (tester) async {
      Color? resolved;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.blue),
                    ),
                builder: (context, spec) {
                  resolved = (spec.decoration as BoxDecoration?)?.color;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(resolved, Colors.blue);
    });

    testWidgets('non-matching constraint branch leaves base', (tester) async {
      Color? resolved;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 800,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.blue),
                    ),
                builder: (context, spec) {
                  resolved = (spec.decoration as BoxDecoration?)?.color;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(resolved, Colors.red);
    });

    testWidgets('onBreakpoint uses viewport; onConstraints uses offered size', (
      tester,
    ) async {
      // Wide viewport (desktop), narrow offered panel.
      Color? color;
      Axis? direction;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: StyleBuilder<FlexBoxSpec>(
                  style: FlexBoxStyler()
                      .direction(Axis.horizontal)
                      .color(Colors.white)
                      .onBreakpoint(
                        const Breakpoint(maxWidth: 767),
                        FlexBoxStyler().color(Colors.orange),
                      )
                      .onConstraints(
                        const Breakpoint(maxWidth: 560),
                        FlexBoxStyler().direction(Axis.vertical),
                      ),
                  builder: (context, spec) {
                    color = (spec.box?.spec.decoration as BoxDecoration?)
                        ?.color;
                    direction = spec.flex?.spec.direction;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Viewport is 1200 → onBreakpoint(max 767) does not match.
      expect(color, Colors.white);
      // Offered width is 300 → onConstraints(max 560) matches.
      expect(direction, Axis.vertical);
    });

    testWidgets('declaration order: later matching branch wins on conflict', (
      tester,
    ) async {
      Color? resolved;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.blue),
                    )
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.green),
                    ),
                builder: (context, spec) {
                  resolved = (spec.decoration as BoxDecoration?)?.color;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(resolved, Colors.green);
    });
  });

  group('responsive card (Flex direction flip)', () {
    testWidgets(
      'flips direction at boundary; stateful child retains state; independent of onMobile',
      (tester) async {
        final width = ValueNotifier<double>(800);
        final stateKey = GlobalKey<_ToggleProbeState>();

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              // Wide desktop viewport so onMobile stays false.
              data: const MediaQueryData(size: Size(1200, 800)),
              child: Scaffold(
                body: Center(
                  child: ValueListenableBuilder<double>(
                    valueListenable: width,
                    builder: (context, w, _) {
                      return SizedBox(
                        width: w,
                        height: 200,
                        child: FlexBox(
                          style: FlexBoxStyler()
                              .direction(Axis.horizontal)
                              .onConstraints(
                                const Breakpoint(maxWidth: 560),
                                FlexBoxStyler().direction(Axis.vertical),
                              )
                              .onMobile(
                                FlexBoxStyler().color(Colors.purple),
                              ),
                          children: [
                            const SizedBox(
                              key: Key('a'),
                              width: 40,
                              height: 40,
                            ),
                            Expanded(
                              child: _ToggleProbe(key: stateKey),
                            ),
                            const SizedBox(
                              key: Key('b'),
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        // Wide: horizontal.
        var flex = tester.widget<Flex>(find.byType(Flex));
        expect(flex.direction, Axis.horizontal);

        // Mutate child state.
        stateKey.currentState!.toggle();
        await tester.pump();
        expect(stateKey.currentState!.toggled, isTrue);

        // Flip to compact via offered width (viewport still desktop).
        width.value = 400;
        await tester.pumpAndSettle();

        flex = tester.widget<Flex>(find.byType(Flex));
        expect(flex.direction, Axis.vertical);
        // Same State instance retained across direction property change.
        expect(stateKey.currentState!.toggled, isTrue);
        expect(find.byKey(const Key('probe')), findsOneWidget);

        // Purple from onMobile should NOT apply (viewport still desktop).
        for (final element in find.byType(Container).evaluate()) {
          final c = element.widget as Container;
          final decoration = c.decoration;
          if (decoration is BoxDecoration) {
            expect(decoration.color, isNot(Colors.purple));
          }
        }

        width.dispose();
      },
    );
  });

  group('container-query typography (universal variant)', () {
    testWidgets('TextStyler onConstraints changes fontSize', (tester) async {
      double? fontSize;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 100,
              child: StyleBuilder<TextSpec>(
                style: TextStyler()
                    .fontSize(20)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      TextStyler().fontSize(14),
                    ),
                builder: (context, spec) {
                  fontSize = spec.style?.fontSize;
                  return Text('hi', style: spec.style);
                },
              ),
            ),
          ),
        ),
      );

      expect(fontSize, 14);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 800,
              height: 100,
              child: StyleBuilder<TextSpec>(
                style: TextStyler()
                    .fontSize(20)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      TextStyler().fontSize(14),
                    ),
                builder: (context, spec) {
                  fontSize = spec.style?.fontSize;
                  return Text('hi', style: spec.style);
                },
              ),
            ),
          ),
        ),
      );

      expect(fontSize, 20);
    });
  });

  group('styleSpec bypass path', () {
    testWidgets('styleSpec path does not install ConstraintScope', (
      tester,
    ) async {
      final styleWithConstraint = BoxStyler()
          .color(Colors.red)
          .onConstraints(
            const Breakpoint(maxWidth: 560),
            BoxStyler().color(Colors.blue),
          );

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: Box(
                // IdentityStyle has no constraint variants — safe styleSpec path.
                style: const IdentityStyle(BoxSpec()),
                styleSpec: const StyleSpec(
                  spec: BoxSpec(
                    decoration: BoxDecoration(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ConstraintScope), findsNothing);
      expect(styleWithConstraint.hasConstraintVariants, isTrue);
    });

    testWidgets(
      'debug assert when styleSpec used with constraint-variant style',
      (tester) async {
        final style = BoxStyler().onConstraints(
          const Breakpoint(maxWidth: 400),
          BoxStyler().width(10),
        );

        Object? caught;
        final oldOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          caught ??= details.exception;
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Box(
              style: style,
              styleSpec: const StyleSpec(spec: BoxSpec()),
            ),
          ),
        );

        FlutterError.onError = oldOnError;
        // Framework may also store the exception for takeException().
        final exception = tester.takeException() ?? caught;
        expect(exception, isNotNull);
        expect(
          exception.toString(),
          contains('Constraint variants'),
        );
        expect(find.byType(ConstraintScope), findsNothing);
      },
    );
  });

  group('rebuild behavior', () {
    testWidgets('identical constraints do not re-resolve style needlessly', (
      tester,
    ) async {
      var builds = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.blue),
                    ),
                builder: (context, spec) {
                  builds++;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      final buildsAfterFirst = builds;
      expect(buildsAfterFirst, greaterThan(0));

      // Pump again with identical tree — LayoutBuilder should not rebuild
      // builder when constraints are identical.
      await tester.pump();
      expect(builds, buildsAfterFirst);

      // Resize triggers rebuild.
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 250,
              height: 200,
              child: StyleBuilder<BoxSpec>(
                style: BoxStyler()
                    .color(Colors.red)
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      BoxStyler().color(Colors.blue),
                    ),
                builder: (context, spec) {
                  builds++;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(builds, greaterThan(buildsAfterFirst));
    });
  });

  group('intrinsics / dry-layout blast radius', () {
    testWidgets(
      'styles without constraint variants work under IntrinsicHeight',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: IntrinsicHeight(
                child: StyleBuilder<BoxSpec>(
                  style: BoxStyler().color(Colors.red).width(100),
                  builder: (context, spec) {
                    return Container(
                      width: 100,
                      height: 50,
                      color: (spec.decoration as BoxDecoration?)?.color,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(LayoutBuilder), findsNothing);
      },
    );

    testWidgets(
      'constraint-variant style dry layout fails with diagnosable LayoutBuilder error',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: StyleBuilder<BoxSpec>(
                  style: BoxStyler()
                      .color(Colors.red)
                      .onConstraints(
                        const Breakpoint(maxWidth: 560),
                        BoxStyler().color(Colors.blue),
                      ),
                  builder: (context, spec) {
                    return Container(
                      width: 100,
                      height: 50,
                      color: (spec.decoration as BoxDecoration?)?.color,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Live layout succeeds.
        expect(tester.takeException(), isNull);
        expect(find.byType(LayoutBuilder), findsOneWidget);

        final box = tester.renderObject<RenderBox>(find.byType(LayoutBuilder));
        Object? dryError;
        try {
          box.getDryLayout(
            const BoxConstraints.tightFor(width: 300, height: 200),
          );
        } catch (e) {
          dryError = e;
        }

        // Known LayoutBuilder cost — exact failure mode for the spike gate.
        expect(dryError, isNotNull);
        final text = dryError.toString();
        expect(text, contains('does not support dry layout'));
        expect(text, contains('LayoutBuilder'));
      },
    );
  });

  group('detection scan cost', () {
    test('recursive scan over modest nested tree completes quickly', () {
      Style<BoxSpec> style = BoxStyler().color(Colors.white);
      // Build a chain of nested non-constraint variants with one buried
      // constraint variant at the leaves.
      for (var i = 0; i < 20; i++) {
        style = BoxStyler().onDark(style as BoxStyler);
      }
      style = BoxStyler().onDark(
        (style as BoxStyler).onConstraints(
          const Breakpoint(maxWidth: 100),
          BoxStyler().width(1),
        ),
      );

      final sw = Stopwatch()..start();
      var hits = 0;
      for (var i = 0; i < 1000; i++) {
        if (style.hasConstraintVariants) hits++;
      }
      sw.stop();

      expect(hits, 1000);
      // Recursing ~20 deep × 1000 should stay well under a few milliseconds
      // on developer hardware; record ceiling for the spike gate.
      expect(
        sw.elapsedMilliseconds,
        lessThan(100),
        reason:
            'hasConstraintVariants scan took ${sw.elapsedMilliseconds}ms '
            'for 1000 calls over depth-20 tree — consider caching if this fails',
      );
    });
  });
}

Widget _scopeHarness({
  required BoxConstraints constraints,
  required Widget child,
}) {
  return MaterialApp(
    home: ConstraintScope(constraints: constraints, child: child),
  );
}

/// Stateful probe used to verify Element/State retention across flex direction flips.
class _ToggleProbe extends StatefulWidget {
  const _ToggleProbe({super.key});

  @override
  State<_ToggleProbe> createState() => _ToggleProbeState();
}

class _ToggleProbeState extends State<_ToggleProbe> {
  bool toggled = false;

  void toggle() => setState(() => toggled = !toggled);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('probe'),
      width: 40,
      height: 40,
      child: Text(toggled ? 'on' : 'off'),
    );
  }
}
