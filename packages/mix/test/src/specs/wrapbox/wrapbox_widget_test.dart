import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/providers/constraint_scope.dart';
import 'package:mix/src/specs/wrap/wrap_spec.dart';
import 'package:mix/src/specs/wrapbox/wrapbox_spec.dart';
import 'package:mix/src/specs/wrapbox/wrapbox_widget.dart';
import 'package:mix/mix.dart';

void main() {
  group('WrapBox (spike)', () {
    testWidgets('applies spacing, runSpacing, and alignment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: WrapBox(
                style: WrapBoxStyler(
                  flow: WrapStyler(
                    spacing: 8,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                  ),
                ),
                children: const [
                  SizedBox(key: Key('c1'), width: 40, height: 20),
                  SizedBox(key: Key('c2'), width: 40, height: 20),
                  SizedBox(key: Key('c3'), width: 40, height: 20),
                ],
              ),
            ),
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 8);
      expect(wrap.runSpacing, 12);
      expect(wrap.alignment, WrapAlignment.center);
      expect(find.byKey(const Key('c1')), findsOneWidget);
      expect(find.byKey(const Key('c2')), findsOneWidget);
      expect(find.byKey(const Key('c3')), findsOneWidget);
    });

    testWidgets('wraps with Box when box style is set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: WrapBox(
              style: WrapBoxStyler(
                box: BoxStyler().color(Colors.red).paddingAll(4),
                flow: WrapStyler(spacing: 4),
              ),
              children: const [SizedBox(width: 10, height: 10)],
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('onConstraints composes with WrapBoxStyler', (tester) async {
      double? spacing;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 300,
              height: 200,
              child: StyleBuilder<WrapBoxSpec>(
                style: WrapBoxStyler(flow: WrapStyler(spacing: 16))
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      WrapBoxStyler(flow: WrapStyler(spacing: 4)),
                    ),
                builder: (context, spec) {
                  spacing = spec.flow?.spec.spacing;
                  return WrapBox(
                    styleSpec: StyleSpec(spec: spec),
                    children: const [SizedBox(width: 20, height: 20)],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(spacing, 4);
      expect(find.byType(ConstraintScope), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 800,
              height: 200,
              child: StyleBuilder<WrapBoxSpec>(
                style: WrapBoxStyler(flow: WrapStyler(spacing: 16))
                    .onConstraints(
                      const Breakpoint(maxWidth: 560),
                      WrapBoxStyler(flow: WrapStyler(spacing: 4)),
                    ),
                builder: (context, spec) {
                  spacing = spec.flow?.spec.spacing;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(spacing, 16);
    });

    test('codegen produced WrapBoxStyler without generator changes', () {
      // Structural evidence: generated class exists and is usable.
      final style = WrapBoxStyler(
        flow: WrapStyler(spacing: 8, runSpacing: 8),
      );
      expect(style.$flow, isNotNull);
      expect(style.hasConstraintVariants, isFalse);

      final withConstraint = style.onConstraints(
        const Breakpoint(maxWidth: 400),
        WrapBoxStyler(flow: WrapStyler(spacing: 2)),
      );
      expect(withConstraint.hasConstraintVariants, isTrue);
    });
  });
}
