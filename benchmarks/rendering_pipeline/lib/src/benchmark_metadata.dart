import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

const int benchmarkSchemaVersion = 1;
const String benchmarkName = 'mix_rendering_pipeline';

Map<String, Object?> createBenchmarkMetadata({
  required String kind,
  required String runOrder,
  ui.FlutterView? view,
}) {
  final display = view?.display;

  return <String, Object?>{
    'benchmark': benchmarkName,
    'kind': kind,
    'timestamp_utc': DateTime.now().toUtc().toIso8601String(),
    'run_id': const String.fromEnvironment('RUN_ID', defaultValue: 'unlabeled'),
    'run_order': runOrder,
    'mix_sha': const String.fromEnvironment('MIX_SHA', defaultValue: 'unknown'),
    'implementation_label': const String.fromEnvironment(
      'IMPLEMENTATION_LABEL',
      defaultValue: 'working-tree',
    ),
    'flutter_revision': const String.fromEnvironment(
      'FLUTTER_REVISION',
      defaultValue: 'unknown',
    ),
    'device_name': const String.fromEnvironment(
      'DEVICE_NAME',
      defaultValue: 'unknown',
    ),
    'operating_system': Platform.operatingSystem,
    'operating_system_version': Platform.operatingSystemVersion,
    'dart_version': Platform.version,
    'build_mode': kReleaseMode
        ? 'release'
        : kProfileMode
        ? 'profile'
        : 'debug',
    'physical_width_px': view?.physicalSize.width,
    'physical_height_px': view?.physicalSize.height,
    'device_pixel_ratio': view?.devicePixelRatio,
    'refresh_rate_hz': display?.refreshRate,
    'benchmark_viewport_logical_width': 1200,
    'benchmark_viewport_logical_height': 800,
    'text_scale': 1,
    'brightness': 'light',
    'locale': 'en_US',
    'animation_duration_ms': 150,
    'animation_curve': 'easeInOut',
  };
}
