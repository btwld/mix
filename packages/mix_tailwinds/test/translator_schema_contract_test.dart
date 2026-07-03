import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

void main() {
  test('translator styler outputs encode and validate through mix_schema', () {
    final parser = TwParser();
    final cases = <Object>[
      parser.parseBox(
        'bg-blue-500 p-4 rounded-md shadow-md '
        'hover:bg-red-500 md:hover:scale-105',
      ),
      parser.parseBox('bg-gradient-to-r from-red-500 via-white to-blue-500'),
      parser.parseBox('bg-gradient-to-br from-red-500 via-white to-blue-500'),
      parser.parseFlex(
        'flex flex-col items-center justify-between gap-4 p-4 '
        'border border-gray-200 text-shadow-md',
      ),
      parser.parseText(
        'text-lg font-bold text-center leading-tight tracking-wide '
        'uppercase text-shadow-sm',
      ),
      parser.parseIcon('w-6 text-blue-700 opacity-50'),
    ];

    for (final style in cases) {
      final encoded = switch (builtInMixSchemaContract.encode(style)) {
        MixSchemaEncodeSuccess(:final value) => value,
        MixSchemaEncodeFailure(:final errors) => fail('$errors'),
      };

      expect(
        builtInMixSchemaContract.validate(encoded),
        isA<MixSchemaValidationSuccess>(),
        reason: style.runtimeType.toString(),
      );
    }
  });
}
