import 'package:flutter/foundation.dart';

import '../animation_config.dart';

/// Implemented by the configs that [AnimationConfig.reversible] returns.
///
/// They stay curve or spring configs to every public API. The style animator
/// reads the original [forward] and [reverse] instances through this
/// interface, so a subclass passed to the factory keeps its own behavior.
@internal
abstract interface class ReversibleAnimation {
  /// Enter timing, exactly as passed to [AnimationConfig.reversible].
  AnimationConfig get forward;

  /// Exit timing, exactly as passed to [AnimationConfig.reversible].
  AnimationConfig get reverse;
}
