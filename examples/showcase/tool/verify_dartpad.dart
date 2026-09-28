import 'dart:async';
import 'dart:convert';
import 'dart:io';

const _service = 'https://stable.api.dartpad.dev/api/v3';
const _expectedSnippetCount = 30;
const _workerCount = 3;
const _maxAttempts = 3;

Future<void> main() async {
  final client = HttpClient();
  try {
    final version = await _requestJson(client, 'GET', 'version');
    final packages = version['packages']! as List<Object?>;
    final mix = packages.cast<Map<String, Object?>>().singleWhere(
      (package) => package['name'] == 'mix',
    );
    if (mix['supported'] != true) {
      throw StateError('DartPad does not currently support package:mix.');
    }

    stdout.writeln(
      'DartPad stable: Dart ${version['dartVersion']}, '
      'Flutter ${version['flutterVersion']}, Mix ${mix['version']}',
    );

    final files =
        Directory('lib/examples/snacks')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    if (files.length != _expectedSnippetCount) {
      throw StateError(
        'Expected $_expectedSnippetCount snippets, found ${files.length}.',
      );
    }

    var next = 0;
    final failures = <String>[];
    Future<void> worker() async {
      while (next < files.length) {
        final file = files[next++];
        try {
          await _verifySnippet(client, file);
          stdout.writeln('✓ ${file.uri.pathSegments.last}');
        } on Object catch (error) {
          failures.add('${file.path}: $error');
        }
      }
    }

    await Future.wait(List.generate(_workerCount, (_) => worker()));
    if (failures.isNotEmpty) {
      throw StateError('DartPad verification failed:\n${failures.join('\n')}');
    }
    stdout.writeln('All ${files.length} snippets analyze and compile.');
  } finally {
    client.close();
  }
}

Future<void> _verifySnippet(HttpClient client, File file) async {
  final source = await file.readAsString();
  final analyze = await _requestJson(
    client,
    'POST',
    'analyze',
    body: {'source': source},
  );
  final issues = analyze['issues']! as List<Object?>;
  if (issues.isNotEmpty) {
    throw StateError(jsonEncode(issues));
  }

  final imports = (analyze['imports']! as List<Object?>).cast<String>();
  final unsupported = imports.where(
    (import) =>
        !import.startsWith('dart:') &&
        !import.startsWith('package:flutter/') &&
        import != 'package:mix/mix.dart',
  );
  if (unsupported.isNotEmpty) {
    throw StateError('Unsupported imports: ${unsupported.join(', ')}');
  }

  final compilation = await _requestJson(
    client,
    'POST',
    'compileDDC',
    body: {'source': source},
  );
  final result = compilation['result'];
  if (result is! String || result.trim().isEmpty) {
    throw StateError(
      'DartPad returned no compiled output: ${jsonEncode(compilation)}',
    );
  }
}

Future<Map<String, Object?>> _requestJson(
  HttpClient client,
  String method,
  String action, {
  Map<String, Object?>? body,
}) async {
  for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
    final request = await client.openUrl(
      method,
      Uri.parse('$_service/$action'),
    );
    request.headers.contentType = ContentType.json;
    if (body != null) request.write(jsonEncode(body));
    final response = await request.close().timeout(const Duration(seconds: 60));
    final payload = await utf8.decoder.bind(response).join();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (jsonDecode(payload) as Map<Object?, Object?>)
          .cast<String, Object?>();
    }
    if (attempt == _maxAttempts ||
        (response.statusCode != 429 && response.statusCode < 500)) {
      throw HttpException(
        '$action returned HTTP ${response.statusCode}: $payload',
      );
    }
    await Future<void>.delayed(Duration(milliseconds: 300 * attempt));
  }
  throw StateError('Unreachable retry state.');
}
