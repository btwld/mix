import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/extensions/extensions.dart';

void main() {
  group('MixDurationInt', () {
    group('Long form duration methods', () {
      test('days creates correct Duration', () {
        expect(1.days, const Duration(days: 1));
        expect(5.days, const Duration(days: 5));
        expect(0.days, const Duration(days: 0));
        expect(365.days, const Duration(days: 365));
      });

      test('hours creates correct Duration', () {
        expect(1.hours, const Duration(hours: 1));
        expect(24.hours, const Duration(hours: 24));
        expect(0.hours, const Duration(hours: 0));
        expect(48.hours, const Duration(hours: 48));
      });

      test('minutes creates correct Duration', () {
        expect(1.minutes, const Duration(minutes: 1));
        expect(60.minutes, const Duration(minutes: 60));
        expect(0.minutes, const Duration(minutes: 0));
        expect(90.minutes, const Duration(minutes: 90));
      });

      test('seconds creates correct Duration', () {
        expect(1.seconds, const Duration(seconds: 1));
        expect(60.seconds, const Duration(seconds: 60));
        expect(0.seconds, const Duration(seconds: 0));
        expect(3600.seconds, const Duration(seconds: 3600));
      });

      test('milliseconds creates correct Duration', () {
        expect(1.milliseconds, const Duration(milliseconds: 1));
        expect(1000.milliseconds, const Duration(milliseconds: 1000));
        expect(0.milliseconds, const Duration(milliseconds: 0));
        expect(500.milliseconds, const Duration(milliseconds: 500));
      });

      test('microseconds creates correct Duration', () {
        expect(1.microseconds, const Duration(microseconds: 1));
        expect(1000000.microseconds, const Duration(microseconds: 1000000));
        expect(0.microseconds, const Duration(microseconds: 0));
        expect(500000.microseconds, const Duration(microseconds: 500000));
      });
    });

    group('Short form duration methods', () {
      test('d creates correct Duration (days)', () {
        expect(1.d, const Duration(days: 1));
        expect(7.d, const Duration(days: 7));
        expect(0.d, const Duration(days: 0));

        // Verify it's equivalent to long form
        expect(5.d, equals(5.days));
      });

      test('h creates correct Duration (hours)', () {
        expect(1.h, const Duration(hours: 1));
        expect(12.h, const Duration(hours: 12));
        expect(0.h, const Duration(hours: 0));

        // Verify it's equivalent to long form
        expect(8.h, equals(8.hours));
      });

      test('min creates correct Duration (minutes)', () {
        expect(1.min, const Duration(minutes: 1));
        expect(30.min, const Duration(minutes: 30));
        expect(0.min, const Duration(minutes: 0));

        // Verify it's equivalent to long form
        expect(45.min, equals(45.minutes));
      });

      test('s creates correct Duration (seconds)', () {
        expect(1.s, const Duration(seconds: 1));
        expect(30.s, const Duration(seconds: 30));
        expect(0.s, const Duration(seconds: 0));

        // Verify it's equivalent to long form
        expect(15.s, equals(15.seconds));
      });

      test('ms creates correct Duration (milliseconds)', () {
        expect(1.ms, const Duration(milliseconds: 1));
        expect(250.ms, const Duration(milliseconds: 250));
        expect(0.ms, const Duration(milliseconds: 0));

        // Verify it's equivalent to long form
        expect(100.ms, equals(100.milliseconds));
      });

      test('us creates correct Duration (microseconds)', () {
        expect(1.us, const Duration(microseconds: 1));
        expect(500.us, const Duration(microseconds: 500));
        expect(0.us, const Duration(microseconds: 0));

        // Verify it's equivalent to long form
        expect(750.us, equals(750.microseconds));
      });
    });

    group('Duration arithmetic and comparisons', () {
      test('durations add correctly', () {
        final duration1 = 1.hours + 30.minutes;
        const duration2 = Duration(hours: 1, minutes: 30);
        expect(duration1, equals(duration2));

        final duration3 = 2.days + 3.hours + 45.minutes + 30.seconds;
        const duration4 = Duration(days: 2, hours: 3, minutes: 45, seconds: 30);
        expect(duration3, equals(duration4));
      });

      test('durations compare correctly', () {
        expect(1.hours, greaterThan(30.minutes));
        expect(1.days, greaterThan(23.hours));
        expect(1000.milliseconds, equals(1.seconds));
        expect(1000000.microseconds, equals(1.seconds));
        expect(60.seconds, equals(1.minutes));
        expect(60.minutes, equals(1.hours));
        expect(24.hours, equals(1.days));
      });

      test('zero durations are equal', () {
        expect(0.days, equals(0.hours));
        expect(0.minutes, equals(0.seconds));
        expect(0.milliseconds, equals(0.microseconds));
        expect(0.d, equals(0.ms));
      });
    });

    group('Real-world usage patterns', () {
      test('animation durations', () {
        final fastAnimation = 200.ms;
        final mediumAnimation = 300.ms;
        final slowAnimation = 500.ms;

        expect(fastAnimation, const Duration(milliseconds: 200));
        expect(mediumAnimation, const Duration(milliseconds: 300));
        expect(slowAnimation, const Duration(milliseconds: 500));

        expect(fastAnimation, lessThan(mediumAnimation));
        expect(mediumAnimation, lessThan(slowAnimation));
      });

      test('timeout durations', () {
        final shortTimeout = 5.s;
        final mediumTimeout = 30.s;
        final longTimeout = 2.min;

        expect(shortTimeout, const Duration(seconds: 5));
        expect(mediumTimeout, const Duration(seconds: 30));
        expect(longTimeout, const Duration(minutes: 2));

        expect(shortTimeout, lessThan(mediumTimeout));
        expect(mediumTimeout, lessThan(longTimeout));
      });

      test('cache expiration times', () {
        final hourlyCache = 1.h;
        final dailyCache = 1.d;
        final weeklyCache = 7.d;

        expect(hourlyCache, const Duration(hours: 1));
        expect(dailyCache, const Duration(days: 1));
        expect(weeklyCache, const Duration(days: 7));

        expect(hourlyCache, lessThan(dailyCache));
        expect(dailyCache, lessThan(weeklyCache));
      });

      test('mixed unit expressions', () {
        final complexDuration = 1.h + 30.min + 45.s + 500.ms;
        const expected = Duration(
          hours: 1,
          minutes: 30,
          seconds: 45,
          milliseconds: 500,
        );
        expect(complexDuration, equals(expected));

        // Test with short forms
        final complexDurationShort = 2.d + 12.h + 30.min;
        const expectedShort = Duration(days: 2, hours: 12, minutes: 30);
        expect(complexDurationShort, equals(expectedShort));
      });
    });

    group('Edge cases', () {
      test('negative values work correctly', () {
        expect((-1).days, const Duration(days: -1));
        expect((-30).minutes, const Duration(minutes: -30));
        expect((-500).ms, const Duration(milliseconds: -500));
      });

      test('large values work correctly', () {
        expect(999999.days, const Duration(days: 999999));
        expect(999999.microseconds, const Duration(microseconds: 999999));
      });

      test('duration properties are accessible', () {
        final duration = 1.d + 2.h + 3.min + 4.s + 5.ms + 6.us;

        expect(duration.inDays, equals(1));
        expect(duration.inHours, equals(26)); // 1 day + 2 hours
        expect(duration.inMinutes, equals(1563)); // 26 hours * 60 + 3 minutes
        expect(duration.inSeconds, greaterThan(90000)); // Many seconds
        expect(
          duration.inMilliseconds,
          greaterThan(90000000),
        ); // Many milliseconds
        expect(
          duration.inMicroseconds,
          greaterThan(90000000000),
        ); // Many microseconds
      });
    });
  });
}
