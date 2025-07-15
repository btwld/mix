import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('TextHeightBehaviorDto', () {
    test('creates with default values', () {
      final dto = TextHeightBehaviorDto();
      expect(dto.applyHeightToFirstAscent, isNull);
      expect(dto.applyHeightToLastDescent, isNull);
      expect(dto.leadingDistribution, isNull);
    });

    test('creates with custom values', () {
      final dto = TextHeightBehaviorDto(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: false,
        leadingDistribution: TextLeadingDistribution.even,
      );
      expect(dto.applyHeightToFirstAscent, resolvesTo(true));
      expect(dto.applyHeightToLastDescent, resolvesTo(false));
      expect(dto.leadingDistribution, resolvesTo(TextLeadingDistribution.even));
    });
  });

  group('TextHeightBehaviorUtility', () {
    late TextHeightBehaviorUtility utility;

    setUp(() {
      utility = TextHeightBehaviorUtility(UtilityTestAttribute.new);
    });

    test('heightToFirstAscent sets applyHeightToFirstAscent', () {
      final result =
          utility.heightToFirstAscent(true)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, isNull);
      expect(result.value.leadingDistribution, isNull);
    });

    test('heightToLastDescent sets applyHeightToLastDescent', () {
      final result =
          utility.heightToLastDescent(false)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, isNull);
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(result.value.leadingDistribution, isNull);
    });

    test('leadingDistribution sets leadingDistribution', () {
      final result =
          utility.leadingDistribution(TextLeadingDistribution.proportional)
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, isNull);
      expect(result.value.applyHeightToLastDescent, isNull);
      expect(
        result.value.leadingDistribution,
        resolvesTo(TextLeadingDistribution.proportional),
      );
    });

    test('only sets multiple properties', () {
      final result =
          utility.only(
                applyHeightToFirstAscent: true,
                applyHeightToLastDescent: false,
                leadingDistribution: TextLeadingDistribution.even,
              )
              as UtilityTestAttribute<TextHeightBehaviorDto>;
      expect(result.value.applyHeightToFirstAscent, resolvesTo(true));
      expect(result.value.applyHeightToLastDescent, resolvesTo(false));
      expect(result.value.leadingDistribution, resolvesTo(TextLeadingDistribution.even));
    });
  });
}
