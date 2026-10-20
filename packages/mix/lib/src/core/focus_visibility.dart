import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether focused widgets should show a focus indicator.
///
/// A pointer press hides the indicator until the next keyboard input. Lone
/// modifier and lock keys do not count, nor do Control, Meta, Super, or Hyper
/// shortcuts, nor Alt shortcuts outside macOS. Key repeat does. Focus moved in
/// code keeps the current visibility.
///
/// This follows the pointer and keyboard part of CSS `:focus-visible`. It does
/// not copy the text-input exception: a text field focused by a pointer does
/// not show an indicator. Style any focus, including that case, with
/// `onFocused`.
///
/// [FocusHighlightStrategy.alwaysTraditional] always shows indicators, and
/// [FocusHighlightStrategy.alwaysTouch] never does. A [FocusHighlightStrategy]
/// change that leaves [FocusManager.highlightMode] unchanged applies on the
/// next rebuild.
///
/// Call [ensureInitialized] after [WidgetsFlutterBinding.ensureInitialized],
/// or before mounting UI that is not built with Mix, so a pointer press before
/// the first [FocusVisibilityScope] or [isVisible] read is recorded.
abstract final class FocusVisibility {
  /// Starts pointer and keyboard tracking immediately.
  ///
  /// Call this after [WidgetsFlutterBinding.ensureInitialized], or before
  /// mounting non-Mix UI. Tracking then starts before the first
  /// [FocusVisibilityScope] or [isVisible] read, so a pointer press in between
  /// is not missed. Calling it again restores keyboard tracking after
  /// [HardwareKeyboard.clearState], which drops key handlers. Safe to call
  /// more than once.
  static void ensureInitialized() =>
      _FocusVisibilityTracker.current._ensureKeyHandler();

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
final class FocusVisibilityScope extends InheritedNotifier<Listenable> {
  /// Creates a scope for [child].
  FocusVisibilityScope({super.key, required super.child})
    : super(notifier: _FocusVisibilityTracker.current);
}

// One tracker per FocusManager. Tests replace the manager between runs.
final class _FocusVisibilityTracker extends ChangeNotifier {
  static final _trackers = Expando<_FocusVisibilityTracker>();
  static var _pointerRouteInstalled = false;

  // Control, Meta, Super, and Hyper are excluded by the pressed-key checks.
  static final _modifierKeys = <LogicalKeyboardKey>{
    .altGraph,
    .altLeft,
    .altRight,
    .capsLock,
    .fn,
    .fnLock,
    .hyper,
    .numLock,
    .scrollLock,
    .shiftLeft,
    .shiftRight,
    .superKey,
    .symbol,
    .symbolLock,
  };

  final FocusManager _focusManager;
  bool _pointerSinceKeyboard = false;
  late final KeyEventCallback _onKeyEvent = _handleKeyEvent;

  _FocusVisibilityTracker._(this._focusManager) {
    _focusManager.addHighlightModeListener(_handleHighlightModeChange);
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  static void _ensurePointerRoute() {
    if (_pointerRouteInstalled) return;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    _pointerRouteInstalled = true;
  }

  static void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) current._setPointerSinceKeyboard(true);
  }

  static bool _isKeyboardInput(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;
    if (_modifierKeys.contains(event.logicalKey)) return false;

    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isLogicalKeyPressed(.superKey) ||
        keyboard.isLogicalKeyPressed(.hyper)) {
      return false;
    }

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

  void _ensureKeyHandler() {
    HardwareKeyboard.instance
      ..removeHandler(_onKeyEvent)
      ..addHandler(_onKeyEvent);
  }

  // A pointer press in automatic mode already hid the indicator. A later
  // touch leaves it hidden, so that mode change has nothing to repaint.
  void _handleHighlightModeChange(FocusHighlightMode _) {
    if (!_pointerSinceKeyboard ||
        _focusManager.highlightStrategy != .automatic) {
      notifyListeners();
    }
  }

  void _setPointerSinceKeyboard(bool value) {
    if (_pointerSinceKeyboard == value) return;
    _pointerSinceKeyboard = value;
    // The flag only changes visibility in automatic traditional mode.
    if (_focusManager.highlightMode == .traditional &&
        _focusManager.highlightStrategy == .automatic) {
      notifyListeners();
    }
  }

  static _FocusVisibilityTracker get current {
    _ensurePointerRoute();
    final manager = FocusManager.instance;

    return _trackers[manager] ??= _FocusVisibilityTracker._(manager);
  }

  bool get isVisible =>
      _focusManager.highlightMode == .traditional &&
      (!_pointerSinceKeyboard ||
          _focusManager.highlightStrategy == .alwaysTraditional);
}
