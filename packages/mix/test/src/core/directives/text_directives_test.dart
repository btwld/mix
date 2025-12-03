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
    test('reveals text based on progress', () {
      const text = 'Hello World';

      const directive0 = TypewriterDirective(progress: 0.0);
      const directive50 = TypewriterDirective(progress: 0.5);
      const directive100 = TypewriterDirective(progress: 1.0);

      expect(directive0.apply(text), '');
      expect(directive50.apply(text).length, closeTo(text.length / 2, 1));
      expect(directive100.apply(text), text);
    });

    test('handles empty string', () {
      const directive = TypewriterDirective(progress: 0.5);
      expect(directive.apply(''), '');
    });

    test('clamps invalid progress values', () {
      const text = 'Test';
      const directiveNegative = TypewriterDirective(progress: -0.5);
      const directiveOver = TypewriterDirective(progress: 1.5);

      expect(directiveNegative.apply(text), '');
      expect(directiveOver.apply(text), text);
    });

    test('lerps correctly', () {
      const directive1 = TypewriterDirective(progress: 0.0);
      const directive2 = TypewriterDirective(progress: 1.0);

      final lerped = directive1.lerp(directive2, 0.5);

      expect(lerped, isA<TypewriterDirective>());
      expect(lerped.progress, closeTo(0.5, 0.001));
    });

    test('lerp returns this when other is different type', () {
      const directive1 = TypewriterDirective(progress: 0.5);
      const directive2 = ReverseTypewriterDirective(progress: 0.5);

      final lerped = directive1.lerp(directive2, 0.5);

      expect(identical(lerped, directive1), isTrue);
    });

    test('has correct key', () {
      const directive = TypewriterDirective();
      expect(directive.key, 'typewriter');
    });

    test('equality works correctly', () {
      const directive1 = TypewriterDirective(progress: 0.5);
      const directive2 = TypewriterDirective(progress: 0.5);
      const directive3 = TypewriterDirective(progress: 0.7);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });

    test('hashCode consistent with equality', () {
      const directive1 = TypewriterDirective(progress: 0.5);
      const directive2 = TypewriterDirective(progress: 0.5);

      expect(directive1.hashCode, equals(directive2.hashCode));
    });

    test('handles Unicode characters', () {
      const text = 'Hello 👋 World 🌍';
      const directive = TypewriterDirective(progress: 0.5);

      final result = directive.apply(text);

      // Should handle Unicode without crashing
      expect(result.length, lessThanOrEqualTo(text.length));
    });
  });

  group('ReverseTypewriterDirective', () {
    test('hides text based on progress', () {
      const text = 'Hello World';

      const directive0 = ReverseTypewriterDirective(progress: 0.0);
      const directive50 = ReverseTypewriterDirective(progress: 0.5);
      const directive100 = ReverseTypewriterDirective(progress: 1.0);

      expect(directive0.apply(text), text);
      expect(directive50.apply(text).length, closeTo(text.length / 2, 1));
      expect(directive100.apply(text), '');
    });

    test('handles empty string', () {
      const directive = ReverseTypewriterDirective(progress: 0.5);
      expect(directive.apply(''), '');
    });

    test('clamps invalid progress values', () {
      const text = 'Test';
      const directiveNegative = ReverseTypewriterDirective(progress: -0.5);
      const directiveOver = ReverseTypewriterDirective(progress: 1.5);

      expect(directiveNegative.apply(text), text);
      expect(directiveOver.apply(text), '');
    });

    test('lerps correctly', () {
      const directive1 = ReverseTypewriterDirective(progress: 0.0);
      const directive2 = ReverseTypewriterDirective(progress: 1.0);

      final lerped = directive1.lerp(directive2, 0.5);

      expect(lerped, isA<ReverseTypewriterDirective>());
      expect(lerped.progress, closeTo(0.5, 0.001));
    });

    test('lerp returns this when other is different type', () {
      const directive1 = ReverseTypewriterDirective(progress: 0.5);
      const directive2 = TypewriterDirective(progress: 0.5);

      final lerped = directive1.lerp(directive2, 0.5);

      expect(identical(lerped, directive1), isTrue);
    });

    test('has correct key', () {
      const directive = ReverseTypewriterDirective();
      expect(directive.key, 'reverse_typewriter');
    });

    test('equality works correctly', () {
      const directive1 = ReverseTypewriterDirective(progress: 0.5);
      const directive2 = ReverseTypewriterDirective(progress: 0.5);
      const directive3 = ReverseTypewriterDirective(progress: 0.7);

      expect(directive1, equals(directive2));
      expect(directive1, isNot(equals(directive3)));
    });

    test('hashCode consistent with equality', () {
      const directive1 = ReverseTypewriterDirective(progress: 0.5);
      const directive2 = ReverseTypewriterDirective(progress: 0.5);

      expect(directive1.hashCode, equals(directive2.hashCode));
    });

    test('handles Unicode characters', () {
      const text = 'Hello 👋 World 🌍';
      const directive = ReverseTypewriterDirective(progress: 0.5);

      final result = directive.apply(text);

      // Should handle Unicode without crashing
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
