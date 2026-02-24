import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('NumberDirective', () {
    group('MultiplyNumberDirective', () {
      test('multiplies numeric value', () {
        final directive = MultiplyNumberDirective(2.0);
        expect(directive.apply(5.0), equals(10.0));
        expect(directive.apply(3), equals(6));
      });

      test('handles negative factors', () {
        final directive = MultiplyNumberDirective(-1.5);
        expect(directive.apply(4.0), equals(-6.0));
      });

      test('handles zero factor', () {
        final directive = MultiplyNumberDirective(0);
        expect(directive.apply(100.0), equals(0.0));
      });

      test('handles fractional multiplication', () {
        final directive = MultiplyNumberDirective(0.5);
        expect(directive.apply(10), equals(5.0));
      });

      test('equality works correctly', () {
        expect(
          MultiplyNumberDirective(2.0),
          equals(MultiplyNumberDirective(2.0)),
        );
        expect(
          MultiplyNumberDirective(2.0),
          isNot(equals(MultiplyNumberDirective(3.0))),
        );
      });

      test('key is correct', () {
        final directive = MultiplyNumberDirective(2.0);
        expect(directive.key, equals('number_multiply'));
      });

      test('hashCode works correctly', () {
        final d1 = MultiplyNumberDirective(2.0);
        final d2 = MultiplyNumberDirective(2.0);
        final d3 = MultiplyNumberDirective(3.0);
        expect(d1.hashCode, equals(d2.hashCode));
        expect(d1.hashCode, isNot(equals(d3.hashCode)));
      });

      test('throws ArgumentError for NaN factor', () {
        expect(
          () => MultiplyNumberDirective(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite factor', () {
        expect(
          () => MultiplyNumberDirective(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => MultiplyNumberDirective(double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('AddNumberDirective', () {
      test('adds numeric value', () {
        final directive = AddNumberDirective(5.0);
        expect(directive.apply(10.0), equals(15.0));
        expect(directive.apply(3), equals(8));
      });

      test('handles negative addend', () {
        final directive = AddNumberDirective(-5.0);
        expect(directive.apply(10.0), equals(5.0));
      });

      test('handles zero addend', () {
        final directive = AddNumberDirective(0);
        expect(directive.apply(10.0), equals(10.0));
      });

      test('equality works correctly', () {
        expect(AddNumberDirective(5.0), equals(AddNumberDirective(5.0)));
        expect(
          AddNumberDirective(5.0),
          isNot(equals(AddNumberDirective(10.0))),
        );
      });

      test('key is correct', () {
        final directive = AddNumberDirective(5.0);
        expect(directive.key, equals('number_add'));
      });

      test('throws ArgumentError for NaN addend', () {
        expect(
          () => AddNumberDirective(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite addend', () {
        expect(
          () => AddNumberDirective(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => AddNumberDirective(double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('SubtractNumberDirective', () {
      test('subtracts numeric value', () {
        final directive = SubtractNumberDirective(5.0);
        expect(directive.apply(10.0), equals(5.0));
        expect(directive.apply(3), equals(-2));
      });

      test('handles negative subtrahend', () {
        final directive = SubtractNumberDirective(-5.0);
        expect(directive.apply(10.0), equals(15.0));
      });

      test('handles zero subtrahend', () {
        final directive = SubtractNumberDirective(0);
        expect(directive.apply(10.0), equals(10.0));
      });

      test('equality works correctly', () {
        expect(
          SubtractNumberDirective(5.0),
          equals(SubtractNumberDirective(5.0)),
        );
        expect(
          SubtractNumberDirective(5.0),
          isNot(equals(SubtractNumberDirective(10.0))),
        );
      });

      test('key is correct', () {
        final directive = SubtractNumberDirective(5.0);
        expect(directive.key, equals('number_subtract'));
      });

      test('throws ArgumentError for NaN subtrahend', () {
        expect(
          () => SubtractNumberDirective(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite subtrahend', () {
        expect(
          () => SubtractNumberDirective(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => SubtractNumberDirective(double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('DivideNumberDirective', () {
      test('divides numeric value', () {
        final directive = DivideNumberDirective(2);
        expect(directive.apply(10.0), equals(5.0));
        expect(directive.apply(10), equals(5.0));
      });

      test('division always returns num type', () {
        final directive = DivideNumberDirective(2);
        final result = directive.apply(10);
        expect(result, equals(5.0));
      });

      test('integer division returns double', () {
        final directive = DivideNumberDirective(3);
        final result = directive.apply(10);
        expect(result, equals(10 / 3));
      });

      test('handles fractional divisor', () {
        final directive = DivideNumberDirective(0.5);
        expect(directive.apply(10), equals(20.0));
      });

      test('handles negative divisor', () {
        final directive = DivideNumberDirective(-2);
        expect(directive.apply(10), equals(-5.0));
      });

      test('equality works correctly', () {
        expect(DivideNumberDirective(2), equals(DivideNumberDirective(2)));
        expect(
          DivideNumberDirective(2),
          isNot(equals(DivideNumberDirective(3))),
        );
      });

      test('key is correct', () {
        final directive = DivideNumberDirective(2);
        expect(directive.key, equals('number_divide'));
      });

      test('throws ArgumentError for zero divisor', () {
        expect(() => DivideNumberDirective(0), throwsA(isA<ArgumentError>()));
      });

      test('throws ArgumentError for NaN divisor', () {
        expect(
          () => DivideNumberDirective(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite divisor', () {
        expect(
          () => DivideNumberDirective(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => DivideNumberDirective(double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('ClampNumberDirective', () {
      test('clamps value within bounds', () {
        final directive = ClampNumberDirective(10, 20);
        expect(directive.apply(5.0), equals(10.0));
        expect(directive.apply(15.0), equals(15.0));
        expect(directive.apply(25.0), equals(20.0));
      });

      test('works with integers', () {
        final directive = ClampNumberDirective(10, 20);
        expect(directive.apply(5), equals(10));
        expect(directive.apply(25), equals(20));
      });

      test('handles negative bounds', () {
        final directive = ClampNumberDirective(-20, -10);
        expect(directive.apply(-25), equals(-20));
        expect(directive.apply(-15), equals(-15));
        expect(directive.apply(-5), equals(-10));
      });

      test('handles zero in range', () {
        final directive = ClampNumberDirective(-10, 10);
        expect(directive.apply(0), equals(0));
      });

      test('equality works correctly', () {
        expect(
          ClampNumberDirective(10, 20),
          equals(ClampNumberDirective(10, 20)),
        );
        expect(
          ClampNumberDirective(10, 20),
          isNot(equals(ClampNumberDirective(10, 30))),
        );
        expect(
          ClampNumberDirective(10, 20),
          isNot(equals(ClampNumberDirective(5, 20))),
        );
      });

      test('key is correct', () {
        final directive = ClampNumberDirective(10, 20);
        expect(directive.key, equals('number_clamp'));
      });

      test('throws ArgumentError for NaN min', () {
        expect(
          () => ClampNumberDirective(double.nan, 20),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for NaN max', () {
        expect(
          () => ClampNumberDirective(10, double.nan),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite min', () {
        expect(
          () => ClampNumberDirective(double.infinity, 20),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => ClampNumberDirective(double.negativeInfinity, 20),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for infinite max', () {
        expect(
          () => ClampNumberDirective(10, double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => ClampNumberDirective(10, double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('AbsNumberDirective', () {
      test('returns absolute value', () {
        const directive = AbsNumberDirective();
        expect(directive.apply(-10.0), equals(10.0));
        expect(directive.apply(10.0), equals(10.0));
        expect(directive.apply(-5), equals(5));
        expect(directive.apply(5), equals(5));
      });

      test('handles zero', () {
        const directive = AbsNumberDirective();
        expect(directive.apply(0), equals(0));
        expect(directive.apply(-0.0), equals(0.0));
      });

      test('equality works correctly', () {
        expect(const AbsNumberDirective(), equals(const AbsNumberDirective()));
      });

      test('key is correct', () {
        const directive = AbsNumberDirective();
        expect(directive.key, equals('number_abs'));
      });
    });

    group('RoundNumberDirective', () {
      test('rounds to nearest integer', () {
        const directive = RoundNumberDirective();
        expect(directive.apply(15.7), equals(16.0));
        expect(directive.apply(15.3), equals(15.0));
        expect(directive.apply(15.5), equals(16.0));
      });

      test('handles negative values', () {
        const directive = RoundNumberDirective();
        expect(directive.apply(-15.7), equals(-16.0));
        expect(directive.apply(-15.3), equals(-15.0));
        expect(directive.apply(-15.5), equals(-16.0));
      });

      test('handles integers', () {
        const directive = RoundNumberDirective();
        expect(directive.apply(15), equals(15.0));
      });

      test('handles zero', () {
        const directive = RoundNumberDirective();
        expect(directive.apply(0), equals(0.0));
      });

      test('equality works correctly', () {
        expect(
          const RoundNumberDirective(),
          equals(const RoundNumberDirective()),
        );
      });

      test('key is correct', () {
        const directive = RoundNumberDirective();
        expect(directive.key, equals('number_round'));
      });
    });

    group('FloorNumberDirective', () {
      test('floors value (rounds down)', () {
        const directive = FloorNumberDirective();
        expect(directive.apply(15.7), equals(15.0));
        expect(directive.apply(15.3), equals(15.0));
      });

      test('handles negative values', () {
        const directive = FloorNumberDirective();
        expect(directive.apply(-15.7), equals(-16.0));
        expect(directive.apply(-15.3), equals(-16.0));
      });

      test('handles integers', () {
        const directive = FloorNumberDirective();
        expect(directive.apply(15), equals(15.0));
      });

      test('handles zero', () {
        const directive = FloorNumberDirective();
        expect(directive.apply(0), equals(0.0));
      });

      test('equality works correctly', () {
        expect(
          const FloorNumberDirective(),
          equals(const FloorNumberDirective()),
        );
      });

      test('key is correct', () {
        const directive = FloorNumberDirective();
        expect(directive.key, equals('number_floor'));
      });
    });

    group('CeilNumberDirective', () {
      test('ceils value (rounds up)', () {
        const directive = CeilNumberDirective();
        expect(directive.apply(15.7), equals(16.0));
        expect(directive.apply(15.3), equals(16.0));
      });

      test('handles negative values', () {
        const directive = CeilNumberDirective();
        expect(directive.apply(-15.7), equals(-15.0));
        expect(directive.apply(-15.3), equals(-15.0));
      });

      test('handles integers', () {
        const directive = CeilNumberDirective();
        expect(directive.apply(15), equals(15.0));
      });

      test('handles zero', () {
        const directive = CeilNumberDirective();
        expect(directive.apply(0), equals(0.0));
      });

      test('equality works correctly', () {
        expect(
          const CeilNumberDirective(),
          equals(const CeilNumberDirective()),
        );
      });

      test('key is correct', () {
        const directive = CeilNumberDirective();
        expect(directive.key, equals('number_ceil'));
      });
    });

    group('Directive chaining via DirectiveListExt', () {
      test('applies multiple directives in sequence', () {
        final directives = <Directive<num>>[
          MultiplyNumberDirective(2), // 10 * 2 = 20
          AddNumberDirective(5), // 20 + 5 = 25
          SubtractNumberDirective(5), // 25 - 5 = 20
        ];

        final result = directives.apply(10.0);
        expect(result, equals(20.0));
      });

      test('applies complex directive chain', () {
        final directives = <Directive<num>>[
          MultiplyNumberDirective(2), // 10 * 2 = 20
          AddNumberDirective(5), // 20 + 5 = 25
          ClampNumberDirective(0, 20), // clamp to 20
        ];

        final result = directives.apply(10.0);
        expect(result, equals(20.0));
      });

      test('applies rounding directives in chain', () {
        final directives = <Directive<num>>[
          MultiplyNumberDirective(1.5), // 10 * 1.5 = 15.0
          AddNumberDirective(0.7), // 15.0 + 0.7 = 15.7
          const RoundNumberDirective(), // round to 16.0
        ];

        final result = directives.apply(10.0);
        expect(result, equals(16.0));
      });
    });
  });
}
