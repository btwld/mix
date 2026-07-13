// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'src/benchmark_case_host.dart';
import 'src/benchmark_frame_clock.dart';
import 'src/benchmark_frame_guard.dart';
import 'src/benchmark_metadata.dart';
import 'src/statistics.dart';

const List<int> _variantCounts = <int>[0, 1, 4, 12];
const int _warmupIterations = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);
const List<WidgetState> _widgetStates = <WidgetState>[
  WidgetState.disabled,
  WidgetState.hovered,
  WidgetState.focused,
  WidgetState.pressed,
  WidgetState.dragged,
  WidgetState.selected,
  WidgetState.error,
];

Future<void> main() => executeVariantMicrobenchmark();

Future<void> executeVariantMicrobenchmark() async {
  if (!kReleaseMode) {
    throw StateError(
      'CPU timings are valid only in release mode. '
      'Run: fvm flutter run --release -d <device> '
      '-t lib/variant_microbenchmark.dart',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError('The microbenchmark requires a live Flutter device.');
  }

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
      for (final variantCount in _variantCounts) {
        print('VARIANT_BENCHMARK_PROGRESS:$variantCount:start');
        results.add(
          await _measureCase(
            tester: tester,
            host: host,
            variantCount: variantCount,
            frameClock: frameClock,
          ),
        );
        print('VARIANT_BENCHMARK_PROGRESS:$variantCount:done');
      }
    } finally {
      frameGuard.dispose();
    }
  });

  final view = binding.platformDispatcher.views.firstOrNull;
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': createBenchmarkMetadata(
      kind: 'release_variant_microbenchmark',
      runOrder: 'variant-count-ascending',
      view: view,
    ),
    'results': results,
  };

  final configuredOutputPath = const String.fromEnvironment(
    'BENCHMARK_OUTPUT_PATH',
  );
  final outputFile = configuredOutputPath.isEmpty
      ? File('${Directory.systemTemp.path}/mix_variant_microbenchmark.json')
      : File(configuredOutputPath).absolute;
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(output));
  print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  exit(0);
}

Future<Map<String, Object?>> _measureCase({
  required WidgetTester tester,
  required BenchmarkCaseHostState host,
  required int variantCount,
  required BenchmarkFrameClock frameClock,
}) async {
  final controller = WidgetStatesController(_widgetStates.toSet());
  final hostKey = GlobalKey<_VariantBenchmarkHostState>();

  host.showCase(
    MaterialApp(
      home: Center(
        child: _VariantBenchmarkHost(
          key: hostKey,
          controller: controller,
          style: _createStyle(variantCount),
        ),
      ),
    ),
  );
  await tester.pumpBenchmark(frameClock.next());
  if (hostKey.currentState == null) {
    throw StateError('The variant benchmark case was not mounted.');
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
    'variant_count': variantCount,
    'warmup_iterations': _warmupIterations,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': DistributionStatistics.fromSamples(
      samples,
    ).toJson(unitSuffix: 'us'),
    'samples_us': samples,
  };
}

BoxStyler _createStyle(int variantCount) {
  var style = BoxStyler().size(100, 100).color(Colors.black);

  for (var index = 0; index < variantCount; index++) {
    final variant = index.isEven
        ? ContextVariant('always-active-$index', (_) => true)
        : ContextVariant.widgetState(
            _widgetStates[(index ~/ 2) % _widgetStates.length],
          );
    style = style.variant(
      variant,
      BoxStyler()
          .paddingAll(index.toDouble())
          .color(Color(0xff000000 | index * 0x00010101)),
    );
  }

  return style;
}

class _VariantBenchmarkHost extends StatefulWidget {
  const _VariantBenchmarkHost({
    super.key,
    required this.controller,
    required this.style,
  });

  final WidgetStatesController controller;
  final BoxStyler style;

  @override
  State<_VariantBenchmarkHost> createState() => _VariantBenchmarkHostState();
}

class _VariantBenchmarkHostState extends State<_VariantBenchmarkHost> {
  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<BoxSpec>(
      controller: widget.controller,
      style: widget.style,
      builder: (BuildContext context, BoxSpec spec) => Container(
        alignment: spec.alignment,
        padding: spec.padding,
        margin: spec.margin,
        constraints: spec.constraints,
        decoration: spec.decoration,
        foregroundDecoration: spec.foregroundDecoration,
        transform: spec.transform,
        transformAlignment: spec.transformAlignment,
        clipBehavior: spec.clipBehavior ?? Clip.none,
      ),
    );
  }
}
