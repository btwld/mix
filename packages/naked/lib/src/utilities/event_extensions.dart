import 'package:flutter/services.dart';

extension KeyEventExtensions on KeyEvent {
  bool get isSpaceOrEnter =>
      logicalKey == LogicalKeyboardKey.space ||
      logicalKey == LogicalKeyboardKey.enter;

  bool get isDown => this is KeyDownEvent;
  bool get isUp => this is KeyUpEvent;
  bool get isEscape => logicalKey == LogicalKeyboardKey.escape;
}
