import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

Future<BoxSpec> _resolveBoxStates(
  WidgetTester tester,
  String classNames,
  Set<WidgetState> states,
) async {
  final controller = WidgetStatesController(states);
  addTearDown(controller.dispose);
  late BoxSpec spec;
  await tester.pumpWidget(
    MaterialApp(
      home: StyleBuilder<BoxSpec>(
        style: TwParser().parseBox(classNames),
        controller: controller,
        builder: (_, resolved) {
          spec = resolved;
          return const SizedBox();
        },
      ),
    ),
  );
  await tester.pump();
  return spec;
}

void main() {
  testWidgets('hover:bg-red-600 composes onHovered', (tester) async {
    final base = await _resolveBoxStates(tester, 'hover:bg-red-600', {});
    final hovered = await _resolveBoxStates(tester, 'hover:bg-red-600', {
      WidgetState.hovered,
    });

    expect((base.decoration as BoxDecoration?)?.color, isNull);
    expect(
      (hovered.decoration as BoxDecoration?)?.color,
      const Color(0xFFDC2626),
    );
  });

  testWidgets('dark:text-white composes onDark for text', (tester) async {
    late TextSpec spec;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: StyleBuilder<TextSpec>(
            style: TwParser().parseText('dark:text-white'),
            builder: (_, resolved) {
              spec = resolved;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(spec.style?.color, Colors.white);
  });

  testWidgets('sm:bg-red-600 composes onBreakpoint', (tester) async {
    late BoxSpec spec;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: StyleBuilder<BoxSpec>(
            style: TwParser().parseBox('sm:bg-red-600'),
            builder: (_, resolved) {
              spec = resolved;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect((spec.decoration as BoxDecoration?)?.color, const Color(0xFFDC2626));
  });

  test('group-hover is ignored without crashing', () {
    final seen = <String>[];
    final style = TwParser(
      onUnsupported: seen.add,
    ).parseBox('group-hover:bg-red-600');
    expect(style, isA<BoxStyler>());
    expect(seen, isEmpty);
  });
}
