// The result-file marker is the CLI interface for this benchmark.
// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'scenarios/card_grid.dart';
import 'scenarios/mix_card.dart';
import 'src/benchmark_metadata.dart';
import 'src/statistics.dart';

const int _defaultOperationsPerBatch = 100;
const int _controlOperationsPerBatch = 100000;
const int _warmupBatches = 100;
const int _benchmarkSeconds = int.fromEnvironment(
  'BENCHMARK_SECONDS',
  defaultValue: 3,
);

enum _ResolutionStage {
  control,
  variantMerge,
  propertyResolve,
  specConstruction,
  specResolve,
  fullBuild,
}

enum _ResolutionProfile { inactiveOnly, static, allActive }

extension on _ResolutionStage {
  String get label => switch (this) {
    _ResolutionStage.control => 'control_store',
    _ResolutionStage.variantMerge => 'variant_merge',
    _ResolutionStage.propertyResolve => 'property_resolve',
    _ResolutionStage.specConstruction => 'spec_construction',
    _ResolutionStage.specResolve => 'premerged_spec_resolve',
    _ResolutionStage.fullBuild => 'full_style_build',
  };
}

extension on _ResolutionProfile {
  String get label => switch (this) {
    _ResolutionProfile.inactiveOnly => 'inactive_only',
    _ResolutionProfile.static => 'static',
    _ResolutionProfile.allActive => 'all_active',
  };
}

typedef _ResolutionStageCase = ({
  _ResolutionProfile profile,
  _ResolutionStage stage,
});

typedef _ResolvedBoxFields = ({
  AlignmentGeometry? alignment,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  BoxConstraints? constraints,
  Decoration? decoration,
  Decoration? foregroundDecoration,
  Matrix4? transform,
  AlignmentGeometry? transformAlignment,
  Clip? clipBehavior,
  AnimationConfig? animation,
  List<WidgetModifier>? widgetModifiers,
});

Future<void> main() => executeResolutionStageMicrobenchmark();

