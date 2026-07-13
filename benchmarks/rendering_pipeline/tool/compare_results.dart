// This file is a command-line entry point.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:rendering_pipeline/src/result_comparison.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln(
      'Usage: fvm dart run tool/compare_results.dart <result.json> [...]',
    );
    exitCode = 64;
    return;
  }

  final documents = <Map<String, Object?>>[];
  for (final path in arguments) {
    final contents = await File(path).readAsString();
    documents.add(_decodeResult(contents, path));
  }

  const encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(compareBenchmarkDocuments(documents)));
}

Map<String, Object?> _decodeResult(String contents, String path) {
  Object? decoded;
  try {
    decoded = jsonDecode(contents);
  } on FormatException {
    const marker = 'BENCHMARK_RESULT_JSON:';
    final markerIndex = contents.lastIndexOf(marker);
    if (markerIndex == -1) {
      throw FormatException('No JSON or $marker marker found in $path.');
    }
    decoded = jsonDecode(
      contents.substring(markerIndex + marker.length).trim(),
    );
  }

  if (decoded is! Map || decoded['results'] is! List) {
    throw FormatException('$path is not a rendering-pipeline result document.');
  }

  return Map<String, Object?>.from(decoded);
}
