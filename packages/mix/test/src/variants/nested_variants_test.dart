import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test variant keys
final _primaryKey = 'test_primary';
final _secondaryKey = 'test_secondary';
final _tertiaryKey = 'test_tertiary';
final _deepKey = 'test_deep';
final _circularKey = 'test_circular';
final _smallKey = 'test_small';
final _largeKey = 'test_large';
final _activeKey = 'test_active';

/// Primary level StyleVariantMixin - contains secondary level variants
class PrimaryBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _primaryKey;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    final cleanBase = BoxStyler();

    // Primary adapts based on secondary and tertiary keys
    return switch (activeVariants) {
      _
          when activeVariants.contains(_secondaryKey) &&
              activeVariants.contains(_tertiaryKey) =>
        cleanBase.width(300.0).height(300.0).padding(EdgeInsetsMix.all(30)),
      _ when activeVariants.contains(_secondaryKey) =>
        cleanBase.width(200.0).height(200.0).padding(EdgeInsetsMix.all(20)),
      _ when activeVariants.contains(_tertiaryKey) =>
        cleanBase.width(250.0).height(250.0).padding(EdgeInsetsMix.all(25)),
      _ => cleanBase.width(100.0).height(100.0).padding(EdgeInsetsMix.all(10)),
    };
  }
}

/// Secondary level StyleVariantMixin - contains tertiary level variants
class SecondaryBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _secondaryKey;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    final cleanBase = BoxStyler();

    // Secondary adapts based on tertiary and size keys
    return switch (activeVariants) {
      _
          when activeVariants.contains(_tertiaryKey) &&
              activeVariants.contains(_smallKey) =>
        cleanBase.margin(EdgeInsetsMix.all(5)).clipBehavior(Clip.antiAlias),
      _
          when activeVariants.contains(_tertiaryKey) &&
              activeVariants.contains(_largeKey) =>
        cleanBase.margin(EdgeInsetsMix.all(15)).clipBehavior(Clip.hardEdge),
      _ when activeVariants.contains(_tertiaryKey) =>
        cleanBase.margin(EdgeInsetsMix.all(10)).clipBehavior(Clip.none),
      _ when activeVariants.contains(_smallKey) => cleanBase.margin(
        EdgeInsetsMix.all(2),
      ),
      _ => cleanBase.margin(EdgeInsetsMix.all(8)),
    };
  }
}

/// Tertiary level StyleVariantMixin - deepest nesting level
class TertiaryBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _tertiaryKey;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    final cleanBase = BoxStyler();

    // Tertiary adapts based on size and active keys
    return switch (activeVariants) {
      _
          when activeVariants.contains(_smallKey) &&
              activeVariants.contains(_activeKey) =>
        cleanBase.alignment(Alignment.topLeft),
      _
          when activeVariants.contains(_largeKey) &&
              activeVariants.contains(_activeKey) =>
        cleanBase.alignment(Alignment.bottomRight),
      _ when activeVariants.contains(_smallKey) => cleanBase.alignment(
        Alignment.centerLeft,
      ),
      _ when activeVariants.contains(_largeKey) => cleanBase.alignment(
        Alignment.centerRight,
      ),
      _ => cleanBase.alignment(Alignment.center),
    };
  }
}

/// Deep nesting level - for performance testing
class DeepBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  final int level;

  DeepBoxStyler(this.level);

  @override
  String get variantKey => '${_deepKey}_$level';

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    final cleanBase = BoxStyler();

    // Each level adds specific styling based on its depth
    final nextLevel = '${_deepKey}_${level + 1}';
    if (activeVariants.contains(nextLevel)) {
      return cleanBase.padding(EdgeInsetsMix.all(level.toDouble()));
    }

    return cleanBase.margin(EdgeInsetsMix.all(level.toDouble()));
  }
}

/// Circular reference test - attempts to reference itself (should be prevented)
class CircularBoxStyler extends BoxStyler
    with StyleVariantMixin<BoxStyler, BoxSpec> {
  @override
  final variantKey = _circularKey;

  @override
  BoxStyler buildStyle(Set<String> activeVariants) {
    final cleanBase = BoxStyler();

    // This should NOT cause infinite recursion because own key is filtered out
    if (activeVariants.contains(_circularKey)) {
      return cleanBase.width(500.0); // This should never execute
    }

    return cleanBase.width(50.0);
  }
}

