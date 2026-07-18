import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1 ||
      (arguments.single != '--check' && arguments.single != '--write')) {
    stderr.writeln('Usage: dart run tool/export_schemas.dart --check|--write');
    exitCode = 64;
    return;
  }

  final mode = arguments.single.substring(2);
  final result = Process.runSync(_flutterExecutable(), [
    'test',
    '--no-pub',
    '--reporter=compact',
    '--dart-define=MIX_PROTOCOL_SCHEMA_EXPORT_MODE=$mode',
    'tool/schema_export_harness_test.dart',
  ]);

  stdout.write(result.stdout);
  stderr.write(result.stderr);
  exitCode = result.exitCode;
}

String _flutterExecutable() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null || flutterRoot.isEmpty) return 'flutter';

  return '$flutterRoot/bin/flutter';
}
