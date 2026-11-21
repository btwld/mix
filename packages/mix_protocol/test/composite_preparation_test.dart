import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_protocol/src/schema/schema_field.dart';

void main() {
  test('derived fields prepare each source once per encoding operation', () {
    var preparations = 0;
    JsonMap prepare(_Source source) {
      preparations++;
      return {'left': source.value, 'right': source.value + 1};
    }

    final schema = SchemaObject<_Source>(
      fields: [
        derivedField<_Source, int>(
          'first',
          Ack.integer(),
          prepare,
          readWire: 'left',
        ),
        derivedField<_Source, int>(
          'second',
          Ack.integer(),
          prepare,
          readWire: 'right',
        ),
      ],
      build: (data) => _Source(data['first']! as int),
    ).codec();

    expect(schema.encode(const _Source(3)), {'first': 3, 'second': 4});
    expect(preparations, 1);
    expect(schema.encode(const _Source(8)), {'first': 8, 'second': 9});
    expect(preparations, 2);
    expect(schema.encode(const _Source(3)), {'first': 3, 'second': 4});
    expect(preparations, 3);
  });
}

final class _Source {
  final int value;

  const _Source(this.value);
}
