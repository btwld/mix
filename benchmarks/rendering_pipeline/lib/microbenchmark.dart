// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scenarios/card_grid.dart';
import 'src/benchmark_metadata.dart';
import 'src/statistics.dart';

const int _warmupIterations = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);
const Duration _frameInterval = Duration(microseconds: 16667);

enum _MicroScenario { s0, s1, s2 }

extension on _MicroScenario {
  String get label => name.toUpperCase();

  String get action => switch (this) {
    _MicroScenario.s0 => 'static_grid_rebuild',
    _MicroScenario.s1 => 'negative_control_hover_toggle',
    _MicroScenario.s2 => 'target_pressed_selected_toggle',
  };
}

Future<void> main() => executeMicrobenchmark();

Future<void> executeMicrobenchmark() async {
  if (!kReleaseMode) {
    throw StateError(
      'CPU timings are valid only in release mode. '
      'Run: fvm flutter run --release -d <device> -t lib/microbenchmark.dart',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError('The microbenchmark requires a live Flutter device.');
  }

  final orderLabel = const String.fromEnvironment(
    'BENCHMARK_ORDER',
    defaultValue: 'flutter-first',
  );
  final results = <Map<String, Object?>>[];

  await benchmarkWidgets((WidgetTester tester) async {
    for (final implementation in benchmarkImplementationOrder(orderLabel)) {
      for (final scenario in _MicroScenario.values) {
        print(
          'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:start',
        );
        results.add(
          await _measureCase(
            tester: tester,
            binding: binding,
            implementation: implementation,
            scenario: scenario,
          ),
        );
        print(
          'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:done',
        );
      }
    }
  });
  final expectedResultCount =
      BenchmarkImplementation.values.length * _MicroScenario.values.length;
  if (results.length != expectedResultCount) {
    throw StateError(
      'Expected $expectedResultCount benchmark results, got ${results.length}.',
    );
  }

  final view = binding.platformDispatcher.views.firstOrNull;
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': createBenchmarkMetadata(
      kind: 'release_cpu_microbenchmark',
      runOrder: orderLabel,
      view: view,
    ),
    'results': results,
  };

  final configuredOutputPath = const String.fromEnvironment(
    'BENCHMARK_OUTPUT_PATH',
  );
  final outputFile = configuredOutputPath.isEmpty
      ? File('${Directory.systemTemp.path}/rendering_pipeline_micro.json')
      : File(configuredOutputPath).absolute;
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(output));
  print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  exit(0);
}

Future<Map<String, Object?>> _measureCase({
  required WidgetTester tester,
  required LiveTestWidgetsFlutterBinding binding,
  required BenchmarkImplementation implementation,
  required _MicroScenario scenario,
}) async {
  final cards = createBenchmarkCards();
  final controllers = BenchmarkControllerSet(cards);
  final gridKey = GlobalKey<BenchmarkGridState>();
  final originalFramePolicy = binding.framePolicy;
  var frameTimestamp = Duration.zero;
  var toggled = false;

  await tester.pumpWidget(
    BenchmarkApp(
      implementation: implementation,
      track: BenchmarkTrack.isolation,
      cards: cards,
      controllers: controllers,
      gridKey: gridKey,
    ),
  );
  await tester.pump();
  print(
    'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:rendered',
  );
  await _enterBenchmarkFramePolicy(tester, binding);
  print(
    'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:manual-frames',
  );

  Future<void> runIteration() async {
    toggled = !toggled;
    switch (scenario) {
      case _MicroScenario.s0:
        gridKey.currentState!.rebuildScreen();
        break;
      case _MicroScenario.s1:
        controllers.setState(stateFreeCardId, WidgetState.hovered, toggled);
        controllers.setState(pressedOnlyCardId, WidgetState.hovered, toggled);
        break;
      case _MicroScenario.s2:
        controllers.setState(targetCardId, WidgetState.pressed, toggled);
        controllers.setState(targetCardId, WidgetState.selected, toggled);
        break;
    }
    frameTimestamp += _frameInterval;
    await tester.pumpBenchmark(frameTimestamp);
  }

  for (var iteration = 0; iteration < _warmupIterations; iteration++) {
    await runIteration();
  }

  final samples = <int>[];
  final measuredTime = Stopwatch()..start();
  final iterationTime = Stopwatch();
  while (measuredTime.elapsed < const Duration(seconds: _benchmarkSeconds)) {
    iterationTime
      ..reset()
      ..start();
    await runIteration();
    iterationTime.stop();
    samples.add(iterationTime.elapsedMicroseconds);
  }
  measuredTime.stop();

  binding.framePolicy = originalFramePolicy;
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  controllers.dispose();

  final statistics = DistributionStatistics.fromSamples(samples);

  return <String, Object?>{
    'scenario': scenario.label,
    'action': scenario.action,
    'track': BenchmarkTrack.isolation.label,
    'implementation': implementation.label,
    'warmup_iterations': _warmupIterations,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': statistics.toJson(unitSuffix: 'us'),
    'samples_us': samples,
  };
}

Future<void> _enterBenchmarkFramePolicy(
  WidgetTester tester,
  LiveTestWidgetsFlutterBinding binding,
) async {
  binding.addPostFrameCallback((Duration _) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmark;
  });
  await tester.pump();
}
