import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  //  ShadowDto
  group('ShadowDto', () {
    test('Constructor assigns correct properties', () {
      final shadowDto = ShadowDto(
        blurRadius: const DoubleMix(10.0),
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
      );

      // MIGRATED: Clean assertions using custom matchers
      expect(shadowDto.blurRadius, resolvesTo(10.0));
      expect(shadowDto.color, resolvesTo(Colors.blue));
      expect(shadowDto.offset, resolvesTo(const Offset(10, 10)));
    });

    test('resolve() returns correct instance', () {
      final shadowDto = ShadowDto(
        blurRadius: const DoubleMix(10.0),
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
      );

      // MIGRATED: Clean assertion using custom matcher
      const expectedShadow = Shadow(
        blurRadius: 10.0,
        color: Colors.blue,
        offset: Offset(10, 10),
      );
      expect(shadowDto, resolvesTo(expectedShadow));
    });

    test('merge() returns correct instance', () {
      final shadowDto = ShadowDto(
        blurRadius: const DoubleMix(10.0),
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
      );

      final mergedShadowDto = shadowDto.merge(
        ShadowDto(
          blurRadius: const DoubleMix(20.0),
          color: const ColorMix(Colors.red),
          offset: const OffsetMix(Offset(20, 20)),
        ),
      );

      // MIGRATED: Clean assertions using custom matchers
      expect(mergedShadowDto.blurRadius, resolvesTo(20.0));
      expect(mergedShadowDto.color, resolvesTo(Colors.red));
      expect(mergedShadowDto.offset, resolvesTo(const Offset(20, 20)));
    });
  });

  group('BoxShadowDto', () {
    test('Constructor assigns correct properties', () {
      final boxShadowDto = BoxShadowDto(
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
        blurRadius: const DoubleMix(10.0),
        spreadRadius: const DoubleMix(5.0),
      );

      // MIGRATED: Clean assertions using custom matchers
      expect(boxShadowDto.blurRadius, resolvesTo(10.0));
      expect(boxShadowDto.color, resolvesTo(Colors.blue));
      expect(boxShadowDto.offset, resolvesTo(const Offset(10, 10)));
      expect(boxShadowDto.spreadRadius, resolvesTo(5.0));
    });

    test('resolve() returns correct instance', () {
      final boxShadowDto = BoxShadowDto(
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
        blurRadius: const DoubleMix(10.0),
        spreadRadius: const DoubleMix(5.0),
      );

      // MIGRATED: Clean assertion using custom matcher
      const expectedBoxShadow = BoxShadow(
        color: Colors.blue,
        offset: Offset(10, 10),
        blurRadius: 10.0,
        spreadRadius: 5.0,
      );
      expect(boxShadowDto, resolvesTo(expectedBoxShadow));
    });

    test('merge() returns correct instance', () {
      final boxShadowDto = BoxShadowDto(
        color: const ColorMix(Colors.blue),
        offset: const OffsetMix(Offset(10, 10)),
        blurRadius: const DoubleMix(10.0),
        spreadRadius: const DoubleMix(5.0),
      );

      final mergedBoxShadowDto = boxShadowDto.merge(
        BoxShadowDto(
          color: const ColorMix(Colors.red),
          offset: const OffsetMix(Offset(20, 20)),
          blurRadius: const DoubleMix(20.0),
          spreadRadius: const DoubleMix(10.0),
        ),
      );

      // MIGRATED: Clean assertions using custom matchers
      expect(mergedBoxShadowDto.blurRadius, resolvesTo(20.0));
      expect(mergedBoxShadowDto.color, resolvesTo(Colors.red));
      expect(mergedBoxShadowDto.offset, resolvesTo(const Offset(20, 20)));
      expect(mergedBoxShadowDto.spreadRadius, resolvesTo(10.0));
    });
  });
}
