import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Golden tests for opacity-* utilities.
///
/// Visual behavior: `opacity-50` box shows background bleed-through
/// vs `opacity-100`.

const _goldenKey = ValueKey('opacity-golden');

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

  testWidgets('opacity utilities affect alpha', (tester) async {
    await _pumpAtWidth(tester, width, height, const _OpacitySample());

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/opacity-utilities-360.png'),
    );
  });
}

class _OpacitySample extends StatelessWidget {
  const _OpacitySample();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex flex-col gap-4',
      children: [
        const P(
          text: 'Opacity utilities',
          classNames: 'text-sm font-semibold text-gray-700',
        ),
        Div(
          classNames: 'flex gap-4',
          children: [
            // Full opacity - should be solid blue
            Div(
              classNames: 'w-24 h-12 bg-blue-500 opacity-100 rounded',
            ),
            // Half opacity - should show background through
            Div(
              classNames: 'w-24 h-12 bg-blue-500 opacity-50 rounded',
            ),
          ],
        ),
      ],
    );
  }
}
