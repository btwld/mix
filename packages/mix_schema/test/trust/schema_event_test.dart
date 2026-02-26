import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('SchemaEvent', () {
    test('TapEvent stores nodeId and actionId', () {
      final event = TapEvent(nodeId: 'btn1', actionId: 'submit');
      expect(event.nodeId, 'btn1');
      expect(event.actionId, 'submit');
      expect(event.timestamp, isA<DateTime>());
    });

    test('TapEvent without actionId', () {
      final event = TapEvent(nodeId: 'btn1');
      expect(event.actionId, isNull);
    });

    test('ChangeEvent stores field and value', () {
      final event = ChangeEvent(
        nodeId: 'input1',
        field: 'name',
        value: 'John',
      );
      expect(event.nodeId, 'input1');
      expect(event.field, 'name');
      expect(event.value, 'John');
    });

    test('all events have toString', () {
      final events = <SchemaEvent>[
        TapEvent(nodeId: 'a'),
        ChangeEvent(nodeId: 'b', field: 'f'),
      ];

      for (final event in events) {
        expect(event.toString(), isNotEmpty);
      }
    });
  });

}
