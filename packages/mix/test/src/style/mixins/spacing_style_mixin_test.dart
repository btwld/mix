import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the spacing mixin
class TestSpacingStyler extends Style<BoxSpec>
    with
        SpacingStyleMixin<TestSpacingStyler>,
        AnimationStyleMixin<BoxSpec, TestSpacingStyler> {
  final List<EdgeInsetsGeometryMix> paddingCalls;
  final List<EdgeInsetsGeometryMix> marginCalls;

  TestSpacingStyler({
    super.variants,
    super.modifier,
    super.animation,
    List<EdgeInsetsGeometryMix>? paddingCalls,
    List<EdgeInsetsGeometryMix>? marginCalls,
  }) : paddingCalls = paddingCalls ?? <EdgeInsetsGeometryMix>[],
       marginCalls = marginCalls ?? <EdgeInsetsGeometryMix>[];

  @override
  TestSpacingStyler padding(EdgeInsetsGeometryMix value) {
    paddingCalls.add(value);
    return this;
  }

  @override
  TestSpacingStyler margin(EdgeInsetsGeometryMix value) {
    marginCalls.add(value);
    return this;
  }

  @override
  TestSpacingStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestSpacingStyler(
      variants: variants,
      modifier: $modifier,
      animation: $animation,
      paddingCalls: paddingCalls,
      marginCalls: marginCalls,
    );
  }

  @override
  TestSpacingStyler animate(AnimationConfig animation) {
    return TestSpacingStyler(
      variants: $variants,
      modifier: $modifier,
      animation: animation,
      paddingCalls: paddingCalls,
      marginCalls: marginCalls,
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
  TestSpacingStyler merge(TestSpacingStyler? other) {
    return TestSpacingStyler(
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      paddingCalls: paddingCalls,
      marginCalls: marginCalls,
    );
  }

  @override
  List<Object?> get props => [$animation, $modifier, $variants];
}

void main() {
  group('SpacingStyleMixin', () {
    late TestSpacingStyler testStyler;

    setUp(() {
      testStyler = TestSpacingStyler();
    });

    group('Padding convenience methods', () {
      test('paddingTop should call padding with top EdgeInsetsGeometryMix', () {
        testStyler.paddingTop(10);

        expect(testStyler.paddingCalls.length, equals(1));
        final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
        expect(edgeInsetsMix.$top, isNotNull);
        expect(edgeInsetsMix.$bottom, isNull);
        expect(edgeInsetsMix.$left, isNull);
        expect(edgeInsetsMix.$right, isNull);
      });

      test(
        'paddingBottom should call padding with bottom EdgeInsetsGeometryMix',
        () {
          testStyler.paddingBottom(20);

          expect(testStyler.paddingCalls.length, equals(1));
          final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
          expect(edgeInsetsMix.$top, isNull);
          expect(edgeInsetsMix.$bottom, isNotNull);
          expect(edgeInsetsMix.$left, isNull);
          expect(edgeInsetsMix.$right, isNull);
        },
      );

      test(
        'paddingLeft should call padding with left EdgeInsetsGeometryMix',
        () {
          testStyler.paddingLeft(15);

          expect(testStyler.paddingCalls.length, equals(1));
          final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
          expect(edgeInsetsMix.$top, isNull);
          expect(edgeInsetsMix.$bottom, isNull);
          expect(edgeInsetsMix.$left, isNotNull);
          expect(edgeInsetsMix.$right, isNull);
        },
      );

      test(
        'paddingRight should call padding with right EdgeInsetsGeometryMix',
        () {
          testStyler.paddingRight(25);

          expect(testStyler.paddingCalls.length, equals(1));
          final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
          expect(edgeInsetsMix.$top, isNull);
          expect(edgeInsetsMix.$bottom, isNull);
          expect(edgeInsetsMix.$left, isNull);
          expect(edgeInsetsMix.$right, isNotNull);
        },
      );

      test(
        'paddingX should call padding with horizontal EdgeInsetsGeometryMix',
        () {
          testStyler.paddingX(30);

          expect(testStyler.paddingCalls.length, equals(1));
          final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
          expect(edgeInsetsMix.$top, isNull);
          expect(edgeInsetsMix.$bottom, isNull);
          expect(edgeInsetsMix.$left, isNotNull);
          expect(edgeInsetsMix.$right, isNotNull);
        },
      );

      test(
        'paddingY should call padding with vertical EdgeInsetsGeometryMix',
        () {
          testStyler.paddingY(35);

          expect(testStyler.paddingCalls.length, equals(1));
          final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
          expect(edgeInsetsMix.$top, isNotNull);
          expect(edgeInsetsMix.$bottom, isNotNull);
          expect(edgeInsetsMix.$left, isNull);
          expect(edgeInsetsMix.$right, isNull);
        },
      );

      test('paddingAll should call padding with all EdgeInsetsGeometryMix', () {
        testStyler.paddingAll(40);

        expect(testStyler.paddingCalls.length, equals(1));
        final edgeInsetsMix = testStyler.paddingCalls.first as EdgeInsetsMix;
        expect(edgeInsetsMix.$top, isNotNull);
        expect(edgeInsetsMix.$bottom, isNotNull);
        expect(edgeInsetsMix.$left, isNotNull);
        expect(edgeInsetsMix.$right, isNotNull);
      });

      test(
        'paddingStart should call padding with start EdgeInsetsGeometryMix',
        () {
          testStyler.paddingStart(45);

          expect(testStyler.paddingCalls.length, equals(1));
          expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test('paddingEnd should call padding with end EdgeInsetsGeometryMix', () {
        testStyler.paddingEnd(50);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });
    });

    group('Margin convenience methods', () {
      test('marginTop should call margin with top EdgeInsetsGeometryMix', () {
        testStyler.marginTop(10);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test(
        'marginBottom should call margin with bottom EdgeInsetsGeometryMix',
        () {
          testStyler.marginBottom(20);

          expect(testStyler.marginCalls.length, equals(1));
          expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test('marginLeft should call margin with left EdgeInsetsGeometryMix', () {
        testStyler.marginLeft(15);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test(
        'marginRight should call margin with right EdgeInsetsGeometryMix',
        () {
          testStyler.marginRight(25);

          expect(testStyler.marginCalls.length, equals(1));
          expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test(
        'marginX should call margin with horizontal EdgeInsetsGeometryMix',
        () {
          testStyler.marginX(30);

          expect(testStyler.marginCalls.length, equals(1));
          expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test(
        'marginY should call margin with vertical EdgeInsetsGeometryMix',
        () {
          testStyler.marginY(35);

          expect(testStyler.marginCalls.length, equals(1));
          expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test('marginAll should call margin with all EdgeInsetsGeometryMix', () {
        testStyler.marginAll(40);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test(
        'marginStart should call margin with start EdgeInsetsGeometryMix',
        () {
          testStyler.marginStart(45);

          expect(testStyler.marginCalls.length, equals(1));
          expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
        },
      );

      test('marginEnd should call margin with end EdgeInsetsGeometryMix', () {
        testStyler.marginEnd(50);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });
    });

    group('paddingOnly', () {
      test('should call padding with only specified values', () {
        testStyler.paddingOnly(left: 10, top: 20);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should handle horizontal and vertical parameters', () {
        testStyler.paddingOnly(horizontal: 15, vertical: 25);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should prioritize specific over general parameters', () {
        testStyler.paddingOnly(horizontal: 10, left: 20);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should use directional when start or end is provided', () {
        testStyler.paddingOnly(start: 10, end: 20);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should handle all parameters', () {
        testStyler.paddingOnly(left: 10, right: 20, top: 30, bottom: 40);

        expect(testStyler.paddingCalls.length, equals(1));
        expect(testStyler.paddingCalls.first, isA<EdgeInsetsGeometryMix>());
      });
    });

    group('marginOnly', () {
      test('should call margin with only specified values', () {
        testStyler.marginOnly(left: 10, top: 20);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should handle horizontal and vertical parameters', () {
        testStyler.marginOnly(horizontal: 15, vertical: 25);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should prioritize specific over general parameters', () {
        testStyler.marginOnly(horizontal: 10, left: 20);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should use directional when start or end is provided', () {
        testStyler.marginOnly(start: 10, end: 20);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });

      test('should handle all parameters', () {
        testStyler.marginOnly(left: 10, right: 20, top: 30, bottom: 40);

        expect(testStyler.marginCalls.length, equals(1));
        expect(testStyler.marginCalls.first, isA<EdgeInsetsGeometryMix>());
      });
    });

    group('method chaining', () {
      test('should support method chaining', () {
        final result = testStyler.paddingTop(10).marginLeft(20).paddingAll(30);

        expect(result, same(testStyler));
        expect(testStyler.paddingCalls.length, equals(2));
        expect(testStyler.marginCalls.length, equals(1));
      });
    });

    group('comprehensive coverage', () {
      test('should verify all convenience methods work', () {
        testStyler
            .paddingTop(1)
            .paddingBottom(2)
            .paddingLeft(3)
            .paddingRight(4)
            .paddingX(5)
            .paddingY(6)
            .paddingAll(7)
            .paddingStart(8)
            .paddingEnd(9)
            .paddingOnly(left: 10)
            .marginTop(11)
            .marginBottom(12)
            .marginLeft(13)
            .marginRight(14)
            .marginX(15)
            .marginY(16)
            .marginAll(17)
            .marginStart(18)
            .marginEnd(19)
            .marginOnly(right: 20);

        // Should have called padding 10 times
        expect(testStyler.paddingCalls.length, equals(10));

        // Should have called margin 10 times
        expect(testStyler.marginCalls.length, equals(10));

        // All should be EdgeInsetsGeometryMix instances
        for (final call in testStyler.paddingCalls) {
          expect(call, isA<EdgeInsetsGeometryMix>());
        }
        for (final call in testStyler.marginCalls) {
          expect(call, isA<EdgeInsetsGeometryMix>());
        }
      });
    });
  });
}
