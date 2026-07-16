import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_figma/src/cli/pull_command.dart';
import 'package:mix_figma/src/dtcg/dtcg_to_theme.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  late Directory temp;

  setUp(() => temp = Directory.systemTemp.createTempSync('mix_figma_pull'));
  tearDown(() => temp.deleteSync(recursive: true));

  String write(String name, Object? json) {
    final file = File('${temp.path}${Platform.pathSeparator}$name')
      ..writeAsStringSync(jsonEncode(json));

    return file.path;
  }

  test('converts a directory of per-mode files to theme documents', () {
    write('light.json', {
      'color': {
        r'$type': 'color',
        'bg': {r'$value': '#FFFFFF'},
      },
    });
    write('dark.json', {
      'color': {
        r'$type': 'color',
        'bg': {r'$value': '#000000'},
      },
    });
    final outDir = '${temp.path}${Platform.pathSeparator}out';

    final result = const PullCommand().run(
      inputs: [temp.path],
      outputDir: outDir,
    );

    expect(result.ok, isTrue);
    expect(result.files, hasLength(2));

    final light = _decode('$outDir${Platform.pathSeparator}light.theme.json');
    final dark = _decode('$outDir${Platform.pathSeparator}dark.theme.json');
    expect(light.tokens[const ColorToken('color.bg')], const Color(0xFFFFFFFF));
    expect(dark.tokens[const ColorToken('color.bg')], const Color(0xFF000000));
  });

  test('honors group overrides and rem ratio from options', () {
    final input = write('tokens.json', {
      'radius': {
        r'$type': 'dimension',
        'card': {
          r'$value': {'value': 0.75, 'unit': 'rem'},
        },
      },
    });
    final outDir = '${temp.path}${Platform.pathSeparator}out';

    final result = PullCommand(
      options: const DtcgConversionOptions(
        groupOverrides: {'radius': 'radii'},
        remPixelRatio: 16,
      ),
    ).run(inputs: [input], outputDir: outDir);

    expect(result.ok, isTrue);
    final theme = _decode('$outDir${Platform.pathSeparator}tokens.theme.json');
    expect(
      theme.tokens[const RadiusToken('radius.card')],
      const Radius.circular(12),
    );
  });

  test('surfaces conversion diagnostics without failing valid output', () {
    final input = write('tokens.json', {
      'weight': {
        r'$type': 'fontWeight',
        'heading': {r'$value': 620},
      },
    });
    final outDir = '${temp.path}${Platform.pathSeparator}out';

    final result = const PullCommand().run(inputs: [input], outputDir: outDir);

    expect(result.ok, isTrue);
    expect(
      result.files.single.diagnostics.map((d) => d.message).single,
      contains('snapped to w600'),
    );
  });

  test('does not write output for a non-object document', () {
    final input = write('bad.json', [1, 2, 3]);
    final outDir = '${temp.path}${Platform.pathSeparator}out';

    final result = const PullCommand().run(inputs: [input], outputDir: outDir);

    expect(result.ok, isFalse);
    expect(result.files.single.errors, isNotEmpty);
    expect(Directory(outDir).existsSync(), isFalse);
  });
}

MixProtocolTheme _decode(String path) {
  final document = jsonDecode(File(path).readAsStringSync()) as JsonMap;

  return switch (mixProtocol.decodeTheme(document)) {
    MixProtocolSuccess<MixProtocolTheme>(:final value) => value,
    MixProtocolFailure<MixProtocolTheme>(:final errors) => fail('$errors'),
  };
}
