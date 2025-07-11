import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/custom_matchers.dart';
import '../../helpers/testing_utils.dart';

void main() {
  group('ClipPathModifierSpec', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();

    const clipBehavior = Clip.antiAlias;

    test('Constructor assigns clipper correctly', () {
      const modifier =
          ClipPathModifierSpec(clipBehavior: clipBehavior, clipper: clipper);

      expect(modifier.clipper, clipper);
      expect(modifier.clipBehavior, clipBehavior);
    });

    test('Lerp method interpolates correctly', () {
      const start = ClipPathModifierSpec(clipper: clipper);
      const end = ClipPathModifierSpec(clipper: clipper2);
      final result = start.lerp(end, 0.5);

      expect(result.clipper, clipper2);
    });

    test('Equality and hashcode test', () {
      const spec1 =
          ClipPathModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const spec2 =
          ClipPathModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const spec3 =
          ClipPathModifierSpec(clipBehavior: clipBehavior, clipper: clipper2);

      expect(spec1, spec2);
      expect(spec1.hashCode, spec2.hashCode);
      expect(spec1 == spec3, false);
      expect(spec1.hashCode == spec3.hashCode, false);
    });

    testWidgets(
      'Build method creates ClipPath widget with correct clipper',
      (WidgetTester tester) async {
        const modifier = ClipPathModifierSpec(clipper: clipper);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final ClipPath clipPathWidget = tester.widget(find.byType(ClipPath));

        expect(find.byType(ClipPath), findsOneWidget);
        expect(clipPathWidget.clipper, clipper);
        expect(clipPathWidget.clipBehavior, clipBehavior);
        expect(clipPathWidget.child, isA<Container>());
      },
    );
  });

  // ClipPathModifierSpecAttribute
  group('ClipPathModifierSpecAttribute', () {
    const clipper = _PathClipper();
    const clipper2 = _OtherPathClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    test('merge', () {
      const modifier = ClipPathModifierSpecAttribute(
          clipper: clipper, clipBehavior: clipBehavior);
      const other = ClipPathModifierSpecAttribute(
          clipper: clipper2, clipBehavior: clipBehavior2);
      final result = modifier.merge(other);
      expect(result, other);
    });

    test('resolve', () {
      const modifier = ClipPathModifierSpecAttribute(
          clipper: clipper, clipBehavior: clipBehavior);
      expect(modifier, resolvesTo(const ClipPathModifierSpec(
          clipper: clipper, clipBehavior: clipBehavior)));
    });
  });

  group('ClipRRectModifierSpec', () {
    final borderRadius = BorderRadius.circular(10.0);
    final borderRadius2 = BorderRadius.circular(20.0);
    const clipper = _RRectClipper();
    const clipper2 = _OtherRRectClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    test('Constructor assigns borderRadius correctly', () {
      final modifier = ClipRRectModifierSpec(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        clipper: clipper,
      );

      expect(modifier.borderRadius, borderRadius);
      expect(modifier.clipBehavior, clipBehavior);
      expect(modifier.clipper, clipper);
    });

    test('Lerp method interpolates correctly', () {
      final start = ClipRRectModifierSpec(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        clipper: clipper,
      );
      final end = ClipRRectModifierSpec(
        borderRadius: borderRadius2,
        clipBehavior: clipBehavior2,
        clipper: clipper2,
      );
      final result = start.lerp(end, 0.5);

      expect(result.borderRadius, BorderRadius.circular(15));
      expect(result.clipBehavior, clipBehavior2);
      expect(result.clipper, clipper2);
    });

    test('Equality and hashcode test', () {
      final modifier1 = ClipRRectModifierSpec(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        clipper: clipper,
      );
      final modifier2 = ClipRRectModifierSpec(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        clipper: clipper,
      );
      final modifier3 = ClipRRectModifierSpec(
        borderRadius: borderRadius2,
        clipBehavior: clipBehavior2,
        clipper: clipper2,
      );

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });
  });

  // ClipRRectModifierSpecAttribute
  group('ClipRRectModifierSpecAttribute', () {
    final borderRadius = BorderRadius.circular(10.0);
    final borderRadius2 = BorderRadius.circular(20.0);
    const clipper = _RRectClipper();
    const clipper2 = _OtherRRectClipper();
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    test('merge', () {
      final modifier = ClipRRectModifierSpecAttribute(
        borderRadius: BorderRadiusDto.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      final other = ClipRRectModifierSpecAttribute(
        borderRadius: BorderRadiusDto.value(borderRadius2),
        clipper: clipper2,
        clipBehavior: clipBehavior2,
      );
      final result = modifier.merge(other);
      expect(result, other);
    });

    test('resolve', () {
      final modifier = ClipRRectModifierSpecAttribute(
        borderRadius: BorderRadiusDto.value(borderRadius),
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      expect(modifier, resolvesTo(ClipRRectModifierSpec(
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        clipper: clipper,
      )));
    });
  });

  // ClipOvalModifierSpec
  group('ClipOvalModifierSpec', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;
    const clipper = _RectClipper();
    const clipper2 = _OtherRectClipper();

    test('Constructor assigns clipper correctly', () {
      const modifier = ClipOvalModifierSpec(
        clipBehavior: clipBehavior,
        clipper: clipper,
      );

      expect(modifier.clipper, clipper);
      expect(modifier.clipBehavior, clipBehavior);
    });

    test('Lerp method interpolates correctly', () {
      const start =
          ClipOvalModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const end =
          ClipOvalModifierSpec(clipBehavior: clipBehavior2, clipper: clipper2);
      final result = start.lerp(end, 0.5);

      expect(result.clipper, clipper2);
      expect(result.clipBehavior, clipBehavior2);
    });

    test('Equality and hashcode test', () {
      const modifier1 =
          ClipOvalModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const modifier2 =
          ClipOvalModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const modifier3 =
          ClipOvalModifierSpec(clipBehavior: clipBehavior2, clipper: clipper2);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates ClipOval widget with correct clipper',
      (WidgetTester tester) async {
        const modifier = ClipOvalModifierSpec(clipper: clipper);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final ClipOval clipOvalWidget = tester.widget(find.byType(ClipOval));

        expect(find.byType(ClipOval), findsOneWidget);
        expect(clipOvalWidget.clipper, clipper);
        expect(clipOvalWidget.clipBehavior, clipBehavior);
        expect(clipOvalWidget.child, isA<Container>());
      },
    );
  });

  // ClipOvalModifierSpecAttribute
  group('ClipOvalModifierSpecAttribute', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;
    const clipper = _RectClipper();
    const clipper2 = _OtherRectClipper();

    test('merge', () {
      const modifier = ClipOvalModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      const other = ClipOvalModifierSpecAttribute(
        clipper: clipper2,
        clipBehavior: clipBehavior2,
      );
      final result = modifier.merge(other);
      expect(result, other);
    });

    test('resolve', () {
      const modifier = ClipOvalModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      expect(modifier, resolvesTo(const ClipOvalModifierSpec(
        clipper: clipper,
        clipBehavior: clipBehavior,
      )));
    });
  });

  // ClipRectModifierSpec
  group('ClipRectModifierSpec', () {
    const clipBehavior = Clip.hardEdge;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;
    const clipper = _RectClipper();
    const clipper2 = _OtherRectClipper();

    test('Constructor assigns clipper correctly', () {
      const modifier = ClipRectModifierSpec(
        clipBehavior: clipBehavior,
        clipper: clipper,
      );

      expect(modifier.clipper, clipper);
      expect(modifier.clipBehavior, clipBehavior);
    });

    test('Lerp method interpolates correctly', () {
      const start =
          ClipRectModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const end =
          ClipRectModifierSpec(clipBehavior: clipBehavior2, clipper: clipper2);
      final result = start.lerp(end, 0.5);

      expect(result.clipper, clipper2);
      expect(result.clipBehavior, clipBehavior2);
    });

    test('Equality and hashcode test', () {
      const modifier1 =
          ClipRectModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const modifier2 =
          ClipRectModifierSpec(clipBehavior: clipBehavior, clipper: clipper);
      const modifier3 =
          ClipRectModifierSpec(clipBehavior: clipBehavior2, clipper: clipper2);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates ClipRect widget with correct clipper',
      (WidgetTester tester) async {
        const modifier = ClipRectModifierSpec(clipper: clipper);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final ClipRect clipRectWidget = tester.widget(find.byType(ClipRect));

        expect(find.byType(ClipRect), findsOneWidget);
        expect(clipRectWidget.clipper, clipper);
        expect(clipRectWidget.clipBehavior, clipBehavior);
        expect(clipRectWidget.child, isA<Container>());
      },
    );
  });

  // ClipRectModifierSpecAttribute
  group('ClipRectModifierSpecAttribute', () {
    const clipBehavior = Clip.hardEdge;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;
    const clipper = _RectClipper();
    const clipper2 = _OtherRectClipper();

    test('merge', () {
      const modifier = ClipRectModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      const other = ClipRectModifierSpecAttribute(
        clipper: clipper2,
        clipBehavior: clipBehavior2,
      );
      final result = modifier.merge(other);
      expect(result, other);
    });

    test('resolve', () {
      const modifier = ClipRectModifierSpecAttribute(
        clipper: clipper,
        clipBehavior: clipBehavior,
      );
      expect(modifier, resolvesTo(const ClipRectModifierSpec(
        clipper: clipper,
        clipBehavior: clipBehavior,
      )));
    });
  });

  // ClipTriangleModifierSpec
  group('ClipTriangleModifierSpec', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    test('Constructor assigns clipper correctly', () {
      const modifier = ClipTriangleModifierSpec(clipBehavior: clipBehavior);

      expect(modifier.clipBehavior, clipBehavior);
    });

    test('Lerp method interpolates correctly', () {
      const start = ClipTriangleModifierSpec(clipBehavior: clipBehavior);
      const end = ClipTriangleModifierSpec(clipBehavior: clipBehavior2);
      final result = start.lerp(end, 0.5);

      expect(result.clipBehavior, clipBehavior2);
    });

    test('Equality and hashcode test', () {
      const modifier1 = ClipTriangleModifierSpec(clipBehavior: clipBehavior);
      const modifier2 = ClipTriangleModifierSpec(clipBehavior: clipBehavior);
      const modifier3 = ClipTriangleModifierSpec(clipBehavior: clipBehavior2);

      expect(modifier1, modifier2);
      expect(modifier1.hashCode, modifier2.hashCode);
      expect(modifier1 == modifier3, false);
      expect(modifier1.hashCode == modifier3.hashCode, false);
    });

    testWidgets(
      'Build method creates ClipPath widget with correct clipper',
      (WidgetTester tester) async {
        const modifier = ClipTriangleModifierSpec(clipBehavior: clipBehavior);

        await tester.pumpMaterialApp(modifier.build(Container()));

        final ClipPath clipPathWidget = tester.widget(find.byType(ClipPath));

        expect(find.byType(ClipPath), findsOneWidget);
        expect(clipPathWidget.clipper, isA<TriangleClipper>());
        expect(clipPathWidget.clipBehavior, clipBehavior);
        expect(clipPathWidget.child, isA<Container>());
      },
    );
  });

  // ClipTriangleModifierSpecAttribute
  group('ClipTriangleModifierSpecAttribute', () {
    const clipBehavior = Clip.antiAlias;
    const clipBehavior2 = Clip.antiAliasWithSaveLayer;

    test('merge', () {
      const modifier =
          ClipTriangleModifierSpecAttribute(clipBehavior: clipBehavior);
      const other =
          ClipTriangleModifierSpecAttribute(clipBehavior: clipBehavior2);
      final result = modifier.merge(other);
      expect(result, other);
    });

    test('resolve', () {
      const modifier =
          ClipTriangleModifierSpecAttribute(clipBehavior: clipBehavior);
      expect(modifier, resolvesTo(const ClipTriangleModifierSpec(
        clipBehavior: clipBehavior,
      )));
    });
  });
}

class _PathClipper extends CustomClipper<Path> {
  const _PathClipper();
  @override
  Path getClip(Size size) {
    return Path();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _OtherPathClipper extends _PathClipper {
  const _OtherPathClipper();
}

class _RectClipper extends CustomClipper<Rect> {
  const _RectClipper();
  @override
  Rect getClip(Size size) {
    return Rect.zero;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _OtherRectClipper extends _RectClipper {
  const _OtherRectClipper();
}

class _RRectClipper extends CustomClipper<RRect> {
  const _RRectClipper();
  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(Rect.zero, Radius.zero);
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    return false;
  }
}

class _OtherRRectClipper extends _RRectClipper {
  const _OtherRRectClipper();
}
