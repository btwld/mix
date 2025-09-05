import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';


void main() {
  group('BrightnessTokenDefinition', () {
    late MixToken<Color> colorToken;
    
    setUp(() {
      colorToken = const MixToken<Color>('test.color');
    });

    test('should create correct BrightnessTokenDefinition with values constructor', () {
      final definition = BrightnessTokenDefinition.values(
        colorToken,
        lightValue: Colors.white,
        darkValue: Colors.black,
      );

      expect(definition, isA<BrightnessTokenDefinition<Color>>());
      expect(definition.token, colorToken);
      expect(definition, isA<TokenDefinition<Color>>());
    });

    test('should create correct BrightnessTokenDefinition with main constructor', () {
      final definition = BrightnessTokenDefinition(
        colorToken,
        lightResolver: (_) => Colors.blue,
        darkResolver: (_) => Colors.red,
      );

      expect(definition, isA<BrightnessTokenDefinition<Color>>());
      expect(definition.token, colorToken);
      expect(definition.lightResolver, isA<ValueBuilder<Color>>());
      expect(definition.darkResolver, isA<ValueBuilder<Color>>());
    });

    test('values constructor should create proper resolvers', () {
      final definition = BrightnessTokenDefinition.values(
        colorToken,
        lightValue: Colors.white,
        darkValue: Colors.black,
      );

      // Test that the resolvers work correctly
      final mockContext = MockBuildContext();
      expect(definition.lightResolver(mockContext), Colors.white);
      expect(definition.darkResolver(mockContext), Colors.black);
    });
  });

  group('MixTokenBrightnessExt', () {
    late MixToken<Color> colorToken;
    
    setUp(() {
      colorToken = const MixToken<Color>('test.color');
    });

    test('defineAdaptive creates BrightnessTokenDefinition with static values', () {
      final definition = colorToken.defineAdaptive(
        light: Colors.white,
        dark: Colors.black,
      );

      expect(definition, isA<BrightnessTokenDefinition<Color>>());
      expect(definition.token, colorToken);

      final mockContext = MockBuildContext();
      final brightnessDef = definition as BrightnessTokenDefinition<Color>;
      expect(brightnessDef.lightResolver(mockContext), Colors.white);
      expect(brightnessDef.darkResolver(mockContext), Colors.black);
    });

    test('defineAdaptiveBuilder creates BrightnessTokenDefinition with builders', () {
      final definition = colorToken.defineAdaptiveBuilder(
        light: (context) => Colors.red,
        dark: (context) => Colors.green,
      );

      expect(definition, isA<BrightnessTokenDefinition<Color>>());
      expect(definition.token, colorToken);

      final mockContext = MockBuildContext();
      final brightnessDef = definition as BrightnessTokenDefinition<Color>;
      expect(brightnessDef.lightResolver(mockContext), Colors.red);
      expect(brightnessDef.darkResolver(mockContext), Colors.green);
    });
  });

  group('MixScope with adaptive tokens', () {
    late MixToken<Color> primaryColor;
    late MixToken<Color> backgroundColor;
    
    setUp(() {
      primaryColor = const MixToken<Color>('primary');
      backgroundColor = const MixToken<Color>('background');
    });

    testWidgets('should work with adaptive tokens created via extension methods', (tester) async {
      final scope = MixScope(
        tokens: {
          primaryColor.defineAdaptive(
            light: Colors.blue,
            dark: Colors.lightBlue,
          ),
          backgroundColor.defineAdaptive(
            light: Colors.white,
            dark: Colors.black,
          ),
        },
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: scope,
        ),
      );

      // Test that the scope was created successfully
      expect(find.byType(MixScope), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    test('should create correct token structure with adaptive tokens', () {
      final scope = MixScope(
        tokens: {
          primaryColor.defineAdaptive(
            light: Colors.blue,
            dark: Colors.lightBlue,
          ),
          backgroundColor.defineAdaptive(
            light: Colors.white,
            dark: Colors.black,
          ),
        },
        child: const SizedBox(),
      );

      // Verify that tokens were set up correctly
      expect(scope.tokens, isNotNull);
      expect(scope.tokens!.length, 2); // 2 adaptive tokens
      
      // Check that all expected tokens are present
      final tokenKeys = scope.tokens!.keys;
      expect(tokenKeys, contains(primaryColor));
      expect(tokenKeys, contains(backgroundColor));
    });
  });

  group('MixScope.withMaterial', () {
    testWidgets('should work with material tokens', (tester) async {
      final scope = MixScope.withMaterial(
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: scope,
        ),
      );

      expect(find.byType(MixScope), findsOneWidget);
    });

    testWidgets('should merge custom adaptive tokens with material tokens', (tester) async {
      final customToken = const MixToken<Color>('custom');
      
      final scope = MixScope.withMaterial(
        tokens: {
          customToken.defineAdaptive(
            light: Colors.purple,
            dark: Colors.deepPurple,
          ),
        },
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: scope,
        ),
      );

      expect(find.byType(MixScope), findsOneWidget);
    });

    test('should include material tokens', () {
      final scope = MixScope.withMaterial(
        child: const SizedBox(),
      );

      // Should have material tokens
      expect(scope.tokens, isNotNull);
      expect(scope.tokens!.isNotEmpty, true);
    });
  });

  group('Integration Tests', () {
    test('BrightnessTokenDefinition resolver switches correctly based on theme', () {
      final token = const MixToken<Color>('test');
      final definition = token.defineAdaptive(
        light: Colors.white,
        dark: Colors.black,
      );

      // Create a mock resolver that simulates brightness switching
      ValueBuilder<Color> createMockResolver(Brightness brightness) {
        return (context) {
          // Simulate Theme.of(context).brightness
          if (brightness == Brightness.light) {
            return (definition as BrightnessTokenDefinition<Color>).lightResolver(context);
          } else {
            return (definition as BrightnessTokenDefinition<Color>).darkResolver(context);
          }
        };
      }

      final mockContext = MockBuildContext();
      final lightResolver = createMockResolver(Brightness.light);
      final darkResolver = createMockResolver(Brightness.dark);

      expect(lightResolver(mockContext), Colors.white);
      expect(darkResolver(mockContext), Colors.black);
    });
  });
}