// Exploratory only: pumped-frame distributions currently dominate the wrapper
// deltas. Do not use this target for standalone stage-cost claims.
// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'scenarios/card_grid.dart';
import 'scenarios/mix_card.dart';
import 'src/benchmark_case_host.dart';
import 'src/benchmark_frame_clock.dart';
import 'src/benchmark_frame_guard.dart';
import 'src/benchmark_metadata.dart';
import 'src/statistics.dart';

const int _warmupIterations = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);
const Widget _cachedChild = SizedBox.expand();

enum _PostBuildStage { direct, animation, styleSpec, fullStyle }

extension on _PostBuildStage {
  String get label => switch (this) {
    _PostBuildStage.direct => 'direct_renderer',
    _PostBuildStage.animation => 'null_animation_builder',
    _PostBuildStage.styleSpec => 'style_spec_builder',
    _PostBuildStage.fullStyle => 'full_style_builder',
  };
}

Future<void> main() => executePostBuildMicrobenchmark();

Future<void> executePostBuildMicrobenchmark() async {
  if (!kReleaseMode) {
    throw StateError(
      'CPU timings are valid only in release mode. '
      'Run: fvm flutter run --release -d <device> '
      '-t lib/post_build_microbenchmark.dart',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError('The microbenchmark requires a live Flutter device.');
  }

  final orderLabel = const String.fromEnvironment(
    'POST_BUILD_ORDER',
    defaultValue: 'forward',
  );
  final results = <Map<String, Object?>>[];
  final frameClock = BenchmarkFrameClock();

  await benchmarkWidgets((WidgetTester tester) async {
    final benchmarkHostKey = GlobalKey<BenchmarkCaseHostState>();
    await tester.pumpWidget(BenchmarkCaseHost(key: benchmarkHostKey));
    await tester.pumpAndSettle();
    final benchmarkHost = benchmarkHostKey.currentState;
    if (benchmarkHost == null || !benchmarkHost.mounted) {
      throw StateError('The persistent benchmark host was not mounted.');
    }

    final setupContextKey = GlobalKey();
    benchmarkHost.showCase(
      MaterialApp(
        home: WidgetStateProvider(
          states: const <WidgetState>{},
          child: SizedBox(key: setupContextKey),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final setupContext = setupContextKey.currentContext;
    if (setupContext == null || !setupContext.mounted) {
      throw StateError('The diagnostic BuildContext was not mounted.');
    }

    final style = styleForCard(CardStateProfile.all, animated: false);
    final styleSpec = style.build(setupContext);

    final frameGuard = BenchmarkFrameGuard.enter(binding);
    try {
      for (final stage in _stageOrder(orderLabel)) {
        print('POST_BUILD_PROGRESS:${stage.label}:start');
        results.add(
          await _measureCase(
            tester: tester,
            host: benchmarkHost,
            stage: stage,
            style: style,
            styleSpec: styleSpec,
            frameClock: frameClock,
          ),
        );
        print('POST_BUILD_PROGRESS:${stage.label}:done');
      }
    } finally {
      frameGuard.dispose();
    }
  });

  if (results.length != _PostBuildStage.values.length) {
    throw StateError(
      'Expected ${_PostBuildStage.values.length} benchmark results, '
      'got ${results.length}.',
    );
  }

  final view = binding.platformDispatcher.views.firstOrNull;
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': createBenchmarkMetadata(
      kind: 'release_post_build_microbenchmark',
      runOrder: orderLabel,
      view: view,
    ),
    'results': results,
  };

  final configuredOutputPath = const String.fromEnvironment(
    'BENCHMARK_OUTPUT_PATH',
  );
  final outputFile = configuredOutputPath.isEmpty
      ? File('${Directory.systemTemp.path}/mix_post_build_microbenchmark.json')
      : File(configuredOutputPath).absolute;
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(output));
  print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  exit(0);
}

List<_PostBuildStage> _stageOrder(String orderLabel) {
  return switch (orderLabel) {
    'forward' => _PostBuildStage.values,
    'reverse' => _PostBuildStage.values.reversed.toList(growable: false),
    _ => throw ArgumentError.value(
      orderLabel,
      'orderLabel',
      'Expected forward or reverse',
    ),
  };
}

Future<Map<String, Object?>> _measureCase({
  required WidgetTester tester,
  required BenchmarkCaseHostState host,
  required _PostBuildStage stage,
  required BoxStyler style,
  required StyleSpec<BoxSpec> styleSpec,
  required BenchmarkFrameClock frameClock,
}) async {
  final controller = WidgetStatesController();
  final hostKey = GlobalKey<_PostBuildBenchmarkHostState>();

  host.showCase(
    MaterialApp(
      home: Center(
        child: SizedBox(
          width: 180,
          height: 160,
          child: _PostBuildBenchmarkHost(
            key: hostKey,
            stage: stage,
            controller: controller,
            style: style,
            styleSpec: styleSpec,
          ),
        ),
      ),
    ),
  );
  await tester.pumpBenchmark(frameClock.next());
  if (hostKey.currentState == null) {
    throw StateError('The post-build benchmark case was not mounted.');
  }

  Future<void> runIteration() async {
    hostKey.currentState!.rebuild();
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
  controller.dispose();

  return <String, Object?>{
    'stage': stage.label,
    'warmup_iterations': _warmupIterations,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': DistributionStatistics.fromSamples(
      samples,
    ).toJson(unitSuffix: 'us'),
    'samples_us': samples,
  };
}

class _PostBuildBenchmarkHost extends StatefulWidget {
  const _PostBuildBenchmarkHost({
    super.key,
    required this.stage,
    required this.controller,
    required this.style,
    required this.styleSpec,
  });

  final _PostBuildStage stage;
  final WidgetStatesController controller;
  final BoxStyler style;
  final StyleSpec<BoxSpec> styleSpec;

  @override
  State<_PostBuildBenchmarkHost> createState() =>
      _PostBuildBenchmarkHostState();
}

class _PostBuildBenchmarkHostState extends State<_PostBuildBenchmarkHost> {
  void rebuild() {
    setState(() {});
  }

  Widget _buildRenderer(BuildContext context, BoxSpec spec) {
    return SharedCardRenderer(
      data: contractCardData,
      spec: spec,
      child: _cachedChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.stage) {
      _PostBuildStage.direct => _buildRenderer(context, widget.styleSpec.spec),
      _PostBuildStage.animation => StyleAnimationBuilder<BoxSpec>(
        spec: widget.styleSpec,
        builder: (context, spec) => _buildRenderer(context, spec.spec),
      ),
      _PostBuildStage.styleSpec => StyleSpecBuilder<BoxSpec>(
        styleSpec: widget.styleSpec,
        builder: _buildRenderer,
      ),
      _PostBuildStage.fullStyle => StyleBuilder<BoxSpec>(
        controller: widget.controller,
        style: widget.style,
        builder: _buildRenderer,
      ),
    };
  }
}
