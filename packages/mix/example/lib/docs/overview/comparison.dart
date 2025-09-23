import '../../helpers.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runMixApp(
    const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [CustomMixWidget(), CustomWidget()],
    ),
  );
}

class CustomMixWidget extends StatelessWidget {
  const CustomMixWidget({super.key});

  TextStyler get customTextStyle {
    return TextStyler()
        .fontSize(16)
        .fontWeight(FontWeight.w600)
        .color(Colors.white)
        .animate(AnimationConfig.easeInOut(100.ms))
        .onDark(TextStyler().color(Colors.black))
        .onHovered(
          TextStyler()
              .animate(AnimationConfig.easeInOut(100.ms))
              .color(Colors.grey.shade700)
              .onLight(TextStyler().color(Colors.white)),
        );
  }

  BoxStyler get customBoxStyle {
    return BoxStyler()
        .height(120)
        .width(120)
        .paddingAll(20)
        .elevation(ElevationShadow.nine)
        .alignment(Alignment.center)
        .borderRounded(10)
        .color(Colors.blue)
        .scale(1.0)
        .animate(AnimationConfig.easeInOut(100.ms))
        .onDark(BoxStyler().color(Colors.cyan))
        .onHovered(
          BoxStyler()
              .alignment(Alignment.topLeft)
              .elevation(ElevationShadow.two)
              .paddingAll(10)
              .scale(1.5)
              .animate(AnimationConfig.easeInOut(100.ms))
              .color(Colors.cyan.shade300)
              .onLight(BoxStyler().color(Colors.blue.shade300)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: () {},
      child: Box(
        style: customBoxStyle,
        child: StyledText('Custom Widget', style: customTextStyle),
      ),
    );
  }
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({super.key});

  @override
  CustomWidgetState createState() => CustomWidgetState();
}

class CustomWidgetState extends State<CustomWidget> {
  bool _isHover = false;

  final _curve = Curves.linear;
  final _duration = const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final backgroundColor = isDark ? Colors.cyan : Colors.blue;
    final textColor = isDark ? Colors.black : Colors.white;
    final borderRadius = BorderRadius.circular(10);

    final onHoverTextColor = isDark
        ? Colors.grey.shade700
        : Colors.grey.shade200;

    final onHoverBgColor = isDark ? Colors.cyan.shade300 : Colors.blue.shade300;

    return MouseRegion(
      onEnter: (event) {
        setState(() => _isHover = true);
      },
      onExit: (event) {
        setState(() => _isHover = false);
      },
      child: Material(
        elevation: _isHover ? 2 : 9,
        borderRadius: borderRadius,
        child: AnimatedScale(
          scale: _isHover ? 1.5 : 1,
          curve: _curve,
          duration: _duration,
          child: AnimatedContainer(
            padding: _isHover
                ? const EdgeInsets.all(10)
                : const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isHover ? onHoverBgColor : backgroundColor,
              borderRadius: borderRadius,
            ),
            width: 120,
            height: 120,
            curve: _curve,
            duration: _duration,
            child: AnimatedAlign(
              alignment: _isHover ? Alignment.topLeft : Alignment.center,
              curve: _curve,
              duration: _duration,
              child: Text(
                'Custom Widget',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _isHover ? onHoverTextColor : textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
