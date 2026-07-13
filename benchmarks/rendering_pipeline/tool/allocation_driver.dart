// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rendering_pipeline/src/allocation_benchmark_protocol.dart';
import 'package:rendering_pipeline/src/allocation_profile_summary.dart';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

const Duration _connectionTimeout = Duration(seconds: 30);

Future<void> main(List<String> arguments) async {
  final options = _AllocationDriverOptions.parse(arguments);
  final serviceUri = await _resolveServiceUri(options);
  final service = await vmServiceConnectUri(serviceUri.toString());
  String? isolateId;
  var finished = false;

  try {
    isolateId = await _waitForBenchmarkIsolate(service);
    final info = await _callExtension(
      service,
      isolateId,
      allocationInfoExtension,
      <String, Object?>{'run_order': options.orderLabel},
    );
    final results = <Map<String, Object?>>[];

    for (final benchmarkCase in allocationBenchmarkCases(options.orderLabel)) {
      final caseArguments = <String, Object?>{
        'profile': benchmarkCase.profile.label,
        'stage': benchmarkCase.stage.label,
        'operation_count': options.operationCount,
      };
      print(
        'ALLOCATION_DRIVER_PROGRESS:${benchmarkCase.profile.label}:'
        '${benchmarkCase.stage.label}:start',
      );
      await _callExtension(
        service,
        isolateId,
        allocationWarmupExtension,
        <String, Object?>{
          ...caseArguments,
          'operation_count': options.warmupOperationCount,
        },
      );
      final baselineProfile = await service.getAllocationProfile(
        isolateId,
        gc: true,
      );
      final timing = await _callExtension(
        service,
        isolateId,
        allocationRunExtension,
        caseArguments,
      );
      final allocationProfile = await service.getAllocationProfile(
        isolateId,
        gc: true,
      );
      final baselineClasses = <String, ClassHeapStats>{
        for (final stats in baselineProfile.members ?? const <ClassHeapStats>[])
          ?stats.classRef?.id: stats,
      };
      final summary = summarizeAllocationProfile(
        operationCount: options.operationCount,
        classLimit: options.classLimit,
        classes: <AllocationClassCount>[
          for (final stats
              in allocationProfile.members ?? const <ClassHeapStats>[])
            AllocationClassCount(
              classId: stats.classRef?.id ?? 'unknown',
              className: stats.classRef?.name ?? 'unknown',
              libraryUri: stats.classRef?.library?.uri ?? 'unknown',
              instances:
                  (stats.instancesCurrent ?? 0) -
                  (baselineClasses[stats.classRef?.id]?.instancesCurrent ?? 0),
              bytes:
                  (stats.bytesCurrent ?? 0) -
                  (baselineClasses[stats.classRef?.id]?.bytesCurrent ?? 0),
            ),
        ],
      );
      results.add(<String, Object?>{
        ...timing,
        'warmup_operations': options.warmupOperationCount,
        'retained_heap_delta': summary.toJson(),
        if (baselineProfile.memoryUsage case final baselineMemoryUsage?)
          'baseline_memory_usage': baselineMemoryUsage.toJson(),
        if (allocationProfile.memoryUsage case final memoryUsage?)
          'memory_usage': memoryUsage.toJson(),
      });
      print(
        'ALLOCATION_DRIVER_PROGRESS:${benchmarkCase.profile.label}:'
        '${benchmarkCase.stage.label}:done',
      );
    }

    final metadata =
        (info['metadata']! as Map<Object?, Object?>).cast<String, Object?>()
          ..['allocation_collection'] =
              'external_vm_service_retained_heap_delta'
          ..['allocation_scope'] =
              'objects reachable from retained operation results; excludes '
              'transient intermediates';
    final output = <String, Object?>{
      'schema_version': info['schema_version'],
      'metadata': metadata,
      'results': results,
    };
    final outputFile = File(options.outputPath).absolute;
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(jsonEncode(output));

    await _callExtension(
      service,
      isolateId,
      allocationFinishExtension,
      const <String, Object?>{},
    );
    finished = true;
    print('BENCHMARK_RESULT_FILE:${outputFile.path}');
  } finally {
    if (!finished && isolateId != null) {
      try {
        await _callExtension(
          service,
          isolateId,
          allocationFinishExtension,
          const <String, Object?>{},
        );
      } catch (_) {
        // Preserve the original driver failure.
      }
    }
    await service.dispose();
  }
}

