import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

void main() {
  testWidgets(
    'responsive widget adaptations preserve MediaQuery-first breakpoints',
    (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(800, 600)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 400,
                child: Div(
                  classNames: 'flex flex-col md:flex-row',
                  children: [
                    Div(classNames: ''),
                    Div(classNames: ''),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final flex = tester.widgetList<Flex>(
        find.byWidgetPredicate((widget) => widget is Flex),
      );

      expect(flex, isNotEmpty);
      expect(flex.first.direction, Axis.horizontal);
    },
  );

  testWidgets('screen sizing preserves viewport-based dimensions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: Size(320, 480)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Div(classNames: 'w-screen h-screen'),
            ),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 320 && widget.height == 480,
      ),
      findsOneWidget,
    );
  });
}
