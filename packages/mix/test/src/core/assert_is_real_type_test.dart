import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/prop_refs.dart';
import 'package:mix/src/theme/tokens/token_refs.dart';

void main() {
  group('assertIsRealType', () {
    group('Color types', () {
      test('should assert when ColorRef is passed', () {
        expect(
          () => assertIsRealType(ColorRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use ColorRef for generic, use Color instead.',
            ),
          ),
        );
      });
    });

    group('Border types', () {
      test('should assert when BorderSideRef is passed', () {
        expect(
          () => assertIsRealType(BorderSideRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BorderSideRef for generic, use BorderSide instead.',
            ),
          ),
        );
      });

      test('should assert when BoxBorderRef is passed', () {
        expect(
          () => assertIsRealType(BoxBorderRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BoxBorderRef for generic, use BoxBorder instead.',
            ),
          ),
        );
      });

      test('should assert when BorderRadiusRef is passed', () {
        expect(
          () => assertIsRealType(BorderRadiusRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BorderRadiusRef for generic, use BorderRadius instead.',
            ),
          ),
        );
      });

      test('should assert when BorderRadiusDirectionalRef is passed', () {
        expect(
          () => assertIsRealType(BorderRadiusDirectionalRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BorderRadiusDirectionalRef for generic, use BorderRadiusDirectional instead.',
            ),
          ),
        );
      });

      test('should assert when BorderRadiusGeometryRef is passed', () {
        expect(
          () => assertIsRealType(BorderRadiusGeometryRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BorderRadiusGeometryRef for generic, use BorderRadiusGeometry instead.',
            ),
          ),
        );
      });
    });

    group('Gradient types', () {
      test('should assert when GradientRef is passed', () {
        expect(
          () => assertIsRealType(GradientRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use GradientRef for generic, use Gradient instead.',
            ),
          ),
        );
      });

      test('should assert when LinearGradientRef is passed', () {
        expect(
          () => assertIsRealType(LinearGradientRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use LinearGradientRef for generic, use LinearGradient instead.',
            ),
          ),
        );
      });

      test('should assert when RadialGradientRef is passed', () {
        expect(
          () => assertIsRealType(RadialGradientRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use RadialGradientRef for generic, use RadialGradient instead.',
            ),
          ),
        );
      });

      test('should assert when SweepGradientRef is passed', () {
        expect(
          () => assertIsRealType(SweepGradientRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use SweepGradientRef for generic, use SweepGradient instead.',
            ),
          ),
        );
      });

      test('should assert when GradientTransformRef is passed', () {
        expect(
          () => assertIsRealType(GradientTransformRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use GradientTransformRef for generic, use GradientTransform instead.',
            ),
          ),
        );
      });
    });

    group('Geometry types', () {
      test('should assert when AlignmentGeometryRef is passed', () {
        expect(
          () => assertIsRealType(AlignmentGeometryRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use AlignmentGeometryRef for generic, use AlignmentGeometry instead.',
            ),
          ),
        );
      });

      test('should assert when AlignmentRef is passed', () {
        expect(
          () => assertIsRealType(AlignmentRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use AlignmentRef for generic, use Alignment instead.',
            ),
          ),
        );
      });

      test('should assert when AlignmentDirectionalRef is passed', () {
        expect(
          () => assertIsRealType(AlignmentDirectionalRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use AlignmentDirectionalRef for generic, use AlignmentDirectional instead.',
            ),
          ),
        );
      });

      test('should assert when EdgeInsetsGeometryRef is passed', () {
        expect(
          () => assertIsRealType(EdgeInsetsGeometryRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use EdgeInsetsGeometryRef for generic, use EdgeInsetsGeometry instead.',
            ),
          ),
        );
      });

      test('should assert when EdgeInsetsRef is passed', () {
        expect(
          () => assertIsRealType(EdgeInsetsRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use EdgeInsetsRef for generic, use EdgeInsets instead.',
            ),
          ),
        );
      });

      test('should assert when EdgeInsetsDirectionalRef is passed', () {
        expect(
          () => assertIsRealType(EdgeInsetsDirectionalRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use EdgeInsetsDirectionalRef for generic, use EdgeInsetsDirectional instead.',
            ),
          ),
        );
      });
    });

    group('Shape and decoration types', () {
      test('should assert when RadiusRef is passed', () {
        expect(
          () => assertIsRealType(RadiusRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use RadiusRef for generic, use Radius instead.',
            ),
          ),
        );
      });

      test('should assert when OffsetRef is passed', () {
        expect(
          () => assertIsRealType(OffsetRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use OffsetRef for generic, use Offset instead.',
            ),
          ),
        );
      });

      test('should assert when RectRef is passed', () {
        expect(
          () => assertIsRealType(RectRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use RectRef for generic, use Rect instead.',
            ),
          ),
        );
      });

      test('should assert when ShadowRef is passed', () {
        expect(
          () => assertIsRealType(ShadowRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use ShadowRef for generic, use Shadow instead.',
            ),
          ),
        );
      });

      test('should assert when BoxShadowRef is passed', () {
        expect(
          () => assertIsRealType(BoxShadowRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BoxShadowRef for generic, use BoxShadow instead.',
            ),
          ),
        );
      });

      test('should assert when BoxDecorationRef is passed', () {
        expect(
          () => assertIsRealType(BoxDecorationRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BoxDecorationRef for generic, use BoxDecoration instead.',
            ),
          ),
        );
      });

      test('should assert when DecorationImageRef is passed', () {
        expect(
          () => assertIsRealType(DecorationImageRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use DecorationImageRef for generic, use DecorationImage instead.',
            ),
          ),
        );
      });

      test('should assert when ShapeBorderRef is passed', () {
        expect(
          () => assertIsRealType(ShapeBorderRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use ShapeBorderRef for generic, use ShapeBorder instead.',
            ),
          ),
        );
      });

      test('should assert when BoxConstraintsRef is passed', () {
        expect(
          () => assertIsRealType(BoxConstraintsRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use BoxConstraintsRef for generic, use BoxConstraints instead.',
            ),
          ),
        );
      });
    });

    group('Text types', () {
      test('should assert when TextStyleRef is passed', () {
        expect(
          () => assertIsRealType(TextStyleRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TextStyleRef for generic, use TextStyle instead.',
            ),
          ),
        );
      });

      test('should assert when TextDecorationRef is passed', () {
        expect(
          () => assertIsRealType(TextDecorationRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TextDecorationRef for generic, use TextDecoration instead.',
            ),
          ),
        );
      });

      test('should assert when StrutStyleRef is passed', () {
        expect(
          () => assertIsRealType(StrutStyleRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use StrutStyleRef for generic, use StrutStyle instead.',
            ),
          ),
        );
      });

      test('should assert when TextHeightBehaviorRef is passed', () {
        expect(
          () => assertIsRealType(TextHeightBehaviorRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TextHeightBehaviorRef for generic, use TextHeightBehavior instead.',
            ),
          ),
        );
      });

      test('should assert when TextScalerRef is passed', () {
        expect(
          () => assertIsRealType(TextScalerRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TextScalerRef for generic, use TextScaler instead.',
            ),
          ),
        );
      });

      test('should assert when FontFeatureRef is passed', () {
        expect(
          () => assertIsRealType(FontFeatureRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use FontFeatureRef for generic, use FontFeature instead.',
            ),
          ),
        );
      });

      test('should assert when FontWeightRef is passed', () {
        expect(
          () => assertIsRealType(FontWeightRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use FontWeightRef for generic, use FontWeight instead.',
            ),
          ),
        );
      });
    });

    group('Other types', () {
      test('should assert when LocaleRef is passed', () {
        expect(
          () => assertIsRealType(LocaleRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use LocaleRef for generic, use Locale instead.',
            ),
          ),
        );
      });

      test('should assert when ImageProviderRef is passed', () {
        expect(
          () => assertIsRealType(ImageProviderRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use ImageProviderRef for generic, use ImageProvider<Object> instead.',
            ),
          ),
        );
      });

      test('should assert when Matrix4Ref is passed', () {
        expect(
          () => assertIsRealType(Matrix4Ref),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use Matrix4Ref for generic, use Matrix4 instead.',
            ),
          ),
        );
      });

      test('should assert when TableColumnWidthRef is passed', () {
        expect(
          () => assertIsRealType(TableColumnWidthRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TableColumnWidthRef for generic, use TableColumnWidth instead.',
            ),
          ),
        );
      });

      test('should assert when TableBorderRef is passed', () {
        expect(
          () => assertIsRealType(TableBorderRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use TableBorderRef for generic, use TableBorder instead.',
            ),
          ),
        );
      });

      test('should assert when DurationRef is passed', () {
        expect(
          () => assertIsRealType(DurationRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use DurationRef for generic, use Duration instead.',
            ),
          ),
        );
      });

      test('should assert when CurveRef is passed', () {
        expect(
          () => assertIsRealType(CurveRef),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'Cannot use CurveRef for generic, use Curve instead.',
            ),
          ),
        );
      });
    });

    group('Valid types', () {
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
  });
}
