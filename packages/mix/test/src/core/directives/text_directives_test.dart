import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('CapitalizeStringDirective', () {
    test('capitalizes first letter', () {
      const directive = CapitalizeStringDirective();

      expect(directive.apply('hello'), 'Hello');
      expect(directive.apply('world'), 'World');
      expect(directive.apply('a'), 'A');
    });

    test('handles empty string', () {
      const directive = CapitalizeStringDirective();
      expect(directive.apply(''), '');
    });

    test('has correct key', () {
      const directive = CapitalizeStringDirective();
      expect(directive.key, 'capitalize');
    });

    test('equality works correctly', () {
      const directive1 = CapitalizeStringDirective();
      const directive2 = CapitalizeStringDirective();

      expect(directive1, equals(directive2));
      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('UppercaseStringDirective', () {
    test('converts to uppercase', () {
      const directive = UppercaseStringDirective();

      expect(directive.apply('hello'), 'HELLO');
      expect(directive.apply('World'), 'WORLD');
      expect(directive.apply('MiXeD'), 'MIXED');
    });

    test('handles empty string', () {
      const directive = UppercaseStringDirective();
      expect(directive.apply(''), '');
    });

    test('has correct key', () {
      const directive = UppercaseStringDirective();
      expect(directive.key, 'uppercase');
    });

    test('equality works correctly', () {
      const directive1 = UppercaseStringDirective();
      const directive2 = UppercaseStringDirective();

      expect(directive1, equals(directive2));
      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('LowercaseStringDirective', () {
    test('converts to lowercase', () {
      const directive = LowercaseStringDirective();

      expect(directive.apply('HELLO'), 'hello');
      expect(directive.apply('World'), 'world');
      expect(directive.apply('MiXeD'), 'mixed');
    });

    test('handles empty string', () {
      const directive = LowercaseStringDirective();
      expect(directive.apply(''), '');
    });

    test('has correct key', () {
      const directive = LowercaseStringDirective();
      expect(directive.key, 'lowercase');
    });

    test('equality works correctly', () {
      const directive1 = LowercaseStringDirective();
      const directive2 = LowercaseStringDirective();

      expect(directive1, equals(directive2));
      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('TitleCaseStringDirective', () {
    test('converts to title case', () {
      const directive = TitleCaseStringDirective();

      expect(directive.apply('hello world'), 'Hello World');
      expect(directive.apply('THE QUICK BROWN FOX'), 'The Quick Brown Fox');
    });

    test('handles empty string', () {
      const directive = TitleCaseStringDirective();
      expect(directive.apply(''), '');
    });

    test('has correct key', () {
      const directive = TitleCaseStringDirective();
      expect(directive.key, 'title_case');
    });

    test('equality works correctly', () {
      const directive1 = TitleCaseStringDirective();
      const directive2 = TitleCaseStringDirective();

      expect(directive1, equals(directive2));
      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('SentenceCaseStringDirective', () {
    test('converts to sentence case', () {
      const directive = SentenceCaseStringDirective();

      expect(directive.apply('hello world'), 'Hello world');
      expect(directive.apply('the quick brown fox'), 'The quick brown fox');
    });

    test('handles empty string', () {
      const directive = SentenceCaseStringDirective();
      expect(directive.apply(''), '');
    });

    test('has correct key', () {
      const directive = SentenceCaseStringDirective();
      expect(directive.key, 'sentence_case');
    });

    test('equality works correctly', () {
      const directive1 = SentenceCaseStringDirective();
      const directive2 = SentenceCaseStringDirective();

      expect(directive1, equals(directive2));
      expect(directive1.hashCode, equals(directive2.hashCode));
    });
  });

  group('TypewriterDirective', () {
    test('applies at full progress by default', () {
      const text = 'Hello World';
      const directive = TypewriterDirective();

      // At progress 1.0 (default), full text is shown
      expect(directive.apply(text, 1.0), text);
    });

    test('reverse parameter works correctly', () {
      const text = 'Hello World';
      const forward = TypewriterDirective();
      const reverse = TypewriterDirective(reverse: true);

      // Forward at 1.0 shows full text
      expect(forward.apply(text, 1.0), text);
      // Reverse at 1.0 shows no text
      expect(reverse.apply(text, 1.0), '');
    });

    test('apply reveals text based on progress', () {
      const text = 'Hello World';
      const directive = TypewriterDirective();

      expect(directive.apply(text, 0.0), '');
      expect(directive.apply(text, 0.5).length, closeTo(text.length / 2, 1));
      expect(directive.apply(text, 1.0), text);
    });

    test('apply with reverse hides text based on progress', () {
      const text = 'Hello World';
      const directive = TypewriterDirective(reverse: true);

      expect(directive.apply(text, 0.0), text);
      expect(directive.apply(text, 0.5).length, closeTo(text.length / 2, 1));
      expect(directive.apply(text, 1.0), '');
    });

    test('handles empty string', () {
      const directive = TypewriterDirective();
      expect(directive.apply('', 1.0), '');
      expect(directive.apply('', 0.5), '');
    });

    test('clamps invalid progress values', () {
      const text = 'Test';
      const directive = TypewriterDirective();

      expect(directive.apply(text, -0.5), '');
      expect(directive.apply(text, 1.5), text);
    });

    test('compatibility accounts for configuration', () {
      const forward = TypewriterDirective();
      const reverse = TypewriterDirective(reverse: true);

      expect(forward.isCompatibleWith(forward), isTrue);
      expect(forward.isCompatibleWith(reverse), isFalse);
    });

    test('has correct key', () {
      const directive = TypewriterDirective();
      expect(directive.key, 'typewriter');
    });

    test('equality works correctly', () {
      const directive1 = TypewriterDirective();
      const directive2 = TypewriterDirective();
      const directive3 = TypewriterDirective(reverse: true);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });

    test('hashCode consistent with equality', () {
      const directive1 = TypewriterDirective();
      const directive2 = TypewriterDirective();

      expect(directive1.hashCode, equals(directive2.hashCode));
    });

    test('handles Unicode characters', () {
      const text = 'Hello 👋 World 🌍';
      const directive = TypewriterDirective();

      final result = directive.apply(text, 0.5);

      expect(result.length, lessThanOrEqualTo(text.length));
    });
  });

  group('String directive chaining', () {
    test('multiple directives can be chained', () {
      const directives = [
        LowercaseStringDirective(),
        CapitalizeStringDirective(),
      ];

      var result = 'HELLO WORLD';
      for (final directive in directives) {
        result = directive.apply(result);
      }

      expect(result, 'Hello world');
    });
  });
}
