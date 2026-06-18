import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('R-2 no discriminator injection helpers or sentinel prefixes exist', () {
    final libText = _dartFiles(
      Directory('lib'),
    ).map((file) => file.readAsStringSync()).join('\n');

    final injectionHelperName = ['buildDiscriminator', 'InjectingCodec'].join();
    final sentinelPrefixName = ['kUnsupportedBranch', 'SubtypePrefix'].join();

    expect(libText, isNot(contains(injectionHelperName)));
    expect(libText, isNot(contains(sentinelPrefixName)));
  });

  test('R-9 mix_tailwinds imports only public mix_schema libraries', () {
    final tailwindsLib = Directory('../mix_tailwinds/lib');
    if (!tailwindsLib.existsSync()) return;

    for (final file in _dartFiles(tailwindsLib)) {
      expect(
        file.readAsStringSync(),
        isNot(contains(['package:mix_schema', 'src'].join('/'))),
        reason: file.path,
      );
    }
  });

  test('R-12 encode.dart does not export schema internals', () {
    final encodeFile = File('lib/encode.dart');

    expect(encodeFile.readAsStringSync(), isNot(contains("export 'src/")));
  });
}

Iterable<File> _dartFiles(Directory directory) {
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}
