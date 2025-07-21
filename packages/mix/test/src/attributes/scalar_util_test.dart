import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Scalar Utilities', () {
    group('BorderStyleUtility', () {
      const utility = BorderStyleUtility(UtilityTestAttribute.new);

      test('none() creates BorderStyle.none', () {
        final attr = utility.none();
        expect(attr.value!.value, BorderStyle.none);
      });

      test('solid() creates BorderStyle.solid', () {
        final attr = utility.solid();
        expect(attr.value!.value, BorderStyle.solid);
      });

      test('call() creates custom BorderStyle', () {
        final attr = utility(BorderStyle.solid);
        expect(attr.value!.value, BorderStyle.solid);
      });
    });

    group('AxisUtility', () {
      const utility = AxisUtility(UtilityTestAttribute.new);

      test('horizontal() creates Axis.horizontal', () {
        final attr = utility.horizontal();
        expect(attr.value!.value, Axis.horizontal);
      });

      test('vertical() creates Axis.vertical', () {
        final attr = utility.vertical();
        expect(attr.value!.value, Axis.vertical);
      });
    });

    group('StackFitUtility', () {
      const utility = StackFitUtility(UtilityTestAttribute.new);

      test('loose() creates StackFit.loose', () {
        final attr = utility.loose();
        expect(attr.value!.value, StackFit.loose);
      });

      test('expand() creates StackFit.expand', () {
        final attr = utility.expand();
        expect(attr.value!.value, StackFit.expand);
      });

      test('passthrough() creates StackFit.passthrough', () {
        final attr = utility.passthrough();
        expect(attr.value!.value, StackFit.passthrough);
      });
    });

    group('TextDirectionUtility', () {
      const utility = TextDirectionUtility(UtilityTestAttribute.new);

      test('rtl() creates TextDirection.rtl', () {
        final attr = utility.rtl();
        expect(attr.value!.value, TextDirection.rtl);
      });

      test('ltr() creates TextDirection.ltr', () {
        final attr = utility.ltr();
        expect(attr.value!.value, TextDirection.ltr);
      });
    });

    group('TextLeadingDistributionUtility', () {
      const utility = TextLeadingDistributionUtility(UtilityTestAttribute.new);

      test('proportional() creates TextLeadingDistribution.proportional', () {
        final attr = utility.proportional();
        expect(attr.value!.value, TextLeadingDistribution.proportional);
      });

      test('even() creates TextLeadingDistribution.even', () {
        final attr = utility.even();
        expect(attr.value!.value, TextLeadingDistribution.even);
      });
    });

    group('TileModeUtility', () {
      const utility = TileModeUtility(UtilityTestAttribute.new);

      test('clamp() creates TileMode.clamp', () {
        final attr = utility.clamp();
        expect(attr.value!.value, TileMode.clamp);
      });

      test('repeated() creates TileMode.repeated', () {
        final attr = utility.repeated();
        expect(attr.value!.value, TileMode.repeated);
      });

      test('mirror() creates TileMode.mirror', () {
        final attr = utility.mirror();
        expect(attr.value!.value, TileMode.mirror);
      });

      test('decal() creates TileMode.decal', () {
        final attr = utility.decal();
        expect(attr.value!.value, TileMode.decal);
      });
    });

    group('BoxFitUtility', () {
      const utility = BoxFitUtility(UtilityTestAttribute.new);

      test('fill() creates BoxFit.fill', () {
        final attr = utility.fill();
        expect(attr.value!.value, BoxFit.fill);
      });

      test('contain() creates BoxFit.contain', () {
        final attr = utility.contain();
        expect(attr.value!.value, BoxFit.contain);
      });

      test('cover() creates BoxFit.cover', () {
        final attr = utility.cover();
        expect(attr.value!.value, BoxFit.cover);
      });

      test('fitWidth() creates BoxFit.fitWidth', () {
        final attr = utility.fitWidth();
        expect(attr.value!.value, BoxFit.fitWidth);
      });

      test('fitHeight() creates BoxFit.fitHeight', () {
        final attr = utility.fitHeight();
        expect(attr.value!.value, BoxFit.fitHeight);
      });

      test('none() creates BoxFit.none', () {
        final attr = utility.none();
        expect(attr.value!.value, BoxFit.none);
      });

      test('scaleDown() creates BoxFit.scaleDown', () {
        final attr = utility.scaleDown();
        expect(attr.value!.value, BoxFit.scaleDown);
      });
    });

    group('BoxShapeUtility', () {
      const utility = BoxShapeUtility(UtilityTestAttribute.new);

      test('rectangle() creates BoxShape.rectangle', () {
        final attr = utility.rectangle();
        expect(attr.value!.value, BoxShape.rectangle);
      });

      test('circle() creates BoxShape.circle', () {
        final attr = utility.circle();
        expect(attr.value!.value, BoxShape.circle);
      });
    });

    group('FontStyleUtility', () {
      const utility = FontStyleUtility(UtilityTestAttribute.new);

      test('normal() creates FontStyle.normal', () {
        final attr = utility.normal();
        expect(attr.value!.value, FontStyle.normal);
      });

      test('italic() creates FontStyle.italic', () {
        final attr = utility.italic();
        expect(attr.value!.value, FontStyle.italic);
      });
    });

    group('FontWeightUtility', () {
      const utility = FontWeightUtility(UtilityTestAttribute.new);

      test('bold() creates FontWeight.bold', () {
        final attr = utility.bold();
        expect(attr.value!.value, FontWeight.bold);
      });

      test('normal() creates FontWeight.normal', () {
        final attr = utility.normal();
        expect(attr.value!.value, FontWeight.normal);
      });

      test('w100() creates FontWeight.w100', () {
        final attr = utility.w100();
        expect(attr.value!.value, FontWeight.w100);
      });

      test('w200() creates FontWeight.w200', () {
        final attr = utility.w200();
        expect(attr.value!.value, FontWeight.w200);
      });

      test('w300() creates FontWeight.w300', () {
        final attr = utility.w300();
        expect(attr.value!.value, FontWeight.w300);
      });

      test('w400() creates FontWeight.w400', () {
        final attr = utility.w400();
        expect(attr.value!.value, FontWeight.w400);
      });

      test('w500() creates FontWeight.w500', () {
        final attr = utility.w500();
        expect(attr.value!.value, FontWeight.w500);
      });

      test('w600() creates FontWeight.w600', () {
        final attr = utility.w600();
        expect(attr.value!.value, FontWeight.w600);
      });

      test('w700() creates FontWeight.w700', () {
        final attr = utility.w700();
        expect(attr.value!.value, FontWeight.w700);
      });

      test('w800() creates FontWeight.w800', () {
        final attr = utility.w800();
        expect(attr.value!.value, FontWeight.w800);
      });

      test('w900() creates FontWeight.w900', () {
        final attr = utility.w900();
        expect(attr.value!.value, FontWeight.w900);
      });
    });

    group('TextBaselineUtility', () {
      const utility = TextBaselineUtility(UtilityTestAttribute.new);

      test('alphabetic() creates TextBaseline.alphabetic', () {
        final attr = utility.alphabetic();
        expect(attr.value!.value, TextBaseline.alphabetic);
      });

      test('ideographic() creates TextBaseline.ideographic', () {
        final attr = utility.ideographic();
        expect(attr.value!.value, TextBaseline.ideographic);
      });
    });

    group('TextWidthBasisUtility', () {
      const utility = TextWidthBasisUtility(UtilityTestAttribute.new);

      test('parent() creates TextWidthBasis.parent', () {
        final attr = utility.parent();
        expect(attr.value!.value, TextWidthBasis.parent);
      });

      test('longestLine() creates TextWidthBasis.longestLine', () {
        final attr = utility.longestLine();
        expect(attr.value!.value, TextWidthBasis.longestLine);
      });
    });

    group('AlignmentUtility', () {
      const utility = AlignmentUtility(UtilityTestAttribute.new);

      test('topLeft() creates Alignment.topLeft', () {
        final attr = utility.topLeft();
        expect(attr.value!.value, Alignment.topLeft);
      });

      test('topCenter() creates Alignment.topCenter', () {
        final attr = utility.topCenter();
        expect(attr.value!.value, Alignment.topCenter);
      });

      test('topRight() creates Alignment.topRight', () {
        final attr = utility.topRight();
        expect(attr.value!.value, Alignment.topRight);
      });

      test('centerLeft() creates Alignment.centerLeft', () {
        final attr = utility.centerLeft();
        expect(attr.value!.value, Alignment.centerLeft);
      });

      test('center() creates Alignment.center', () {
        final attr = utility.center();
        expect(attr.value!.value, Alignment.center);
      });

      test('centerRight() creates Alignment.centerRight', () {
        final attr = utility.centerRight();
        expect(attr.value!.value, Alignment.centerRight);
      });

      test('bottomLeft() creates Alignment.bottomLeft', () {
        final attr = utility.bottomLeft();
        expect(attr.value!.value, Alignment.bottomLeft);
      });

      test('bottomCenter() creates Alignment.bottomCenter', () {
        final attr = utility.bottomCenter();
        expect(attr.value!.value, Alignment.bottomCenter);
      });

      test('bottomRight() creates Alignment.bottomRight', () {
        final attr = utility.bottomRight();
        expect(attr.value!.value, Alignment.bottomRight);
      });

      test('only() creates custom Alignment', () {
        final attr = utility.only(x: 0.5, y: -0.5);
        expect(attr.value!.value, const Alignment(0.5, -0.5));
      });

      test('only() creates AlignmentDirectional when start is provided', () {
        final attr = utility.only(start: 0.5, y: -0.5);
        expect(attr.value!.value, const AlignmentDirectional(0.5, -0.5));
      });

      test('only() throws when both x and start are provided', () {
        expect(
          () => utility.only(x: 0.5, start: 0.5, y: -0.5),
          throwsAssertionError,
        );
      });
    });
  });
}
