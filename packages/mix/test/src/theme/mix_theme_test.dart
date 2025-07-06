import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  const primaryColor = MixableToken<Color>('primary');
  const tokenUtil = MixTokensTest();
  final theme = MixScopeData.static(
    tokens: {
      primaryColor: Colors.blue,
      tokenUtil.space.small: 30.0,
      tokenUtil.radius.small: const Radius.circular(200),
      tokenUtil.radius.large: const Radius.circular(2000),
    },
  );

  group('MixScope', () {
    testWidgets('MixScope.of', (tester) async {
      await tester.pumpWithMixScope(Container(), theme: theme);

      final context = tester.element(find.byType(Container));

      expect(MixScope.of(context), theme);
      expect(MixScope.maybeOf(context), theme);
    });

    testWidgets(
      'when applied to Box via Style, it must reproduce the same values than the theme',
      (tester) async {
        const key = Key('box');

        await tester.pumpWithMixScope(
          Box(
            style: Style(
              $box.color.ref(primaryColor),
              $box.borderRadius.all.ref(tokenUtil.radius.small),
              $box.padding.horizontal.ref(tokenUtil.space.small),
              $text.style.ref($material.textTheme.bodyLarge),
            ),
            key: key,
            child: const StyledText('Hello'),
          ),
          theme: theme,
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(Container),
          ),
        );

        expect(
          container.decoration,
          BoxDecoration(
            color: theme.tokens![primaryColor]!(context),
            borderRadius: BorderRadius.all(
              theme.tokens![tokenUtil.radius.small]!(context) as Radius,
            ),
          ),
        );

        expect(
          container.padding!.horizontal / 2,
          theme.tokens![tokenUtil.space.small]!(context),
        );

        final textWidget = tester.widget<Text>(
          find.descendant(of: find.byKey(key), matching: find.byType(Text)),
        );

        expect(
          textWidget.style,
          theme.tokens![$material.textTheme.bodyLarge]!(context),
        );
      },
    );

    // maybeOf
    testWidgets('MixScope.maybeOf', (tester) async {
      await tester.pumpMaterialApp(Container());

      final context = tester.element(find.byType(Container));

      expect(MixScope.maybeOf(context), null);
      expect(() => MixScope.of(context), throwsAssertionError);
    });
  });
}
