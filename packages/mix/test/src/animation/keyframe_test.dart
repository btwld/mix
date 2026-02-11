import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/animation/animation_config.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Keyframe', () {
    group('construction', () {
      test('creates with required parameters', () {
        const keyframe = Keyframe<double>(
          0.5,
          Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        expect(keyframe.value, 0.5);
        expect(keyframe.duration, const Duration(milliseconds: 300));
        expect(keyframe.curve, Curves.easeIn);
      });

      test('linear constructor uses Curves.linear', () {
        const keyframe = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 200),
        );

        expect(keyframe.curve, Curves.linear);
        expect(keyframe.value, 1.0);
        expect(keyframe.duration, const Duration(milliseconds: 200));
      });

      test('ease constructor uses Curves.ease', () {
        const keyframe = Keyframe<double>.ease(
          0.8,
          Duration(milliseconds: 150),
        );

        expect(keyframe.curve, Curves.ease);
      });

      test('easeInOut constructor uses Curves.easeInOut', () {
        const keyframe = Keyframe<double>.easeInOut(
          0.5,
          Duration(milliseconds: 100),
        );

        expect(keyframe.curve, Curves.easeInOut);
      });

      test('bounceOut constructor uses Curves.bounceOut', () {
        const keyframe = Keyframe<double>.bounceOut(
          1.0,
          Duration(milliseconds: 400),
        );

        expect(keyframe.curve, Curves.bounceOut);
      });
    });

    group('spring constructors', () {
      test('springWithBounce creates SpringCurve', () {
        final keyframe = Keyframe<double>.springWithBounce(
          1.0,
          const Duration(milliseconds: 500),
          bounce: 0.3,
        );

        expect(keyframe.curve, isNotNull);
        expect(keyframe.value, 1.0);
      });

      test('springWithDampingRatio creates SpringCurve', () {
        final keyframe = Keyframe<double>.springWithDampingRatio(
          1.0,
          const Duration(milliseconds: 500),
          ratio: 0.8,
        );

        expect(keyframe.curve, isNotNull);
      });

      test('spring creates SpringCurve with custom parameters', () {
        final keyframe = Keyframe<double>.spring(
          1.0,
          const Duration(milliseconds: 500),
          mass: 2.0,
          stiffness: 200.0,
          damping: 15.0,
        );

        expect(keyframe.curve, isNotNull);
      });
    });

    group('equality', () {
      test('equal keyframes have same hashCode', () {
        const keyframe1 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 300),
        );
        const keyframe2 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 300),
        );

        expect(keyframe1, equals(keyframe2));
        expect(keyframe1.hashCode, equals(keyframe2.hashCode));
      });

      test('different values produce different keyframes', () {
        const keyframe1 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 300),
        );
        const keyframe2 = Keyframe<double>.linear(
          0.5,
          Duration(milliseconds: 300),
        );

        expect(keyframe1, isNot(equals(keyframe2)));
      });

      test('different durations produce different keyframes', () {
        const keyframe1 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 300),
        );
        const keyframe2 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 500),
        );

        expect(keyframe1, isNot(equals(keyframe2)));
      });

      test('different curves produce different keyframes', () {
        const keyframe1 = Keyframe<double>.linear(
          1.0,
          Duration(milliseconds: 300),
        );
        const keyframe2 = Keyframe<double>.ease(
          1.0,
          Duration(milliseconds: 300),
        );

        expect(keyframe1, isNot(equals(keyframe2)));
      });
    });

    group('props', () {
      test('props contains duration, value, and curve', () {
        const keyframe = Keyframe<double>(
          0.5,
          Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        expect(keyframe.props, contains(const Duration(milliseconds: 300)));
        expect(keyframe.props, contains(0.5));
        expect(keyframe.props, contains(Curves.easeIn));
      });
    });
  });

  group('KeyframeTrack', () {
    group('totalDuration', () {
      test('sums all segment durations', () {
        final track = KeyframeTrack<double>('opacity', const [
          Keyframe.linear(0.5, Duration(milliseconds: 100)),
          Keyframe.linear(1.0, Duration(milliseconds: 200)),
          Keyframe.linear(0.8, Duration(milliseconds: 150)),
        ], initial: 0.0);

        expect(track.totalDuration, const Duration(milliseconds: 450));
      });

      test('returns zero for empty segments', () {
        final track = KeyframeTrack<double>('empty', const [], initial: 0.0);

        expect(track.totalDuration, Duration.zero);
      });

      test('handles single segment', () {
        final track = KeyframeTrack<double>('single', const [
          Keyframe.linear(1.0, Duration(milliseconds: 500)),
        ], initial: 0.0);

        expect(track.totalDuration, const Duration(milliseconds: 500));
      });
    });

    group('createSequenceItems', () {
      test('creates correct number of items', () {
        final track = KeyframeTrack<double>('test', const [
          Keyframe.linear(0.5, Duration(milliseconds: 100)),
          Keyframe.linear(1.0, Duration(milliseconds: 200)),
        ], initial: 0.0);

        final items = track.createSequenceItems();

        expect(items.length, 2);
      });

      test('items have correct weights based on duration', () {
        final track = KeyframeTrack<double>('test', const [
          Keyframe.linear(0.5, Duration(milliseconds: 100)),
          Keyframe.linear(1.0, Duration(milliseconds: 300)),
        ], initial: 0.0);

        final items = track.createSequenceItems();

        expect(items[0].weight, 100.0);
        expect(items[1].weight, 300.0);
      });

      test('returns empty list for empty segments', () {
        final track = KeyframeTrack<double>('empty', const [], initial: 0.0);

        final items = track.createSequenceItems();

        expect(items, isEmpty);
      });
    });

    group('createAnimatable', () {
      test('creates animatable for timeline duration', () {
        final track = KeyframeTrack<double>('test', const [
          Keyframe.linear(0.5, Duration(milliseconds: 100)),
          Keyframe.linear(1.0, Duration(milliseconds: 100)),
        ], initial: 0.0);

        final animatable = track.createAnimatable(
          const Duration(milliseconds: 200),
        );

        expect(animatable, isNotNull);
      });

      test('animatable transforms values correctly at boundaries', () {
        final track = KeyframeTrack<double>('test', const [
          Keyframe.linear(1.0, Duration(milliseconds: 100)),
        ], initial: 0.0);

        final animatable = track.createAnimatable(
          const Duration(milliseconds: 100),
        );

        // At t=0, should be at initial value
        expect(animatable.transform(0.0), closeTo(0.0, 0.01));

        // At t=1, should be at final value
        expect(animatable.transform(1.0), closeTo(1.0, 0.01));
      });
    });

    group('custom tweenBuilder', () {
      test('uses default Tween when not provided', () {
        final track = KeyframeTrack<double>('test', const [
          Keyframe.linear(1.0, Duration(milliseconds: 100)),
        ], initial: 0.0);

        // Should not throw
        expect(() => track.createSequenceItems(), returnsNormally);
      });

      test('uses custom tweenBuilder when provided', () {
        var builderCalled = false;

        final track = KeyframeTrack<double>(
          'test',
          const [Keyframe.linear(1.0, Duration(milliseconds: 100))],
          initial: 0.0,
          tweenBuilder: ({double? begin, double? end}) {
            builderCalled = true;
            return Tween<double>(begin: begin, end: end);
          },
        );

        track.createSequenceItems();

        expect(builderCalled, true);
      });
    });

    group('equality', () {
      test('equal tracks have same props', () {
        final track1 = KeyframeTrack<double>('test', const [
          Keyframe.linear(1.0, Duration(milliseconds: 100)),
        ], initial: 0.0);
        final track2 = KeyframeTrack<double>('test', const [
          Keyframe.linear(1.0, Duration(milliseconds: 100)),
        ], initial: 0.0);

        expect(track1.props, equals(track2.props));
      });
    });
  });

  group('KeyframeAnimationResult', () {
    group('get<T>', () {
      test('returns value for existing key', () {
        const result = KeyframeAnimationResult({'opacity': 0.5, 'scale': 1.2});

        expect(result.get<double>('opacity'), 0.5);
        expect(result.get<double>('scale'), 1.2);
      });

      test('throws ArgumentError for missing key', () {
        const result = KeyframeAnimationResult({'opacity': 0.5});

        expect(
          () => result.get<double>('nonexistent'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws StateError for wrong type', () {
        const result = KeyframeAnimationResult({'opacity': 0.5});

        expect(() => result.get<String>('opacity'), throwsA(isA<StateError>()));
      });

      test('works with various types', () {
        const result = KeyframeAnimationResult({
          'color': Colors.red,
          'offset': Offset(10, 20),
          'size': Size(100, 200),
        });

        expect(result.get<Color>('color'), Colors.red);
        expect(result.get<Offset>('offset'), const Offset(10, 20));
        expect(result.get<Size>('size'), const Size(100, 200));
      });
    });
  });

  group('KeyframeAnimationConfig', () {
    test('stores all required parameters', () {
      final trigger = ValueNotifier(false);
      final timeline = [
        KeyframeTrack<double>('test', const [
          Keyframe.linear(1, Duration(milliseconds: 100)),
        ], initial: 0.0),
      ];

      final config = KeyframeAnimationConfig<MockSpec<double>>(
        trigger: trigger,
        timeline: timeline,
        styleBuilder: (result, style) => style,
        initialStyle: MockStyle(0.0),
      );

      expect(config.trigger, trigger);
      expect(config.timeline, timeline);
      expect(config.styleBuilder, isNotNull);
      expect(config.initialStyle, isA<MockStyle>());

      trigger.dispose();
    });

    test('props contains all fields for equality', () {
      final trigger = ValueNotifier(false);
      final timeline = <KeyframeTrack>[];

      final config = KeyframeAnimationConfig<MockSpec<double>>(
        trigger: trigger,
        timeline: timeline,
        styleBuilder: (result, style) => style,
        initialStyle: MockStyle(0.0),
      );

      expect(config.props, contains(trigger));
      expect(config.props, contains(timeline));

      trigger.dispose();
    });
  });
}
