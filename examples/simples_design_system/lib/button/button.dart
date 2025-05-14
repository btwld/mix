import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'button.spec.dart';

part 'button.style.dart';

typedef ButtonStyle = SpecStyle<ButtonSpecUtility>;

abstract class _BaseButton extends StatefulWidget {
  const _BaseButton({
    required this.label,
    this.disabled = false,
    this.loading = false,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    required this.onPressed,
    required this.style,
  });

  /// The text content displayed in the center of the button.
  final String label;

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// {@macro remix.component.loading}
  final bool loading;

  /// The icon displayed in the left side of the button.
  final IconData? iconLeft;

  /// The icon displayed in the right side of the button.
  final IconData? iconRight;

  /// {@macro remix.component.onPressed}
  final VoidCallback? onPressed;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final ButtonStyle style;

  @override
  State<_BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<_BaseButton> {
  late final MixWidgetStateController controller;
  late final isDisabled = widget.disabled || widget.loading;

  @override
  void initState() {
    super.initState();

    controller = MixWidgetStateController()..disabled = isDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: !isDisabled,
      controller: controller,
      onPress: widget.disabled || widget.loading ? null : widget.onPressed,
      child: Builder(builder: (context) {
        final config = SpecConfiguration(context, ButtonSpecUtility.self);

        return SpecBuilder(
          style: widget.style.makeStyle(config).applyVariants(widget.variants),
          builder: (context) {
            final spec = ButtonSpec.of(context);

            return spec.container(
              direction: Axis.horizontal,
              children: [
                if (widget.iconLeft != null) spec.icon(widget.iconLeft),
                spec.label(widget.label),
                if (widget.iconRight != null) spec.icon(widget.iconRight),
              ],
            );
          },
        );
      }),
    );
  }
}

class SimplePrimaryButton extends _BaseButton {
  const SimplePrimaryButton._({
    required super.label,
    super.disabled,
    super.loading,
    super.iconLeft,
    super.iconRight,
    super.variants,
    super.onPressed,
    required super.style,
  });

  factory SimplePrimaryButton({
    required String label,
    bool disabled = false,
    bool loading = false,
    IconData? iconLeft,
    IconData? iconRight,
    VoidCallback? onPressed,
    ButtonSizeVariant size = ButtonSizeVariant.md,
  }) {
    return SimplePrimaryButton._(
      label: label,
      disabled: disabled,
      loading: loading,
      iconLeft: iconLeft,
      iconRight: iconRight,
      variants: [size.value, _primary],
      onPressed: onPressed,
      style: SimpleButtonStyle(),
    );
  }
}

class SimpleSecondaryButton extends _BaseButton {
  const SimpleSecondaryButton._({
    required super.label,
    super.disabled,
    super.loading,
    super.iconLeft,
    super.iconRight,
    super.variants,
    super.onPressed,
    required super.style,
  });

  factory SimpleSecondaryButton({
    required String label,
    bool disabled = false,
    bool loading = false,
    IconData? iconLeft,
    IconData? iconRight,
    VoidCallback? onPressed,
    ButtonSizeVariant size = ButtonSizeVariant.md,
  }) {
    return SimpleSecondaryButton._(
      label: label,
      disabled: disabled,
      loading: loading,
      iconLeft: iconLeft,
      iconRight: iconRight,
      variants: [size.value, _secondary],
      onPressed: onPressed,
      style: SimpleButtonStyle(),
    );
  }
}

class SimpleDestructiveButton extends _BaseButton {
  const SimpleDestructiveButton._({
    required super.label,
    super.disabled,
    super.loading,
    super.iconLeft,
    super.iconRight,
    super.variants,
    super.onPressed,
    required super.style,
  });

  factory SimpleDestructiveButton({
    required String label,
    bool disabled = false,
    bool loading = false,
    IconData? iconLeft,
    IconData? iconRight,
    VoidCallback? onPressed,
    ButtonSizeVariant size = ButtonSizeVariant.md,
  }) {
    return SimpleDestructiveButton._(
      label: label,
      disabled: disabled,
      loading: loading,
      iconLeft: iconLeft,
      iconRight: iconRight,
      variants: [size.value, _destructive],
      onPressed: onPressed,
      style: SimpleButtonStyle(),
    );
  }
}
