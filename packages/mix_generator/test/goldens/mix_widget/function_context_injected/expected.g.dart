// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class ContextualButton extends StatelessWidget {
  final bool compact;
  final String label;
  final void Function()? onPressed;
  final bool loading;
  final ContextButtonStyle? style;

  const ContextualButton({
    super.key,
    this.compact = false,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = contextualButtonStyle(context, compact: compact);
    final effectiveStyle = baseStyle.merge(style);
    return ContextButton(
      label: label,
      onPressed: onPressed,
      loading: loading,
      key: key,
      style: effectiveStyle,
    );
  }
}
