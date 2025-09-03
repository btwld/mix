import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/properties/painting/decoration_mixin.dart';

import '../../../helpers/testing_utils.dart';

// Test class that extends MockStyle and uses BorderMixin
class TestBorderStyle extends MockStyle<DecorationMix>
    with BorderMixin<TestBorderStyle>, DecorationMixin<TestBorderStyle> {
  TestBorderStyle([DecorationMix? value]) : super(value ?? BoxDecorationMix());

  @override
  TestBorderStyle decoration(DecorationMix value) {
    return TestBorderStyle(value);
  }

  @override
  TestBorderStyle border(BoxBorderMix value) {
    return decoration(DecorationMix.border(value));
  }

  @override
  TestBorderStyle borderRadius(BorderRadiusGeometryMix value) {
    return decoration(DecorationMix.borderRadius(value));
  }

  @override
  TestBorderStyle color(Color value) {
    return decoration(DecorationMix.color(value));
  }

  @override
  TestBorderStyle gradient(GradientMix value) {
    return decoration(DecorationMix.gradient(value));
  }

  @override
  TestBorderStyle shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix.boxShadow([value]));
  }

  @override
  TestBorderStyle shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix.boxShadow(value));
  }

  @override
  TestBorderStyle elevation(ElevationShadow value) {
    return decoration(
      BoxDecorationMix.boxShadow(BoxShadowMix.fromElevation(value)),
    );
  }

  @override
  TestBorderStyle image(DecorationImageMix value) {
    return decoration(DecorationMix.image(value));
  }

  @override
  TestBorderStyle shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }
}

void main() {
  group('BorderMixin', () {
    late TestBorderStyle style;

    setUp(() {
      style = TestBorderStyle();
    });

    group('individual border methods', () {
      test('borderTop sets top border', () {
        final result = style.borderTop(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.top,
          const BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderBottom sets bottom border', () {
        final result = style.borderBottom(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.bottom,
          const BorderSide(
            color: Colors.blue,
            width: 3.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderLeft sets left border', () {
        final result = style.borderLeft(
          color: Colors.green,
          width: 1.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.left,
          const BorderSide(
            color: Colors.green,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderRight sets right border', () {
        final result = style.borderRight(
          color: Colors.yellow,
          width: 4.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.right,
          const BorderSide(
            color: Colors.yellow,
            width: 4.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderStart sets start border', () {
        final result = style.borderStart(
          color: Colors.orange,
          width: 2.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as BorderDirectional;

        expect(
          border.start,
          const BorderSide(
            color: Colors.orange,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderEnd sets end border', () {
        final result = style.borderEnd(
          color: Colors.purple,
          width: 3.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as BorderDirectional;

        expect(
          border.end,
          const BorderSide(
            color: Colors.purple,
            width: 3.0,
            style: BorderStyle.solid,
          ),
        );
      });
    });

    group('grouped border methods', () {
      test('borderVertical sets left and right borders', () {
        final result = style.borderVertical(
          color: Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.left,
          const BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
        expect(
          border.right,
          const BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderHorizontal sets top and bottom borders', () {
        final result = style.borderHorizontal(
          color: Colors.blue,
          width: 3.0,
          style: BorderStyle.solid,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(
          border.top,
          const BorderSide(
            color: Colors.blue,
            width: 3.0,
            style: BorderStyle.solid,
          ),
        );
        expect(
          border.bottom,
          const BorderSide(
            color: Colors.blue,
            width: 3.0,
            style: BorderStyle.solid,
          ),
        );
      });

      test('borderAll sets all borders', () {
        final result = style.borderAll(
          color: Colors.green,
          width: 1.5,
          style: BorderStyle.solid,
          strokeAlign: 0.5,
        );

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        const expectedSide = BorderSide(
          color: Colors.green,
          width: 1.5,
          style: BorderStyle.solid,
          strokeAlign: 0.5,
        );

        expect(border.top, expectedSide);
        expect(border.bottom, expectedSide);
        expect(border.left, expectedSide);
        expect(border.right, expectedSide);
      });
    });

    group('border method with BorderMix', () {
      test('accepts BorderMix directly', () {
        final borderMix = BorderMix(
          top: BorderSideMix(color: Colors.red, width: 2.0),
          bottom: BorderSideMix(color: Colors.blue, width: 3.0),
        );
        final result = style.border(borderMix);

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as Border;

        expect(border.top, const BorderSide(color: Colors.red, width: 2.0));
        expect(border.bottom, const BorderSide(color: Colors.blue, width: 3.0));
      });

      test('accepts BorderDirectionalMix', () {
        final borderMix = BorderDirectionalMix(
          start: BorderSideMix(color: Colors.green, width: 1.0),
          end: BorderSideMix(color: Colors.yellow, width: 2.0),
        );
        final result = style.border(borderMix);

        final decoration =
            result.value.resolve(MockBuildContext()) as BoxDecoration;
        final border = decoration.border as BorderDirectional;

        expect(border.start, const BorderSide(color: Colors.green, width: 1.0));
        expect(border.end, const BorderSide(color: Colors.yellow, width: 2.0));
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

      test('vertical utility sets left and right sides', () {
        final result = util.vertical(width: 2.5, color: Colors.orange);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border.symmetric(
            vertical: BorderSide(width: 2.5, color: Colors.orange),
          ),
        );
      });

      test('horizontal utility sets top and bottom sides', () {
        final result = util.horizontal(width: 1.5, color: Colors.pink);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const Border.symmetric(
            horizontal: BorderSide(width: 1.5, color: Colors.pink),
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
      final topBorder = BorderSide(width: 1.0, color: Colors.red);

      final bottomBorder = BorderSide(width: 2.0, color: Colors.blue);
      final border = Border(top: topBorder, bottom: bottomBorder);
      final result = util.as(border);

      expect(
        result.value,
        BorderMix(
          top: BorderSideMix(
            width: topBorder.width,
            color: topBorder.color,
            style: topBorder.style,
            strokeAlign: topBorder.strokeAlign,
          ),
          bottom: BorderSideMix(
            width: bottomBorder.width,
            color: bottomBorder.color,
            style: bottomBorder.style,
            strokeAlign: bottomBorder.strokeAlign,
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

      test('vertical utility sets top and bottom sides', () {
        final result = util.vertical(width: 2.5, color: Colors.orange);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BorderDirectional(
            top: BorderSide(width: 2.5, color: Colors.orange),
            bottom: BorderSide(width: 2.5, color: Colors.orange),
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
      final result = util(
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
