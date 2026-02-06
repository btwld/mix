import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Golden tests for ring / ring-* / ring-offset-* utilities.
///
/// Visual behavior: A base `ring` halo and a `ring-4 + ring-offset-4` halo
/// with offset color.

const _goldenKey = ValueKey('ring-golden');

Future<void> _pumpAtWidth(
  WidgetTester tester,
  double width,
  double height,
  Widget child,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: RepaintBoundary(
          key: _goldenKey,
          child: SizedBox(
            width: width,
            height: height,
            child: ColoredBox(
              color: const Color(0xFFF3F4F6),
              child: Padding(padding: const EdgeInsets.all(16), child: child),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const width = 360.0;
  const height = 240.0;

  testWidgets('ring utilities draw outlines and offsets', (tester) async {
    await _pumpAtWidth(tester, width, height, const _RingSample());

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/ring-utilities-360.png'),
    );
  });
}

class _RingSample extends StatelessWidget {
  const _RingSample();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex flex-col gap-4',
      children: [
        const P(
          text: 'Ring utilities',
          classNames: 'text-sm font-semibold text-gray-700',
        ),
        Div(
          classNames: 'flex gap-6',
          children: [
            Div(
              classNames: 'flex flex-col items-center gap-2',
              children: [
                Div(
                  classNames:
                      'w-16 h-16 bg-white ring ring-blue-500 rounded-lg',
                ),
                const P(text: 'ring', classNames: 'text-xs text-gray-500'),
              ],
            ),
            Div(
              classNames: 'flex flex-col items-center gap-2',
              children: [
                Div(
                  classNames:
                      'w-16 h-16 bg-white ring-4 ring-blue-500 ring-offset-4 ring-offset-amber-300 rounded-lg',
                ),
                const P(
                  text: 'ring-4 + offset',
                  classNames: 'text-xs text-gray-500',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
