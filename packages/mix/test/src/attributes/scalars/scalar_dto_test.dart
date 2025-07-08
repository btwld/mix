import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Mixable<T>', () {
    group('Mixable<String>', () {
      test('value constructor works', () {
        const dto = Mix.value('test');
        expect(dto.resolve(createMixContext()), 'test');
      });

      // TODO: Add token tests when token resolution is properly set up

      test('composite constructor works - last value wins', () {
        const dto1 = Mix.value('first');
        const dto2 = Mix.value('second');
        const dto3 = Mix.value('third');

        const composite = Mix.composite([dto1, dto2, dto3]);
        expect(composite.resolve(createMixContext()), 'third');
      });

      test('merge creates composite', () {
        const dto1 = Mix<String>.value('first');
        const dto2 = Mix<String>.value('second');

        final merged = dto1.merge(dto2);
        expect(merged.resolve(createMixContext()), 'second');
      });
    });

    group('Mixable<double>', () {
      test('value constructor works', () {
        const dto = Mix<double>.value(42.5);
        expect(dto.resolve(createMixContext()), 42.5);
      });

      // TODO: Add token tests when token resolution is properly set up

      test('composite constructor works - last value wins', () {
        const dto1 = Mix<double>.value(10.0);
        const dto2 = Mix<double>.value(20.0);
        const dto3 = Mix<double>.value(30.0);

        const composite = Mix<double>.composite([dto1, dto2, dto3]);
        expect(composite.resolve(createMixContext()), 30.0);
      });
    });

    group('Mixable<FontWeight>', () {
      test('value constructor works', () {
        const dto = Mix<FontWeight>.value(FontWeight.bold);
        expect(dto.resolve(createMixContext()), FontWeight.bold);
      });

      // TODO: Add token tests when token resolution is properly set up
    });
  });

  group('ColorDto with composite', () {
    test('composite resolution works', () {
      const dto1 = Mix<Color>.value(Colors.red);
      const dto2 = Mix<Color>.value(Colors.blue);

      const composite = Mix<Color>.composite([dto1, dto2]);
      expect(composite.resolve(createMixContext()), Colors.blue);
    });

    test('composite with directives accumulates directives', () {
      const dto1 = Mix<Color>.value(Colors.red);
      const dto2 = Mix<Color>.value(Colors.blue);

      const composite = Mix<Color>.composite([dto1, dto2]);
      final resolved = composite.resolve(createMixContext());
      expect(resolved, Colors.blue);
    });
  });

  group('RadiusDto with composite', () {
    test('composite resolution works', () {
      const dto1 = Mix<Radius>.value(Radius.circular(5));
      const dto2 = Mix<Radius>.value(Radius.circular(10));

      const composite = Mix<Radius>.composite([dto1, dto2]);
      expect(composite.resolve(createMixContext()), const Radius.circular(10));
    });

    test('fromValue works', () {
      const radius = Radius.circular(15);
      const dto = Mix.value(radius);
      expect(dto.resolve(createMixContext()), radius);
    });
  });
}
