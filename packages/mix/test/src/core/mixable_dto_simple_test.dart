import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/factory/mix_context.dart';
import 'package:mix/src/core/mix_element.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/theme/tokens/mix_token.dart';

// Simple test to validate MixableDto works correctly
void main() {
  test('MixableDto basic functionality', () {
    // Create a simple Mock Mix for testing
    const mockMix = TestMix('test_value');

    // Test value creation
    const valueDto = MixProp.value(mockMix);
    expect(valueDto.isEmpty, false);

    // Test token creation
    const token = MixableToken<TestMix>('test_token');
    const tokenDto = MixProp.token(token);
    expect(tokenDto.isEmpty, false);

    // Test merging
    const mockMix2 = TestMix('second_value');
    const valueDto2 = MixProp.value(mockMix2);
    final merged = valueDto.merge(valueDto2);
    expect(merged.isEmpty, false);

    print('✅ MixableDto basic functionality test passed!');
  });
}

// Minimal Mock Mix implementation for testing
@immutable
class TestMix extends Mix<String> {
  final String value;

  const TestMix(this.value);

  @override
  String resolve(MixContext context) => value;

  @override
  TestMix merge(TestMix? other) {
    if (other == null) return this;
    return TestMix('${value}_${other.value}');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestMix &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  List<Object?> get props => [value];
}
