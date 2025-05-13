import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

extension KeyEventExtensions on KeyEvent {
  bool get isSpaceOrEnter =>
      logicalKey == LogicalKeyboardKey.space ||
      logicalKey == LogicalKeyboardKey.enter;

  bool get isDown => this is KeyDownEvent;
  bool get isUp => this is KeyUpEvent;
  bool get isEscape => logicalKey == LogicalKeyboardKey.escape;
}

mixin KeyboardActionHandler {
  ValueChanged<bool>? get onPressedState;
  VoidCallback get onkeyAction;

  KeyEventResult handleOnKeyEvent(FocusNode focusNode, KeyEvent event) {
    if (event.isDown && event.isSpaceOrEnter) {
      onPressedState?.call(true);

      return KeyEventResult.handled;
    } else if (event.isUp && event.isSpaceOrEnter) {
      onPressedState?.call(false);
      onkeyAction.call();

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
