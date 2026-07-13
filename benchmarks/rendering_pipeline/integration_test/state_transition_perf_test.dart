import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rendering_pipeline/scenarios/card_grid.dart';
import 'package:rendering_pipeline/src/benchmark_metadata.dart';
import 'package:rendering_pipeline/src/statistics.dart';

const int _warmupTransitions = 100;
const int _measuredTransitions = 200;
const Set<String> _supportedScenarios = <String>{'S2', 'S3', 'S4', 'S5'};

enum _PerfAction { controlledState, pointerSweep, animatedState, themeChange }

typedef _PerfCase = ({
  String scenario,
  BenchmarkTrack track,
  bool animated,
  _PerfAction action,
});

const List<_PerfCase> _allCases = <_PerfCase>[
  (
    scenario: 'S2',
    track: BenchmarkTrack.isolation,
    animated: false,
    action: _PerfAction.controlledState,
  ),
  (
    scenario: 'S2',
    track: BenchmarkTrack.idiomatic,
    animated: false,
    action: _PerfAction.controlledState,
  ),
  (
    scenario: 'S3',
    track: BenchmarkTrack.idiomatic,
    animated: false,
    action: _PerfAction.pointerSweep,
  ),
  (
    scenario: 'S4',
    track: BenchmarkTrack.isolation,
    animated: true,
    action: _PerfAction.animatedState,
  ),
  (
    scenario: 'S5',
    track: BenchmarkTrack.isolation,
    animated: false,
    action: _PerfAction.themeChange,
  ),
];

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;

  testWidgets(
    'profile S2-S5 rendering-pipeline scenarios',
    (WidgetTester tester) async {
      if (!kProfileMode) {
        throw StateError(
          'Frame and GC results are valid only in profile mode. '
          'Run this test with fvm flutter drive --profile.',
        );
      }

      final orderLabel = const String.fromEnvironment(
        'BENCHMARK_ORDER',
        defaultValue: 'flutter-first',
      );
      final selectedScenarios = const String.fromEnvironment(
        'SCENARIOS',
        defaultValue: 'S2,S3,S4,S5',
      ).split(',').toSet();
      final unsupportedScenarios = selectedScenarios.difference(
        _supportedScenarios,
      );
      if (selectedScenarios.isEmpty || unsupportedScenarios.isNotEmpty) {
        throw ArgumentError.value(
          selectedScenarios,
          'SCENARIOS',
          'Expected a comma-separated subset of S2,S3,S4,S5',
        );
      }
      final results = <Map<String, Object?>>[];

      for (final benchmarkCase in _allCases) {
        if (!selectedScenarios.contains(benchmarkCase.scenario)) {
          continue;
        }
        for (final implementation in benchmarkImplementationOrder(orderLabel)) {
          results.add(
            await _runCase(
              tester: tester,
              binding: binding,
              implementation: implementation,
              benchmarkCase: benchmarkCase,
            ),
          );
        }
      }

      final view = binding.platformDispatcher.views.first;
      binding.reportData = <String, dynamic>{
        'schema_version': benchmarkSchemaVersion,
        'metadata': createBenchmarkMetadata(
          kind: 'profile_integration_benchmark',
          runOrder: orderLabel,
          view: view,
        ),
        'results': results,
      };
    },
    semanticsEnabled: false,
    timeout: Timeout.none,
  );
}

Future<Map<String, Object?>> _runCase({
  required WidgetTester tester,
  required IntegrationTestWidgetsFlutterBinding binding,
  required BenchmarkImplementation implementation,
  required _PerfCase benchmarkCase,
}) async {
  final cards = createBenchmarkCards();
  final controllers = BenchmarkControllerSet(cards);

  await tester.pumpWidget(
    BenchmarkApp(
      implementation: implementation,
      track: benchmarkCase.track,
      cards: cards,
      controllers: controllers,
      animated: benchmarkCase.animated,
    ),
  );
  await tester.pumpAndSettle();

  await _runTransitions(
    tester: tester,
    controllers: controllers,
    action: benchmarkCase.action,
    count: _warmupTransitions,
  );

  final reportKey = <String>[
    benchmarkCase.scenario,
    benchmarkCase.track.label,
    implementation.label,
  ].join('_');
  final result = await _capturePerformance(
    binding: binding,
    reportKey: reportKey,
    action: () => _runTransitions(
      tester: tester,
      controllers: controllers,
      action: benchmarkCase.action,
      count: _measuredTransitions,
    ),
  );

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  controllers.dispose();

  return <String, Object?>{
    'scenario': benchmarkCase.scenario,
    'action': benchmarkCase.action.name,
    'track': benchmarkCase.track.label,
    'implementation': implementation.label,
    'animated': benchmarkCase.animated,
    'warmup_transitions': _warmupTransitions,
    'measured_transitions': _measuredTransitions,
    ...result,
  };
}

