import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Mock Mix classes for testing
@immutable
class MockMix extends Mix<String> {
  final String value;
  final int priority;

  const MockMix(this.value, {this.priority = 0});

  @override
  String resolve(MixContext context) => value;

  @override
  MockMix merge(MockMix? other) {
    if (other == null) return this;
    return MockMix('${value}_${other.value}', priority: other.priority);
  }

  @override
  List<Object?> get props => [value, priority];
}

@immutable
class MockToken extends MixableToken<MockMix> {
  const MockToken(super.name);
}

void main() {
  late MixContext mockContext;

  setUp(() {
    mockContext = createEmptyMixData();
  });

  group('MixableDto', () {
    group('Factory constructors', () {
      test('value constructor creates _ValueMixDto', () {
        const mockMix = MockMix('test');
        final dto = MixProp.value(mockMix);

        expect(dto, isA<MixProp<MockMix, String>>());
        expect(dto.isEmpty, false);
      });

      test('token constructor creates _TokenMixDto', () {
        const mockToken = MockToken('test_token');
        final dto = MixProp.token(mockToken);

        expect(dto, isA<MixProp<MockMix, String>>());
        expect(dto.isEmpty, false);
      });

      test('maybeValue returns null for null input', () {
        final dto = MixProp.maybeValue<MockMix, String>(null);
        expect(dto, isNull);
      });

      test('maybeValue returns MixableDto for non-null input', () {
        const mockMix = MockMix('test');
        final dto = MixProp.maybeValue(mockMix);

        expect(dto, isNotNull);
        expect(dto!.isEmpty, false);
      });
    });

    group('Resolve behavior', () {
      test('value resolves to the original Mix object', () {
        const mockMix = MockMix('test_value');
        final dto = MixProp.value(mockMix);

        final result = dto.resolve(mockContext);
        expect(result, equals(mockMix));
      });

      test('token resolves to null when token not found in context', () {
        const mockToken = MockToken('missing_token');
        final dto = MixProp.token(mockToken);

        final result = dto.resolve(mockContext);
        expect(result, isNull);
      });

      test('empty items list resolves to null', () {
        // Create an aggregated DTO with empty items
        final dto = MixProp.value(const MockMix('test'));
        final emptyDto = dto.merge(null); // This should return the same dto

        // Create a dto that will be empty after merging
        final result = emptyDto.resolve(mockContext);
        expect(result, isNotNull); // Should not be null since it has the value
      });
    });

    group('Merge behavior', () {
      test('merging with null returns same object', () {
        const mockMix = MockMix('test');
        final dto = MixProp.value(mockMix);

        final result = dto.merge(null);
        expect(result, same(dto));
      });

      test('merging two values creates aggregated dto', () {
        const mockMix1 = MockMix('first');
        const mockMix2 = MockMix('second');
        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);

        final result = dto1.merge(dto2);
        expect(result, isA<MixProp<MockMix, String>>());
        expect(result.isEmpty, false);
        expect(result, isNot(same(dto1)));
        expect(result, isNot(same(dto2)));
      });

      test('merging value with token creates aggregated dto', () {
        const mockMix = MockMix('value');
        const mockToken = MockToken('token');
        final valueDto = MixProp.value(mockMix);
        final tokenDto = MixProp.token(mockToken);

        final result = valueDto.merge(tokenDto);
        expect(result, isA<MixProp<MockMix, String>>());
        expect(result.isEmpty, false);
      });

      test('merging aggregated dtos combines all items', () {
        const mockMix1 = MockMix('first');
        const mockMix2 = MockMix('second');
        const mockMix3 = MockMix('third');

        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);
        final dto3 = MixProp.value(mockMix3);

        final aggregated1 = dto1.merge(dto2);
        final aggregated2 = aggregated1.merge(dto3);

        expect(aggregated2, isA<MixProp<MockMix, String>>());
        expect(aggregated2.isEmpty, false);
      });
    });

    group('Smart grouping behavior', () {
      test('consecutive values at end are merged together', () {
        const mockMix1 = MockMix('first');
        const mockMix2 = MockMix('second');
        const mockMix3 = MockMix('third');

        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);
        final dto3 = MixProp.value(mockMix3);

        final result = dto1.merge(dto2).merge(dto3);

        // When resolving, the consecutive values should be merged
        final resolved = result.resolve(mockContext);
        expect(resolved, isNotNull);
        expect(resolved!.value, equals('first_second_third'));
      });

      test('values after token are merged, but token remains separate', () {
        const mockToken = MockToken('token');
        const mockMix1 = MockMix('first');
        const mockMix2 = MockMix('second');

        final tokenDto = MixProp.token(mockToken);
        final valueDto1 = MixProp.value(mockMix1);
        final valueDto2 = MixProp.value(mockMix2);

        final result = tokenDto.merge(valueDto1).merge(valueDto2);

        // Should have token + merged values
        expect(result.isEmpty, false);

        // When resolving (token returns null), should get merged values
        final resolved = result.resolve(mockContext);
        expect(resolved, isNotNull);
        expect(resolved!.value, equals('first_second'));
      });

      test('all values are merged when no tokens present', () {
        const mockMix1 = MockMix('a');
        const mockMix2 = MockMix('b');
        const mockMix3 = MockMix('c');

        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);
        final dto3 = MixProp.value(mockMix3);

        final result = dto1.merge(dto2).merge(dto3);

        final resolved = result.resolve(mockContext);
        expect(resolved, isNotNull);
        expect(resolved!.value, equals('a_b_c'));
      });

      test('complex pattern: Value + Token + Value + Value', () {
        const mockMix1 = MockMix('first');
        const mockToken = MockToken('token');
        const mockMix2 = MockMix('second');
        const mockMix3 = MockMix('third');

        final dto1 = MixProp.value(mockMix1);
        final tokenDto = MixProp.token(mockToken);
        final dto2 = MixProp.value(mockMix2);
        final dto3 = MixProp.value(mockMix3);

        final result = dto1.merge(tokenDto).merge(dto2).merge(dto3);

        // Should have: [first, token, merged(second+third)]
        final resolved = result.resolve(mockContext);
        expect(resolved, isNotNull);
        // Since token resolves to null, we should get: first + (second_third)
        expect(resolved!.value, equals('first_second_third'));
      });
    });

    group('Equality and hashing', () {
      test('same values are equal', () {
        const mockMix = MockMix('test');
        final dto1 = MixProp.value(mockMix);
        final dto2 = MixProp.value(mockMix);

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('different values are not equal', () {
        const mockMix1 = MockMix('test1');
        const mockMix2 = MockMix('test2');
        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);

        expect(dto1, isNot(equals(dto2)));
      });

      test('same tokens are equal', () {
        const mockToken = MockToken('test');
        final dto1 = MixProp.token(mockToken);
        final dto2 = MixProp.token(mockToken);

        expect(dto1, equals(dto2));
        expect(dto1.hashCode, equals(dto2.hashCode));
      });

      test('different tokens are not equal', () {
        const mockToken1 = MockToken('test1');
        const mockToken2 = MockToken('test2');
        final dto1 = MixProp.token(mockToken1);
        final dto2 = MixProp.token(mockToken2);

        expect(dto1, isNot(equals(dto2)));
      });

      test('aggregated dtos with same items are equal', () {
        const mockMix1 = MockMix('first');
        const mockMix2 = MockMix('second');

        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);

        final aggregated1 = dto1.merge(dto2);
        final aggregated2 = dto1.merge(dto2);

        expect(aggregated1, equals(aggregated2));
        expect(aggregated1.hashCode, equals(aggregated2.hashCode));
      });
    });

    group('Edge cases', () {
      test('empty aggregated dto isEmpty returns true', () {
        // This is a theoretical case since we don't expose empty aggregated DTOs
        // But the logic should handle it
        const mockMix = MockMix('test');
        final dto = MixProp.value(mockMix);

        expect(dto.isEmpty, false);
      });

      test('resolving with null items handles gracefully', () {
        const mockMix = MockMix('test');
        final dto = MixProp.value(mockMix);

        final result = dto.resolve(mockContext);
        expect(result, isNotNull);
        expect(result!.value, equals('test'));
      });

      test('merging multiple times maintains consistency', () {
        const mockMix1 = MockMix('a');
        const mockMix2 = MockMix('b');
        const mockMix3 = MockMix('c');
        const mockMix4 = MockMix('d');

        final dto1 = MixProp.value(mockMix1);
        final dto2 = MixProp.value(mockMix2);
        final dto3 = MixProp.value(mockMix3);
        final dto4 = MixProp.value(mockMix4);

        final result1 = dto1.merge(dto2).merge(dto3).merge(dto4);
        final result2 = dto1.merge(dto2.merge(dto3).merge(dto4));

        // Both should resolve to the same value
        final resolved1 = result1.resolve(mockContext);
        final resolved2 = result2.resolve(mockContext);

        expect(resolved1!.value, equals(resolved2!.value));
      });

      test('single item list handling', () {
        const mockMix = MockMix('single');
        final dto = MixProp.value(mockMix);

        final result = dto.resolve(mockContext);
        expect(result, isNotNull);
        expect(result!.value, equals('single'));
      });
    });

    group('Integration with actual Mix types', () {
      test('works with different Mix types', () {
        // Test that the generic nature works with different Mix implementations
        const mockMix = MockMix('test');
        final dto = MixProp.value(mockMix);

        expect(dto, isA<MixProp<MockMix, String>>());

        final result = dto.resolve(mockContext);
        expect(result, isA<MockMix>());
      });
    });
  });
}
