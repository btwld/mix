import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('VisibilityModifier', () {
    group('constructor', () {
      test('should create with default values', () {
        const modifier = VisibilityModifier();

        expect(modifier.visible, isTrue);
      });

      test('should create with custom visibility', () {
        const modifier = VisibilityModifier(false);

        expect(modifier.visible, isFalse);
      });

      test('should create with explicit visibility true', () {
        const modifier = VisibilityModifier(true);

        expect(modifier.visible, isTrue);
      });

      test('should use true when null is provided', () {
        const modifier = VisibilityModifier(null);

        expect(modifier.visible, isTrue);
      });
    });

    group('copyWith', () {
      test('should copy with no changes when no parameters provided', () {
        const original = VisibilityModifier(false);

        final copied = original.copyWith();

        expect(copied.visible, equals(original.visible));
      });

      test('should copy with updated values', () {
        const original = VisibilityModifier();

        final copied = original.copyWith(visible: false);

        expect(copied.visible, isFalse);
      });
    });

    group('lerp', () {
      test('should return this when other is null', () {
        const modifier = VisibilityModifier();
        final result = modifier.lerp(null, 0.5);

        expect(result, same(modifier));
      });

      test('should snap to other when t >= 0.5', () {
        const start = VisibilityModifier(true);
        const end = VisibilityModifier(false);

        final result = start.lerp(end, 0.5);

        expect(result.visible, isFalse);
      });

      test('should return this when t < 0.5', () {
        const start = VisibilityModifier(true);
        const end = VisibilityModifier(false);

        final result = start.lerp(end, 0.3);

        expect(result.visible, isTrue);
      });

      test('should handle lerp at boundaries', () {
        const start = VisibilityModifier(true);
        const end = VisibilityModifier(false);

        final resultAtZero = start.lerp(end, 0.0);
        final resultAtOne = start.lerp(end, 1.0);

        expect(resultAtZero.visible, isTrue);
        expect(resultAtOne.visible, isFalse);
      });
    });

    group('build', () {
      testWidgets('should wrap child in Visibility widget', (tester) async {
        const modifier = VisibilityModifier(true);
        const child = Text('Test Text');
        final result = modifier.build(child);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: result)));

        final visibilityWidget = tester.widget<Visibility>(
          find.byType(Visibility),
        );

        expect(visibilityWidget.visible, isTrue);
        expect(visibilityWidget.child, equals(child));
      });

      testWidgets('should hide child when visible is false', (tester) async {
        const modifier = VisibilityModifier(false);
        const child = Text('Test Text');
        final result = modifier.build(child);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: result)));

        final visibilityWidget = tester.widget<Visibility>(
          find.byType(Visibility),
        );

        expect(visibilityWidget.visible, isFalse);
        expect(visibilityWidget.child, equals(child));
      });
    });

    group('equality and props', () {
      test('should be equal when all properties are same', () {
        const modifier1 = VisibilityModifier(true);
        const modifier2 = VisibilityModifier(true);

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const modifier1 = VisibilityModifier(true);
        const modifier2 = VisibilityModifier(false);

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('should have correct props', () {
        const modifier = VisibilityModifier(false);

        expect(modifier.props, equals([false]));
      });
    });

    group('debugFillProperties', () {
      test('should add diagnostic properties for visible true', () {
        const modifier = VisibilityModifier(true);

        final builder = DiagnosticPropertiesBuilder();
        modifier.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.length, greaterThan(0));

        // Should have a FlagProperty for visible
        expect(
          properties.any((p) => p.name == 'visible' && p is FlagProperty),
          isTrue,
        );
      });

      test('should add diagnostic properties for visible false', () {
        const modifier = VisibilityModifier(false);

        final builder = DiagnosticPropertiesBuilder();
        modifier.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.length, greaterThan(0));

        // Should have a FlagProperty for visible
        expect(
          properties.any((p) => p.name == 'visible' && p is FlagProperty),
          isTrue,
        );
      });
    });
  });

  group('VisibilityModifierMix', () {
    group('constructor', () {
      test('should create with direct value', () {
        final mix = VisibilityModifierMix(visible: true);

        expect(mix.visible, isA<Prop<bool>>());
      });

      test('should create with create constructor', () {
        final mix = VisibilityModifierMix.create(visible: Prop.value(false));

        expect(mix.visible, isA<Prop<bool>>());
      });

      test('should create with null value', () {
        final mix = VisibilityModifierMix(visible: null);

        expect(mix.visible, isNull);
      });
    });

    group('resolve', () {
      testWidgets('should resolve to VisibilityModifier', (tester) async {
        final mix = VisibilityModifierMix(visible: false);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final resolved = mix.resolve(context);

                expect(resolved, isA<VisibilityModifier>());
                expect(resolved.visible, isFalse);

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should resolve with null value', (tester) async {
        final mix = VisibilityModifierMix.create();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final resolved = mix.resolve(context);

                expect(resolved, isA<VisibilityModifier>());
                expect(
                  resolved.visible,
                  isTrue,
                ); // VisibilityModifier defaults to true when null

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('merge', () {
      test('should return this when other is null', () {
        final mix = VisibilityModifierMix(visible: true);
        final result = mix.merge(null);

        expect(result, same(mix));
      });

      test('should merge properties correctly', () {
        final mix1 = VisibilityModifierMix(visible: true);
        final mix2 = VisibilityModifierMix(visible: false);

        final merged = mix1.merge(mix2);

        expect(merged.visible, isNotNull);
      });

      test('should use other value when this has null', () {
        final mix1 = VisibilityModifierMix.create();
        final mix2 = VisibilityModifierMix(visible: false);

        final merged = mix1.merge(mix2);

        expect(merged.visible, equals(mix2.visible));
      });
    });

    group('equality and props', () {
      test('should be equal when properties are same', () {
        final mix1 = VisibilityModifierMix(visible: true);
        final mix2 = VisibilityModifierMix(visible: true);

        expect(mix1, equals(mix2));
      });

      test('should not be equal when properties differ', () {
        final mix1 = VisibilityModifierMix(visible: true);
        final mix2 = VisibilityModifierMix(visible: false);

        expect(mix1, isNot(equals(mix2)));
      });

      test('should have correct props', () {
        final mix = VisibilityModifierMix(visible: false);

        expect(mix.props.length, equals(1));
        expect(mix.props[0], equals(mix.visible));
      });
    });

    group('debugFillProperties', () {
      test('should add diagnostic properties', () {
        final mix = VisibilityModifierMix(visible: true);

        final builder = DiagnosticPropertiesBuilder();
        mix.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.length, greaterThan(0));

        // Verify specific properties are added
        expect(properties.any((p) => p.name == 'visible'), isTrue);
      });
    });
  });

  group('VisibilityModifierUtility', () {
    late VisibilityModifierUtility<TestStyle> utility;

    setUp(() {
      utility = VisibilityModifierUtility<TestStyle>(
        (mix) => TestStyle(modifierMix: mix),
      );
    });

    test('should create VisibilityModifierMix with on method', () {
      final result = utility.on();

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<VisibilityModifierMix>());
    });

    test('should create VisibilityModifierMix with off method', () {
      final result = utility.off();

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<VisibilityModifierMix>());
    });

    test('should create VisibilityModifierMix with call method', () {
      final trueResult = utility(true);
      final falseResult = utility(false);

      expect(trueResult, isA<TestStyle>());
      expect(falseResult, isA<TestStyle>());
      expect(trueResult.modifierMix, isA<VisibilityModifierMix>());
      expect(falseResult.modifierMix, isA<VisibilityModifierMix>());
    });

    test('should create VisibilityModifierMix with token method', () {
      final token = TestBoolToken('visibility.token');
      final result = utility.token(token);

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<VisibilityModifierMix>());
    });
  });
}

