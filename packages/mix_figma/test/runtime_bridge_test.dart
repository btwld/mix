import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_figma/src/runtime/mix_figma_bridge.dart';
import 'package:mix_figma/src/runtime/mix_scope_loader.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  const bridge = MixFigmaBridge();

  test('bridge wraps materialization, inspection, and token references', () {
    final themeDocument = {
      'v': 1,
      'type': 'theme',
      'colors': {
        'color.base': '#112233',
        'color.alias': {r'$token': 'color.base'},
      },
    };
    final theme = switch (bridge.materializeTheme(themeDocument)) {
      MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
      MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
    };
    final encoded = switch (bridge.dematerializeTheme(theme)) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };
    expect((encoded['colors']! as Map)['color.alias'], '#112233');

    final inspection = switch (bridge.diffableTheme(themeDocument)) {
      MixProtocolSuccess<MixProtocolThemeInspection>(:final value) => value,
      MixProtocolFailure<MixProtocolThemeInspection>(:final errors) => fail(
        '$errors',
      ),
    };
    expect(
      inspection.tokens
          .singleWhere((token) => token.name == 'color.alias')
          .aliasChain,
      ['color.alias', 'color.base'],
    );

    final style = switch (bridge.materializeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'decoration': {
        'color': {r'$token': 'color.alias'},
      },
    })) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    expect(bridge.tokenRefs(style), {
      const MixProtocolTokenReference('colors', 'color.alias'),
    });
  });

  testWidgets('decoded light and dark themes swap a live MixScope', (
    tester,
  ) async {
    final style = switch (bridge.materializeStyle<BoxStyler>({
      'v': 1,
      'type': 'box',
      'decoration': {
        'color': {r'$token': 'color.surface'},
      },
    })) {
      MixProtocolSuccess<BoxStyler>(:final value) => value,
      MixProtocolFailure<BoxStyler>(:final errors) => fail('$errors'),
    };
    const key = ValueKey('surface');

    Future<void> pump(String color) async {
      final theme = switch (bridge.materializeTheme({
        'v': 1,
        'type': 'theme',
        'colors': {'color.surface': color},
      })) {
        MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
        MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
      };
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: mixScopeFromProtocolTheme(
            theme: theme,
            child: Box(key: key, style: style),
          ),
        ),
      );
    }

    await pump('#101820');
    expect(_boxColor(tester, key), const Color(0xFF101820));
    await pump('#F4F8FF');
    expect(_boxColor(tester, key), const Color(0xFFF4F8FF));
  });
}

Color? _boxColor(WidgetTester tester, Key key) {
  final container = tester.widget<Container>(
    find.descendant(of: find.byKey(key), matching: find.byType(Container)),
  );

  return (container.decoration as BoxDecoration?)?.color;
}
