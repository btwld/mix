// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class ContextualButton extends StatelessWidget {
  const ContextualButton({
    super.key,
    this.compact = false,
    this.style,
    this.child,
  });

  final bool compact;

  final ContextButtonStyle? style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Box(
      key: key,
      style: contextualButtonStyle(context, compact: compact, style: style),
      child: child,
    );
  }
}
