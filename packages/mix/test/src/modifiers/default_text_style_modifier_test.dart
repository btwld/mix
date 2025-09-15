import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('DefaultTextStyleModifier', () {
    group('constructor', () {
      test('should create with default values', () {
        const modifier = DefaultTextStyleModifier();

        expect(modifier.style, equals(const TextStyle()));
        expect(modifier.textAlign, isNull);
        expect(modifier.softWrap, isTrue);
        expect(modifier.overflow, equals(TextOverflow.clip));
        expect(modifier.maxLines, isNull);
        expect(modifier.textWidthBasis, equals(TextWidthBasis.parent));
        expect(modifier.textHeightBehavior, isNull);
      });

      test('should create with custom values', () {
        const style = TextStyle(fontSize: 16, color: Colors.blue);
        const textHeightBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
        );

        const modifier = DefaultTextStyleModifier(
          style: style,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: textHeightBehavior,
        );

        expect(modifier.style, equals(style));
        expect(modifier.textAlign, equals(TextAlign.center));
        expect(modifier.softWrap, isFalse);
        expect(modifier.overflow, equals(TextOverflow.ellipsis));
        expect(modifier.maxLines, equals(3));
        expect(modifier.textWidthBasis, equals(TextWidthBasis.longestLine));
        expect(modifier.textHeightBehavior, equals(textHeightBehavior));
      });
    });

    group('copyWith', () {
      test('should copy with no changes when no parameters provided', () {
        const original = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.left,
          softWrap: false,
          overflow: TextOverflow.fade,
          maxLines: 2,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        final copied = original.copyWith();

        expect(copied.style, equals(original.style));
        expect(copied.textAlign, equals(original.textAlign));
        expect(copied.softWrap, equals(original.softWrap));
        expect(copied.overflow, equals(original.overflow));
        expect(copied.maxLines, equals(original.maxLines));
        expect(copied.textWidthBasis, equals(original.textWidthBasis));
        expect(copied.textHeightBehavior, equals(original.textHeightBehavior));
      });

      test('should copy with updated values', () {
        const original = DefaultTextStyleModifier();
        const newStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

        final copied = original.copyWith(
          style: newStyle,
          textAlign: TextAlign.right,
          softWrap: false,
          overflow: TextOverflow.visible,
          maxLines: 5,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        expect(copied.style, equals(newStyle));
        expect(copied.textAlign, equals(TextAlign.right));
        expect(copied.softWrap, isFalse);
        expect(copied.overflow, equals(TextOverflow.visible));
        expect(copied.maxLines, equals(5));
        expect(copied.textWidthBasis, equals(TextWidthBasis.longestLine));
        expect(copied.textHeightBehavior, isNull); // Unchanged
      });
    });

    group('lerp', () {
      test('should return this when other is null', () {
        const modifier = DefaultTextStyleModifier();
        final result = modifier.lerp(null, 0.5);

        expect(result, same(modifier));
      });

      test('should interpolate between two modifiers', () {
        const start = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.left,
          softWrap: true,
          overflow: TextOverflow.clip,
          maxLines: 1,
          textWidthBasis: TextWidthBasis.parent,
        );

        const end = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.right,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        final result = start.lerp(end, 0.5);

        expect(result.style.fontSize, equals(15.0)); // Interpolated
        expect(result.textAlign, equals(TextAlign.right)); // Snapped at t=0.5
        expect(result.softWrap, isFalse); // Snapped at t=0.5
        expect(
          result.overflow,
          equals(TextOverflow.ellipsis),
        ); // Snapped at t=0.5
        expect(result.maxLines, equals(3)); // Snapped at t=0.5
        expect(
          result.textWidthBasis,
          equals(TextWidthBasis.longestLine),
        ); // Snapped at t=0.5
      });

      test('should handle lerp at boundaries', () {
        const start = DefaultTextStyleModifier(style: TextStyle(fontSize: 10));
        const end = DefaultTextStyleModifier(style: TextStyle(fontSize: 20));

        final resultAtZero = start.lerp(end, 0.0);
        final resultAtOne = start.lerp(end, 1.0);

        expect(resultAtZero.style.fontSize, equals(10.0));
        expect(resultAtOne.style.fontSize, equals(20.0));
      });
    });

    group('build', () {
      testWidgets('should wrap child in DefaultTextStyle', (tester) async {
        const modifier = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 16, color: Colors.red),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        const child = Text('Test Text');
        final result = modifier.build(child);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: result)));

        final defaultTextStyle = tester.widget<DefaultTextStyle>(
          find.byType(DefaultTextStyle),
        );

        expect(defaultTextStyle.style.fontSize, equals(16));
        expect(defaultTextStyle.style.color, equals(Colors.red));
        expect(defaultTextStyle.textAlign, equals(TextAlign.center));
        expect(defaultTextStyle.softWrap, isFalse);
        expect(defaultTextStyle.overflow, equals(TextOverflow.ellipsis));
        expect(defaultTextStyle.maxLines, equals(2));
        expect(
          defaultTextStyle.textWidthBasis,
          equals(TextWidthBasis.longestLine),
        );
        expect(defaultTextStyle.child, equals(child));
      });

      testWidgets('should use default values when not specified', (
        tester,
      ) async {
        const modifier = DefaultTextStyleModifier();
        const child = Text('Test Text');
        final result = modifier.build(child);

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: result)));

        final defaultTextStyle = tester.widget<DefaultTextStyle>(
          find.byType(DefaultTextStyle),
        );

        expect(defaultTextStyle.style, equals(const TextStyle()));
        expect(defaultTextStyle.textAlign, isNull);
        expect(defaultTextStyle.softWrap, isTrue);
        expect(defaultTextStyle.overflow, equals(TextOverflow.clip));
        expect(defaultTextStyle.maxLines, isNull);
        expect(defaultTextStyle.textWidthBasis, equals(TextWidthBasis.parent));
        expect(defaultTextStyle.textHeightBehavior, isNull);
      });
    });

    group('equality and props', () {
      test('should be equal when all properties are same', () {
        const modifier1 = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        const modifier2 = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        expect(modifier1, equals(modifier2));
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const modifier1 = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 16),
        );
        const modifier2 = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 18),
        );

        expect(modifier1, isNot(equals(modifier2)));
      });

      test('should have correct props', () {
        const style = TextStyle(fontSize: 16);
        const modifier = DefaultTextStyleModifier(
          style: style,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        expect(
          modifier.props,
          equals([
            style,
            TextAlign.center,
            false,
            TextOverflow.ellipsis,
            3,
            TextWidthBasis.longestLine,
            null, // textHeightBehavior
          ]),
        );
      });
    });

    group('debugFillProperties', () {
      test('should add diagnostic properties', () {
        const modifier = DefaultTextStyleModifier(
          style: TextStyle(fontSize: 16, color: Colors.blue),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        final builder = DiagnosticPropertiesBuilder();
        modifier.debugFillProperties(builder);

        final properties = builder.properties;
        expect(properties.length, greaterThan(0));

        // Verify specific properties are added
        expect(properties.any((p) => p.name == 'style'), isTrue);
        expect(properties.any((p) => p.name == 'textAlign'), isTrue);
        expect(properties.any((p) => p.name == 'softWrap'), isTrue);
        expect(properties.any((p) => p.name == 'overflow'), isTrue);
        expect(properties.any((p) => p.name == 'maxLines'), isTrue);
        expect(properties.any((p) => p.name == 'textWidthBasis'), isTrue);
      });
    });
  });

  group('DefaultTextStyleModifierMix', () {
    group('constructor', () {
      test('should create with direct values', () {
        final mix = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehaviorMix(),
        );

        expect(mix.style, isA<Prop<TextStyle>>());
        expect(mix.textAlign, isA<Prop<TextAlign>>());
        expect(mix.softWrap, isA<Prop<bool>>());
        expect(mix.overflow, isA<Prop<TextOverflow>>());
        expect(mix.maxLines, isA<Prop<int>>());
        expect(mix.textWidthBasis, isA<Prop<TextWidthBasis>>());
        expect(mix.textHeightBehavior, isA<Prop<TextHeightBehavior>>());
      });

      test('should create with create constructor', () {
        final mix = DefaultTextStyleModifierMix.create(
          style: Prop.value(const TextStyle(fontSize: 18)),
          textAlign: Prop.value(TextAlign.right),
          softWrap: Prop.value(false),
        );

        expect(mix.style, isA<Prop<TextStyle>>());
        expect(mix.textAlign, isA<Prop<TextAlign>>());
        expect(mix.softWrap, isA<Prop<bool>>());
        expect(mix.overflow, isNull);
        expect(mix.maxLines, isNull);
        expect(mix.textWidthBasis, isNull);
        expect(mix.textHeightBehavior, isNull);
      });
    });

    group('resolve', () {
      testWidgets('should resolve to DefaultTextStyleModifier', (tester) async {
        final mix = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 20),
          textAlign: TextAlign.justify,
          softWrap: false,
          overflow: TextOverflow.visible,
          maxLines: 4,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final resolved = mix.resolve(context);

                expect(resolved, isA<DefaultTextStyleModifier>());
                expect(resolved.style.fontSize, equals(20));
                expect(resolved.textAlign, equals(TextAlign.justify));
                expect(resolved.softWrap, isFalse);
                expect(resolved.overflow, equals(TextOverflow.visible));
                expect(resolved.maxLines, equals(4));
                expect(
                  resolved.textWidthBasis,
                  equals(TextWidthBasis.longestLine),
                );

                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should resolve with null values', (tester) async {
        final mix = DefaultTextStyleModifierMix.create();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final resolved = mix.resolve(context);

                expect(resolved, isA<DefaultTextStyleModifier>());
                expect(resolved.style, isNull);
                expect(resolved.textAlign, isNull);
                expect(resolved.softWrap, isNull);
                expect(resolved.overflow, isNull);
                expect(resolved.maxLines, isNull);
                expect(resolved.textWidthBasis, isNull);
                expect(resolved.textHeightBehavior, isNull);

                return Container();
              },
            ),
          ),
        );
      });
    });

    group('merge', () {
      test('should return this when other is null', () {
        final mix = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
        );
        final result = mix.merge(null);

        expect(result, same(mix));
      });

      test('should merge properties correctly', () {
        final mix1 = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
          textAlign: TextAlign.left,
          softWrap: true,
        );

        final mix2 = DefaultTextStyleModifierMix(
          style: TextStyleMix(color: Colors.red),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        );

        final merged = mix1.merge(mix2);

        expect(merged.style, isNotNull);
        expect(merged.textAlign, isA<Prop<TextAlign>>());
        expect(merged.softWrap, isA<Prop<bool>>());
        expect(merged.overflow, isA<Prop<TextOverflow>>());
      });
    });

    group('equality and props', () {
      test('should be equal when properties are same', () {
        final mix1 = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: false,
        );

        final mix2 = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: false,
        );

        expect(mix1, equals(mix2));
      });

      test('should have correct props', () {
        final mix = DefaultTextStyleModifierMix(
          style: TextStyleMix(fontSize: 16),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textWidthBasis: TextWidthBasis.longestLine,
        );

        expect(mix.props.length, equals(7));
        expect(mix.props[0], equals(mix.style));
        expect(mix.props[1], equals(mix.textAlign));
        expect(mix.props[2], equals(mix.softWrap));
        expect(mix.props[3], equals(mix.overflow));
        expect(mix.props[4], equals(mix.maxLines));
        expect(mix.props[5], equals(mix.textWidthBasis));
        expect(mix.props[6], equals(mix.textHeightBehavior));
      });
    });
  });

  group('DefaultTextStyleModifierUtility', () {
    late DefaultTextStyleModifierUtility<TestStyle> utility;

    setUp(() {
      utility = DefaultTextStyleModifierUtility<TestStyle>(
        (mix) => TestStyle(modifierMix: mix),
      );
    });

    test('should create DefaultTextStyleModifierMix with all parameters', () {
      const style = TextStyle(fontSize: 18, color: Colors.green);
      const textHeightBehavior = TextHeightBehavior(
        applyHeightToFirstAscent: false,
      );

      final result = utility(
        style: style,
        textAlign: TextAlign.end,
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 5,
        textWidthBasis: TextWidthBasis.longestLine,
        textHeightBehavior: textHeightBehavior,
      );

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<DefaultTextStyleModifierMix>());
    });

    test(
      'should create DefaultTextStyleModifierMix with minimal parameters',
      () {
        final result = utility(style: const TextStyle(fontSize: 14));

        expect(result, isA<TestStyle>());
        expect(result.modifierMix, isA<DefaultTextStyleModifierMix>());
      },
    );

    test('should create DefaultTextStyleModifierMix with no parameters', () {
      final result = utility();

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<DefaultTextStyleModifierMix>());
    });

    test('should handle null values correctly', () {
      final result = utility(
        style: null,
        textAlign: null,
        softWrap: null,
        overflow: null,
        maxLines: null,
        textWidthBasis: null,
        textHeightBehavior: null,
      );

      expect(result, isA<TestStyle>());
      expect(result.modifierMix, isA<DefaultTextStyleModifierMix>());
    });
  });
}

// Test helper class
class TestStyle extends Style<BoxSpec> {
  final DefaultTextStyleModifierMix modifierMix;

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
