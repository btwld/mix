import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/encode.dart';
import 'package:mix_schema/mix_schema.dart';

FlexibleModifierMix? twFlexibleModifierForFlexItem(String utility) {
  final payload = _flexibleModifierPayload(utility);
  if (payload == null) return null;

  final decoded = builtInMixSchemaContract.decode<BoxStyler>(
    payloadStyler(SchemaStyler.box, {
      'modifiers': [payload],
    }),
  );

  final style = switch (decoded) {
    MixSchemaDecodeSuccess<BoxStyler>(:final value) => value,
    MixSchemaDecodeFailure<BoxStyler>(:final errors) => throw StateError(
      'Failed to decode flex item modifier payload: $errors',
    ),
  };

  for (final modifier in style.$modifier?.$modifiers ?? const <ModifierMix>[]) {
    if (modifier is FlexibleModifierMix) return modifier;
  }

  throw StateError('Flex item payload did not decode to FlexibleModifierMix.');
}

JsonMap? _flexibleModifierPayload(String utility) {
  final ({int flex, FlexFit fit})? spec = switch (utility) {
    'flex-1' ||
    'flex-shrink' ||
    'shrink' ||
    'grow' => (flex: 1, fit: FlexFit.tight),
    'flex-auto' => (flex: 1, fit: FlexFit.loose),
    'flex-initial' ||
    'flex-none' ||
    'flex-shrink-0' ||
    'shrink-0' ||
    'grow-0' => (flex: 0, fit: FlexFit.loose),
    _ => null,
  };
  if (spec == null) return null;

  return payloadModifier(SchemaModifier.flexible, {
    'flex': spec.flex,
    'fit': payloadEnum(spec.fit),
  });
}
