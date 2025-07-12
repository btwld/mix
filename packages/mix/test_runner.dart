import 'dart:io';

void main() async {
  // Try to run tests and capture output
  final result = await Process.run('flutter', ['test', '--verbose'], workingDirectory: '.');
  
  print('Exit code: ${result.exitCode}');
  print('STDOUT:');
  print(result.stdout);
  print('STDERR:');
  print(result.stderr);
}