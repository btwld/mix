import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('ShadowListMix merge behavior', () {
    test('merges shadow lists by replacement', () {
      final list1 = ShadowListMix([
        ShadowMix(blurRadius: 5.0, color: Colors.black),
        ShadowMix(blurRadius: 3.0, color: Colors.grey),
      ]);

      final list2 = ShadowListMix([
        ShadowMix(blurRadius: 8.0, color: Colors.red),
      ]);

      final merged = list1.merge(list2);

      expect(merged.items.length, 1);
      expect(merged.items[0].resolve(MockBuildContext()).blurRadius, 8.0);
      expect(merged.items[0].resolve(MockBuildContext()).color, Colors.red);
    });

    test('returns original list when merging with null', () {
      final list = ShadowListMix([
        ShadowMix(blurRadius: 5.0, color: Colors.black),
      ]);

      final merged = list.merge(null);

      expect(merged.items.length, 1);
      expect(merged.items[0].resolve(MockBuildContext()).blurRadius, 5.0);
      expect(merged.items[0].resolve(MockBuildContext()).color, Colors.black);
    });

    test('resolves shadow list to List<Shadow>', () {
      final shadowList = ShadowListMix([
        ShadowMix(blurRadius: 5.0, color: Colors.black),
        ShadowMix(blurRadius: 3.0, color: Colors.grey),
      ]);

      final resolved = shadowList.resolve(MockBuildContext());

      expect(resolved, isA<List<Shadow>>());
      expect(resolved.length, 2);
      expect(resolved[0].blurRadius, 5.0);
      expect(resolved[0].color, Colors.black);
      expect(resolved[1].blurRadius, 3.0);
      expect(resolved[1].color, Colors.grey);
    });

    test('has correct equality and props', () {
      final shadows = [
        ShadowMix(blurRadius: 5.0, color: Colors.black),
        ShadowMix(blurRadius: 3.0, color: Colors.grey),
      ];

      final list1 = ShadowListMix(shadows);
      final list2 = ShadowListMix(shadows);
      final list3 = ShadowListMix([ShadowMix(blurRadius: 8.0, color: Colors.red)]);

      expect(list1.props, equals(list2.props));
      expect(list1.props, isNot(equals(list3.props)));
    });
  });

  group('BoxShadowListMix merge behavior', () {
    test('merges box shadow lists by replacement', () {
      final list1 = BoxShadowListMix([
        BoxShadowMix(blurRadius: 5.0, color: Colors.black, spreadRadius: 1.0),
        BoxShadowMix(blurRadius: 3.0, color: Colors.grey, spreadRadius: 2.0),
      ]);

      final list2 = BoxShadowListMix([
        BoxShadowMix(blurRadius: 8.0, color: Colors.red, spreadRadius: 3.0),
      ]);

      final merged = list1.merge(list2);

      expect(merged.items.length, 1);
      final resolved = merged.items[0].resolve(MockBuildContext());
      expect(resolved.blurRadius, 8.0);
      expect(resolved.color, Colors.red);
      expect(resolved.spreadRadius, 3.0);
    });

    test('returns original list when merging with null', () {
      final list = BoxShadowListMix([
        BoxShadowMix(blurRadius: 5.0, color: Colors.black, spreadRadius: 1.0),
      ]);

      final merged = list.merge(null);

      expect(merged.items.length, 1);
      final resolved = merged.items[0].resolve(MockBuildContext());
      expect(resolved.blurRadius, 5.0);
      expect(resolved.color, Colors.black);
      expect(resolved.spreadRadius, 1.0);
    });

    test('resolves box shadow list to List<BoxShadow>', () {
      final shadowList = BoxShadowListMix([
        BoxShadowMix(blurRadius: 5.0, color: Colors.black, spreadRadius: 1.0),
        BoxShadowMix(blurRadius: 3.0, color: Colors.grey, spreadRadius: 2.0),
      ]);

      final resolved = shadowList.resolve(MockBuildContext());

      expect(resolved, isA<List<BoxShadow>>());
      expect(resolved.length, 2);
      expect(resolved[0].blurRadius, 5.0);
      expect(resolved[0].color, Colors.black);
      expect(resolved[0].spreadRadius, 1.0);
      expect(resolved[1].blurRadius, 3.0);
      expect(resolved[1].color, Colors.grey);
      expect(resolved[1].spreadRadius, 2.0);
    });

    test('has correct equality and props', () {
      final shadows = [
        BoxShadowMix(blurRadius: 5.0, color: Colors.black, spreadRadius: 1.0),
        BoxShadowMix(blurRadius: 3.0, color: Colors.grey, spreadRadius: 2.0),
      ];

      final list1 = BoxShadowListMix(shadows);
      final list2 = BoxShadowListMix(shadows);
      final list3 = BoxShadowListMix([BoxShadowMix(blurRadius: 8.0, color: Colors.red)]);

      expect(list1.props, equals(list2.props));
      expect(list1.props, isNot(equals(list3.props)));
    });
  });
}
