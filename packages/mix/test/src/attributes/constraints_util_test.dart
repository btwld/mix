import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Constraints Utilities', () {
    group('BoxConstraintsUtility', () {
      final utility = BoxConstraintsUtility(UtilityTestAttribute.new);

      test('call() creates BoxConstraintsMix', () {
        final constraintsMix = BoxConstraintsMix.only(
          minWidth: 50.0,
          maxWidth: 150.0,
          minHeight: 100.0,
          maxHeight: 200.0,
        );
        final attr = utility(constraintsMix);
        expect(attr.value, isA<MixProp<BoxConstraints>>());
      });

      test('as() creates BoxConstraintsMix from BoxConstraints', () {
        const constraints = BoxConstraints(
          minWidth: 25.0,
          maxWidth: 125.0,
          minHeight: 75.0,
          maxHeight: 175.0,
        );
        final attr = utility.as(constraints);
        expect(attr.value, isA<MixProp<BoxConstraints>>());
      });

      group('Property Utilities', () {
        test('minWidth() creates constraints with min width', () {
          final attr = utility.minWidth(50.0);
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('minWidth.zero() creates constraints with zero min width', () {
          final attr = utility.minWidth.zero();
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test(
          'minWidth.infinity() creates constraints with infinite min width',
          () {
            final attr = utility.minWidth.infinity();
            expect(attr.value, isA<MixProp<BoxConstraints>>());
          },
        );

        test('maxWidth() creates constraints with max width', () {
          final attr = utility.maxWidth(150.0);
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('maxWidth.zero() creates constraints with zero max width', () {
          final attr = utility.maxWidth.zero();
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test(
          'maxWidth.infinity() creates constraints with infinite max width',
          () {
            final attr = utility.maxWidth.infinity();
            expect(attr.value, isA<MixProp<BoxConstraints>>());
          },
        );

        test('minHeight() creates constraints with min height', () {
          final attr = utility.minHeight(100.0);
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('minHeight.zero() creates constraints with zero min height', () {
          final attr = utility.minHeight.zero();
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test(
          'minHeight.infinity() creates constraints with infinite min height',
          () {
            final attr = utility.minHeight.infinity();
            expect(attr.value, isA<MixProp<BoxConstraints>>());
          },
        );

        test('maxHeight() creates constraints with max height', () {
          final attr = utility.maxHeight(200.0);
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('maxHeight.zero() creates constraints with zero max height', () {
          final attr = utility.maxHeight.zero();
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test(
          'maxHeight.infinity() creates constraints with infinite max height',
          () {
            final attr = utility.maxHeight.infinity();
            expect(attr.value, isA<MixProp<BoxConstraints>>());
          },
        );
      });

      group('Common Constraint Patterns', () {
        test('creates tight constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 100, height: 200),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates loose constraints', () {
          final attr = utility.as(
            const BoxConstraints(maxWidth: 300, maxHeight: 400),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates expand constraints', () {
          final attr = utility.as(const BoxConstraints.expand());
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates expand constraints with width', () {
          final attr = utility.as(const BoxConstraints.expand(width: 500));
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates expand constraints with height', () {
          final attr = utility.as(const BoxConstraints.expand(height: 600));
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates tight for finite constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightForFinite(width: 250, height: 350),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });
      });

      group('Edge Cases', () {
        test('handles zero constraints', () {
          final attr = utility.as(BoxConstraints.tight(Size.zero));
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('handles infinite constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('handles mixed finite and infinite constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: 300,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('handles very large finite constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 1000,
              maxWidth: 5000,
              minHeight: 2000,
              maxHeight: 8000,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('handles fractional constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 10.5,
              maxWidth: 100.7,
              minHeight: 20.3,
              maxHeight: 200.9,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });
      });

      group('Constraint Validation Patterns', () {
        test('creates valid tight constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 100, height: 100),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates valid loose constraints with min bounds', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 50,
              maxWidth: 200,
              minHeight: 75,
              maxHeight: 300,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates constraints with equal min and max', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 150,
              maxWidth: 150,
              minHeight: 200,
              maxHeight: 200,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });
      });

      group('Responsive Constraint Patterns', () {
        test('creates mobile-friendly constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 320,
              maxWidth: 480,
              minHeight: 0,
              maxHeight: double.infinity,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates tablet-friendly constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 768,
              maxWidth: 1024,
              minHeight: 0,
              maxHeight: double.infinity,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates desktop-friendly constraints', () {
          final attr = utility.as(
            const BoxConstraints(
              minWidth: 1200,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: double.infinity,
            ),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });
      });

      group('Aspect Ratio Constraint Patterns', () {
        test('creates square constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 200, height: 200),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates 16:9 aspect ratio constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 320, height: 180),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates 4:3 aspect ratio constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 400, height: 300),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });

        test('creates golden ratio constraints', () {
          final attr = utility.as(
            const BoxConstraints.tightFor(width: 161.8, height: 100),
          );
          expect(attr.value, isA<MixProp<BoxConstraints>>());
        });
      });

      test('token() creates constraints from token', () {
        const token = MixToken<BoxConstraints>('test.constraints');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<BoxConstraints>>());
      });
    });
  });
}
