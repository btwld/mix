import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Tokens used to simulate "Fortal" (outer) and custom (inner) scope.
const _fortalPrimary = ColorToken('fortal.color.primary');
const _fortalSurface = ColorToken('fortal.color.surface');
const _customGap = SpaceToken('custom.space.gap');
const _customAccent = ColorToken('custom.color.accent');

void main() {
  group('MixScope.inherit', () {
    testWidgets(
      'outer scope token and inner custom token both resolve in same subtree',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MixScope(
              colors: {
                _fortalPrimary: Colors.blue,
                _fortalSurface: Colors.white,
              },
              child: MixScope.inherit(
                spaces: {_customGap: 12.0},
                colors: {_customAccent: Colors.orange},
                child: Builder(
                  builder: (context) {
                    final scope = MixScope.of(context);
                    expect(
                      scope.getToken(_fortalPrimary, context),
                      Colors.blue,
                    );
                    expect(
                      scope.getToken(_fortalSurface, context),
                      Colors.white,
                    );
                    expect(scope.getToken(_customGap, context), 12.0);
                    expect(
                      scope.getToken(_customAccent, context),
                      Colors.orange,
                    );
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    testWidgets(
      'Material scope + MixScope.inherit: both Material and custom tokens resolve',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: MixScope.withMaterial(
              child: MixScope.inherit(
                spaces: {_customGap: 8.0},
                colors: {_customAccent: Colors.purple},
                child: Builder(
                  builder: (context) {
                    final scope = MixScope.of(context);
                    final md = const MaterialTokens();
                    expect(
                      scope.getToken(md.colorScheme.primary, context),
                      Theme.of(context).colorScheme.primary,
                    );
                    expect(
                      scope.getToken(md.colorScheme.surface, context),
                      Theme.of(context).colorScheme.surface,
                    );
                    expect(scope.getToken(_customGap, context), 8.0);
                    expect(
                      scope.getToken(_customAccent, context),
                      Colors.purple,
                    );
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    testWidgets(
      'resolution valid for .light within createFortalScope-like outer scope',
      (tester) async {
        const lightPrimary = Color(0xFF0D47A1);
        const lightSurface = Color(0xFFFAFAFA);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: lightPrimary,
                surface: lightSurface,
              ),
            ),
            home: MixScope.withMaterial(
              child: MixScope.inherit(
                spaces: {_customGap: 16.0},
                child: Builder(
                  builder: (context) {
                    final scope = MixScope.of(context);
                    final md = const MaterialTokens();
                    expect(
                      scope.getToken(md.colorScheme.primary, context),
                      lightPrimary,
                    );
                    expect(
                      scope.getToken(md.colorScheme.surface, context),
                      lightSurface,
                    );
                    expect(scope.getToken(_customGap, context), 16.0);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    testWidgets(
      'resolution valid for .dark within createFortalScope-like outer scope',
      (tester) async {
        const darkPrimary = Color(0xFF90CAF9);
        const darkSurface = Color(0xFF121212);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: darkPrimary,
                surface: darkSurface,
              ),
            ),
            home: MixScope.withMaterial(
              child: MixScope.inherit(
                spaces: {_customGap: 24.0},
                child: Builder(
                  builder: (context) {
                    final scope = MixScope.of(context);
                    final md = const MaterialTokens();
                    expect(
                      scope.getToken(md.colorScheme.primary, context),
                      darkPrimary,
                    );
                    expect(
                      scope.getToken(md.colorScheme.surface, context),
                      darkSurface,
                    );
                    expect(scope.getToken(_customGap, context), 24.0);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    testWidgets('inner token overrides parent when same key is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MixScope(
            colors: {_fortalPrimary: Colors.blue},
            child: MixScope.inherit(
              colors: {_fortalPrimary: Colors.green},
              child: Builder(
                builder: (context) {
                  final scope = MixScope.of(context);
                  expect(scope.getToken(_fortalPrimary, context), Colors.green);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets(
      'MixScope.inherit with no parent still provides only child tokens',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MixScope.inherit(
              colors: {_customAccent: Colors.teal},
              child: Builder(
                builder: (context) {
                  final scope = MixScope.of(context);
                  expect(scope.getToken(_customAccent, context), Colors.teal);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      },
    );
  });
}
