import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds/mix_winds.dart';

void main() {
  for (final axis in Axis.values) {
    final padding = axis == .horizontal ? 'px' : 'py';
    final border = axis == .horizontal ? 'border-x' : 'border-y';
    final margin = axis == .horizontal ? 'mx' : 'my';
    for (final nested in [false, true]) {
      testWidgets(
        '${axis.name} margin reservation agrees with application, nested=$nested',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1200, 1200));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          for (final (viewport, parentWidth) in [
            (0.0, 900.0),
            (900.0, 900.0),
            (0.0, 600.0),
            (0.0, 900.0),
          ]) {
            final marginExtent = parentWidth >= 768 ? 40.0 : 8.0;
            final inner = Div(
              key: const Key('inner'),
              classNames:
                  '${nested ? 'flex-1 ' : ''}flex ${axis == .vertical ? 'flex-col' : ''}',
              children: [
                Div(
                  classNames: 'flex-1 $margin-2 md:$margin-10',
                  child: const SizedBox(key: Key('first-content')),
                ),
                const Div(
                  classNames: 'flex-1',
                  child: SizedBox(key: Key('second-content')),
                ),
              ],
            );
            await tester.pumpWidget(
              MediaQuery(
                data: MediaQueryData(size: Size(viewport, 1200)),
                child: Directionality(
                  textDirection: .ltr,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: parentWidth,
                      height: 900,
                      child: nested
                          ? Div(
                              classNames:
                                  'flex ${axis == .vertical ? 'flex-col' : ''}',
                              children: [
                                inner,
                                const Div(classNames: 'flex-1'),
                              ],
                            )
                          : inner,
                    ),
                  ),
                ),
              ),
            );
            expect(tester.takeException(), isNull);
            final first = tester.getRect(
              find.byKey(const Key('first-content')),
            );
            final second = tester.getRect(
              find.byKey(const Key('second-content')),
            );
            final parent = tester.getRect(find.byKey(const Key('inner')));
            final extent = axis == .horizontal ? first.width : first.height;
            final parentExtent = axis == .horizontal
                ? parent.width
                : parent.height;
            expect(
              extent,
              closeTo(axis == .horizontal ? second.width : second.height, 0.01),
            );
            expect(
              axis == .horizontal
                  ? first.left - parent.left
                  : first.top - parent.top,
              marginExtent,
            );
            expect(
              extent,
              closeTo((parentExtent - marginExtent * 2) / 2, 0.01),
            );
          }
        },
      );
    }
    for (final classes in [
      '$padding-5 md:$padding-10 lg:$padding-5',
      '$padding-10 md:$padding-10 lg:$padding-5',
      'lg:$padding-5 md:$padding-10 $padding-10',
      'md:rounded $padding-10 md:$padding-10 lg:$padding-5',
      '$padding-10 lg:md:$padding-10 md:lg:$padding-5',
      '$border-4 md:$border-4 lg:$border-2',
      'border-2 md:border-l-4 lg:border-t-4',
      'border-2 md:border-4 lg:border-blue-500',
      'md:rounded $border-4 md:$border-4 lg:$border-2',
    ]) {
      testWidgets('equal ${axis.name} flex content extents for $classes', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1200, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (final viewportWidth in [0.0, 600.0, 800.0, 1200.0, 800.0]) {
          await tester.pumpWidget(
            MediaQuery(
              data: MediaQueryData(size: Size(viewportWidth, 1200)),
              child: Directionality(
                textDirection: .ltr,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: axis == .horizontal ? 900 : 100,
                    height: axis == .vertical ? 900 : 100,
                    child: Div(
                      classNames: axis == .horizontal
                          ? 'flex'
                          : 'flex flex-col',
                      children: [
                        Div(
                          classNames: 'flex-1 $classes',
                          child: const SizedBox(key: Key('first-content')),
                        ),
                        const Div(
                          classNames: 'flex-1',
                          child: SizedBox(key: Key('second-content')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          final first = tester.getSize(find.byKey(const Key('first-content')));
          final second = tester.getSize(
            find.byKey(const Key('second-content')),
          );
          expect(
            axis == .horizontal ? first.width : first.height,
            greaterThan(0),
          );
          expect(
            axis == .horizontal ? first.width : first.height,
            closeTo(axis == .horizontal ? second.width : second.height, 0.01),
            reason: 'viewport width $viewportWidth',
          );
        }
      });
    }
  }
}
