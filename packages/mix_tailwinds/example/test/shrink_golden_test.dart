import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Golden tests for shrink / shrink-0 flex utilities.
///
/// Visual behavior: In a constrained flex row, the `shrink` item compresses
/// while the `shrink-0` item keeps its full width.

const _goldenKey = ValueKey('shrink-golden');

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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
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
  const height = 220.0;

  testWidgets('shrink vs shrink-0 flex sizing', (tester) async {
    await _pumpAtWidth(tester, width, height, const _ShrinkSample());

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/shrink-utilities-360.png'),
    );
  });
}

class _ShrinkSample extends StatelessWidget {
  const _ShrinkSample();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex flex-col gap-3',
      children: [
        const P(
          text: 'Flex shrink utilities',
          classNames: 'text-sm font-semibold text-gray-700',
        ),
        // Container is 180px wide, children want 128+96=224px total
        // With shrink, blue should compress; with shrink-0, green keeps size
        Div(
          classNames: 'flex w-44 gap-2 rounded bg-gray-100 p-2',
          children: [
            // This one should shrink
            Div(
              classNames: 'shrink w-32 h-10 bg-blue-500 rounded',
            ),
            // This one should NOT shrink
            Div(
              classNames: 'shrink-0 w-24 h-10 bg-emerald-400 rounded',
            ),
          ],
        ),
      ],
    );
  }
}
