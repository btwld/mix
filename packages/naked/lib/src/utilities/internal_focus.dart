import 'package:flutter/widgets.dart';

mixin EffectiveFocusNodeHandler<T extends StatefulWidget> on State<T> {
  FocusNode? get widgetFocusNode;
  FocusNode get effectiveFocusNode => widgetFocusNode ?? FocusNode();

  @override
  void dispose() {
    if (widgetFocusNode == null) {
      effectiveFocusNode.dispose();
    }
    super.dispose();
  }
}
