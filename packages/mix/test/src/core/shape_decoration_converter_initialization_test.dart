import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

// Keep this in its own test file to exercise the registry's first conversion.
void main() {
  test('initialization preserves a custom ShapeDecoration converter', () {
    final registry = MixConverterRegistry.instance;
    const decoration = ShapeDecoration(
      shape: CircleBorder(),
      color: Color(0xFFFF0000),
    );
    const converted = ShapeDecoration(
      shape: CircleBorder(),
      color: Color(0xFF0000FF),
    );
    final customMix = ShapeDecorationMix.value(converted);
    var conversions = 0;
    final converter = SimpleMixConverter<ShapeDecoration>((value) {
      expect(value, decoration);
      conversions++;

      return customMix;
    });
    registry.register<ShapeDecoration>(converter);

    final concrete = registry.convert<ShapeDecoration>(decoration);
    final base = registry.convert<Decoration>(decoration);

    expect(registry.get<ShapeDecoration>(), same(converter));
    expect(concrete.resolve(MockBuildContext()), converted);
    expect(base.resolve(MockBuildContext()), converted);
    expect(conversions, 2);
  });
}
