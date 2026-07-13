// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import 'scenarios/card_grid.dart';
import 'scenarios/mix_card.dart';
import 'src/allocation_benchmark_protocol.dart';
import 'src/benchmark_metadata.dart';

const int _defaultWarmupOperations = 10000;
const int _defaultMeasuredOperations = 10000;

typedef _AllocationOperation = Object? Function();

Future<void> main() => executeAllocationMicrobenchmark();

Future<void> executeAllocationMicrobenchmark() async {
  if (!kProfileMode) {
    throw StateError(
      'Allocation profiles require profile mode. Run the target with '
      '`fvm flutter run --profile`, then use '
      '`fvm dart run tool/allocation_driver.dart` from another process.',
    );
  }

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  if (binding is! LiveTestWidgetsFlutterBinding) {
    throw StateError(
      'The allocation benchmark requires a live Flutter device.',
    );
  }

  final finished = Completer<void>();
  final staticContextKey = GlobalKey();
  final allActiveContextKey = GlobalKey();

  await benchmarkWidgets((WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: <Widget>[
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

    final contexts = <AllocationProfile, BuildContext?>{
      AllocationProfile.static: staticContextKey.currentContext,
      AllocationProfile.allActive: allActiveContextKey.currentContext,
    };
    if (contexts.values.any((context) => context == null || !context.mounted)) {
      throw StateError('A diagnostic BuildContext was not mounted.');
    }

    final style = styleForCard(CardStateProfile.all, animated: false);
    final premergedStyles = <AllocationProfile, Style<BoxSpec>>{
      for (final profile in AllocationProfile.values)
        profile: style.mergeActiveVariants(
          contexts[profile]!,
          namedVariants: const <NamedVariant>{},
        ),
    };
    final selectedVariantCounts = <AllocationProfile, int>{
      for (final profile in AllocationProfile.values)
        profile: _selectedVariantCount(style, contexts[profile]!),
    };
    Object? blackHole;
    final operations = <AllocationBenchmarkCase, _AllocationOperation>{
      for (final profile in AllocationProfile.values)
        for (final stage in AllocationStage.values)
          (profile: profile, stage: stage): switch (stage) {
            AllocationStage.control => () => blackHole = style,
            AllocationStage.variantMerge =>
              () => blackHole = style.mergeActiveVariants(
                contexts[profile]!,
                namedVariants: const <NamedVariant>{},
              ),
            AllocationStage.specResolve =>
              () => blackHole = premergedStyles[profile]!.resolve(
                contexts[profile]!,
              ),
            AllocationStage.fullBuild => () => blackHole = style.build(
              contexts[profile]!,
            ),
          },
    };
    AllocationBenchmarkCase? warmedCase;
    List<Object?> retainedResults = const <Object?>[];

    developer.registerExtension(allocationInfoExtension, (
      method,
      parameters,
    ) async {
      final runOrder = parameters['run_order'] ?? 'unknown';
      final view = binding.platformDispatcher.views.firstOrNull;
      final metadata = createBenchmarkMetadata(
        kind: 'profile_allocation_microbenchmark',
        runOrder: runOrder,
        view: view,
      );

      return developer.ServiceExtensionResponse.result(
        jsonEncode(<String, Object?>{
          'schema_version': benchmarkSchemaVersion,
          'metadata': metadata,
          'default_warmup_operations': _defaultWarmupOperations,
          'default_measured_operations': _defaultMeasuredOperations,
          'cases': <Map<String, String>>[
            for (final entry in allocationBenchmarkCases('forward'))
              <String, String>{
                'profile': entry.profile.label,
                'stage': entry.stage.label,
              },
          ],
        }),
      );
    });

    developer.registerExtension(allocationWarmupExtension, (
      method,
      parameters,
    ) async {
      try {
        final benchmarkCase = _parseCase(parameters);
        final operationCount = _parseOperationCount(
          parameters,
          fallback: _defaultWarmupOperations,
        );
        retainedResults = const <Object?>[];
        _runOperations(operations[benchmarkCase]!, operationCount);
        if (blackHole == null) {
          throw StateError('The warmup operation did not produce a value.');
        }
        warmedCase = benchmarkCase;

        return _resultResponse(<String, Object?>{
          'profile': benchmarkCase.profile.label,
          'stage': benchmarkCase.stage.label,
          'warmup_operations': operationCount,
        });
      } catch (error) {
        return _errorResponse(error);
      }
    });

    developer.registerExtension(allocationRunExtension, (
      method,
      parameters,
    ) async {
      try {
        final benchmarkCase = _parseCase(parameters);
        if (benchmarkCase != warmedCase) {
          throw StateError(
            'Warm up ${benchmarkCase.profile.label}/'
            '${benchmarkCase.stage.label} before measuring it.',
          );
        }
        final operationCount = _parseOperationCount(
          parameters,
          fallback: _defaultMeasuredOperations,
        );
        final stopwatch = Stopwatch()..start();
        retainedResults = _runOperationsRetainingResults(
          operations[benchmarkCase]!,
          operationCount,
        );
        stopwatch.stop();
        if (blackHole == null || retainedResults.length != operationCount) {
          throw StateError('The measured operation did not produce a value.');
        }
        warmedCase = null;

        return _resultResponse(<String, Object?>{
          'profile': benchmarkCase.profile.label,
          'stage': benchmarkCase.stage.label,
          'declared_variant_count': style.$variants?.length ?? 0,
          'selected_variant_count':
              selectedVariantCounts[benchmarkCase.profile]!,
          'operation_count': operationCount,
          'elapsed_microseconds': stopwatch.elapsedMicroseconds,
          'elapsed_nanoseconds_per_operation':
              stopwatch.elapsedMicroseconds * 1000 / operationCount,
        });
      } catch (error) {
        return _errorResponse(error);
      }
    });

    developer.registerExtension(allocationFinishExtension, (
      method,
      parameters,
    ) async {
      Timer.run(() {
        if (!finished.isCompleted) finished.complete();
      });
      return _resultResponse(const <String, Object?>{'finished': true});
    });

    print('ALLOCATION_BENCHMARK_READY');
    await finished.future;
  });

  print('ALLOCATION_BENCHMARK_FINISHED');
  exit(0);
}

void _runOperations(_AllocationOperation operation, int operationCount) {
  for (var index = 0; index < operationCount; index++) {
    operation();
  }
}

List<Object?> _runOperationsRetainingResults(
  _AllocationOperation operation,
  int operationCount,
) {
  final results = List<Object?>.filled(operationCount, null, growable: false);
  for (var index = 0; index < operationCount; index++) {
    results[index] = operation();
  }

  return results;
}

AllocationBenchmarkCase _parseCase(Map<String, String> parameters) {
  final profileLabel = parameters['profile'];
  final stageLabel = parameters['stage'];
  final profile = AllocationProfile.values
      .where((entry) => entry.label == profileLabel)
      .firstOrNull;
  final stage = AllocationStage.values
      .where((entry) => entry.label == stageLabel)
      .firstOrNull;
  if (profile == null || stage == null) {
    throw FormatException(
      'Unsupported allocation case: profile=$profileLabel, stage=$stageLabel.',
    );
  }

  return (profile: profile, stage: stage);
}

int _parseOperationCount(
  Map<String, String> parameters, {
  required int fallback,
}) {
  final value = int.tryParse(parameters['operation_count'] ?? '') ?? fallback;
  if (value <= 0) {
    throw FormatException('operation_count must be greater than zero.');
  }

  return value;
}

developer.ServiceExtensionResponse _resultResponse(Map<String, Object?> body) {
  return developer.ServiceExtensionResponse.result(jsonEncode(body));
}

developer.ServiceExtensionResponse _errorResponse(Object error) {
  return developer.ServiceExtensionResponse.error(
    developer.ServiceExtensionResponse.invalidParams,
    jsonEncode(<String, Object?>{'error': error.toString()}),
  );
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
