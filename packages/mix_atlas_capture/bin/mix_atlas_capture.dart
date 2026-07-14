import 'dart:convert';
import 'dart:io';

import 'package:mix_atlas_capture/producer.dart';

void main(List<String> arguments) {
  try {
    final options = _CliOptions.parse(arguments);
    final config = _object(
      jsonDecode(File(options.configPath).readAsStringSync()),
      'config',
    );
    _expectKeys(config, {'metadata', 'assets', 'preserve'});
    final metadata = _metadata(_object(config['metadata'], 'metadata'));
    final assets = config['assets'] == null
        ? const <AtlasCaptureAsset>[]
        : _list(config['assets'], 'assets').indexed.map((entry) {
            final value = _object(entry.$2, 'assets/${entry.$1}');
            _expectKeys(value, {'source', 'destination'});

            return AtlasCaptureAsset(
              sourcePath: _string(value['source'], 'source'),
              destinationPath: _string(value['destination'], 'destination'),
            );
          }).toList();
    final preserve = config['preserve'] == null
        ? const <String>{}
        : _list(
            config['preserve'],
            'preserve',
          ).map((value) => _string(value, 'preserve')).toSet();
    final input = AtlasCapturePackageInput(
      sourceDirectory: Directory(options.sourcePath),
      outputDirectory: Directory(options.outputPath),
      metadata: metadata,
      assets: assets,
      preservedPaths: preserve,
    );
    final result = options.check
        ? AtlasCapturePackager.check(input)
        : AtlasCapturePackager.build(input);
    if (!result.isCurrent) {
      stderr.writeln('Atlas capture drift: ${result.driftPaths.join(', ')}');
      exitCode = 1;

      return;
    }
    stdout.writeln(
      '${options.check ? 'Verified' : 'Packaged'} Atlas capture: '
      '${result.fileCount} files, ${result.totalBytes} bytes.',
    );
  } on Object catch (error) {
    stderr.writeln('mix_atlas_capture: $error');
    exitCode = 64;
  }
}

AtlasCapturePackageMetadata _metadata(Map<String, Object?> value) {
  _expectKeys(value, {
    'id',
    'atlasVersion',
    'mixProtocolVersion',
    'mixProtocolFormat',
    'flutterVersion',
    'catalog',
    'themes',
    'components',
    'protocolCoverage',
  });
  final themes = _list(value['themes'], 'themes').indexed.map((entry) {
    final theme = _object(entry.$2, 'themes/${entry.$1}');
    _expectKeys(theme, {'id', 'document'});

    return AtlasCaptureThemeSpec(
      id: _string(theme['id'], 'themes/id'),
      documentPath: _string(theme['document'], 'themes/document'),
    );
  }).toList();
  final components = _list(value['components'], 'components').indexed.map((
    entry,
  ) {
    final component = _object(entry.$2, 'components/${entry.$1}');
    _expectKeys(component, {'id', 'document'});

    return AtlasCaptureComponentSpec(
      id: _string(component['id'], 'components/id'),
      documentPath: _string(component['document'], 'components/document'),
    );
  }).toList();
  final format = value['mixProtocolFormat'];
  if (format is! int) {
    throw const FormatException('mixProtocolFormat must be an integer.');
  }

  return AtlasCapturePackageMetadata(
    id: _string(value['id'], 'id'),
    atlasVersion: _string(value['atlasVersion'], 'atlasVersion'),
    mixProtocolVersion: _string(
      value['mixProtocolVersion'],
      'mixProtocolVersion',
    ),
    mixProtocolFormat: format,
    flutterVersion: _string(value['flutterVersion'], 'flutterVersion'),
    catalogPath: _string(value['catalog'], 'catalog'),
    themes: themes,
    components: components,
    protocolCoveragePath: _string(
      value['protocolCoverage'],
      'protocolCoverage',
    ),
  );
}

final class _CliOptions {
  final String sourcePath;

  final String outputPath;

  final String configPath;
  final bool check;
  const _CliOptions({
    required this.sourcePath,
    required this.outputPath,
    required this.configPath,
    required this.check,
  });

  factory _CliOptions.parse(List<String> arguments) {
    String? source;
    String? output;
    String? config;
    var check = false;
    for (var index = 0; index < arguments.length; index += 1) {
      switch (arguments[index]) {
        case '--source':
          source = _next(arguments, ++index, '--source');
        case '--output':
          output = _next(arguments, ++index, '--output');
        case '--config':
          config = _next(arguments, ++index, '--config');
        case '--check':
          check = true;
        default:
          throw FormatException('Unknown argument: ${arguments[index]}');
      }
    }
    if (source == null || output == null || config == null) {
      throw const FormatException(
        'Usage: dart run mix_atlas_capture --source DIR --output DIR '
        '--config FILE [--check]',
      );
    }

    return _CliOptions(
      sourcePath: source,
      outputPath: output,
      configPath: config,
      check: check,
    );
  }
}

String _next(List<String> arguments, int index, String option) {
  if (index >= arguments.length) {
    throw FormatException('$option requires a value.');
  }

  return arguments[index];
}

Map<String, Object?> _object(Object? value, String path) {
  if (value is! Map<String, Object?>) {
    throw FormatException('$path must be an object.');
  }

  return value;
}

List<Object?> _list(Object? value, String path) {
  if (value is! List<Object?>) throw FormatException('$path must be a list.');

  return value;
}

String _string(Object? value, String path) {
  if (value is! String || value.isEmpty) {
    throw FormatException('$path must be a non-empty string.');
  }

  return value;
}

void _expectKeys(Map<String, Object?> value, Set<String> allowed) {
  final unknown = value.keys.toSet().difference(allowed);
  if (unknown.isNotEmpty) {
    throw FormatException('Unknown config fields: ${unknown.join(', ')}');
  }
}
