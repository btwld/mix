import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ModifiersDataDto', () {
    test('should create an instance with default values', () {
      const dto = WidgetModifiersConfigDto([]);
      expect(dto.value, isEmpty);
    });

    test('should create an instance with provided values', () {
      const modifier1 = TestModifierSpecAttribute();
      const modifier2 = TestModifierSpecAttribute();
      // ignore: equal_elements_in_set
      const dto = WidgetModifiersConfigDto([modifier1, modifier2]);
      expect(dto.value, contains(modifier1));
    });

    test('should merge with another instance', () {
      const dto1 = WidgetModifiersConfigDto([TestModifierSpecAttribute()]);
      const dto2 = WidgetModifiersConfigDto([TestModifierSpecAttribute(2)]);
      final merged = dto1.merge(dto2);
      expect(merged.value, hasLength(1));
      expect(merged.value.first, const TestModifierSpecAttribute(2));
    });

    test('should resolve to a ModifiersData instance', () {
      const modifier = TestModifierSpecAttribute();
      const dto = WidgetModifiersConfigDto([modifier]);
      final modifiersData = dto.resolve(EmptyMixData);
      expect(modifiersData.value.length, 1);
      expect(modifiersData.value.first, const TestModifierSpec());
    });

    // test equality
    test('should be equal to another instance', () {
      const dto1 = WidgetModifiersConfigDto([TestModifierSpecAttribute()]);
      const dto2 = WidgetModifiersConfigDto([TestModifierSpecAttribute()]);
      expect(dto1, equals(dto2));
    });

    test('should not be equal to another instance', () {
      const dto1 = WidgetModifiersConfigDto([TestModifierSpecAttribute()]);
      const dto2 = WidgetModifiersConfigDto([TestModifierSpecAttribute(2)]);
      expect(dto1, isNot(equals(dto2)));
    });
  });

  group('ModifiersData', () {
    test('should create an instance with provided values', () {
      const modifier1 = TestModifierSpec();
      const modifier2 = TestModifierSpec();
      // ignore: equal_elements_in_set
      const modifiersData = WidgetModifiersConfig([modifier1, modifier2]);
      expect(modifiersData.value, contains(modifier1));
    });

    // equality
    test('should be equal to another instance', () {
      const modifiersData1 = WidgetModifiersConfig([TestModifierSpec()]);
      const modifiersData2 = WidgetModifiersConfig([TestModifierSpec()]);
      expect(modifiersData1, equals(modifiersData2));
    });

    test('should not be equal to another instance', () {
      const modifiersData1 = WidgetModifiersConfig([TestModifierSpec()]);
      const modifiersData2 = WidgetModifiersConfig([]);
      expect(modifiersData1, isNot(equals(modifiersData2)));
    });
  });
}

final class TestModifierSpec extends WidgetModifierSpec<TestModifierSpec> {
  const TestModifierSpec([this.value = 1]);
  final int value;
  @override
  Widget build(Widget child) {
    throw UnimplementedError();
  }

  @override
  TestModifierSpec lerp(TestModifierSpec other, double t) {
    return this;
  }

  @override
  TestModifierSpec copyWith() {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [value];
}

final class TestModifierSpecAttribute
    extends WidgetModifierSpecAttribute<TestModifierSpec> {
  const TestModifierSpecAttribute([this.value = 1]);

  final int value;

  @override
  List<Object?> get props => [value];

  @override
  SpecAttribute<TestModifierSpec> merge(
      covariant SpecAttribute<TestModifierSpec>? other) {
    return other ?? this;
  }

  @override
  TestModifierSpec resolve(MixContext mix) {
    return const TestModifierSpec();
  }
}
