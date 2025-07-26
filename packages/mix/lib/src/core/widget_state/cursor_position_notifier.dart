import 'package:flutter/material.dart';
import 'widget_state_provider.dart'; // For PointerPosition

/// Notifier that tracks cursor position with automatic listener detection.
///
/// This notifier automatically optimizes performance by only updating position
/// when there are active listeners. Use [shouldTrack] to determine if position
/// tracking should be enabled.
class CursorPositionNotifier extends ValueNotifier<PointerPosition?> {
  CursorPositionNotifier() : super(null);
  
  /// Whether tracking should be active based on listener presence.
  ///
  /// Returns true if there are widgets listening for position updates.
  /// Use this to conditionally enable expensive mouse tracking operations.
  bool get shouldTrack => hasListeners;
  
  /// Updates position only if listeners exist.
  ///
  /// This method automatically optimizes performance by only updating
  /// the position when widgets are actually listening for changes.
  void updatePosition(Alignment position, Offset offset) {
    if (hasListeners) {
      value = PointerPosition(position: position, offset: offset);
    }
  }
  
  /// Clears the current position.
  void clearPosition() {
    value = null;
  }
}