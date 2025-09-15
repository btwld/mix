import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the border radius mixin
class TestBorderRadiusStyler extends Style<BoxSpec>
    with BorderRadiusStyleMixin<TestBorderRadiusStyler> {
  final List<BorderRadiusGeometryMix> borderRadiusCalls;
  final List<DecorationMix> decorationCalls;
  final List<DecorationMix> foregroundDecorationCalls;

  TestBorderRadiusStyler({
    super.variants,
    super.modifier,
    super.animation,
    List<BorderRadiusGeometryMix>? borderRadiusCalls,
    List<DecorationMix>? decorationCalls,
    List<DecorationMix>? foregroundDecorationCalls,
  }) : borderRadiusCalls = borderRadiusCalls ?? <BorderRadiusGeometryMix>[],
       decorationCalls = decorationCalls ?? <DecorationMix>[],
       foregroundDecorationCalls = foregroundDecorationCalls ?? <DecorationMix>[];

  @override
  TestBorderRadiusStyler borderRadius(BorderRadiusGeometryMix value) {
    borderRadiusCalls.add(value);
    return this;
  }

  @override
  TestBorderRadiusStyler decoration(DecorationMix value) {
    decorationCalls.add(value);
    return this;
  }

  @override
  TestBorderRadiusStyler foregroundDecoration(DecorationMix value) {
    foregroundDecorationCalls.add(value);
    return this;
  }

  // DecorationStyleMixin implementations (stub implementations for testing)
  @override
  TestBorderRadiusStyler color(Color value) => this;

  @override
  TestBorderRadiusStyler gradient(GradientMix value) => this;

  @override
  TestBorderRadiusStyler border(BoxBorderMix value) => this;

  @override
  TestBorderRadiusStyler shadow(BoxShadowMix value) => this;

  @override
  TestBorderRadiusStyler shadows(List<BoxShadowMix> value) => this;

  @override
  TestBorderRadiusStyler elevation(ElevationShadow value) => this;

  @override
  TestBorderRadiusStyler image(DecorationImageMix value) => this;

  @override
  TestBorderRadiusStyler shape(ShapeBorderMix value) => this;

  @override
  TestBorderRadiusStyler shapeCircle({BorderSideMix? side}) => this;

  @override
  TestBorderRadiusStyler shapeStadium({BorderSideMix? side}) => this;

  @override
  TestBorderRadiusStyler shapeRoundedRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => this;

  @override
  TestBorderRadiusStyler shapeBeveledRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => this;

  @override
  TestBorderRadiusStyler shapeContinuousRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => this;

  @override
  TestBorderRadiusStyler shapeStar({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) => this;

  @override
  TestBorderRadiusStyler shapeLinear({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) => this;

  @override
  TestBorderRadiusStyler shapeSuperellipse({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) => this;

  @override
  TestBorderRadiusStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) => this;

  @override
  TestBorderRadiusStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) => this;

  @override
  TestBorderRadiusStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) => this;

  @override
  TestBorderRadiusStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => this;

  @override
  TestBorderRadiusStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestBorderRadiusStyler(
      variants: variants,
      modifier: $modifier,
      animation: $animation,
      borderRadiusCalls: borderRadiusCalls,
      decorationCalls: decorationCalls,
      foregroundDecorationCalls: foregroundDecorationCalls,
    );
  }

  @override
  TestBorderRadiusStyler animate(AnimationConfig animation) {
    return TestBorderRadiusStyler(
      variants: $variants,
      modifier: $modifier,
      animation: animation,
      borderRadiusCalls: borderRadiusCalls,
      decorationCalls: decorationCalls,
      foregroundDecorationCalls: foregroundDecorationCalls,
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
  TestBorderRadiusStyler merge(TestBorderRadiusStyler? other) {
    return TestBorderRadiusStyler(
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      borderRadiusCalls: borderRadiusCalls,
      decorationCalls: decorationCalls,
      foregroundDecorationCalls: foregroundDecorationCalls,
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
  group('BorderRadiusStyleMixin', () {
    late TestBorderRadiusStyler testStyler;

    setUp(() {
      testStyler = TestBorderRadiusStyler();
    });

    group('Radius-based methods', () {
      test('borderRadiusAll should call borderRadius', () {
        const radius = Radius.circular(8);
        testStyler.borderRadiusAll(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusTop should call borderRadius', () {
        const radius = Radius.circular(10);
        testStyler.borderRadiusTop(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusBottom should call borderRadius', () {
        const radius = Radius.circular(12);
        testStyler.borderRadiusBottom(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusLeft should call borderRadius', () {
        const radius = Radius.circular(14);
        testStyler.borderRadiusLeft(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusRight should call borderRadius', () {
        const radius = Radius.circular(16);
        testStyler.borderRadiusRight(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusTopLeft should call borderRadius', () {
        const radius = Radius.circular(18);
        testStyler.borderRadiusTopLeft(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusTopRight should call borderRadius', () {
        const radius = Radius.circular(20);
        testStyler.borderRadiusTopRight(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusBottomLeft should call borderRadius', () {
        const radius = Radius.circular(22);
        testStyler.borderRadiusBottomLeft(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusBottomRight should call borderRadius', () {
        const radius = Radius.circular(24);
        testStyler.borderRadiusBottomRight(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('Directional methods', () {
      test('borderRadiusTopStart should call borderRadius', () {
        const radius = Radius.circular(26);
        testStyler.borderRadiusTopStart(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusTopEnd should call borderRadius', () {
        const radius = Radius.circular(28);
        testStyler.borderRadiusTopEnd(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusBottomStart should call borderRadius', () {
        const radius = Radius.circular(30);
        testStyler.borderRadiusBottomStart(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRadiusBottomEnd should call borderRadius', () {
        const radius = Radius.circular(32);
        testStyler.borderRadiusBottomEnd(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('Rounded shortcuts - all corners', () {
      test('borderRounded should call borderRadius with circular radius', () {
        testStyler.borderRounded(8);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('Rounded shortcuts - grouped corners', () {
      test('borderRoundedTop should call borderRadius', () {
        testStyler.borderRoundedTop(10);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedBottom should call borderRadius', () {
        testStyler.borderRoundedBottom(12);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedLeft should call borderRadius', () {
        testStyler.borderRoundedLeft(14);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedRight should call borderRadius', () {
        testStyler.borderRoundedRight(16);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('Rounded shortcuts - single corners', () {
      test('borderRoundedTopLeft should call borderRadius', () {
        testStyler.borderRoundedTopLeft(18);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedTopRight should call borderRadius', () {
        testStyler.borderRoundedTopRight(20);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedBottomLeft should call borderRadius', () {
        testStyler.borderRoundedBottomLeft(22);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedBottomRight should call borderRadius', () {
        testStyler.borderRoundedBottomRight(24);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('Rounded shortcuts - directional', () {
      test('borderRoundedTopStart should call borderRadius', () {
        testStyler.borderRoundedTopStart(26);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedTopEnd should call borderRadius', () {
        testStyler.borderRoundedTopEnd(28);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedBottomStart should call borderRadius', () {
        testStyler.borderRoundedBottomStart(30);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('borderRoundedBottomEnd should call borderRadius', () {
        testStyler.borderRoundedBottomEnd(32);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });

    group('method chaining', () {
      test('should support method chaining', () {
        final result = testStyler
            .borderRounded(8)
            .borderRadiusTopLeft(const Radius.circular(16))
            .borderRoundedBottomRight(12);

        expect(result, same(testStyler));
        expect(testStyler.borderRadiusCalls.length, equals(3));
      });
    });

    group('comprehensive coverage', () {
      test('should verify all convenience methods work', () {
        final radius = const Radius.circular(4);

        testStyler
            // Radius-based methods
            .borderRadiusAll(radius)
            .borderRadiusTop(radius)
            .borderRadiusBottom(radius)
            .borderRadiusLeft(radius)
            .borderRadiusRight(radius)
            .borderRadiusTopLeft(radius)
            .borderRadiusTopRight(radius)
            .borderRadiusBottomLeft(radius)
            .borderRadiusBottomRight(radius)
            // Directional methods
            .borderRadiusTopStart(radius)
            .borderRadiusTopEnd(radius)
            .borderRadiusBottomStart(radius)
            .borderRadiusBottomEnd(radius)
            // Rounded shortcuts - all corners
            .borderRounded(8)
            // Rounded shortcuts - grouped corners
            .borderRoundedTop(10)
            .borderRoundedBottom(12)
            .borderRoundedLeft(14)
            .borderRoundedRight(16)
            // Rounded shortcuts - single corners
            .borderRoundedTopLeft(18)
            .borderRoundedTopRight(20)
            .borderRoundedBottomLeft(22)
            .borderRoundedBottomRight(24)
            // Rounded shortcuts - directional
            .borderRoundedTopStart(26)
            .borderRoundedTopEnd(28)
            .borderRoundedBottomStart(30)
            .borderRoundedBottomEnd(32);

        // Should have called borderRadius 26 times
        expect(testStyler.borderRadiusCalls.length, equals(26));

        // All should be BorderRadiusGeometryMix instances
        for (final call in testStyler.borderRadiusCalls) {
          expect(call, isA<BorderRadiusGeometryMix>());
        }
      });
    });

    group('different radius types', () {
      test('should handle elliptical radius', () {
        const radius = Radius.elliptical(10, 20);
        testStyler.borderRadiusAll(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });

      test('should handle zero radius', () {
        const radius = Radius.zero;
        testStyler.borderRadiusAll(radius);

        expect(testStyler.borderRadiusCalls.length, equals(1));
        expect(testStyler.borderRadiusCalls.first, isA<BorderRadiusGeometryMix>());
      });
    });
  });
}