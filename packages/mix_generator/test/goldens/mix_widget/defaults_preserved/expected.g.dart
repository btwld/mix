// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class DefaultCard extends StatelessWidget {
  const DefaultCard({
    super.key,
    this.compact = false,
    this.padding = 16,
    this.child,
  });

  final bool compact;

  final int padding;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return defaultCardStyle(
      compact: compact,
      padding: padding,
    ).call(key: key, child: child);
  }
}