Future<void> executeResolutionStageMicrobenchmark() async {
  if (!kReleaseMode) {
    throw StateError(
      'CPU timings are valid only in release mode. '
      'Run: fvm flutter run --release -d <device> '
      '-t lib/resolution_stage_microbenchmark.dart',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError('The microbenchmark requires a live Flutter device.');
  }

  final orderLabel = const String.fromEnvironment(
    'STAGE_ORDER',
    defaultValue: 'forward',
  );
  final inactiveContextKey = GlobalKey();
  final staticContextKey = GlobalKey();
  final allActiveContextKey = GlobalKey();
  final results = <Map<String, Object?>>[];

  await benchmarkWidgets((WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: <Widget>[
            WidgetStateProvider(
              states: const <WidgetState>{},
              child: SizedBox(key: inactiveContextKey),
            ),
            WidgetStateProvider(
              states: const <WidgetState>{},
              child: SizedBox(key: staticContextKey),
            ),
            WidgetStateProvider(
              states: const <WidgetState>{
                WidgetState.disabled,
                WidgetState.hovered,
                WidgetState.pressed,
                WidgetState.selected,
              },
              child: SizedBox(key: allActiveContextKey),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final contexts = <_ResolutionProfile, BuildContext?>{
      _ResolutionProfile.inactiveOnly: inactiveContextKey.currentContext,
      _ResolutionProfile.static: staticContextKey.currentContext,
      _ResolutionProfile.allActive: allActiveContextKey.currentContext,
    };
    if (contexts.values.any((context) => context == null || !context.mounted)) {
      throw StateError('A diagnostic BuildContext was not mounted.');
    }

    final style = styleForCard(CardStateProfile.all, animated: false);
    final styles = <_ResolutionProfile, BoxStyler>{
      _ResolutionProfile.inactiveOnly: _createInactiveOnlyStyle(),
      _ResolutionProfile.static: style,
      _ResolutionProfile.allActive: style,
    };
    final premergedStyles = <_ResolutionProfile, BoxStyler>{
      for (final profile in _ResolutionProfile.values)
        profile:
            styles[profile]!.mergeActiveVariants(
                  contexts[profile]!,
                  namedVariants: const <NamedVariant>{},
                )
                as BoxStyler,
    };
    final resolvedFields = <_ResolutionProfile, _ResolvedBoxFields>{
      for (final profile in _ResolutionProfile.values)
        profile: _resolveBoxFields(
          contexts[profile]!,
          premergedStyles[profile]!,
        ),
    };
    final selectedVariantCounts = <_ResolutionProfile, int>{
      for (final profile in _ResolutionProfile.values)
        profile: _selectedVariantCount(styles[profile]!, contexts[profile]!),
    };

    for (final stageCase in _stageCases(orderLabel)) {
      final profile = stageCase.profile;
      final stage = stageCase.stage;
      print('RESOLUTION_STAGE_PROGRESS:${profile.label}:${stage.label}:start');
      results.add(
        _measureCase(
          context: contexts[profile]!,
          profile: profile,
          stage: stage,
          style: styles[profile]!,
          premergedStyle: premergedStyles[profile]!,
          resolvedFields: resolvedFields[profile]!,
          selectedVariantCount: selectedVariantCounts[profile]!,
        ),
      );
      print('RESOLUTION_STAGE_PROGRESS:${profile.label}:${stage.label}:done');
    }
  });

  final expectedResultCount =
      _ResolutionProfile.values.length * _ResolutionStage.values.length;
  if (results.length != expectedResultCount) {
    throw StateError(
      'Expected $expectedResultCount benchmark results, got ${results.length}.',
    );
  }

  final view = binding.platformDispatcher.views.firstOrNull;
  final output = <String, Object?>{
    'schema_version': benchmarkSchemaVersion,
    'metadata': createBenchmarkMetadata(
      kind: 'release_resolution_stage_microbenchmark',
      runOrder: orderLabel,
      view: view,
    ),
    'results': results,
  };

  final configuredOutputPath = const String.fromEnvironment(
    'BENCHMARK_OUTPUT_PATH',
  );
  final outputFile = configuredOutputPath.isEmpty
      ? File(
          '${Directory.systemTemp.path}/mix_resolution_stage_microbenchmark.json',
        )
      : File(configuredOutputPath).absolute;
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(jsonEncode(output));
  print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  exit(0);
}

List<_ResolutionStageCase> _stageCases(String orderLabel) {
  final cases = <_ResolutionStageCase>[
    for (final profile in _ResolutionProfile.values)
      for (final stage in _ResolutionStage.values)
        (profile: profile, stage: stage),
  ];

  return switch (orderLabel) {
    'forward' => cases,
    'reverse' => cases.reversed.toList(growable: false),
    _ => throw ArgumentError.value(
      orderLabel,
      'orderLabel',
      'Expected forward or reverse',
    ),
  };
}

Map<String, Object?> _measureCase({
  required BuildContext context,
  required _ResolutionProfile profile,
  required _ResolutionStage stage,
  required BoxStyler style,
  required Style<BoxSpec> premergedStyle,
  required _ResolvedBoxFields resolvedFields,
  required int selectedVariantCount,
}) {
  Object? blackHole;
  final operationsPerBatch = stage == _ResolutionStage.control
      ? _controlOperationsPerBatch
      : _defaultOperationsPerBatch;
  final operation = switch (stage) {
    _ResolutionStage.control => () => blackHole = style,
    _ResolutionStage.variantMerge =>
      () => blackHole = style.mergeActiveVariants(
        context,
        namedVariants: const <NamedVariant>{},
      ),
    _ResolutionStage.propertyResolve => () => blackHole = _resolveBoxFields(
      context,
      premergedStyle as BoxStyler,
    ),
    _ResolutionStage.specConstruction => () => blackHole = _constructStyleSpec(
      resolvedFields,
    ),
    _ResolutionStage.specResolve => () => blackHole = premergedStyle.resolve(
      context,
    ),
    _ResolutionStage.fullBuild => () => blackHole = style.build(context),
  };

  void runBatch() {
    for (
      var operationIndex = 0;
      operationIndex < operationsPerBatch;
      operationIndex++
    ) {
      operation();
    }
  }

  for (var batch = 0; batch < _warmupBatches; batch++) {
    runBatch();
  }

  final samples = <int>[];
  final measuredTime = Stopwatch()..start();
  final batchTime = Stopwatch();
  while (measuredTime.elapsed < const Duration(seconds: _benchmarkSeconds)) {
    batchTime
      ..reset()
      ..start();
    runBatch();
    batchTime.stop();

    final elapsedNanoseconds =
        batchTime.elapsedTicks *
        Duration.microsecondsPerSecond *
        1000 /
        batchTime.frequency;
    samples.add((elapsedNanoseconds / operationsPerBatch).round());
  }
  measuredTime.stop();

  if (blackHole == null) {
    throw StateError('The benchmark operation did not produce a value.');
  }

  return <String, Object?>{
    'profile': profile.label,
    'stage': stage.label,
    'declared_variant_count': style.$variants?.length ?? 0,
    'selected_variant_count': selectedVariantCount,
    'operations_per_batch': operationsPerBatch,
    'warmup_batches': _warmupBatches,
    'measurement_duration_ms': measuredTime.elapsedMilliseconds,
    'metrics': DistributionStatistics.fromSamples(
      samples,
    ).toJson(unitSuffix: 'ns'),
    'samples_ns_per_operation': samples,
  };
}

int _selectedVariantCount(BoxStyler style, BuildContext context) {
  return (style.$variants ?? const <VariantStyle<BoxSpec>>[])
      .where(
        (variantStyle) => switch (variantStyle.variant) {
          ContextVariant variant => variant.when(context),
          NamedVariant _ => false,
          ContextVariantBuilder _ => true,
        },
      )
      .length;
}

_ResolvedBoxFields _resolveBoxFields(BuildContext context, BoxStyler style) {
  return (
    alignment: MixOps.resolve(context, style.$alignment),
    padding: MixOps.resolve(context, style.$padding),
    margin: MixOps.resolve(context, style.$margin),
    constraints: MixOps.resolve(context, style.$constraints),
    decoration: MixOps.resolve(context, style.$decoration),
    foregroundDecoration: MixOps.resolve(context, style.$foregroundDecoration),
    transform: MixOps.resolve(context, style.$transform),
    transformAlignment: MixOps.resolve(context, style.$transformAlignment),
    clipBehavior: MixOps.resolve(context, style.$clipBehavior),
    animation: style.$animation,
    widgetModifiers: style.$modifier?.resolve(context),
  );
}

StyleSpec<BoxSpec> _constructStyleSpec(_ResolvedBoxFields fields) {
  return StyleSpec(
    spec: BoxSpec(
      alignment: fields.alignment,
      padding: fields.padding,
      margin: fields.margin,
      constraints: fields.constraints,
      decoration: fields.decoration,
      foregroundDecoration: fields.foregroundDecoration,
      transform: fields.transform,
      transformAlignment: fields.transformAlignment,
      clipBehavior: fields.clipBehavior,
    ),
    animation: fields.animation,
    widgetModifiers: fields.widgetModifiers,
  );
}

BoxStyler _createInactiveOnlyStyle() {
  return BoxStyler()
      .size(100, 100)
      .color(Colors.black)
      .onHovered(BoxStyler().color(Colors.blue))
      .onPressed(BoxStyler().scale(0.98))
      .variant(
        ContextVariant.widgetState(WidgetState.selected),
        BoxStyler().borderAll(color: Colors.indigo, width: 2),
      )
      .onDisabled(BoxStyler().wrap(WidgetModifierConfig.opacity(0.45)));
}
