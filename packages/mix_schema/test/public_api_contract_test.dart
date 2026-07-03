import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';
import 'package:mix_schema/testing.dart' as schema_testing;

final class _ApiStyle {
  const _ApiStyle(this.value);

  final String value;
}

void main() {
  test(
    'public API exposes contract, vocabulary, JsonMap, and sealed results',
    () {
      final branch = MixSchemaBranch<_ApiStyle>.json(
        decode: (data) => _ApiStyle(data['value']! as String),
        encode: (value) => {'value': value.value},
        validate: (data) => data['value'] is String,
        validationMessage: 'API test branch requires a string value.',
      );
      final contract = MixSchemaContractBuilder()
          .addStyler('api', branch)
          .freeze();

      final JsonMap payload = {'type': 'api', 'value': 'ok'};

      expect(contract.registeredTypes, ['api']);
      expect(contract.rootSchema, isA<MixSchemaRootSchema>());
      expect(contract.rootSchema.toJsonSchema(), isA<JsonMap>());
      expect(contract.validate(payload), isA<MixSchemaValidationSuccess>());
      expect(SchemaStyler.box.wireValue, 'box');
      expect(
        SchemaModifier.values.map((value) => value.wireValue),
        containsAll([
          'align',
          'aspect_ratio',
          'blur',
          'box',
          'clip_oval',
          'clip_rect',
          'clip_r_rect',
          'clip_triangle',
          'default_text_style',
          'default_text_styler',
          'flexible',
          'fractionally_sized_box',
          'icon_theme',
          'intrinsic_height',
          'intrinsic_width',
          'opacity',
          'padding',
          'rotate',
          'rotated_box',
          'scale',
          'scroll_view',
          'sized_box',
          'skew',
          'transform',
          'translate',
          'visibility',
        ]),
      );
      expect(
        SchemaVariant.values.map((value) => value.wireValue),
        containsAll([
          'named',
          'widget_state',
          'enabled',
          'context_brightness',
          'context_breakpoint',
          'context_directionality',
          'context_not',
          'context_not_widget_state',
          'context_orientation',
          'context_platform',
          'context_web',
        ]),
      );
      expect(builtInMixSchemaContract.registeredTypes, contains('box'));
      expect(
        schema_testing.payloadStyler(schema_testing.SchemaStyler.box)['type'],
        'box',
      );
      expect(
        schema_testing.payloadModifier(schema_testing.SchemaModifier.opacity, {
          'opacity': 0.5,
        })['type'],
        'opacity',
      );

      final result = contract.decode<_ApiStyle>(payload);
      final value = switch (result) {
        MixSchemaDecodeSuccess<_ApiStyle>(:final value) => value.value,
        MixSchemaDecodeFailure<_ApiStyle>() => fail('expected success'),
      };
      expect(value, 'ok');
    },
  );
}
