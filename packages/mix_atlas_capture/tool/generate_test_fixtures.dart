import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../test/artifact_fixture.dart';

void main() {
  test('generates committed baseline and changed captures', _generate);
}

Future<void> _generate() async {
  final output = Directory('test/fixtures');
  if (output.existsSync()) output.deleteSync(recursive: true);

  final baseline = ArtifactFixture.create()..addPortableButtonCapture();
  final changed = ArtifactFixture.create();
  changed.addPortableButtonCapture();
  baseline.replaceJson('styles/button/solid-size1/label.mix.json', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {r'$token': 'fortal.accent.9'},
    },
  });
  changed.replaceJson('styles/button/solid-size1/label.mix.json', {
    'v': 1,
    'type': 'text',
    'style': {
      'color': {r'$token': 'fortal.accent.9'},
    },
    'maxLines': 1,
  });

  await _writeFixture(Directory('${output.path}/button_baseline'), baseline);
  await _writeFixture(Directory('${output.path}/button_changed'), changed);
}

Future<void> _writeFixture(Directory directory, ArtifactFixture fixture) async {
  await directory.create(recursive: true);
  final manifest = const JsonEncoder.withIndent('  ').convert(fixture.manifest);
  await File('${directory.path}/capture.json').writeAsString('$manifest\n');
  final entries = fixture.files.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  for (final entry in entries) {
    final file = File('${directory.path}/${entry.key}');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(entry.value, flush: true);
  }
}
