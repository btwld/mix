import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(body: Center(child: Example())),
    ),
  );
}

class CustomInheritedWidget extends InheritedWidget {
  const CustomInheritedWidget({
    super.key,
    required super.child,
    required this.flag,
  });

  static CustomInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  final bool flag;

  @override
  bool updateShouldNotify(covariant CustomInheritedWidget oldWidget) {
    return flag != oldWidget.flag;
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  BoxStyler get box =>
      .new() //
          .color(Colors.red)
          .size(100, 100)
          .variant(
            ContextVariant('custom_flag', (context) {
              final flag = CustomInheritedWidget.of(context)?.flag ?? false;

              return flag;
            }),
            BoxStyler().color(Colors.blue),
          );

  @override
  Widget build(BuildContext context) {
    return CustomInheritedWidget(flag: true, child: box());
  }
}

extension WidgetStateVariantMixinX<T extends Style<S>, S extends Spec<S>>
    on WidgetStateVariantMixin<T, S> {
  T onCustomFlag(T style) {
    return variant(
      ContextVariant('custom_flag', (context) {
        final flag = CustomInheritedWidget.of(context)?.flag ?? false;

        return flag;
      }),
      style,
    );
  }
}
