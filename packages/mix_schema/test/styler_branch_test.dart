import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/schema/styler_branch.dart';

final class _A {
  const _A(this.value);

  final String value;
}

final class _B {
  const _B();
}

void main() {
  test('widens a typed branch without changing its boundary shape', () {
    final branch = widenStylerBranch<_A>(
      Ack.object({'value': Ack.string()}).codec<_A>(
        decode: (data) => _A(data['value']! as String),
        encode: (value) => {'value': value.value},
      ),
    );

    expect(branch.safeParse({'value': 'x'}).getOrNull(), isA<_A>());
    expect(branch.safeEncode(const _A('x')).getOrThrow(), {'value': 'x'});
  });

  test('wrong runtime subtype fails through a typed exception', () {
    final branch = widenStylerBranch<_A>(
      Ack.object({'value': Ack.string()}).codec<_A>(
        decode: (data) => _A(data['value']! as String),
        encode: (value) => {'value': value.value},
      ),
      debugName: '_A',
    );

    final result = branch.safeEncode(const _B());

    expect(result.isFail, isTrue);
    final error = result.getError();
    expect(error.cause, isA<UnsupportedEncodeValueError>());
  });
}
