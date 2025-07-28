import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Enum Utility Extensions', () {
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
  });
}