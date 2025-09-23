import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BreakpointToken Integration Tests', () {
    testWidgets(
      'BreakpointToken integration with onMobile when no MixScope is provided',
      (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              final mobile = BreakpointToken.mobile();
              expect(
                mobile.resolveProp(context),
                equals(Breakpoint.maxWidth(767)),
              );

              final tablet = BreakpointToken.tablet();
              expect(
                tablet.resolveProp(context),
                equals(Breakpoint.widthRange(768, 1023)),
              );

              final desktop = BreakpointToken.desktop();
              expect(
                desktop.resolveProp(context),
                equals(Breakpoint.minWidth(1024)),
              );

              return Box();
            },
          ),
        );
      },
    );

    testWidgets(
      'BreakpointToken integration with onMobile when MixScope is provided',
      (tester) async {
        final mobileBreakpoint = Breakpoint.maxWidth(10);
        final tabletBreakpoint = Breakpoint.widthRange(10, 14);
        final desktopBreakpoint = Breakpoint.minWidth(15);

        await tester.pumpWidget(
          MixScope(
            breakpoints: {
              BreakpointToken.mobile: mobileBreakpoint,
              BreakpointToken.tablet: tabletBreakpoint,
              BreakpointToken.desktop: desktopBreakpoint,
            },
            child: Builder(
              builder: (context) {
                final mobile = BreakpointToken.mobile();
                expect(mobile.resolveProp(context), equals(mobileBreakpoint));

                final tablet = BreakpointToken.tablet();
                expect(tablet.resolveProp(context), equals(tabletBreakpoint));

                final desktop = BreakpointToken.desktop();
                expect(desktop.resolveProp(context), equals(desktopBreakpoint));

                return Box();
              },
            ),
          ),
        );
      },
    );

    testWidgets('BreakpointToken integration with onBreakpoint', (
      tester,
    ) async {
      const mobileToken = BreakpointToken('breakpoint.mobile');
      const customToken = BreakpointToken('breakpoint.custom');

      await tester.pumpWidget(
        MixScope(
          breakpoints: {
            mobileToken: Breakpoint.maxWidth(767),
            customToken: Breakpoint(minWidth: 1440, maxHeight: 900),
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
