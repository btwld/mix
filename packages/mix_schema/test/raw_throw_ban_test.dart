import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against regressions of PR1 C2: encode-time failures under
/// `lib/src/schema/**` must throw [UnsupportedEncodeValueError] so the schema
/// error mapper can route them to `unsupported_encode_value` and carry the
/// structured offending sub-value. Raw `UnsupportedError` throws strip both.
///
/// Scoped to `UnsupportedError` only. `StateError` remains acceptable for
/// genuine programming invariants (impossible-state guards) that never fire
/// against user data.
void main() {
  test('schema files do not throw raw UnsupportedError', () {
    final root = Directory('lib/src/schema');
    expect(
      root.existsSync(),
      isTrue,
      reason: 'schema directory not found at ${root.path}',
    );

    final offenders = <String>[];
    final pattern = RegExp(r'\bthrow\s+UnsupportedError\b');

    for (final entity in root.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final content = entity.readAsStringSync();
      if (pattern.hasMatch(content)) offenders.add(entity.path);
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'Use UnsupportedEncodeValueError so the schema error mapper can '
          'surface the failure as unsupported_encode_value. '
          'Offenders:\n${offenders.join('\n')}',
    );
  });
}
