import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BreakpointToken Integration Tests', () {
    testWidgets('BreakpointToken integration with onBreakpoint', (
      tester,
    ) async {
      const mobileToken = BreakpointToken('breakpoint.mobile');
      const customToken = BreakpointToken('breakpoint.custom');

      const customBreakpoint = Breakpoint(minWidth: 1440, maxHeight: 900);

      await tester.pumpWidget(
        MixScope(
          breakpoints: {
            mobileToken: Breakpoint.mobile,
            customToken: customBreakpoint,
          },
          child: Box(
            style: BoxStyler()
                .paddingAll(8)
                .onBreakpoint(mobileToken(), BoxStyler().color(Colors.red))
                .onBreakpoint(customToken(), BoxStyler().color(Colors.blue)),
          ),
        ),
      );
    });

    test('BreakpointToken equality and hashCode work correctly', () {
      const token1 = BreakpointToken('test.breakpoint');
      const token2 = BreakpointToken('test.breakpoint');
      const token3 = BreakpointToken('different.breakpoint');

      expect(token1, equals(token2));
      expect(token1.hashCode, equals(token2.hashCode));
      expect(token1, isNot(equals(token3)));
      expect(token1.hashCode, isNot(equals(token3.hashCode)));
    });

    test('BreakpointRef equality works correctly', () {
      const token1 = BreakpointToken('test.breakpoint');
      const token2 = BreakpointToken('test.breakpoint');
      const token3 = BreakpointToken('different.breakpoint');

      final ref1 = token1();
      final ref2 = token2();
      final ref3 = token3();

      expect(ref1, equals(ref2));
      expect(ref1, isNot(equals(ref3)));
    });
  });
}