void main() {
  group('Nested StyleVariantMixin Tests', () {
    group('Basic Nesting Scenarios', () {
      testWidgets('should handle StyleVariantMixin inside TriggerVariant', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final secondaryStyler = SecondaryBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_secondaryKey, (context) => true),
                    secondaryStyler,
                  ),
                ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_secondaryKey, _tertiaryKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should have margin from secondary's buildStyle
                expect(resolved.margin, EdgeInsets.all(10));
                expect(resolved.clipBehavior, Clip.none);

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle multiple levels of nesting', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();
                final secondaryStyler = SecondaryBoxStyler();
                final tertiaryStyler = TertiaryBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_secondaryKey, (context) => true),
                    secondaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_tertiaryKey, (context) => true),
                    tertiaryStyler,
                  ),
                ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {
                    _primaryKey,
                    _secondaryKey,
                    _tertiaryKey,
                    _smallKey,
                  },
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should combine all three levels
                expect(resolved.constraints?.minWidth, 300.0); // From primary
                expect(resolved.constraints?.maxWidth, 300.0);
                expect(resolved.constraints?.minHeight, 300.0);
                expect(resolved.constraints?.maxHeight, 300.0);
                expect(resolved.padding, EdgeInsets.all(30)); // From primary
                expect(resolved.margin, EdgeInsets.all(5)); // From secondary
                expect(resolved.clipBehavior, Clip.antiAlias); // From secondary
                expect(
                  resolved.alignment,
                  Alignment.centerLeft,
                ); // From tertiary

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Key Aggregation Testing', () {
      testWidgets('should aggregate keys from all nesting levels', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                ]);

                // Test that primary receives aggregated keys (minus its own)
                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {
                    _primaryKey,
                    _secondaryKey,
                    _tertiaryKey,
                    _smallKey,
                    _activeKey,
                  },
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Primary should see secondary and tertiary keys and adapt accordingly
                expect(resolved.constraints?.minWidth, 300.0);
                expect(resolved.constraints?.maxWidth, 300.0);
                expect(resolved.padding, EdgeInsets.all(30));

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should prevent own key in aggregated keys', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final circularStyler = CircularBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_circularKey, (context) => true),
                    circularStyler,
                  ),
                ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_circularKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should NOT execute the circular reference branch
                expect(resolved.constraints?.minWidth, 50.0);
                expect(resolved.constraints?.maxWidth, 50.0);

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Priority System Testing', () {
      testWidgets('should respect priority order in nested variants', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();
                final secondaryStyler = SecondaryBoxStyler();

                final baseStyle = BoxStyler().width(50.0).withVariants([
                  // Lower priority - EventVariantStyle without WidgetState
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_secondaryKey, (context) => true),
                    secondaryStyler,
                  ),
                  // Higher priority - WidgetState variant (should override)
                  EventVariantStyle(
                    ContextTrigger.widgetState(WidgetState.hovered),
                    BoxStyler().width(400.0),
                  ),
                ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_primaryKey, _secondaryKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should have primary's width since no WidgetState is active
                expect(resolved.constraints?.minWidth, 200.0);
                expect(resolved.constraints?.maxWidth, 200.0);

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Circular Reference Prevention', () {
      testWidgets('should prevent infinite recursion with self-reference', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final circularStyler = CircularBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_circularKey, (context) => true),
                    circularStyler,
                  ),
                ]);

                // This should complete without stack overflow
                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_circularKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should use the non-circular branch
                expect(resolved.constraints?.minWidth, 50.0);

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle mutual references between StyleVariantMixins', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();
                final secondaryStyler = SecondaryBoxStyler();

                // Each references the other's key but shouldn't cause infinite loops
                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_secondaryKey, (context) => true),
                    secondaryStyler,
                  ),
                ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_primaryKey, _secondaryKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should resolve without infinite recursion
                expect(resolved.constraints?.minWidth, 200.0);
                expect(
                  resolved.margin,
                  EdgeInsets.all(8),
                ); // Default case since tertiary is not active

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Performance and Deep Nesting', () {
      testWidgets('should handle deep nesting without stack overflow', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Create 10 levels of deep nesting
                final deepStylers = List.generate(10, (i) => DeepBoxStyler(i));
                final variants = deepStylers
                    .map(
                      (styler) => EventVariantStyle(
                        ContextTrigger(styler.variantKey, (context) => true),
                        styler,
                      ),
                    )
                    .toList();

                final baseStyle = BoxStyler().withVariants(variants);

                // Activate all deep levels
                final namedVariants = Set<String>.from(
                  deepStylers.map((s) => s.variantKey),
                );

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: namedVariants,
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should complete without stack overflow
                expect(resolved, isNotNull);

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should perform reasonably with complex nesting', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final stopwatch = Stopwatch()..start();

                final primaryStyler = PrimaryBoxStyler();
                final secondaryStyler = SecondaryBoxStyler();
                final tertiaryStyler = TertiaryBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_secondaryKey, (context) => true),
                    secondaryStyler,
                  ),
                  EventVariantStyle(
                    ContextTrigger(_tertiaryKey, (context) => true),
                    tertiaryStyler,
                  ),
                ]);

                // Resolve with many variants multiple times
                for (int i = 0; i < 100; i++) {
                  baseStyle.build(
                    context,
                    namedVariants: {
                      _primaryKey,
                      _secondaryKey,
                      _tertiaryKey,
                      _smallKey,
                      _activeKey,
                    },
                  );
                }

                stopwatch.stop();

                // Should complete in reasonable time (less than 1 second)
                expect(stopwatch.elapsedMilliseconds, lessThan(1000));

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Edge Cases and Merge Behavior', () {
      testWidgets('should handle empty variant sets correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();

                final baseStyle = BoxStyler().withVariants([
                  EventVariantStyle(
                    ContextTrigger(_primaryKey, (context) => true),
                    primaryStyler,
                  ),
                ]);

                // Test with no named variants
                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should still process primary but with empty active variants
                expect(resolved.constraints?.minWidth, 100.0);

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should merge properties correctly through nesting levels', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();
                final secondaryStyler = SecondaryBoxStyler();

                final baseStyle = BoxStyler()
                    .alignment(Alignment.topCenter) // Base alignment
                    .width(75.0) // Base width (should be overridden)
                    .withVariants([
                      EventVariantStyle(
                        ContextTrigger(_primaryKey, (context) => true),
                        primaryStyler,
                      ),
                      EventVariantStyle(
                        ContextTrigger(_secondaryKey, (context) => true),
                        secondaryStyler,
                      ),
                    ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_primaryKey, _secondaryKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Should merge properly:
                // - Width from primary (overrides base)
                // - Margin from secondary
                // - Alignment from base (not overridden)
                expect(resolved.constraints?.minWidth, 200.0); // From primary
                expect(resolved.margin, EdgeInsets.all(8)); // From secondary
                expect(resolved.alignment, Alignment.topCenter); // From base

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle conflicting properties correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final primaryStyler = PrimaryBoxStyler();

                final baseStyle = BoxStyler()
                    .width(25.0) // Base width
                    .height(25.0) // Base height
                    .withVariants([
                      EventVariantStyle(
                        ContextTrigger(_primaryKey, (context) => true),
                        primaryStyler,
                      ),
                      // This should override primary's settings
                      EventVariantStyle(
                        ContextTrigger.widgetState(WidgetState.hovered),
                        BoxStyler().width(500.0).height(500.0),
                      ),
                    ]);

                final resolvedSpec = baseStyle.build(
                  context,
                  namedVariants: {_primaryKey, _secondaryKey},
                );

                expect(resolvedSpec, isA<StyleSpec<BoxSpec>>());
                final resolved = resolvedSpec.spec;

                // Primary should win since no WidgetState is active
                expect(resolved.constraints?.minWidth, 200.0);
                expect(resolved.constraints?.maxWidth, 200.0);
                expect(resolved.constraints?.minHeight, 200.0);
                expect(resolved.constraints?.maxHeight, 200.0);

                return Container();
              },
            ),
          ),
        );
      });
    });
  });
}
