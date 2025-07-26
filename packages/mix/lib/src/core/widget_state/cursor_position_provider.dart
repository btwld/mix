import 'package:flutter/widgets.dart';

import 'cursor_position_notifier.dart';

// Export the private provider for internal use only
export 'cursor_position_notifier.dart' show CursorPositionNotifier;

/// Internal provider for cursor position tracking.
///
/// This provider is an implementation detail and should not be used directly.
/// Instead, use [PointerPosition.of] to access cursor position from widgets.
class CursorPositionProvider extends InheritedNotifier<CursorPositionNotifier> {
  const CursorPositionProvider({
    super.key,
    required CursorPositionNotifier super.notifier,
    required super.child,
  });
}
