import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Test implementation that uses the mixin
class TestStyler extends Style<BoxSpec>
    with
        WidgetModifierStyleMixin<TestStyler, BoxSpec>,
        AnimationStyleMixin<BoxSpec, TestStyler> {
  final List<WidgetModifierConfig> calledWith;

  TestStyler({
    super.variants,
    super.modifier,
    super.animation,
    List<WidgetModifierConfig>? calledWith,
  }) : calledWith = calledWith ?? <WidgetModifierConfig>[];

  @override
  TestStyler wrap(WidgetModifierConfig value) {
    calledWith.add(value);
    return this;
  }

  @override
  TestStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return TestStyler(
      variants: variants,
      modifier: $modifier,
      animation: $animation,
      calledWith: calledWith,
    );
  }

  @override
  TestStyler animate(AnimationConfig animation) {
    return TestStyler(
      variants: $variants,
      modifier: $modifier,
      animation: animation,
      calledWith: calledWith,
    );
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: BoxSpec(),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  TestStyler merge(TestStyler? other) {
    return TestStyler(
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      calledWith: calledWith,
    );
  }

  @override
  List<Object?> get props => [$animation, $modifier, $variants];
}

void main() {
  group('WidgetModifierStyleMixin', () {
    late TestStyler testStyler;

    setUp(() {
      testStyler = TestStyler();
    });

    group('wrapOpacity', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapOpacity(0.5);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapPadding', () {
      test('should call wrap with widget modifier config', () {
        final padding = EdgeInsetsGeometryMix.value(const EdgeInsets.all(16));
        testStyler.wrapPadding(padding);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapClipOval', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapClipOval();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with parameters', () {
        testStyler.wrapClipOval(clipBehavior: Clip.antiAlias);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapClipRect', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapClipRect();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with parameters', () {
        testStyler.wrapClipRect(clipBehavior: Clip.hardEdge);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapClipPath', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapClipPath();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with parameters', () {
        testStyler.wrapClipPath(clipBehavior: Clip.antiAliasWithSaveLayer);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapClipTriangle', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapClipTriangle();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapClipRRect', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapClipRRect(borderRadius: BorderRadius.circular(8));

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapVisibility', () {
      test('should call wrap with widget modifier config for visible', () {
        testStyler.wrapVisibility(true);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config for hidden', () {
        testStyler.wrapVisibility(false);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapAspectRatio', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapAspectRatio(16 / 9);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapFlexible', () {
      test('should call wrap with widget modifier config with defaults', () {
        testStyler.wrapFlexible();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test(
        'should call wrap with widget modifier config with custom parameters',
        () {
          testStyler.wrapFlexible(flex: 2, fit: FlexFit.tight);

          expect(testStyler.calledWith.length, equals(1));
          expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
        },
      );
    });

    group('wrapExpanded', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapExpanded();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with custom flex', () {
        testStyler.wrapExpanded(flex: 3);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapScale', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapScale(1.5);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with alignment', () {
        testStyler.wrapScale(0.8, alignment: Alignment.topLeft);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapRotate', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapRotate(3.14159);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with alignment', () {
        testStyler.wrapRotate(1.57, alignment: Alignment.bottomRight);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapTranslate', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapTranslate(10, 20);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with z', () {
        testStyler.wrapTranslate(5, 15, 3);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapTransform', () {
      test('should call wrap with widget modifier config', () {
        final transform = Matrix4.identity();
        testStyler.wrapTransform(transform);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with alignment', () {
        final transform = Matrix4.diagonal3Values(2, 2, 1);
        testStyler.wrapTransform(transform, alignment: Alignment.center);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapSizedBox', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapSizedBox(width: 100, height: 200);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with width only', () {
        testStyler.wrapSizedBox(width: 150);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with height only', () {
        testStyler.wrapSizedBox(height: 75);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapConstrainedBox', () {
      test('should call wrap with widget modifier config from constraints', () {
        final constraints = const BoxConstraints(maxWidth: 200, maxHeight: 300);
        testStyler.wrapConstrainedBox(constraints);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should handle unbounded constraints', () {
        final constraints = const BoxConstraints();
        testStyler.wrapConstrainedBox(constraints);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapAlign', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapAlign(Alignment.topLeft);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapCenter', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapCenter();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapFractionallySizedBox', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapFractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.6,
        );

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });

      test('should call wrap with widget modifier config with defaults', () {
        testStyler.wrapFractionallySizedBox();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapRotatedBox', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapRotatedBox(2);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapIntrinsicWidth', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapIntrinsicWidth();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapIntrinsicHeight', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapIntrinsicHeight();

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapMouseCursor', () {
      test('should call wrap with widget modifier config', () {
        testStyler.wrapMouseCursor(SystemMouseCursors.click);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapDefaultTextStyle', () {
      test('should call wrap with widget modifier config', () {
        final textStyle = TextStyleMix();
        testStyler.wrapDefaultTextStyle(textStyle);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapIconTheme', () {
      test('should call wrap with widget modifier config', () {
        const iconTheme = IconThemeData(color: Colors.blue, size: 24);
        testStyler.wrapIconTheme(iconTheme);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('wrapBox', () {
      test('should call wrap with widget modifier config', () {
        final boxStyler = BoxStyler();
        testStyler.wrapBox(boxStyler);

        expect(testStyler.calledWith.length, equals(1));
        expect(testStyler.calledWith.first, isA<WidgetModifierConfig>());
      });
    });

    group('method chaining', () {
      test('should support method chaining by returning self', () {
        final result = testStyler
            .wrapOpacity(0.5)
            .wrapPadding(EdgeInsetsGeometryMix.value(const EdgeInsets.all(8)))
            .wrapCenter();

        expect(result, same(testStyler));
        expect(testStyler.calledWith.length, equals(3));
      });
    });

    group('comprehensive coverage', () {
      test('should verify all convenience methods call wrap', () {
        // Test all wrap methods to ensure complete coverage
        testStyler
            .wrapOpacity(0.5)
            .wrapPadding(EdgeInsetsGeometryMix.value(const EdgeInsets.all(8)))
            .wrapClipOval()
            .wrapClipRect()
            .wrapClipPath()
            .wrapClipTriangle()
            .wrapClipRRect(borderRadius: BorderRadius.circular(8))
            .wrapVisibility(true)
            .wrapAspectRatio(16 / 9)
            .wrapFlexible()
            .wrapExpanded()
            .wrapScale(1.2)
            .wrapRotate(0.5)
            .wrapTranslate(10, 20)
            .wrapTransform(Matrix4.identity())
            .wrapSizedBox(width: 100)
            .wrapConstrainedBox(const BoxConstraints())
            .wrapAlign(Alignment.center)
            .wrapCenter()
            .wrapFractionallySizedBox()
            .wrapRotatedBox(1)
            .wrapIntrinsicWidth()
            .wrapIntrinsicHeight()
            .wrapMouseCursor(SystemMouseCursors.click)
            .wrapDefaultTextStyle(TextStyleMix())
            .wrapIconTheme(const IconThemeData())
            .wrapBox(BoxStyler());

        // Should have called wrap 27 times
        expect(testStyler.calledWith.length, equals(27));

        // All should be WidgetModifierConfig instances
        for (final config in testStyler.calledWith) {
          expect(config, isA<WidgetModifierConfig>());
        }
      });
    });
  });
}
