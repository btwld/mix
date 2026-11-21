import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/parser/candidate_parser.dart';
import 'package:mix_winds/src/parser/data/parser_registry.g.dart';
import 'package:mix_winds/src/parser/diagnostics.dart';
import 'package:mix_winds/src/translate/tw_routing.dart';

void main() {
  const candidateParser = TailwindCandidateParser(
    registry: defaultTailwindParserRegistry,
  );
  final breakpoints = TwConfig.standard().breakpoints;

  test('every ignored and unsupported routing path emits a diagnostic', () {
    const cases = <({String token, TwRouteKind kind, TwDiagnosticCode code})>[
      (
        token: '!bg-blue-500',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.importantModifierIgnored,
      ),
      (
        token: '[color:red]',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.arbitraryPropertyIgnored,
      ),
      (
        token: '[&_p]:mt-4',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.arbitraryVariantIgnored,
      ),
      (
        token: '@md:bg-blue-500',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.containerVariantIgnored,
      ),
      (
        token: 'group-hover:bg-blue-500',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.contextVariantIgnored,
      ),
      (
        token: 'peer-hover:bg-blue-500',
        kind: TwRouteKind.ignored,
        code: TwDiagnosticCode.contextVariantIgnored,
      ),
      (
        token: 'supports-[display:grid]:bg-blue-500',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedVariant,
      ),
      (
        token: 'not-focus:bg-blue-500',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedVariant,
      ),
      (
        token: 'visited:bg-blue-500',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedVariant,
      ),
      (
        token: 'weird:bg-blue-500',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedVariant,
      ),
      (
        token: 'totally-unknown',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedUtility,
      ),
      (
        token: 'min-w-auto',
        kind: TwRouteKind.unsupported,
        code: TwDiagnosticCode.unsupportedUtility,
      ),
    ];

    for (final testCase in cases) {
      final parsed = candidateParser.parseCandidate(testCase.token);
      expect(parsed, isA<TailwindParseSuccess>(), reason: testCase.token);
      final candidate = (parsed as TailwindParseSuccess).candidate;
      final route = routeCandidate(candidate, breakpoints: breakpoints);
      expect(route.kind, testCase.kind, reason: testCase.token);
      expect(route.diagnosticCode, testCase.code, reason: testCase.token);

      final diagnostics = <TwDiagnostic>[];
      TwParser(onDiagnostic: diagnostics.add).parseBox(testCase.token);

      expect(diagnostics, hasLength(1), reason: testCase.token);
      expect(diagnostics.single.token, testCase.token);
      expect(diagnostics.single.code, testCase.code);
      expect(diagnostics.single.reason, isNotEmpty);
    }
  });

  test('parse failures and unsupported values carry actionable fields', () {
    final diagnostics = <TwDiagnostic>[];
    final parser = TwParser(onDiagnostic: diagnostics.add);

    parser
      ..parseBox('bg-[color:red')
      ..parseBox('z-10');

    expect(diagnostics, hasLength(2));
    expect(diagnostics.first.code, TwDiagnosticCode.invalidCandidate);
    expect(diagnostics.first.workaround, isNotEmpty);
    expect(diagnostics.last.code, TwDiagnosticCode.unsupportedUtility);
    expect(diagnostics.last.reason, isNotEmpty);
  });

  test(
    'deprecated string callback remains a token-only compatibility shim',
    () {
      final tokens = <String>[];
      // ignore: deprecated_member_use_from_same_package
      TwParser(onUnsupported: tokens.add).parseBox('[color:red]');

      expect(tokens, ['[color:red]']);
    },
  );
}
