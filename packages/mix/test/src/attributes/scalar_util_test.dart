import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Scalar Utilities Extensions', () {
    group('BorderStylePropUtilityExt', () {
      final utility = PropUtility<UtilityTestAttribute, BorderStyle>(
        UtilityTestAttribute.new,
      );

      test('none() creates BorderStyle.none', () {
        final attr = utility.none();
        expectProp(attr.value, BorderStyle.none);
      });

      test('solid() creates BorderStyle.solid', () {
        final attr = utility.solid();
        expectProp(attr.value, BorderStyle.solid);
      });

      test('call() creates custom BorderStyle', () {
        final attr = utility(BorderStyle.solid);
        expectProp(attr.value, BorderStyle.solid);
      });
    });

    group('AxisPropUtilityExt', () {
      final utility = PropUtility<UtilityTestAttribute, Axis>(
        UtilityTestAttribute.new,
      );

      test('horizontal() creates Axis.horizontal', () {
        final attr = utility.horizontal();
        expectProp(attr.value, Axis.horizontal);
      });

      test('vertical() creates Axis.vertical', () {
        final attr = utility.vertical();
        expectProp(attr.value, Axis.vertical);
      });
    });

    group('StackFitPropUtilityExt', () {
      final utility = PropUtility<UtilityTestAttribute, StackFit>(
        UtilityTestAttribute.new,
      );

      test('loose() creates StackFit.loose', () {
        final attr = utility.loose();
        expectProp(attr.value, StackFit.loose);
      });

      test('expand() creates StackFit.expand', () {
        final attr = utility.expand();
        expectProp(attr.value, StackFit.expand);
      });

      test('passthrough() creates StackFit.passthrough', () {
        final attr = utility.passthrough();
        expectProp(attr.value, StackFit.passthrough);
      });
    });

    group('TextDirectionPropUtilityExt', () {
      final utility = PropUtility<UtilityTestAttribute, TextDirection>(
        UtilityTestAttribute.new,
      );

      test('rtl() creates TextDirection.rtl', () {
        final attr = utility.rtl();
        expectProp(attr.value, TextDirection.rtl);
      });

      test('ltr() creates TextDirection.ltr', () {
        final attr = utility.ltr();
        expectProp(attr.value, TextDirection.ltr);
      });
    });

    group('TextLeadingDistributionPropUtilityExt', () {
      final utility =
          PropUtility<UtilityTestAttribute, TextLeadingDistribution>(
            UtilityTestAttribute.new,
          );

      test('proportional() creates TextLeadingDistribution.proportional', () {
        final attr = utility.proportional();
        expectProp(attr.value, TextLeadingDistribution.proportional);
      });

      test('even() creates TextLeadingDistribution.even', () {
        final attr = utility.even();
        expectProp(attr.value, TextLeadingDistribution.even);
      });
    });

    group('TileModeUtility', () {
      const utility = PropUtility<UtilityTestAttribute, TileMode>(
        UtilityTestAttribute.new,
      );

      test('clamp() creates TileMode.clamp', () {
        final attr = utility.clamp();
        expectProp(attr.value, TileMode.clamp);
      });

      test('repeated() creates TileMode.repeated', () {
        final attr = utility.repeated();
        expectProp(attr.value, TileMode.repeated);
      });

      test('mirror() creates TileMode.mirror', () {
        final attr = utility.mirror();
        expectProp(attr.value, TileMode.mirror);
      });

      test('decal() creates TileMode.decal', () {
        final attr = utility.decal();
        expectProp(attr.value, TileMode.decal);
      });
    });

    group('BoxFitUtility', () {
      const utility = PropUtility<UtilityTestAttribute, BoxFit>(
        UtilityTestAttribute.new,
      );

      test('fill() creates BoxFit.fill', () {
        final attr = utility.fill();
        expectProp(attr.value, BoxFit.fill);
      });

      test('contain() creates BoxFit.contain', () {
        final attr = utility.contain();
        expectProp(attr.value, BoxFit.contain);
      });

      test('cover() creates BoxFit.cover', () {
        final attr = utility.cover();
        expectProp(attr.value, BoxFit.cover);
      });

      test('fitWidth() creates BoxFit.fitWidth', () {
        final attr = utility.fitWidth();
        expectProp(attr.value, BoxFit.fitWidth);
      });

      test('fitHeight() creates BoxFit.fitHeight', () {
        final attr = utility.fitHeight();
        expectProp(attr.value, BoxFit.fitHeight);
      });

      test('none() creates BoxFit.none', () {
        final attr = utility.none();
        expectProp(attr.value, BoxFit.none);
      });

      test('scaleDown() creates BoxFit.scaleDown', () {
        final attr = utility.scaleDown();
        expectProp(attr.value, BoxFit.scaleDown);
      });
    });

    group('BoxShapeUtility', () {
      const utility = PropUtility<UtilityTestAttribute, BoxShape>(
        UtilityTestAttribute.new,
      );

      test('rectangle() creates BoxShape.rectangle', () {
        final attr = utility.rectangle();
        expectProp(attr.value, BoxShape.rectangle);
      });

      test('circle() creates BoxShape.circle', () {
        final attr = utility.circle();
        expectProp(attr.value, BoxShape.circle);
      });
    });

    group('FontStyleUtility', () {
      const utility = PropUtility<UtilityTestAttribute, FontStyle>(
        UtilityTestAttribute.new,
      );

      test('normal() creates FontStyle.normal', () {
        final attr = utility.normal();
        expectProp(attr.value, FontStyle.normal);
      });

      test('italic() creates FontStyle.italic', () {
        final attr = utility.italic();
        expectProp(attr.value, FontStyle.italic);
      });
    });

    group('FontWeightUtility', () {
      const utility = FontWeightUtility(UtilityTestAttribute.new);

      test('bold() creates FontWeight.bold', () {
        final attr = utility.bold();
        expectProp(attr.value, FontWeight.bold);
      });

      test('normal() creates FontWeight.normal', () {
        final attr = utility.normal();
        expectProp(attr.value, FontWeight.normal);
      });

      test('w100() creates FontWeight.w100', () {
        final attr = utility.w100();
        expectProp(attr.value, FontWeight.w100);
      });

      test('w200() creates FontWeight.w200', () {
        final attr = utility.w200();
        expectProp(attr.value, FontWeight.w200);
      });

      test('w300() creates FontWeight.w300', () {
        final attr = utility.w300();
        expectProp(attr.value, FontWeight.w300);
      });

      test('w400() creates FontWeight.w400', () {
        final attr = utility.w400();
        expectProp(attr.value, FontWeight.w400);
      });

      test('w500() creates FontWeight.w500', () {
        final attr = utility.w500();
        expectProp(attr.value, FontWeight.w500);
      });

      test('w600() creates FontWeight.w600', () {
        final attr = utility.w600();
        expectProp(attr.value, FontWeight.w600);
      });

      test('w700() creates FontWeight.w700', () {
        final attr = utility.w700();
        expectProp(attr.value, FontWeight.w700);
      });

      test('w800() creates FontWeight.w800', () {
        final attr = utility.w800();
        expectProp(attr.value, FontWeight.w800);
      });

      test('w900() creates FontWeight.w900', () {
        final attr = utility.w900();
        expectProp(attr.value, FontWeight.w900);
      });
    });

    group('TextBaselineUtility', () {
      const utility = PropUtility<UtilityTestAttribute, TextBaseline>(
        UtilityTestAttribute.new,
      );

      test('alphabetic() creates TextBaseline.alphabetic', () {
        final attr = utility.alphabetic();
        expectProp(attr.value, TextBaseline.alphabetic);
      });

      test('ideographic() creates TextBaseline.ideographic', () {
        final attr = utility.ideographic();
        expectProp(attr.value, TextBaseline.ideographic);
      });
    });

    group('TextWidthBasisUtility', () {
      const utility = PropUtility<UtilityTestAttribute, TextWidthBasis>(
        UtilityTestAttribute.new,
      );

      test('parent() creates TextWidthBasis.parent', () {
        final attr = utility.parent();
        expectProp(attr.value, TextWidthBasis.parent);
      });

      test('longestLine() creates TextWidthBasis.longestLine', () {
        final attr = utility.longestLine();
        expectProp(attr.value, TextWidthBasis.longestLine);
      });
    });

    group('AlignmentUtility', () {
      const utility = AlignmentUtility(UtilityTestAttribute.new);

      test('topLeft() creates Alignment.topLeft', () {
        final attr = utility.topLeft();
        expectProp(attr.value, Alignment.topLeft);
      });

      test('topCenter() creates Alignment.topCenter', () {
        final attr = utility.topCenter();
        expectProp(attr.value, Alignment.topCenter);
      });

      test('topRight() creates Alignment.topRight', () {
        final attr = utility.topRight();
        expectProp(attr.value, Alignment.topRight);
      });

      test('centerLeft() creates Alignment.centerLeft', () {
        final attr = utility.centerLeft();
        expectProp(attr.value, Alignment.centerLeft);
      });

      test('center() creates Alignment.center', () {
        final attr = utility.center();
        expectProp(attr.value, Alignment.center);
      });

      test('centerRight() creates Alignment.centerRight', () {
        final attr = utility.centerRight();
        expectProp(attr.value, Alignment.centerRight);
      });

      test('bottomLeft() creates Alignment.bottomLeft', () {
        final attr = utility.bottomLeft();
        expectProp(attr.value, Alignment.bottomLeft);
      });

      test('bottomCenter() creates Alignment.bottomCenter', () {
        final attr = utility.bottomCenter();
        expectProp(attr.value, Alignment.bottomCenter);
      });

      test('bottomRight() creates Alignment.bottomRight', () {
        final attr = utility.bottomRight();
        expectProp(attr.value, Alignment.bottomRight);
      });

      test('only() creates custom Alignment', () {
        final attr = utility.only(x: 0.5, y: -0.5);
        expectProp(attr.value, const Alignment(0.5, -0.5));
      });

      test('only() creates AlignmentDirectional when start is provided', () {
        final attr = utility.only(start: 0.5, y: -0.5);
        expectProp(attr.value, const AlignmentDirectional(0.5, -0.5));
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
