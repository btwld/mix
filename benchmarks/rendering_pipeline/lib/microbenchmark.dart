// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scenarios/card_grid.dart';
import 'src/benchmark_case_host.dart';
import 'src/benchmark_frame_clock.dart';
import 'src/benchmark_frame_guard.dart';
import 'src/benchmark_metadata.dart';
import 'src/benchmark_run_options.dart';
import 'src/statistics.dart';

const int _warmupIterations = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);

enum _MicroScenario { s0, s1, s2, s0Idiomatic, s1Idiomatic }

extension on _MicroScenario {
  String get label => switch (this) {
    _MicroScenario.s0 => 'S0',
    _MicroScenario.s1 => 'S1',
    _MicroScenario.s2 => 'S2',
    _MicroScenario.s0Idiomatic => 'S0I',
    _MicroScenario.s1Idiomatic => 'S1I',
  };

  String get action => switch (this) {
    _MicroScenario.s0 || _MicroScenario.s0Idiomatic => 'static_grid_rebuild',
    _MicroScenario.s1 ||
    _MicroScenario.s1Idiomatic => 'negative_control_hover_toggle',
    _MicroScenario.s2 => 'target_pressed_selected_toggle',
  };

  BenchmarkTrack get track => switch (this) {
    _MicroScenario.s0 ||
    _MicroScenario.s1 ||
    _MicroScenario.s2 => BenchmarkTrack.isolation,
    _MicroScenario.s0Idiomatic ||
    _MicroScenario.s1Idiomatic => BenchmarkTrack.idiomatic,
  };
}

Future<void> main(List<String> arguments) => executeMicrobenchmark(arguments);

Future<void> executeMicrobenchmark([List<String> arguments = const []]) async {
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
  final runOptions = BenchmarkRunOptions.parse(arguments);
  final implementations = benchmarkImplementationOrder(orderLabel)
      .where(
        (implementation) =>
            runOptions.implementation == null ||
            implementation.label == runOptions.implementation,
      )
      .toList(growable: false);
  final scenarios = _MicroScenario.values
      .where(
        (scenario) =>
            runOptions.scenario == null ||
            scenario.label == runOptions.scenario,
      )
      .toList(growable: false);
  final results = <Map<String, Object?>>[];
  final frameClock = BenchmarkFrameClock();

  await benchmarkWidgets((WidgetTester tester) async {
    final hostKey = GlobalKey<BenchmarkCaseHostState>();
    await tester.pumpWidget(BenchmarkCaseHost(key: hostKey));
    await tester.pumpAndSettle();

    final host = hostKey.currentState;
    if (host == null || !host.mounted) {
      throw StateError('The persistent benchmark host was not mounted.');
    }

    final frameGuard = BenchmarkFrameGuard.enter(binding);
    try {
      for (final implementation in implementations) {
        for (final scenario in scenarios) {
          print(
            'MICROBENCHMARK_PROGRESS:'
            '${implementation.label}:${scenario.label}:start',
          );
          results.add(
            await _measureCase(
              tester: tester,
              host: host,
              implementation: implementation,
              scenario: scenario,
              frameClock: frameClock,
            ),
          );
          print(
            'MICROBENCHMARK_PROGRESS:'
            '${implementation.label}:${scenario.label}:done',
          );
        }
      }
    } finally {
      frameGuard.dispose();
    }
  });
  final expectedResultCount = implementations.length * scenarios.length;
  if (results.length != expectedResultCount) {
    throw StateError(
      'Expected $expectedResultCount benchmark results, got ${results.length}.',
    );
  }

  final view = binding.platformDispatcher.views.firstOrNull;
  final metadata =
      createBenchmarkMetadata(
          kind: 'release_cpu_microbenchmark',
          runOrder: orderLabel,
          view: view,
        )
        ..['case_selection'] = <String, Object>{
          'implementation': runOptions.implementation ?? 'all',
          'scenario': runOptions.scenario ?? 'all',
        };
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': metadata,
    'results': results,
  };

  final configuredOutputPath =
      runOptions.outputPath ??
      const String.fromEnvironment('BENCHMARK_OUTPUT_PATH');
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
  required BenchmarkCaseHostState host,
  required BenchmarkImplementation implementation,
  required _MicroScenario scenario,
  required BenchmarkFrameClock frameClock,
}) async {
  final cards = createBenchmarkCards();
  final controllers = BenchmarkControllerSet(cards);
  final gridKey = GlobalKey<BenchmarkGridState>();
  var toggled = false;

  host.showCase(
    BenchmarkApp(
      implementation: implementation,
      track: scenario.track,
      cards: cards,
      controllers: controllers,
      gridKey: gridKey,
    ),
  );
  await tester.pumpBenchmark(frameClock.next());
  if (gridKey.currentState == null) {
    throw StateError('The benchmark grid was not mounted.');
  }
  print(
    'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:rendered',
  );
  print(
    'MICROBENCHMARK_PROGRESS:${implementation.label}:${scenario.label}:manual-frames',
  );

  Future<void> runIteration() async {
    toggled = !toggled;
    switch (scenario) {
      case _MicroScenario.s0:
      case _MicroScenario.s0Idiomatic:
        gridKey.currentState!.rebuildScreen();
        break;
      case _MicroScenario.s1:
      case _MicroScenario.s1Idiomatic:
        controllers.setState(stateFreeCardId, WidgetState.hovered, toggled);
        controllers.setState(pressedOnlyCardId, WidgetState.hovered, toggled);
        break;
      case _MicroScenario.s2:
        controllers.setState(targetCardId, WidgetState.pressed, toggled);
        controllers.setState(targetCardId, WidgetState.selected, toggled);
        break;
    }
    await tester.pumpBenchmark(frameClock.next());
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

  host.clearCase();
  await tester.pumpBenchmark(frameClock.next());
  controllers.dispose();

  final statistics = DistributionStatistics.fromSamples(samples);

  return <String, Object?>{
    'scenario': scenario.label,
    'action': scenario.action,
    'track': scenario.track.label,
    'implementation': implementation.label,
    'warmup_iterations': _warmupIterations,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': statistics.toJson(unitSuffix: 'us'),
    'samples_us': samples,
  };
}
