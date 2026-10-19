import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether focused widgets should show a focus indicator, following the CSS
/// `:focus-visible` heuristics.
///
/// This refines [FocusManager.highlightMode], which ignores mouse and
/// trackpad input: a pointer press of any kind hides focus indicators until
/// the next keyboard input. Lone modifier keys and Control or Meta shortcuts
/// do not count as keyboard input, nor do Alt shortcuts outside macOS. Focus
/// moved in code keeps the current visibility. As in browsers, focus in an
/// editable text field stays visible after a pointer press.
///
/// [FocusHighlightStrategy.alwaysTraditional] always shows focus indicators,
/// and [FocusHighlightStrategy.alwaysTouch] never does. A strategy change
/// that leaves [FocusManager.highlightMode] unchanged applies on the next
/// rebuild.
abstract final class FocusVisibility {
  /// Whether a focused widget should currently show its focus indicator.
  static bool get isVisible => _FocusVisibilityTracker.current.isVisible;

  /// Notifies listeners when [isVisible] may have changed.
  static Listenable get listenable => _FocusVisibilityTracker.current;
}

final class _FocusVisibilityTracker extends ChangeNotifier {
  // One tracker per FocusManager, so state follows the manager's lifetime.
  static final _trackers = Expando<_FocusVisibilityTracker>();
  static var _routeInstalled = false;

  static final _modifierKeys = {
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.fn,
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  };

  final FocusManager _focusManager;
  bool _pointerSinceKeyboard = false;

  _FocusVisibilityTracker._(this._focusManager) {
    _focusManager
      ..addEarlyKeyEventHandler(_handleKeyEvent)
      ..addHighlightModeListener(_handleHighlightModeChange);
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

  // FocusManager runs early handlers after updating highlightMode, which
  // already ignores Android soft-keyboard events.
  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (_isKeyboardInput(event)) _setPointerSinceKeyboard(false);

    return .ignored;
  }

  void _handleHighlightModeChange(FocusHighlightMode _) => notifyListeners();

  void _setPointerSinceKeyboard(bool value) {
    if (_pointerSinceKeyboard == value) return;
    _pointerSinceKeyboard = value;
    notifyListeners();
  }

  bool get _editableTextHasFocus {
    final context = _focusManager.primaryFocus?.context;
    if (context == null || !context.mounted) return false;
    final editable = context.findAncestorStateOfType<EditableTextState>();

    return editable != null && !editable.widget.readOnly;
  }

  static _FocusVisibilityTracker get current {
    if (!_routeInstalled) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
      _routeInstalled = true;
    }
    final manager = FocusManager.instance;

    return _trackers[manager] ??= _FocusVisibilityTracker._(manager);
  }

  bool get isVisible {
    final traditional = _focusManager.highlightMode == .traditional;

    if (_focusManager.highlightStrategy != .automatic) {
      return traditional;
    }

    return traditional && (!_pointerSinceKeyboard || _editableTextHasFocus);
  }
}
