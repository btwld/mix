import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Enum Utility Extensions', () {
    group('BorderStylePropUtilityExt', () {
      final utility = MixUtility<MockStyle<BorderStyle>, BorderStyle>(
        MockStyle.new,
      );

      test('none() creates BorderStyle.none', () {
        final attr = utility(BorderStyle.none);
        expect(attr.value, BorderStyle.none);
      });

      test('solid() creates BorderStyle.solid', () {
        final attr = utility(BorderStyle.solid);
        expect(attr.value, BorderStyle.solid);
      });

      test('call() creates custom BorderStyle', () {
        final attr = utility(BorderStyle.solid);
        expect(attr.value, BorderStyle.solid);
      });
    });

    group('AxisPropUtilityExt', () {
      final utility = MixUtility<MockStyle<Axis>, Axis>(MockStyle.new);

      test('horizontal() creates Axis.horizontal', () {
        final attr = utility(Axis.horizontal);
        expect(attr.value, Axis.horizontal);
      });

      test('vertical() creates Axis.vertical', () {
        final attr = utility(Axis.vertical);
        expect(attr.value, Axis.vertical);
      });
    });

    group('StackFitPropUtilityExt', () {
      final utility = MixUtility<MockStyle<StackFit>, StackFit>(MockStyle.new);

      test('loose() creates StackFit.loose', () {
        final attr = utility(StackFit.loose);
        expect(attr.value, StackFit.loose);
      });

      test('expand() creates StackFit.expand', () {
        final attr = utility.expand();
        expect(attr.value, StackFit.expand);
      });

      test('passthrough() creates StackFit.passthrough', () {
        final attr = utility.passthrough();
        expect(attr.value, StackFit.passthrough);
      });
    });

    group('TextDirectionPropUtilityExt', () {
      final utility = MixUtility<MockStyle<TextDirection>, TextDirection>(
        MockStyle.new,
      );

      test('rtl() creates TextDirection.rtl', () {
        final attr = utility.rtl();
        expect(attr.value, TextDirection.rtl);
      });

      test('ltr() creates TextDirection.ltr', () {
        final attr = utility.ltr();
        expect(attr.value, TextDirection.ltr);
      });
    });

    group('TextLeadingDistributionPropUtilityExt', () {
      final utility =
          MixUtility<
            MockStyle<TextLeadingDistribution>,
            TextLeadingDistribution
          >(MockStyle.new);

      test('proportional() creates TextLeadingDistribution.proportional', () {
        final attr = utility.proportional();
        expect(attr.value, TextLeadingDistribution.proportional);
      });

      test('even() creates TextLeadingDistribution.even', () {
        final attr = utility.even();
        expect(attr.value, TextLeadingDistribution.even);
      });
    });

    group('TileModeUtility', () {
      const utility = MixUtility<MockStyle<TileMode>, TileMode>(MockStyle.new);

      test('clamp() creates TileMode.clamp', () {
        final attr = utility.clamp();
        expect(attr.value, TileMode.clamp);
      });

      test('repeated() creates TileMode.repeated', () {
        final attr = utility.repeated();
        expect(attr.value, TileMode.repeated);
      });

      test('mirror() creates TileMode.mirror', () {
        final attr = utility.mirror();
        expect(attr.value, TileMode.mirror);
      });

      test('decal() creates TileMode.decal', () {
        final attr = utility.decal();
        expect(attr.value, TileMode.decal);
      });
    });

    group('BoxFitUtility', () {
      const utility = MixUtility<MockStyle<BoxFit>, BoxFit>(MockStyle.new);

      test('fill() creates BoxFit.fill', () {
        final attr = utility.fill();
        expect(attr.value, BoxFit.fill);
      });

      test('contain() creates BoxFit.contain', () {
        final attr = utility.contain();
        expect(attr.value, BoxFit.contain);
      });

      test('cover() creates BoxFit.cover', () {
        final attr = utility.cover();
        expect(attr.value, BoxFit.cover);
      });

      test('fitWidth() creates BoxFit.fitWidth', () {
        final attr = utility.fitWidth();
        expect(attr.value, BoxFit.fitWidth);
      });

      test('fitHeight() creates BoxFit.fitHeight', () {
        final attr = utility.fitHeight();
        expect(attr.value, BoxFit.fitHeight);
      });

      test('none() creates BoxFit.none', () {
        final attr = utility(BoxFit.none);
        expect(attr.value, BoxFit.none);
      });

      test('scaleDown() creates BoxFit.scaleDown', () {
        final attr = utility.scaleDown();
        expect(attr.value, BoxFit.scaleDown);
      });
    });

    group('BoxShapeUtility', () {
      const utility = MixUtility<MockStyle<BoxShape>, BoxShape>(MockStyle.new);

      test('rectangle() creates BoxShape.rectangle', () {
        final attr = utility.rectangle();
        expect(attr.value, BoxShape.rectangle);
      });

      test('circle() creates BoxShape.circle', () {
        final attr = utility.circle();
        expect(attr.value, BoxShape.circle);
      });
    });

    group('FontStyleUtility', () {
      const utility = MixUtility<MockStyle<FontStyle>, FontStyle>(
        MockStyle.new,
      );

      test('normal() creates FontStyle.normal', () {
        final attr = utility.normal();
        expect(attr.value, FontStyle.normal);
      });

      test('italic() creates FontStyle.italic', () {
        final attr = utility.italic();
        expect(attr.value, FontStyle.italic);
      });
    });

    group('TextBaselineUtility', () {
      const utility = MixUtility<MockStyle<TextBaseline>, TextBaseline>(
        MockStyle.new,
      );

      test('alphabetic() creates TextBaseline.alphabetic', () {
        final attr = utility.alphabetic();
        expect(attr.value, TextBaseline.alphabetic);
      });

      test('ideographic() creates TextBaseline.ideographic', () {
        final attr = utility.ideographic();
        expect(attr.value, TextBaseline.ideographic);
      });
    });

    group('TextWidthBasisUtility', () {
      const utility = MixUtility<MockStyle<TextWidthBasis>, TextWidthBasis>(
        MockStyle.new,
      );

      test('parent() creates TextWidthBasis.parent', () {
        final attr = utility.parent();
        expect(attr.value, TextWidthBasis.parent);
      });

      test('longestLine() creates TextWidthBasis.longestLine', () {
        final attr = utility.longestLine();
        expect(attr.value, TextWidthBasis.longestLine);
      });
    });
  });
}