Future<void> _runTransitions({
  required WidgetTester tester,
  required BenchmarkControllerSet controllers,
  required _PerfAction action,
  required int count,
}) async {
  final refreshRate =
      tester.binding.platformDispatcher.views.first.display.refreshRate;
  final transitionInterval = Duration(
    microseconds: (Duration.microsecondsPerSecond / refreshRate).round(),
  );
  if (action == _PerfAction.pointerSweep) {
    await _runPointerSweep(tester, count, transitionInterval);
    return;
  }

  for (var iteration = 0; iteration < count; iteration++) {
    final toggled = iteration.isEven;
    switch (action) {
      case _PerfAction.controlledState:
        controllers.setState(targetCardId, WidgetState.pressed, toggled);
        controllers.setState(targetCardId, WidgetState.selected, toggled);
        break;
      case _PerfAction.animatedState:
        controllers.setState(targetCardId, WidgetState.hovered, toggled);
        controllers.setState(targetCardId, WidgetState.pressed, !toggled);
        break;
      case _PerfAction.themeChange:
        controllers.toggleTheme();
        break;
      case _PerfAction.pointerSweep:
        throw StateError('Pointer sweeps use their own gesture loop.');
    }
    await tester.binding.delayed(transitionInterval);
  }
}

Future<void> _runPointerSweep(
  WidgetTester tester,
  int count,
  Duration transitionInterval,
) async {
  final centers = <Offset>[];
  for (var cardId = 0; cardId < benchmarkCardCount; cardId++) {
    final finder = find.byKey(ValueKey<String>('card-hit-target-$cardId'));
    if (finder.evaluate().isNotEmpty) {
      centers.add(tester.getCenter(finder));
    }
  }
  if (centers.isEmpty) {
    throw StateError('No visible card hit targets were found for S3.');
  }

  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: centers.first - const Offset(0, 24));
  for (var iteration = 0; iteration < count; iteration++) {
    await gesture.moveTo(centers[iteration % centers.length]);
    await tester.binding.delayed(transitionInterval);
  }
  await gesture.removePointer();
}

Future<Map<String, Object?>> _capturePerformance({
  required IntegrationTestWidgetsFlutterBinding binding,
  required String reportKey,
  required Future<void> Function() action,
}) async {
  final totalSpanTimings = <FrameTiming>[];
  final TimingsCallback callback = totalSpanTimings.addAll;
  var callbackInstalled = false;
  try {
    await binding.watchPerformance(() async {
      binding.addTimingsCallback(callback);
      callbackInstalled = true;
      await action();
    }, reportKey: reportKey);
  } finally {
    if (callbackInstalled) {
      binding.removeTimingsCallback(callback);
    }
  }

  if (totalSpanTimings.isEmpty) {
    throw StateError('No FrameTiming values were captured for $reportKey.');
  }

  final flutterSummary = Map<String, Object?>.from(
    binding.reportData!.remove(reportKey)! as Map,
  );
  final rawBuildTimes = flutterSummary.remove('frame_build_times');
  final rawRasterTimes = flutterSummary.remove('frame_rasterizer_times');
  final totalSpanMicroseconds = totalSpanTimings
      .map<int>((FrameTiming timing) => timing.totalSpan.inMicroseconds)
      .toList(growable: false);
  final totalSpanStatistics = DistributionStatistics.fromSamples(
    totalSpanMicroseconds,
  );
  final refreshRate =
      binding.platformDispatcher.views.first.display.refreshRate;
  final frameBudgetMicroseconds = (Duration.microsecondsPerSecond / refreshRate)
      .round();
  final missedFrames = totalSpanMicroseconds
      .where((int value) => value > frameBudgetMicroseconds)
      .length;

  return <String, Object?>{
    'metrics': <String, Object?>{
      ...flutterSummary,
      'refresh_rate_hz': refreshRate,
      'frame_budget_us': frameBudgetMicroseconds,
      'refresh_budget_missed_frame_count': missedFrames,
      'refresh_budget_missed_frame_ratio':
          missedFrames / totalSpanMicroseconds.length,
      ...totalSpanStatistics.toJson(unitSuffix: 'total_span_us'),
    },
    'raw': <String, Object?>{
      'frame_build_times_us': rawBuildTimes,
      'frame_rasterizer_times_us': rawRasterTimes,
      'frame_total_spans_us': totalSpanMicroseconds,
    },
  };
}
