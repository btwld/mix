import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackMixAttribute', () {
    test(
      'of returns default attribute when mix does not have StackMixAttribute',
      () {
        final mix = MixContext.create(MockBuildContext(), Style());
        const attribute = StackSpecAttribute();

        final resolved = attribute.resolve(mix);

        expect(resolved.alignment, null);
        expect(resolved.fit, null);
        expect(resolved.textDirection, null);
        expect(resolved.clipBehavior, null);
      },
    );

    test('resolve returns correct StackSpec', () {
      const attribute = StackSpecAttribute(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );
      final mix = MixContext.create(MockBuildContext(), Style(attribute));
      final spec = attribute.resolve(mix);

      expect(spec.alignment, Alignment.center);
      expect(spec.fit, StackFit.expand);
      expect(spec.textDirection, TextDirection.ltr);
      expect(spec.clipBehavior, Clip.antiAlias);
    });

    test('merge returns correct StackMixAttribute', () {
      const attribute1 = StackSpecAttribute(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );
      const attribute2 = StackSpecAttribute(
        alignment: Alignment.topLeft,
        fit: StackFit.loose,
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.hardEdge,
      );
      final mergedAttribute = attribute1.merge(attribute2);

      final resolved = mergedAttribute.resolve(EmptyMixData);

      expect(resolved.alignment, Alignment.topLeft);
      expect(resolved.fit, StackFit.loose);
      expect(resolved.textDirection, TextDirection.rtl);
      expect(resolved.clipBehavior, Clip.hardEdge);
    });

    test('props returns correct list of properties', () {
      const attribute = StackSpecAttribute(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
        animated: AnimationConfigDto.withDefaults(),
      );
      final props = attribute.props;

      expect(props.length, 6);
      expect(props[0], Alignment.center);
      expect(props[1], StackFit.expand);
      expect(props[2], TextDirection.ltr);
      expect(props[3], Clip.antiAlias);
      expect(props[4], const AnimationConfigDto.withDefaults());
    });
  });
}
