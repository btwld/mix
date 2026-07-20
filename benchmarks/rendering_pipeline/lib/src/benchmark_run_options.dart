import 'benchmark_border_geometry.dart';

class BenchmarkRunOptions {
  const BenchmarkRunOptions({
    this.implementation,
    this.scenario,
    this.outputPath,
    this.borderGeometry = BenchmarkBorderGeometry.physical,
  });

  static const supportedImplementations = <String>{'flutter', 'mix'};
  static const supportedScenarios = <String>{'S0', 'S1', 'S2', 'S0I', 'S1I'};

  final String? implementation;
  final String? scenario;
  final String? outputPath;
  final BenchmarkBorderGeometry borderGeometry;

  factory BenchmarkRunOptions.parse(List<String> arguments) {
    String? implementation;
    String? scenario;
    String? outputPath;
    var borderGeometry = BenchmarkBorderGeometry.physical;

    for (final argument in arguments) {
      if (argument.startsWith('--implementation=')) {
        implementation = argument.substring('--implementation='.length);
      } else if (argument.startsWith('--scenario=')) {
        scenario = argument.substring('--scenario='.length);
      } else if (argument.startsWith('--output=')) {
        outputPath = argument.substring('--output='.length);
      } else if (argument.startsWith('--border=')) {
        borderGeometry = parseBenchmarkBorderGeometry(
          argument.substring('--border='.length),
        );
      } else if (argument.startsWith('--')) {
        throw FormatException('Unknown benchmark argument: $argument');
      }
    }

    if (implementation != null &&
        !supportedImplementations.contains(implementation)) {
      throw FormatException(
        'Unsupported implementation "$implementation". Expected one of: '
        '${supportedImplementations.join(', ')}.',
      );
    }
    if (scenario != null && !supportedScenarios.contains(scenario)) {
      throw FormatException(
        'Unsupported scenario "$scenario". Expected one of: '
        '${supportedScenarios.join(', ')}.',
      );
    }
    if (outputPath != null && outputPath.isEmpty) {
      throw const FormatException('Benchmark output path cannot be empty.');
    }

    return BenchmarkRunOptions(
      implementation: implementation,
      scenario: scenario,
      outputPath: outputPath,
      borderGeometry: borderGeometry,
    );
  }
}
