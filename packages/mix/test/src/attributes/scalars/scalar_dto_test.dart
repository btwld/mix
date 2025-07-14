import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('Mixable<T>', () {
    group('Prop<String>', () {
      test('value constructor works', () {
        final prop = Prop.value('test');
        // MIGRATED: Clean assertion using custom matcher
        expect(prop, resolvesTo('test'));
      });

      // Token API has been removed in current version
      // test('token constructor works', () {
      //   // Token functionality removed from API
      // });

      test('merge creates composite', () {
        final prop1 = Prop.value('first');
        final prop2 = Prop.value('second');

        final merged = prop1.merge(prop2);
        // MIGRATED: Clean assertions - last value wins in merge
        expect(merged, resolvesTo('second'));
        expect(prop2, resolvesTo('second'));
      });
    });

    group('Prop<double>', () {
      test('value constructor works', () {
        final prop = Prop.value(42.5);
        // MIGRATED: Clean assertion
        expect(prop, resolvesTo(42.5));
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
        final prop1 = Prop.value(10.0);
        final prop2 = Prop.value(20.0);

        final merged = prop1.merge(prop2);
        // MIGRATED: Clean assertion - last value wins
        expect(merged, resolvesTo(20.0));
        expect(prop2, resolvesTo(20.0));
      });
    });

    group('Mixable<FontWeight>', () {
      test('value constructor works', () {
        final prop = Prop.value(FontWeight.bold);
        // MIGRATED: Clean assertion
        expect(prop, resolvesTo(FontWeight.bold));
      });

      // TODO: Add token tests when token resolution is properly set up
    });
  });

  group('ColorDto with composite', () {
    test('merge resolution works', () {
      final prop1 = Prop.value(Colors.red);
      final prop2 = Prop.value(Colors.blue);

      final merged = prop1.merge(prop2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(Colors.blue));
    });

    test('merge behavior is consistent', () {
      final prop1 = Prop.value(Colors.red);
      final prop2 = Prop.value(Colors.blue);

      final merged = prop1.merge(prop2);
      // MIGRATED: Clean assertions
      expect(merged, resolvesTo(Colors.blue));
      expect(prop2, resolvesTo(Colors.blue));
    });
  });

  group('RadiusDto with composite', () {
    test('merge resolution works', () {
      final prop1 = Prop.value(const Radius.circular(5));
      final prop2 = Prop.value(const Radius.circular(10));

      final merged = prop1.merge(prop2);
      // MIGRATED: Clean assertion - last value wins
      expect(merged, resolvesTo(const Radius.circular(10)));
    });

    test('fromValue works', () {
      const radius = Radius.circular(15);
      final prop = Prop.value(radius);
      // MIGRATED: Clean assertion
      expect(prop, resolvesTo(radius));
    });
  });
}
