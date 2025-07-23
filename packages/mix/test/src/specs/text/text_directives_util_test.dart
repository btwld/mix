import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('TextDirectiveUtility', () {
    final utility = TextDirectiveUtility<UtilityTestAttribute>(
      (prop) => UtilityTestAttribute(prop),
    );

    test('capitalize creates CapitalizeStringDirective', () {
      final result = utility.capitalize();
      expect(result, isA<UtilityTestAttribute>());

      // Check that it contains a Prop with CapitalizeStringDirective
      expect(result.value, isA<Prop<MixDirective<String>>>());
      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(isA<CapitalizeStringDirective>()));

      // Test the directive functionality
      final directive = prop.value;
      expect(directive.apply('hello world'), 'Hello world');
    });

    test('uppercase creates UppercaseStringDirective', () {
      final result = utility.uppercase();
      expect(result, isA<UtilityTestAttribute>());

      expect(result.value, isA<Prop<MixDirective<String>>>());
      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(isA<UppercaseStringDirective>()));

      // Test the directive functionality
      final directive = prop.value;
      expect(directive.apply('hello world'), 'HELLO WORLD');
    });

    test('lowercase creates LowercaseStringDirective', () {
      final result = utility.lowercase();
      expect(result, isA<UtilityTestAttribute>());

      expect(result.value, isA<Prop<MixDirective<String>>>());
      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(isA<LowercaseStringDirective>()));

      // Test the directive functionality
      final directive = prop.value;
      expect(directive.apply('HELLO WORLD'), 'hello world');
    });

    test('titleCase creates TitleCaseStringDirective', () {
      final result = utility.titleCase();
      expect(result, isA<UtilityTestAttribute>());

      expect(result.value, isA<Prop<MixDirective<String>>>());
      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(isA<TitleCaseStringDirective>()));

      // Test the directive functionality
      final directive = prop.value;
      expect(directive.apply('hello world'), 'Hello World');
    });

    test('sentenceCase creates SentenceCaseStringDirective', () {
      final result = utility.sentenceCase();
      expect(result, isA<UtilityTestAttribute>());

      expect(result.value, isA<Prop<MixDirective<String>>>());
      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(isA<SentenceCaseStringDirective>()));

      // Test the directive functionality
      final directive = prop.value;
      expect(directive.apply('hello. world'), 'Hello. World');
    });

    test('call method with custom directive', () {
      // Create a custom directive for testing
      final customDirective = _TestStringDirective();
      final result = utility.call(customDirective);

      expect(result, isA<UtilityTestAttribute>());
      expect(result.value, isA<Prop<MixDirective<String>>>());

      final prop = result.value as Prop<MixDirective<String>>;
      expect(prop, resolvesTo(same(customDirective)));
    });
  });
}

// Test helper directive
class _TestStringDirective implements MixDirective<String> {
  const _TestStringDirective();

  @override
  String apply(String value) => 'TEST: $value';

  @override
  String get key => 'test_string_directive';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestStringDirective && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
