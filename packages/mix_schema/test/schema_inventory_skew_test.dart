import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/schema/schema_field.dart';
import 'package:mix_schema/mix_schema.dart';

final class _InventoryOwner {
  const _InventoryOwner(this.known);

  final String known;
}

void main() {
  test('SchemaObject encode fails loudly when owner inventory drifts', () {
    final schema = SchemaObject<_InventoryOwner>(
      inventoryOwner: '_InventoryOwner',
      ownerFieldInventory: const {'known', 'future'},
      fields: [
        directField<_InventoryOwner, String>(
          'known',
          Ack.string(),
          (value) => value.known,
        ),
      ],
      build: (data) => _InventoryOwner(data['known']! as String),
    );

    final result = schema.codec().safeEncode(const _InventoryOwner('value'));

    expect(result.isFail, isTrue);
    expect(result.getError().cause, isA<SchemaInventorySkewError>());

    final errors = mapSchemaError(result.getError());
    expect(
      errors.single,
      isA<MixSchemaError>()
          .having(
            (error) => error.code,
            'code',
            MixSchemaErrorCode.inventorySkew,
          )
          .having(
            (error) => error.message,
            'message',
            allOf(contains('_InventoryOwner'), contains('future')),
          ),
    );
  });

  test('SchemaObject infers real styler coverage from declared fields', () {
    final schema = SchemaObject<BoxStyler>(
      inventoryOwner: 'BoxStyler',
      ownerFieldInventory: const {'alignment', 'padding'},
      fields: [
        directField<BoxStyler, String>('alignment', Ack.string(), (_) => null),
      ],
      build: (_) => BoxStyler(),
    );

    final result = schema.codec().safeEncode(BoxStyler());

    expect(result.isFail, isTrue);
    final errors = mapSchemaError(result.getError());
    expect(
      errors.single,
      isA<MixSchemaError>()
          .having(
            (error) => error.code,
            'code',
            MixSchemaErrorCode.inventorySkew,
          )
          .having(
            (error) => error.message,
            'message',
            allOf(contains('BoxStyler'), contains('padding')),
          ),
    );
  });

  test(
    'SchemaObject reports count skew when runtime fields cannot be named',
    () {
      final schema = SchemaObject<_InventoryOwner>(
        inventoryOwner: '_InventoryOwner',
        ownerFieldInventory: const {'known'},
        actualFieldCount: (_) => 2,
        fields: [
          directField<_InventoryOwner, String>(
            'known',
            Ack.string(),
            (value) => value.known,
          ),
        ],
        build: (data) => _InventoryOwner(data['known']! as String),
      );

      final result = schema.codec().safeEncode(const _InventoryOwner('value'));

      expect(result.isFail, isTrue);
      final errors = mapSchemaError(result.getError());
      expect(
        errors.single,
        isA<MixSchemaError>()
            .having(
              (error) => error.code,
              'code',
              MixSchemaErrorCode.inventorySkew,
            )
            .having(
              (error) => error.value,
              'value',
              allOf(
                containsPair('expectedFieldCount', 1),
                containsPair('actualFieldCount', 2),
              ),
            ),
      );
    },
  );

  test('real composite stylers use owner-field skew accounting', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    for (final styler in [
      FlexBoxStyler(padding: EdgeInsetsMix.all(4), direction: Axis.horizontal),
      StackBoxStyler(
        padding: EdgeInsetsMix.all(4),
        stackAlignment: Alignment.center,
      ),
    ]) {
      final result = contract.encode(styler);

      expect(
        result,
        isA<MixSchemaEncodeSuccess>(),
        reason: 'expected ${styler.runtimeType} to encode without skew',
      );
    }
  });
}
