import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

void main() {
  for (final scenario in [
    (gap: '', global: false),
    (gap: 'gap-y-4', global: false),
    (gap: '', global: true),
    (gap: 'gap-y-4', global: true),
  ]) {
    testWidgets('keyed flex children retain state when reordered ($scenario)', (
      tester,
    ) async {
      final keys = <String, Key>{
        for (final name in ['first', 'second', 'third'])
          name: scenario.global ? GlobalKey() : ValueKey(name),
      };
      Widget build(List<String> names) => Directionality(
        textDirection: .ltr,
        child: Div(
          classNames: 'flex ${scenario.gap}',
          children: [
            for (final name in names)
              Div(
                key: keys[name],
                classNames: 'w-4 h-4',
                child: StatefulBuilder(
                  builder: (context, setState) => const SizedBox(),
                ),
              ),
          ],
        ),
      );

      State stateOf(String name) => tester.state(
        find.descendant(
          of: find.byKey(keys[name]!),
          matching: find.byType(StatefulBuilder),
        ),
      );

      await tester.pumpWidget(build(['first', 'second']));
      final firstState = stateOf('first');
      final secondState = stateOf('second');

      await tester.pumpWidget(build(['second', 'first']));
      expect(stateOf('first'), same(firstState));
      expect(stateOf('second'), same(secondState));

      await tester.pumpWidget(build(['third', 'first']));
      expect(stateOf('first'), same(firstState));
      expect(secondState.mounted, isFalse);
      expect(tester.takeException(), isNull);
    });
  }
}
