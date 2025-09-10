import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop_refs.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';

void main() {
  group('assertIsRealType', () {
    test('should assert when ColorProp is passed', () {
      expect(
        () => assertIsRealType(ColorRef),
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
        () => assertIsRealType(RadiusRef),
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
        () => assertIsRealType(TextStyleRef),
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
        () => assertIsRealType(ShadowRef),
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
        () => assertIsRealType(GradientRef),
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
        () => assertIsRealType(BoxDecorationRef),
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
        () => assertIsRealType(ShapeBorderRef),
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
        () => assertIsRealType(BoxConstraintsRef),
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
        () => assertIsRealType(DecorationImageRef),
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
        () => assertIsRealType(EdgeInsetsGeometryRef),
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
        () => assertIsRealType(BorderRadiusGeometryRef),
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
        () => assertIsRealType(AlignmentGeometryRef),
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
        () => assertIsRealType(TextDecorationRef),
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
        () => assertIsRealType(OffsetRef),
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
        () => assertIsRealType(RectRef),
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
        () => assertIsRealType(LocaleRef),
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
        () => assertIsRealType(ImageProviderRef),
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
        () => assertIsRealType(GradientTransformRef),
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
        () => assertIsRealType(Matrix4Ref),
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
        () => assertIsRealType(TextScalerRef),
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
        () => assertIsRealType(TableColumnWidthRef),
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
        () => assertIsRealType(TableBorderRef),
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
        () => assertIsRealType(StrutStyleRef),
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
        () => assertIsRealType(TextHeightBehaviorRef),
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
