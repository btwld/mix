import 'package:flutter/widgets.dart';

class PressedStateRegion extends StatelessWidget {
  final bool enabled;
  final void Function(bool)? onPressedState;
  final void Function()? onTap;
  final Widget child;

  const PressedStateRegion({
    super.key,
    required this.child,
    this.onPressedState,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => onPressedState?.call(true) : null,
      onTapUp: enabled ? (_) => onPressedState?.call(false) : null,
      onTapCancel: enabled ? () => onPressedState?.call(false) : null,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }
}
