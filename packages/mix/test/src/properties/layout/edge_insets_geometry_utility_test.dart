import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/helpers.dart';
import 'package:mix/src/core/prop.dart';
import 'package:mix/src/core/spec.dart';
import 'package:mix/src/core/style.dart';
import 'package:mix/src/properties/layout/edge_insets_geometry_mix.dart';
import 'package:mix/src/properties/layout/edge_insets_geometry_util.dart';

// Test spec class
class TestSpec extends Spec<TestSpec> {
  @override
  TestSpec copyWith() => this;

  @override
  TestSpec lerp(TestSpec? other, double t) => this;

  @override
  List<Object?> get props => [];
}

// Test attribute class for utility testing
class TestAttribute extends StyleAttribute<TestSpec> {
  final MixProp<EdgeInsetsGeometry>? edgeInsets;

  const TestAttribute({this.edgeInsets});

  @override
  TestAttribute merge(TestAttribute? other) {
    if (other == null) return this;
    return TestAttribute(
      edgeInsets: MixHelpers.merge(edgeInsets, other.edgeInsets),
    );
  }

  @override
  TestSpec resolve(Object context) => TestSpec();

  @override
  List<Object?> get props => [edgeInsets];
}

void main() {
  group('EdgeInsetsGeometryUtility', () {
    late EdgeInsetsGeometryUtility<TestAttribute> utility;

    setUp(() {
      utility = EdgeInsetsGeometryUtility<TestAttribute>(
        (prop) => TestAttribute(edgeInsets: prop),
      );
    });

    test('all() creates EdgeInsetsMix with all sides equal', () {
      final result = utility.all(16.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top?.value, 16.0);
      expect(mix.$bottom?.value, 16.0);
      expect(mix.$left?.value, 16.0);
      expect(mix.$right?.value, 16.0);
    });

    test('symmetric() creates EdgeInsetsMix with symmetric values', () {
      final result = utility.symmetric(vertical: 10.0, horizontal: 20.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top?.value, 10.0);
      expect(mix.$bottom?.value, 10.0);
      expect(mix.$left?.value, 20.0);
      expect(mix.$right?.value, 20.0);
    });

    test('horizontal() creates EdgeInsetsMix with horizontal values', () {
      final result = utility.horizontal(15.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top, isNull);
      expect(mix.$bottom, isNull);
      expect(mix.$left?.value, 15.0);
      expect(mix.$right?.value, 15.0);
    });

    test('vertical() creates EdgeInsetsMix with vertical values', () {
      final result = utility.vertical(25.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top?.value, 25.0);
      expect(mix.$bottom?.value, 25.0);
      expect(mix.$left, isNull);
      expect(mix.$right, isNull);
    });

    test('only() creates EdgeInsetsMix with specific values', () {
      final result = utility.only(
        top: 10.0,
        bottom: 20.0,
        left: 30.0,
        right: 40.0,
      );

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top?.value, 10.0);
      expect(mix.$bottom?.value, 20.0);
      expect(mix.$left?.value, 30.0);
      expect(mix.$right?.value, 40.0);
    });

    test('top() creates EdgeInsetsMix with only top value', () {
      final result = utility.top(12.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top?.value, 12.0);
      expect(mix.$bottom, isNull);
      expect(mix.$left, isNull);
      expect(mix.$right, isNull);
    });

    test('bottom() creates EdgeInsetsMix with only bottom value', () {
      final result = utility.bottom(14.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top, isNull);
      expect(mix.$bottom?.value, 14.0);
      expect(mix.$left, isNull);
      expect(mix.$right, isNull);
    });

    test('left() creates EdgeInsetsMix with only left value', () {
      final result = utility.left(16.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top, isNull);
      expect(mix.$bottom, isNull);
      expect(mix.$left?.value, 16.0);
      expect(mix.$right, isNull);
    });

    test('right() creates EdgeInsetsMix with only right value', () {
      final result = utility.right(18.0);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, isA<EdgeInsetsMix>());
      final mix = result.edgeInsets!.value as EdgeInsetsMix;
      expect(mix.$top, isNull);
      expect(mix.$bottom, isNull);
      expect(mix.$left, isNull);
      expect(mix.$right?.value, 18.0);
    });

    test('call() accepts EdgeInsetsGeometryMix directly', () {
      final edgeInsetsMix = EdgeInsetsMix.all(20.0);
      final result = utility.call(edgeInsetsMix);

      expect(result.edgeInsets, isNotNull);
      expect(result.edgeInsets!.value, same(edgeInsetsMix));
    });

    group('EdgeInsetsDirectionalUtility', () {
      test('directional property provides access to directional utilities', () {
        expect(utility.directional, isA<EdgeInsetsDirectionalUtility>());

        // Test directional.all
        final directionalResult = utility.directional.all(10.0);
        expect(directionalResult.edgeInsets, isNotNull);
        expect(
          directionalResult.edgeInsets!.value,
          isA<EdgeInsetsDirectionalMix>(),
        );
      });
    });
  });
}
