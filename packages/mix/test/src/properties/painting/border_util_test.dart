import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

// Test class that extends MockStyle and uses BorderMixin
class TestBorderStyle extends MockStyle<BoxBorderMix>
    with BorderMixin<TestBorderStyle> {
  TestBorderStyle([BoxBorderMix? value]) : super(value ?? BorderMix());

  @override
  TestBorderStyle border(BoxBorderMix value) {
    return TestBorderStyle(value);
  }
}

void main() {
  group('BorderMixin', () {
    late TestBorderStyle style;

    setUp(() {
      style = TestBorderStyle();
    });

    group('borderWidth method', () {
      test('sets all border widths with all parameter', () {
        final result = style.borderWidth(all: 2.0);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(width: 2.0));
      });

      test('sets horizontal border widths', () {
        final result = style.borderWidth(horizontal: 3.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            left: BorderSide(width: 3.0),
            right: BorderSide(width: 3.0),
          ),
        );
      });

      test('sets vertical border widths', () {
        final result = style.borderWidth(vertical: 4.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(width: 4.0),
            bottom: BorderSide(width: 4.0),
          ),
        );
      });

      test('sets specific border widths', () {
        final result = style.borderWidth(
          top: 1.0,
          bottom: 2.0,
          left: 3.0,
          right: 4.0,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          Border(
            top: BorderSide(width: 1.0),
            bottom: BorderSide(width: 2.0),
            left: BorderSide(width: 3.0),
            right: BorderSide(width: 4.0),
          ),
        );
      });

      test('sets logical border widths', () {
        final result = style.borderWidth(start: 2.0, end: 3.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          BorderDirectional(
            start: BorderSide(width: 2.0),
            end: BorderSide(width: 3.0),
          ),
        );
      });

      test('priority order: specific sides override horizontal/vertical', () {
        final result = style.borderWidth(all: 1.0, horizontal: 2.0, left: 3.0);
        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          Border(
            top: BorderSide(width: 1.0),
            bottom: BorderSide(width: 1.0),
            left: BorderSide(width: 3.0),
            right: BorderSide(width: 2.0),
          ),
        );
      });

      test('priority order: horizontal/vertical sets all sides', () {
        final result = style.borderWidth(horizontal: 2.0, vertical: 3.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(width: 3.0),
            bottom: BorderSide(width: 3.0),
            left: BorderSide(width: 2.0),
            right: BorderSide(width: 2.0),
          ),
        );
      });

      test('throws error when mixing physical and logical properties', () {
        expect(
          () => style.borderWidth(left: 1.0, start: 2.0),
          throwsArgumentError,
        );
      });

      test('throws error when mixing right and end properties', () {
        expect(
          () => style.borderWidth(right: 1.0, end: 2.0),
          throwsArgumentError,
        );
      });
    });

    group('borderColor method', () {
      test('sets all border colors with all parameter', () {
        final result = style.borderColor(all: Colors.red);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(color: Colors.red));
      });

      test('sets horizontal border colors', () {
        final result = style.borderColor(horizontal: Colors.blue);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            left: BorderSide(color: Colors.blue),
            right: BorderSide(color: Colors.blue),
          ),
        );
      });

      test('sets vertical border colors', () {
        final result = style.borderColor(vertical: Colors.green);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(color: Colors.green),
            bottom: BorderSide(color: Colors.green),
          ),
        );
      });

      test('sets specific border colors', () {
        final result = style.borderColor(
          top: Colors.red,
          bottom: Colors.blue,
          left: Colors.green,
          right: Colors.yellow,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(color: Colors.red),
            bottom: BorderSide(color: Colors.blue),
            left: BorderSide(color: Colors.green),
            right: BorderSide(color: Colors.yellow),
          ),
        );
      });

      test('sets logical border colors', () {
        final result = style.borderColor(
          start: Colors.orange,
          end: Colors.purple,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            start: BorderSide(color: Colors.orange),
            end: BorderSide(color: Colors.purple),
          ),
        );
      });

      test('priority order works correctly', () {
        final result = style.borderColor(
          all: Colors.black,
          vertical: Colors.white,
          top: Colors.red,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(color: Colors.red),
            bottom: BorderSide(color: Colors.white),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          ),
        );
      });

      test('throws error when mixing physical and logical properties', () {
        expect(
          () => style.borderColor(left: Colors.red, start: Colors.blue),
          throwsArgumentError,
        );
      });
    });

    group('borderStyle method', () {
      test('sets all border styles with all parameter', () {
        final result = style.borderStyle(all: BorderStyle.solid);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(style: BorderStyle.solid));
      });

      test('sets horizontal border styles', () {
        final result = style.borderStyle(horizontal: BorderStyle.none);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            left: BorderSide(style: BorderStyle.none),
            right: BorderSide(style: BorderStyle.none),
          ),
        );
      });

      test('sets vertical border styles', () {
        final result = style.borderStyle(vertical: BorderStyle.solid);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(style: BorderStyle.solid),
            bottom: BorderSide(style: BorderStyle.solid),
          ),
        );
      });

      test('sets specific border styles', () {
        final result = style.borderStyle(
          top: BorderStyle.solid,
          bottom: BorderStyle.none,
          left: BorderStyle.solid,
          right: BorderStyle.none,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(style: BorderStyle.solid),
            bottom: BorderSide(style: BorderStyle.none),
            left: BorderSide(style: BorderStyle.solid),
            right: BorderSide(style: BorderStyle.none),
          ),
        );
      });

      test('sets logical border styles', () {
        final result = style.borderStyle(
          start: BorderStyle.solid,
          end: BorderStyle.none,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            start: BorderSide(style: BorderStyle.solid),
            end: BorderSide(style: BorderStyle.none),
          ),
        );
      });

      test('throws error when mixing physical and logical properties', () {
        expect(
          () => style.borderStyle(
            left: BorderStyle.solid,
            start: BorderStyle.none,
          ),
          throwsArgumentError,
        );
      });
    });
  });

  group('BoxBorderUtility', () {
    late BoxBorderUtility<MockStyle<BoxBorderMix>> util;

    setUp(() {
      util = BoxBorderUtility<MockStyle<BoxBorderMix>>(MockStyle.new);
    });

    test('has border property', () {
      expect(util.border, isA<BorderUtility>());
    });

    test('has borderDirectional property', () {
      expect(util.borderDirectional, isA<BorderDirectionalUtility>());
    });

    test('call method creates BoxBorderMix', () {
      final borderMix = BorderMix(
        top: BorderSideMix(width: 2.0, color: Colors.red),
      );
      final result = util(borderMix);

      expect(result.value, borderMix);
    });

    test('as method accepts BoxBorder', () {
      const border = Border(
        top: BorderSide(width: 2.0, color: Colors.red),
        bottom: BorderSide(width: 1.0, color: Colors.blue),
      );
      final result = util.as(border);

      expect(
        result.value,
        BorderMix(
          top: BorderSideMix(
            width: 2.0,
            color: Colors.red,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
          bottom: BorderSideMix(
            width: 1.0,
            color: Colors.blue,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
        ),
      );
    });
  });

  group('BorderUtility', () {
    late BorderUtility<MockStyle<BorderMix>> util;

    setUp(() {
      util = BorderUtility<MockStyle<BorderMix>>((mix) => MockStyle(mix));
    });

    group('side utilities', () {
      test('all utility sets all sides', () {
        final result = util.all(width: 2.0, color: Colors.red);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(width: 2.0, color: Colors.red));
      });

      test('top utility sets top side', () {
        final result = util.top(width: 3.0, color: Colors.blue);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(top: BorderSide(width: 3.0, color: Colors.blue)),
        );
      });

      test('bottom utility sets bottom side', () {
        final result = util.bottom(width: 1.0, color: Colors.green);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(bottom: BorderSide(width: 1.0, color: Colors.green)),
        );
      });

      test('left utility sets left side', () {
        final result = util.left(width: 4.0, color: Colors.yellow);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(left: BorderSide(width: 4.0, color: Colors.yellow)),
        );
      });

      test('right utility sets right side', () {
        final result = util.right(width: 0.5, color: Colors.purple);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(right: BorderSide(width: 0.5, color: Colors.purple)),
        );
      });

      test('vertical utility sets top and bottom sides', () {
        final result = util.vertical(width: 2.5, color: Colors.orange);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(width: 2.5, color: Colors.orange),
            bottom: BorderSide(width: 2.5, color: Colors.orange),
          ),
        );
      });

      test('horizontal utility sets left and right sides', () {
        final result = util.horizontal(width: 1.5, color: Colors.pink);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            left: BorderSide(width: 1.5, color: Colors.pink),
            right: BorderSide(width: 1.5, color: Colors.pink),
          ),
        );
      });
    });

    group('convenience utilities', () {
      test('color utility sets color for all sides', () {
        final result = util.color(Colors.red);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(color: Colors.red));
      });

      test('style utility sets style for all sides', () {
        final result = util.style(BorderStyle.solid);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(style: BorderStyle.solid));
      });

      test('width utility sets width for all sides', () {
        final result = util.width(3.0);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(width: 3.0));
      });

      test('strokeAlign utility sets strokeAlign for all sides', () {
        final result = util.strokeAlign(0.5);

        final border = result.value.resolve(MockBuildContext());

        expect(border, Border.all(strokeAlign: 0.5));
      });
    });

    group('none and only methods', () {
      test('none method sets BorderSide.none for all sides', () {
        final result = util.none();

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide.none,
            bottom: BorderSide.none,
            left: BorderSide.none,
            right: BorderSide.none,
          ),
        );
      });

      test('only method sets specified sides', () {
        final topSide = BorderSideMix(width: 2.0, color: Colors.red);
        final leftSide = BorderSideMix(width: 1.0, color: Colors.blue);

        final result = util.only(top: topSide, left: leftSide);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border(
            top: BorderSide(width: 2.0, color: Colors.red),
            left: BorderSide(width: 1.0, color: Colors.blue),
          ),
        );
      });
    });

    test('call method creates uniform border', () {
      final result = util(
        color: Colors.black,
        width: 2.0,
        style: BorderStyle.solid,
        strokeAlign: 0.0,
      );

      final border = result.value.resolve(MockBuildContext());

      expect(
        border,
        Border.all(
          color: Colors.black,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 0.0,
        ),
      );
    });

    test('as method accepts Border', () {
      const border = Border(
        top: BorderSide(width: 1.0, color: Colors.red),
        bottom: BorderSide(width: 2.0, color: Colors.blue),
      );
      final result = util.as(border);

      expect(
        result.value,
        BorderMix(
          top: BorderSideMix(
            width: 1.0,
            color: Colors.red,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
          bottom: BorderSideMix(
            width: 2.0,
            color: Colors.blue,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
        ),
      );
    });
  });

  group('BorderDirectionalUtility', () {
    late BorderDirectionalUtility<MockStyle<BorderDirectionalMix>> util;

    setUp(() {
      util = BorderDirectionalUtility<MockStyle<BorderDirectionalMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('side utilities', () {
      test('all utility sets all sides', () {
        final result = util.all(width: 2.0, color: Colors.red);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            top: BorderSide(width: 2.0, color: Colors.red),
            bottom: BorderSide(width: 2.0, color: Colors.red),
            start: BorderSide(width: 2.0, color: Colors.red),
            end: BorderSide(width: 2.0, color: Colors.red),
          ),
        );
      });

      test('start utility sets start side', () {
        final result = util.start(width: 3.0, color: Colors.blue);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            start: BorderSide(width: 3.0, color: Colors.blue),
          ),
        );
      });

      test('end utility sets end side', () {
        final result = util.end(width: 1.0, color: Colors.green);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            end: BorderSide(width: 1.0, color: Colors.green),
          ),
        );
      });

      test('horizontal utility sets start and end sides', () {
        final result = util.horizontal(width: 1.5, color: Colors.pink);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            start: BorderSide(width: 1.5, color: Colors.pink),
            end: BorderSide(width: 1.5, color: Colors.pink),
          ),
        );
      });
    });

    test('none method sets BorderSide.none for all sides', () {
      final result = util.none();

      final border = result.value.resolve(MockBuildContext());

      expect(
        border,
        const BorderDirectional(
          top: BorderSide.none,
          bottom: BorderSide.none,
          start: BorderSide.none,
          end: BorderSide.none,
        ),
      );
    });

    test('only method sets specified sides', () {
      final topSide = BorderSideMix(width: 2.0, color: Colors.red);
      final startSide = BorderSideMix(width: 1.0, color: Colors.blue);

      final result = util.only(top: topSide, start: startSide);

      final border = result.value.resolve(MockBuildContext());

      expect(
        border,
        const BorderDirectional(
          top: BorderSide(width: 2.0, color: Colors.red),
          start: BorderSide(width: 1.0, color: Colors.blue),
        ),
      );
    });

    test('as method accepts BorderDirectional', () {
      const border = BorderDirectional(
        top: BorderSide(width: 1.0, color: Colors.red),
        start: BorderSide(width: 2.0, color: Colors.blue),
      );
      final result = util.as(border);

      expect(
        result.value,
        BorderDirectionalMix(
          top: BorderSideMix(
            width: 1.0,
            color: Colors.red,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
          start: BorderSideMix(
            width: 2.0,
            color: Colors.blue,
            style: BorderStyle.solid,
            strokeAlign: -1.0,
          ),
        ),
      );
    });
  });

  group('BorderSideUtility', () {
    late BorderSideUtility<MockStyle<BorderSideMix>> util;

    setUp(() {
      util = BorderSideUtility<MockStyle<BorderSideMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('property utilities', () {
      test('color utility sets color', () {
        final result = util.color(Colors.red);

        final borderSide = result.value.resolve(MockBuildContext());

        expect(borderSide, const BorderSide(color: Colors.red));
      });

      test('width utility sets width', () {
        final result = util.width(3.0);

        final borderSide = result.value.resolve(MockBuildContext());

        expect(borderSide, const BorderSide(width: 3.0));
      });

      test('style utility sets style', () {
        final result = util.style(BorderStyle.solid);

        final borderSide = result.value.resolve(MockBuildContext());

        expect(borderSide, const BorderSide(style: BorderStyle.solid));
      });

      test('strokeAlign utility sets strokeAlign', () {
        final result = util.strokeAlign(0.5);

        final borderSide = result.value.resolve(MockBuildContext());

        expect(borderSide, const BorderSide(strokeAlign: 0.5));
      });
    });

    test('none method creates BorderSideMix.none', () {
      final result = util.none();
      expect(result.value, BorderSideMix.none);
    });

    test('only method sets specified properties', () {
      final result = util.only(
        color: Colors.blue,
        width: 2.0,
        style: BorderStyle.solid,
        strokeAlign: 0.0,
      );

      final borderSide = result.value.resolve(MockBuildContext());

      expect(
        borderSide,
        const BorderSide(
          color: Colors.blue,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: 0.0,
        ),
      );
    });

    test('call method delegates to only', () {
      final result = util(
        color: Colors.green,
        width: 1.5,
        style: BorderStyle.solid,
        strokeAlign: 1.0,
      );

      final borderSide = result.value.resolve(MockBuildContext());

      expect(
        borderSide,
        const BorderSide(
          color: Colors.green,
          width: 1.5,
          style: BorderStyle.solid,
          strokeAlign: 1.0,
        ),
      );
    });

    test('as method accepts BorderSide', () {
      const borderSide = BorderSide(
        color: Colors.red,
        width: 2.0,
        style: BorderStyle.solid,
      );
      final result = util.as(borderSide);

      expect(
        result.value,
        BorderSideMix(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
          strokeAlign: -1.0,
        ),
      );
    });
  });
}
