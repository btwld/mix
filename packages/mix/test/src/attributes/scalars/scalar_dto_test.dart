import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('Mixable<T>', () {
    group('Mixable<String>', () {
      test('value constructor works', () {
        const dto = StringMix('test');
        // MIGRATED: Clean assertion using custom matcher
        expect(dto, resolvesTo('test'));
      });

      // TODO: Add token tests when token resolution is properly set up

      test('merge creates composite', () {
        const dto1 = StringMix('first');
        const dto2 = StringMix('second');

        final merged = dto1.merge(dto2);
        // MIGRATED: Clean assertions - last value wins in merge
        expect(merged, resolvesTo('second'));
        expect(merged, equivalentTo(dto2));
      });
    });

    group('Mixable<double>', () {
      test('value constructor works', () {
        const dto = DoubleMix(42.5);
        // MIGRATED: Clean assertion
        expect(dto, resolvesTo(42.5));
      });

      // TODO: Add token tests when token resolution is properly set up

      test('merge works correctly', () {
        const dto1 = DoubleMix(10.0);
        const dto2 = DoubleMix(20.0);

        final merged = dto1.merge(dto2);
        // MIGRATED: Clean assertion - last value wins
        expect(merged, resolvesTo(20.0));
        expect(merged, equivalentTo(dto2));
      });
    });

    group('Mixable<FontWeight>', () {
      test('value constructor works', () {
        const dto = FontWeightMix(FontWeight.bold);
        // MIGRATED: Clean assertion
        expect(dto, resolvesTo(FontWeight.bold));
      });

      // TODO: Add token tests when token resolution is properly set up
    });
  });

  group('ColorDto with composite', () {
    test('merge resolution works', () {
      const dto1 = ColorMix(Colors.red);
      const dto2 = ColorMix(Colors.blue);

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(Colors.blue));
    });

    test('merge behavior is consistent', () {
      const dto1 = ColorMix(Colors.red);
      const dto2 = ColorMix(Colors.blue);

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertions
      expect(merged, resolvesTo(Colors.blue));
      expect(merged, equivalentTo(dto2));
    });
  });

  group('RadiusDto with composite', () {
    test('merge resolution works', () {
      const dto1 = RadiusMix(Radius.circular(5));
      const dto2 = RadiusMix(Radius.circular(10));

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(const Radius.circular(10)));
    });

    test('fromValue works', () {
      const radius = Radius.circular(15);
      const dto = RadiusMix(radius);
      // MIGRATED: Clean assertion
      expect(dto, resolvesTo(radius));
    });
  });
}
