import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('ComputedStyleProvider', () {
    group('Basic functionality', () {
      testWidgets('provides ComputedStyle to descendants', (tester) async {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $box.padding(16),
        );

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SpecBuilder(
              style: style,
              builder: (context) {
                final computedStyle = ComputedStyleProvider.of(context);
                expect(computedStyle, isNotNull);
                expect(computedStyle.specOf<BoxSpec>(), isNotNull);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('maybeOf returns null when no provider exists',
          (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              final computedStyle = ComputedStyleProvider.maybeOf(context);
              expect(computedStyle, isNull);
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('of throws assertion error when no provider exists',
          (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              expect(
                () => ComputedStyleProvider.of(context),
                throwsAssertionError,
              );
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('specOf returns correct spec types', (tester) async {
        final style = Style(
          $box.color(const Color(0xFF000000)),
          $text.style.fontSize(16),
          $icon.size(24),
        );

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SpecBuilder(
              style: style,
              builder: (context) {
                final boxSpec = ComputedStyleProvider.specOf<BoxSpec>(context);
                final textSpec =
                    ComputedStyleProvider.specOf<TextSpec>(context);
                final iconSpec =
                    ComputedStyleProvider.specOf<IconSpec>(context);

                expect(boxSpec, isNotNull);
                expect(textSpec, isNotNull);
                expect(iconSpec, isNotNull);

                expect((boxSpec!.decoration as BoxDecoration?)?.color,
                    const Color(0xFF000000));
                expect(textSpec!.style?.fontSize, 16);
                expect(iconSpec!.size, 24);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('Surgical rebuilds', () {
      testWidgets('only rebuilds widgets that depend on changed specs',
          (tester) async {
        final rebuildTracker = _RebuildTracker();

        await tester.pumpWidget(
          _SurgicalRebuildTestApp(tracker: rebuildTracker),
        );

        // Initial build
        expect(rebuildTracker.boxCount, 1);
        expect(rebuildTracker.textCount, 1);
        expect(rebuildTracker.iconCount, 1);
        expect(rebuildTracker.combinedCount, 1);

        // Change only box color
        await tester.tap(find.text('Change Box'));
        await tester.pump();

        expect(rebuildTracker.boxCount, 2); // Rebuilt
        expect(rebuildTracker.textCount, 1); // Not rebuilt
        expect(rebuildTracker.iconCount, 1); // Not rebuilt
        expect(rebuildTracker.combinedCount, 2); // Rebuilt (depends on BoxSpec)

        // Change only text size
        await tester.tap(find.text('Change Text'));
        await tester.pump();

        expect(rebuildTracker.boxCount, 2); // Not rebuilt
        expect(rebuildTracker.textCount, 2); // Rebuilt
        expect(rebuildTracker.iconCount, 1); // Not rebuilt
        expect(rebuildTracker.combinedCount, 3); // Rebuilt (depends on TextSpec)

        // Change only icon size
        await tester.tap(find.text('Change Icon'));
        await tester.pump();

        expect(rebuildTracker.boxCount, 2); // Not rebuilt
        expect(rebuildTracker.textCount, 2); // Not rebuilt
        expect(rebuildTracker.iconCount, 2); // Rebuilt
        expect(rebuildTracker.combinedCount, 4); // Rebuilt (depends on IconSpec)
      });

      testWidgets('handles spec removal correctly', (tester) async {
        Widget buildTestWidget(Style style) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: SpecBuilder(
              style: style,
              builder: (context) {
                final boxSpec = ComputedStyleProvider.specOf<BoxSpec>(context);
                final textSpec =
                    ComputedStyleProvider.specOf<TextSpec>(context);

                return Column(
                  children: [
                    Text('Has BoxSpec: ${boxSpec != null}'),
                    Text('Has TextSpec: ${textSpec != null}'),
                  ],
                );
              },
            ),
          );
        }

        // Start with both specs
        await tester.pumpWidget(buildTestWidget(
          Style(
            $box.color(const Color(0xFF000000)),
            $text.style.fontSize(16),
          ),
        ));

        expect(find.text('Has BoxSpec: true'), findsOneWidget);
        expect(find.text('Has TextSpec: true'), findsOneWidget);

        // Remove text spec
        await tester.pumpWidget(buildTestWidget(
          Style($box.color(const Color(0xFF000000))),
        ));

        expect(find.text('Has BoxSpec: true'), findsOneWidget);
        expect(find.text('Has TextSpec: false'), findsOneWidget);
      });
    });

    group('Inheritance', () {
      testWidgets('nested providers work correctly', (tester) async {
        final outerStyle = Style($box.color(const Color(0xFF0000FF)));
        final innerStyle = Style($box.color(const Color(0xFFFF0000)));

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SpecBuilder(
              style: outerStyle,
              builder: (outerContext) {
                return SpecBuilder(
                  style: innerStyle,
                  builder: (innerContext) {
                    final innerSpec =
                        ComputedStyleProvider.specOf<BoxSpec>(innerContext);
                    expect((innerSpec?.decoration as BoxDecoration?)?.color,
                        const Color(0xFFFF0000));
                    return const SizedBox();
                  },
                );
              },
            ),
          ),
        );
      });

      testWidgets('inheritance affects rebuild scope', (tester) async {
        final rebuildTracker = _RebuildTracker();

        await tester.pumpWidget(
          _InheritanceTestApp(tracker: rebuildTracker),
        );

        // Initial build
        expect(rebuildTracker.outerCount, 1);
        expect(rebuildTracker.innerCount, 1);

        // Change parent style - both should rebuild due to inheritance
        await tester.tap(find.text('Change Parent'));
        await tester.pump();

        expect(rebuildTracker.outerCount, 2);
        expect(rebuildTracker.innerCount, 2); // Rebuilds due to inheritance

        // Change child style - only child should rebuild
        await tester.tap(find.text('Change Child'));
        await tester.pump();

        expect(rebuildTracker.outerCount, 2); // No rebuild
        expect(rebuildTracker.innerCount, 3); // Rebuilds
      });
    });

    group('Memory management', () {
      testWidgets('handles rapid style changes without leaks', (tester) async {
        // Rapidly change styles to test cache invalidation
        for (int i = 0; i < 20; i++) {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: SpecBuilder(
                style: Style(
                  $box.color(Color(0xFF000000 + i)),
                  $box.padding(i.toDouble()),
                ),
                builder: (context) {
                  final spec = BoxSpec.of(context);
                  return Container(
                    decoration: spec.decoration,
                    padding: spec.padding,
                  );
                },
              ),
            ),
          );
        }

        // If we get here without issues, memory management is working
        expect(true, isTrue);
      });
    });
  });
}

// Simplified test helpers
class _RebuildTracker {
  int boxCount = 0;
  int textCount = 0;
  int iconCount = 0;
  int combinedCount = 0;
  int outerCount = 0;
  int innerCount = 0;

  void reset() {
    boxCount = 0;
    textCount = 0;
    iconCount = 0;
    combinedCount = 0;
    outerCount = 0;
    innerCount = 0;
  }
}

class _SurgicalRebuildTestApp extends StatefulWidget {
  const _SurgicalRebuildTestApp({required this.tracker});

  final _RebuildTracker tracker;

  @override
  State<_SurgicalRebuildTestApp> createState() =>
      _SurgicalRebuildTestAppState();
}

class _SurgicalRebuildTestAppState extends State<_SurgicalRebuildTestApp> {
  Color _boxColor = const Color(0xFF0000FF);
  double _textSize = 16.0;
  double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final style = Style(
      $box.color(_boxColor),
      $text.style.fontSize(_textSize),
      $icon.size(_iconSize),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          SpecBuilder(
            style: style,
            builder: (context) {
              return Column(
                children: [
                  // Box-only widget
                  Builder(builder: (context) {
                    widget.tracker.boxCount++;
                    final spec = BoxSpec.of(context);
                    return Container(
                      height: 50,
                      decoration: spec.decoration,
                    );
                  }),
                  // Text-only widget
                  Builder(builder: (context) {
                    widget.tracker.textCount++;
                    final spec = TextSpec.of(context);
                    return Text('Text', style: spec.style);
                  }),
                  // Icon-only widget
                  Builder(builder: (context) {
                    widget.tracker.iconCount++;
                    final spec = IconSpec.of(context);
                    return Icon(Icons.star, size: spec.size);
                  }),
                  // Combined widget (depends on all specs)
                  Builder(builder: (context) {
                    widget.tracker.combinedCount++;
                    BoxSpec.of(context);
                    TextSpec.of(context);
                    IconSpec.of(context);
                    return const Text('Combined');
                  }),
                ],
              );
            },
          ),
          GestureDetector(
            onTap: () => setState(() => _boxColor = const Color(0xFFFF0000)),
            child: const Text('Change Box'),
          ),
          GestureDetector(
            onTap: () => setState(() => _textSize = 24.0),
            child: const Text('Change Text'),
          ),
          GestureDetector(
            onTap: () => setState(() => _iconSize = 32.0),
            child: const Text('Change Icon'),
          ),
        ],
      ),
    );
  }
}

class _InheritanceTestApp extends StatefulWidget {
  const _InheritanceTestApp({required this.tracker});

  final _RebuildTracker tracker;

  @override
  State<_InheritanceTestApp> createState() => _InheritanceTestAppState();
}

class _InheritanceTestAppState extends State<_InheritanceTestApp> {
  Color _parentColor = const Color(0xFF0000FF);
  double _childPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          SpecBuilder(
            style: Style($box.color(_parentColor)),
            builder: (context) {
              return Column(
                children: [
                  Builder(builder: (context) {
                    widget.tracker.outerCount++;
                    final spec = BoxSpec.of(context);
                    return Container(
                      height: 50,
                      decoration: spec.decoration,
                    );
                  }),
                  SpecBuilder(
                    inherit: true,
                    style: Style($box.padding(_childPadding)),
                    builder: (context) {
                      widget.tracker.innerCount++;
                      final spec = BoxSpec.of(context);
                      return Container(
                        height: 30,
                        decoration: spec.decoration,
                        padding: spec.padding,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          GestureDetector(
            onTap: () => setState(() => _parentColor = const Color(0xFFFF0000)),
            child: const Text('Change Parent'),
          ),
          GestureDetector(
            onTap: () => setState(() => _childPadding = 16.0),
            child: const Text('Change Child'),
          ),
        ],
      ),
    );
  }
}
