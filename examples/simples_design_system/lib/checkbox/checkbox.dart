// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'checkbox.spec.dart';

part 'checkbox.style.dart';

typedef CheckboxStyle = SpecStyle<CheckboxSpecUtility>;

class _BaseCheckbox extends StatefulWidget {
  const _BaseCheckbox({
    super.key,
    this.disabled = false,
    this.value = false,
    this.onChanged,
    this.iconChecked = Icons.check_rounded,
    this.iconUnchecked,
    required this.style,
    this.variants = const [],
    this.label,
  });

  /// Whether the checkbox is disabled.
  final bool disabled;

  /// Whether the checkbox is checked.
  final bool value;

  /// The icon to display when the checkbox is checked.
  final IconData iconChecked;

  /// The icon to display when the checkbox is unchecked.
  final IconData? iconUnchecked;

  /// The callback function that is called when the checkbox is tapped.
  final ValueChanged<bool>? onChanged;

  final CheckboxStyle style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// An optional label that will be displayed next to the checkbox.
  final String? label;

  @override
  State<_BaseCheckbox> createState() => _BaseCheckboxState();
}

class _BaseCheckboxState extends State<_BaseCheckbox> {
  late final MixWidgetStateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MixWidgetStateController();
    _controller.selected = widget.value;
    _controller.disabled = widget.disabled;
  }

  void _handleOnPress() => widget.onChanged?.call(!widget.value);

  @override
  void didUpdateWidget(_BaseCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (mounted) {
      if (oldWidget.value != widget.value) {
        _controller.selected = widget.value;
      }

      if (oldWidget.disabled != widget.disabled) {
        _controller.disabled = widget.disabled;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pressable(
      enabled: !widget.disabled,
      onPress: widget.disabled ? null : _handleOnPress,
      controller: _controller,
      child: Builder(builder: (context) {
        final config = SpecConfiguration(context, CheckboxSpecUtility.self);

        return SpecBuilder(
          style: widget.style
              .makeStyle(config)
              .applyVariants(widget.variants)
              .animate(),
          builder: (context) {
            final spec = CheckboxSpec.of(context);

            return spec.container(
              direction: Axis.horizontal,
              children: [
                spec.indicatorContainer(
                  child: spec.indicator(
                    widget.value
                        ? widget.iconChecked
                        : (widget.iconUnchecked ?? widget.iconChecked),
                  ),
                ),
                if (widget.label != null) spec.label(widget.label!),
              ],
            );
          },
        );
      }),
    );
  }
}

class SimpleCheckbox extends _BaseCheckbox {
  const SimpleCheckbox._({
    super.key,
    super.disabled,
    super.value,
    super.onChanged,
    required super.style,
    super.iconChecked,
    super.iconUnchecked,
    super.variants,
    super.label,
  });

  factory SimpleCheckbox({
    Key? key,
    bool disabled = false,
    bool value = false,
    IconData iconChecked = Icons.check_rounded,
    IconData? iconUnchecked,
    ValueChanged<bool>? onChanged,
    List<Variant> variants = const [],
    String? label,
  }) {
    return SimpleCheckbox._(
      key: key,
      disabled: disabled,
      value: value,
      iconChecked: iconChecked,
      iconUnchecked: iconUnchecked,
      onChanged: onChanged,
      style: SimpleCheckboxStyle(),
      variants: variants,
      label: label,
    );
  }
}
