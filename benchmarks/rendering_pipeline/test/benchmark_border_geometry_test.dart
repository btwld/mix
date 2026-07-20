import 'package:flutter_test/flutter_test.dart';
import 'package:rendering_pipeline/src/benchmark_border_geometry.dart';

void main() {
  test('parses supported border geometries', () {
    expect(
      parseBenchmarkBorderGeometry('physical'),
      BenchmarkBorderGeometry.physical,
    );
    expect(
      parseBenchmarkBorderGeometry('directional'),
      BenchmarkBorderGeometry.directional,
    );
  });

  test('rejects an unsupported border geometry', () {
    expect(
      () => parseBenchmarkBorderGeometry('diagonal'),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('physical, directional'),
        ),
      ),
    );
  });
}
