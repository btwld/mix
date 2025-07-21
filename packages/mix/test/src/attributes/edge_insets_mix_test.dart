import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final edgeInsetsMix = EdgeInsetsMix.only(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        expect(edgeInsetsMix.top, isProp(8.0));
        expect(edgeInsetsMix.bottom, isProp(12.0));
        expect(edgeInsetsMix.left, isProp(16.0));
        expect(edgeInsetsMix.right, isProp(20.0));
      });

      test('value constructor extracts properties from EdgeInsets', () {
        const edgeInsets = EdgeInsets.only(
          top: 5.0,
          bottom: 10.0,
          left: 15.0,
          right: 20.0,
        );

        final edgeInsetsMix = EdgeInsetsMix.value(edgeInsets);

        expect(edgeInsetsMix.top, isProp(5.0));
        expect(edgeInsetsMix.bottom, isProp(10.0));
        expect(edgeInsetsMix.left, isProp(15.0));
        expect(edgeInsetsMix.right, isProp(20.0));
      });

      test('all constructor creates uniform insets', () {
        final edgeInsetsMix = EdgeInsetsMix.all(16.0);

        expect(edgeInsetsMix.top, isProp(16.0));
        expect(edgeInsetsMix.bottom, isProp(16.0));
        expect(edgeInsetsMix.left, isProp(16.0));
        expect(edgeInsetsMix.right, isProp(16.0));
      });

      test('none constructor creates zero insets', () {
        final edgeInsetsMix = EdgeInsetsMix.none();

        expect(edgeInsetsMix.top, isProp(0.0));
        expect(edgeInsetsMix.bottom, isProp(0.0));
        expect(edgeInsetsMix.left, isProp(0.0));
        expect(edgeInsetsMix.right, isProp(0.0));
      });

      test('maybeValue returns null for null input', () {
        final result = EdgeInsetsMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns EdgeInsetsMix for non-null input', () {
        const edgeInsets = EdgeInsets.all(8.0);
        final result = EdgeInsetsMix.maybeValue(edgeInsets);

        expect(result, isNotNull);
        expect(result!.top, isProp(8.0));
      });
    });

    group('resolve', () {
      test('resolves to EdgeInsets with correct properties', () {
        final edgeInsetsMix = EdgeInsetsMix.only(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        final context = MockBuildContext();
        final resolved = edgeInsetsMix.resolve(context);

        expect(resolved.top, 8.0);
        expect(resolved.bottom, 12.0);
        expect(resolved.left, 16.0);
        expect(resolved.right, 20.0);
      });

      test('uses zero for null properties', () {
        final edgeInsetsMix = EdgeInsetsMix.only(
          top: 8.0,
          left: 16.0,
        );

        final context = MockBuildContext();
        final resolved = edgeInsetsMix.resolve(context);

        expect(resolved.top, 8.0);
        expect(resolved.bottom, 0.0);
        expect(resolved.left, 16.0);
        expect(resolved.right, 0.0);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final edgeInsetsMix = EdgeInsetsMix.only(top: 8.0);
        final merged = edgeInsetsMix.merge(null);

        expect(merged, same(edgeInsetsMix));
      });

      test('merges properties correctly', () {
        final first = EdgeInsetsMix.only(
          top: 8.0,
          left: 16.0,
        );

        final second = EdgeInsetsMix.only(
          top: 12.0,
          right: 20.0,
        );

        final merged = first.merge(second);

        expect(merged.top, isProp(12.0));
        expect(merged.bottom, isNull);
        expect(merged.left, isProp(16.0));
        expect(merged.right, isProp(20.0));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final edgeInsetsMix1 = EdgeInsetsMix.only(
          top: 8.0,
          left: 16.0,
        );

        final edgeInsetsMix2 = EdgeInsetsMix.only(
          top: 8.0,
          left: 16.0,
        );

        expect(edgeInsetsMix1, edgeInsetsMix2);
        expect(edgeInsetsMix1.hashCode, edgeInsetsMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final edgeInsetsMix1 = EdgeInsetsMix.only(top: 8.0);
        final edgeInsetsMix2 = EdgeInsetsMix.only(top: 12.0);

        expect(edgeInsetsMix1, isNot(edgeInsetsMix2));
      });
    });
  });

  group('EdgeInsetsDirectionalMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        expect(edgeInsetsDirectionalMix.top, isProp(8.0));
        expect(edgeInsetsDirectionalMix.bottom, isProp(12.0));
        expect(edgeInsetsDirectionalMix.start, isProp(16.0));
        expect(edgeInsetsDirectionalMix.end, isProp(20.0));
      });

      test('value constructor extracts properties from EdgeInsetsDirectional', () {
        const edgeInsets = EdgeInsetsDirectional.only(
          top: 5.0,
          bottom: 10.0,
          start: 15.0,
          end: 20.0,
        );

        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.value(edgeInsets);

        expect(edgeInsetsDirectionalMix.top, isProp(5.0));
        expect(edgeInsetsDirectionalMix.bottom, isProp(10.0));
        expect(edgeInsetsDirectionalMix.start, isProp(15.0));
        expect(edgeInsetsDirectionalMix.end, isProp(20.0));
      });

      test('all constructor creates uniform insets', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.all(16.0);

        expect(edgeInsetsDirectionalMix.top, isProp(16.0));
        expect(edgeInsetsDirectionalMix.bottom, isProp(16.0));
        expect(edgeInsetsDirectionalMix.start, isProp(16.0));
        expect(edgeInsetsDirectionalMix.end, isProp(16.0));
      });

      test('none constructor creates zero insets', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.none();

        expect(edgeInsetsDirectionalMix.top, isProp(0.0));
        expect(edgeInsetsDirectionalMix.bottom, isProp(0.0));
        expect(edgeInsetsDirectionalMix.start, isProp(0.0));
        expect(edgeInsetsDirectionalMix.end, isProp(0.0));
      });

      test('maybeValue returns null for null input', () {
        final result = EdgeInsetsDirectionalMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns EdgeInsetsDirectionalMix for non-null input', () {
        const edgeInsets = EdgeInsetsDirectional.all(8.0);
        final result = EdgeInsetsDirectionalMix.maybeValue(edgeInsets);

        expect(result, isNotNull);
        expect(result!.top, isProp(8.0));
      });
    });

    group('resolve', () {
      test('resolves to EdgeInsetsDirectional with correct properties', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        final context = MockBuildContext();
        final resolved = edgeInsetsDirectionalMix.resolve(context);

        expect(resolved.top, 8.0);
        expect(resolved.bottom, 12.0);
        expect(resolved.start, 16.0);
        expect(resolved.end, 20.0);
      });
    });

    group('merge', () {
      test('returns this when other is null', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.only(top: 8.0);
        final merged = edgeInsetsDirectionalMix.merge(null);

        expect(merged, same(edgeInsetsDirectionalMix));
      });

      test('merges properties correctly', () {
        final first = EdgeInsetsDirectionalMix.only(
          top: 8.0,
          start: 16.0,
        );

        final second = EdgeInsetsDirectionalMix.only(
          top: 12.0,
          end: 20.0,
        );

        final merged = first.merge(second);

        expect(merged.top, isProp(12.0));
        expect(merged.bottom, isNull);
        expect(merged.start, isProp(16.0));
        expect(merged.end, isProp(20.0));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final edgeInsetsDirectionalMix1 = EdgeInsetsDirectionalMix.only(
          top: 8.0,
          start: 16.0,
        );

        final edgeInsetsDirectionalMix2 = EdgeInsetsDirectionalMix.only(
          top: 8.0,
          start: 16.0,
        );

        expect(edgeInsetsDirectionalMix1, edgeInsetsDirectionalMix2);
        expect(edgeInsetsDirectionalMix1.hashCode, edgeInsetsDirectionalMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final edgeInsetsDirectionalMix1 = EdgeInsetsDirectionalMix.only(top: 8.0);
        final edgeInsetsDirectionalMix2 = EdgeInsetsDirectionalMix.only(top: 12.0);

        expect(edgeInsetsDirectionalMix1, isNot(edgeInsetsDirectionalMix2));
      });
    });
  });
}
