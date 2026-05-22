import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('compound built-in styler codecs', () {
    test('encodes and decodes flattened FlexBoxStyler fields', () {
      final contract = MixSchemaContract.builtIn();
      final style = FlexBoxStyler(
        alignment: Alignment.centerLeft,
        padding: EdgeInsetsMix(top: 8, left: 12),
        constraints: BoxConstraintsMix(minWidth: 20, maxWidth: 80),
        clipBehavior: Clip.hardEdge,
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        textBaseline: TextBaseline.alphabetic,
        flexClipBehavior: Clip.antiAlias,
        spacing: 6,
      );

      _expectEncodeDecodeRoundTrip(contract, style, {
        'type': 'flex_box',
        'alignment': {'x': -1.0, 'y': 0.0},
        'padding': {'top': 8.0, 'left': 12.0},
        'constraints': {'minWidth': 20.0, 'maxWidth': 80.0},
        'clipBehavior': 'hardEdge',
        'direction': 'horizontal',
        'mainAxisAlignment': 'center',
        'crossAxisAlignment': 'stretch',
        'mainAxisSize': 'min',
        'textDirection': 'rtl',
        'textBaseline': 'alphabetic',
        'flexClipBehavior': 'antiAlias',
        'spacing': 6.0,
      });
    });

    test('encodes and decodes flattened StackBoxStyler fields', () {
      final contract = MixSchemaContract.builtIn();
      final style = StackBoxStyler(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsetsMix(bottom: 10, right: 14),
        constraints: BoxConstraintsMix(minHeight: 30, maxHeight: 90),
        clipBehavior: Clip.hardEdge,
        stackAlignment: Alignment.topRight,
        fit: StackFit.expand,
        textDirection: TextDirection.rtl,
        stackClipBehavior: Clip.antiAliasWithSaveLayer,
      );

      _expectEncodeDecodeRoundTrip(contract, style, {
        'type': 'stack_box',
        'alignment': {'x': 0.0, 'y': 1.0},
        'margin': {'bottom': 10.0, 'right': 14.0},
        'constraints': {'minHeight': 30.0, 'maxHeight': 90.0},
        'clipBehavior': 'hardEdge',
        'stackAlignment': {'x': 1.0, 'y': -1.0},
        'fit': 'expand',
        'textDirection': 'rtl',
        'stackClipBehavior': 'antiAliasWithSaveLayer',
      });
    });

    test('reports encode errors for nested multi-source compound props', () {
      final contract = MixSchemaContract.builtIn();
      final style = FlexBoxStyler(
        alignment: Alignment.center,
      ).merge(FlexBoxStyler(alignment: Alignment.topLeft));

      final result = contract.encode(style);

      expect(result.ok, isFalse);
      expect(result.value, isNull);
      expect(result.errors, hasLength(1));
      expect(
        result.errors.single.code,
        MixSchemaErrorCode.unsupportedEncodeValue,
      );
      expect(
        result.errors.single.message,
        contains('Only single-source mix props can be encoded.'),
      );
    });

    test('reports encode errors for nested non-direct compound props', () {
      final contract = MixSchemaContract.builtIn();
      final style = StackBoxStyler.create(
        box: Prop.token(_TestToken<StyleSpec<BoxSpec>>('box-style')),
      );

      final result = contract.encode(style);

      expect(result.ok, isFalse);
      expect(result.value, isNull);
      expect(result.errors, hasLength(1));
      expect(
        result.errors.single.code,
        MixSchemaErrorCode.unsupportedEncodeValue,
      );
      expect(
        result.errors.single.message,
        contains('Only direct mix props can be encoded.'),
      );
    });
  });
}

void _expectEncodeDecodeRoundTrip<T extends Object>(
  MixSchemaContract contract,
  T style,
  Map<String, Object?> expectedPayload,
) {
  final encoded = contract.encode(style);

  expect(encoded.ok, isTrue, reason: encoded.errors.join('\n'));
  expect(encoded.value, expectedPayload);

  final decoded = contract.decode(encoded.value!);

  expect(decoded.ok, isTrue, reason: decoded.errors.join('\n'));
  expect(decoded.value, style);
}

class _TestToken<T> extends MixToken<T> {
  const _TestToken(super.name);
}
