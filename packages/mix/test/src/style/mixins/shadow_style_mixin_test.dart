import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the shadow mixin
class TestShadowStyler extends Style<BoxSpec>
    with ShadowStyleMixin<TestShadowStyler> {
  final List<DecorationMix> decorationCalls;

  TestShadowStyler({
    super.variants,
    super.modifier,
    super.animation,
    List<DecorationMix>? decorationCalls,
  }) : decorationCalls = decorationCalls ?? <DecorationMix>[];

  @override
  TestShadowStyler decoration(DecorationMix value) {
    decorationCalls.add(value);
    return this;
  }

  @override
  TestShadowStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestShadowStyler(
      variants: variants,
      modifier: $modifier,
      animation: $animation,
      decorationCalls: decorationCalls,
    );
  }

  @override
  TestShadowStyler animate(AnimationConfig animation) {
    return TestShadowStyler(
      variants: $variants,
      modifier: $modifier,
      animation: animation,
      decorationCalls: decorationCalls,
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
  TestShadowStyler merge(TestShadowStyler? other) {
    return TestShadowStyler(
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      decorationCalls: decorationCalls,
    );
  }

  @override
  List<Object?> get props => [
        $animation,
        $modifier,
        $variants,
      ];
}

void main() {
  group('ShadowStyleMixin', () {
    late TestShadowStyler testStyler;

    setUp(() {
      testStyler = TestShadowStyler();
    });

    group('shadowOnly', () {
      test('should call decoration with box shadow', () {
        testStyler.shadowOnly(
          color: Colors.red,
          offset: const Offset(2, 4),
          blurRadius: 8,
          spreadRadius: 1,
        );

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with minimal parameters', () {
        testStyler.shadowOnly(color: Colors.blue);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with no parameters', () {
        testStyler.shadowOnly();

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with only offset', () {
        testStyler.shadowOnly(offset: const Offset(1, 2));

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with only blur radius', () {
        testStyler.shadowOnly(blurRadius: 5);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with only spread radius', () {
        testStyler.shadowOnly(spreadRadius: 2);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });
    });

    group('boxShadows', () {
      test('should call decoration with multiple box shadows', () {
        final shadows = [
          BoxShadowMix(
            color: Colors.red,
            offset: const Offset(1, 2),
            blurRadius: 3,
          ),
          BoxShadowMix(
            color: Colors.blue,
            offset: const Offset(2, 4),
            blurRadius: 6,
          ),
        ];

        testStyler.boxShadows(shadows);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with empty shadow list', () {
        testStyler.boxShadows([]);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with single shadow in list', () {
        final shadows = [
          BoxShadowMix(
            color: Colors.green,
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ];

        testStyler.boxShadows(shadows);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });
    });

    group('boxElevation', () {
      test('should call decoration with elevation shadow', () {
        const elevation = ElevationShadow.one;
        testStyler.boxElevation(elevation);

        expect(testStyler.decorationCalls.length, equals(1));
        expect(testStyler.decorationCalls.first, isA<BoxDecorationMix>());
      });

      test('should work with different elevation levels', () {
        const elevations = [
          ElevationShadow.one,
          ElevationShadow.two,
          ElevationShadow.three,
          ElevationShadow.four,
          ElevationShadow.six,
          ElevationShadow.eight,
          ElevationShadow.nine,
          ElevationShadow.twelve,
          ElevationShadow.sixteen,
          ElevationShadow.twentyFour,
        ];

        for (final elevation in elevations) {
          testStyler.boxElevation(elevation);
        }

        expect(testStyler.decorationCalls.length, equals(elevations.length));
        for (final call in testStyler.decorationCalls) {
          expect(call, isA<BoxDecorationMix>());
        }
      });
    });

    group('method chaining', () {
      test('should support method chaining', () {
        final result = testStyler
            .shadowOnly(color: Colors.red)
            .boxElevation(ElevationShadow.two)
            .boxShadows([BoxShadowMix()]);

        expect(result, same(testStyler));
        expect(testStyler.decorationCalls.length, equals(3));
      });
    });

    group('comprehensive coverage', () {
      test('should verify all shadow methods work', () {
        final shadows = [
          BoxShadowMix(color: Colors.purple),
          BoxShadowMix(color: Colors.orange),
        ];

        testStyler
            .shadowOnly(
              color: Colors.red,
              offset: const Offset(1, 1),
              blurRadius: 4,
              spreadRadius: 2,
            )
            .shadowOnly(color: Colors.blue)
            .shadowOnly()
            .boxShadows(shadows)
            .boxShadows([])
            .boxElevation(ElevationShadow.one)
            .boxElevation(ElevationShadow.eight)
            .boxElevation(ElevationShadow.twentyFour);

        // Should have called decoration 8 times
        expect(testStyler.decorationCalls.length, equals(8));

        // All should be BoxDecorationMix instances
        for (final call in testStyler.decorationCalls) {
          expect(call, isA<BoxDecorationMix>());
        }
      });
    });

    group('parameter variations', () {
      test('should handle various shadow configurations', () {
        // Test different parameter combinations
        testStyler
            .shadowOnly(color: Colors.black)
            .shadowOnly(offset: const Offset(0, 0))
            .shadowOnly(blurRadius: 0)
            .shadowOnly(spreadRadius: 0)
            .shadowOnly(
              color: Colors.grey,
              offset: const Offset(-1, -1),
            )
            .shadowOnly(
              blurRadius: 10,
              spreadRadius: 5,
            );

        expect(testStyler.decorationCalls.length, equals(6));
        for (final call in testStyler.decorationCalls) {
          expect(call, isA<BoxDecorationMix>());
        }
      });
    });
  });
}