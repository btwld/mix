/// Extension on [int] to create [Duration] objects with convenient syntax.
///
/// Example:
/// ```dart
/// final duration1 = 100.ms; // Duration(milliseconds: 100)
/// final duration2 = 5.seconds; // Duration(seconds: 5)
/// final duration3 = 2.hours; // Duration(hours: 2)
/// ```
extension DurationIntExt on int {
  /// Creates a [Duration] with this many days.
  Duration get days => .new(days: this);

  /// Creates a [Duration] with this many hours.
  Duration get hours => .new(hours: this);

  /// Creates a [Duration] with this many minutes.
  Duration get minutes => .new(minutes: this);

  /// Creates a [Duration] with this many seconds.
  Duration get seconds => .new(seconds: this);

  /// Creates a [Duration] with this many milliseconds.
  Duration get milliseconds => .new(milliseconds: this);

  /// Creates a [Duration] with this many microseconds.
  Duration get microseconds => .new(microseconds: this);

  // Short forms for convenience

  /// Short form for [days].
  Duration get d => .new(days: this);

  /// Short form for [hours].
  Duration get h => .new(hours: this);

  /// Short form for [minutes].
  Duration get min => .new(minutes: this);

  /// Short form for [seconds].
  Duration get s => .new(seconds: this);

  /// Short form for [milliseconds].
  Duration get ms => .new(milliseconds: this);

  /// Short form for [microseconds].
  Duration get us => .new(microseconds: this);
}
