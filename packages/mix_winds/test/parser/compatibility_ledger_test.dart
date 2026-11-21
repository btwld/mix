import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/parser/candidate_parser.dart';
import 'package:mix_winds/src/parser/data/compatibility_ledger.g.dart';
import 'package:mix_winds/src/parser/data/parser_registry.g.dart';
import 'package:mix_winds/src/parser/diagnostics.dart';
import 'package:mix_winds/src/translate/tw_routing.dart';

void main() {
  test(
    'focus-visible explanation agrees with the Protocol round-trip contract',
    () {
      // protocol_contract_test.dart exercises the actual selector round trip.
      final entry = generatedTailwindVariantCompatibilityLedger.singleWhere(
        (entry) => entry.root == 'focus-visible',
      );
      expect(entry.status, TailwindCompatibilityStatus.adapted);
      expect(entry.reason, isNot(contains('does not encode')));
      expect(entry.reason, contains('context_focus_visible'));
    },
  );
  final snapshot = _readSnapshot();
  const candidateParser = TailwindCandidateParser(
    registry: defaultTailwindParserRegistry,
  );
  final breakpoints = TwConfig.standard().breakpoints;

  test(
    'ledger classifies every effective utility and variant registration',
    () {
      final expectedUtilities = <String>{
        for (final root in defaultTailwindParserRegistry.staticUtilityRoots)
          _key(TailwindRegistryRootKind.staticUtility, root),
        for (final root in defaultTailwindParserRegistry.functionalUtilityRoots)
          _key(TailwindRegistryRootKind.functionalUtility, root),
      };
      final expectedVariants = <String>{
        for (final root in defaultTailwindParserRegistry.staticVariantRoots)
          _key(TailwindRegistryRootKind.staticVariant, root),
        for (final root in defaultTailwindParserRegistry.functionalVariantRoots)
          _key(TailwindRegistryRootKind.functionalVariant, root),
        for (final root in defaultTailwindParserRegistry.compoundVariantRoots)
          _key(TailwindRegistryRootKind.compoundVariant, root),
      };
      final actualUtilities = {
        for (final entry in generatedTailwindUtilityCompatibilityLedger)
          _key(entry.kind, entry.root),
      };
      final actualVariants = {
        for (final entry in generatedTailwindVariantCompatibilityLedger)
          _key(entry.kind, entry.root),
      };

      expect(generatedTailwindUtilityCompatibilityLedger, hasLength(599));
      expect(generatedTailwindVariantCompatibilityLedger, hasLength(91));
      expect(actualUtilities, hasLength(599), reason: 'duplicate utility key');
      expect(actualVariants, hasLength(91), reason: 'duplicate variant key');
      expect(actualUtilities, expectedUtilities);
      expect(actualVariants, expectedVariants);
      expect(
        generatedTailwindCompatibilityMeta,
        (snapshot['meta']! as Map).cast<String, Object?>(),
      );
    },
  );

  test('ledger statuses carry the required accounting detail', () {
    const allowedLabels = {
      'implemented',
      'adapted',
      'unsupported',
      'ignored-by-design',
    };
    final entries = [
      ...generatedTailwindUtilityCompatibilityLedger,
      ...generatedTailwindVariantCompatibilityLedger,
    ];

    for (final entry in entries) {
      expect(allowedLabels, contains(entry.status.label), reason: entry.root);
      switch (entry.status) {
        case TailwindCompatibilityStatus.implemented:
          expect(entry.reason, isNull, reason: entry.root);
        case TailwindCompatibilityStatus.adapted:
          expect(
            entry.reason,
            contains('FLUTTER_ADAPTATIONS.md'),
            reason: entry.root,
          );
        case TailwindCompatibilityStatus.unsupported:
          expect(entry.reason, isNull, reason: entry.root);
        case TailwindCompatibilityStatus.ignoredByDesign:
          expect(entry.reason, isNotEmpty, reason: entry.root);
          expect(
            entry.reason,
            contains('FLUTTER_ADAPTATIONS.md'),
            reason: entry.root,
          );
      }
    }
  });

  test('adapted variant policy matches the implemented runtime behavior', () {
    final focusVisible = generatedTailwindVariantCompatibilityLedger
        .singleWhere((entry) => entry.root == 'focus-visible');
    final themeMidnight = generatedTailwindVariantCompatibilityLedger
        .singleWhere((entry) => entry.root == 'theme-midnight');

    expect(focusVisible.status, TailwindCompatibilityStatus.adapted);
    expect(focusVisible.reason, contains('focus-visible state'));
    expect(focusVisible.reason, isNot(contains('broader Mix focus state')));
    expect(themeMidnight.status, TailwindCompatibilityStatus.unsupported);
    expect(themeMidnight.reason, isNull);
  });

  testWidgets('auto sizing translation agrees with adapted ledger entries', (
    tester,
  ) async {
    final widthAuto = _entry(
      generatedTailwindUtilityCompatibilityLedger,
      TailwindRegistryRootKind.staticUtility,
      'w-auto',
    );
    final heightAuto = _entry(
      generatedTailwindUtilityCompatibilityLedger,
      TailwindRegistryRootKind.staticUtility,
      'h-auto',
    );
    final diagnostics = <TwDiagnostic>[];
    final style = TwParser(
      onDiagnostic: diagnostics.add,
    ).parseBox('w-auto h-auto');
    late BoxConstraints constraints;

    await tester.pumpWidget(
      Builder(
        builder: (context) {
          constraints = style.resolve(context).spec.constraints!;

          return const SizedBox.shrink();
        },
      ),
    );

    expect(widthAuto.status, TailwindCompatibilityStatus.adapted);
    expect(heightAuto.status, TailwindCompatibilityStatus.adapted);
    expect(
      _route(candidateParser, breakpoints, 'w-auto').kind,
      TwRouteKind.style,
    );
    expect(
      _route(candidateParser, breakpoints, 'h-auto').kind,
      TwRouteKind.style,
    );
    expect(diagnostics, isEmpty);
    expect(constraints.minWidth, 0);
    expect(constraints.maxWidth, double.infinity);
    expect(constraints.minHeight, 0);
    expect(constraints.maxHeight, double.infinity);
  });

  test('variant ledger entries agree with standard runtime routing', () {
    final light = _entry(
      generatedTailwindVariantCompatibilityLedger,
      TailwindRegistryRootKind.staticVariant,
      'light',
    );
    final not = _entry(
      generatedTailwindVariantCompatibilityLedger,
      TailwindRegistryRootKind.compoundVariant,
      'not',
    );
    final threeExtraLarge = _entry(
      generatedTailwindVariantCompatibilityLedger,
      TailwindRegistryRootKind.staticVariant,
      '3xl',
    );

    expect(light.status, TailwindCompatibilityStatus.adapted);
    expect(
      _route(candidateParser, breakpoints, 'light:bg-white').kind,
      TwRouteKind.style,
    );
    expect(not.status, TailwindCompatibilityStatus.adapted);
    expect(not.reason, contains('Only not-hover'));
    expect(
      _route(candidateParser, breakpoints, 'not-hover:opacity-50').kind,
      TwRouteKind.style,
    );
    expect(threeExtraLarge.status, TailwindCompatibilityStatus.unsupported);
    final route = _route(candidateParser, breakpoints, '3xl:bg-white');
    expect(route.kind, TwRouteKind.unsupported);
    expect(route.diagnosticCode, TwDiagnosticCode.unsupportedVariant);
  });

  test('block is no longer advertised as implemented', () {
    final block = _entry(
      generatedTailwindUtilityCompatibilityLedger,
      TailwindRegistryRootKind.staticUtility,
      'block',
    );

    expect(block.status, TailwindCompatibilityStatus.unsupported);
    expect(block.reason, isNull);
  });

  test(
    'block routing emits the unsupported diagnostic promised by the ledger',
    () {
      final route = _route(candidateParser, breakpoints, 'block');

      expect(route.kind, TwRouteKind.unsupported);
      expect(route.diagnosticCode, TwDiagnosticCode.unsupportedUtility);
    },
  );

  test('min-w-auto is not advertised as a Flutter automatic minimum', () {
    final minWidthAuto = generatedTailwindUtilityCompatibilityLedger
        .singleWhere((entry) => entry.root == 'min-w-auto');

    expect(minWidthAuto.status, TailwindCompatibilityStatus.unsupported);
    expect(minWidthAuto.reason, isNull);
  });

  test('checked-in registries match generator output', () {
    final result = Process.runSync(_dartExecutable(), [
      'tool/gen_registry.dart',
      '--check',
    ], workingDirectory: Directory.current.path);

    expect(
      result.exitCode,
      0,
      reason: 'stdout:\n${result.stdout}\nstderr:\n${result.stderr}',
    );
  });
}

