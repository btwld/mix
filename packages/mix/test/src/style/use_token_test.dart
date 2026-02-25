import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('useToken', () {
    group('ColorToken', () {
      const colorToken = ColorToken('test.color');
      const tokenColor = Colors.blue;

      late MockBuildContext context;

      setUp(() {
        context = MockBuildContext(tokens: {colorToken: tokenColor});
      });

      test('resolves token color through BoxStyler', () {
        final style = BoxStyler().useToken(
          colorToken,
          (color) => BoxStyler().color(color),
        );

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(tokenColor));
      });

      test('preserves chain ordering - useToken then explicit (explicit wins)',
          () {
        final style = BoxStyler()
            .useToken(colorToken, (color) => BoxStyler().color(color))
            .color(Colors.green);

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.green));
      });

      test('preserves chain ordering - explicit then useToken (token wins)',
          () {
        final style = BoxStyler()
            .color(Colors.red)
            .useToken(colorToken, (color) => BoxStyler().color(color));

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(tokenColor));
      });

      test('works with method tear-off syntax', () {
        final style = BoxStyler().useToken(colorToken, BoxStyler().color);

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(tokenColor));
      });
    });

    group('SpaceToken (double)', () {
      const spaceToken = SpaceToken('test.space');
      const tokenValue = 24.0;

      late MockBuildContext context;

      setUp(() {
        context = MockBuildContext(tokens: {spaceToken: tokenValue});
      });

      test('resolves token spacing through BoxStyler.paddingAll', () {
        final style = BoxStyler().useToken(
          spaceToken,
          (space) => BoxStyler().paddingAll(space),
        );

        final resolved = style.resolve(context);

        expect(resolved.spec.padding, equals(EdgeInsets.all(tokenValue)));
      });

      test('preserves ordering - useToken then explicit (explicit wins)', () {
        final style = BoxStyler()
            .useToken(spaceToken, (space) => BoxStyler().paddingAll(space))
            .paddingAll(8);

        final resolved = style.resolve(context);

        expect(resolved.spec.padding, equals(const EdgeInsets.all(8)));
      });

      test('preserves ordering - explicit then useToken (token wins)', () {
        final style = BoxStyler()
            .paddingAll(8)
            .useToken(spaceToken, (space) => BoxStyler().paddingAll(space));

        final resolved = style.resolve(context);

        expect(resolved.spec.padding, equals(EdgeInsets.all(tokenValue)));
      });
    });

    group('multiple useToken calls', () {
      const colorToken = ColorToken('test.primary');
      const spaceToken = SpaceToken('test.spacing');

      late MockBuildContext context;

      setUp(() {
        context = MockBuildContext(
          tokens: {colorToken: Colors.purple, spaceToken: 16.0},
        );
      });

      test('multiple useToken calls on different fields', () {
        final style = BoxStyler()
            .useToken(colorToken, (color) => BoxStyler().color(color))
            .useToken(spaceToken, (space) => BoxStyler().paddingAll(space));

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.purple));
        expect(resolved.spec.padding, equals(const EdgeInsets.all(16)));
      });

      test('useToken mixed with regular setters preserves all fields', () {
        final style = BoxStyler()
            .useToken(colorToken, (color) => BoxStyler().color(color))
            .alignment(Alignment.center)
            .useToken(spaceToken, (space) => BoxStyler().paddingAll(space))
            .clipBehavior(Clip.hardEdge);

        final resolved = style.resolve(context);
        final decoration = resolved.spec.decoration as BoxDecoration;

        expect(decoration.color, equals(Colors.purple));
        expect(resolved.spec.padding, equals(const EdgeInsets.all(16)));
        expect(resolved.spec.alignment, equals(Alignment.center));
        expect(resolved.spec.clipBehavior, equals(Clip.hardEdge));
      });
    });

    group('returns correct type for chaining', () {
      test('useToken returns BoxStyler for continued chaining', () {
        const token = ColorToken('test.chain');

        final style = BoxStyler()
            .useToken(token, (color) => BoxStyler().color(color))
            .alignment(Alignment.topLeft);

        expect(style, isA<BoxStyler>());
      });
    });
  });
}
