final class BenchmarkFrameClock {
  BenchmarkFrameClock({
    this.frameInterval = const Duration(microseconds: 16667),
  });

  final Duration frameInterval;
  Duration _timestamp = Duration.zero;

  Duration next() {
    _timestamp += frameInterval;
    return _timestamp;
  }
}
