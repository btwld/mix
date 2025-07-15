import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/internal/constants.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('AnimationConfigDto', () {
    test('should create an instance with default values', () {
      final dto = AnimationConfigDto.withDefaults();
      expect(dto.duration, equals(kDefaultAnimationDuration));
      expect(dto.curve, equals(Curves.linear));
    });

    test('should create an instance with provided values', () {
      final dto = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      expect(dto.duration, equals(const Duration(seconds: 2)));
      expect(dto.curve, equals(Curves.easeIn));
    });

    test('should merge with another instance', () {
      final dto1 = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      final dto2 = AnimationConfigDto(
        duration: Duration(seconds: 3),
        curve: Curves.easeOut,
      );
      final merged = dto1.merge(dto2);
      expect(merged.duration, equals(const Duration(seconds: 3)));
      expect(merged.curve, equals(Curves.easeOut));
    });

    test('should resolve to an AnimationConfig instance', () {
      final dto = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      final animationConfig = dto.resolve(EmptyMixData);
      expect(animationConfig.duration, equals(const Duration(seconds: 2)));
      expect(animationConfig.curve, equals(Curves.easeIn));
    });

    // test equality
    test('should be equal to another instance', () {
      final dto1 = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      final dto2 = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      expect(dto1, equals(dto2));
    });

    test('should not be equal to another instance', () {
      final dto1 = AnimationConfigDto(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      final dto2 = AnimationConfigDto(
        duration: Duration(seconds: 3),
        curve: Curves.easeIn,
      );
      expect(dto1, isNot(equals(dto2)));
    });
  });

  group('AnimationConfig', () {
    test('should create an instance with default values', () {
      const animationConfig = AnimationConfig.withDefaults();
      expect(animationConfig.duration, equals(kDefaultAnimationDuration));
      expect(animationConfig.curve, equals(Curves.linear));
    });

    test('should create an instance with provided values', () {
      const animationConfig = AnimationConfig(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      expect(animationConfig.duration, equals(const Duration(seconds: 2)));
      expect(animationConfig.curve, equals(Curves.easeIn));
    });

    test('should return default values if not set', () {
      const animationConfig = AnimationConfig(duration: null, curve: null);
      expect(animationConfig.duration, equals(kDefaultAnimationDuration));
      expect(animationConfig.curve, equals(Curves.linear));
    });

    test('should convert to an AnimationConfigDto', () {
      const animationConfig = AnimationConfig(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      final dto = animationConfig.toDto();
      expect(dto.duration, equals(const Duration(seconds: 2)));
      expect(dto.curve, equals(Curves.easeIn));
    });

    // equality
    test('should be equal to another instance', () {
      const animationConfig1 = AnimationConfig(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      const animationConfig2 = AnimationConfig(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      expect(animationConfig1, equals(animationConfig2));
    });

    test('should not be equal to another instance', () {
      const animationConfig1 = AnimationConfig(
        duration: Duration(seconds: 2),
        curve: Curves.easeIn,
      );
      const animationConfig2 = AnimationConfig(
        duration: Duration(seconds: 3),
        curve: Curves.easeIn,
      );
      expect(animationConfig1, isNot(equals(animationConfig2)));
    });
  });

  group('Backward Compatibility', () {
    test('AnimatedData typedef should work', () {
      // ignore: deprecated_member_use_from_same_package
      final animatedData = AnimatedData.withDefaults();
      expect(animatedData.duration, equals(kDefaultAnimationDuration));
      expect(animatedData.curve, equals(Curves.linear));
    });

    test('AnimatedDataDto typedef should work', () {
      // ignore: deprecated_member_use_from_same_package
      final dto = AnimatedDataDto.withDefaults();
      expect(dto.duration, equals(kDefaultAnimationDuration));
      expect(dto.curve, equals(Curves.linear));
    });
  });
}
