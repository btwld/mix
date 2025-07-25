import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/internal/constants.dart';

void main() {
  group('AnimationConfig', () {
    group('CurveAnimationConfig', () {
      test('creates with implicit factory', () {
        final config = AnimationConfig.implicit(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        expect(config, isA<CurveAnimationConfig>());
        expect(config.duration, const Duration(milliseconds: 300));
        expect(config.curve, Curves.easeIn);
      });

      test('creates with curve shortcuts', () {
        final linear = AnimationConfig.linear(const Duration(seconds: 1));
        expect(linear.curve, Curves.linear);
        expect(linear.duration, const Duration(seconds: 1));

        final ease = AnimationConfig.ease(const Duration(seconds: 1));
        expect(ease.curve, Curves.ease);

        final easeIn = AnimationConfig.easeIn(const Duration(seconds: 1));
        expect(easeIn.curve, Curves.easeIn);

        final easeOut = AnimationConfig.easeOut(const Duration(seconds: 1));
        expect(easeOut.curve, Curves.easeOut);

        final easeInOut = AnimationConfig.easeInOut(const Duration(seconds: 1));
        expect(easeInOut.curve, Curves.easeInOut);

        final fastOutSlowIn = AnimationConfig.fastOutSlowIn(const Duration(seconds: 1));
        expect(fastOutSlowIn.curve, Curves.fastOutSlowIn);

        final bounceIn = AnimationConfig.bounceIn(const Duration(seconds: 1));
        expect(bounceIn.curve, Curves.bounceIn);

        final bounceOut = AnimationConfig.bounceOut(const Duration(seconds: 1));
        expect(bounceOut.curve, Curves.bounceOut);

        final bounceInOut = AnimationConfig.bounceInOut(const Duration(seconds: 1));
        expect(bounceInOut.curve, Curves.bounceInOut);

        final elasticIn = AnimationConfig.elasticIn(const Duration(seconds: 1));
        expect(elasticIn.curve, Curves.elasticIn);

        final elasticOut = AnimationConfig.elasticOut(const Duration(seconds: 1));
        expect(elasticOut.curve, Curves.elasticOut);

        final elasticInOut = AnimationConfig.elasticInOut(const Duration(seconds: 1));
        expect(elasticInOut.curve, Curves.elasticInOut);
      });

      test('supports equality', () {
        final config1 = AnimationConfig.linear(const Duration(seconds: 1));
        final config2 = AnimationConfig.linear(const Duration(seconds: 1));
        final config3 = AnimationConfig.ease(const Duration(seconds: 1));

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('has correct hashCode', () {
        final config1 = AnimationConfig.linear(const Duration(seconds: 1));
        final config2 = AnimationConfig.linear(const Duration(seconds: 1));

        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('handles onEnd callback', () {
        bool called = false;
        final config = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
          onEnd: () => called = true,
        );

        expect(config.onEnd, isNotNull);
        config.onEnd!();
        expect(called, true);
      });
    });

    group('SpringAnimationConfig', () {
      test('creates with spring factory', () {
        final config = AnimationConfig.spring(
          mass: 2.0,
          stiffness: 100.0,
          damping: 10.0,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 100.0);
        expect(config.spring.damping, 10.0);
      });

      test('creates with custom SpringDescription', () {
        final spring = SpringDescription(
          mass: 3.0,
          stiffness: 150.0,
          damping: 15.0,
        );
        final config = AnimationConfig.spring(spring: spring);

        expect(config.spring, spring);
      });

      test('creates critically damped spring', () {
        final config = AnimationConfig.criticallyDamped(
          mass: 2.0,
          stiffness: 200.0,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 2.0);
        expect(config.spring.stiffness, 200.0);
        // Critically damped has specific damping ratio
      });

      test('creates underdamped spring', () {
        final config = AnimationConfig.underdamped(
          mass: 1.5,
          stiffness: 250.0,
          ratio: 0.7,
        );

        expect(config, isA<SpringAnimationConfig>());
        expect(config.spring.mass, 1.5);
        expect(config.spring.stiffness, 250.0);
      });

      test('supports equality', () {
        final config1 = AnimationConfig.spring(
          mass: 1.0,
          stiffness: 180.0,
          damping: 12.0,
        );
        final config2 = AnimationConfig.spring(
          mass: 1.0,
          stiffness: 180.0,
          damping: 12.0,
        );
        final config3 = AnimationConfig.spring(
          mass: 2.0,
          stiffness: 180.0,
          damping: 12.0,
        );

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('handles onEnd callback', () {
        bool called = false;
        final config = AnimationConfig.spring(
          onEnd: () => called = true,
        );

        expect(config.onEnd, isNotNull);
        config.onEnd!();
        expect(called, true);
      });

      test('creates with standard constructor', () {
        final config = SpringAnimationConfig.standard();
        
        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
        expect(config.spring.damping, 12.0);
      });

      test('creates with critically damped constructor', () {
        final config = SpringAnimationConfig.criticallyDamped();
        
        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
      });

      test('creates with underdamped constructor', () {
        final config = SpringAnimationConfig.underdamped();
        
        expect(config.spring.mass, 1.0);
        expect(config.spring.stiffness, 180.0);
      });
    });

    group('ControlledAnimationConfig', () {
      test('creates with controller', () {
        final controller = AnimationController(
          vsync: const TestVSync(),
          duration: const Duration(seconds: 1),
        );
        final config = AnimationConfig.controller(controller);

        expect(config, isA<ControlledAnimationConfig>());
        expect(config.controller, controller);
        expect(config.duration, const Duration(seconds: 1));
        expect(config.curve, Curves.linear);

        controller.dispose();
      });

      test('supports equality', () {
        final controller1 = AnimationController(
          vsync: const TestVSync(),
        );
        final controller2 = AnimationController(
          vsync: const TestVSync(),
        );

        final config1 = AnimationConfig.controller(controller1);
        final config2 = AnimationConfig.controller(controller1);
        final config3 = AnimationConfig.controller(controller2);

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));

        controller1.dispose();
        controller2.dispose();
      });
    });

    group('AnimationBuilderConfig', () {
      test('creates with builder factory', () {
        SpecStyle<BoxSpec> builder(int value) {
          return BoxSpecAttribute()
              .width(value.toDouble())
              .height(value.toDouble());
        }

        final config = AnimationConfig.builder<BoxSpec, int>(
          builder: builder,
          curve: Curves.bounceIn,
          delay: const Duration(milliseconds: 100),
          duration: const Duration(seconds: 2),
        );

        expect(config, isA<AnimationBuilderConfig>());
        expect(config.builder, builder);
        expect(config.curve, Curves.bounceIn);
        expect(config.delay, const Duration(milliseconds: 100));
        expect(config.duration, const Duration(seconds: 2));
      });

      test('uses default values', () {
        SpecStyle<BoxSpec> builder(int value) {
          return BoxSpecAttribute()
              .width(value.toDouble())
              .height(value.toDouble());
        }

        final config = AnimationConfig.builder<BoxSpec, int>(
          builder: builder,
        );

        expect(config.curve, Curves.linear);
        expect(config.delay, Duration.zero);
        expect(config.duration, kDefaultAnimationDuration);
      });
    });
  });
}


