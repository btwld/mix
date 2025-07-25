import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

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


      test('supports equality', () {
        final config1 = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config2 = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config3 = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        );

        expect(config1, equals(config2));
        expect(config1, isNot(equals(config3)));
      });

      test('has correct hashCode', () {
        final config1 = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        final config2 = AnimationConfig.implicit(
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );

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
  });
}


