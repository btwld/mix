import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/src/errors/mix_schema_error.dart';
import 'package:mix_schema/src/errors/schema_error_mapper.dart';
import 'package:mix_schema/src/schema/schema_field.dart';
import 'package:mix_schema/src/schema/styler_field_inventory.dart';
import 'package:mix_schema/mix_schema.dart';

final class _InventoryOwner {
  const _InventoryOwner(this.known);

  final String known;
}

final class _FutureTextStyleMix extends TextStyleMix {
  const _FutureTextStyleMix() : super.create();

  @override
  List<Object?> get props => [...super.props, 'future'];
}

final class _FutureStrutStyleMix extends StrutStyleMix {
  const _FutureStrutStyleMix() : super.create();

  @override
  List<Object?> get props => [...super.props, 'future'];
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

  test('nested Mix inventory guard reports count skew', () {
    expect(
      () => checkKnownFieldInventory(
        const LinearGradientMix.create(),
        owner: 'LinearGradientMix',
        fields: const {'begin'},
      ),
      throwsA(
        isA<SchemaInventorySkewError>()
            .having((error) => error.owner, 'owner', 'LinearGradientMix')
            .having((error) => error.expectedFieldCount, 'expected', 1)
            .having((error) => error.actualFieldCount, 'actual', 6),
      ),
    );
  });

  test('nested text Mix encode guards report count skew', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    final cases = [
      (
        owner: 'TextStyleMix',
        styler: TextStyler.create(style: Prop.mix(const _FutureTextStyleMix())),
      ),
      (
        owner: 'StrutStyleMix',
        styler: TextStyler.create(
          strutStyle: Prop.mix(const _FutureStrutStyleMix()),
        ),
      ),
    ];

    for (final (:owner, :styler) in cases) {
      final result = contract.encode(styler);
      final errors = switch (result) {
        MixSchemaEncodeFailure(:final errors) => errors,
        MixSchemaEncodeSuccess() => fail('expected $owner skew failure'),
      };

      expect(
        errors,
        contains(
          isA<MixSchemaError>()
              .having(
                (error) => error.code,
                'code',
                MixSchemaErrorCode.inventorySkew,
              )
              .having((error) => error.message, 'message', contains(owner)),
        ),
        reason: owner,
      );
    }
  });

  test('Phase 4 nested Mix inventories match runtime fields', () {
    final cases = [
      (
        value: const WidgetModifierConfig(),
        owner: 'WidgetModifierConfig',
        fields: widgetModifierConfigInventory,
      ),
      (
        value: const BoxDecorationMix.create(),
        owner: 'BoxDecorationMix',
        fields: boxDecorationMixInventory,
      ),
      (
        value: const LinearGradientMix.create(),
        owner: 'LinearGradientMix',
        fields: linearGradientMixInventory,
      ),
      (
        value: const RadialGradientMix.create(),
        owner: 'RadialGradientMix',
        fields: radialGradientMixInventory,
      ),
      (
        value: const SweepGradientMix.create(),
        owner: 'SweepGradientMix',
        fields: sweepGradientMixInventory,
      ),
      (
        value: const TextStyleMix.create(),
        owner: 'TextStyleMix',
        fields: textStyleMixInventory,
      ),
      (
        value: const StrutStyleMix.create(),
        owner: 'StrutStyleMix',
        fields: strutStyleMixInventory,
      ),
      (
        value: const AlignModifierMix.create(),
        owner: 'AlignModifierMix',
        fields: modifierAlignInventory,
      ),
      (
        value: const AspectRatioModifierMix.create(),
        owner: 'AspectRatioModifierMix',
        fields: modifierAspectRatioInventory,
      ),
      (
        value: const BlurModifierMix.create(),
        owner: 'BlurModifierMix',
        fields: modifierBlurInventory,
      ),
      (
        value: BoxModifierMix(BoxStyler()),
        owner: 'BoxModifierMix',
        fields: modifierBoxInventory,
      ),
      (
        value: const ClipOvalModifierMix.create(),
        owner: 'ClipOvalModifierMix',
        fields: modifierClipOvalInventory,
      ),
      (
        value: const ClipRectModifierMix.create(),
        owner: 'ClipRectModifierMix',
        fields: modifierClipRectInventory,
      ),
      (
        value: const ClipRRectModifierMix.create(),
        owner: 'ClipRRectModifierMix',
        fields: modifierClipRRectInventory,
      ),
      (
        value: const ClipTriangleModifierMix.create(),
        owner: 'ClipTriangleModifierMix',
        fields: modifierClipTriangleInventory,
      ),
      (
        value: const DefaultTextStyleModifierMix.create(),
        owner: 'DefaultTextStyleModifierMix',
        fields: modifierDefaultTextStyleInventory,
      ),
      (
        value: const DefaultTextStylerModifierMix(TextStyler.create()),
        owner: 'DefaultTextStylerModifierMix',
        fields: modifierDefaultTextStylerInventory,
      ),
      (
        value: const FlexibleModifierMix.create(),
        owner: 'FlexibleModifierMix',
        fields: modifierFlexibleInventory,
      ),
      (
        value: const FractionallySizedBoxModifierMix.create(),
        owner: 'FractionallySizedBoxModifierMix',
        fields: modifierFractionallySizedBoxInventory,
      ),
      (
        value: const IconThemeModifierMix.create(),
        owner: 'IconThemeModifierMix',
        fields: modifierIconThemeInventory,
      ),
      (
        value: const IntrinsicHeightModifierMix(),
        owner: 'IntrinsicHeightModifierMix',
        fields: modifierIntrinsicHeightInventory,
      ),
      (
        value: const IntrinsicWidthModifierMix(),
        owner: 'IntrinsicWidthModifierMix',
        fields: modifierIntrinsicWidthInventory,
      ),
      (
        value: const OpacityModifierMix.create(),
        owner: 'OpacityModifierMix',
        fields: modifierOpacityInventory,
      ),
      (
        value: const PaddingModifierMix.create(),
        owner: 'PaddingModifierMix',
        fields: modifierPaddingInventory,
      ),
      (
        value: const RotateModifierMix.create(),
        owner: 'RotateModifierMix',
        fields: modifierRotateInventory,
      ),
      (
        value: const RotatedBoxModifierMix.create(),
        owner: 'RotatedBoxModifierMix',
        fields: modifierRotatedBoxInventory,
      ),
      (
        value: const ScaleModifierMix.create(),
        owner: 'ScaleModifierMix',
        fields: modifierScaleInventory,
      ),
      (
        value: const ScrollViewModifierMix.create(),
        owner: 'ScrollViewModifierMix',
        fields: modifierScrollViewInventory,
      ),
      (
        value: const SizedBoxModifierMix.create(),
        owner: 'SizedBoxModifierMix',
        fields: modifierSizedBoxInventory,
      ),
      (
        value: const SkewModifierMix.create(),
        owner: 'SkewModifierMix',
        fields: modifierSkewInventory,
      ),
      (
        value: const TransformModifierMix.create(),
        owner: 'TransformModifierMix',
        fields: modifierTransformInventory,
      ),
      (
        value: const TranslateModifierMix.create(),
        owner: 'TranslateModifierMix',
        fields: modifierTranslateInventory,
      ),
      (
        value: const VisibilityModifierMix.create(),
        owner: 'VisibilityModifierMix',
        fields: modifierVisibilityInventory,
      ),
    ];

    for (final (:value, :owner, :fields) in cases) {
      checkKnownFieldInventory(value, owner: owner, fields: fields);
    }
  });

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
