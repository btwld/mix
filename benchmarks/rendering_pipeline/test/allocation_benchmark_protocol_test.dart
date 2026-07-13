import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/allocation_benchmark_protocol.dart';

void main() {
  test('builds deterministic forward and reverse case orders', () {
    final forward = allocationBenchmarkCases('forward');
    final reverse = allocationBenchmarkCases('reverse');

    expect(forward, hasLength(8));
    expect(
      forward.map((entry) => '${entry.profile.label}:${entry.stage.label}'),
      <String>[
        'static:control_store',
        'static:variant_merge',
        'static:premerged_spec_resolve',
        'static:full_style_build',
        'all_active:control_store',
        'all_active:variant_merge',
        'all_active:premerged_spec_resolve',
        'all_active:full_style_build',
      ],
    );
    expect(reverse, forward.reversed);
  });

  test('rejects unsupported order labels', () {
    expect(() => allocationBenchmarkCases('random'), throwsArgumentError);
  });
}
