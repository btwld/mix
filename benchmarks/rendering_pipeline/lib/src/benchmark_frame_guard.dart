import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Gives manual `pumpBenchmark` calls exclusive ownership of frame delivery.
final class BenchmarkFrameGuard {
  BenchmarkFrameGuard._({
    required LiveTestWidgetsFlutterBinding binding,
    required LiveTestWidgetsFlutterBindingFramePolicy originalFramePolicy,
    required ui.FrameCallback? originalOnBeginFrame,
    required ui.VoidCallback? originalOnDrawFrame,
  }) : _binding = binding,
       _originalFramePolicy = originalFramePolicy,
       _originalOnBeginFrame = originalOnBeginFrame,
       _originalOnDrawFrame = originalOnDrawFrame;

  final LiveTestWidgetsFlutterBinding _binding;
  final LiveTestWidgetsFlutterBindingFramePolicy _originalFramePolicy;
  final ui.FrameCallback? _originalOnBeginFrame;
  final ui.VoidCallback? _originalOnDrawFrame;
  var _isDisposed = false;

  static BenchmarkFrameGuard enter(LiveTestWidgetsFlutterBinding binding) {
    final platformDispatcher = binding.platformDispatcher;
    final guard = BenchmarkFrameGuard._(
      binding: binding,
      originalFramePolicy: binding.framePolicy,
      originalOnBeginFrame: platformDispatcher.onBeginFrame,
      originalOnDrawFrame: platformDispatcher.onDrawFrame,
    );

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmark;
    // Benchmark policy prevents new framework requests, but cannot cancel a
    // vsync already accepted by the engine. Detaching these callbacks prevents
    // that vsync from splitting a manually pumped begin/draw pair.
    platformDispatcher
      ..onBeginFrame = null
      ..onDrawFrame = null;

    return guard;
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    _binding.platformDispatcher
      ..onBeginFrame = _originalOnBeginFrame
      ..onDrawFrame = _originalOnDrawFrame;
    _binding.framePolicy = _originalFramePolicy;
  }
}
