import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/benchmark_frame_clock.dart';

void main() {
  test('timestamps remain monotonic across benchmark cases', () {
    final clock = BenchmarkFrameClock(
      frameInterval: const Duration(milliseconds: 16),
    );

    final firstCase = <Duration>[clock.next(), clock.next()];
    final secondCase = <Duration>[clock.next(), clock.next()];

    expect(firstCase, const <Duration>[
      Duration(milliseconds: 16),
      Duration(milliseconds: 32),
    ]);
    expect(secondCase, const <Duration>[
      Duration(milliseconds: 48),
      Duration(milliseconds: 64),
    ]);
  });
}
