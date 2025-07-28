import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Text Height Behavior Utilities', () {
    group('TextHeightBehaviorUtility', () {
      final utility = TextHeightBehaviorUtility(UtilityTestAttribute.new);

      test('call() creates TextHeightBehaviorMix', () {
        final textHeightBehaviorMix = TextHeightBehaviorMix(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.proportional,
        );
        final attr = utility(textHeightBehaviorMix);
        expect(attr.value, isA<MixProp<TextHeightBehavior>>());
      });

      test('as() creates TextHeightBehaviorMix from TextHeightBehavior', () {
        const textHeightBehavior = TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: true,
          leadingDistribution: TextLeadingDistribution.even,
        );
        final attr = utility.as(textHeightBehavior);
        expect(attr.value, isA<MixProp<TextHeightBehavior>>());
      });

      group('Property Utilities', () {
        test(
          'heightToFirstAscent() creates text height behavior with height to first ascent',
          () {
            final attr = utility.heightToFirstAscent(true);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'heightToFirstAscent.on() creates text height behavior with height to first ascent on',
          () {
            final attr = utility.heightToFirstAscent.on();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'heightToFirstAscent.off() creates text height behavior with height to first ascent off',
          () {
            final attr = utility.heightToFirstAscent.off();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'heightToLastDescent() creates text height behavior with height to last descent',
          () {
            final attr = utility.heightToLastDescent(false);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'heightToLastDescent.on() creates text height behavior with height to last descent on',
          () {
            final attr = utility.heightToLastDescent.on();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'heightToLastDescent.off() creates text height behavior with height to last descent off',
          () {
            final attr = utility.heightToLastDescent.off();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'leadingDistribution() creates text height behavior with leading distribution',
          () {
            final attr = utility.leadingDistribution(
              TextLeadingDistribution.proportional,
            );
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'leadingDistribution.proportional() creates text height behavior with proportional leading distribution',
          () {
            final attr = utility.leadingDistribution.proportional();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'leadingDistribution.even() creates text height behavior with even leading distribution',
          () {
            final attr = utility.leadingDistribution.even();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );
      });

      group('Common Text Height Behavior Patterns', () {
        test('creates default text height behavior', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for tight line spacing', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for loose line spacing', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for headings', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for body text', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for captions', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });
      });

      group('Leading Distribution Variations', () {
        test(
          'creates text height behavior with proportional leading distribution',
          () {
            final attr = utility.leadingDistribution.proportional();
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test('creates text height behavior with even leading distribution', () {
          final attr = utility.leadingDistribution.even();
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('combines leading distribution with height settings', () {
          final textHeightBehaviorMix = TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(textHeightBehaviorMix);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });
      });

      group('Height Application Combinations', () {
        test(
          'creates text height behavior with both height applications enabled',
          () {
            final textHeightBehaviorMix = TextHeightBehaviorMix(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: true,
            );
            final attr = utility(textHeightBehaviorMix);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'creates text height behavior with both height applications disabled',
          () {
            final textHeightBehaviorMix = TextHeightBehaviorMix(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            );
            final attr = utility(textHeightBehaviorMix);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'creates text height behavior with only first ascent height enabled',
          () {
            final textHeightBehaviorMix = TextHeightBehaviorMix(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: false,
            );
            final attr = utility(textHeightBehaviorMix);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'creates text height behavior with only last descent height enabled',
          () {
            final textHeightBehaviorMix = TextHeightBehaviorMix(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: true,
            );
            final attr = utility(textHeightBehaviorMix);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );
      });

      group('Typography Use Cases', () {
        test('creates text height behavior for display text', () {
          final displayTextBehavior = TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(displayTextBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for paragraph text', () {
          final paragraphTextBehavior = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(paragraphTextBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for code text', () {
          final codeTextBehavior = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: true,
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(codeTextBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for button text', () {
          final buttonTextBehavior = TextHeightBehaviorMix(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(buttonTextBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior for label text', () {
          final labelTextBehavior = TextHeightBehaviorMix(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent: false,
            leadingDistribution: TextLeadingDistribution.proportional,
          );
          final attr = utility(labelTextBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });
      });

      group('Edge Cases', () {
        test('creates text height behavior with minimal configuration', () {
          final minimalBehavior = TextHeightBehaviorMix();
          final attr = utility(minimalBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test('creates text height behavior with only leading distribution', () {
          final onlyLeadingBehavior = TextHeightBehaviorMix(
            leadingDistribution: TextLeadingDistribution.even,
          );
          final attr = utility(onlyLeadingBehavior);
          expect(attr.value, isA<MixProp<TextHeightBehavior>>());
        });

        test(
          'creates text height behavior with only height to first ascent',
          () {
            final onlyFirstAscentBehavior = TextHeightBehaviorMix(
              applyHeightToFirstAscent: true,
            );
            final attr = utility(onlyFirstAscentBehavior);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );

        test(
          'creates text height behavior with only height to last descent',
          () {
            final onlyLastDescentBehavior = TextHeightBehaviorMix(
              applyHeightToLastDescent: false,
            );
            final attr = utility(onlyLastDescentBehavior);
            expect(attr.value, isA<MixProp<TextHeightBehavior>>());
          },
        );
      });

      test('token() creates text height behavior from token', () {
        const token = MixToken<TextHeightBehavior>('test.textHeightBehavior');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<TextHeightBehavior>>());
      });
    });
  });
}
