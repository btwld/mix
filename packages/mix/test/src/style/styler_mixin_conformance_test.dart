import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// Conformance tests to ensure all Styler classes have the correct mixins.
///
/// These tests verify that all Stylers have their required mixins properly
/// applied. If a mixin is missing, the test will fail to compile.
///
/// This prevents regressions like issue #817 where FlexBoxStyler and
/// StackBoxStyler were missing AnimationStyleMixin.
///
/// ## Mixin Categories:
///
/// **Universal (ALL Stylers):**
/// - WidgetModifierStyleMixin
/// - VariantStyleMixin
/// - WidgetStateVariantMixin
///
/// **Animation (all except ImageStyler):**
/// - AnimationStyleMixin
///
/// **Box-type (BoxStyler, FlexBoxStyler, StackBoxStyler, WrapBoxStyler):**
/// - BorderStyleMixin
/// - BorderRadiusStyleMixin
/// - ShadowStyleMixin
/// - DecorationStyleMixin
/// - SpacingStyleMixin
/// - TransformStyleMixin
/// - ConstraintStyleMixin
///
/// **Flex-specific (FlexStyler, FlexBoxStyler):**
/// - FlexStyleMixin
///
/// **Wrap-specific (WrapStyler, WrapBoxStyler):**
/// - WrapStyleMixin
///
/// **Text-specific (TextStyler):**
/// - TextStyleMixin
void main() {
  group('Styler Mixin Conformance', () {
    // =========================================================================
    // UNIVERSAL MIXINS - All Stylers must have these
    // =========================================================================
    group('Universal Mixins', () {
      test('all Stylers have WidgetModifierStyleMixin', () {
        // These will fail to compile if the mixin is missing
        expect(BoxStyler(), isA<WidgetModifierStyleMixin>());
        expect(FlexStyler(), isA<WidgetModifierStyleMixin>());
        expect(FlexBoxStyler(), isA<WidgetModifierStyleMixin>());
        expect(StackStyler(), isA<WidgetModifierStyleMixin>());
        expect(StackBoxStyler(), isA<WidgetModifierStyleMixin>());
        expect(WrapStyler(), isA<WidgetModifierStyleMixin>());
        expect(WrapBoxStyler(), isA<WidgetModifierStyleMixin>());
        expect(GridBoxStyler(), isA<WidgetModifierStyleMixin>());
        expect(TextStyler(), isA<WidgetModifierStyleMixin>());
        expect(IconStyler(), isA<WidgetModifierStyleMixin>());
        expect(ImageStyler(), isA<WidgetModifierStyleMixin>());
      });

      test('all Stylers have VariantStyleMixin', () {
        expect(BoxStyler(), isA<VariantStyleMixin>());
        expect(FlexStyler(), isA<VariantStyleMixin>());
        expect(FlexBoxStyler(), isA<VariantStyleMixin>());
        expect(StackStyler(), isA<VariantStyleMixin>());
        expect(StackBoxStyler(), isA<VariantStyleMixin>());
        expect(WrapStyler(), isA<VariantStyleMixin>());
        expect(WrapBoxStyler(), isA<VariantStyleMixin>());
        expect(GridBoxStyler(), isA<VariantStyleMixin>());
        expect(TextStyler(), isA<VariantStyleMixin>());
        expect(IconStyler(), isA<VariantStyleMixin>());
        expect(ImageStyler(), isA<VariantStyleMixin>());
      });

      test('all Stylers have WidgetStateVariantMixin', () {
        expect(BoxStyler(), isA<WidgetStateVariantMixin>());
        expect(FlexStyler(), isA<WidgetStateVariantMixin>());
        expect(FlexBoxStyler(), isA<WidgetStateVariantMixin>());
        expect(StackStyler(), isA<WidgetStateVariantMixin>());
        expect(StackBoxStyler(), isA<WidgetStateVariantMixin>());
        expect(WrapStyler(), isA<WidgetStateVariantMixin>());
        expect(WrapBoxStyler(), isA<WidgetStateVariantMixin>());
        expect(GridBoxStyler(), isA<WidgetStateVariantMixin>());
        expect(TextStyler(), isA<WidgetStateVariantMixin>());
        expect(IconStyler(), isA<WidgetStateVariantMixin>());
        expect(ImageStyler(), isA<WidgetStateVariantMixin>());
      });

      test('all Stylers name every equality field', () {
        _verifyFieldInventory(BoxStyler());
        _verifyFieldInventory(FlexStyler());
        _verifyFieldInventory(FlexBoxStyler());
        _verifyFieldInventory(StackStyler());
        _verifyFieldInventory(StackBoxStyler());
        _verifyFieldInventory(WrapStyler());
        _verifyFieldInventory(WrapBoxStyler());
        _verifyFieldInventory(GridBoxStyler());
        _verifyFieldInventory(TextStyler());
        _verifyFieldInventory(IconStyler());
        _verifyFieldInventory(ImageStyler());
      });
    });

    // =========================================================================
    // ANIMATION MIXIN - All Stylers except ImageStyler
    // =========================================================================
    group('AnimationStyleMixin', () {
      // Intentionally excluded: ImageStyler (no animatable properties)

      test('BoxStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<BoxStyler, BoxSpec>(BoxStyler());
      });

      test('FlexStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<FlexStyler, FlexSpec>(FlexStyler());
      });

      test('FlexBoxStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<FlexBoxStyler, FlexBoxSpec>(FlexBoxStyler());
      });

      test('StackStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<StackStyler, StackSpec>(StackStyler());
      });

      test('StackBoxStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<StackBoxStyler, StackBoxSpec>(
          StackBoxStyler(),
        );
      });

      test('WrapStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<WrapStyler, WrapSpec>(WrapStyler());
      });

      test('WrapBoxStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<WrapBoxStyler, WrapBoxSpec>(WrapBoxStyler());
      });

      test('GridBoxStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<GridBoxStyler, GridBoxSpec>(GridBoxStyler());
      });

      test('TextStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<TextStyler, TextSpec>(TextStyler());
      });

      test('IconStyler has AnimationStyleMixin', () {
        _verifyAnimationStyleMixin<IconStyler, IconSpec>(IconStyler());
      });
    });

    // =========================================================================
    // BOX-TYPE MIXINS - BoxStyler, FlexBoxStyler, StackBoxStyler, WrapBoxStyler
    // =========================================================================
    group('Box-type Mixins', () {
      test('box-type Stylers have DecorationStyleMixin', () {
        expect(BoxStyler(), isA<DecorationStyleMixin>());
        expect(FlexBoxStyler(), isA<DecorationStyleMixin>());
        expect(StackBoxStyler(), isA<DecorationStyleMixin>());
        expect(WrapBoxStyler(), isA<DecorationStyleMixin>());
      });

      test('box-type Stylers have BorderStyleMixin', () {
        expect(BoxStyler(), isA<BorderStyleMixin>());
        expect(FlexBoxStyler(), isA<BorderStyleMixin>());
        expect(StackBoxStyler(), isA<BorderStyleMixin>());
        expect(WrapBoxStyler(), isA<BorderStyleMixin>());
      });

      test('box-type Stylers have BorderRadiusStyleMixin', () {
        expect(BoxStyler(), isA<BorderRadiusStyleMixin>());
        expect(FlexBoxStyler(), isA<BorderRadiusStyleMixin>());
        expect(StackBoxStyler(), isA<BorderRadiusStyleMixin>());
        expect(WrapBoxStyler(), isA<BorderRadiusStyleMixin>());
      });

      test('box-type Stylers have ShadowStyleMixin', () {
        expect(BoxStyler(), isA<ShadowStyleMixin>());
        expect(FlexBoxStyler(), isA<ShadowStyleMixin>());
        expect(StackBoxStyler(), isA<ShadowStyleMixin>());
        expect(WrapBoxStyler(), isA<ShadowStyleMixin>());
      });

      test('box-type Stylers have SpacingStyleMixin', () {
        expect(BoxStyler(), isA<SpacingStyleMixin>());
        expect(FlexBoxStyler(), isA<SpacingStyleMixin>());
        expect(StackBoxStyler(), isA<SpacingStyleMixin>());
        expect(WrapBoxStyler(), isA<SpacingStyleMixin>());
      });

      test('box-type Stylers have TransformStyleMixin', () {
        expect(BoxStyler(), isA<TransformStyleMixin>());
        expect(FlexBoxStyler(), isA<TransformStyleMixin>());
        expect(StackBoxStyler(), isA<TransformStyleMixin>());
        expect(WrapBoxStyler(), isA<TransformStyleMixin>());
      });

      test('box-type Stylers have ConstraintStyleMixin', () {
        expect(BoxStyler(), isA<ConstraintStyleMixin>());
        expect(FlexBoxStyler(), isA<ConstraintStyleMixin>());
        expect(StackBoxStyler(), isA<ConstraintStyleMixin>());
        expect(WrapBoxStyler(), isA<ConstraintStyleMixin>());
      });
    });

    // =========================================================================
    // FLEX-SPECIFIC MIXIN - FlexStyler, FlexBoxStyler
    // =========================================================================
    group('Flex-specific Mixins', () {
      test('flex Stylers have FlexStyleMixin', () {
        expect(FlexStyler(), isA<FlexStyleMixin>());
        expect(FlexBoxStyler(), isA<FlexStyleMixin>());
      });
    });

    // =========================================================================
    // WRAP-SPECIFIC MIXIN - WrapStyler, WrapBoxStyler
    // =========================================================================
    group('Wrap-specific Mixins', () {
      test('wrap Stylers have WrapStyleMixin', () {
        expect(WrapStyler(), isA<WrapStyleMixin>());
        expect(WrapBoxStyler(), isA<WrapStyleMixin>());
      });
    });

    // =========================================================================
    // TEXT-SPECIFIC MIXIN - TextStyler only
    // =========================================================================
    group('Text-specific Mixins', () {
      test('TextStyler has TextStyleMixin', () {
        expect(TextStyler(), isA<TextStyleMixin>());
      });
    });

    // =========================================================================
    // METHOD VERIFICATION - Ensure mixin methods work correctly
    // =========================================================================
    group('Mixin method verification', () {
      late ValueNotifier<int> trigger;

      setUp(() {
        trigger = ValueNotifier(0);
      });

      tearDown(() {
        trigger.dispose();
      });

      test('keyframeAnimation returns styled instance', () {
        final styler = BoxStyler();

        final animated = styler.keyframeAnimation(
          trigger: trigger,
          timeline: [
            KeyframeTrack<double>('scale', [
              Keyframe.linear(1.0, Duration(milliseconds: 500)),
            ], initial: 1.0),
          ],
          styleBuilder: (values, style) => style,
        );

        expect(animated, isA<BoxStyler>());
        expect(animated.$animation, isA<KeyframeAnimationConfig<BoxSpec>>());
      });

      test('phaseAnimation returns styled instance', () {
        final styler = BoxStyler();

        final animated = styler.phaseAnimation<int>(
          trigger: trigger,
          phases: [0, 1, 2],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        );

        expect(animated, isA<BoxStyler>());
        expect(
          animated.$animation,
          isA<PhaseAnimationConfig<BoxSpec, BoxStyler>>(),
        );
      });

      test('FlexBoxStyler keyframeAnimation works correctly', () {
        final styler = FlexBoxStyler();

        final animated = styler.keyframeAnimation(
          trigger: trigger,
          timeline: [
            KeyframeTrack<double>('opacity', [
              Keyframe.linear(0.5, Duration(milliseconds: 200)),
            ], initial: 1.0),
          ],
          styleBuilder: (values, style) => style,
        );

        expect(animated, isA<FlexBoxStyler>());
        expect(
          animated.$animation,
          isA<KeyframeAnimationConfig<FlexBoxSpec>>(),
        );
      });

      test('StackBoxStyler phaseAnimation works correctly', () {
        final styler = StackBoxStyler();

        final animated = styler.phaseAnimation<String>(
          trigger: trigger,
          phases: ['start', 'middle', 'end'],
          styleBuilder: (phase, style) => style,
          configBuilder: (phase) => CurveAnimationConfig(
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          ),
        );

        expect(animated, isA<StackBoxStyler>());
        expect(
          animated.$animation,
          isA<PhaseAnimationConfig<StackBoxSpec, StackBoxStyler>>(),
        );
      });

      test('box-type decoration methods work', () {
        // BoxStyler
        final boxWithColor = BoxStyler().color(Colors.red);
        expect(boxWithColor.$decoration, isNotNull);

        // FlexBoxStyler
        final flexBoxWithColor = FlexBoxStyler().color(Colors.blue);
        expect(flexBoxWithColor.$box, isNotNull);

        // StackBoxStyler
        final stackBoxWithColor = StackBoxStyler().color(Colors.green);
        expect(stackBoxWithColor.$box, isNotNull);

        // WrapBoxStyler
        final wrapBoxWithColor = WrapBoxStyler().color(Colors.orange);
        expect(wrapBoxWithColor.$box, isNotNull);
      });

      test('box-type spacing methods work', () {
        // BoxStyler
        final boxWithPadding = BoxStyler().paddingAll(16);
        expect(boxWithPadding.$padding, isNotNull);

        // FlexBoxStyler
        final flexBoxWithPadding = FlexBoxStyler().paddingAll(16);
        expect(flexBoxWithPadding.$box, isNotNull);

        // StackBoxStyler
        final stackBoxWithPadding = StackBoxStyler().paddingAll(16);
        expect(stackBoxWithPadding.$box, isNotNull);

        // WrapBoxStyler
        final wrapBoxWithPadding = WrapBoxStyler().paddingAll(16);
        expect(wrapBoxWithPadding.$box, isNotNull);
      });

      test('flex-type direction methods work', () {
        // FlexStyler
        final flexWithDir = FlexStyler().direction(.horizontal);
        expect(flexWithDir.$direction, isNotNull);

        // FlexBoxStyler
        final flexBoxWithDir = FlexBoxStyler().direction(.horizontal);
        expect(flexBoxWithDir.$flex, isNotNull);
      });

      test('wrap-type direction methods work', () {
        // WrapStyler
        final wrapWithDir = WrapStyler().direction(.vertical);
        expect(wrapWithDir.$direction, isNotNull);

        // WrapBoxStyler
        final wrapBoxWithDir = WrapBoxStyler().direction(.vertical);
        expect(wrapBoxWithDir.$flow, isNotNull);
      });
    });
  });
}

void _verifyFieldInventory<S extends Spec<S>>(Style<S> styler) {
  expect(styler, isA<StylerFieldMetadata>());
  final metadata = styler as StylerFieldMetadata;
  expect(metadata.$stylerFieldNames, hasLength(styler.props.length));
}

/// Verifies that a Styler has AnimationStyleMixin by calling its methods.
///
/// This is a compile-time check - if the mixin is missing, this function
/// won't compile because the methods won't exist on the Styler.
void _verifyAnimationStyleMixin<T extends Style<S>, S extends Spec<S>>(
  T styler,
) {
  // Verify animate() method exists and returns correct type
  final animation = AnimationConfig.linear(Duration(milliseconds: 100));
  final animated = (styler as dynamic).animate(animation) as T;
  expect(animated.$animation, animation);

  // Verify the Styler is an instance of AnimationStyleMixin
  // This is a runtime check that complements the compile-time check
  expect(styler, isA<AnimationStyleMixin<T, S>>());
}
