import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

final MixSchemaContract _schema = MixSchemaContractBuilder().builtIn().freeze();

FlexibleModifierMix? twFlexibleModifierForFlexItem(String utility) {
  final payload = _flexibleModifierPayload(utility);
  if (payload == null) return null;

  final decoded = _schema.decode<BoxStyler>({
    'type': 'box',
    'modifiers': [payload],
  });

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
  return switch (utility) {
    'flex-1' ||
    'flex-shrink' ||
    'shrink' ||
    'grow' => const {'type': 'flexible', 'flex': 1, 'fit': 'tight'},
    'flex-auto' => const {'type': 'flexible', 'flex': 1, 'fit': 'loose'},
    'flex-initial' ||
    'flex-none' ||
    'flex-shrink-0' ||
    'shrink-0' ||
    'grow-0' => const {'type': 'flexible', 'flex': 0, 'fit': 'loose'},
    _ => null,
  };
}
