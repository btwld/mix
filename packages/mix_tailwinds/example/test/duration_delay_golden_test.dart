import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Golden tests for duration-* / delay-* animation timing utilities.
///
/// Visual behavior:
/// - Duration: At 300ms, duration-200 should be nearly finished vs
///   duration-1000 mid-transition.
/// - Delay: At 300ms, delay-500 should not have started while delay-0
///   has progressed.

const _durationGoldenKey = ValueKey('duration-golden');
const _delayGoldenKey = ValueKey('delay-golden');

Future<void> _pumpScene(
  WidgetTester tester,
  double width,
  double height,
  Key goldenKey,
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
          key: goldenKey,
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

  // Pump once so post-frame callbacks can flip state and start animations.
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const width = 360.0;
  const height = 240.0;

  testWidgets('duration utilities control transition speed', (tester) async {
    await _pumpScene(
      tester,
      width,
      height,
      _durationGoldenKey,
      const _DurationSample(),
    );

    // Capture mid-animation to show speed differences.
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byKey(_durationGoldenKey),
      matchesGoldenFile('goldens/duration-utilities-360.png'),
    );
  });

  testWidgets('delay utilities defer transition start', (tester) async {
    await _pumpScene(
      tester,
      width,
      height,
      _delayGoldenKey,
      const _DelaySample(),
    );

    // Capture before the delayed animation begins.
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(
      find.byKey(_delayGoldenKey),
      matchesGoldenFile('goldens/delay-utilities-360.png'),
    );
  });
}

class _AnimatedColorBox extends StatefulWidget {
  const _AnimatedColorBox({required this.label, required this.timingClass});

  final String label;
  final String timingClass;

  @override
  State<_AnimatedColorBox> createState() => _AnimatedColorBoxState();
}

class _AnimatedColorBoxState extends State<_AnimatedColorBox> {
  bool _toggled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _toggled = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorClass = _toggled ? 'bg-red-500' : 'bg-blue-500';

    // Simple color box without text to avoid overflow
    return Div(
      classNames:
          'w-20 h-10 rounded transition-colors ${widget.timingClass} $colorClass',
    );
  }
}

class _DurationSample extends StatelessWidget {
  const _DurationSample();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex flex-col gap-4',
      children: [
        const P(
          text: 'Duration utilities',
          classNames: 'text-sm font-semibold text-gray-700',
        ),
        const Div(
          classNames: 'flex gap-4',
          children: [
            _AnimatedColorBox(
              label: 'duration-1000',
              timingClass: 'duration-1000',
            ),
            _AnimatedColorBox(
              label: 'duration-200',
              timingClass: 'duration-200',
            ),
          ],
        ),
      ],
    );
  }
}

class _DelaySample extends StatelessWidget {
  const _DelaySample();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames: 'flex flex-col gap-4',
      children: [
        const P(
          text: 'Delay utilities',
          classNames: 'text-sm font-semibold text-gray-700',
        ),
        const Div(
          classNames: 'flex gap-4',
          children: [
            _AnimatedColorBox(
              label: 'delay-0',
              timingClass: 'duration-200 delay-0',
            ),
            _AnimatedColorBox(
              label: 'delay-500',
              timingClass: 'duration-200 delay-500',
            ),
          ],
        ),
      ],
    );
  }
}
