import 'dart:io';

import 'package:mix_figma/mix_figma.dart';

const _usage = '''
mix_figma — Figma/DTCG design-token bridge for Mix

Usage:
  dart run mix_figma pull --out <dir> [options] <input>...

Commands:
  pull    Convert DTCG token files (Figma variable export, Tokens Studio,
          Style Dictionary) into mix_protocol theme documents.

pull options:
  --out <dir>            Output directory for <name>.theme.json files. (required)
  --group <prefix=grp>   Route tokens under <prefix> to theme group <grp>
                         (e.g. --group radius=radii). Repeatable.
  --rem-pixel-ratio <n>  Pixels per rem for rem-unit dimensions.
  -h, --help             Show this help.

Inputs may be files or directories (directories convert every *.json inside).
Each Figma variable mode is one input file and becomes one theme document.
''';

Future<int> main(List<String> args) async {
  if (args.isEmpty || args.first == '-h' || args.first == '--help') {
    stdout.writeln(_usage);

    return args.isEmpty ? 64 : 0;
  }

  final command = args.first;
  final rest = args.sublist(1);

  switch (command) {
    case 'pull':
      return _runPull(rest);
    default:
      stderr.writeln('Unknown command: $command\n');
      stderr.writeln(_usage);

      return 64;
  }
}

int _runPull(List<String> args) {
  String? outputDir;
  final groupOverrides = <String, String>{};
  double? remPixelRatio;
  final inputs = <String>[];

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    switch (arg) {
      case '-h' || '--help':
        stdout.writeln(_usage);

        return 0;
      case '--out':
        outputDir = _next(args, ++i, '--out');
      case '--group':
        final pair = _next(args, ++i, '--group');
        final eq = pair.indexOf('=');
        if (eq <= 0) {
          stderr.writeln('Invalid --group "$pair"; expected prefix=group');

          return 64;
        }
        groupOverrides[pair.substring(0, eq)] = pair.substring(eq + 1);
      case '--rem-pixel-ratio':
        remPixelRatio = double.tryParse(_next(args, ++i, '--rem-pixel-ratio'));
        if (remPixelRatio == null) {
          stderr.writeln('Invalid --rem-pixel-ratio; expected a number');

          return 64;
        }
      default:
        if (arg.startsWith('-')) {
          stderr.writeln('Unknown option: $arg');

          return 64;
        }
        inputs.add(arg);
    }
  }

  if (outputDir == null) {
    stderr.writeln('Missing required --out <dir>\n');
    stderr.writeln(_usage);

    return 64;
  }
  if (inputs.isEmpty) {
    stderr.writeln('No inputs given\n');
    stderr.writeln(_usage);

    return 64;
  }

  final command = PullCommand(
    options: DtcgConversionOptions(
      groupOverrides: groupOverrides,
      remPixelRatio: remPixelRatio,
    ),
  );

  final PullResult result;
  try {
    result = command.run(inputs: inputs, outputDir: outputDir);
  } on FileSystemException catch (error) {
    stderr.writeln('${error.message}: ${error.path}');

    return 66;
  }

  for (final file in result.files) {
    if (file.ok) {
      stdout.writeln('✓ ${file.source} → ${file.output}');
    } else {
      stdout.writeln('✗ ${file.source} (not written)');
      for (final error in file.errors) {
        stdout.writeln('    error: $error');
      }
    }
    for (final diagnostic in file.diagnostics) {
      final marker = diagnostic.severity == MixFigmaSeverity.error
          ? 'error'
          : 'warn';
      stdout.writeln('    $marker ${diagnostic.path}: ${diagnostic.message}');
    }
  }

  final written = result.files.where((file) => file.ok).length;
  stdout.writeln(
    '\n$written/${result.files.length} document(s) written to $outputDir',
  );

  return result.ok ? 0 : 1;
}

String _next(List<String> args, int index, String flag) {
  if (index >= args.length) {
    stderr.writeln('Missing value for $flag');
    exit(64);
  }

  return args[index];
}
