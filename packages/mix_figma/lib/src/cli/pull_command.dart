import 'dart:convert';
import 'dart:io';

import '../diagnostics.dart';
import '../dtcg/dtcg_to_theme.dart';

/// Outcome of a single-file conversion, for reporting and testing.
final class PullFileResult {
  const PullFileResult({
    required this.source,
    required this.output,
    required this.diagnostics,
    required this.errors,
  });

  final String source;
  final String output;
  final List<MixFigmaDiagnostic> diagnostics;

  /// File-level failures (unreadable file, non-object JSON). Non-empty means
  /// no document was written for this source.
  final List<String> errors;

  bool get ok => errors.isEmpty;
}

/// Aggregate result of a `pull` run.
final class PullResult {
  const PullResult({required this.files});

  final List<PullFileResult> files;

  bool get ok => files.every((file) => file.ok);
}

/// Converts DTCG token files to `mix_protocol` theme documents.
///
/// Figma exports one DTCG file per variable mode; a directory of them becomes
/// a directory of `<name>.theme.json` documents (one per mode) that a Flutter
/// app layers or swaps at runtime with `MixScope`.
///
/// Pure Dart by design: the conversion never needs Flutter, so the CLI runs
/// under a plain `dart run`. The produced documents are validated against the
/// real `mixProtocol.decodeTheme` codec in the test suite, which runs under
/// `flutter test` where `dart:ui` is available.
final class PullCommand {
  const PullCommand({
    DtcgConversionOptions options = const DtcgConversionOptions(),
  }) : _options = options;

  final DtcgConversionOptions _options;

  /// Converts every `*.json` file under [inputs] (files or directories) and
  /// writes `<name>.theme.json` documents to [outputDir].
  PullResult run({
    required List<String> inputs,
    required String outputDir,
    bool write = true,
  }) {
    const encoder = JsonEncoder.withIndent('  ');
    final results = <PullFileResult>[];

    for (final source in _expandInputs(inputs)) {
      final Object? decoded;
      try {
        decoded = jsonDecode(File(source).readAsStringSync());
      } on FormatException catch (error) {
        results.add(_failure(source, 'invalid JSON: ${error.message}'));
        continue;
      } on FileSystemException catch (error) {
        results.add(_failure(source, 'cannot read file: ${error.message}'));
        continue;
      }

      if (decoded is! Map<String, Object?>) {
        results.add(
          _failure(source, 'top-level DTCG value must be a JSON object'),
        );
        continue;
      }

      final conversion = dtcgToThemeDocument(decoded, options: _options);
      final output = _outputPath(source, outputDir);
      if (write) {
        File(output)
          ..createSync(recursive: true)
          ..writeAsStringSync('${encoder.convert(conversion.themeDocument)}\n');
      }

      results.add(
        PullFileResult(
          source: source,
          output: output,
          diagnostics: conversion.diagnostics,
          errors: const [],
        ),
      );
    }

    return PullResult(files: results);
  }

  PullFileResult _failure(String source, String error) {
    return PullFileResult(
      source: source,
      output: '',
      diagnostics: const [],
      errors: [error],
    );
  }

  Iterable<String> _expandInputs(List<String> inputs) sync* {
    for (final input in inputs) {
      final type = FileSystemEntity.typeSync(input);
      if (type == FileSystemEntityType.directory) {
        final entries =
            Directory(input)
                .listSync()
                .whereType<File>()
                .where((file) => file.path.endsWith('.json'))
                .map((file) => file.path)
                .toList()
              ..sort();
        yield* entries;
      } else if (type == FileSystemEntityType.file) {
        yield input;
      } else {
        throw FileSystemException('input not found', input);
      }
    }
  }

  String _outputPath(String source, String outputDir) {
    final base = source.split(Platform.pathSeparator).last;
    final stem = base
        .replaceAll(RegExp(r'\.tokens\.json$'), '')
        .replaceAll(RegExp(r'\.json$'), '');

    return '$outputDir${Platform.pathSeparator}$stem.theme.json';
  }
}
