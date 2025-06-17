import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/helpers/duration.dart';

void main() {
  group('MixDurationInt Extension', () {
    group('Full names', () {
      test('should create Duration with days', () {
        const days = 5;
        final duration = days.days;

        expect(duration, const Duration(days: days));
      });

      test('should create Duration with hours', () {
        const hours = 3;
        final duration = hours.hours;

        expect(duration, const Duration(hours: hours));
      });

      test('should create Duration with minutes', () {
        const minutes = 30;
        final duration = minutes.minutes;

        expect(duration, const Duration(minutes: minutes));
      });

      test('should create Duration with seconds', () {
        const seconds = 45;
        final duration = seconds.seconds;

        expect(duration, const Duration(seconds: seconds));
      });

      test('should create Duration with milliseconds', () {
        const milliseconds = 100;
        final duration = milliseconds.milliseconds;

        expect(duration, const Duration(milliseconds: milliseconds));
      });

      test('should create Duration with microseconds', () {
        const microseconds = 1000;
        final duration = microseconds.microseconds;

        expect(duration, const Duration(microseconds: microseconds));
      });
    });

    group('Short forms', () {
      test('should create Duration with d (days)', () {
        const days = 7;
        final duration = days.d;

        expect(duration, const Duration(days: days));
      });

      test('should create Duration with h (hours)', () {
        const hours = 12;
        final duration = hours.h;

        expect(duration, const Duration(hours: hours));
      });

      test('should create Duration with min (minutes)', () {
        const minutes = 15;
        final duration = minutes.min;

        expect(duration, const Duration(minutes: minutes));
      });

      test('should create Duration with s (seconds)', () {
        const seconds = 30;
        final duration = seconds.s;

        expect(duration, const Duration(seconds: seconds));
      });

      test('should create Duration with ms (milliseconds)', () {
        const milliseconds = 500;
        final duration = milliseconds.ms;

        expect(duration, const Duration(milliseconds: milliseconds));
      });

      test('should create Duration with us (microseconds)', () {
        const microseconds = 2000;
        final duration = microseconds.us;

        expect(duration, const Duration(microseconds: microseconds));
      });
    });
  });
}
