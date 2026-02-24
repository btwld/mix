import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../../helpers.dart';

void main() {
  runMixApp(Example());
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class ShiftPressedInheritedWidget extends InheritedWidget {
  const ShiftPressedInheritedWidget({
    super.key,
    required this.isShiftPressed,
    required super.child,
  });

  static ShiftPressedInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  final bool isShiftPressed;

  @override
  bool updateShouldNotify(ShiftPressedInheritedWidget oldWidget) {
    return isShiftPressed != oldWidget.isShiftPressed;
  }
}

class PressedShiftContextVariant extends ContextVariant {
  PressedShiftContextVariant()
    : super('pressed_shift', (context) {
        return ShiftPressedInheritedWidget.of(context)?.isShiftPressed ?? false;
      });
}

class _ExampleState extends State<Example> {
  bool isShiftPressed = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.shift) return false;

    setState(() {
      isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    });

    return true;
  }

  @override
  void dispose() {
    focusNode.dispose();
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShiftPressedInheritedWidget(
        isShiftPressed: isShiftPressed,
        child: Badge(),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  const Badge({super.key});

  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .shapeStadium(side: .new().color(Colors.blueGrey.shade200))
        .color(Colors.blueGrey.shade50)
        .padding(.horizontal(8).vertical(4))
        .wrap(
          .new()
              .defaultText(
                .new() //
                    .fontSize(14)
                    .color(Colors.blueGrey.shade600),
              )
              .scale(1, 1),
        )
        .variant(
          PressedShiftContextVariant(),
          BoxStyler()
              .color(Colors.deepPurpleAccent.shade100)
              .shapeStadium(
                side: .new().color(Colors.deepPurpleAccent.shade700),
              )
              .wrap(
                .new()
                    .defaultText(.new().color(Colors.deepPurpleAccent.shade700))
                    .scale(0.8, 0.8),
              ),
        )
        .animate(.ease(300.ms));

    return Box(style: style, child: StyledText('Press shift'));
  }
}
