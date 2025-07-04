import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/internal/constants.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('AnimatedDataDto', () {
    test('should create an instance with default values', () {
      const dto = AnimationConfigDto.withDefaults();
      expect(dto.duration, equals(kDefaultAnimationDuration));
      expect(dto.curve, equals(Curves.linear));
    });

    test('should create an instance with provided values', () {
      const dto = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      expect(dto.duration, equals(const Duration(seconds: 2)));
      expect(dto.curve, equals(Curves.easeIn));
    });

    test('should merge with another instance', () {
      const dto1 = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      const dto2 = AnimationConfigDto(
          duration: Duration(seconds: 3), curve: Curves.easeOut);
      final merged = dto1.merge(dto2);
      expect(merged.duration, equals(const Duration(seconds: 3)));
      expect(merged.curve, equals(Curves.easeOut));
    });

    test('should resolve to an AnimatedData instance', () {
      const dto = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      final animatedData = dto.resolve(EmptyMixData);
      expect(animatedData.duration, equals(const Duration(seconds: 2)));
      expect(animatedData.curve, equals(Curves.easeIn));
    });

    // test equality
    test('should be equal to another instance', () {
      const dto1 = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      const dto2 = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      expect(dto1, equals(dto2));
    });

    test('should not be equal to another instance', () {
      const dto1 = AnimationConfigDto(
          duration: Duration(seconds: 2), curve: Curves.easeIn);
      const dto2 = AnimationConfigDto(
          duration: Duration(seconds: 3), curve: Curves.easeIn);
      expect(dto1, isNot(equals(dto2)));
    });
  });

  group('AnimatedData', () {
    test('should create an instance with default values', () {
      const animatedData = AnimationConfig.withDefaults();
      expect(animatedData.duration, equals(kDefaultAnimationDuration));
      expect(animatedData.curve, equals(Curves.linear));
    });

    test('should create an instance with provided values', () {
      const animatedData =
          AnimationConfig(duration: Duration(seconds: 2), curve: Curves.easeIn);
      expect(animatedData.duration, equals(const Duration(seconds: 2)));
      expect(animatedData.curve, equals(Curves.easeIn));
    });

    test('should return default values if not set', () {
      const animatedData = AnimationConfig(duration: null, curve: null);
      expect(animatedData.duration, equals(kDefaultAnimationDuration));
      expect(animatedData.curve, equals(Curves.linear));
    });

    test('should convert to an AnimatedDataDto', () {
      const animatedData =
          AnimationConfig(duration: Duration(seconds: 2), curve: Curves.easeIn);
      final dto = animatedData.toDto();
      expect(dto.duration, equals(const Duration(seconds: 2)));
      expect(dto.curve, equals(Curves.easeIn));
    });

    // equality
    test('should be equal to another instance', () {
      const animatedData1 =
          AnimationConfig(duration: Duration(seconds: 2), curve: Curves.easeIn);
      const animatedData2 =
          AnimationConfig(duration: Duration(seconds: 2), curve: Curves.easeIn);
      expect(animatedData1, equals(animatedData2));
    });

    test('should not be equal to another instance', () {
      const animatedData1 =
          AnimationConfig(duration: Duration(seconds: 2), curve: Curves.easeIn);
      const animatedData2 =
          AnimationConfig(duration: Duration(seconds: 3), curve: Curves.easeIn);
      expect(animatedData1, isNot(equals(animatedData2)));
    });
  });
}
