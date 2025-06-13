/// Extension on [int] to create [Duration] objects with convenient syntax.
///
/// Example:
/// ```dart
/// final duration1 = 100.ms; // Duration(milliseconds: 100)
/// final duration2 = 5.seconds; // Duration(seconds: 5)
/// final duration3 = 2.hours; // Duration(hours: 2)
/// ```
extension MixDurationInt on int {
  /// Creates a [Duration] with this many days.
  Duration get days => Duration(days: this);

  /// Creates a [Duration] with this many hours.
  Duration get hours => Duration(hours: this);

  /// Creates a [Duration] with this many minutes.
  Duration get minutes => Duration(minutes: this);

  /// Creates a [Duration] with this many seconds.
  Duration get seconds => Duration(seconds: this);

  /// Creates a [Duration] with this many milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Creates a [Duration] with this many microseconds.
  Duration get microseconds => Duration(microseconds: this);

  // Short forms for convenience

  /// Short form for [days].
  Duration get d => Duration(days: this);

  /// Short form for [hours].
  Duration get h => Duration(hours: this);

  /// Short form for [minutes].
  Duration get min => Duration(minutes: this);

  /// Short form for [seconds].
  Duration get s => Duration(seconds: this);

  /// Short form for [milliseconds].
  Duration get ms => Duration(milliseconds: this);

  /// Short form for [microseconds].
  Duration get us => Duration(microseconds: this);
}
