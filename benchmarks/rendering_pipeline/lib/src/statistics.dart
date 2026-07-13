import 'dart:math' as math;

final class DistributionStatistics {
  DistributionStatistics._({
    required this.sampleCount,
    required this.average,
    required this.median,
    required this.p90,
    required this.p99,
    required this.worst,
    required this.standardDeviation,
  });

  factory DistributionStatistics.fromSamples(Iterable<num> samples) {
    final sorted = samples.map<double>((num value) => value.toDouble()).toList()
      ..sort();
    if (sorted.isEmpty) {
      throw ArgumentError.value(samples, 'samples', 'Must not be empty');
    }

    final average =
        sorted.reduce((double a, double b) => a + b) / sorted.length;
    final squaredDeviationTotal = sorted.fold<double>(
      0,
      (double total, double value) =>
          total + math.pow(value - average, 2).toDouble(),
    );

    return DistributionStatistics._(
      sampleCount: sorted.length,
      average: average,
      median: _percentile(sorted, 0.50),
      p90: _percentile(sorted, 0.90),
      p99: _percentile(sorted, 0.99),
      worst: sorted.last,
      standardDeviation: math.sqrt(squaredDeviationTotal / sorted.length),
    );
  }

  final int sampleCount;
  final double average;
  final double median;
  final double p90;
  final double p99;
  final double worst;
  final double standardDeviation;

  Map<String, Object> toJson({String unitSuffix = ''}) {
    String key(String name) =>
        unitSuffix.isEmpty ? name : '${name}_$unitSuffix';

    return <String, Object>{
      'sample_count': sampleCount,
      key('average'): average,
      key('median'): median,
      key('p90'): p90,
      key('p99'): p99,
      key('worst'): worst,
      key('standard_deviation'): standardDeviation,
    };
  }
}

double _percentile(List<double> sorted, double percentile) {
  return sorted[((sorted.length - 1) * percentile).round()];
}
