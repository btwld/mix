import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether focused widgets should show a focus indicator, following the CSS
/// `:focus-visible` heuristics.
///
/// [FocusManager.highlightMode] ignores mouse and trackpad input. Here, a
/// pointer press of any kind also hides focus indicators, until the next
/// keyboard input. Lone modifier keys and Control or Meta shortcuts do not
/// count as keyboard input, nor do Alt shortcuts outside macOS. Focus moved in
/// code keeps the current visibility. Text inputs usually style any focus
/// instead, as Radix and React Aria do.
///
/// [FocusHighlightStrategy.alwaysTraditional] always shows focus indicators,
/// and [FocusHighlightStrategy.alwaysTouch] never does.
abstract final class FocusVisibility {
  /// Returns [isVisible], rebuilding [context] when it changes inside a
  /// [FocusVisibilityScope].
  static bool of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<FocusVisibilityScope>();

    return isVisible;
  }

  /// Whether a focused widget should currently show its focus indicator.
  static bool get isVisible => _FocusVisibilityTracker.current.isVisible;
}

/// Rebuilds descendants that call [FocusVisibility.of] when focus visibility
/// changes.
///
/// Pressable and styled widgets driven by a [WidgetStatesController] provide
/// one. Mount it above a manually mounted widget-state scope so
/// `onFocusVisible` styles beneath it update on input changes. A
/// [FocusHighlightStrategy] change that leaves [FocusManager.highlightMode]
/// unchanged applies on the next rebuild.
class FocusVisibilityScope extends InheritedNotifier<Listenable> {
  /// Creates a scope for [child].
  FocusVisibilityScope({super.key, required super.child})
    : super(notifier: _FocusVisibilityTracker.current);
}

// One tracker per FocusManager, since tests replace the manager and clear
// HardwareKeyboard handlers between runs.
final class _FocusVisibilityTracker extends ChangeNotifier {
  static final _trackers = Expando<_FocusVisibilityTracker>();
  static var _pointerRouteInstalled = false;

  // Control and Meta are excluded by the pressed-key checks.
  static final _modifierKeys = {
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.fn,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  };

  final FocusManager _focusManager;
  bool _pointerSinceKeyboard = false;

  _FocusVisibilityTracker._(this._focusManager) {
    _focusManager.addHighlightModeListener(_handleHighlightModeChange);
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  static void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) current._setPointerSinceKeyboard(true);
  }

  static bool _isKeyboardInput(KeyEvent event) {
    if (event is! KeyDownEvent || _modifierKeys.contains(event.logicalKey)) {
      return false;
    }
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed || keyboard.isMetaPressed) return false;

    // Option composes characters on macOS; elsewhere Alt starts a shortcut.
    return !keyboard.isAltPressed || defaultTargetPlatform == .macOS;
  }

  // Android soft-keyboard events also land here, but FocusManager keeps
  // highlightMode in touch mode for them, so isVisible stays false.
  bool _handleKeyEvent(KeyEvent event) {
    if (_pointerSinceKeyboard && _isKeyboardInput(event)) {
      _setPointerSinceKeyboard(false);
    }

    return false;
  }

  void _handleHighlightModeChange(FocusHighlightMode _) => notifyListeners();

  void _setPointerSinceKeyboard(bool value) {
    if (_pointerSinceKeyboard == value) return;
    _pointerSinceKeyboard = value;
    notifyListeners();
  }

  static _FocusVisibilityTracker get current {
    if (!_pointerRouteInstalled) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
      _pointerRouteInstalled = true;
    }
    final manager = FocusManager.instance;

    return _trackers[manager] ??= _FocusVisibilityTracker._(manager);
  }

  bool get isVisible =>
      _focusManager.highlightMode == .traditional &&
      (!_pointerSinceKeyboard ||
          _focusManager.highlightStrategy == .alwaysTraditional);
}
