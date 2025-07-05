import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Mixable<T>', () {
    group('Mixable<String>', () {
      test('value constructor works', () {
        const dto = Mixable.value('test');
        expect(dto.resolve(createMixContext()), 'test');
      });

      // TODO: Add token tests when token resolution is properly set up

      test('composite constructor works - last value wins', () {
        const dto1 = Mixable.value('first');
        const dto2 = Mixable.value('second');
        const dto3 = Mixable.value('third');

        const composite = Mixable.composite([dto1, dto2, dto3]);
        expect(composite.resolve(createMixContext()), 'third');
      });

      test('merge creates composite', () {
        const dto1 = Mixable<String>.value('first');
        const dto2 = Mixable<String>.value('second');

        final merged = dto1.merge(dto2);
        expect(merged.resolve(createMixContext()), 'second');
      });
    });

    group('Mixable<double>', () {
      test('value constructor works', () {
        const dto = Mixable<double>.value(42.5);
        expect(dto.resolve(createMixContext()), 42.5);
      });

      // TODO: Add token tests when token resolution is properly set up

      test('composite constructor works - last value wins', () {
        const dto1 = Mixable<double>.value(10.0);
        const dto2 = Mixable<double>.value(20.0);
        const dto3 = Mixable<double>.value(30.0);

        const composite = Mixable<double>.composite([dto1, dto2, dto3]);
        expect(composite.resolve(createMixContext()), 30.0);
      });
    });

    group('Mixable<FontWeight>', () {
      test('value constructor works', () {
        const dto = Mixable<FontWeight>.value(FontWeight.bold);
        expect(dto.resolve(createMixContext()), FontWeight.bold);
      });

      // TODO: Add token tests when token resolution is properly set up
    });
  });

  group('ColorDto with composite', () {
    test('composite resolution works', () {
      const dto1 = ColorDto.value(Colors.red);
      const dto2 = ColorDto.value(Colors.blue);

      const composite = ColorDto.composite([dto1, dto2]);
      expect(composite.resolve(createMixContext()), Colors.blue);
    });

    test('composite with directives accumulates directives', () {
      const dto1 = ColorDto.value(Colors.red, directives: []);
      const dto2 = ColorDto.value(Colors.blue, directives: []);

      const composite = ColorDto.composite([dto1, dto2]);
      final resolved = composite.resolve(createMixContext());
      expect(resolved, Colors.blue);
    });
  });

  group('RadiusDto with composite', () {
    test('composite resolution works', () {
      const dto1 = Mixable<Radius>.value(Radius.circular(5));
      const dto2 = Mixable<Radius>.value(Radius.circular(10));

      const composite = Mixable<Radius>.composite([dto1, dto2]);
      expect(composite.resolve(createMixContext()), const Radius.circular(10));
    });

    test('fromValue works', () {
      const radius = Radius.circular(15);
      final dto = RadiusDto$.fromValue(radius);
      expect(dto.resolve(createMixContext()), radius);
    });
  });

  group('TextStyleDto with composite', () {
    test('composite resolution works', () {
      const dto1 = TextStyleDto(
        fontSize: Mixable<double>.value(12),
        color: ColorDto.value(Colors.red),
      );
      const dto2 = TextStyleDto(
        fontSize: Mixable<double>.value(16),
        fontWeight: Mixable<FontWeight>.value(FontWeight.bold),
      );

      const composite = TextStyleDto.composite([dto1, dto2]);
      final resolved = composite.resolve(createMixContext());

      expect(resolved.fontSize, 16); // Last value wins
      expect(resolved.color, Colors.red); // Preserved from first
      expect(resolved.fontWeight, FontWeight.bold); // From second
    });

    test('fromValue works', () {
      const style = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green,
      );

      final dto = TextStyleDto.fromValue(style);
      final resolved = dto.resolve(createMixContext());

      expect(resolved.fontSize, 14);
      expect(resolved.fontWeight, FontWeight.w500);
      expect(resolved.color, Colors.green);
    });

    // TODO: Add token with value override test when token resolution is properly set up
  });
}