// Test helper class
class TestStyle extends Style<BoxSpec>
    with
        AnimationStyleMixin<BoxSpec, TestStyle>,
        VariantStyleMixin<TestStyle, BoxSpec>,
        WidgetModifierStyleMixin<TestStyle, BoxSpec> {
  final VisibilityModifierMix modifierMix;

  const TestStyle({
    required this.modifierMix,
    super.variants,
    super.modifier,
    super.animation,
  });

  @override
  TestStyle withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestStyle(
      modifierMix: modifierMix,
      variants: variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  TestStyle animate(AnimationConfig animation) {
    return TestStyle(
      modifierMix: modifierMix,
      variants: $variants,
      modifier: $modifier,
      animation: animation,
    );
  }

  @override
  TestStyle wrap(WidgetModifierConfig value) {
    return TestStyle(
      modifierMix: modifierMix,
      variants: $variants,
      modifier: value,
      animation: $animation,
    );
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: BoxSpec(),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  TestStyle merge(TestStyle? other) {
    return TestStyle(
      modifierMix: other?.modifierMix ?? modifierMix,
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
    );
  }

  @override
  List<Object?> get props => [modifierMix, $animation, $modifier, $variants];
}

// Test helper token class
class TestBoolToken extends MixToken<bool> {
  const TestBoolToken(super.name);

  @override
  bool call() => false;
}