Map<String, Object?> _readSnapshot() {
  final decoded = jsonDecode(
    File('tool/tailwind_parser_registry_snapshot.json').readAsStringSync(),
  );
  return (decoded as Map).cast<String, Object?>();
}

String _key(TailwindRegistryRootKind kind, String root) => '${kind.name}:$root';

TailwindCompatibilityEntry _entry(
  List<TailwindCompatibilityEntry> ledger,
  TailwindRegistryRootKind kind,
  String root,
) => ledger.singleWhere((entry) => entry.kind == kind && entry.root == root);

TwRoute _route(
  TailwindCandidateParser parser,
  Map<String, double> breakpoints,
  String token,
) {
  final parsed = parser.parseCandidate(token);
  expect(parsed, isA<TailwindParseSuccess>(), reason: token);

  return routeCandidate(
    (parsed as TailwindParseSuccess).candidate,
    breakpoints: breakpoints,
  );
}

String _dartExecutable() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final bundled = File('$flutterRoot/bin/cache/dart-sdk/bin/dart');
    if (bundled.existsSync()) return bundled.path;
  }

  final resolved = File(Platform.resolvedExecutable);
  if (resolved.uri.pathSegments.last == 'dart') return resolved.path;

  throw StateError('Unable to locate the Dart executable for generator check.');
}
