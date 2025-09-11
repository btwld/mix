import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final edgeInsetsMix = EdgeInsetsMix(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        expect(edgeInsetsMix.$top, resolvesTo(8.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(12.0));
        expect(edgeInsetsMix.$left, resolvesTo(16.0));
        expect(edgeInsetsMix.$right, resolvesTo(20.0));
      });

      test('value constructor extracts properties from EdgeInsets', () {
        final edgeInsets = EdgeInsets.only(
          top: 5.0,
          bottom: 10.0,
          left: 15.0,
          right: 20.0,
        );

        final edgeInsetsMix = EdgeInsetsMix.value(edgeInsets);

        expect(edgeInsetsMix.$top, resolvesTo(5.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(10.0));
        expect(edgeInsetsMix.$left, resolvesTo(15.0));
        expect(edgeInsetsMix.$right, resolvesTo(20.0));
      });

      test('all constructor creates uniform insets', () {
        final edgeInsetsMix = EdgeInsetsMix.all(16.0);

        expect(edgeInsetsMix.$top, resolvesTo(16.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(16.0));
        expect(edgeInsetsMix.$left, resolvesTo(16.0));
        expect(edgeInsetsMix.$right, resolvesTo(16.0));
      });

      test('none constructor creates zero insets', () {
        final edgeInsetsMix = EdgeInsetsMix.none();

        expect(edgeInsetsMix.$top, resolvesTo(0.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(0.0));
        expect(edgeInsetsMix.$left, resolvesTo(0.0));
        expect(edgeInsetsMix.$right, resolvesTo(0.0));
      });

      test('maybeValue returns null for null input', () {
        final result = EdgeInsetsMix.maybeValue(null);
        expect(result, isNull);
      });

      test('maybeValue returns EdgeInsetsMix for non-null input', () {
        const edgeInsets = EdgeInsets.all(8.0);
        final result = EdgeInsetsMix.maybeValue(edgeInsets);

        expect(result, isNotNull);
        expect(result!.$top, resolvesTo(8.0));
        expect(result.$bottom, resolvesTo(8.0));
        expect(result.$left, resolvesTo(8.0));
        expect(result.$right, resolvesTo(8.0));
      });
    });

    group('Factory Constructors', () {
      test('symmetric factory creates EdgeInsetsMix with symmetric insets', () {
        final edgeInsetsMix = EdgeInsetsMix.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        );

        expect(edgeInsetsMix.$top, resolvesTo(10.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(10.0));
        expect(edgeInsetsMix.$left, resolvesTo(20.0));
        expect(edgeInsetsMix.$right, resolvesTo(20.0));
      });

      test(
        'horizontal factory creates EdgeInsetsMix with horizontal insets',
        () {
          final edgeInsetsMix = EdgeInsetsMix.horizontal(15.0);

          expect(edgeInsetsMix.$left, resolvesTo(15.0));
          expect(edgeInsetsMix.$right, resolvesTo(15.0));
          expect(edgeInsetsMix.$top, isNull);
          expect(edgeInsetsMix.$bottom, isNull);
        },
      );

      test('vertical factory creates EdgeInsetsMix with vertical insets', () {
        final edgeInsetsMix = EdgeInsetsMix.vertical(12.0);

        expect(edgeInsetsMix.$top, resolvesTo(12.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(12.0));
        expect(edgeInsetsMix.$left, isNull);
        expect(edgeInsetsMix.$right, isNull);
      });

      test('fromLTRB factory creates EdgeInsetsMix with specific values', () {
        final edgeInsetsMix = EdgeInsetsMix.fromLTRB(5.0, 10.0, 15.0, 20.0);

        expect(edgeInsetsMix.$left, resolvesTo(5.0));
        expect(edgeInsetsMix.$top, resolvesTo(10.0));
        expect(edgeInsetsMix.$right, resolvesTo(15.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(20.0));
      });
    });

    group('Utility Methods', () {
      test('top utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().top(10.0);

        expect(edgeInsetsMix.$top, resolvesTo(10.0));
      });

      test('bottom utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().bottom(12.0);

        expect(edgeInsetsMix.$bottom, resolvesTo(12.0));
      });

      test('left utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().left(8.0);

        expect(edgeInsetsMix.$left, resolvesTo(8.0));
      });

      test('right utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().right(15.0);

        expect(edgeInsetsMix.$right, resolvesTo(15.0));
      });

      test('all factory works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix.all(16.0);

        expect(edgeInsetsMix.$top, resolvesTo(16.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(16.0));
        expect(edgeInsetsMix.$left, resolvesTo(16.0));
        expect(edgeInsetsMix.$right, resolvesTo(16.0));
      });

      test('symmetric utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        );

        expect(edgeInsetsMix.$top, resolvesTo(10.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(10.0));
        expect(edgeInsetsMix.$left, resolvesTo(20.0));
        expect(edgeInsetsMix.$right, resolvesTo(20.0));
      });

      test('only utility works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix().only(
          left: 5.0,
          top: 10.0,
          right: 15.0,
          bottom: 20.0,
        );

        expect(edgeInsetsMix.$left, resolvesTo(5.0));
        expect(edgeInsetsMix.$top, resolvesTo(10.0));
        expect(edgeInsetsMix.$right, resolvesTo(15.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(20.0));
      });

      test('fromLTRB factory works correctly', () {
        final edgeInsetsMix = EdgeInsetsMix.fromLTRB(5.0, 10.0, 15.0, 20.0);

        expect(edgeInsetsMix.$left, resolvesTo(5.0));
        expect(edgeInsetsMix.$top, resolvesTo(10.0));
        expect(edgeInsetsMix.$right, resolvesTo(15.0));
        expect(edgeInsetsMix.$bottom, resolvesTo(20.0));
      });
    });

    group('resolve', () {
      test('resolves to EdgeInsets with correct properties', () {
        final edgeInsetsMix = EdgeInsetsMix(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        const resolvedValue = EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        expect(edgeInsetsMix, resolvesTo(resolvedValue));
      });

      test('uses zero for null properties', () {
        final edgeInsetsMix = EdgeInsetsMix(top: 8.0, left: 16.0);

        const resolvedValue = EdgeInsets.only(
          top: 8.0,
          bottom: 0.0,
          left: 16.0,
          right: 0.0,
        );

        expect(edgeInsetsMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns equivalent instance when other is null', () {
        final edgeInsetsMix = EdgeInsetsMix(top: 8.0);
        final merged = edgeInsetsMix.merge(null);

        expect(identical(merged, edgeInsetsMix), isFalse);
        expect(merged, equals(edgeInsetsMix));
      });

      test('merges properties correctly', () {
        final first = EdgeInsetsMix(top: 8.0, left: 16.0);

        final second = EdgeInsetsMix(top: 12.0, right: 20.0);

        final merged = first.merge(second);

        expect(merged.$top, resolvesTo(12.0));
        expect(merged.$bottom, isNull);
        expect(merged.$left, resolvesTo(16.0));
        expect(merged.$right, resolvesTo(20.0));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final edgeInsetsMix1 = EdgeInsetsMix(top: 8.0, left: 16.0);

        final edgeInsetsMix2 = EdgeInsetsMix(top: 8.0, left: 16.0);

        expect(edgeInsetsMix1, edgeInsetsMix2);
        expect(edgeInsetsMix1.hashCode, edgeInsetsMix2.hashCode);
      });

      test('returns false when properties are different', () {
        final edgeInsetsMix1 = EdgeInsetsMix(top: 8.0);
        final edgeInsetsMix2 = EdgeInsetsMix(top: 12.0);

        expect(edgeInsetsMix1, isNot(edgeInsetsMix2));
      });
    });

    group('Props getter', () {
      test('props includes all properties', () {
        final edgeInsetsMix = EdgeInsetsMix(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        expect(edgeInsetsMix.props.length, 4);
        expect(edgeInsetsMix.props, contains(edgeInsetsMix.$top));
        expect(edgeInsetsMix.props, contains(edgeInsetsMix.$bottom));
        expect(edgeInsetsMix.props, contains(edgeInsetsMix.$left));
        expect(edgeInsetsMix.props, contains(edgeInsetsMix.$right));
      });
    });
  });

  group('EdgeInsetsDirectionalMix', () {
    group('Constructor', () {
      test('only constructor creates instance with correct properties', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        expect(edgeInsetsDirectionalMix.$top, resolvesTo(8.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(12.0));
        expect(edgeInsetsDirectionalMix.$start, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(20.0));
      });

      test(
        'value constructor extracts properties from EdgeInsetsDirectional',
        () {
          const edgeInsets = EdgeInsetsDirectional.only(
            top: 5.0,
            bottom: 10.0,
            start: 15.0,
            end: 20.0,
          );

          final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.value(
            edgeInsets,
          );

          expect(edgeInsetsDirectionalMix.$top, resolvesTo(5.0));
          expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(10.0));
          expect(edgeInsetsDirectionalMix.$start, resolvesTo(15.0));
          expect(edgeInsetsDirectionalMix.$end, resolvesTo(20.0));
        },
      );

      test('all constructor creates uniform insets', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.all(16.0);

        expect(edgeInsetsDirectionalMix.$top, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$start, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(16.0));
      });

      test('none constructor creates zero insets', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.none();

        expect(edgeInsetsDirectionalMix.$top, resolvesTo(0.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(0.0));
        expect(edgeInsetsDirectionalMix.$start, resolvesTo(0.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(0.0));
      });

      test('maybeValue returns null for null input', () {
        final result = EdgeInsetsDirectionalMix.maybeValue(null);
        expect(result, isNull);
      });

      test(
        'maybeValue returns EdgeInsetsDirectionalMix for non-null input',
        () {
          const edgeInsets = EdgeInsetsDirectional.all(8.0);
          final result = EdgeInsetsDirectionalMix.maybeValue(edgeInsets);

          expect(result, isNotNull);
          expect(result!.$top, resolvesTo(8.0));
        },
      );
    });

    group('resolve', () {
      test('resolves to EdgeInsetsDirectional with correct properties', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        const resolvedValue = EdgeInsetsDirectional.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        expect(edgeInsetsDirectionalMix, resolvesTo(resolvedValue));
      });
    });

    group('merge', () {
      test('returns equivalent instance when other is null', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix(top: 8.0);
        final merged = edgeInsetsDirectionalMix.merge(null);

        expect(identical(merged, edgeInsetsDirectionalMix), isFalse);
        expect(merged, equals(edgeInsetsDirectionalMix));
      });

      test('merges properties correctly', () {
        final first = EdgeInsetsDirectionalMix(top: 8.0, start: 16.0);

        final second = EdgeInsetsDirectionalMix(top: 12.0, end: 20.0);

        final merged = first.merge(second);

        expect(merged.$top, resolvesTo(12.0));
        expect(merged.$bottom, isNull);
        expect(merged.$start, resolvesTo(16.0));
        expect(merged.$end, resolvesTo(20.0));
      });
    });

    group('Utility Methods', () {
      test('all factory works correctly', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.all(16.0);

        expect(edgeInsetsDirectionalMix.$top, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$start, resolvesTo(16.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(16.0));
      });

      test('symmetric utility works correctly', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix().symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        );

        expect(edgeInsetsDirectionalMix.$top, resolvesTo(10.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(10.0));
        expect(edgeInsetsDirectionalMix.$start, resolvesTo(20.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(20.0));
      });

      test('directional utility works correctly', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix().directional(
          start: 5.0,
          top: 10.0,
          end: 15.0,
          bottom: 20.0,
        );

        expect(edgeInsetsDirectionalMix.$start, resolvesTo(5.0));
        expect(edgeInsetsDirectionalMix.$top, resolvesTo(10.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(15.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(20.0));
      });

      test('fromSTEB factory works correctly', () {
        final edgeInsetsDirectionalMix = EdgeInsetsDirectionalMix.fromSTEB(
          5.0,
          10.0,
          15.0,
          20.0,
        );

        expect(edgeInsetsDirectionalMix.$start, resolvesTo(5.0));
        expect(edgeInsetsDirectionalMix.$top, resolvesTo(10.0));
        expect(edgeInsetsDirectionalMix.$end, resolvesTo(15.0));
        expect(edgeInsetsDirectionalMix.$bottom, resolvesTo(20.0));
      });
    });

    group('Equality', () {
      test('returns true when all properties are the same', () {
        final edgeInsetsDirectionalMix1 = EdgeInsetsDirectionalMix(
          top: 8.0,
          start: 16.0,
        );

        final edgeInsetsDirectionalMix2 = EdgeInsetsDirectionalMix(
          top: 8.0,
          start: 16.0,
        );

        expect(edgeInsetsDirectionalMix1, edgeInsetsDirectionalMix2);
        expect(
          edgeInsetsDirectionalMix1.hashCode,
          edgeInsetsDirectionalMix2.hashCode,
        );
      });

      test('returns false when properties are different', () {
        final edgeInsetsDirectionalMix1 = EdgeInsetsDirectionalMix(top: 8.0);
        final edgeInsetsDirectionalMix2 = EdgeInsetsDirectionalMix(top: 12.0);

        expect(edgeInsetsDirectionalMix1, isNot(edgeInsetsDirectionalMix2));
      });
    });
  });
}
