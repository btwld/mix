import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('NumberPropDirectiveExt', () {
    group('multiply', () {
      test('multiplies numeric value', () {
        final prop = Prop.value(10.0).multiply(2.0);
        expect(prop, resolvesTo(20.0));
      });

      test('works with Prop<double>', () {
        final prop = Prop.value<double>(5.0).multiply(3.0);
        expect(prop, resolvesTo(15.0));
      });

      test('works with Prop<int>', () {
        final prop = Prop.value<int>(4).multiply(5);
        expect(prop, resolvesTo(20));
      });

      test('handles negative factors', () {
        final prop = Prop.value(10.0).multiply(-2.0);
        expect(prop, resolvesTo(-20.0));
      });

      test('handles fractional multiplication', () {
        final prop = Prop.value(10.0).multiply(0.5);
        expect(prop, resolvesTo(5.0));
      });
    });

    group('add', () {
      test('adds numeric value', () {
        final prop = Prop.value(10.0).add(5.0);
        expect(prop, resolvesTo(15.0));
      });

      test('handles negative addend', () {
        final prop = Prop.value(10.0).add(-5.0);
        expect(prop, resolvesTo(5.0));
      });
    });

    group('subtract', () {
      test('subtracts numeric value', () {
        final prop = Prop.value(10.0).subtract(3.0);
        expect(prop, resolvesTo(7.0));
      });

      test('handles negative subtrahend', () {
        final prop = Prop.value(10.0).subtract(-5.0);
        expect(prop, resolvesTo(15.0));
      });
    });

    group('divide', () {
      test('divides numeric value', () {
        final prop = Prop.value(10.0).divide(2.0);
        expect(prop, resolvesTo(5.0));
      });

      test('handles fractional division', () {
        final prop = Prop.value(10.0).divide(3.0);
        expect(prop, resolvesTo(10.0 / 3.0));
      });
    });

    group('clamp', () {
      test('clamps value within bounds', () {
        final propLow = Prop.value(5.0).clamp(10, 20);
        expect(propLow, resolvesTo(10.0));

        final propMid = Prop.value(15.0).clamp(10, 20);
        expect(propMid, resolvesTo(15.0));

        final propHigh = Prop.value(25.0).clamp(10, 20);
        expect(propHigh, resolvesTo(20.0));
      });
    });

    group('abs', () {
      test('returns absolute value', () {
        final propNeg = Prop.value(-10.0).abs();
        expect(propNeg, resolvesTo(10.0));

        final propPos = Prop.value(10.0).abs();
        expect(propPos, resolvesTo(10.0));
      });
    });

    group('round', () {
      test('rounds to nearest integer', () {
        final propUp = Prop.value(15.7).round();
        expect(propUp, resolvesTo(16.0));

        final propDown = Prop.value(15.3).round();
        expect(propDown, resolvesTo(15.0));
      });
    });

    group('floor', () {
      test('floors value', () {
        final prop = Prop.value(15.7).floor();
        expect(prop, resolvesTo(15.0));
      });
    });

    group('ceil', () {
      test('ceils value', () {
        final prop = Prop.value(15.3).ceil();
        expect(prop, resolvesTo(16.0));
      });
    });

    group('scale', () {
      test('is an alias for multiply', () {
        final propMultiply = Prop.value(10.0).multiply(2.0);
        final propScale = Prop.value(10.0).scale(2.0);

        expect(propScale, resolvesTo(20.0));
        expect(propScale.$directives, equals(propMultiply.$directives));
      });
    });

    group('directive chaining', () {
      test('chains multiple transformations', () {
        final prop = Prop.value(10.0)
            .multiply(2) // 20
            .add(5) // 25
            .subtract(5) // 20
            .divide(2); // 10

        expect(prop, resolvesTo(10.0));
      });

      test('chains with clamp', () {
        final prop = Prop.value(10.0)
            .multiply(2) // 20
            .add(10) // 30
            .clamp(0, 25); // 25

        expect(prop, resolvesTo(25.0));
      });

      test('chains with rounding', () {
        final prop = Prop.value(10.0)
            .multiply(1.5) // 15.0
            .add(0.7) // 15.7
            .round(); // 16.0

        expect(prop, resolvesTo(16.0));
      });

      test('complex chain with abs and floor', () {
        final prop = Prop.value(-10.5).abs().multiply(2).floor();
        // -10.5 -> 10.5 -> 21.0 -> 21.0
        expect(prop, resolvesTo(21.0));
      });
    });

    group('token resolution with directives', () {
      test('applies directives to token value', () {
        final token = TestToken<num>('size');
        final prop = Prop.token(token).multiply(2);

        final context = MockBuildContext(tokens: {token: 10});
        final resolved = prop.resolveProp(context);

        expect(resolved, equals(20));
      });

      test('chains directives with token', () {
        final token = TestToken<num>('base');
        final prop = Prop.token(token).multiply(1.5).clamp(10, 20);

        final context = MockBuildContext(tokens: {token: 5});
        final resolved = prop.resolveProp(context);

        // 5 * 1.5 = 7.5, clamped to 10
        expect(resolved, equals(10));
      });

      test('works with double token', () {
        final token = TestToken<double>('fontSize');
        final prop = Prop.token(token).multiply(1.2).round();

        final context = MockBuildContext(tokens: {token: 16.0});
        final resolved = prop.resolveProp(context);

        // 16.0 * 1.2 = 19.2, rounded to 19.0
        expect(resolved, equals(19.0));
      });

      test('works with int token', () {
        final token = TestToken<int>('spacing');
        final prop = Prop.token(token).multiply(2).add(4);

        final context = MockBuildContext(tokens: {token: 8});
        final resolved = prop.resolveProp(context);

        // 8 * 2 = 16, + 4 = 20
        expect(resolved, equals(20));
      });
    });

    group('real-world use cases', () {
      test('proportional typography scaling', () {
        // letterSpacing = 0.0025 * fontSize
        final fontSize = 12.0;
        final letterSpacing = Prop.value(0.0025).multiply(fontSize);

        expect(letterSpacing, resolvesTo(0.03));
      });

      test('token-based proportional scaling', () {
        final ratioToken = TestToken<double>('ratio');

        final letterSpacing = Prop.token(ratioToken).multiply(12.0);

        final context = MockBuildContext(tokens: {ratioToken: 0.0025});

        expect(letterSpacing.resolveProp(context), equals(0.03));
      });

      test('responsive font size with bounds', () {
        final baseSizeToken = TestToken<num>('baseSize');
        final fontSize = Prop.token(baseSizeToken).multiply(1.5).clamp(16, 32);

        final smallContext = MockBuildContext(tokens: {baseSizeToken: 10});
        expect(
          fontSize.resolveProp(smallContext),
          equals(16),
        ); // 10*1.5=15, clamped to 16

        final mediumContext = MockBuildContext(tokens: {baseSizeToken: 16});
        expect(fontSize.resolveProp(mediumContext), equals(24)); // 16*1.5=24

        final largeContext = MockBuildContext(tokens: {baseSizeToken: 30});
        expect(
          fontSize.resolveProp(largeContext),
          equals(32),
        ); // 30*1.5=45, clamped to 32
      });

      test('computed margins', () {
        final baseSpacingToken = TestToken<num>('baseSpacing');
        final margin = Prop.token(baseSpacingToken).multiply(2);

        final context = MockBuildContext(tokens: {baseSpacingToken: 8});
        expect(margin.resolveProp(context), equals(16));
      });

      test('line height calculation', () {
        // Line height as multiple of font size
        final fontSize = 16.0;
        final lineHeight = Prop.value(1.5).multiply(fontSize);

        expect(lineHeight, resolvesTo(24.0));
      });
    });

    group('type coercion', () {
      test('int * double = double', () {
        final prop = Prop.value<int>(10).multiply(1.5);
        final result = prop.resolveProp(MockBuildContext());
        expect(result, equals(15.0));
        expect(result, isA<double>());
      });

      test('double * int preserves num type', () {
        final prop = Prop.value<double>(10.0).multiply(2);
        final result = prop.resolveProp(MockBuildContext());
        expect(result, equals(20.0));
      });

      test('division always returns num', () {
        final prop = Prop.value<int>(10).divide(3);
        final result = prop.resolveProp(MockBuildContext());
        expect(result, closeTo(3.333, 0.001));
      });
    });

    group('edge cases', () {
      test('handles zero values', () {
        final prop = Prop.value(0.0).multiply(100);
        expect(prop, resolvesTo(0.0));
      });

      test('handles very large numbers', () {
        final prop = Prop.value(1e10).multiply(2);
        expect(prop, resolvesTo(2e10));
      });

      test('handles very small numbers', () {
        final prop = Prop.value(1e-10).multiply(2);
        expect(prop, resolvesTo(2e-10));
      });

      test('handles multiple directives of same type', () {
        final prop = Prop.value(10.0).multiply(2).multiply(3);
        expect(prop, resolvesTo(60.0));
      });

      test('handles empty directive chain', () {
        final prop = Prop.value(10.0);
        expect(prop, resolvesTo(10.0));
      });
    });
  });
}
