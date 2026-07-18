import 'dart:convert';
import 'dart:io';

import 'package:mix_figma/src/core/codegen/token_source_generator.dart';
import 'package:mix_figma/src/core/json_map.dart';

void main(List<String> arguments) {
  try {
    final options = _Options(arguments);
    final output =
        options.single('--output') ?? '../../design/tokens/tokens.g.dart';
    final inputs = options.all('--input');
    final themes = inputs.isEmpty
        ? _themesFromDirectory(
            options.single('--input-dir') ?? '../../design/tokens',
          )
        : {
            for (final input in inputs)
              _modeAndPath(input).$1: _readJson(_modeAndPath(input).$2),
          };
    final source = generateTokensSource(themes);
    final outputFile = File(output);
    if (options.flag('--check')) {
      if (!outputFile.existsSync() || outputFile.readAsStringSync() != source) {
        stderr.writeln('Generated token source is stale: $output');
        exitCode = 1;
      }

      return;
    }
    outputFile.parent.createSync(recursive: true);
    outputFile.writeAsStringSync(source);
    stdout.writeln('Wrote $output');
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
  }
}

Map<String, JsonMap> _themesFromDirectory(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    throw FormatException('Theme directory does not exist: $path');
  }
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.theme.json'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  if (files.isEmpty) throw FormatException('No *.theme.json files in $path.');

  return {
    for (final file in files)
      _modeFromThemePath(file.path): _readJson(file.path),
  };
}

(String, String) _modeAndPath(String input) {
  final separator = input.indexOf('=');
  if (separator <= 0 || separator == input.length - 1) {
    throw FormatException('--input must use mode=path, got "$input".');
  }

  return (input.substring(0, separator), input.substring(separator + 1));
}

String _modeFromThemePath(String path) =>
    File(path).uri.pathSegments.last.substring(
      0,
      File(path).uri.pathSegments.last.length - '.theme.json'.length,
    );

JsonMap _readJson(String path) {
  final value = jsonDecode(File(path).readAsStringSync());
  if (value is! Map) throw FormatException('Expected a JSON object in $path.');

  return value.cast();
}

final class _Options {
  final List<String> _arguments;

  const _Options(List<String> arguments) : _arguments = arguments;

  bool flag(String name) => _arguments.contains(name);

  String? single(String name) => all(name).lastOrNull;

  List<String> all(String name) {
    final values = <String>[];
    for (var index = 0; index < _arguments.length; index += 1) {
      if (_arguments[index] != name) continue;
      if (index + 1 >= _arguments.length ||
          _arguments[index + 1].startsWith('--')) {
        throw FormatException('Missing value for $name.');
      }
      values.add(_arguments[index + 1]);
    }

    return values;
  }
}
