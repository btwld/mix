import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/src/parser/candidate_parser.dart';
import 'package:mix_tailwinds/src/parser/data/parser_registry.g.dart';
import 'package:mix_tailwinds/src/parser/diagnostics.dart';
import 'package:mix_tailwinds/src/parser/model.dart';

void main() {
  final parser = TailwindCandidateParser(
    registry: defaultTailwindParserRegistry,
  );

  test('generated parser registry uses committed deterministic metadata', () {
    expect(generatedTailwindRegistryMeta, isNot(contains('generatedAt')));
    final generated = File(
      'lib/src/parser/data/parser_registry.g.dart',
    ).readAsStringSync();

    expect(generated, contains('tool/tailwind_parser_registry_snapshot.json'));
    expect(generated, isNot(contains('Generated at ')));
  });

  test(
    'parses all probe fixtures into the expected utility root when valid',
    () {
      final fixture =
          jsonDecode(
                File('test/fixtures/candidate-probes.json').readAsStringSync(),
              )
              as Map<String, Object?>;
      final probes = (fixture['probes'] as List).cast<Map<String, Object?>>();

      const syntaxFailures = {
        'bg-red-500/50/50': TailwindParseErrorCode.invalidModifier,
        'p-[]': TailwindParseErrorCode.emptyArbitraryValue,
        '[broken]': TailwindParseErrorCode.invalidArbitraryProperty,
      };
      const semanticInvalids = {'-px', 'not-a-tailwind-class'};

      for (final probe in probes) {
        final input = probe['input']! as String;
        final result = parser.parseCandidate(input);

        if (probe['valid'] != true) {
          final expectedCode = syntaxFailures[input];
          if (expectedCode != null) {
            expect(result, isA<TailwindParseFailure>(), reason: input);
            expect(
              (result as TailwindParseFailure).errors.single.code,
              expectedCode,
              reason: input,
            );
          } else {
            expect(semanticInvalids, contains(input), reason: input);
            expect(result, isA<TailwindParseSuccess>(), reason: input);
          }
          continue;
        }

        expect(result, isA<TailwindParseSuccess>(), reason: input);
        final candidate = (result as TailwindParseSuccess).candidate;
        expect(candidate.raw, input);
        expect(
          candidate.important,
          input.endsWith('!') || input.startsWith('!') || input.contains(':!'),
        );
        expect(_root(candidate.utility), probe['utilityRoot'], reason: input);
      }
    },
  );

  test('candidate probe fixture is in sync with candidate list fixture', () {
    final fixture =
        jsonDecode(
              File('test/fixtures/candidate-probes.json').readAsStringSync(),
            )
            as Map<String, Object?>;
    final probeInputs = (fixture['probes'] as List)
        .cast<Map<String, Object?>>()
        .map((probe) => probe['input'] as String)
        .toSet();
    final candidateInputs = File(
      'test/fixtures/candidates.txt',
    ).readAsLinesSync().where((line) => line.trim().isNotEmpty).toSet();

    expect(probeInputs, containsAll(candidateInputs));
  });

  test('parses contract examples', () {
    final cases = <String, Type>{
      'flex': TailwindStaticUtility,
      'border': TailwindFunctionalUtility,
      'p-4': TailwindFunctionalUtility,
      'w-1/2': TailwindFunctionalUtility,
      'bg-[#0088cc]': TailwindFunctionalUtility,
      'bg-[color:var(--brand)]': TailwindFunctionalUtility,
      'bg-(--brand-color)': TailwindFunctionalUtility,
      '[color:red]': TailwindArbitraryProperty,
      'hover:bg-brand-500/50': TailwindFunctionalUtility,
      'group-hover:flex': TailwindStaticUtility,
      'peer-focus:text-blue-500': TailwindFunctionalUtility,
      'not-hover:opacity-50': TailwindFunctionalUtility,
      '[&_p]:mt-4': TailwindFunctionalUtility,
    };

    for (final entry in cases.entries) {
      final result = parser.parseCandidate(entry.key);
      expect(result, isA<TailwindParseSuccess>(), reason: entry.key);
      final utility = (result as TailwindParseSuccess).candidate.utility;
      expect(utility.runtimeType, entry.value, reason: entry.key);
    }
  });

  test('parses values, modifiers, negatives, and important markers', () {
    final result = parser.parseCandidate('md:hover:!-mx-4');
    expect(result, isA<TailwindParseSuccess>());
    final candidate = (result as TailwindParseSuccess).candidate;
    expect(candidate.important, isTrue);
    expect(candidate.variants, hasLength(2));
    final utility = candidate.utility as TailwindFunctionalUtility;
    expect(utility.root, 'mx');
    expect(utility.negative, isTrue);
    expect((utility.value as TailwindNamedValue).raw, '4');

    final color =
        (parser.parseCandidate('bg-red-500/[50%]') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    expect(color.root, 'bg');
    expect((color.value as TailwindNamedValue).raw, 'red-500');
    expect(color.modifier, isA<TailwindArbitraryModifier>());
  });

  test('keeps root-aware fractions separate from opacity modifiers', () {
    final width =
        (parser.parseCandidate('w-1/2') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    expect(width.root, 'w');
    expect((width.value as TailwindNamedValue).raw, '1/2');
    expect(width.modifier, isNull);

    final color =
        (parser.parseCandidate('bg-red-500/50') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    expect(color.root, 'bg');
    expect((color.value as TailwindNamedValue).raw, 'red-500');
    expect(color.modifier, isA<TailwindNamedModifier>());
    expect((color.modifier as TailwindNamedModifier).raw, '50');
  });

  test('parses explicit parser fidelity cases', () {
    final bgArbitraryModifier =
        (parser.parseCandidate('bg-red-500/[50%]') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    expect(bgArbitraryModifier.root, 'bg');
    expect((bgArbitraryModifier.value as TailwindNamedValue).raw, 'red-500');
    expect(bgArbitraryModifier.modifier, isA<TailwindArbitraryModifier>());

    final bgVariableModifier =
        (parser.parseCandidate('bg-red-500/(--v)') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    expect(bgVariableModifier.root, 'bg');
    expect((bgVariableModifier.value as TailwindNamedValue).raw, 'red-500');
    expect(bgVariableModifier.modifier, isA<TailwindCssVariableModifier>());

    final textLength =
        (parser.parseCandidate('text-[length:12px]') as TailwindParseSuccess)
                .candidate
                .utility
            as TailwindFunctionalUtility;
    final textValue = textLength.value as TailwindArbitraryValue;
    expect(textLength.root, 'text');
    expect(textValue.raw, '[length:12px]');
    expect(textValue.typeHint, 'length');
    expect(textValue.value, '12px');
  });

  test('parses @max as longest functional variant root', () {
    final candidate =
        (parser.parseCandidate('@max-md:hidden') as TailwindParseSuccess)
            .candidate;
    final variant = candidate.variants.single as TailwindFunctionalVariant;
    expect(variant.root, '@max');
    expect((variant.value as TailwindNamedValue).raw, 'md');
  });

  test('allows important characters inside arbitrary values', () {
    final candidate =
        (parser.parseCandidate('bg-[color:var(--bang!)]')
                as TailwindParseSuccess)
            .candidate;
    final utility = candidate.utility as TailwindFunctionalUtility;
    final value = utility.value as TailwindArbitraryValue;

    expect(candidate.important, isFalse);
    expect(value.typeHint, 'color');
    expect(value.value, 'var(--bang!)');
  });

  test('parses suffix important markers outside arbitrary values', () {
    for (final token in ['mx-4!', 'hover:bg-red-500!', '[color:red]/50!']) {
      final candidate =
          (parser.parseCandidate(token) as TailwindParseSuccess).candidate;
      expect(candidate.important, isTrue, reason: token);
      expect(candidate.utility.raw, isNot(contains('!')), reason: token);
    }
  });

  test('malformed arbitrary values and modifiers fail with diagnostics', () {
    final cases = {
      'bg-red-500/50/50': TailwindParseErrorCode.invalidModifier,
      'p-[]': TailwindParseErrorCode.emptyArbitraryValue,
      'bg-[]': TailwindParseErrorCode.emptyArbitraryValue,
    };

    for (final entry in cases.entries) {
      final result = parser.parseCandidate(entry.key);
      expect(result, isA<TailwindParseFailure>(), reason: entry.key);
      expect(
        (result as TailwindParseFailure).errors.single.code,
        entry.value,
        reason: entry.key,
      );
    }
  });

  test('invalid important marker span is relative to full candidate', () {
    final result = parser.parseCandidate('hover:bg!red');
    expect(result, isA<TailwindParseFailure>());
    final error = (result as TailwindParseFailure).errors.single;

    expect(error.code, TailwindParseErrorCode.invalidImportantPosition);
    expect(error.span, const SourceSpan(8, 9));
  });

  test('semantic invalid utilities parse as unresolved syntax successes', () {
    final result = parser.parseCandidate('not-a-tailwind-class');
    expect(result, isA<TailwindParseSuccess>());
    final utility = (result as TailwindParseSuccess).candidate.utility;
    expect(utility, isA<TailwindUnresolvedUtility>());
  });

  test('malformed delimiter input fails with diagnostics', () {
    final result = parser.parseCandidate('bg-[color:red');
    expect(result, isA<TailwindParseFailure>());
    expect(
      (result as TailwindParseFailure).errors.single.code,
      TailwindParseErrorCode.unclosedBracket,
    );
  });
}

String? _root(TailwindUtility utility) {
  return switch (utility) {
    TailwindStaticUtility(:final root) => root,
    TailwindFunctionalUtility(:final root) => root,
    TailwindArbitraryProperty(:final property) => property,
    TailwindUnresolvedUtility() => null,
  };
}
