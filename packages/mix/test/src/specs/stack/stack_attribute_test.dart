import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('StackMixAttribute', () {
    test(
      'of returns default attribute when mix does not have StackMixAttribute',
      () {
        const attribute = StackSpecAttribute();

        expect(
          attribute,
          resolvesTo(const StackSpec()),
        );
      },
    );

    test('resolve returns correct StackSpec', () {
      const attribute = StackSpecAttribute(
        alignment: Alignment.center,
        fit: StackFit.expand,
        textDirection: TextDirection.ltr,
        clipBehavior: Clip.antiAlias,
      );

      expect(
        attribute,
        resolvesTo(const StackSpec(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        )),
      );
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

      expect(
        mergedAttribute,
        resolvesTo(const StackSpec(
          alignment: Alignment.topLeft,
          fit: StackFit.loose,
          textDirection: TextDirection.rtl,
          clipBehavior: Clip.hardEdge,
        )),
      );
    });

    test('props returns correct list of properties', () {
      final attribute = StackSpecAttribute(
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
      expect(props[4], AnimationConfigDto.withDefaults());
    });
  });
}
