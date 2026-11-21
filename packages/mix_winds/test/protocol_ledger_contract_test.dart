import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/parser/data/compatibility_ledger.g.dart';

import 'protocol_ledger_cases.dart';

void main() {
  final parser = TwParser();

  test('the protocol matrix covers each supported ledger family', () {
    bool supported(TailwindCompatibilityEntry entry) =>
        entry.status == .implemented || entry.status == .adapted;
    expect(
      {for (final entry in ledgerUtilityCases) (entry.kind, entry.root)},
      {
        for (final entry in generatedTailwindUtilityCompatibilityLedger.where(
          supported,
        ))
          (entry.kind, entry.root),
      },
    );
    expect(
      ledgerUtilityCases.map((entry) => (entry.kind, entry.root)).toSet(),
      hasLength(ledgerUtilityCases.length),
    );
    expect(ledgerVariantRoots.toSet(), {
      for (final entry in generatedTailwindVariantCompatibilityLedger.where(
        supported,
      ))
        entry.root,
    });
  });

  for (final entry in ledgerUtilityCases) {
    testWidgets('${entry.kind.name}/${entry.root} preserves its style', (
      tester,
    ) async {
      final compilation = compileLedgerCase(
        parser,
        entry.target,
        entry.classes,
      );
      expect(compilation.diagnostics, isEmpty, reason: entry.classes);
      expect(
        compilation.requiresWidgetRuntime,
        entry.runtime,
        reason: entry.classes,
      );
      final decoded = _roundTrip(compilation.styler, entry.classes);
      await _checkContexts(tester, compilation.styler, decoded);
    });
  }

  for (final variant in ledgerVariantRoots) {
    for (final target in LedgerTarget.values) {
      testWidgets(
        '$variant/${target.name} preserves active and inactive styles',
        (tester) async {
          final classes = ledgerVariantClasses(variant, target);
          final compilation = compileLedgerCase(parser, target, classes);
          if (target == LedgerTarget.icon) {
            expect(
              compilation.diagnostics.map((diagnostic) => diagnostic.code),
              [TwDiagnosticCode.unsupportedForTarget],
              reason: classes,
            );
          } else {
            expect(compilation.diagnostics, isEmpty, reason: classes);
          }
          expect(compilation.requiresWidgetRuntime, isFalse, reason: classes);
          final decoded = _roundTrip(compilation.styler, classes);
          await _checkContexts(tester, compilation.styler, decoded);
        },
      );
    }
  }
}

// Schema acceptance of every encoded document is pinned by
// schema/fixtures/style.json and verified with Ajv against the core schema.
Object _roundTrip(Object style, String label) {
  final encoded = _encode(style);
  final decoded = switch (mixProtocol.decodeStyle<Object>(encoded)) {
    MixProtocolSuccess<Object>(:final value, :final warnings)
        when warnings.isEmpty =>
      value,
    final result => throw TestFailure('$label: $result'),
  };
  expect(_encode(decoded), encoded, reason: label);
  return decoded;
}

JsonMap _encode(Object style) => switch (mixProtocol.encodeStyle(style)) {
  MixProtocolSuccess<JsonMap>(:final value) => value,
  MixProtocolFailure<JsonMap>(:final errors) => throw TestFailure('$errors'),
};

Object _resolve(Object style, BuildContext context) => switch (style) {
  BoxStyler() => style.build(context),
  FlexBoxStyler() => style.build(context),
  TextStyler() => style.build(context),
  IconStyler() => style.build(context),
  _ => throw TestFailure('Unexpected style ${style.runtimeType}'),
};

Future<void> _checkContexts(
  WidgetTester tester,
  Object original,
  Object decoded,
) async {
  for (final width in [480.0, 640.0, 768.0, 1024.0, 1280.0, 1536.0]) {
    for (final active in [false, true]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 900),
              platformBrightness: active ? Brightness.dark : Brightness.light,
            ),
            child: WidgetStateStyleOverride(
              states: {
                if (active) ...[
                  WidgetState.hovered,
                  WidgetState.focused,
                  WidgetState.pressed,
                  WidgetState.disabled,
                ],
              },
              child: Builder(
                builder: (context) {
                  expect(
                    _resolve(decoded, context),
                    _resolve(original, context),
                    reason:
                        '${original.runtimeType}: width=$width, active=$active',
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    }
  }
}
