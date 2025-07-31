import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('RoundedRectangleBorderUtility', () {
    late RoundedRectangleBorderUtility<MockStyle<RoundedRectangleBorderMix>>
        util;

    setUp(() {
      util = RoundedRectangleBorderUtility<
          MockStyle<RoundedRectangleBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has borderRadius utility', () {
        expect(util.borderRadius, isA<BorderRadiusGeometryUtility>());
      });

      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });
    });

    group('property setters', () {
      test('borderRadius sets border radius', () {
        final result = util.borderRadius.borderRadius.all(Radius.circular(8.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        );
      });

      test('side sets border side', () {
        const side = BorderSide(color: Colors.red, width: 2.0);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const RoundedRectangleBorder(side: side));
      });
    });

    group('only method', () {
      test('sets specific properties', () {
        const radius = BorderRadius.all(Radius.circular(12.0));
        const side = BorderSide(color: Colors.blue, width: 3.0);
        final result = util.only(
          borderRadius: BorderRadiusGeometryMix.value(radius),
          side: BorderSideMix.value(side),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const RoundedRectangleBorder(
            borderRadius: radius,
            side: side,
          ),
        );
      });

      test('handles partial properties', () {
        const radius = BorderRadius.all(Radius.circular(6.0));
        final result = util.only(
          borderRadius: BorderRadiusGeometryMix.value(radius),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const RoundedRectangleBorder(borderRadius: radius),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final border = result.value.resolve(MockBuildContext());

        expect(border, const RoundedRectangleBorder());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const radius = BorderRadius.all(Radius.circular(10.0));
        const side = BorderSide(color: Colors.green, width: 1.5);
        final result = util(
          borderRadius: BorderRadiusGeometryMix.value(radius),
          side: BorderSideMix.value(side),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const RoundedRectangleBorder(
            borderRadius: radius,
            side: side,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts RoundedRectangleBorder', () {
        const border = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          side: BorderSide(color: Colors.purple, width: 4.0),
        );
        final result = util.as(border);

        expect(result.value, isA<RoundedRectangleBorderMix>());
        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('BeveledRectangleBorderUtility', () {
    late BeveledRectangleBorderUtility<MockStyle<BeveledRectangleBorderMix>>
        util;

    setUp(() {
      util = BeveledRectangleBorderUtility<MockStyle<BeveledRectangleBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has borderRadius utility', () {
        expect(util.borderRadius, isA<BorderRadiusGeometryUtility>());
      });

      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });
    });

    group('property setters', () {
      test('borderRadius sets border radius', () {
        final result = util.borderRadius.borderRadius.all(Radius.circular(6.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
        );
      });

      test('side sets border side', () {
        const side = BorderSide(color: Colors.orange, width: 2.5);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const BeveledRectangleBorder(side: side));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const radius = BorderRadius.all(Radius.circular(8.0));
        const side = BorderSide(color: Colors.cyan, width: 1.0);
        final result = util.only(
          borderRadius: BorderRadiusGeometryMix.value(radius),
          side: BorderSideMix.value(side),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BeveledRectangleBorder(
            borderRadius: radius,
            side: side,
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const radius = BorderRadius.all(Radius.circular(4.0));
        final result = util(
          borderRadius: BorderRadiusGeometryMix.value(radius),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BeveledRectangleBorder(borderRadius: radius),
        );
      });
    });

    group('as method', () {
      test('accepts BeveledRectangleBorder', () {
        const border = BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          side: BorderSide(color: Colors.pink, width: 3.0),
        );
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('ContinuousRectangleBorderUtility', () {
    late ContinuousRectangleBorderUtility<
        MockStyle<ContinuousRectangleBorderMix>> util;

    setUp(() {
      util = ContinuousRectangleBorderUtility<
          MockStyle<ContinuousRectangleBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has borderRadius utility', () {
        expect(util.borderRadius, isA<BorderRadiusGeometryUtility>());
      });

      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });
    });

    group('property setters', () {
      test('borderRadius sets border radius', () {
        final result = util.borderRadius.borderRadius.all(Radius.circular(16.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        );
      });

      test('side sets border side', () {
        const side = BorderSide(color: Colors.yellow, width: 1.5);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const ContinuousRectangleBorder(side: side));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const radius = BorderRadius.all(Radius.circular(20.0));
        const side = BorderSide(color: Colors.teal, width: 2.0);
        final result = util.only(
          borderRadius: BorderRadiusGeometryMix.value(radius),
          side: BorderSideMix.value(side),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const ContinuousRectangleBorder(
            borderRadius: radius,
            side: side,
          ),
        );
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const radius = BorderRadius.all(Radius.circular(14.0));
        final result = util(
          borderRadius: BorderRadiusGeometryMix.value(radius),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const ContinuousRectangleBorder(borderRadius: radius),
        );
      });
    });

    group('as method', () {
      test('accepts ContinuousRectangleBorder', () {
        const border = ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
          side: BorderSide(color: Colors.indigo, width: 2.5),
        );
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('CircleBorderUtility', () {
    late CircleBorderUtility<MockStyle<CircleBorderMix>> util;

    setUp(() {
      util = CircleBorderUtility<MockStyle<CircleBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });

      test('has eccentricity utility', () {
        expect(util.eccentricity, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('side sets border side', () {
        const side = BorderSide(color: Colors.red, width: 3.0);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const CircleBorder(side: side));
      });

      test('eccentricity sets eccentricity', () {
        final result = util.eccentricity(0.8);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const CircleBorder(eccentricity: 0.8));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const side = BorderSide(color: Colors.blue, width: 2.0);
        final result = util.only(
          side: BorderSideMix.value(side),
          eccentricity: 0.5,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const CircleBorder(
            side: side,
            eccentricity: 0.5,
          ),
        );
      });

      test('handles partial properties', () {
        final result = util.only(eccentricity: 0.3);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const CircleBorder(eccentricity: 0.3));
      });

      test('handles null values', () {
        final result = util.only();

        final border = result.value.resolve(MockBuildContext());

        expect(border, const CircleBorder());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const side = BorderSide(color: Colors.green, width: 1.0);
        final result = util(
          side: BorderSideMix.value(side),
          eccentricity: 0.7,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const CircleBorder(
            side: side,
            eccentricity: 0.7,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts CircleBorder', () {
        const border = CircleBorder(
          side: BorderSide(color: Colors.purple, width: 2.5),
          eccentricity: 0.9,
        );
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('StarBorderUtility', () {
    late StarBorderUtility<MockStyle<StarBorderMix>> util;

    setUp(() {
      util = StarBorderUtility<MockStyle<StarBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });

      test('has points utility', () {
        expect(util.points, isA<MixUtility>());
      });

      test('has innerRadiusRatio utility', () {
        expect(util.innerRadiusRatio, isA<MixUtility>());
      });

      test('has pointRounding utility', () {
        expect(util.pointRounding, isA<MixUtility>());
      });

      test('has valleyRounding utility', () {
        expect(util.valleyRounding, isA<MixUtility>());
      });

      test('has rotation utility', () {
        expect(util.rotation, isA<MixUtility>());
      });

      test('has squash utility', () {
        expect(util.squash, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('side sets border side', () {
        const side = BorderSide(color: Colors.orange, width: 2.0);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(side: side));
      });

      test('points sets number of points', () {
        final result = util.points(6.0);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(points: 6.0));
      });

      test('innerRadiusRatio sets inner radius ratio', () {
        final result = util.innerRadiusRatio(0.4);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(innerRadiusRatio: 0.4));
      });

      test('pointRounding sets point rounding', () {
        final result = util.pointRounding(0.2);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(pointRounding: 0.2));
      });

      test('valleyRounding sets valley rounding', () {
        final result = util.valleyRounding(0.3);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(valleyRounding: 0.3));
      });

      test('rotation sets rotation', () {
        final result = util.rotation(45.0);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(rotation: 45.0));
      });

      test('squash sets squash', () {
        final result = util.squash(0.8);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(squash: 0.8));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const side = BorderSide(color: Colors.red, width: 1.5);
        final result = util.only(
          side: BorderSideMix.value(side),
          points: 8.0,
          innerRadiusRatio: 0.5,
          pointRounding: 0.1,
          valleyRounding: 0.2,
          rotation: 30.0,
          squash: 0.9,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const StarBorder(
            side: side,
            points: 8.0,
            innerRadiusRatio: 0.5,
            pointRounding: 0.1,
            valleyRounding: 0.2,
            rotation: 30.0,
            squash: 0.9,
          ),
        );
      });

      test('handles partial properties', () {
        final result = util.only(
          points: 5.0,
          innerRadiusRatio: 0.3,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const StarBorder(
            points: 5.0,
            innerRadiusRatio: 0.3,
          ),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const side = BorderSide(color: Colors.blue, width: 2.5);
        final result = util(
          side: BorderSideMix.value(side),
          points: 7.0,
          rotation: 15.0,
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const StarBorder(
            side: side,
            points: 7.0,
            rotation: 15.0,
          ),
        );
      });
    });

    group('as method', () {
      test('accepts StarBorder', () {
        const border = StarBorder(
          side: BorderSide(color: Colors.yellow, width: 3.0),
          points: 10.0,
          innerRadiusRatio: 0.6,
          pointRounding: 0.15,
          valleyRounding: 0.25,
          rotation: 60.0,
          squash: 0.7,
        );
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('LinearBorderUtility', () {
    late LinearBorderUtility<MockStyle<LinearBorderMix>> util;

    setUp(() {
      util = LinearBorderUtility<MockStyle<LinearBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });

      test('has start utility', () {
        expect(util.start, isA<LinearBorderEdgeUtility>());
      });

      test('has end utility', () {
        expect(util.end, isA<LinearBorderEdgeUtility>());
      });

      test('has top utility', () {
        expect(util.top, isA<LinearBorderEdgeUtility>());
      });

      test('has bottom utility', () {
        expect(util.bottom, isA<LinearBorderEdgeUtility>());
      });
    });

    group('property setters', () {
      test('side sets border side', () {
        const side = BorderSide(color: Colors.green, width: 2.0);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const LinearBorder(side: side));
      });

      test('start sets start edge', () {
        final result = util.start(size: 0.5, alignment: 0.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            start: LinearBorderEdge(size: 0.5, alignment: 0.0),
          ),
        );
      });

      test('end sets end edge', () {
        final result = util.end(size: 0.3, alignment: 1.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            end: LinearBorderEdge(size: 0.3, alignment: 1.0),
          ),
        );
      });

      test('top sets top edge', () {
        final result = util.top(size: 0.7, alignment: 0.5);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            top: LinearBorderEdge(size: 0.7, alignment: 0.5),
          ),
        );
      });

      test('bottom sets bottom edge', () {
        final result = util.bottom(size: 0.4, alignment: -0.5);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            bottom: LinearBorderEdge(size: 0.4, alignment: -0.5),
          ),
        );
      });
    });

    group('only method', () {
      test('sets all properties', () {
        const side = BorderSide(color: Colors.purple, width: 1.0);
        final result = util.only(
          side: BorderSideMix.value(side),
          start: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.2, alignment: 0.1),
          ),
          end: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.3, alignment: 0.9),
          ),
          top: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.4, alignment: 0.0),
          ),
          bottom: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.5, alignment: 1.0),
          ),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            side: side,
            start: LinearBorderEdge(size: 0.2, alignment: 0.1),
            end: LinearBorderEdge(size: 0.3, alignment: 0.9),
            top: LinearBorderEdge(size: 0.4, alignment: 0.0),
            bottom: LinearBorderEdge(size: 0.5, alignment: 1.0),
          ),
        );
      });

      test('handles partial properties', () {
        final result = util.only(
          start: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.6),
          ),
          end: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.8),
          ),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            start: LinearBorderEdge(size: 0.6),
            end: LinearBorderEdge(size: 0.8),
          ),
        );
      });

      test('handles null values', () {
        final result = util.only();

        final border = result.value.resolve(MockBuildContext());

        expect(border, const LinearBorder());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const side = BorderSide(color: Colors.cyan, width: 1.5);
        final result = util(
          side: BorderSideMix.value(side),
          top: LinearBorderEdgeMix.value(
            const LinearBorderEdge(size: 0.9, alignment: 0.2),
          ),
        );

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            side: side,
            top: LinearBorderEdge(size: 0.9, alignment: 0.2),
          ),
        );
      });
    });

    group('as method', () {
      test('accepts LinearBorder', () {
        const border = LinearBorder(
          side: BorderSide(color: Colors.pink, width: 2.5),
          start: LinearBorderEdge(size: 0.1, alignment: 0.0),
          end: LinearBorderEdge(size: 0.2, alignment: 1.0),
          top: LinearBorderEdge(size: 0.3, alignment: 0.5),
          bottom: LinearBorderEdge(size: 0.4, alignment: -0.5),
        );
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('LinearBorderEdgeUtility', () {
    late LinearBorderEdgeUtility<MockStyle<LinearBorderEdgeMix>> util;

    setUp(() {
      util = LinearBorderEdgeUtility<MockStyle<LinearBorderEdgeMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has size utility', () {
        expect(util.size, isA<MixUtility>());
      });

      test('has alignment utility', () {
        expect(util.alignment, isA<MixUtility>());
      });
    });

    group('property setters', () {
      test('size sets edge size', () {
        final result = util.size(0.7);

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge(size: 0.7));
      });

      test('alignment sets edge alignment', () {
        final result = util.alignment(0.3);

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge(alignment: 0.3));
      });
    });

    group('only method', () {
      test('sets all properties', () {
        final result = util.only(size: 0.8, alignment: 0.6);

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge(size: 0.8, alignment: 0.6));
      });

      test('handles partial properties', () {
        final result = util.only(size: 0.4);

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge(size: 0.4));
      });

      test('handles null values', () {
        final result = util.only();

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        final result = util(size: 0.9, alignment: -0.2);

        final edge = result.value.resolve(MockBuildContext());

        expect(edge, const LinearBorderEdge(size: 0.9, alignment: -0.2));
      });
    });

    group('as method', () {
      test('accepts LinearBorderEdge', () {
        const edge = LinearBorderEdge(size: 0.5, alignment: 0.8);
        final result = util.as(edge);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, edge);
      });
    });
  });

  group('StadiumBorderUtility', () {
    late StadiumBorderUtility<MockStyle<StadiumBorderMix>> util;

    setUp(() {
      util = StadiumBorderUtility<MockStyle<StadiumBorderMix>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has side utility', () {
        expect(util.side, isA<BorderSideUtility>());
      });
    });

    group('property setters', () {
      test('side sets border side', () {
        const side = BorderSide(color: Colors.red, width: 2.0);
        final result = util.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StadiumBorder(side: side));
      });
    });

    group('only method', () {
      test('sets side property', () {
        const side = BorderSide(color: Colors.blue, width: 3.0);
        final result = util.only(side: BorderSideMix.value(side));

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StadiumBorder(side: side));
      });

      test('handles null values', () {
        final result = util.only();

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StadiumBorder());
      });
    });

    group('call method', () {
      test('delegates to only method', () {
        const side = BorderSide(color: Colors.green, width: 1.5);
        final result = util(side: BorderSideMix.value(side));

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StadiumBorder(side: side));
      });
    });

    group('as method', () {
      test('accepts StadiumBorder', () {
        const border =
            StadiumBorder(side: BorderSide(color: Colors.purple, width: 4.0));
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('ShapeBorderUtility', () {
    late ShapeBorderUtility<MockStyle<ShapeBorderMix<ShapeBorder>>> util;

    setUp(() {
      util = ShapeBorderUtility<MockStyle<ShapeBorderMix<ShapeBorder>>>(
        (mix) => MockStyle(mix),
      );
    });

    group('utility properties', () {
      test('has roundedRectangle utility', () {
        expect(util.roundedRectangle, isA<RoundedRectangleBorderUtility>());
      });

      test('has beveled utility', () {
        expect(util.beveled, isA<BeveledRectangleBorderUtility>());
      });

      test('has continuous utility', () {
        expect(util.continuous, isA<ContinuousRectangleBorderUtility>());
      });

      test('has circle utility', () {
        expect(util.circle, isA<CircleBorderUtility>());
      });

      test('has star utility', () {
        expect(util.star, isA<StarBorderUtility>());
      });

      test('has linear utility', () {
        expect(util.linear, isA<LinearBorderUtility>());
      });

      test('has stadium utility', () {
        expect(util.stadium, isA<StadiumBorderUtility>());
      });
    });

    group('shape border utilities integration', () {
      test('roundedRectangle utility works', () {
        final result = util.roundedRectangle.borderRadius.borderRadius.all(Radius.circular(10.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        );
      });

      test('beveled utility works', () {
        final result = util.beveled.borderRadius.borderRadius.all(Radius.circular(8.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        );
      });

      test('continuous utility works', () {
        final result = util.continuous.borderRadius.borderRadius.all(Radius.circular(12.0));

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        );
      });

      test('circle utility works', () {
        final result = util.circle.eccentricity(0.5);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const CircleBorder(eccentricity: 0.5));
      });

      test('star utility works', () {
        final result = util.star.points(6.0);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StarBorder(points: 6.0));
      });

      test('linear utility works', () {
        final result = util.linear.start(size: 0.5, alignment: 0.0);

        final border = result.value.resolve(MockBuildContext());

        expect(
          border,
          const LinearBorder(
            start: LinearBorderEdge(size: 0.5, alignment: 0.0),
          ),
        );
      });

      test('stadium utility works', () {
        const side = BorderSide(color: Colors.orange, width: 2.0);
        final result = util.stadium.side.as(side);

        final border = result.value.resolve(MockBuildContext());

        expect(border, const StadiumBorder(side: side));
      });
    });

    group('as method', () {
      test('accepts RoundedRectangleBorder', () {
        const border = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        );
        final result = util.as(border);

        expect(result.value, isA<ShapeBorderMix>());
        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });

      test('accepts CircleBorder', () {
        const border = CircleBorder(eccentricity: 0.8);
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });

      test('accepts StarBorder', () {
        const border = StarBorder(points: 8.0, innerRadiusRatio: 0.4);
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });

      test('accepts StadiumBorder', () {
        const border =
            StadiumBorder(side: BorderSide(color: Colors.teal, width: 1.0));
        final result = util.as(border);

        final resolved = result.value.resolve(MockBuildContext());
        expect(resolved, border);
      });
    });
  });

  group('Shape border integration tests', () {
    test('different shape borders maintain their specific properties', () {
      final roundedBorderUtil =
          RoundedRectangleBorderUtility<MockStyle<RoundedRectangleBorderMix>>(
        (mix) => MockStyle(mix),
      );
      final circleBorderUtil = CircleBorderUtility<MockStyle<CircleBorderMix>>(
        (mix) => MockStyle(mix),
      );
      final starBorderUtil = StarBorderUtility<MockStyle<StarBorderMix>>(
        (mix) => MockStyle(mix),
      );

      final rounded = roundedBorderUtil.borderRadius.borderRadius.all(Radius.circular(8.0));
      final circle = circleBorderUtil.eccentricity(0.6);
      final star = starBorderUtil.points(5.0);

      expect(rounded.value.resolve(MockBuildContext()),
          isA<RoundedRectangleBorder>());
      expect(circle.value.resolve(MockBuildContext()), isA<CircleBorder>());
      expect(star.value.resolve(MockBuildContext()), isA<StarBorder>());
    });

    test('side utilities work consistently across shape borders', () {
      final roundedBorderUtil =
          RoundedRectangleBorderUtility<MockStyle<RoundedRectangleBorderMix>>(
        (mix) => MockStyle(mix),
      );
      final circleBorderUtil = CircleBorderUtility<MockStyle<CircleBorderMix>>(
        (mix) => MockStyle(mix),
      );
      final stadiumBorderUtil =
          StadiumBorderUtility<MockStyle<StadiumBorderMix>>(
        (mix) => MockStyle(mix),
      );

      const side = BorderSide(color: Colors.red, width: 2.0);

      final roundedBorder = roundedBorderUtil.side.as(side);
      final circleBorder = circleBorderUtil.side.as(side);
      final stadiumBorder = stadiumBorderUtil.side.as(side);

      final resolvedRounded = roundedBorder.value.resolve(MockBuildContext());
      final resolvedCircle = circleBorder.value.resolve(MockBuildContext());
      final resolvedStadium = stadiumBorder.value.resolve(MockBuildContext());

      expect(resolvedRounded.side, side);
      expect(resolvedCircle.side, side);
      expect(resolvedStadium.side, side);
    });
  });

  group('Edge cases and validation', () {
    test('handles extreme eccentricity values', () {
      final util = CircleBorderUtility<MockStyle<CircleBorderMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.eccentricity(1.0);
      final border = result.value.resolve(MockBuildContext());

      expect(border.eccentricity, 1.0);
    });

    test('handles extreme star border configurations', () {
      final util = StarBorderUtility<MockStyle<StarBorderMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.only(
        points: 100.0,
        innerRadiusRatio: 0.99,
        pointRounding: 0.5,
        valleyRounding: 0.5,
        rotation: 360.0,
        squash: 0.01,
      );

      final border = result.value.resolve(MockBuildContext());

      expect(border.points, 100.0);
      expect(border.innerRadiusRatio, 0.99);
      expect(border.pointRounding, 0.5);
      expect(border.valleyRounding, 0.5);
      expect(border.rotation, 360.0);
      expect(border.squash, 0.01);
    });

    test('handles extreme linear border edge values', () {
      final util = LinearBorderEdgeUtility<MockStyle<LinearBorderEdgeMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.only(size: 1.0, alignment: -1.0);
      final edge = result.value.resolve(MockBuildContext());

      expect(edge.size, 1.0);
      expect(edge.alignment, -1.0);
    });

    test('handles complex linear border configurations', () {
      final util = LinearBorderUtility<MockStyle<LinearBorderMix>>(
        (mix) => MockStyle(mix),
      );

      final result = util.only(
        side: BorderSideMix.value(
          const BorderSide(color: Colors.black, width: 5.0),
        ),
        start: LinearBorderEdgeMix.value(
          const LinearBorderEdge(size: 1.0, alignment: 1.0),
        ),
        end: LinearBorderEdgeMix.value(
          const LinearBorderEdge(size: 0.0, alignment: -1.0),
        ),
        top: LinearBorderEdgeMix.value(
          const LinearBorderEdge(size: 0.5, alignment: 0.0),
        ),
        bottom: LinearBorderEdgeMix.value(
          const LinearBorderEdge(size: 0.75, alignment: 0.25),
        ),
      );

      final border = result.value.resolve(MockBuildContext());

      expect(border.side.width, 5.0);
      expect(border.start?.size, 1.0);
      expect(border.start?.alignment, 1.0);
      expect(border.end?.size, 0.0);
      expect(border.end?.alignment, -1.0);
      expect(border.top?.size, 0.5);
      expect(border.top?.alignment, 0.0);
      expect(border.bottom?.size, 0.75);
      expect(border.bottom?.alignment, 0.25);
    });
  });
}