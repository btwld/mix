import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('TextDataDirectiveUtility', () {
    final textDirective = TextDirectiveUtility(
      (directive) => TextSpecAttribute.only(directive: directive),
    );
    test('merge returns merged object correctly', () {
      final attr1 = textDirective.uppercase();
      final attr2 = textDirective.capitalize();
      final merged = attr1.merge(attr2);
      expect(merged.directive.length, 2);
    });

    test('Equality holds when all properties are the same', () {
      final attr1 = textDirective.capitalize();
      final attr2 = textDirective.capitalize();
      expect(attr1, attr2);
    });
    test('Equality fails when properties are different', () {
      final attr1 = textDirective.capitalize();
      final attr2 = textDirective.lowercase();
      expect(attr1, isNot(attr2));
    });

    group('UppercaseDirective', () {
      test('modify returns correct value', () {
        final attribute = textDirective.uppercase();
        final directive = attribute.directive;
        expect(directive, resolvesTo(isA<TextDirective>()));
      });
    });

    group('CapitalizeDirective', () {
      test('modify returns correct value', () {
        final attribute = $text.capitalize();
        final directive = attribute.directive;
        expect(directive, resolvesTo(isA<TextDirective>()));
      });
    });

    group('LowercaseDirective', () {
      test('modify returns correct value', () {
        final attribute = $text.lowercase();
        final directive = attribute.directive;
        expect(directive, resolvesTo(isA<TextDirective>()));
      });
    });

    group('SentenceCaseDirective', () {
      test('modify returns correct value', () {
        final attribute = $text.sentenceCase();
        final directive = attribute.directive;
        expect(directive, resolvesTo(isA<TextDirective>()));
      });
    });

    group('TitleCaseDirective', () {
      test('modify returns correct value', () {
        final attribute = $text.titleCase();
        final directive = attribute.directive;
        expect(directive, resolvesTo(isA<TextDirective>()));
      });
    });

    group('TextDirective', () {
      test('Equality holds when all properties are the same', () {
        final attr1 = $text.uppercase();
        final attr2 = $text.uppercase();
        expect(attr1, attr2);
      });
      test('Equality fails when properties are different', () {
        final attr1 = $text.uppercase();
        final attr2 = $text.lowercase();
        expect(attr1, isNot(attr2));
      });
    });
  });
}
