import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsGeometryUtility', () {
    late EdgeInsetsGeometryUtility<MockStyle<EdgeInsetsGeometryMix>> util;

    setUp(() {
      util = EdgeInsetsGeometryUtility<MockStyle<EdgeInsetsGeometryMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has directional utility', () {
        expect(util.directional, isA<EdgeInsetsDirectionalUtility>());
      });

      test('has horizontal utility', () {
        expect(util.horizontal, isA<SpacingSideUtility>());
      });

      test('has vertical utility', () {
        expect(util.vertical, isA<SpacingSideUtility>());
      });

      test('has all utility', () {
        expect(util.all, isA<SpacingSideUtility>());
      });

      test('has top utility', () {
        expect(util.top, isA<SpacingSideUtility>());
      });

      test('has bottom utility', () {
        expect(util.bottom, isA<SpacingSideUtility>());
      });

      test('has left utility', () {
        expect(util.left, isA<SpacingSideUtility>());
      });

      test('has right utility', () {
        expect(util.right, isA<SpacingSideUtility>());
      });
    });

    group('spacing utilities', () {
      test('all sets all sides', () {
        final result = util.all(16.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.all(16.0));
      });

      test('horizontal sets left and right sides', () {
        final result = util.horizontal(20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.symmetric(horizontal: 20.0));
      });

      test('vertical sets top and bottom sides', () {
        final result = util.vertical(12.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.symmetric(vertical: 12.0));
      });

      test('top sets only top side', () {
        final result = util.top(8.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.only(top: 8.0));
      });

      test('bottom sets only bottom side', () {
        final result = util.bottom(10.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.only(bottom: 10.0));
      });

      test('left sets only left side', () {
        final result = util.left(14.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.only(left: 14.0));
      });

      test('right sets only right side', () {
        final result = util.right(18.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.only(right: 18.0));
      });
    });

    group('only method', () {
      test('sets individual sides with physical properties', () {
        final result = util.only(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsets.only(
            top: 8.0,
            bottom: 12.0,
            left: 16.0,
            right: 20.0,
          ),
        );
      });

      test('sets individual sides with logical properties', () {
        final result = util.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.only(
            top: 8.0,
            bottom: 12.0,
            start: 16.0,
            end: 20.0,
          ),
        );
      });

      test('handles partial properties', () {
        final result = util.only(top: 10.0, left: 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.only(top: 10.0, left: 20.0));
      });

      test('handles null values', () {
        final result = util.only();

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, EdgeInsets.zero);
      });
    });

    group('call method', () {
      test('single parameter sets all sides', () {
        final result = util(16.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsets.all(16.0));
      });

      test('two parameters set vertical and horizontal', () {
        final result = util(12.0, 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        );
      });

      test('three parameters set top, horizontal, bottom', () {
        final result = util(8.0, 16.0, 12.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsets.only(
            top: 8.0,
            left: 16.0,
            right: 16.0,
            bottom: 12.0,
          ),
        );
      });

      test('four parameters set top, right, bottom, left', () {
        final result = util(8.0, 16.0, 12.0, 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsets.only(
            top: 8.0,
            right: 16.0,
            bottom: 12.0,
            left: 20.0,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts EdgeInsets', () {
        const edgeInsets = EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
          left: 16.0,
          right: 20.0,
        );
        final result = util.as(edgeInsets);

        expect(
          result.value,
          EdgeInsetsMix(top: 8.0, bottom: 12.0, left: 16.0, right: 20.0),
        );
      });

      test('accepts EdgeInsetsDirectional', () {
        const edgeInsets = EdgeInsetsDirectional.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );
        final result = util.as(edgeInsets);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, edgeInsets);
      });
    });

    group('directional utility access', () {
      test(
        'directional property provides access to EdgeInsetsDirectionalUtility',
        () {
          final directionalResult = util.directional.all(16.0);

          final edgeInsets = directionalResult.value.resolve(
            MockBuildContext(),
          );

          expect(edgeInsets, const EdgeInsetsDirectional.all(16.0));
        },
      );
    });
  });

  group('EdgeInsetsDirectionalUtility', () {
    late EdgeInsetsDirectionalUtility<MockStyle<EdgeInsetsDirectionalMix>> util;

    setUp(() {
      util = EdgeInsetsDirectionalUtility<MockStyle<EdgeInsetsDirectionalMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has all utility', () {
        expect(util.all, isA<SpacingSideUtility>());
      });

      test('has start utility', () {
        expect(util.start, isA<SpacingSideUtility>());
      });

      test('has end utility', () {
        expect(util.end, isA<SpacingSideUtility>());
      });

      test('has top utility', () {
        expect(util.top, isA<SpacingSideUtility>());
      });

      test('has bottom utility', () {
        expect(util.bottom, isA<SpacingSideUtility>());
      });

      test('has vertical utility', () {
        expect(util.vertical, isA<SpacingSideUtility>());
      });

      test('has horizontal utility', () {
        expect(util.horizontal, isA<SpacingSideUtility>());
      });
    });

    group('spacing utilities', () {
      test('all sets all sides', () {
        final result = util.all(16.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.all(16.0));
      });

      test('horizontal sets start and end sides', () {
        final result = util.horizontal(20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        );
      });

      test('vertical sets top and bottom sides', () {
        final result = util.vertical(12.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.symmetric(vertical: 12.0),
        );
      });

      test('start sets only start side', () {
        final result = util.start(14.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.only(start: 14.0));
      });

      test('end sets only end side', () {
        final result = util.end(18.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.only(end: 18.0));
      });

      test('top sets only top side', () {
        final result = util.top(8.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.only(top: 8.0));
      });

      test('bottom sets only bottom side', () {
        final result = util.bottom(10.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.only(bottom: 10.0));
      });
    });

    group('only method', () {
      test('sets individual sides', () {
        final result = util.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.only(
            top: 8.0,
            bottom: 12.0,
            start: 16.0,
            end: 20.0,
          ),
        );
      });

      test('handles partial properties', () {
        final result = util.only(top: 10.0, start: 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.only(top: 10.0, start: 20.0),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, EdgeInsetsDirectional.zero);
      });
    });

    group('call method', () {
      test('single parameter sets all sides', () {
        final result = util(16.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(edgeInsets, const EdgeInsetsDirectional.all(16.0));
      });

      test('two parameters set vertical and horizontal', () {
        final result = util(12.0, 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.symmetric(
            vertical: 12.0,
            horizontal: 20.0,
          ),
        );
      });

      test('three parameters set top, horizontal, bottom', () {
        final result = util(8.0, 16.0, 12.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.only(
            top: 8.0,
            start: 16.0,
            end: 16.0,
            bottom: 12.0,
          ),
        );
      });

      test('four parameters set top, end, bottom, start', () {
        final result = util(8.0, 16.0, 12.0, 20.0);

        final edgeInsets = result.value.resolve(MockBuildContext());

        expect(
          edgeInsets,
          const EdgeInsetsDirectional.only(
            top: 8.0,
            end: 16.0,
            bottom: 12.0,
            start: 20.0,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts EdgeInsetsDirectional', () {
        const edgeInsets = EdgeInsetsDirectional.only(
          top: 8.0,
          bottom: 12.0,
          start: 16.0,
          end: 20.0,
        );
        final result = util.as(edgeInsets);

        expect(
          result.value,
          EdgeInsetsDirectionalMix(
            top: 8.0,
            bottom: 12.0,
            start: 16.0,
            end: 20.0,
          ),
        );
      });
    });
  });
}
