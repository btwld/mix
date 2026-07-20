import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/benchmark_border_geometry.dart';
import 'package:rendering_pipeline/src/benchmark_run_options.dart';

void main() {
  test('defaults to the full benchmark matrix', () {
    final options = BenchmarkRunOptions.parse(const []);

    expect(options.implementation, isNull);
    expect(options.scenario, isNull);
    expect(options.outputPath, isNull);
    expect(options.borderGeometry, BenchmarkBorderGeometry.physical);
  });

  test('parses an isolated benchmark case and output path', () {
    final options = BenchmarkRunOptions.parse(const [
      '--implementation=mix',
      '--scenario=S0I',
      '--output=/tmp/result.json',
    ]);

    expect(options.implementation, 'mix');
    expect(options.scenario, 'S0I');
    expect(options.outputPath, '/tmp/result.json');
  });

  test('parses the directional border selector', () {
    final options = BenchmarkRunOptions.parse(const ['--border=directional']);

    expect(options.borderGeometry, BenchmarkBorderGeometry.directional);
  });

  test('rejects unsupported selectors and unknown long options', () {
    expect(
      () => BenchmarkRunOptions.parse(const ['--implementation=other']),
      throwsFormatException,
    );
    expect(
      () => BenchmarkRunOptions.parse(const ['--scenario=S9']),
      throwsFormatException,
    );
    expect(
      () => BenchmarkRunOptions.parse(const ['--border=diagonal']),
      throwsFormatException,
    );
    expect(
      () => BenchmarkRunOptions.parse(const ['--typo=value']),
      throwsFormatException,
    );
  });

  test('ignores platform arguments that are not long options', () {
    final options = BenchmarkRunOptions.parse(const ['-psn_0_12345']);

    expect(options.implementation, isNull);
    expect(options.scenario, isNull);
  });
}
