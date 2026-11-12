import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  // Keep this first-use regression in its own test library so the singleton
  // has not been initialized by another conversion.
  test('startup registration survives lazy built-in initialization', () {
    final registry = MixConverterRegistry.instance;
    const decoration = BoxDecoration(color: Color(0xFF123456));
    final custom = SimpleMixConverter<Decoration>(
      (value) => MockMix<Decoration>(value),
    );

    registry.register<Decoration>(custom);

    expect(
      registry.convert<Decoration>(decoration),
      isA<MockMix<Decoration>>(),
    );
    expect(registry.get<Decoration>(), same(custom));
    expect(
      registry.convert(const BorderSide(width: 3)),
      resolvesTo(const BorderSide(width: 3)),
    );

    final replacement = SimpleMixConverter<Decoration>(
      (value) => MockMix<Decoration>(const BoxDecoration()),
    );
    registry.register<Decoration>(replacement);

    expect(registry.get<Decoration>(), same(replacement));
    expect(
      registry.convert<Decoration>(decoration),
      resolvesTo(const BoxDecoration()),
    );
  });
}
