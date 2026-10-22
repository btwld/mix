import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  test('chained modifiers preserve separate wrap calls for both states', () {
    for (final active in [false, true]) {
      expect(
        BoxStyler().wrap(
          .opacity(
            active ? 1 : 0,
          ).scale(active ? 1 : .95, active ? 1 : .95, alignment: .topLeft),
        ),
        BoxStyler()
            .wrap(.opacity(active ? 1 : 0))
            .wrap(
              .scale(
                x: active ? 1 : .95,
                y: active ? 1 : .95,
                alignment: .topLeft,
              ),
            ),
      );
      expect(
        BoxStyler().wrap(
          .align(
            alignment: .topLeft,
            widthFactor: 1,
            heightFactor: active ? 1 : 0,
          ).opacity(active ? 1 : 0),
        ),
        BoxStyler()
            .wrap(
              .align(
                alignment: .topLeft,
                widthFactor: 1,
                heightFactor: active ? 1 : 0,
              ),
            )
            .wrap(.opacity(active ? 1 : 0)),
      );
    }
    expect(
      BoxStyler().wrap(.opacity(0.5).rotate(radians: 0.1)),
      BoxStyler().wrap(.opacity(0.5)).wrap(.rotate(radians: 0.1)),
    );
  });

  for (final customOrder in [false, true]) {
    testWidgets(
      'single wrap preserves rendering with customOrder=$customOrder',
      (tester) async {
        final base = BoxStyler().color(Colors.white).size(200, 100);
        final separate = base
            .wrap(.opacity(0.9))
            .wrap(.padding(.all(16)))
            .wrap(.align(alignment: .center));
        final combined = base.wrap(
          .opacity(0.9).padding(.all(16)).align(alignment: .center),
        );
        expect(combined, separate);
        final styles = [separate, combined];
        if (customOrder) {
          styles[0] = separate.wrap(
            .orderOfModifiers([
              OpacityModifier,
              PaddingModifier,
              AlignModifier,
            ]),
          );
          styles[1] = base.wrap(
            .opacity(
              0.9,
            ).padding(.all(16)).align(alignment: .center).orderOfModifiers([
              OpacityModifier,
              PaddingModifier,
              AlignModifier,
            ]),
          );
          expect(styles[1], styles[0]);
        } else {
          styles.add(
            base.wrap(
              .align(alignment: .center).padding(.all(16)).opacity(0.9),
            ),
          );
        }
        for (final style in styles) {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: Box(style: style),
            ),
          );
          final context = tester.element(find.byType(Box));
          expect(
            style.$modifier!.resolve(context).map((m) => m.runtimeType),
            customOrder
                ? [OpacityModifier, PaddingModifier, AlignModifier]
                : [AlignModifier, PaddingModifier, OpacityModifier],
          );
          final opacity = tester.widget<Opacity>(find.byType(Opacity));
          final padding = tester.widget<Padding>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Padding &&
                  widget.padding == const EdgeInsets.all(16),
            ),
          );
          final align = tester.widget<Align>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Align &&
                  (customOrder
                      ? identical(padding.child, widget)
                      : identical(widget.child, padding)),
            ),
          );
          expect(opacity.opacity, 0.9);
          expect(align.alignment, Alignment.center);
          if (customOrder) {
            expect(opacity.child, same(padding));
            expect(padding.child, same(align));
          } else {
            expect(align.child, same(padding));
            expect(padding.child, same(opacity));
          }
          final container = tester.widget<Container>(find.byType(Container));
          expect(
            container.constraints,
            BoxConstraints.tightFor(width: 200, height: 100),
          );
          expect((container.decoration as BoxDecoration).color, Colors.white);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
        }
      },
    );
  }
}
