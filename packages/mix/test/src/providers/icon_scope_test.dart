import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('IconScope', () {
    testWidgets('provides icon data to descendants', (tester) async {
      final icon = IconStyler(
        size: 24.0,
        color: Colors.blue,
        weight: 400.0,
        fill: 1.0,
      );

      late IconStyler capturedScope;

      await tester.pumpWidget(
        IconScope(
          icon: icon,
          child: Builder(
            builder: (context) {
              capturedScope = IconScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedScope, isNotNull);
      expect(capturedScope, equals(icon));
    });

    testWidgets('maybeOf returns null when no scope found', (tester) async {
      IconStyler? capturedScope;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedScope = IconScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(capturedScope, isNull);
    });

    testWidgets('of throws assertion error when no scope found', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => IconScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('wraps child with IconTheme', (tester) async {
      final icon = IconStyler(
        size: 32.0,
        color: Colors.red,
        weight: 700.0,
        fill: 0.5,
        grade: 200.0,
        opticalSize: 48.0,
        opacity: 0.8,
        shadows: [ShadowMix(color: Colors.black, offset: const Offset(1, 1))],
        applyTextScaling: false,
      );

      await tester.pumpWidget(
        IconScope(
          icon: icon,
          child: Builder(
            builder: (context) {
              final iconTheme = IconTheme.of(context);
              expect(iconTheme.size, 32.0);
              expect(iconTheme.color, Colors.red);
              expect(iconTheme.weight, 700.0);
              expect(iconTheme.fill, 0.5);
              expect(iconTheme.grade, 200.0);
              expect(iconTheme.opticalSize, 48.0);
              expect(iconTheme.opacity, 0.8);
              expect(iconTheme.shadows, isNotNull);
              expect(iconTheme.shadows!.length, 1);
              expect(iconTheme.applyTextScaling, false);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('notifies dependents when icon changes', (tester) async {
      final icon1 = IconStyler(size: 16.0);
      final icon2 = IconStyler(size: 24.0);
      var dependencyChanges = 0;

      await tester.pumpWidget(
        IconScope(
          icon: icon1,
          child: _IconDependencyProbe(
            key: const Key('icon-probe'),
            onDependenciesChanged: () => dependencyChanges++,
            child: const SizedBox(),
          ),
        ),
      );

      expect(dependencyChanges, 1);

      await tester.pumpWidget(
        IconScope(
          icon: icon2,
          child: _IconDependencyProbe(
            key: const Key('icon-probe'),
            onDependenciesChanged: () => dependencyChanges++,
            child: const SizedBox(),
          ),
        ),
      );

      expect(dependencyChanges, 2);
    });

    testWidgets('does not notify dependents when icon is same', (
      tester,
    ) async {
      final icon = IconStyler(size: 16.0);
      var dependencyChanges = 0;

      await tester.pumpWidget(
        IconScope(
          icon: icon,
          child: _IconDependencyProbe(
            key: const Key('icon-probe'),
            onDependenciesChanged: () => dependencyChanges++,
            child: const SizedBox(),
          ),
        ),
      );

      expect(dependencyChanges, 1);

      await tester.pumpWidget(
        IconScope(
          icon: icon,
          child: _IconDependencyProbe(
            key: const Key('icon-probe'),
            onDependenciesChanged: () => dependencyChanges++,
            child: const SizedBox(),
          ),
        ),
      );

      expect(dependencyChanges, 1);
    });

    testWidgets('handles null icon properties', (tester) async {
      final icon = IconStyler();

      await tester.pumpWidget(
        MaterialApp(
          home: IconScope(
            icon: icon,
            child: Builder(
              builder: (context) {
                final iconTheme = IconTheme.of(context);
                // IconTheme.of(context) may have default values from MaterialApp
                // Just verify that IconScope is providing the theme
                expect(iconTheme, isNotNull);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    group('nested scopes', () {
      testWidgets('inner scope overrides outer scope', (tester) async {
        final outerIcon = IconStyler(size: 48.0);
        final innerIcon = IconStyler(size: 24.0);

        late IconStyler capturedScope;

        await tester.pumpWidget(
          MaterialApp(
            home: IconScope(
              icon: outerIcon,
              child: IconScope(
                icon: innerIcon,
                child: Builder(
                  builder: (context) {
                    capturedScope = IconScope.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        // Inner scope should be accessible, not outer
        expect(capturedScope, equals(innerIcon));
        expect(capturedScope, isNot(equals(outerIcon)));
      });

      testWidgets('inner IconTheme overrides outer', (tester) async {
        final outerIcon = IconStyler(size: 48.0);
        final innerIcon = IconStyler(size: 24.0);

        await tester.pumpWidget(
          MaterialApp(
            home: IconScope(
              icon: outerIcon,
              child: IconScope(
                icon: innerIcon,
                child: Builder(
                  builder: (context) {
                    final iconTheme = IconTheme.of(context);
                    expect(iconTheme.size, 24.0);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      });

      testWidgets('scope is accessible at multiple nesting depths', (
        tester,
      ) async {
        final icon = IconStyler(size: 32.0, color: Colors.green);
        late IconStyler capturedScope;

        await tester.pumpWidget(
          MaterialApp(
            home: IconScope(
              icon: icon,
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          capturedScope = IconScope.of(context);
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(capturedScope, equals(icon));
      });
    });
  });
}

class _IconDependencyProbe extends StatefulWidget {
  const _IconDependencyProbe({
    required this.onDependenciesChanged,
    required this.child,
    super.key,
  });

  final VoidCallback onDependenciesChanged;
  final Widget child;

  @override
  State<_IconDependencyProbe> createState() => _IconDependencyProbeState();
}

class _IconDependencyProbeState extends State<_IconDependencyProbe> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDependenciesChanged();
  }

  @override
  Widget build(BuildContext context) {
    IconScope.of(context);
    return widget.child;
  }
}
