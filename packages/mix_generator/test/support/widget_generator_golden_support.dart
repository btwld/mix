import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'widget_generator_test_support.dart';

const mixWidgetGoldenUpdateCommand = 'melos run goldens:mix_widget:update';

final class MixWidgetGoldenCase {
  final String name;
  final File expectedFile;
  final Map<String, String> packageSources;

  const MixWidgetGoldenCase({
    required this.name,
    required this.expectedFile,
    required this.packageSources,
  });

  String get expectedDisplayPath =>
      p.relative(expectedFile.path, from: Directory.current.path);

  String readExpectedOutput() {
    if (!expectedFile.existsSync()) {
      throw StateError(
        'Missing golden snapshot for `$name` at `$expectedDisplayPath`. '
        'Run `$mixWidgetGoldenUpdateCommand` to create it.',
      );
    }

    return normalizeGoldenText(expectedFile.readAsStringSync());
  }

  String? readExpectedOutputIfExists() {
    if (!expectedFile.existsSync()) {
      return null;
    }

    return normalizeGoldenText(expectedFile.readAsStringSync());
  }

  void writeExpectedOutput(String output) {
    expectedFile.writeAsStringSync(normalizeGoldenText(output));
  }
}

List<MixWidgetGoldenCase> loadMixWidgetGoldenCases() {
  final rootDirectory = Directory(_mixWidgetGoldenRootPath);
  if (!rootDirectory.existsSync()) {
    throw StateError(
      'MixWidget golden root not found at `${rootDirectory.path}`.',
    );
  }

  final caseDirectories =
      rootDirectory.listSync().whereType<Directory>().toList()..sort(
        (left, right) =>
            p.basename(left.path).compareTo(p.basename(right.path)),
      );

  return caseDirectories.map(_loadMixWidgetGoldenCase).toList();
}

Future<String> generateMixWidgetGoldenOutput(
  MixWidgetGoldenCase goldenCase, {
  void Function(LogRecord log)? onLog,
}) {
  return generateMixWidgetOutputFromPackageSources(
    mixWidgetBaseSourcesFromPackageSources(goldenCase.packageSources),
    onLog: onLog,
  );
}

MixWidgetGoldenCase _loadMixWidgetGoldenCase(Directory caseDirectory) {
  final files = caseDirectory.listSync().whereType<File>().toList()
    ..sort(
      (left, right) => p.basename(left.path).compareTo(p.basename(right.path)),
    );

  final inputFile = File(p.join(caseDirectory.path, 'input.dart'));
  if (!inputFile.existsSync()) {
    throw StateError(
      'MixWidget golden case `${p.basename(caseDirectory.path)}` is missing `input.dart`.',
    );
  }

  final expectedFile = File(p.join(caseDirectory.path, 'expected.g.dart'));
  final packageSources = <String, String>{};

  for (final file in files) {
    final basename = p.basename(file.path);
    if (p.extension(file.path) != '.dart' || basename == 'expected.g.dart') {
      continue;
    }

    packageSources['mix_generator|lib/$basename'] = normalizeGoldenText(
      file.readAsStringSync(),
    );
  }

  if (!packageSources.containsKey(mixWidgetInputAssetId)) {
    throw StateError(
      'MixWidget golden case `${p.basename(caseDirectory.path)}` did not map `input.dart` to `$mixWidgetInputAssetId`.',
    );
  }

  return MixWidgetGoldenCase(
    name: p.basename(caseDirectory.path),
    expectedFile: expectedFile,
    packageSources: packageSources,
  );
}

String get _mixWidgetGoldenRootPath =>
    p.join(Directory.current.path, 'test', 'goldens', 'mix_widget');
