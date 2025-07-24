import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Strut Style Utilities', () {
    group('StrutStyleUtility', () {
      final utility = StrutStyleUtility(UtilityTestAttribute.new);

      test('call() creates StrutStyleMix', () {
        final strutStyleMix = StrutStyleMix.only(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          height: 1.5,
          leading: 2.0,
          forceStrutHeight: true,
        );
        final attr = utility(strutStyleMix);
        expect(attr.value, isA<MixProp<StrutStyle>>());
      });

      test('as() creates StrutStyleMix from StrutStyle', () {
        const strutStyle = StrutStyle(
          fontFamily: 'Arial',
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          height: 1.2,
          leading: 1.5,
          forceStrutHeight: false,
        );
        final attr = utility.as(strutStyle);
        expect(attr.value, isA<MixProp<StrutStyle>>());
      });

      group('Property Utilities', () {
        test('fontWeight() creates strut style with font weight', () {
          final attr = utility.fontWeight(FontWeight.w600);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.bold() creates strut style with bold font weight', () {
          final attr = utility.fontWeight.bold();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test(
          'fontWeight.normal() creates strut style with normal font weight',
          () {
            final attr = utility.fontWeight.normal();
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );

        test('fontWeight.w100() creates strut style with w100 font weight', () {
          final attr = utility.fontWeight.w100();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w200() creates strut style with w200 font weight', () {
          final attr = utility.fontWeight.w200();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w300() creates strut style with w300 font weight', () {
          final attr = utility.fontWeight.w300();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w400() creates strut style with w400 font weight', () {
          final attr = utility.fontWeight.w400();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w500() creates strut style with w500 font weight', () {
          final attr = utility.fontWeight.w500();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w600() creates strut style with w600 font weight', () {
          final attr = utility.fontWeight.w600();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w700() creates strut style with w700 font weight', () {
          final attr = utility.fontWeight.w700();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w800() creates strut style with w800 font weight', () {
          final attr = utility.fontWeight.w800();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontWeight.w900() creates strut style with w900 font weight', () {
          final attr = utility.fontWeight.w900();
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontStyle() creates strut style with font style', () {
          final attr = utility.fontStyle(FontStyle.italic);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test(
          'fontStyle.italic() creates strut style with italic font style',
          () {
            final attr = utility.fontStyle.italic();
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );

        test(
          'fontStyle.normal() creates strut style with normal font style',
          () {
            final attr = utility.fontStyle.normal();
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );

        test('fontSize() creates strut style with font size', () {
          final attr = utility.fontSize(20.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('fontFamily() creates strut style with font family', () {
          final attr = utility.fontFamily('Helvetica');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test(
          'fontFamily.fromCharCodes() creates strut style with font family from char codes',
          () {
            final attr = utility.fontFamily.fromCharCodes([65, 66, 67]);
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );

        test(
          'fontFamily.fromCharCode() creates strut style with font family from char code',
          () {
            final attr = utility.fontFamily.fromCharCode(65);
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );

        test(
          'fontFamily.fromEnvironment() creates strut style with font family from environment',
          () {
            final attr = utility.fontFamily.fromEnvironment(
              'FONT_FAMILY',
              defaultValue: 'Arial',
            );
            expect(attr.value, isA<MixProp<StrutStyle>>());
          },
        );
      });

      group('Common Font Families', () {
        test('creates strut style with system font families', () {
          final attr = utility.fontFamily('system-ui');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with serif font family', () {
          final attr = utility.fontFamily('serif');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with sans-serif font family', () {
          final attr = utility.fontFamily('sans-serif');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with monospace font family', () {
          final attr = utility.fontFamily('monospace');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with cursive font family', () {
          final attr = utility.fontFamily('cursive');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with fantasy font family', () {
          final attr = utility.fontFamily('fantasy');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });
      });

      group('Font Size Variations', () {
        test('handles very small font size', () {
          final attr = utility.fontSize(8.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles standard font sizes', () {
          final attr = utility.fontSize(14.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles large font size', () {
          final attr = utility.fontSize(24.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles very large font size', () {
          final attr = utility.fontSize(48.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles fractional font size', () {
          final attr = utility.fontSize(16.5);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });
      });

      group('Font Weight Combinations', () {
        test('creates strut style with light weight and italic style', () {
          final lightItalic = StrutStyleMix.only(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
          );
          final attr = utility(lightItalic);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with bold weight and normal style', () {
          final boldNormal = StrutStyleMix.only(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          );
          final attr = utility(boldNormal);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style with medium weight and large size', () {
          final mediumLarge = StrutStyleMix.only(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          );
          final attr = utility(mediumLarge);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });
      });

      group('Edge Cases', () {
        test('handles zero font size', () {
          final attr = utility.fontSize(0.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles negative font size', () {
          final attr = utility.fontSize(-1.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles very large font size', () {
          final attr = utility.fontSize(1000.0);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles empty font family', () {
          final attr = utility.fontFamily('');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles font family with special characters', () {
          final attr = utility.fontFamily('Font-Name_123');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles font family with spaces', () {
          final attr = utility.fontFamily('Times New Roman');
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('handles very long font family name', () {
          final longName = 'A' * 100;
          final attr = utility.fontFamily(longName);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });
      });

      group('Complete StrutStyle Configurations', () {
        test('creates complete strut style with all properties', () {
          final completeStrutStyle = StrutStyleMix.only(
            fontFamily: 'Roboto',
            fontFamilyFallback: const ['Arial', 'sans-serif'],
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            height: 1.4,
            leading: 0.0,
            forceStrutHeight: false,
          );
          final attr = utility(completeStrutStyle);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style for headings', () {
          final headingStrutStyle = StrutStyleMix.only(
            fontFamily: 'Roboto',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            height: 1.2,
          );
          final attr = utility(headingStrutStyle);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style for body text', () {
          final bodyStrutStyle = StrutStyleMix.only(
            fontFamily: 'Roboto',
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            height: 1.5,
          );
          final attr = utility(bodyStrutStyle);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });

        test('creates strut style for captions', () {
          final captionStrutStyle = StrutStyleMix.only(
            fontFamily: 'Roboto',
            fontSize: 12.0,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            height: 1.3,
          );
          final attr = utility(captionStrutStyle);
          expect(attr.value, isA<MixProp<StrutStyle>>());
        });
      });

      test('token() creates strut style from token', () {
        const token = MixToken<StrutStyle>('test.strutStyle');
        final attr = utility.token(token);
        expect(attr.value, isA<MixProp<StrutStyle>>());
      });
    });
  });
}