Future<Uri> _resolveServiceUri(_AllocationDriverOptions options) async {
  if (options.serviceUri case final serviceUri?) {
    return convertToWebSocketUrl(serviceProtocolUrl: Uri.parse(serviceUri));
  }

  final serviceUriFile = File(options.serviceUriFile!);
  final deadline = DateTime.now().add(_connectionTimeout);
  while (DateTime.now().isBefore(deadline)) {
    if (await serviceUriFile.exists()) {
      final contents = (await serviceUriFile.readAsString()).trim();
      if (contents.isNotEmpty) {
        return convertToWebSocketUrl(serviceProtocolUrl: Uri.parse(contents));
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  throw TimeoutException(
    'Timed out waiting for VM service URI file ${serviceUriFile.path}.',
    _connectionTimeout,
  );
}

Future<String> _waitForBenchmarkIsolate(VmService service) async {
  final deadline = DateTime.now().add(_connectionTimeout);
  while (DateTime.now().isBefore(deadline)) {
    final vm = await service.getVM();
    for (final isolateRef in vm.isolates ?? const <IsolateRef>[]) {
      if (isolateRef.isSystemIsolate ?? false) continue;
      final id = isolateRef.id;
      if (id == null) continue;
      final candidate = await service.getIsolate(id);
      if (candidate.extensionRPCs?.contains(allocationInfoExtension) ?? false) {
        return id;
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  throw TimeoutException(
    'Timed out waiting for $allocationInfoExtension.',
    _connectionTimeout,
  );
}

Future<Map<String, Object?>> _callExtension(
  VmService service,
  String isolateId,
  String method,
  Map<String, Object?> arguments,
) async {
  final response = await service.callServiceExtension(
    method,
    isolateId: isolateId,
    args: arguments,
  );

  return (response.json ?? const <String, Object?>{}).cast<String, Object?>();
}

class _AllocationDriverOptions {
  const _AllocationDriverOptions({
    required this.serviceUri,
    required this.serviceUriFile,
    required this.outputPath,
    required this.orderLabel,
    required this.operationCount,
    required this.warmupOperationCount,
    required this.classLimit,
  });

  final String? serviceUri;
  final String? serviceUriFile;
  final String outputPath;
  final String orderLabel;
  final int operationCount;
  final int warmupOperationCount;
  final int classLimit;

  factory _AllocationDriverOptions.parse(List<String> arguments) {
    String? serviceUri;
    String? serviceUriFile;
    String? outputPath;
    var orderLabel = 'forward';
    var operationCount = 10000;
    var warmupOperationCount = 10000;
    var classLimit = 200;

    for (final argument in arguments) {
      if (argument.startsWith('--service-uri=')) {
        serviceUri = argument.substring('--service-uri='.length);
      } else if (argument.startsWith('--service-uri-file=')) {
        serviceUriFile = argument.substring('--service-uri-file='.length);
      } else if (argument.startsWith('--output=')) {
        outputPath = argument.substring('--output='.length);
      } else if (argument.startsWith('--order=')) {
        orderLabel = argument.substring('--order='.length);
      } else if (argument.startsWith('--operation-count=')) {
        operationCount = _parsePositiveInt(argument, '--operation-count=');
      } else if (argument.startsWith('--warmup-operation-count=')) {
        warmupOperationCount = _parsePositiveInt(
          argument,
          '--warmup-operation-count=',
        );
      } else if (argument.startsWith('--class-limit=')) {
        classLimit = _parsePositiveInt(argument, '--class-limit=');
      } else {
        throw FormatException('Unknown allocation driver argument: $argument');
      }
    }

    if ((serviceUri == null) == (serviceUriFile == null)) {
      throw const FormatException(
        'Provide exactly one of --service-uri or --service-uri-file.',
      );
    }
    if (outputPath == null || outputPath.isEmpty) {
      throw const FormatException('--output is required.');
    }
    allocationBenchmarkCases(orderLabel);

    return _AllocationDriverOptions(
      serviceUri: serviceUri,
      serviceUriFile: serviceUriFile,
      outputPath: outputPath,
      orderLabel: orderLabel,
      operationCount: operationCount,
      warmupOperationCount: warmupOperationCount,
      classLimit: classLimit,
    );
  }

  static int _parsePositiveInt(String argument, String prefix) {
    final value = int.tryParse(argument.substring(prefix.length));
    if (value == null || value <= 0) {
      throw FormatException('$prefix requires a positive integer.');
    }

    return value;
  }
}
