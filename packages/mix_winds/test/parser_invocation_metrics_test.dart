import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';
import 'package:mix_winds/src/parser/candidate_parser.dart';
import 'package:mix_winds/src/translate/tw_translator.dart';

int _countCandidateParses(void Function() action) {
  var count = 0;
  final previous = TailwindCandidateParser.debugParseObserver;
  TailwindCandidateParser.debugParseObserver = (String _) => count++;
  try {
    action();
  } finally {
    TailwindCandidateParser.debugParseObserver = previous;
  }

  return count;
}

Future<int> _countCandidateParsesAsync(Future<void> Function() action) async {
  var count = 0;
  final previous = TailwindCandidateParser.debugParseObserver;
  TailwindCandidateParser.debugParseObserver = (String _) => count++;
  try {
    await action();
  } finally {
    TailwindCandidateParser.debugParseObserver = previous;
  }

  return count;
}

void main() {
  const representativeClasses =
      'flex md:flex-col gap-4 p-4 w-full transition duration-300';

  test('direct translation parses each candidate once', () {
    final count = _countCandidateParses(
      () => TwParser().parseFlex(representativeClasses),
    );

    expect(count, 7);
  });

  test('compilation reuses parsed candidates for animation extraction', () {
    final count = _countCandidateParses(
      () => TwParser().compileBox(
        'bg-blue-500 transition duration-300 ease-in-out delay-100',
      ),
    );

    expect(count, 5);
  });

  test('internal target inference and multi-output share one program', () {
    final translator = TwTranslator(config: TwConfig.standard());
    final count = _countCandidateParses(() {
      translator.compileForWidget(
        'p-4 uppercase transition duration-300',
        .inline,
      );
    });

    expect(count, 4);
  });

  test('program ordering never reparses malformed candidates', () {
    final diagnostics = <TwDiagnostic>[];
    final count = _countCandidateParses(() {
      TwParser(onDiagnostic: diagnostics.add).compileBox('p-10 p-[] p-2 p-[');
    });

    expect(count, 4);
    expect(diagnostics.map((diagnostic) => diagnostic.token), ['p-[]', 'p-[']);
  });

  testWidgets('compiles the Div tree with bounded one-pass parsing', (
    tester,
  ) async {
    final count = await _countCandidateParsesAsync(() async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: .ltr,
          child: Div(
            classNames: representativeClasses,
            children: [
              Div(classNames: 'flex-1 basis-0 p-2'),
              Div(classNames: 'flex-1 basis-0 p-4'),
            ],
          ),
        ),
      );
    });

    // The parent and each direct child compile exactly once. The parent reuses
    // each child's prepared compilation for flex measurement instead of
    // compiling a second layout-only copy (down from the 312-call baseline).
    expect(count, 13);
  });

  testWidgets('constraint-only layout passes perform no parsing', (
    tester,
  ) async {
    final width = ValueNotifier(400.0);
    addTearDown(width.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Align(
          alignment: .topLeft,
          child: ValueListenableBuilder<double>(
            valueListenable: width,
            builder: (context, value, child) =>
                SizedBox(width: value, child: child),
            child: const Div(
              classNames: representativeClasses,
              children: [
                Div(classNames: 'flex-1 basis-0 p-2'),
                Div(classNames: 'flex-1 basis-0 p-4'),
              ],
            ),
          ),
        ),
      ),
    );

    final count = await _countCandidateParsesAsync(() async {
      width.value = 800;
      await tester.pump();
    });

    expect(count, 0);
  });

  testWidgets('prepared child compilation replays diagnostics exactly once', (
    tester,
  ) async {
    final structured = <TwDiagnostic>[];
    final legacy = <String>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: Div(
          classNames: 'flex',
          children: [
            Div(
              classNames: 'unknown-child-utility',
              onDiagnostic: structured.add,
              onUnsupported: legacy.add,
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(structured.map((diagnostic) => diagnostic.token), [
      'unknown-child-utility',
    ]);
    expect(legacy, ['unknown-child-utility']);
  });

  testWidgets('prepared children recompile when the inherited config changes', (
    tester,
  ) async {
    final config = ValueNotifier(TwConfig.standard());
    addTearDown(config.dispose);
    const childKey = ValueKey('configured-child');
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: ValueListenableBuilder<TwConfig>(
          valueListenable: config,
          builder: (context, value, child) =>
              TwConfigProvider(config: value, child: child!),
          child: const Div(
            classNames: 'flex',
            children: [Div(key: childKey, classNames: 'w-4 h-4')],
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(childKey)), const Size(16, 16));

    final count = await _countCandidateParsesAsync(() async {
      config.value = config.value.copyWith(
        space: {...config.value.space, '4': 32},
      );
      await tester.pump();
    });

    expect(tester.getSize(find.byKey(childKey)), const Size(32, 32));
    expect(count, 3);
    expect(tester.takeException(), isNull);
  });
}
