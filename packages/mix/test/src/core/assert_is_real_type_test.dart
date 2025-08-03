import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop_refs.dart';

void main() {
  group('assertIsRealType', () {
    test('should assert when ColorProp is passed', () {
      expect(
        () => assertIsRealType(ColorProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use ColorProp for generic, use Color instead.',
          ),
        ),
      );
    });

    test('should assert when RadiusProp is passed', () {
      expect(
        () => assertIsRealType(RadiusProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use RadiusProp for generic, use Radius instead.',
          ),
        ),
      );
    });

    test('should assert when TextStyleProp is passed', () {
      expect(
        () => assertIsRealType(TextStyleProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TextStyleProp for generic, use TextStyle instead.',
          ),
        ),
      );
    });

    test('should assert when ShadowProp is passed', () {
      expect(
        () => assertIsRealType(ShadowProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use ShadowProp for generic, use Shadow instead.',
          ),
        ),
      );
    });

    test('should assert when GradientProp is passed', () {
      expect(
        () => assertIsRealType(GradientProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use GradientProp for generic, use Gradient instead.',
          ),
        ),
      );
    });

    test('should assert when BoxDecorationProp is passed', () {
      expect(
        () => assertIsRealType(BoxDecorationProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use BoxDecorationProp for generic, use BoxDecoration instead.',
          ),
        ),
      );
    });

    test('should assert when ShapeBorderProp is passed', () {
      expect(
        () => assertIsRealType(ShapeBorderProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use ShapeBorderProp for generic, use ShapeBorder instead.',
          ),
        ),
      );
    });

    test('should assert when BoxConstraintsProp is passed', () {
      expect(
        () => assertIsRealType(BoxConstraintsProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use BoxConstraintsProp for generic, use BoxConstraints instead.',
          ),
        ),
      );
    });

    test('should assert when DecorationImageProp is passed', () {
      expect(
        () => assertIsRealType(DecorationImageProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use DecorationImageProp for generic, use DecorationImage instead.',
          ),
        ),
      );
    });

    test('should assert when EdgeInsetsGeometryProp is passed', () {
      expect(
        () => assertIsRealType(EdgeInsetsGeometryProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use EdgeInsetsGeometryProp for generic, use EdgeInsetsGeometry instead.',
          ),
        ),
      );
    });

    test('should assert when BorderRadiusGeometryProp is passed', () {
      expect(
        () => assertIsRealType(BorderRadiusGeometryProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use BorderRadiusGeometryProp for generic, use BorderRadiusGeometry instead.',
          ),
        ),
      );
    });

    test('should assert when AlignmentGeometryProp is passed', () {
      expect(
        () => assertIsRealType(AlignmentGeometryProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use AlignmentGeometryProp for generic, use AlignmentGeometry instead.',
          ),
        ),
      );
    });

    test('should assert when TextDecorationProp is passed', () {
      expect(
        () => assertIsRealType(TextDecorationProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TextDecorationProp for generic, use TextDecoration instead.',
          ),
        ),
      );
    });

    test('should assert when OffsetProp is passed', () {
      expect(
        () => assertIsRealType(OffsetProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use OffsetProp for generic, use Offset instead.',
          ),
        ),
      );
    });

    test('should assert when RectProp is passed', () {
      expect(
        () => assertIsRealType(RectProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use RectProp for generic, use Rect instead.',
          ),
        ),
      );
    });

    test('should assert when LocaleProp is passed', () {
      expect(
        () => assertIsRealType(LocaleProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use LocaleProp for generic, use Locale instead.',
          ),
        ),
      );
    });

    test('should assert when ImageProviderProp is passed', () {
      expect(
        () => assertIsRealType(ImageProviderProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use ImageProviderProp for generic, use ImageProvider<Object> instead.',
          ),
        ),
      );
    });

    test('should assert when GradientTransformProp is passed', () {
      expect(
        () => assertIsRealType(GradientTransformProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use GradientTransformProp for generic, use GradientTransform instead.',
          ),
        ),
      );
    });

    test('should assert when Matrix4Prop is passed', () {
      expect(
        () => assertIsRealType(Matrix4Prop),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use Matrix4Prop for generic, use Matrix4 instead.',
          ),
        ),
      );
    });

    test('should assert when TextScalerProp is passed', () {
      expect(
        () => assertIsRealType(TextScalerProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TextScalerProp for generic, use TextScaler instead.',
          ),
        ),
      );
    });

    test('should assert when TableColumnWidthProp is passed', () {
      expect(
        () => assertIsRealType(TableColumnWidthProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TableColumnWidthProp for generic, use TableColumnWidth instead.',
          ),
        ),
      );
    });

    test('should assert when TableBorderProp is passed', () {
      expect(
        () => assertIsRealType(TableBorderProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TableBorderProp for generic, use TableBorder instead.',
          ),
        ),
      );
    });

    test('should assert when StrutStyleProp is passed', () {
      expect(
        () => assertIsRealType(StrutStyleProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use StrutStyleProp for generic, use StrutStyle instead.',
          ),
        ),
      );
    });

    test('should assert when TextHeightBehaviorProp is passed', () {
      expect(
        () => assertIsRealType(TextHeightBehaviorProp),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot use TextHeightBehaviorProp for generic, use TextHeightBehavior instead.',
          ),
        ),
      );
    });

    test('should not assert when a real type is passed', () {
      expect(() => assertIsRealType(Color), returnsNormally);
      expect(() => assertIsRealType(TextStyle), returnsNormally);
      expect(() => assertIsRealType(BoxDecoration), returnsNormally);
      expect(() => assertIsRealType(String), returnsNormally);
      expect(() => assertIsRealType(int), returnsNormally);
      expect(() => assertIsRealType(double), returnsNormally);
      expect(() => assertIsRealType(bool), returnsNormally);
    });

    test('should not assert when unknown type is passed', () {
      expect(() => assertIsRealType(Object), returnsNormally);
      expect(() => assertIsRealType(dynamic), returnsNormally);
      expect(() => assertIsRealType(List), returnsNormally);
      expect(() => assertIsRealType(Map), returnsNormally);
    });
  });
}
