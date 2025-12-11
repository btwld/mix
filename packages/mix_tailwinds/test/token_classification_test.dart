import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

import 'test_helpers.dart';

void main() {
  group('wantsFlex', () {
    test('detects explicit flex token', () {
      final parser = TwParser();
      expect(parser.wantsFlex({'flex'}), isTrue);
    });

    test('detects implicit flex via gap', () {
      final parser = TwParser();
      expect(parser.wantsFlex({'gap-4'}), isTrue);
    });

    test('detects prefixed flex', () {
      final parser = TwParser();
      expect(parser.wantsFlex({'md:hover:flex-row'}), isTrue);
    });

    test('returns false for non-flex tokens', () {
      final parser = TwParser();
      expect(parser.wantsFlex({'bg-blue-500'}), isFalse);
    });
  });

  group('animation token classification', () {
    test('recognizes transition with duration/delay', () {
      final helper = ParserTestHelper();
      final result = helper.parser.parseAnimationFromTokens([
        'transition',
        'duration-200',
        'delay-100',
      ]);
      expect(result, isNotNull);
      helper.expectNoWarnings();
    });

    test('uses config-driven durations', () {
      final custom = TwConfig.standard().copyWith(
        durations: {...TwConfig.standard().durations, '2000': 2000},
      );
      final helper = ParserTestHelper(custom);

      final result =
          helper.parser.parseAnimationFromTokens(['transition', 'duration-2000']);
      expect(result, isNotNull);
      helper.expectNoWarnings();
    });

    test('onUnsupported fires for unknown duration', () {
      final helper = ParserTestHelper();
      helper.parser
          .parseAnimationFromTokens(['transition', 'duration-999']);
      helper.expectWarning('duration-999');
    });
  });

  group('transform token classification', () {
    test('recognizes scale token via parseBox', () {
      final helper = ParserTestHelper();
      helper.parser.parseBox('scale-150');
      helper.expectNoWarnings();
    });

    test('rejects unknown rotation key', () {
      final helper = ParserTestHelper();
      helper.parser.parseBox('rotate-999');
      helper.expectWarning('rotate-999');
    });

    test('uses config-driven scales', () {
      final custom = TwConfig.standard().copyWith(
        scales: {...TwConfig.standard().scales, '200': 2.0},
      );
      final helper = ParserTestHelper(custom);
      helper.parser.parseBox('scale-200');
      helper.expectNoWarnings();
    });
  });

  group('border token classification', () {
    test('accepts border-t-2', () {
      final helper = ParserTestHelper();
      helper.parser.parseBox('border-t-2');
      helper.expectNoWarnings();
    });

    test('rejects unknown border token', () {
      final helper = ParserTestHelper();
      helper.parser.parseBox('border-unknown');
      helper.expectWarning('border-unknown');
    });
  });
}
