import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';
import '../../../helpers/testing_utils.dart';

void main() {
  group('Mixable<T>', () {
    group('Mixable<String>', () {
      test('value constructor works', () {
        final dto = Mix.value('test');
        // MIGRATED: Clean assertion using custom matcher
        expect(dto, resolvesTo('test'));
      });

      // Token API has been removed in current version
      // test('token constructor works', () {
      //   // Token functionality removed from API
      // });

      test('merge creates composite', () {
        final dto1 = Mix.value('first');
        final dto2 = Mix.value('second');

        final merged = dto1.merge(dto2);
        // MIGRATED: Clean assertions - last value wins in merge
        expect(merged, resolvesTo('second'));
        expect(merged, equivalentTo(dto2));
      });
    });

    group('Mixable<double>', () {
      test('value constructor works', () {
        final dto = Mix.value(42.5);
        // MIGRATED: Clean assertion
        expect(dto, resolvesTo(42.5));
      });

      // Token API has been removed in current version
      // test('token constructor works', () {
      //   // Token functionality removed from API
      // });

      // Token API has been removed in current version
      // test('token constructor works', () {
      //   // Token functionality removed from API
      // });

      test('merge works correctly', () {
        final dto1 = Mix.value(10.0);
        final dto2 = Mix.value(20.0);

        final merged = dto1.merge(dto2);
        // MIGRATED: Clean assertion - last value wins
        expect(merged, resolvesTo(20.0));
        expect(merged, equivalentTo(dto2));
      });
    });

    group('Mixable<FontWeight>', () {
      test('value constructor works', () {
        final dto = Mix.value(FontWeight.bold);
        // MIGRATED: Clean assertion
        expect(dto, resolvesTo(FontWeight.bold));
      });

      // TODO: Add token tests when token resolution is properly set up
    });
  });

  group('ColorDto with composite', () {
    test('merge resolution works', () {
      final dto1 = Mix.value(Colors.red);
      final dto2 = Mix.value(Colors.blue);

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(Colors.blue));
    });

    test('merge behavior is consistent', () {
      final dto1 = Mix.value(Colors.red);
      final dto2 = Mix.value(Colors.blue);

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertions
      expect(merged, resolvesTo(Colors.blue));
      expect(merged, equivalentTo(dto2));
    });
  });

  group('RadiusDto with composite', () {
    test('merge resolution works', () {
      final dto1 = Mix.value(const Radius.circular(5));
      final dto2 = Mix.value(const Radius.circular(10));

      final merged = dto1.merge(dto2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(const Radius.circular(10)));
    });

    test('fromValue works', () {
      const radius = Radius.circular(15);
      final dto = Mix.value(radius);
      // MIGRATED: Clean assertion
      expect(dto, resolvesTo(radius));
    });
  });
}
