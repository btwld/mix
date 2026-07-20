enum BenchmarkBorderGeometry { physical, directional }

BenchmarkBorderGeometry parseBenchmarkBorderGeometry(String label) {
  return switch (label) {
    'physical' => BenchmarkBorderGeometry.physical,
    'directional' => BenchmarkBorderGeometry.directional,
    _ => throw FormatException(
      'Unsupported border geometry "$label". Expected one of: '
      '${BenchmarkBorderGeometry.values.map((value) => value.name).join(', ')}.',
    ),
  };
}
