// Example: load a sugar-form Mix JSON document, run the full pipeline,
// and print the canonical form.
//
// Run with:
//   dart run example/main.dart

// ignore_for_file: avoid_print

import 'dart:convert' show JsonEncoder;
import 'package:mix_schema/mix_schema.dart';

void main() {
  // In a real CLI, load the asset directory once at startup.
  final assets = MixSchemaAssets.fromFiles('lib/src/assets');
  final parser = Parser(assets);
  const serializer = Serializer();

  // Sugar input — bare scalar at a Value position, EdgeInsets `all`
  // shorthand, Alignment preset string.
  final sugar = <String, Object?>{
    'schema': '1.0.0',
    'root': {
      'widget': 'Box',
      'style': {
        'spec': 'box',
        'props': {
          'padding': {'all': 16},
          'alignment': 'center',
          'decoration': {
            'color': '#fff',
            'borderRadius': {'all': 8},
          },
        },
      },
    },
  };

  final result = parser.parseValidating(sugar);
  if (!result.isValid) {
    print('Validation failed:');
    for (final err in result.validation.errors) {
      print('  $err');
    }
    return;
  }

  final canonical = serializer.toMap(result.document!);
  print(const JsonEncoder.withIndent('  ').convert(canonical));
}
