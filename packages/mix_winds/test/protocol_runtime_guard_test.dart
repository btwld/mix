import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('production source does not own the Mix Protocol wire format', () {
    final runtimeFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.contains('/.mix_winds_registry_check_'))
        .toList(growable: false);
    final forbiddenOwnership = <({String label, Pattern pattern})>[
      (
        label: 'a mix_protocol package import',
        pattern: RegExp(r'''package:mix_protocol(?:/|['"])'''),
      ),
      (
        label: 'a Mix Protocol API identifier',
        pattern: RegExp(r'\b(?:mixProtocol|MixProtocol[A-Za-z0-9_]*)\b'),
      ),
      (label: r'the $token wire key', pattern: r'$token'),
      (label: r'the $merge wire key', pattern: r'$merge'),
      (
        label: 'the root version wire key',
        pattern: RegExp(r'''['"]v['"]\s*:'''),
      ),
      (
        label: 'a raw type discriminator',
        pattern: RegExp(r'''['"]type['"]\s*:'''),
      ),
    ];

    expect(runtimeFiles, isNotEmpty);

    for (final file in runtimeFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in forbiddenOwnership) {
        expect(
          source,
          isNot(contains(forbidden.pattern)),
          reason: '${file.path} contains ${forbidden.label}',
        );
      }
    }
  });

  test('mix_protocol remains a consumer or development dependency', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final dependencies = RegExp(
      r'^dependencies:\s*$([\s\S]*?)^dev_dependencies:\s*$',
      multiLine: true,
    ).firstMatch(pubspec)?.group(1);

    expect(dependencies, isNotNull, reason: 'dependencies section not found');
    expect(
      dependencies,
      isNot(matches(RegExp(r'^\s+mix_protocol:', multiLine: true))),
      reason: 'mix_winds must not acquire a runtime protocol dependency',
    );
  });

  test('README keeps protocol encoding at the consumer boundary', () {
    final readme = File('README.md').readAsStringSync();

    expect(readme, contains('TwParser().compileBox('));
    expect(readme, contains('mixProtocol.encodeStyle(result.styler)'));
    expect(
      readme,
      contains(RegExp(r'does not own or\s+depend on the Mix wire format')),
    );
  });
}
