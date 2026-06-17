import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart';

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

  test('R-12 producer discriminator enums match schema codec branches', () {
    final modifierSource = File(
      'lib/src/schema/modifier_codec.dart',
    ).readAsStringSync();
    final modifierBranches = RegExp(
      r"'([^']+)':\s*_[A-Za-z0-9]+ModifierCodec\(",
    ).allMatches(modifierSource).map((match) => match.group(1)!).toSet();

    expect(
      SchemaModifier.values.map((value) => value.wireValue).toSet(),
      modifierBranches,
    );

    final variantSource = File(
      'lib/src/schema/variant_codec.dart',
    ).readAsStringSync();
    final variantCodecStart = variantSource.indexOf(
      'Ack.discriminated<VariantStyle<BoxSpec>>',
    );
    final variantCodecEnd = variantSource.indexOf(
      'AckSchema<JsonMap, VariantStyle<BoxSpec>> _namedVariantCodec',
    );
    final variantCodecBlock = variantSource.substring(
      variantCodecStart,
      variantCodecEnd,
    );
    final variantBranches = RegExp(
      r"'([^']+)':",
    ).allMatches(variantCodecBlock).map((match) => match.group(1)!).toSet();

    expect(
      SchemaVariant.values.map((value) => value.wireValue).toSet(),
      variantBranches,
    );
  });
}

Iterable<File> _dartFiles(Directory directory) {
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}
