import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/statistics.dart';

void main() {
  test('summarizes samples with Flutter-compatible rounded percentiles', () {
    final statistics = DistributionStatistics.fromSamples(<double>[
      1,
      2,
      3,
      4,
      100,
    ]);

    expect(statistics.sampleCount, 5);
    expect(statistics.average, 22);
    expect(statistics.median, 3);
    expect(statistics.p90, 100);
    expect(statistics.p99, 100);
    expect(statistics.worst, 100);
    expect(statistics.standardDeviation, closeTo(39.0128, 0.0001));
    expect(statistics.toJson(unitSuffix: 'us'), containsPair('median_us', 3));
  });

  test('rejects empty samples', () {
    expect(
      () => DistributionStatistics.fromSamples(const <double>[]),
      throwsArgumentError,
    );
  });
}
