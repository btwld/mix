import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/ui/components/button.dart';
import 'package:mix_showcase/ui/theme/theme_scope.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('a generated button owns its GlobalKey across builds', (
    tester,
  ) async {
    final key = GlobalKey();
    final adapter = find.byKey(key);
    final child = find.descendant(
      of: adapter,
      matching: find.byType(RemixButton),
    );

    Future<void> pumpButton(UiButton button) => tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: UiThemeScope(child: button),
      ),
    );

    await pumpButton(UiButton(key: key, label: 'Before'));

    expect(tester.takeException(), isNull);
    expect(tester.widget(adapter), isA<UiButton>());
    final adapterContext = key.currentContext;
    expect(tester.widget(child).key, isNull);
    expect(find.text('Before'), findsOneWidget);

    await pumpButton(UiButton.primary(key: key, label: 'After'));

    expect(tester.takeException(), isNull);
    expect(key.currentContext, same(adapterContext));
    expect(tester.widget(child).key, isNull);
    expect(find.text('After'), findsOneWidget);
  });
}
