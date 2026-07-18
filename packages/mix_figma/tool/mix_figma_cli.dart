import 'dart:convert';
import 'dart:io';

import 'package:mix_figma/src/core/codegen/token_source_generator.dart';
import 'package:mix_figma/src/core/dtcg/dtcg_parser.dart';
import 'package:mix_figma/src/core/json_map.dart';
import 'package:mix_figma/src/core/protocol_json/figma_style_payloads.dart';
import 'package:mix_figma/src/core/protocol_json/figma_variable_payload.dart';
import 'package:mix_figma/src/core/protocol_json/theme_from_dtcg.dart';

import 'bridge_server.dart';

Future<void> main(List<String> arguments) async {
  try {
    if (arguments.isEmpty) throw const FormatException(_usage);
    final command = arguments.first;
    final options = _Options(arguments.skip(1).toList());
    switch (command) {
      case 'pull':
        _pull(options);
      case 'push':
        _push(options);
      case 'check':
        await _check(options);
      case 'serve':
        await _serve(options);
      default:
        throw FormatException('Unknown command "$command".\n$_usage');
    }
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
  }
}

void _pull(_Options options) {
  if (options.single('--from') != 'dtcg') {
    throw const FormatException('pull currently requires --from dtcg.');
  }
  final inputs = options.all('--input');
  if (inputs.isEmpty) {
    throw const FormatException('pull requires --input mode=path.');
  }
  final outputDirectory = Directory(
    options.single('--output-dir') ?? '../../design/tokens',
  )..createSync(recursive: true);
  final themes = <String, JsonMap>{};
  for (final input in inputs) {
    final (mode, path) = _modeAndPath(input);
    final result = buildProtocolThemeJsonFromDtcg(
      parseDtcgDocument(_readJson(path)),
    );
    if (result.hasErrors) {
      throw FormatException(
        jsonEncode(result.diagnostics.map((item) => item.toJson()).toList()),
      );
    }
    themes[mode] = result.value;
    File(
      '${outputDirectory.path}/$mode.theme.json',
    ).writeAsStringSync(_json(result.value));
  }
  final tokensOutput = options.single('--tokens-output');
  if (tokensOutput != null) {
    final file = File(tokensOutput);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(generateTokensSource(themes));
  }
}

void _push(_Options options) {
  final themes = _readThemes(
    options.single('--input-dir') ?? '../../design/tokens',
  );
  final modes = themes.keys.toList()..sort();
  final variables = buildFigmaVariableWritePayload(themes);
  final styles = buildFigmaStylePayloads(themes[modes.first]!);
  final result = {
    'variables': variables.value,
    'styles': styles.value,
    'diagnostics': [
      ...variables.diagnostics.map((item) => item.toJson()),
      ...styles.diagnostics.map((item) => item.toJson()),
    ],
  };
  final output = options.single('--output');
  if (output == null) {
    stdout.write(_json(result));
  } else {
    final file = File(output);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(_json(result));
  }
}

Future<void> _check(_Options options) async {
  final expected = options.required('--expected');
  final actual = options.required('--actual');
  final kind = options.single('--kind') ?? 'theme';
  if (kind != 'theme' && kind != 'style') {
    throw const FormatException('--kind must be theme or style.');
  }
  final result = await Process.run('flutter', [
    'test',
    '--no-pub',
    'tool/protocol_check_harness_test.dart',
    '--dart-define=MIX_FIGMA_EXPECTED=${File(expected).absolute.path}',
    '--dart-define=MIX_FIGMA_ACTUAL=${File(actual).absolute.path}',
    '--dart-define=MIX_FIGMA_KIND=$kind',
  ]);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) exitCode = result.exitCode;
}

Future<void> _serve(_Options options) async {
  final server = await MixFigmaBridgeServer(
    host: options.single('--host') ?? '127.0.0.1',
    port: int.parse(options.single('--port') ?? '8787'),
    themeDirectory: options.single('--theme-dir') ?? '../../design/tokens',
    componentDirectory:
        options.single('--component-dir') ?? '../../design/components',
    validateByDefault: options.flag('--validate'),
  ).start();
  stdout.writeln(
    'Mix Figma bridge listening on http://${server.address.host}:${server.port}',
  );
  await ProcessSignal.sigint.watch().first;
  await server.close(force: true);
}

Map<String, JsonMap> _readThemes(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    throw FormatException('Missing theme directory: $path');
  }
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.theme.json'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  if (files.isEmpty) throw FormatException('No theme documents in $path.');

  return {
    for (final file in files)
      file.uri.pathSegments.last.replaceFirst('.theme.json', ''): _readJson(
        file.path,
      ),
  };
}

(String, String) _modeAndPath(String value) {
  final separator = value.indexOf('=');
  if (separator <= 0 || separator == value.length - 1) {
    throw FormatException('--input must use mode=path, got "$value".');
  }

  return (value.substring(0, separator), value.substring(separator + 1));
}

JsonMap _readJson(String path) {
  final value = jsonDecode(File(path).readAsStringSync());
  if (value is! Map) throw FormatException('Expected a JSON object in $path.');

  return value.cast();
}

String _json(Object value) =>
    '${const JsonEncoder.withIndent('  ').convert(value)}\n';

final class _Options {
  final List<String> arguments;
  const _Options(this.arguments);
  bool flag(String name) => arguments.contains(name);
  String required(String name) =>
      single(name) ?? (throw FormatException('Missing $name.'));
  String? single(String name) => all(name).lastOrNull;
  List<String> all(String name) {
    final values = <String>[];
    for (var index = 0; index < arguments.length; index += 1) {
      if (arguments[index] != name) continue;
      if (index + 1 >= arguments.length ||
          arguments[index + 1].startsWith('--')) {
        throw FormatException('Missing value for $name.');
      }
      values.add(arguments[index + 1]);
    }

    return values;
  }
}

const _usage = '''Usage: mix_figma_cli.dart <pull|push|check|serve>
  pull --from dtcg --input mode=path [--input mode=path] --output-dir path
  push --input-dir path [--output path]
  check --kind theme|style --expected path --actual path
  serve [--host 127.0.0.1] [--port 8787] [--validate]''';
