import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  testWidgets('decoded theme and style docs resolve through MixScope', (
    tester,
  ) async {
    final style = _decodeBoxStyle(_boxStylePayload());
    final lightTheme = _decodeTheme(_themePayload(color: '#101820', space: 8));
    final darkTheme = _decodeTheme(_themePayload(color: '#F4F8FF', space: 18));
    const boxKey = ValueKey('box');

    await tester.pumpWidget(
      _host(
        MixScope(
          tokens: lightTheme.tokens,
          child: Box(key: boxKey, style: style),
        ),
      ),
    );

    expect(_boxColor(tester, boxKey), const Color(0xFF101820));
    expect(_boxPadding(tester, boxKey), const EdgeInsets.only(top: 8));

    await tester.pumpWidget(
      _host(
        MixScope(
          tokens: darkTheme.tokens,
          child: Box(key: boxKey, style: style),
        ),
      ),
    );

    expect(_boxColor(tester, boxKey), const Color(0xFFF4F8FF));
    expect(_boxPadding(tester, boxKey), const EdgeInsets.only(top: 18));
  });

  testWidgets('MixScope.inherit overrides decoded theme tokens for a subtree', (
    tester,
  ) async {
    final style = _decodeBoxStyle(_boxStylePayload());
    final theme = _decodeTheme(_themePayload(color: '#101820', space: 8));
    final override = _decodeTheme(_themePayload(color: '#FF00AA', space: 24));
    const outerKey = ValueKey('outer');
    const innerKey = ValueKey('inner');

    await tester.pumpWidget(
      _host(
        MixScope(
          tokens: theme.tokens,
          child: Column(
            children: [
              Box(key: outerKey, style: style),
              MixScope.inherit(
                tokens: override.tokens,
                child: Box(key: innerKey, style: style),
              ),
            ],
          ),
        ),
      ),
    );

    expect(_boxColor(tester, outerKey), const Color(0xFF101820));
    expect(_boxPadding(tester, outerKey), const EdgeInsets.only(top: 8));
    expect(_boxColor(tester, innerKey), const Color(0xFFFF00AA));
    expect(_boxPadding(tester, innerKey), const EdgeInsets.only(top: 24));
  });

  testWidgets('unknown decoded token references surface core StateError', (
    tester,
  ) async {
    final style = _decodeBoxStyle(_boxStylePayload());

    await tester.pumpWidget(
      _host(
        MixScope(
          tokens: const {},
          child: Box(style: style),
        ),
      ),
    );

    final error = tester.takeException();

    expect(error, isA<StateError>());
    expect('$error', contains('Token "'));
    expect('$error', contains('not found in scope'));
  });
}

JsonMap _boxStylePayload() {
  return {
    'v': 1,
    'type': 'box',
    'padding': {
      'top': {r'$token': 'space.gap'},
    },
    'decoration': {
      'color': {r'$token': 'color.surface'},
    },
  };
}

JsonMap _themePayload({required String color, required double space}) {
  return {
    'v': 1,
    'type': 'theme',
    'colors': {'color.surface': color},
    'spaces': {'space.gap': space},
  };
}

BoxStyler _decodeBoxStyle(JsonMap payload) {
  final contract = MixSchemaContractBuilder().builtIn().freeze();

  return switch (contract.decode<BoxStyler>(payload)) {
    MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
    MixSchemaDecodeFailure<BoxStyler>(:final errors) => fail('$errors'),
  };
}

MixSchemaThemeDocument _decodeTheme(JsonMap payload) {
  return switch (const MixSchemaThemeCodec().decode(payload)) {
    MixSchemaDecodeSuccess<MixSchemaThemeDocument>(:final value) => value,
    MixSchemaDecodeFailure<MixSchemaThemeDocument>(:final errors) => fail(
      '$errors',
    ),
  };
}

Widget _host(Widget child) {
  return Directionality(textDirection: TextDirection.ltr, child: child);
}

Color? _boxColor(WidgetTester tester, Key key) {
  final decoration = _container(tester, key).decoration;

  return (decoration as BoxDecoration?)?.color;
}

EdgeInsetsGeometry? _boxPadding(WidgetTester tester, Key key) {
  return _container(tester, key).padding;
}

Container _container(WidgetTester tester, Key key) {
  return tester.widget<Container>(
    find.descendant(of: find.byKey(key), matching: find.byType(Container)),
  );
}
